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

/*
//After exploration is complete and we are collecting check if resources
//are still there
//if not share it with friends
+!check_area:
	discovered(Is) &
	Is == true &
	pos(X,Y) &
	friendSlow(Slow) &
	friendMiddle(Middle)
<-
	for(.range(CurrX,X-1,X+1)){
		for(.range(CurrY,Y-1,Y+1)){
			if(wood_at(CurrX,CurrY) & not wood(CurrX,CurrY)){
				!picked(X,Y);
				.send(Slow,achieve,picked_w(CurrX,CurrY));
				.send(Middle,achieve,picked(CurrX,CurrY));
			}
			if(gold_at(CurrX,CurrY) & not gold(CurrX,CurrY)){
				!picked(X,Y);
				.send(Slow,achieve,picked_g(CurrX,CurrY));
				.send(Middle,achieve,picked(CurrX,CurrY));
			}
			if(spec_at(CurrX,CurrY) & not spectacles(CurrX,CurrY)){
				.abolish(spec_at(CurrX,CurrY));
				.send(Slow,achieve,picked_s(CurrX,CurrY));
			}
		}
	}
.
*/
//Delete visible area from explore candidates
//Check visible area for resources and share info with other agents
+!check_area: 
    pos(X,Y) &
	friendSlow(Slow) &
	friendMiddle(Middle)
<-
	.send(Slow,achieve,fastPos(X,Y));
	for(.range(CurrX,X-1,X+1)){
		for(.range(CurrY,Y-1,Y+1)){
			!unexplore(CurrX,CurrY);
			.send(Slow,achieve,unexplore(CurrX,CurrY));
			.send(Middle,achieve,unexplore(CurrX,CurrY));
		}
	}
	while(wood(AtX,AtY)){
		+wood_at(AtX,AtY);
		.send(Slow,tell,wood_at(AtX,AtY));
		.send(Middle,tell,wood_at(AtX,AtY));
		.abolish(wood(AtX,AtY));
	}
	while(gold(AtX,AtY)){
		+gold_at(AtX,AtY);
		.send(Slow,tell,gold_at(AtX,AtY));
		.send(Middle,tell,gold_at(AtX,AtY));
		.abolish(gold(AtX,AtY));
	}
	while(spectacles(AtX,AtY)){
		+spec_at(AtX,AtY);
		.send(Slow,tell,spec_at(AtX,AtY));
		.send(Middle,tell,spec_at(AtX,AtY));
		.abolish(spectacles(AtX,AtY));
	}
	while(spectacles(AtX,AtY)){
		+spec_at(AtX,AtY);
		.send(Slow,tell,spec_at(AtX,AtY));
		.send(Middle,tell,spec_at(AtX,AtY));
		.abolish(spectacles(AtX,AtY));
	}
	while(obstacle(AtX,AtY)){
		+obstacle_at(AtX,AtY);
		.send(Slow,tell,obstacle_at(AtX,AtY));
		.send(Middle,tell,obstacle_at(AtX,AtY));
		.abolish(obstacle(AtX,AtY));
	}
.
//end of check_area

//Move towards coordinates
+!move_towards(X,Y):
	moves_per_round(C)
<-
	//Target is to the left and up
	if( pos(A,B) & A>X & B>Y){
		//Distance to left more than 1 and more than up.
		if(A-X > 1 & A-X > B-Y){
			do(left);
			do(up);
			do(left);
		}else{
			do(up);
			do(left);
			do(up);		
		}
	}else{ 	
	//Target to the right and up
	if( pos(A,B) & A<X & B>Y){
		//Distance to right more than 1 dist and more than up.
		if(X-A > 1 & X-A > B-Y){
			do(right);
			do(up);
			do(right);
		}else{
			do(up);
			do(right);
			do(up);		
		}	
	}else{
	//Target to the right and down
	if( pos(A,B) & A<X & B<Y){
		//Distance to right more than 1 dist and more than down.
		if(X-A > 1 & X-A > B-Y){
			do(right);
			do(down);
			do(right);
		}else{
			do(down);
			do(right);
			do(down);		
		}	
	}else{
	//Target is to the left and up
	if( pos(A,B) & A>X & B>Y){
		//Distance to left more than 1 and more than down.
		if(A-X > 1 & A-X > B-Y){
			do(left);
			do(down);
			do(left);
		}else{
			do(up);
			do(down);
			do(up);		
		}
	}else{ 	
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
	}}}}
.
//end of move_towards

//Plan to drop go_tos
+!drop_go <- .abolish(go_to(_,_)).



+step(0)
<-
	!start;
	!explore;
	?explore(X,Y);
	!move_towards(X,Y);
.

//+step(_) <- do(skip);do(skip);do(skip);.

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
	.send(Slow,achieve,fast_drop);
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
	friendMiddle(Middle)
<-
	do(pick);
	!picked(X,Y);
	.send(Slow,achieve,picked(X,Y));
	.send(Middle,achieve,picked(X,Y));
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
	friendMiddle(Middle)
<-
	do(pick);
	//make sure collect is dropped
	!picked(X,Y);
	.send(Slow,achieve,picked(X,Y));
	.send(Middle,achieve,picked(X,Y));
	.send(Slow,tell,midCarry("gold"));
	if(carrying_capacity(Cap) 
		& carrying_gold(Gold) &  Cap == Gold ){
		+depos;
	}
.

//If I get to the collect position and nothings there, abolish collect
+step(N):
	collect(X,Y) &
	pos(A,B) &
	friendSlow(Slow) &
	friendMiddle(Middle) &
	math.abs(A-X) < 2 &
	math.abs(B-Y) < 2 &
	not wood(X,Y) &
	not gold(X,Y)
<- 
	!picked(X,Y);
	.send(Slow,achieve,picked(X,Y));
	.send(Middle,achieve,picked(X,Y));
	do(skip);do(skip);do(skip);
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
	do(skip);do(skip);do(skip);.

+step(N)<-do(skip);do(skip);do(skip).


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

+!picked(_,_):true.
