//start the agent
!start.
!explore.

//check which side I am playing
+!start : .my_name(Name) & .substring("a",Name,0) <- +side("a");.
+!start : .my_name(Name) & .substring("b",Name,0) <- +side("b");.


@p2[atomic]
+?seen(A,B) <- ?pos(X,Y);
			   if( A > X){TargetA = (A-1);} if( A < X){TargetA = (A+1);}
			   if( B > Y){TargetB = (B-1);} if( B < Y){TargetB = (B+1);}
			   if(A == X) {TargetA = A;} if(B==Y){TargetB=B;}
			   !go_to(TargetA,TargetB);
			   .
+!go_toB(A,B):  true <-  while(pos(X,Y) & (A\==X | B\==Y))
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
						if(moves_left(C) & C>0 ){
							do(skip); 
							if(C>1){ do(skip);}
							if(C>2){ do(skip);}	
						}.
	
@g2[atomic]						  
+!go_to(A,B): true <-	while(pos(X,Y) & (A\==X | B\==Y))
						{
							while(moves_left(Moves) & Moves\==0 & pos(CurrX,CurrY) & (A\==CurrX | B\==CurrY))
							{ 
								!check_area;
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
							.							  



//+step(X) <- .print("step",X).
 //If enemy is around us and they are collecting contest them.

@p3[atomic]
+!explore: moves_left(Moves) & Moves > 0 <- ?grid_size(MaxX,MaxY);
											.print("MaxSizes:",MaxX-1,",",MaxY-1);
											for(.range(Y,0,(MaxY-1))){
												for(.range(X,0,(MaxX-1))){
													?seen(X,Y);
												}
											}
											+discovered(true);
											!collect.

@p14[atomic]											
+!depos: pos(X,Y) & depot(DX,DY) & moves_left(Mov) & moves_per_round(Total) & X==DX & Y==DY & Mov ==Total <- do(drop);.
+!depos: pos(X,Y) & depot(DX,DY) & moves_left(Mov) & moves_per_round(Total) & X==DX & Y==DY & Mov < Total <- while(moves_left(A) & A\==0){do(skip)} !depos.
+!depos: pos(X,Y) & depot(DX,DY) & X\==DX & Y\==DY <- !go_toB(DX,DY);!depos.
											
@p15[atomic]
+!skip(StepNum): step(X) & StepNum == X &skipped(Y) <- if(X\==Y){ do(skip);do(skip);do(skip); +skipped(X); .wait(.wait(step(Next)&Next>X))};!collect .
																		
																		
@p4[atomic]
+!collect: pos(X,Y) & wood_at(WoodX,WoodY) & ally(A,B) & X==WoodX & WoodX==A & Y==WoodY & WoodY==B & moves_left(Moves) & Moves\==0 <-?step(StepNum);.print("I shouldn't be here"); 
																.send(aMiddle,achieve,pick_it); do(pick); .abolish(wood_at(WoodX,WoodY));
																 if(carrying_capacity(Carry) & carrying_wood(Wood) & Carry == Wood){ .send(aMiddle,tell,skip(true)); !depos; .send(aMiddle,tell,skip(false));}
																 !collect.

+!collect: pos(X,Y) & wood_at(WoodX,WoodY) & X==WoodX & Y==WoodY & moves_left(Moves) & Moves==0 <-.print("doing nothing until step"); 
																								.wait(20);!collect.	
@p6[atomic]
+!collect: pos(X,Y) & wood_at(WoodX,WoodY) & X==WoodX & Y==WoodY <-.print("I should be here"); if(moves_left(Moves) & Moves<=3) 
					{if(Moves>0){do(skip);}if(Moves>1){do(skip);}if(Moves>2){do(skip);}} !collect.
@p7[atomic]																	
+!collect: pos(X,Y) & wood_at(WoodX,WoodY)<- .print("I should be here only once");.send(aMiddle,achieve,go_toB(WoodX,WoodY)); !go_toB(WoodX,WoodY);!collect.	

@p9[atomic]
+!collect: pos(X,Y) & gold_at(GoldX,GoldY) & ally(A,B) & X==GoldX & GoldX==A & Y==GoldY & GoldY==B & moves_left(Moves) & Moves\==0 <-.print("I shouldn't be here"); 
																.send(aMiddle,achieve,pick_it); do(pick); .abolish(gold_at(GoldX,GoldY));
																 if(carrying_capacity(Carry) & carrying_gold(Gold) & Carry == Gold){ .send(aMiddle,tell,skip(true)); !depos; .send(aMiddle,tell,skip(false));}
																 !collect.

+!collect: pos(X,Y) & gold_at(GoldX,GoldY) & X==GoldX & Y==GoldY & moves_left(Moves) & Moves==0 <-.print("doing nothing until step"); 
																								.wait(20);!collect.	
@p10[atomic]
+!collect: pos(X,Y) & gold_at(GoldX,GoldY) & X==GoldX & Y==GoldY <-.print("I should be here"); if(moves_left(Moves) & Moves<=3) 
					{if(Moves>0){do(skip);}if(Moves>1){do(skip);}if(Moves>2){do(skip);}} !collect.

@p11[atomic]																	
+!collect: pos(X,Y) & gold_at(GoldX,GoldY)<- .print("I should be here only once");if(carrying_wood(Gold) & Gold\==0) {!depos;.send(aMiddle,achieve,depos)}
													.send(aMiddle,achieve,go_toB(GoldX,GoldY)); !go_toB(GoldX,GoldY);!collect.

+!collect: pos(X,Y) & gold_at(GoldX,GoldY) & X==GoldX & Y==GoldY & moves_left(Moves) & Moves==0 <-.print("doing nothing until step"); 
																								.wait(20);!collect.	

+!collect: moves_left(Moves) & Moves==0 <- .wait(20);!collect.
							 


@p5[atomic]
+!check_area: pos(X,Y) &gold(_,_) <- Left=X-1; Right=X+1;Top=Y+1;Bottom=Y-1;
						 +seen(Left,Top);+seen(X,Top);+seen(Right,Top);
						 +seen(Left,Y);+seen(X,Y);+seen(Right,Y);
						 +seen(Left,Bottom);+seen(X,Bottom);+seen(Right,Bottom);
						 ?gold(A,B);.print("Gold at position:",A,",",B);
						 +gold_at(A,B); .


+!check_area: pos(X,Y) &wood(_,_) <- Left=X-1; Right=X+1;Top=Y+1;Bottom=Y-1;
						 +seen(Left,Top);+seen(X,Top);+seen(Right,Top);
						 +seen(Left,Y);+seen(X,Y);+seen(Right,Y);
						 +seen(Left,Bottom);+seen(X,Bottom);+seen(Right,Bottom);
						 ?wood(A,B);.print("Wood at position:",A,",",B);
						 +wood_at(A,B);	.
						 
+!check_area: pos(X,Y) <- Left=X-1; Right=X+1;Top=Y+1;Bottom=Y-1;
						 +seen(Left,Top);+seen(X,Top);+seen(Right,Top);
						 +seen(Left,Y);+seen(X,Y);+seen(Right,Y);
						 +seen(Left,Bottom);+seen(X,Bottom);+seen(Right,Bottom);
						 .
						 
+?moves_left<-.print("failed for no reason").
						/* if(seen(Left,Top)){ +gold_at(Left,Top);}if(gold(X,Top)){ +gold_at(X,top); };if(gold(Right,Top)){+gold_at(Right,Top);}
						 if(gold(Left,Y)){+gold_at(Left,Y);}if(gold(X,Y)){+gold_at(X,Y);}if(gold(Right,Y)){+gold_at(Right,Y);}
						 if(gold(Left,Bottom)){+gold_at(Left,Bottom);}if(gold(X,Bottom)){+gold_at(X,Bottom);}if(gold(Right,Bottom)){+gold_at(Right,Bottom);}*/
					  
/*						  
+!check_area: pos(X,Y) & ( enemy(X,Y+1) | enemy(X+1,Y) | enemy(X-1,Y) | enemy(X,Y-1)) <-
		.print("My Position is:"); .print("Enemy Close by").
										

		
+!check_area:true <- ?pos(X,Y); .print("My Position is:",X,",",Y);.



+!get_gold(A,B): pos(X,Y) & moves_left(C) & C > 0 <- if( A > X){ do(right); !check_area;}
													 if( A < X){ do(left); !check_area;}
													 if( B > Y) { do(down); !check_area;}
													 if( B < Y) { do(up); !check_area;}.
													 
+!get_gold(A,B): pos(X,Y) & moves_left(C) & C > 0 <- if( A > X){ do(right); !check_area;}
													 if( A < X){ do(left); !check_area;}
													 if( B > Y) { do(down); !check_area;}
													 if( B < Y) { do(up); !check_area;}.													 
*/									 
