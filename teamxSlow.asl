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

/*
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
*/
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
		.send(Fast,tell,wood_at(AtX,AtY));
		.send(Middle,tell,wood_at(AtX,AtY));
		.abolish(wood(AtX,AtY));
	}
	while(gold(AtX,AtY)){
		+gold_at(AtX,AtY);
		.send(Fast,tell,gold_at(AtX,AtY));
		.send(Middle,tell,gold_at(AtX,AtY));
		.abolish(gold(AtX,AtY));
	}
	while(spectacles(AtX,AtY)){
		+spec_at(AtX,AtY);
		.send(Fast,tell,spec_at(AtX,AtY));
		.send(Middle,tell,spec_at(AtX,AtY));
		.abolish(spectacles(AtX,AtY));
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


//the items to be collected were picked
+!picked_w(X,Y) <-.abolish(wood_at(X,Y));.
+!picked_g(X,Y) <- .abolish(gold_at(X,Y));.
+!picked_s(X,Y) <- .abolish(spec_at(X,Y));.

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
	ally(X,Y) &
	friendMiddle(Middle) &
	friendFast(Fast)
<-
	.abolish(sent);
	.abolish(spec_at(X,Y));
	+have_spectacles(true);
	.send(Middle,achieve,drop_go);
	.send(Fast,achieve,drop_go);
	do(pick);
.

+step(N):
	spec_at(X,Y) &
	sent
<-
	!move_towards(X,Y);
.

+step(N):
	not have_spectacles(_) &
	spec_at(X,Y) &
	fastPos(FX,FY) &
	midPos(MX,MY)
<-
	Dist1 = (math.abs(FX-X)+ math.abs(FY-Y)) div 4;
	Dist2 = (math.abs(MX-X)+ math.abs(MY-Y)) div 2;
	if(Dist1 < Dist2){
		?friendFast(Fast);
		.send(Fast,tell,go_to(X,Y));
	}else{
		?friendMiddle(Middle);
		.send(Middle,tell,go_to(X,Y));
	}
	+sent;
	!move_towards(X,Y);
.

+step(N):
	explore(X,Y) &
	gold_at(A,B) &
	friendMiddle(Middle) &
	friendFast(Fast)
<-
	.send(Middle,tell,collect(A,B));
	.send(Fast,tell,collect(A,B));
	!move_towards(X,Y);
.

+step(N):
	explore(X,Y)
<-
	!move_towards(X,Y);
.

+step(N):
	wood_at(A,B) &
	friendMiddle(Middle) &
	friendFast(Fast) &
	midCarry(MCar) &
	fastCarry(FCar) &
	(MCar =="gold" | FCar =="gold")
<-
	if(MCar \== ""){
		.send(Middle,tell,depos);
	}
	if(FCar \==""){
		.send(Fast,tell,depos);
	}
	do(skip);.	

+step(N):
	wood_at(A,B) &
	friendMiddle(Middle) &
	friendFast(Fast) 
<-
	.send(Middle,tell,collect(A,B));
	.send(Fast,tell,collect(A,B));
	do(skip);.


+step(N):
	friendMiddle(Middle) &
	friendFast(Fast) <- do(skip);.


//agents did their job, give them new stuff to do.
+!picked(X,Y):
	gold_at(X,Y)
<-
	.abolish(gold_at(X,Y));
.

+!picked(X,Y):
	wood_at(X,Y)
<-
	.abolish(wood_at(X,Y));
.

+!picked(_,_):true.

