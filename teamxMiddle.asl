
/*
+step(D): go(A,B) <- !go_to(A,B);!go_to(A,B);!findAll.
+step(D): collect <- .abolish(collect); !collectGold;do(skip);do(skip).
+step(D): pick    <- do(pick);.abolish(pick);+collect.
+step(D): depos   <- do(drop);.abolish(depos);+collect.
+step(D)          <- do(skip);do(skip).
*/

//check which side I am playing
+!start : 
    .my_name(Name) & 
    .substring("a",Name,0) 
<- 
    +side("a");
    .concat("a",Slow,X);
    .concat("a",Fast,Y);
    +friendSlow(X);
    +friendFast(Y);.
//end of start a
+!start : 
    .my_name(Name) & 
    .substring("b",Name,0) 
<- 
    +side("b");
    .concat("b",Slow,X);
    .concat("b",Fast,Y);
    +friendSlow(X);
    +friendFast(Y);.
//end of start b


//Explore the whole playing field
+!explore:
	grid_size(MaxX,MaxY)
<- 
    for(.range(Y,1,(MaxY-2))){
        for(.range(X,1,(MaxX-2))){
			+explore(X,Y);
        }//forX
    }//forY
	.
//end of explore

+!unexplore(X,Y)
<- 
	.abolish(explore(X,Y));
.

+!check_area:
	discovered(Is) &
	Is == true &
	pos(X,Y)
<-
	for(.range(CurrX,X-1,X+1)){
		for(.range(CurrY,Y-1,Y+1)){
			if(wood_at(CurrX,CurrY) & not wood(CurrX,CurrY)){
				.abolish(wood_at(CurrX,CurrY));
			}
			if(gold_at(CurrX,CurrY) & not gold(CurrX,CurrY)){
				.abolish(gold_at(CurrX,CurrY));
			}
		}
	}
.
/* Unexplore the 9 cells I see and if there are wood or gold add it to BB */
+!check_area: 
    pos(X,Y) &
	friendSlow(Slow) &
	friendFast(Fast)
<-
    Left    =   X-1; 
    Right   =   X+1;
    Top     =   Y+1;
    Bottom  =   Y-1;
	for(.range(CurrX,X-1,X+1)){
		for(.range(CurrY,Y-1,Y+1)){
			!unexplore(CurrX,CurrY);
			.send(Slow,achieve,unexplore(CurrX,CurrY));
			.send(Fast,achieve,unexplore(CurrX,CurrY));
		}
	}
	while(wood(AtX,AtY)){
		+wood_at(AtX,AtY);
		.send(Fast,tell,wood_at(AtX,AtY));
		.abolish(wood(AtX,AtY));
	}
	while(gold(AtX,AtY)){
		+gold_at(AtX,AtY);
		.send(Fast,tell,gold_at(AtX,AtY));
		.abolish(gold(AtX,AtY));
	}
	if(not explore(_,_)){
		.abolish(discovered(_));
		+discovered(true);
	}
.


+!move_towards(X,Y):
	moves_per_round(C)
<-
	for(.range(Counter,1,C)){
		!check_area;
		if( pos(A,B) & A>X){
			do(left);
		}else{ 
		if( pos(A,B) & B>Y){
			do(up);
			}else{
		if( pos(A,B) & A<X){
			do(right);		
			}else{
		if( pos(A,B) & B<Y){
			do(down);	
		}else{
			do(skip);}
		}}}
	}//for
.


+step(N):
	carrying_capacity(Cap) &
	carrying_gold(Gold) &
	carrying_wood(Wood) &
	( Cap == Gold | Cap == Wood) &
	depot(X,Y) &
	pos(CA,CB) 
<-
	.print("I am Full");
	if(CA\==X | CB\==Y){
		!move_towards(X,Y);
	}else{
		do(drop);
	}
	.
	
+step(N):
	gold_at(X,Y) &
	pos(A,B) &
	ally(FX,FY) &
	carrying_wood(WC) &
	WC==0 &
	A==X &
	B==Y &
	FX==A &
	FY==B
<-
	.abolish(gold_at(X,Y));
	do(pick);
.

+step(N):
	gold_at(X,Y) &
	pos(A,B) & 
	carrying_wood(WC) &
	WC==0
<-
	!move_towards(X,Y);
.

+step(N):
	wood_at(X,Y) &
	pos(A,B) &
	ally(FX,FY) &
	carrying_gold(GC) &
	GC==0 &
	A==X &
	B==Y &
	FX==A &
	FY==B
<-
	.abolish(wood_at(X,Y));
	do(pick);
.
	
+step(N):
	wood_at(X,Y) &
	pos(A,B) &
	carrying_gold(GC) &
	GC==0
<-
	!move_towards(X,Y);
.

+step(N):
	collect(X,Y) &
	moves_per_round(C)
<-
	for(.range(Counter,1,C)){
		!check_area;
		if( pos(A,B) & A>X){
			do(left);
		}else{ 
		if( pos(A,B) & B>Y){
			do(up);
		}else{
		if( pos(A,B) & A<X){
			do(right);		
		}else{
		if( pos(A,B) & B<Y){
			do(down);	
		}else{
			do(skip);}
		}}}
	}//for
	.
+step(N): 
	explore(X,Y) &
	moves_per_round(C)
<-
	!move_towards(X,Y);
.


+step(0)
<-
	!start;
	!explore;
	+step(-1)
.
	
/*

+!go_to(A,B):pos(X,Y) & X<A <- do(right).
+!go_to(A,B):pos(X,Y) & X>A <- do(left).
+!go_to(A,B):pos(X,Y) & Y<B <- do(down).
+!go_to(A,B):pos(X,Y) & Y>B <- do(up).
+!go_to(A,B) <-.abolish(go(A,B));do(skip).


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
+!collectWood. //End of collencting*/
