//check which side I am playing
+!start: 
    .my_name(Name) & 
    .substring("b",Name,0) 
<- 
    +side("b");
    .concat("b","Slow",X);
    .concat("b","Middle",Y);
    +friendSlow(X);
    +friendMiddle(Y);.
//end of start b

+!start: 
    .my_name(Name) & 
    .substring("a",Name,Pos)
<- 
    +side("a");
    .concat("a","Slow",X);
    .concat("a","Middle",Y);
    +friendSlow(X);
    +friendMiddle(Y);.
//end of start a



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
	while(spectacles(AtX,AtY)){
		.send(Slow,tell,spec_at(AtX,AtY));
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
+!move_towards(A,B):
	pos(A,B)
<-
	do(skip);do(skip);do(skip);.
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
			.nth(0,Res,STarget);
			.term2string(Target,STarget);
			do(Target);
		}
	}//for
.
//end of move_towards


	
//Plan to drop go_tos
+!drop_go <- .abolish(go_to(_,_)).

+!drop_collects <- .abolish(collect(_,_)).

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
	gold(X,Y) &
	friendSlow(Slow) 
<-
	//make sure collect is dropped
	!picked(X,Y);
	.send(Slow,achieve,picked_g(X,Y));
	do(pick);
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


+step(N)<-do(skip);do(skip);do(skip).


//agents did their job, give them new stuff to do.
+!picked(X,Y)
<-
	.abolish(collect(X,Y));
.
