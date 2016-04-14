new.


 +step(X):new <- ?grid_size(A,B);+right(A);+down(B);+right;-new;do(skip).

 +step(X):spectacles(A,B)&pos(A,B)<-+hass;do(pick).
 +step(X):spectacles(A,B)&hass<-do(skip).
 +step(X):right&pos(A,B)&right(C)&(A+1)<C<- do(right).
 +step(X):right<--right;+left;do(down).	
 +step(X):left&pos(A,B)&A>0<-do(left).	
 +step(X):left<--left;+right;do(down).



