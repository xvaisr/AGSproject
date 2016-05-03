//see DEBUG to find places where communication should happen, need to pull names into it though
//cant pick anything up - you need 2 agents to pick something? - see test 1
//still no idea how to walk around obstacles, see. //DEBUG_OBSTACLES
//this is boring, yet annoying bullshit (note: try deleting this line before final version)

priority(search). //start with searching
vision(3). //start without spectacles

//define where borders are
border(X,-1). //top border
border(-1,Y). //left border
border(X,Y) :- grid_size(X,_). //roght border
border(X,Y) :- grid_size(_,Y). //bottom border

//eg. can go left means - no obstacle or border there
free(left) :- pos(MyX, MyY) & 
              not (obstacle_at(MyX-1, MyY) | border(MyX-1, MyY)).
free(right) :- pos(MyX, MyY) & 
               not (obstacle_at(MyX+1, MyY) | border(MyX+1, MyY)).
free(up) :- pos(MyX, MyY) & 
            not (obstacle_at(MyX, MyY-1) | border(MyX, MyY-1)).
free(down) :- pos(MyX, MyY) & 
              not (obstacle_at(MyX, MyY+1) | border(MyX, MyY+1)).

//check which side I am playing - same as other agents
+!start : 
    .my_name(Name) & 
    .substring("a",Name,0) 
<- 
    +side("a");
    .concat("a",Fast,X);
    .concat("a",Middle,Y);
    +friendFast(X);
    +friendMiddle(Y);.
+!start : 
    .my_name(Name) & 
    .substring("b",Name,0) 
<- 
    +side("b");
    .concat("b",Fast,X);
    .concat("b",Middle,Y);
    +friendFast(X);
    +friendMiddle(Y);.

//Explore the whole playing field - used on step 0
//top left corner is 0,0. Bigger X is more to right, bigger Y is more down
+!explore:
    grid_size(GetX,GetY)
<- 
    for(.range(Y,0,(GetY-1))){
        for(.range(X,0,(GetX-1))){
			+explore(X,Y); //want to explore everything
        }
    }
.

//needed for communication with others, they might send me this
+!unexplore(X,Y)
<- 
	.abolish(explore(X,Y));
.
	
//decision 1: searching the map, still have unexplored things to do
+!decide:
	priority(search) &
	pos(MyX,MyY) &
	explore(Something,Somewhere) &
	vision(Level)
<-
    //things already explored
    for(.range(IteratorX,MyX-Level,MyX+Level)){
		for(.range(IteratorY,MyY-Level,MyY+Level)){
			.abolish(explore(IteratorX,IteratorY));
	//DEBUG		.send(Fast,achieve,unexplore(CurrX,CurrY));
	//DEBUG		.send(Middle,achieve,unexplore(CurrX,CurrY));
		}
	}
    
	//note wood
	while(wood(AtX,AtY)){
		+wood_at(AtX,AtY);
	//DEBUG		.send(Middle,tell,wood_at(AtX,AtY));
	//DEBUG		.send(Fast,tell,wood_at(AtX,AtY));
		.abolish(wood(AtX,AtY));
	}
	
	//note gold
	while(gold(AtX,AtY)){
		+gold_at(AtX,AtY);
	//DEBUG		.send(Middle,tell,gold_at(AtX,AtY));
	//DEBUG		.send(Fast,tell,gold_at(AtX,AtY));
		.abolish(gold(AtX,AtY));
	}
	
	//note obstacles
	while(obstacle(AtX,AtY)){
		+obstacle_at(AtX,AtY);
	//DEBUG		.send(Middle,tell,obstacle_at(AtX,AtY));
	//DEBUG		.send(Fast,tell,obstacle_at(AtX,AtY));
		.abolish(obstacle(AtX,AtY));
	}
	
	//change priority when all explored
	if(not explore(_,_)){
		.abolish(priority(search));
		 while (visited(SomeX,SomeY)){
		 	.abolish(visited(SomeX,SomeY));
	     }
		.abolish(target(_,_));
		+priority(pick);
	}
	!go_next.

//after exploring, dont have to send all info and we save time, maybe
+!decide:
	not priority(search) 
<-
	!go_next.

/**************************following are !go_next(s)**************************/	
//passing through spectacles, grab them
+!go_next:
	vision(3) & //no spectacles yet
	// and spectacles on me
	spectacles(X,Y) & 
	pos(X,Y)
<-
	//update your vision
	.abolish(vision(3));
	+vision(6);
	do(pick).

//do not go into obstacle if that happens to be your target during exploring
+!go_next:
	target(X,Y) &
	obstacle_at(X,Y)
<-
	.abolish(target(X,Y));
	!go_next.	
	
//going explore, get target to explore 
+!go_next:
	pos(X,Y) &
	explore(Xe,Ye) & //we have st to search
	priority(search) & //search
	not target(Something,Somewhere)
