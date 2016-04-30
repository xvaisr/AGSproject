!discover.


+!go_to(A,B): moves_left(0)<-!go_to(A,B).
+!go_to(A,B):pos(X,Y) & X<A <- do(right);!go_to(A,B).
+!go_to(A,B):pos(X,Y) & X>A <- do(left);!go_to(A,B).
+!go_to(A,B):pos(X,Y) & Y<B <- do(down);!go_to(A,B).
+!go_to(A,B):pos(X,Y) & Y>B <- do(up);!go_to(A,B).
+!go_to(A,B) .
//+!go_to(A,B)<-do(skip);!go_to.

+!discover :  grid_size(MaxX,MaxY) <- 
    for (.range(Y, 0, MaxY-2)) // Cyklus pres viditelne bunky
    {
		if((Y mod 3) == 0){
      	  for (.range(X, 1, MaxX-2))
		  {
				!go_to(X,Y); !findAll; 
		   }
		}
    } 
!collectGold;!collectWood.

+!findAll: gold(X,Y) & not goldAt(X,Y) <-  +goldAt(X,Y).
+!findAll: wood(X,Y) & not woodAt(X,Y) <- +woodAt(X,Y).
+!findAll: obstacle(X,Y) & not obstacleAt(X,Y) <- +obstacleAt(X,Y).
+!findAll.

+!collectGold:goldAt(X,Y)  & not carrying_gold(4) <-!go_to(X,Y); !try_pick; .abolish(goldAt(X,Y));  !collectGold.
+!collectGold: carrying_gold(4) & depot(X,Y)<- !go_to(X,Y); !try_depo;!collectGold.
+!collectGold: not carrying_gold(0) & depot(X,Y)<- !go_to(X,Y); !try_depo.
+!collectGold.

+!collectWood:woodAt(X,Y) & not carrying_wood(4) <-!go_to(X,Y); !try_pick; .abolish(woodAt(X,Y));  !collectWood.
+!collectWood: carrying_wood(4) & depot(X,Y)<- !go_to(X,Y);!try_depo;!collectWood.
+!collectWood: not carrying_wood(0) & depot(X,Y)<- !go_to(X,Y); !try_depo.
+!collectWood.

+!try_pick:pos(X,Y) & not gold(X,Y) & not wood(X,Y) .
//+!try_pick: pos(X,Y) & moves_left(2) & ally(X,Y) <- do(pick).
+!try_pick: pos(X,Y) & moves_left(2) <- do(pick).
+!try_pick<-!blank;!try_pick.


+!try_depo: moves_left(2) <-do(drop).
+!try_depo<-!blank;!try_depo.

+!blank: moves_left(2) <- do(skip);do(skip).
+!blank: moves_left(1) <- do(skip).
+!blank.
