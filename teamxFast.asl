/* beliefbase */

discovered(false).
inc(X,Y)	:-	Y = X+1.
inc2(X,Y)	:-	Y = X+2.
dec(X,Y)	:-	Y = X-1.
dec2(X,Y)	:-	Y = X-2.
/* initial goals */


/* plans */

//check which side I am playing
+!start : 
    .my_name(Name) & 
    .substring("a",Name,0) 
<- 
    +side("a");
    .concat("a",Slow,X);
    .concat("a",Middle,Y);
    +friendSlow(X);
    +friendMiddle(Y);.
//end of start a
+!start : 
    .my_name(Name) & 
    .substring("b",Name,0) 
<- 
    +side("b");
    .concat("b",Slow,X);
    .concat("b",Middle,Y);
    +friendSlow(X);
    +friendMiddle(Y);.
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
	friendMiddle(Middle)
<-
    Left    =   X-1; 
    Right   =   X+1;
    Top     =   Y+1;
    Bottom  =   Y-1;
	for(.range(CurrX,X-1,X+1)){
		for(.range(CurrY,Y-1,Y+1)){
			!unexplore(CurrX,CurrY);
			.send(Slow,achieve,unexplore(CurrX,CurrY));
			.send(Middle,achieve,unexplore(CurrX,CurrY));
		}
	}
	while(wood(AtX,AtY)){
		+wood_at(AtX,AtY);
		.send(Middle,tell,wood_at(AtX,AtY));
		.abolish(wood(AtX,AtY));
	}
	while(gold(AtX,AtY)){
		+gold_at(AtX,AtY);
		.send(Middle,tell,gold_at(AtX,AtY));
		.abolish(gold(AtX,AtY));
	}
	if(not explore(_,_)){
		.abolish(discovered(_));
		+discovered(true);
	}
.

//end of check_area

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
	carrying_capacity(Cap) &
	carrying_gold(Gold) &
	Cap == Gold &
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
	explore(X,Y) &
	moves_per_round(C)
<-
	!move_towards(X,Y);
.

+step(0)
<-
	!start;
	!explore;
	+step(-1).
/*
+step(N):
	discovered(Is) &
	Is\==True &
	grid_size(MaxX,MaxY)
<-
	for(.range(Counter,0,2)){
		!check_area;
		if( pos(A,B) & A>1 & not seen(A-2,B) ){
			do(left);
		}else{ 
		if( pos(A,B) & B>1 & not seen(A,B-2) ){
			do(up);
		}else{
		if( pos(A,B) & A<MaxX-2 & not seen(A+2,B) ){
			do(right);		
		}else{
		if( pos(A,B) & B<MaxY-2 & not seen(A,B+2) ){
			do(down);	
		}
		}}}
	}
	.
    */                  
                             
