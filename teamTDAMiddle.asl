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
    for(.range(X,0,(MaxX-1))){
        for(.range(Y,0,(MaxY-1))){
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
			if(wood_at(CurrX,CurrY) & not wood(CurrX,CurrY) & not gold(CurrX,CurrY)){
				!picked(X,Y);
				.send(Slow,achieve,picked(CurrX,CurrY));
				.send(Fast,achieve,picked(CurrX,CurrY));
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
		.send(Slow,tell,wood_at(AtX,AtY));
		.abolish(wood(AtX,AtY));
	}
	while(gold(AtX,AtY)){
		.send(Slow,tell,gold_at(AtX,AtY));
		.abolish(gold(AtX,AtY));
	}
	while(spectacles(AtX,AtY)){
		.send(Slow,tell,spec_at(AtX,AtY));
		.abolish(spectacles(AtX,AtY));
	}
	while(obstacle(AtX,AtY)){
		+obstacle_at(AtX,AtY);
		.send(Slow,tell,obstacle_at(AtX,AtY));
		.send(Fast,tell,obstacle_at(AtX,AtY));
		.abolish(obstacle(AtX,AtY));
	}
.
//end of check_area
//Move towards coordinates
+!move_towards(A,B):
	pos(A,B)
<-
	do(skip);do(skip);.
+!move_towards(A,B):
	moves_per_round(C)
<-
	for(.range(Counter,1,C)){
		!check_area;
		if(pos(X,Y) & A == X & B ==Y){
			do(skip);
		}else{
			?pos(X,Y);
			aStar.road_to(X,Y,A,B,1,Res);
			//.print(Res);
			.nth(0,Res,STarget);
			.term2string(Target,STarget);
			do(Target);
		}
	}//for
.
//end of move_towards
/*//Move towards coordinates
+!move_towards(X,Y):
	moves_per_round(C)
<-
	//Target is to the left and up
	if( pos(A,B) & A>X & B>Y){
		//Distance to left more than 1 and more than up.
		if(A-X > 1 & A-X > B-Y){
			!check_area;
			do(left);
			!check_area;
			do(up);
		}else{
			!check_area;	
			do(up);
			!check_area;
			do(left);	
		}
	}else{ 	
	//Target to the right and up
	if( pos(A,B) & A<X & B>Y){
		//Distance to right more than 1 dist and more than up.
		if(X-A > 1 & X-A > B-Y){
			!check_area;
			do(right);
			!check_area;
			do(up);
		}else{
			!check_area;
			do(up);
			!check_area;
			do(right);	
		}	
	}else{
	//Target to the right and down
	if( pos(A,B) & A<X & B<Y){
		//Distance to right more than 1 dist and more than down.
		if(X-A > 1 & X-A > B-Y){
			!check_area;
			do(right);
			!check_area;
			do(down);
		}else{
			!check_area;
			do(down);
			!check_area;
			do(right);		
		}	
	}else{
	//Target is to the left and up
	if( pos(A,B) & A>X & B>Y){
		//Distance to left more than 1 and more than down.
		if(A-X > 1 & A-X > B-Y){
			!check_area;
			do(left);
			!check_area;
			do(down);
		}else{
			!check_area;
			do(up);
			!check_area;
			do(down);
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
.*/
//end of move_towards


//Plan to drop go_tos
+!drop_go <- .abolish(go_to(_,_)).

+!drop_collects <- .abolish(collect(_,_)).

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
	friendSlow(Slow) 
<-
	!picked(X,Y);
	.send(Slow,achieve,picked_w(X,Y));
	do(pick);
	if(carrying_capacity(Cap) & carrying_wood(Wood) 
		 & Cap == Wood){
		+depos;
}.
	
	

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
+!picked(X,Y)
<-
	.abolish(collect(X,Y));
.

