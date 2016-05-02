!discover.

+step(D): go(A,B) <- !go_to(A,B);!go_to(A,B);!findAll.
+step(D): collect <- .abolish(collect); !collectGold;do(skip);do(skip).
+step(D): pick    <- do(pick);.abolish(pick);+collect.
+step(D): depos   <- do(drop);.abolish(depos);+collect.
+step(D)          <- do(skip);do(skip).



+!go_to(A,B):pos(X,Y) & X<A <- do(right).
+!go_to(A,B):pos(X,Y) & X>A <- do(left).
+!go_to(A,B):pos(X,Y) & Y<B <- do(down).
+!go_to(A,B):pos(X,Y) & Y>B <- do(up).
+!go_to(A,B) <-.abolish(go(A,B));do(skip).


+!discover :  grid_size(MaxX,MaxY) <- 
   for (.range(Y, 0,MaxY-1)) 
    {
		if((Y mod 3) == 0){
      	  
				+go(1,Y);  
				+go(MaxX-2,Y);
		}
    }
+collect.


+!findAll: gold(X,Y) & not goldAt(X,Y) <-  +goldAt(X,Y).
+!findAll: wood(X,Y) & not woodAt(X,Y) <- +woodAt(X,Y).
+!findAll: obstacle(X,Y) & not obstacleAt(X,Y) <- +obstacleAt(X,Y).
+!findAll.

+!collectGold:goldAt(X,Y)  & not carrying_gold(4) <-+go(X,Y); +pick; .abolish(goldAt(X,Y)).
+!collectGold: carrying_gold(4) & depot(X,Y)<- +go(X,Y); +depos.
+!collectGold: not carrying_gold(0) & depot(X,Y)<- +go(X,Y); +depos.
+!collectGold <-!collectWood.

+!collectWood:woodAt(X,Y) & not carrying_wood(4) <-+go(X,Y);  +pick; .abolish(woodAt(X,Y)).
+!collectWood: carrying_wood(4) & depot(X,Y)<- +go(X,Y);+depos.
+!collectWood: not carrying_wood(0) & depot(X,Y)<- +go(X,Y); +depos.
+!collectWood. //End of collencting
