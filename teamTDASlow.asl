//+step(1) <- do(transfer,aFast,1). //enemy agent => error , also not with myself!!!
//check which side I am playing
+!start : 
    .my_name(Name) & 
    .substring("a",Name,0) 
<- 
    +side("a");
    .concat("a",Fast,X);
    .concat("a",Middle,Y);
    +friendFast(X);
    +friendMiddle(Y);
	+fastCarry("");
	+midCarry("");.

//end of start a
+!start : 
    .my_name(Name) & 
    .substring("b",Name,0) 
<- 
    +side("b");
    .concat("b",Fast,X);
    .concat("b",Middle,Y);
    +friendFast(X);
    +friendMiddle(Y);
	+fastCarry("");
	+midCarry("");.
//end of start b

//Add whole playing field as unexplored to BB
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


//After exploration is complete and we are collecting check if resources
//are still there
//if not share it with friends
+!check_area:
	discovered(Is) &
	Is == true &
	pos(X,Y)
<-
	if(have_spectacles(_)){
		Range=6;
	}else{
		Range=3;
	}
	for(.range(CurrX,X-Range,X+Range)){
		for(.range(CurrY,Y-Range,Y+Range)){
			if(wood_at(CurrX,CurrY) & not wood(CurrX,CurrY)){
				.abolish(wood_at(CurrX,CurrY));
			}
			if(gold_at(CurrX,CurrY) & not gold(CurrX,CurrY)){
				.abolish(gold_at(CurrX,CurrY));
			}
		}
	}
.

//Delete visible area from explore candidates
//Check visible area for resources and share info with other agents
+!check_area: 
    pos(X,Y) &
	friendFast(Fast) &
	friendMiddle(Middle)
<-
	if(have_spectacles(_)){
		Range=6;
	}else{
		Range=3;
	}
	for(.range(CurrX,X-Range,X+Range)){
		for(.range(CurrY,Y-Range,Y+Range)){
			!unexplore(CurrX,CurrY);
			.send(Fast,achieve,unexplore(CurrX,CurrY));
			.send(Middle,achieve,unexplore(CurrX,CurrY));
		}
	}
	while(wood(AtX,AtY)){
		+wood_at(AtX,AtY);
		.abolish(wood(AtX,AtY));
	}
	while(gold(AtX,AtY)){
		+gold_at(AtX,AtY);
		.abolish(gold(AtX,AtY));
	}
	while(spectacles(AtX,AtY)){
		+spec_at(AtX,AtY);
		.abolish(spectacles(AtX,AtY));
	}
	while(obstacle(AtX,AtY)){
		+obstacle_at(AtX,AtY);
		.send(Fast,tell,obstacle_at(AtX,AtY));
		.send(Middle,tell,obstacle_at(AtX,AtY));
		.abolish(obstacle(AtX,AtY));
	}
	if(not explore(_,_)){
		.abolish(discovered(_));
		+discovered(true);
		.send(Fast,tell,discovered(true));
		.send(Middle,tell,discovered(true));
	}
.
//end of check_area

	

//Move towards coordinates
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


//the items to be collected were picked
+!picked_w(X,Y)
<-
	.abolish(wood_at(X,Y));
	!recalibrate
.


+!picked_g(X,Y)
<- 
	.abolish(gold_at(X,Y));
	!recalibrate
.

+!recalibrate:
	friendMiddle(Middle) &
	friendFast(Fast)
<-
	.abolish(collecting(_,_));
	.send(Middle,achieve,drop_collects);
	.send(Fast,achieve,drop_collects);
	while(wood_at(A,B)){
		+wood_temp(A,B);
		.abolish(wood_at(A,B));
	}
	while(gold_at(A,B)){
		+gold_temp(A,B);
		.abolish(gold_at(A,B));
	}
	while(wood_temp(A,B)){
		+wood_at(A,B);
		.abolish(wood_temp(A,B));
	}
	while(gold_temp(A,B)){
		+gold_at(A,B);
		.abolish(gold_temp(A,B));
	}
.
//end of picked

+!fastPos(X,Y)
<-
	.abolish(fastPos(_,_));
	+fastPos(X,Y);
.

+!midPos(X,Y)
<-
	.abolish(midPos(_,_));
	+midPos(X,Y);
.

//Mid and Fast drops their carriage
+!fast_drop 
<- 
	.abolish(fastCarry(_)); 
	+fastCarry("");
	if(midCarry(X) & X == ""){
		.abolish(collecting);
}.
	
+!mid_drop 
<- 
	.abolish(midCarry(_)); 
	+midCarry("");
	if(fastCarry(X) & X==""){
		.abolish(collecting);
}.

