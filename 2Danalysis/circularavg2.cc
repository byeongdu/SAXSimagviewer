#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

#include <octave/oct.h>
#include "defun-dld.h"
#include "error.h"
#include "gripes.h"
#include "oct-obj.h"
#include "utils.h"
#include "dMatrix.h"

#include <stdio.h>
#include <math.h>

double azimang(int X, int Y, double Xc, double Yc)
{
double dx, dy;
double theta = 0;
double pi = 3.141592;

dx = (double) X-Xc;
dy = (double) Y-Yc;
if (dx>0) theta = atan(dy/dx)*180/pi + 90;
if (dx<0) theta = atan(dy/dx)*180/pi + 270;
if (dx == 0) {
    if (dy > 0)	theta = 180;
    if (dy <= 0) theta = 0;
    }
return theta;
}

int inSector(const Matrix& sector, double theta)
{
int row = sector.rows ();
int retval = 0;
for (int m=0;m<row;m++) if ((theta >= sector(m,0)) & (theta <= sector(m, 1))) retval = 1;
return retval;
}

int inMarcircle(double centX, double centY, double R, int X, int Y)
{
int retval = 1;
double R1 = 0.0;
R1 = sqrt((centX-X)*(centX-X) + (centY-Y)*(centY-Y));
if (R1 > R) retval = 0;
return retval;
}

int validatedata(int mask, double data, int maxlimit, int minlimit)
{
int retval = 0;
if (mask > 0) if ((data > minlimit) & (data < maxlimit)) retval = 1;
return retval;
}

DEFUN_DLD (circularavg, args, nargout,
  "-*- texinfo -*-\n\
@deftypefn {Loadable Function} {[@var{x}] = } circularavg (@var{image},@var{[beam X, beam Y]},@var{[maxlimit, minlimit]},@var{[mu_start_ang, mu_end_ang; ..]},@var{mask})\n\
Default : limit = [-2^16, 2^16], azimuthal angle = [], mask = []\n\
Using the 2D interpolation fuction\n\
@end deftypefn")

{ 
    octave_value retval;
    int nargin = args.length();

    Matrix img = args(0).matrix_value();
    Matrix mask;
    int row = img.rows();
    int col = img.columns();
    int rowmask;
    int colmask;
    int isMask = 0;
    int isSectoravg = 0;
    Matrix azimtheta;
    int rowtheta = 0;
    int coltheta = 0;

    int maxlimit = 65536;
    int minlimit = 0;
    int maskdata = 0;
    int offset = 0;
    offset = args(2).int_value();

    Matrix limit;

    if (nargin >= 4)
	{
	limit = args(3).matrix_value();
	if (limit.columns() > 1) {
	    if (limit(0) < limit(1)) {
		minlimit = (int) limit(0);    // [theta_start, theta_end; theta2_start, theta2_end;]
	        maxlimit = (int) limit(1);
		}
  	    if (limit(0) > limit(1)) printf("invalid input of max, min limit\n");
	    }
	}

    if (nargin >= 5)
	{
	azimtheta = args(4).matrix_value();
        
	rowtheta = azimtheta.rows ();    // [theta_start, theta_end; theta2_start, theta2_end;]
        coltheta = azimtheta.columns ();
	if (coltheta > 1) {
	    if (coltheta != 2) {
	    	printf("Error: azimuthal angles has to be added as [sec1_start, sec1_end; sec2_sart, sec2_end...]\n");
	    	printf("Sector average won't be done\n");
	    	}
	    else isSectoravg = 1;
	    }
	}

    if (nargin == 6)
	{
	mask = args(5).matrix_value();
	rowmask = mask.rows ();
	colmask = mask.columns ();
	
	if (rowmask > 0) {
	    if ((rowmask == row) & (colmask == col)) isMask = 1;
	    else printf("Error : Dimension of a mask is different from that of data\n");
	    }
	}

    ColumnVector arg_cent (args(1).vector_value());
    double cent_X = arg_cent(0);    // 
    double cent_Y = arg_cent(1);
    cent_X -= 1;
    cent_Y -= 1;
    int CCDradius = 0;
    int edge[4];
    edge[0] = int(cent_X);
    edge[1] = int(col - cent_X+1);
    edge[2] = int(cent_Y);
    edge[3] = int(row - cent_Y+1);
    CCDradius = int(sqrt((col-cent_X+1)*(col-cent_X+1) + (row-cent_Y+1)*(row-cent_Y+1)));
    int d = 0;
    for (int k=0;k<4;k++)
	{
	if (d<edge[k])
	    d = edge[k];
	}
    d = d-5;

    double dx2;
    double dy2;
    int r2;
    int MAXSIZE = d+1;
    double avg[MAXSIZE];
    double npx[MAXSIZE];
    double avg2[MAXSIZE];
    int i;
    int j;
    int isvalid;
    Matrix data (d+1, 5);
    for (i=0;i<MAXSIZE;i++){
	avg[i]=0;
 	avg2[i]=0;
	npx[i]=0;
    }
    for (i = 0; i < row; i++) {
          for (j = 0; j < col; j++) {

	    if (isMask) maskdata = (int) mask(i,j);
 	    else maskdata = 1;
	    
	    if (isSectoravg) if (inSector(azimtheta, azimang(i, j, cent_X, cent_Y)) == 0) maskdata = 0;
	    isvalid = validatedata(maskdata, img(i,j), maxlimit, minlimit);
            isvalid = isvalid * inMarcircle(cent_X, cent_Y, CCDradius, i, j);
            if (isvalid) {
                dx2 = (i - cent_X)*(i - cent_X);
                dy2 = (j - cent_Y)*(j - cent_Y);
                r2 = (int) (sqrt(dx2 + dy2));

                if (r2 >= 0 && r2 < MAXSIZE) {
                  avg[r2] += img(i,j) - offset;
		  avg2[r2] += (img(i,j)-offset)*(img(i,j)-offset);
                  npx[r2] += 1.0;
                }
            }
          }
    }

    for (i=0; i<MAXSIZE;i++)
	{
	data(i, 1) = avg[i]/npx[i];
//	data(i, 2) = sqrt((avg2[i]-(avg[i]*avg[i]/npx[i]))/npx[i]);
	data(i, 2) = sqrt(avg[i])/npx[i];
	data(i, 0) = i;
	data(i, 3) = avg[i];
	data(i, 4) = npx[i];
	}
    retval = data;
    return retval;
}
