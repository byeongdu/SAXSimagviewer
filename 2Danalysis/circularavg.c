#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

# include "mex.h"
# include "math.h"
# define MAX_Array_SIZE 5000

int findmax(int *edge){
    int k;
    int d;
    d = 0;
    for (k=0;k<4;k++)
	{
        if (d < *(edge + k))
            d = *(edge + k);
	}
    return d;
}

int findmin(int *edge){
    int k;
    int d;
    d = MAX_Array_SIZE;
    for (k=0;k<4;k++)
	{
        if (d > *(edge + k))
            d = *(edge + k);
	}
    return d;
}

double dist(int x1, int y1, double x2, double y2)
{
    double z;
    z = (double) sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2));
    return z;
}

double azimang(int Y, int X, double Yc, double Xc)
{
double dx, dy;
double theta = 0;
double pi = 3.141592;

dx = (double) X-Xc;
dy = (double) Y-Yc;
if (dx>0) {
    if (dy >= 0) theta = atan(dy/dx)*180/pi;
    if (dy < 0) theta = 360 + atan(dy/dx)*180/pi;
}
if (dx<0) theta = atan(dy/dx)*180/pi + 180;
if (dx == 0) {
    if (dy > 0)	theta = 90;
    if (dy <= 0) theta = 270;
    }
return theta;
}

int inMarcircle(double dimx, double dimy, double R, int X, int Y)
{
int retval = 1;
double R1 = 0.0;
if (R<1)
    return 1;
R1 = sqrt((dimx/2.0-X)*(dimx/2.0-X) + (dimy/2.0-Y)*(dimy/2.0-Y));
if (R1 > R) retval = 0;
return retval;
}

int validatedata(double mask, double data, double maxlimit, double minlimit)
{
int retval = 0;
if (mask > 0) if ((data > minlimit) & (data < maxlimit)) retval = 1;
return retval;
}

