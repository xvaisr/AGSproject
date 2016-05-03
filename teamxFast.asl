!start.

+step(D): go(A,B) <- !go_to(A,B);!go_to(A,B);!go_to(A,B).
+step(X)<-do(skip);do(skip);do(skip).

+!go_to(A,B):pos(X,Y) & X<A <- do(right).
+!go_to(A,B):pos(X,Y) & X>A <- do(left).
+!go_to(A,B):pos(X,Y) & Y<B <- do(down).
+!go_to(A,B):pos(X,Y) & Y>B <- do(up).
+!go_to(A,B):go(A,B) <-.abolish(go(A,B));do(skip).
+!go_to(A,B) <-do(skip).

+!start : 
    .my_name(Name) & 
    .substring("a",Name,0) 
<- 
    +side("a");
    .concat("a",Slow,X);
    .concat("a",Middle,Y);
    +friendSlow(X);
    +friendMiddle(Y);.
