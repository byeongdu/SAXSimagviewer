#include <math.h>
#include "mex.h"

/*usage*/
/* circularc(img, cent) */

#define	T_IN prhs[0]
#define	Y_IN prhs[1]
#define	Z_IN prhs[2]

/* Output Arguments */

#define	TP_OUT plhs[0]
#define	YP_OUT plhs[1]

void circularc(double *img, double *centx, double *centy, double *x, double *y, int m, int n)
{

unsigned int index = 0;
unsigned int count = 0;
unsigned int max_index = 0;
unsigned int i, j;
double cent_X;
double cent_Y;

cent_Y = *centy;
cent_X = *centx;

    for(i = 0; i < n; i++) {
        for(j=0; j < m; j++) {
                index = floor(sqrt((i+1-cent_X)*(i+1-cent_X) + (j+1-cent_Y)*(j+1-cent_Y)) + 0.5);
                *(y + index) = *(y + index) +  *(img + count);
                *(x + index) = *(x + index) + 1;
                count++;
                if(index > max_index){
                        max_index = index;
                }
        }
    }


for(i=1; i < (max_index - 2); i++){
        *(y + i) =  *(y + i) / *(x + i);
        *(x + i) = i;
    }
        *y =  0;
}    
    


/*the gateway routine */

void mexFunction( int nlhs, mxArray *plhs[], 
		  int nrhs, const mxArray *prhs[] )
     
{ 
    double *yp; 
    double *tp;
    double *t,*y, *z; 
    unsigned int mrow,ncol; 
    double *cx, *cy;
    double cent[2];
    unsigned int kk[4];
    unsigned int max_index = 0;
    int i;
    
    /* Check for proper number of arguments */
    
    if (nrhs != 3) { 
	mexErrMsgTxt("Three input arguments required."); 
    } 
    
    if (nlhs < 2 || nlhs > 2) {
	mexErrMsgTxt("Two output arguments required."); 
    } 
    
    /* Check the dimensions of Y.  Y can be 4 X 1 or 1 X 4. */ 
    
    mrow = mxGetM(T_IN); 
    ncol = mxGetN(T_IN);

    cx = mxGetPr(Y_IN);
    cy = mxGetPr(Z_IN);
    cent[0] = *cx;
    cent[1] = *cy;
    
    kk[0] =  floor(sqrt( (1 - cent[0]) * (1 - cent[0])  + (1 - cent[1]) * (1 - cent[1]) ) + 0.5);
    kk[1] =  floor(sqrt( (ncol - cent[0]) * (ncol-1 - cent[0])  + (1 - cent[1]) * (1 - cent[1]) ) + 0.5);
    kk[2] =  floor(sqrt( (1 - cent[0]) * (1 - cent[0])  + (mrow - cent[1]) * (mrow-1 - cent[1]) ) + 0.5);
    kk[3] =  floor(sqrt( (ncol - cent[0]) * (ncol-1 - cent[0])  + (mrow - cent[1]) * (mrow-1 - cent[1]) ) + 0.5);
    
    for(i=0; i<4; i++){
        if(max_index < kk[i]){
            max_index = kk[i];
        }
    }
        
    
    /* Create a matrix for the return argument */ 
    TP_OUT = mxCreateDoubleMatrix(max_index-1, 1, mxREAL); 
    YP_OUT = mxCreateDoubleMatrix(max_index-1, 1, mxREAL);     

    /* Assign pointers to the various parameters */ 
    tp = mxGetPr(TP_OUT);
    yp = mxGetPr(YP_OUT);
    
    t = mxGetPr(T_IN); 
    y = mxGetPr(Y_IN);
    z = mxGetPr(Z_IN);
        
    /* Do the actual computations in a subroutine */
    circularc(t,y, z, tp, yp, mrow, ncol); 
    return;
    
}