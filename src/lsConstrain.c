/* $Author: sinnwell $ */
/* $Date: 2006/11/28 21:21:00 $ */
/* $Header: /people/biostat3/sinnwell/Projects/IBDReg/Make/RCS/lsConstrain.c,v 1.2 2006/11/28 21:21:00 sinnwell Exp $ */
/* $Locker:  $ */
 
/*      SUBROUTINE LSTSQ 
	ALGORITHM AS225 APPL. STATIST. (1987) VOL. 36, NO. 2

        COMPUTES THE LEAST-SQUARES PROJECTION OF X ONTO
        THE INTERSECTION OF K SIMULTANEOUS AFFINE CONSTRAINTS,
        USING THE MAHALANOBIS DISTANCE DETERMINED BY S.
        THE ITH CONSTRAINT IS OF THE FORM
        SUM OVER J OF A(I,J)*X(J) (.LE.,.EQ.) B(I)
        --.LE. IF IFLAG(I) .EQ. 0
        --.EQ. IF IFLAG(I) .EQ. 1

	Translated from Fortran to C by Dan Schaid 9/9/2005
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <R.h> 
#include <R_ext/Error.h>
#define ulong unsigned

static double **double_vec_to_mat(double *Yvec, ulong nrow, ulong ncol);
static double **double_matrix(ulong nrow, ulong ncol);
static void errmsg(char *string);


/*************** Global vars ******************************************************/

/* s and a are global, so we can later return to S, and then free
   them from memory. We do this because there are multiple ways to
   return from the lsConstrain function, and so we want to avoid
   redundant free of memory */


/**********************************************************************************/

