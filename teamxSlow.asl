!start.
!discover.
//!solve(16,10).

+step(D): 
	go(A,B) 
<- 
	!go_to(A,B).

+step(D): 
	spectaclesAt(X,Y) 
<- 
	.abolish(spectaclesAt(X,Y)); 
	do(pick);
	+glass.
	
+step(D): 
	explore(A,B)
<- 
	!go_to(A,B).

+step(D)  
<- 
	do(skip).

+!start : 
    .my_name(Name) & 
    .substring("a",Name,0) 
<- 
    +side("a");
    .concat("a",Fast,X);                          
    .concat("a",Middle,Y);
    +friendFast(X);
    +friendMiddle(Y);.


+!go_to(A,B):
	pos(X,Y) & 
	X<A
<- 
	do(right);
	!findAll;
	!seen(X,Y).
	
+!go_to(A,B):
	pos(X,Y) & 
	X>A
<- 
	do(left);
	!findAll;
	!seen(X,Y).	
	
+!go_to(A,B):
	pos(X,Y) & 
	Y<B 
<- 
	do(down);
	!findAll;
	!seen(X,Y).
	
+!go_to(A,B):
	pos(X,Y) & 
	Y>B
<- 
	do(up);
	!findAll;
	!seen(X,Y).
	
+!go_to(A,B):
	go(A,B) 
<-
	.abolish(go(A,B));
	do(skip).
	
+!go_to(A,B):
	explore(A,B) 
<-
	.abolish(explore(A,B));
	do(skip).
	
+!go_to(A,B) 
<-
	do(skip).

@discover[atomic]
+!discover :  
	grid_size(MaxX,MaxY) 
<- 

	for (.range(X, 1,MaxX-2)) {
	
		for (.range(Y, 1,(MaxY-2)/2)) {  
			if( not explore(X,Y) & not obstacle(X,Y) ) {
				+explore(X,Y)
			};		
		}
		
		for (.range(Y, (MaxY-2)/2,MaxY-2)) {
      		if( not explore(X,Y) & not obstacle(X,Y)  ) { 
				+explore(X,Y)
			};
		}
    }.
 


@seen[atomic]
+!seen(A,B): 
	not glass
<-
	for(.range(CurrX,A-3,A+3)){
		for(.range(CurrY,B-3,B+3)){
			if(explore(CurrX,CurrY)) {
				.abolish(explore(CurrX,CurrY))
			}
		}
	}.
	
@seen2[atomic]
+!seen(A,B): 
	glass
<-
	for(.range(CurrX,A-6,A+6)){
		for(.range(CurrY,B-6,B+6)){
			if(explore(CurrX,CurrY)) {
				.abolish(explore(CurrX,CurrY))
			}
		}
	}.

+!findAll: 
	gold(X,Y) & 
	not goldAt(X,Y) & 
	friendMiddle(Middle) 
<- 
	+goldAt(X,Y); 
	.send(Middle,tell,goldAt(X,Y)).
	
+!findAll: 
	spectacles(X,Y) & 
	not spectaclesAt(X,Y) & 
	not glass 
<-  
	+go(X,Y);  
	+spectaclesAt(X,Y).
	
+!findAll: 
	wood(X,Y) & 
	not woodAt(X,Y) & 
	friendMiddle(Middle) 
<-
	+woodAt(X,Y); 
	.send(Middle,tell,woodAt(X,Y)).
	
+!findAll: 
	obstacle(X,Y) & 
	not obstacleAt(X,Y) & 
	friendMiddle(Middle) 
<-
	+obstacleAt(X,Y); 
	.send(Middle,tell,obstacleAt(X,Y)).
	
+!findAll.