void mexFunction (int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{ 
    /* circularavg(image, offset, [beamX, beamY], [maxlimit, minlimit], [mu_start, mu_end], mask, Qoption, [Qmax, Qnum], waveln, psize, SDD);
    // default: maxlimit = 2^16, minlimit = -2^16
    //          azimthalangle = []
    //          mask =[];
    //          Qoption = 0 // pixel based calculation
    //          Qscale = [Qmax, number of Q] -- largest Q, and number of Q....
     */
    
	/*mxArray *img_, *bxy_, *scale_, *mu_, *mask_, Qscale_;*/
    double *img, *bxy, *scale, *mu, *mask, *Qscale;
    double offset, Qoption, waveln, psize, SDD;
    int CCDradius, dezinger;
    double *data;
    int row, col;
    double pi = 3.141592;
    int rowmask;
    int colmask;
    int isMask = 0;
    int isSectoravg = 0;
    int rowtheta = 0;
    int coltheta = 0;

    const int DEF_MAXL = 2^32;
    const int DEF_MINL = 0;
    double maxlimit = 65536;
    double minlimit = 0;
    double maskdata = 0.0;
    int muNumber = 0;
    double cent_X = 0;
    double cent_Y = 0;
    int edge[4];
    int d = 0, k=0;
    double qval, qmax;
    int qN, MAXSIZE;
    double dx2, dy2;
    double dezingtimes;
    long indimg;
    double Lp;
    double solidanglecorrection;
    
    int r2;
    int i, j, m;
    int isvalid, isvalid1, isvalid2, isvalid3;
    double imgv=0.0;
    double maskv=0.0;
    double qv[MAX_Array_SIZE];
    double avg[MAX_Array_SIZE];
    double npx[MAX_Array_SIZE];
    double avg2[MAX_Array_SIZE];
    double azim=0.0;
    
    int inSector;
    
	if (nrhs != 14) {
        mexPrintf("%i\n", nrhs);
	    mexErrMsgTxt("13 inputs, image, offset, [beamX, beamY], [highL, lowL], [mu_S, mu_E], and mask, Qoption, Qscale, waveln, psize, SDD, CCDradius, deZinger are required.");
    }
	if (nlhs != 1)
	    mexErrMsgTxt("1 output is required.");
	/*img_ = prhs[0];
    bxy_ = prhs[2];
    scale_ = prhs[3];
    mu_ = prhs[4];
    mask_ = prhs[5];
    Qscale_ = prhs[7];*/
    
	img = mxGetPr(prhs[0]);
	bxy = mxGetPr(prhs[2]);
	scale = mxGetPr(prhs[3]);
	mu = mxGetPr(prhs[4]);
	mask = mxGetPr(prhs[5]);
	Qscale = mxGetPr(prhs[7]);
	offset = mxGetScalar(prhs[1]);
	Qoption = mxGetScalar(prhs[6]);
    waveln = mxGetScalar(prhs[8]);
    psize = mxGetScalar(prhs[9]);
    SDD = mxGetScalar(prhs[10]); 
    CCDradius = mxGetScalar(prhs[11]); 
    dezinger = mxGetScalar(prhs[12]); 
    dezingtimes = mxGetScalar(prhs[13]); 
    
	row = mxGetM(prhs[0]);
	col = mxGetN(prhs[0]);	

    if (mxGetNumberOfElements(prhs[3]) >1) {
        if (scale[0]>scale[1]){
            maxlimit = scale[0];    
            minlimit = scale[1];
		}else{
            minlimit = scale[0];    
            maxlimit = scale[1];
        }
	}else {
        maxlimit = DEF_MAXL;
        minlimit = DEF_MINL;
    }
    muNumber = mxGetNumberOfElements(prhs[4])/2;
    if (muNumber !=0) isSectoravg = 1;

	rowmask = mxGetM(prhs[5]);
	colmask = mxGetN(prhs[5]);
	if (rowmask > 0) {
	    if ((rowmask == row) & (colmask == col)) isMask = 1;
	    else mexPrintf("Error : Dimension of a mask is different from that of data\n");
	}
    if (mxGetNumberOfElements(prhs[2]) >1) {
        cent_X = bxy[1]-1;
        cent_Y = bxy[0]-1;
    }else{
        mexPrintf("Error : Wrong beam centers, will be set [1,1]\n");
        cent_X = 1.0;
        cent_Y = 1.0;
    }
    edge[0] = (int) dist(row, col, cent_X, cent_Y);
    edge[1] = (int) dist(0, col, cent_X, cent_Y);
    edge[2] = (int) dist(row, 0, cent_X, cent_Y);
    edge[3] = (int) dist(0, 0, cent_X, cent_Y);
    
    d = findmax(edge);

    if (Qoption) {
        qmax = Qscale[0];
        qN = Qscale[1];
        MAXSIZE = qN;
    } else {
        qmax = 0.0;
        qN = 0.0;
        MAXSIZE = d-1;
    }

    plhs[0] = mxCreateDoubleMatrix(MAXSIZE, 5, mxREAL);
    data = mxGetPr(plhs[0]);
    
    for (i=0;i<MAXSIZE;i++){
    	qv[i]=0;
        avg[i]=0;
        avg2[i]=0;
        npx[i]=0;
        data[i,0]=0.0;
        data[i,1]=0.0;
        data[i,2]=0.0;
        data[i,3]=0.0;
        data[i,4]=0.0;
    }
    
    for (i = 0; i < row; i++) {
        for (j = 0; j < col; j++) {
            indimg = i + j*row;
            imgv = *(img + indimg);
            isvalid = 1;
            if (isMask) {
                maskdata = *(mask + indimg);
            } else maskdata = 1.0;
            if (isSectoravg) {
                azim = azimang(i, j, cent_X, cent_Y);
                inSector = 0;
                for (m=0;m<muNumber;m++) {
                    if ((azim >= *(mu+m)) & (azim <= *(mu+muNumber+m))) inSector = 1;
                }
                if (inSector == 0) maskdata = 0.0;
            }
            isvalid1 = validatedata(maskdata, imgv, maxlimit, minlimit);
            isvalid2 = inMarcircle(row, col, CCDradius, i, j);
            isvalid = isvalid*isvalid1*isvalid2;
            if (isvalid) {
                dx2 = (i - cent_X)*(i - cent_X);
                dy2 = (j - cent_Y)*(j - cent_Y);
                r2 = floor(sqrt(dx2 + dy2) +0.5);
                qval = 4.0*pi/waveln*sin(1.0/2.0*atan(r2*psize/SDD));
                if (Qoption) {
                    r2 = floor(qval/qmax*MAXSIZE);
                    qval = (r2+0.5)*(qmax/MAXSIZE);
                }
                if (r2 >= 0 && r2 < MAXSIZE) {
                    if (dezinger) {
                        if (avg[r2] > 0) {
                            if ((imgv - offset) > avg[r2]/npx[r2]*dezingtimes) {
                                isvalid = 0;
                            }
                        }
                    }
                    if (isvalid) {
                        qv[r2] = qval;
                        avg[r2] += imgv - offset;
                        avg2[r2] += (imgv-offset)*(imgv-offset);
                        npx[r2] += 1.0;
                    }
                }
            }
        }
    }

    for (i=0;i<MAXSIZE;i++)
	{
    	data[i] = qv[i];
        Lp = sqrt(i*psize*i*psize + SDD*SDD);
        solidanglecorrection = Lp*Lp*Lp/SDD/psize/psize/1000000;
        data[i+MAXSIZE] = avg[i]/npx[i]*solidanglecorrection;
        data[i+2*MAXSIZE] = sqrt(avg[i])/npx[i]*solidanglecorrection;
        data[i+3*MAXSIZE] = avg[i];
        data[i+4*MAXSIZE] = npx[i];
        if (dezinger) {
            avg[i] = 0;
            npx[i] = 0;
        }
        
	}
}