void lsConstrain(

/*      SUBROUTINE LSTSQ(X, S, A, B, IFLAG, N, K, NWORK, ITMAX, EPS, EPS2,
     *  W, XHAT, XKT, ITER, SUPDIF, IFAULT)
     */

     double *x,              /* vector of length N */
     int    *n_in,
     int    *k_in,
     int    *nwork_in,
     int    *itmax,
     double *eps,
     double *eps2,
     double *svec,                /* to be an N x N matrix */
     double *avec,                /*  A(K, N) */
     double *b,                /* B(K) */
     int    *iflag,            /* vec length K */
     double *xhat,             /* vec length N */
     double *xkt,              /* vec length K */
     int    *iter,
     double *supdif,
     int    *ifault,
     double *w)
{


  double zero = 0.0;
  double two = 2.0;

  double **s, **a;
  int k = *k_in;
  int n = *n_in;

  int nk = n * k;
  int nk2 = nk + nk;
  int nk2k = nk2 + k;
  int index;
  int i,j,l;
  int ind1, ind2;
  double abdif;
  double sum, temp;

 
  /* need to have a function to later call (from S) to free mem */

  s = double_vec_to_mat(svec, n, n);
  a = double_vec_to_mat(avec, k, n);


  *ifault = 0;
 
   for(i=1; i<=k; i++){
     for(j=1; j<=n; j++){
       index = nk + (j - 1) * k + i;
       w[index-1] = zero;
       for(l=1; l<=n; l++){
         w[index-1] +=  a[i-1][l-1] * s[l-1][j-1];
	}
     }
   }

   for(i=1; i<=k; i++){
     index = nk2 + i;
     w[index-1] = zero;
     for(j=1; j<=n; j++){
       ind2 = nk + (j - 1) * k + i;
       w[index-1] +=  a[i-1][j-1] * w[ind2-1];
     }
     if(fabs(w[index-1]) <= (*eps2)){
       *ifault = 3;

       /* free memory  */

       for(i=0; i< n; i++){
         Free(s[i]);
       }
       Free(s);
       s = NULL;

       for(i=0; i< k; i++){
         Free(a[i]);
       }
       Free(a);
       a = NULL;
       return;

     }
   }


   for(j=1; j<=n; j++){ 
     index = nk2k + j;
     w[index-1] = x[j-1];
     xhat[j-1] = x[j-1];
     for(i=1; i<=k; i++){
       index = (i - 1) * n + j;
       w[index-1] = zero;
     }
   }

   *iter = 0;


  while( (*iter) < (*itmax)){
    (*iter) ++;
    (*supdif) = zero;

    for(i=1; i<=k; i++){

      for(j=1; j<=n; j++){
        index = (i - 1) * n + j;
        xhat[j-1] +=  w[index-1];
      }

      sum = zero;
  
      for(j=1; j<=n; j++){
        sum += a[i-1][j-1] * xhat[j-1]; 
      }

      sum = sum - b[i-1];

      if(iflag[i-1] == 0 && sum <= zero)
      {
        for(j=1; j<=n; j++){
          index = (i - 1) * n + j;
          w[index-1] = zero;
        }
      } 
      else 
      {
       index = nk2 + i; 
       temp = sum / w[index-1];
       for(j=1; j<=n; j++){
         ind1 = (i - 1) * n + j;
         ind2 = nk + (j - 1) * k + i;
         w[ind1-1] = w[ind2-1] * temp;
         xhat[j-1] = xhat[j-1] - w[ind1-1];
       }
      }


      /*    FIND LARGEST CHANGE, AND CHECK FOR CONVERGENCE */

      for(j=1; j<=n; j++){
        index = nk2k + j;
        abdif  = fabs(xhat[j-1] - w[index-1]);
        if( (*supdif) < abdif) (*supdif) = abdif;
      }
    }

   if( (*supdif) <= (*eps)){

     for(i=1; i<=k; i++){

       /* FIND A NON-ZERO DENOMINATOR:*/

       for(j=1; j<=n; j++){ 
         index = nk + (j-1) * k + i; 
         if(fabs(w[index-1]) > (*eps2)) break;
       }

       ind2 = (i-1) * n + j;
       xkt[i-1] = two * w[ind2-1] / w[index-1];
     } 


     /* free memory  */

     for(i=0; i< n; i++){
        Free(s[i]);
     }
     Free(s);
     s = NULL;

     for(i=0; i< k; i++){
       Free(a[i]);
     }
     Free(a);
     a = NULL;
 
     return;
   }

   for(j=1; j<=n; j++){
     index = nk2k + j;
     w[index-1] = xhat[j-1];
   }


  } /* end while loop */

  *ifault = 1;

  /* free memory  */

  for(i=0; i< n; i++){
    Free(s[i]);
  }
  Free(s);
  s = NULL;

  for(i=0; i< k; i++){
    Free(a[i]);
  }
  Free(a);
  a = NULL;

  return;
}

/***********************************************************************************/

static double **double_vec_to_mat(double *Yvec, ulong nrow, ulong ncol){

   ulong i,j,k;
   double **Y;

   Y=double_matrix(nrow,ncol);
   k=0;
   for (j=0;j<ncol;j++){
      for (i=0;i<nrow;i++){
         Y[i][j]=Yvec[k];
         k++;
      }
   }
   return Y;
}

/***********************************************************************************/

static double **double_matrix(ulong nrow, ulong ncol){
/* allocate double matrix with subscript range m[0 ..(nrow-1)][0..(ncol-1)] */
        ulong i;
        double **m;

        /* allocate pointers to rows */
        m=(double **) Calloc(nrow, double *);
        if (!m) errmsg("mem alloc failure 1 in double_matrix");
  
	/* allocate vec of memory for each row */
        for(i=0;i<nrow;i++) {
          m[i]=(double *) Calloc(ncol, double);
          if(!m[i]) errmsg("mem alloc failure 2 in double_matrix");
	}

        /* return pointer to array of pointers to rows */
        return m;
}

/***********************************************************************************/

static void errmsg(char *string){

  /* Function to emulate "stop" of S+ - see page 134, S Programing, by
     Venables and Ripley */

  /* PROBLEM "%s", string RECOVER(NULL_ENTRY); 
     For R 4.1.x and later, use Rf_error from R_ext/Error.h 
  */
  Rf_error(string, "%s");
   
}

