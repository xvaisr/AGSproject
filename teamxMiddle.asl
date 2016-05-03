
able(right) :- pos(MyX, MyY) & grid_size(MaxX,MaxY) & not (obstacle(MyX+1, MyY) | MyX == MaxX).
able(up) :- pos(MyX, MyY) & grid_size(MaxX,MaxY) & not (obstacle(MyX, MyY-1) | MyY == 0).
able(left) :- pos(MyX, MyY) & grid_size(MaxX,MaxY) & not (obstacle(MyX-1, MyY) | MyX == 0).
able(down) :- pos(MyX, MyY) & grid_size(MaxX,MaxY) & not (obstacle(MyX, MyY+1) | MyY == MaxY).




!start.
//!solve(16,10).


+step(D): go(A,B) <- !go_to(A,B);!go_to(A,B).
+step(D): pickG(X,Y) & ally(X,Y)   <- do(pick);.abolish(pickG(X,Y)); .abolish(goldAt(X,Y)).
+step(D): pickW(X,Y) & ally(X,Y)   <- do(pick);.abolish(pickW(X,Y)); .abolish(woodAt(X,Y)).
+step(D): depos   <- do(drop);.abolish(depos).
+step(D) <- !collectGold;do(skip);do(skip).
//+step(D) <- do(skip);do(skip).

+!start : 
    .my_name(Name) & 
    .substring("a",Name,0) 
<- 
    +side("a");
    .concat("a",Slow,X);
    .concat("a",Fast,Y);
    +friendSlow(X);
    +friendFast(Y).

+!solve(X,Y): moves_left(0) <-!solve(X,Y).
+!solve(X,Y): pos(Ya,Xa) & X == Xa & Y == Ya.
+!solve(X,Y): pos(Ya,Xa) & able(left) <- .print(Xa,Ya);do(left);!solve(Xa-1,Ya).
+!solve(X,Y): pos(Ya,Xa) & able(right) <- .print(Xa,Ya);do(right);!solve(Xa+1,Ya).
+!solve(X,Y): pos(Ya,Xa) & able(up) <- .print(Xa,Ya);do(up);!solve(Xa,Ya-1).
+!solve(X,Y): pos(Ya,Xa) & able(down) <- .print(Xa,Ya);do(down);!solve(Xa,Ya+1).


+!go_to(A,B):pos(X,Y) & X<A <- do(right).
+!go_to(A,B):pos(X,Y) & X>A <- do(left).
+!go_to(A,B):pos(X,Y) & Y<B <- do(down).
+!go_to(A,B):pos(X,Y) & Y>B <- do(up).
+!go_to(A,B):go(A,B) <-.abolish(go(A,B));do(skip).
+!go_to(A,B) <-do(skip).




//@collectGold0[atomic]+!collectGold:goldAt(X,Y) & not carrying_wood(0) <-!collectWood.
@collectGold1[atomic]+!collectGold:goldAt(X,Y) & carrying_wood(0) & not carrying_gold(4) & friendFast(Fast) <-+go(X,Y); .send(Fast,tell,go(X,Y)); +pickG(X,Y).
@collectGold2[atomic]+!collectGold: carrying_gold(4) & depot(X,Y)<- +go(X,Y); +depos.
@collectGold3[atomic]+!collectGold: not carrying_gold(0) & depot(X,Y)<- +go(X,Y); +depos.
@collectGold4[atomic]+!collectGold<-!collectWood.

//@collectWood0[atomic]+!collectWood:woodAt(X,Y) & not carrying_gold(0) <-!collectGold.
@collectWood1[atomic]+!collectWood: woodAt(X,Y) &  carrying_gold(0) & not carrying_wood(4)   & friendFast(Fast) <-+go(X,Y); .send(Fast,tell,go(X,Y)); +pickW(X,Y).
@collectWood2[atomic]+!collectWood: carrying_wood(4) & depot(X,Y)<- +go(X,Y);+depos.
@collectWood3[atomic]+!collectWood: not carrying_wood(0) & depot(X,Y)<- +go(X,Y); +depos.
@collectWood4[atomic]+!collectWood. //End of collencting


