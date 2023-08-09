#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

# include "mex.h"
# include "math.h"

double interpolate(double *img, double *x, double *y, long N, int w, int h, double *out)
{
/* img : input image
x, y: arrays of X and Y coordinates. [x, y] is a set.
N : number of points in x or y.
w : width of image
h : height of image
out : array to get return values
*/
	double fraction_x, fraction_y, one_minus_x, one_minus_y;
	int ceil_x, ceil_y, floor_x, floor_y;
	double pix[4], xR, yR;
	long i;
	for (i=0; i<N; i++) {
		xR = x[i]-1; // due to matlab and c index difference
		yR = y[i]-1; // due to matlab and c index difference 
		floor_x = (int)floor(xR);
		floor_y = (int)floor(yR);
		/* if the coordinate is outside of the image, it return -1*/
		if (floor_x<0) {
			out[i] = -1;
			continue;
			//floor_x = 0;
		}
		if (floor_y<0) {
			out[i] = -1;
			continue;
			//floor_y = 0;
		}
		if (floor_x>h-1) {
			out[i] = -1;
			continue;
		}
		if (floor_y>w-1) {
			out[i] = -1;
			continue;
		}
		ceil_x = floor_x + 1;
		ceil_y = floor_y + 1;
		ceil_x = floor_x + 1;
		if (ceil_x >= w) ceil_x = floor_x;
		ceil_y = floor_y + 1;
		if (ceil_y >= h) ceil_y = floor_y;	
		fraction_x = xR - floor_x;
		fraction_y = yR - floor_y;
		one_minus_x = 1.0 - fraction_x;
		one_minus_y = 1.0 - fraction_y;
		
		pix[0] = img[floor_y*w + floor_x];
		pix[1] = img[floor_y*w + ceil_x];
		pix[2] = img[ceil_y*w + floor_x];
		pix[3] = img[ceil_y*w + ceil_x];
		//pix[0] = *img(floor_y*w + floor_x];
		//pix[1] = *img(floor_y*w + ceil_x];
		//pix[2] = *img(ceil_y*w + floor_x];
		//pix[3] = *img(ceil_y*w + ceil_x];
		 
		out[i] = one_minus_y*(one_minus_x*pix[0]+fraction_x*pix[1]) + fraction_y*(one_minus_x*pix[2]+fraction_x*pix[3]);
	}
}

void mexFunction (int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{ 
    /* interpolate2D(image, x, y);
    // x and y are the cartesian coordinate(s) where intensities will be interplated to.
	// x is the row and y is the colum as you do in matlab.
     */
    
	double *img, *x, *y, *pind;
    int row, col;
	long len_input;
    
	if (nrhs != 3) {
        mexPrintf("%i\n", nrhs);
	    mexErrMsgTxt("3 inputs, image, x and y");
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
	x = mxGetPr(prhs[1]);
	y = mxGetPr(prhs[2]);
    
	row = mxGetM(prhs[0]);
	col = mxGetN(prhs[0]);	
	len_input = mxGetNumberOfElements(prhs[1]);
	plhs[0] = mxCreateDoubleMatrix(len_input,1,mxREAL);
	pind = mxGetPr(plhs[0]);
	//printf("row = %i, col = %i\n", row, col);
	//fprintf('valat (3,2) are %0.3f\n', *(img+2+1*(int)row));
	interpolate(img, x, y, len_input, row, col, pind);
}