//First step, complete start and explore first
+step(0)
<-
	!start;
	!explore;
	?explore(X,Y);
	!move_towards(X,Y);
.

// PICK UP SPECTACLES IF FOUND ONE 
+step(N):
	spectacles(X,Y) &
	pos(X,Y) &
	not have_spectacles(_) &
	friendMiddle(Middle) &
	friendFast(Fast)
<-
	.abolish(spec_at(_,_));
	+have_spectacles(true);
	do(pick);
.

+step(N):
	not have_spectacles(_) &
	spec_at(X,Y)
<-
	!move_towards(X,Y);
.

+step(N):
	(wood_at(_,_) | gold_at(_,_)) &
	not collecting(_,_)
<-
	!recalibrate;
	if(explore(X,Y)){
		!move_towards(X,Y);
	}else{
		if(collecting(X,Y)){
			!move_towards(X,Y);
		}else{
			do(skip);
		}
	}
.

+step(N):
	friendMiddle(Middle) &
	friendFast(Fast) &
	not collecting(_,_) &
	not wood_at(_,_) &
	not gold_at(_,_) &
	not explore(_,_)
<-
	.send(Middle,tell,depos);
	.send(Fast,tell,depos);
	do(skip);
.

+step(N):
	explore(X,Y)
<-
	!move_towards(X,Y);
.

+step(N):
	collecting(X,Y)
<-
	!move_towards(X,Y);
.

+step(N):
	friendMiddle(Middle) &
	friendFast(Fast) <- do(skip);.

+wood_at(X,Y):
	collecting(A,B) &
	midPos(Mx,My) &
	fastPos(Fx,Fy) &
	friendMiddle(Middle) &
	friendFast(Fast) 
<-	
	DistMidWood = ((math.abs(X-Mx) + math.abs(Y-My)) div 2) + ((math.abs(X-Mx) + math.abs(Y-My)) mod 2);
	DistMidColl = ((math.abs(A-Mx) + math.abs(B-My)) div 2) + ((math.abs(A-Mx) + math.abs(B-My)) mod 2);
	DistFastWood = ((math.abs(X-Fx) + math.abs(Y-Fy)) div 3) + ((math.abs(X-Fx) + math.abs(Y-Fy)) mod 3);
	DistFastColl = ((math.abs(A-Fx) + math.abs(B-Fy)) div 3) + ((math.abs(A-Fx) + math.abs(B-Fy)) mod 3);
	DistWood = math.max(DistMidWood,DistFastWood);
	DistColl = math.max(DistMidColl,DistFastColl);
	if(DistWood < DistColl){
		.send(Middle,tell,collect(X,Y));
		.send(Fast,tell,collect(X,Y));
		+collecting(X,Y);
	}.

+wood_at(X,Y):
	friendMiddle(Middle) &
	friendFast(Fast) 
<-
	.send(Middle,tell,collect(X,Y));
	.send(Fast,tell,collect(X,Y));
	+collecting(X,Y);
.	
	
+gold_at(X,Y):
	collecting(A,B) &
	midPos(Mx,My) &
	fastPos(Fx,Fy) &
	friendMiddle(Middle) &
	friendFast(Fast)
<-
	DistMidGold = ((math.abs(X-Mx) + math.abs(Y-My)) div 2) + ((math.abs(X-Mx) + math.abs(Y-My)) mod 2);
	DistMidColl = ((math.abs(A-Mx) + math.abs(B-My)) div 2) + ((math.abs(A-Mx) + math.abs(B-My)) mod 2);
	DistFastGold = ((math.abs(X-Fx) + math.abs(Y-Fy)) div 3) + ((math.abs(X-Fx) + math.abs(Y-Fy)) mod 3);
	DistFastColl = ((math.abs(A-Fx) + math.abs(B-Fy)) div 3) + ((math.abs(A-Fx) + math.abs(B-Fy)) mod 3);
	DistGold = math.max(DistMidGold,DistFastGold);
	DistColl = math.max(DistMidColl,DistFastColl);
	if(DistGold < DistColl){
		.send(Middle,tell,collect(X,Y));
		.send(Fast,tell,collect(X,Y));
		+collecting(X,Y);
	}.	

+gold_at(X,Y):
	friendMiddle(Middle) &
	friendFast(Fast) 
<-
	.send(Middle,tell,collect(X,Y));
	.send(Fast,tell,collect(X,Y));
	+collecting(X,Y);
.
	


//resources was picked uop by enemy.
+!picked(X,Y)
<-	
	.abolish(collecting(X,Y));
	if(gold_at(X,Y)){
		.abolish(gold_at(X,Y));	
	}
	if(wood_at(X,Y)){
		.abolish(wood_at(X,Y));
	}
.



