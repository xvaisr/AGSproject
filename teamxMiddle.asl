factorial(0,1).
factorial(N,F) :- factorial(N-1,F1) & F = N*F1.

!start.

+!start : .my_name(Name) & .substring("a",Name,0) <- +side("a");+skip(true).
+!start : .my_name(Name) & .substring("b",Name,0) <- +side("b").


+!depos: pos(X,Y) & depot(DX,DY) & moves_left(Mov) & moves_per_round(Total) & X==DX & Y==DY & Mov ==Total <- do(drop);.
+!depos: pos(X,Y) & depot(DX,DY) & moves_left(Mov) & moves_per_round(Total) & X==DX & Y==DY & Mov \==Total <- while(moves_left(A) & A\==0){do(skip)} !depos.
+!depos: pos(X,Y) & depot(DX,DY) & X\==DX & Y\==DY <- !go_toB(DX,DY);!depos.

+!skip:true <-if(moves_left(C) & C>0 ){
							do(skip); 
							if(C>1){ do(skip);}}.

							
							
@p2[atomic]			
+step(X) <- if((skip(Y) & Y == true) | X == 0 ) {.print("+step(X)"); while(moves_left(Moves) & Moves\==0) { do(skip)} while(moves_left(Moves) & Moves\==0) { do(skip)}}.

+!pick_it: pos(X,Y) & ally(A,B) & X==A & Y==B & moves_left(Moves) & Moves == 2 <- do(pick);if(carrying_capacity(Carry) & carrying_wood(Wood) & carrying_gold(Gold) 
																						& (Carry == Wood | Carry==Gold) ){!depos}. 
+!pick_it: true <- while(moves_left(Moves) & Moves\==0) { do(skip)}.

@p1[atomic]
+!go_toB(A,B):  true <-  .abolish(skip);
						 while(pos(X,Y) & (A\==X | B\==Y))
						 {
							while(moves_left(Moves) & Moves\==0 & pos(CurrX,CurrY) & (A\==CurrX | B\==CurrY))
							{ 
								if(A\==CurrX){ 
									if( A > CurrX){ 
										do(right); 
									} else{ 
										do(left);
									}
								}
								else {
									if(B\==CurrY){ 
										if( B > CurrY) { do(down);}
										else { 
										/*if( B < CurrY)*/  do(up);
										}
									}
								}
							}
						}
						if(moves_left(C) & C==1 ){do(skip);}.
						
				  
/*
!printfact5.
@p1[atomic]
+!printfact5 : .my_name(aMiddle) <- ?factorial(5,F);
				+hodnota_faktorialu(5,F);
				.print("Factorial(5) = ", F).

+hodnota_faktorialu(X,F) <-.print("Ulozeno fact(", X, ")=",F).
@p2[atomic]
+!printfact5  <- .print("Nejsem agentA, nereknu nic").


+step(X) <- !akce1;!akce2;do(skip);do(skip).
+!akce1 : friend(F) & .substring("Slow",F) <- .print("I have a friend: ", F, " and he is a slow type").
+!akce1 : friend(F) & .substring("Fast",F) <- .print("I have a friend: ", F, " and he is a fast type").
+!akce1 : friend(F) & .substring("Middle",F) <- .print("I have a friend: ", F, " and he is a middle type").

+!akce2 <- .my_name(Name);?side(Side);.print("I am: ", Name, " on side: ", Side).*/