<-
    while (visited(SomeX,SomeY)){
		.abolish(visited(SomeX,SomeY));
	}
	+visited(X,Y);
	+target(Xe,Ye);
	!go_next.

//full - go to depo, this one has only capacity 1, so no need to differ between gold/wood
+!go_next:
	carrying_wood(B) & 
	carrying_gold(A) & 
	priority(pick) & 
	carrying_capacity(C) &
	A+B == C &
	depot(HereX,HereY)
<-
    while (target(Something,Somewhere)){
		.abolish(target(Something,Somewhere));
	}
	while (visited(SomeX,SomeY)){
		.abolish(visited(SomeX,SomeY));
	}
	+visited(X,Y);
	+target(HereX,HereY);
	.abolish(priority(pick));
	+priority(drop);
	!go_next.

//drop it, we are at depo
+!go_next:
	carrying_wood(B) & 
	carrying_gold(A) & 
	priority(drop) & 
	(A>0 | B>0) &
	depot(HereX,HereY) &
	pos(HereX,HereY)
<-
    while (target(Something,Somewhere)){
		.abolish(target(Something,Somewhere));
	}
	.abolish(priority(drop));
	+priority(pick);
	do(drop).
	
//make wood your target	
+!go_next:
	pos(X,Y) &
	wood_at(Xe,Ye) & 
	priority(pick) & 
	not target(Something,Somewhere)
<-
    while (visited(SomeX,SomeY)){
		.abolish(visited(SomeX,SomeY));
	}
	+visited(X,Y);
	+target(Xe,Ye);
	!go_next.

//make gold your target	
+!go_next:
	pos(X,Y) &
	gold_at(Xe,Ye) & 
	priority(pick) & 
	not target(Something,Somewhere)
<-
    while (visited(SomeX,SomeY)){
		.abolish(visited(SomeX,SomeY));
	}
	+visited(X,Y);
	+target(Xe,Ye);
	!go_next.
	
//going somewhere, I have a target, but not there yet
+!go_next:
	pos(X,Y) &
	target(Xe,Ye) &
	moves_left(1) &
	(X \== Xe | Y \== Ye)
<-
	//routing - trivial, place I was not at, backtracking 
    //if (free(right)){do(right)}else{do(down)}.
	
	//try going the right way
	if ((X < Xe) & free(right) & not visited(X+1,Y)){
		+visited(X+1,Y);
		do(right)
	}else{
    if ((Y < Ye) & free(down) & not visited(X,Y+1)){
		+visited(X,Y+1);
		do(down)
	}else{
	if ((Y > Ye) & free(up) & not visited(X,Y-1)){
		+visited(X,Y-1);
		do(up)
	}else{
	if ((X > Xe) & free(left) & not visited(X-1,Y)){
		+visited(X-1,Y);
		do(left)
	}else{
	//DEBUG_OBSTACLES
	//well, I tried backtracking here, but it did not work ... hmm, this is annoying
	//'visited' were part of that backtracking
	do(skip);
	}
	}}}.

//already there - searching part, go somewhere else    
+!go_next:
	pos(X,Y) &
	priority(search) &
	target(Xe,Ye) &
	moves_left(1) &
	X == Xe &
	Y == Ye
<-
    .abolish(target(Xe,Ye));
	!go_next.

//got it
+!go_next:
	pos(X,Y) &
	priority(pick) &
	target(Xe,Ye) &
	( gold_at(Xe,Ye) | wood_at(Xe,Ye) ) &
	moves_left(1) &
	X == Xe &
	Y == Ye
<-
    .abolish(target(Xe,Ye));
	do(pick).

//its not there!!! - maybe should find ahead of time, hmmm...
+!go_next:
	pos(X,Y) &
	priority(pick) &
	target(Xe,Ye) &
	not( gold_at(Xe,Ye) | wood_at(Xe,Ye) ) &
	moves_left(1) &
	X == Xe &
	Y == Ye
<-
    .abolish(target(Xe,Ye));
	!go_next.
	
//safeguard against Jason intelligence	
+!go_next:
	not priority(search) |
	moves_left(0)
<-
    true.
+!go_next:
	true
<-
    do(skip).
/*****************************end of !go_next(s)*****************************/
	
//check if stuff is still there (opponent may have taken it)
+!check_area:
	pos(X,Y) &
	vision(Level)
<-
	for(.range(CurrX,X-Level,X+Level)){
		for(.range(CurrY,Y-Level,Y+Level)){
			if(wood_at(CurrX,CurrY) & not wood(CurrX,CurrY)){
				.abolish(wood_at(CurrX,CurrY));
			}
			if(gold_at(CurrX,CurrY) & not gold(CurrX,CurrY)){
				.abolish(gold_at(CurrX,CurrY));
			}
		}
	}
.

//always check what is still true, then decide your action
+step(0) <- !start;!explore;!check_area;!decide.
+step(X) <- !check_area;!decide. 
