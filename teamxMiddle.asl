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
    for(.range(Y,0,(MaxY-1))){
        for(.range(X,0,(MaxX-1))){
			+explore(X,Y);
        }//forX
    }//forY
	.
//end of explore

//Delete Explored Position from BB 
+!unexplore(X,Y)
<- 
	.abolish(explore(X,Y));
.
//end of unexplore
/*
//After exploration is complete and we are collecting check if resources
//are still there
//if not share it with friends
+!check_area:
	discovered(Is) &
	Is == true &
	pos(X,Y) &
	friendSlow(Slow) &
	friendFast(Fast)
<-
	for(.range(CurrX,X-1,X+1)){
		for(.range(CurrY,Y-1,Y+1)){
			if(wood_at(CurrX,CurrY) & not wood(CurrX,CurrY)){
				!picked(X,Y);
				.send(Slow,achieve,picked_w(CurrX,CurrY));
				.send(Fast,achieve,picked(CurrX,CurrY));
			}
			if(gold_at(CurrX,CurrY) & not gold(CurrX,CurrY)){
				!picked(X,Y);
				.send(Slow,achieve,picked_g(CurrX,CurrY));
				.send(Fast,achieve,picked(CurrX,CurrY));
			}
			if(spec_at(CurrX,CurrY) & not spectacles(CurrX,CurrY)){
				.abolish(spec_at(CurrX,CurrY));
				.send(Slow,achieve,picked_s(CurrX,CurrY));
			}
		}
	}
.*/
//Delete visible area from explore candidates
//Check visible area for resources and share info with other agents
+!check_area: 
    pos(X,Y) &
	friendSlow(Slow) &
	friendFast(Fast)
<-
	.send(Slow,achieve,midPos(X,Y));
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
		.send(Slow,tell,wood_at(AtX,AtY));
		.abolish(wood(AtX,AtY));
	}
	while(gold(AtX,AtY)){
		+gold_at(AtX,AtY);
		.send(Fast,tell,gold_at(AtX,AtY));
		.send(Slow,tell,gold_at(AtX,AtY));
		.abolish(gold(AtX,AtY));
	}
	while(spectacles(AtX,AtY)){
		+spec_at(AtX,AtY);
		.send(Fast,tell,spec_at(AtX,AtY));
		.send(Slow,tell,spec_at(AtX,AtY));
		.abolish(spectacles(AtX,AtY));
	}
.
//end of check_area

//Move towards coordinates
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
//end of move_towards


//Plan to drop go_tos
+!drop_go <- .abolish(go_to(_,_)).

//+step(_) <- do(skip);do(skip);.

//First step, complete start and explore first
+step(0)
<-
	!start;
	!explore;
	?explore(X,Y);
	!move_towards(X,Y);
.
//end of first step

+step(N):
	go_to(X,Y)
<-
	!move_towards(X,Y);.

+step(N):
	depos &
	depot(X,Y) &
	pos(X,Y) &
	friendSlow(Slow)
<-
	.abolish(depos);
	.send(Slow,achieve,mid_drop);
	do(drop);
.

+step(N):
	depos & 
	depot(X,Y)
<-
	!move_towards(X,Y);
.
+step(N):
	collect(X,Y) &
	pos(X,Y) &
	ally(X,Y) &
	wood(X,Y) &
	friendSlow(Slow) &
	friendFast(Fast)
<-
	do(pick);
	!picked(X,Y);
	.send(Slow,achieve,picked(X,Y));
	.send(Fast,achieve,picked(X,Y));
	.send(Slow,tell,midCarry("wood"));
	if(carrying_capacity(Cap) & carrying_wood(Wood) 
		 & Cap == Wood){
		+depos;
	}.
	
	
+step(N):
	collect(X,Y) &
	pos(X,Y) &
	ally(X,Y) &
	gold(X,Y) &
	friendSlow(Slow) &
	friendFast(Fast)
<-
	do(pick);
	//make sure collect is dropped
	!picked(X,Y);
	.send(Slow,achieve,picked(X,Y));
	.send(Fast,achieve,picked(X,Y));
	.send(Slow,tell,midCarry("gold"));
	if(carrying_capacity(Cap) 
		& carrying_gold(Gold) &  Cap == Gold ){
		+depos;
	}
.
//If I get to the collect position and nothings there, abolish collect
+step(N):
	collect(X,Y) &
	pos(X,Y) &
	friendSlow(Slow) &
	friendFast(Fast) &
	not wood(X,Y) &
	not gold(X,Y)
<- 
	!picked(X,Y);
	.send(Slow,achieve,picked(X,Y));
	.send(Fast,achieve,picked(X,Y));
	do(skip);do(skip);
.
+step(N):
	collect(X,Y)
<-
	!move_towards(X,Y);
.

+step(N): 
	explore(X,Y)
<-
	!move_towards(X,Y);
.

+step(N):
	carrying_gold(X) &
	carrying_wood(Y) &
	not wood_at(_,_) &
	not gold_at(_,_) &
	( X > 0 | Y > 0 )
<-
	+depos;
	do(skip);do(skip);.

+step(N)<-do(skip);do(skip);.

//agents did their job, give them new stuff to do.
+!picked(X,Y):
	gold_at(X,Y)
<-
	.abolish(gold_at(X,Y));
	.abolish(collect(X,Y));
.

+!picked(X,Y):
	wood_at(X,Y)
<-
	.abolish(wood_at(X,Y));
	.abolish(collect(X,Y));
.

+!picked(X,Y):true.

