/* beliefbase */

discovered(false).
inc(X,Y)	:-	Y = X+1.
inc2(X,Y)	:-	Y = X+2.
dec(X,Y)	:-	Y = X-1.
dec2(X,Y)	:-	Y = X-2.
/* initial goals */

!start. 

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


    
+!go_to(A,B):  
    true 
<-  
    while(pos(X,Y) & ( A\==X | B\==Y )){
        while(moves_left(Moves) & Moves\==0 & pos(CurrX,CurrY) & ( A\==CurrX | B\==CurrY )){ 
            if( A \== CurrX ){ 
                if( A > CurrX ){ 
                    do(right); 
                }else{ 
                    do(left);
                }//if-else
            }else {
                if(B\==CurrY){ 
                    if( B > CurrY) { 
                        do(down);
                    }else { 
                        do(up);
                    }//if-else
                }//if-else
            }//if-else
            if( discovered(IsIt) & IsIt \== true ){
                !check_area;
            }
        }//while
    }//while
    if( moves_left(C) & C > 0 ){
        do(skip); 
        if( C > 1 ){ do(skip); }
        if( C > 2 ){ do(skip); }
    }//if 
    .
//end of go_to
    
                      

	
                                            
//At depot, deposit or wait for next round
+!depos: 
    pos(X,Y) &
    depot(DX,DY) &
    moves_left(Mov) &
    moves_per_round(Total) &
    X==DX &
    Y==DY
<-  if ( Mov==Total){
        do(drop);
    }else{
        while (moves_left(A) & A\==0) {
            do(skip);
        }//while
        !depos
    }//if
    .
//end of depos


+!depos: 
    pos(X,Y) &
    depot(DX,DY) &
    X\==DX &
    Y\==DY 
<- 
    !go_toB(DX,DY);
    !depos.
//end of depos                                          

+!depos:
    true
<-
    .print("This shouldn't happen to be honest");
    .
                                                                    
+!collect: 
    pos(X,Y) &
    wood_at(WoodX,WoodY) &
    //ally(A,B) &
    WoodX==X &
    WoodY==Y &  
    moves_left(Moves) &
    Moves==3 
<-
    do(pick); 
    .abolish(wood_at(WoodX,WoodY));
    if (carrying_capacity(Carry) & carrying_wood(Wood) & Carry == Wood ) {
        !depos;
    }//if
    !collect.
//print end of collect

+!collect: 
    pos(X,Y) & 
    wood_at(WoodX,WoodY) & 
    X==WoodX &
    Y==WoodY 
<-
    while (moves_left(A) & A\==0) {
            do(skip);
    }//while
    !collect.
//print end of collect

+!collect: 
    pos(X,Y) & 
    wood_at(WoodX,WoodY)
<-
    !go_toB(WoodX,WoodY);
    !collect.   
//print end of collect

+!collect: 
    pos(X,Y) &
    gold_at(GoldX,GoldY) & 
    GoldX == X &
    GoldY == Y &
    moves_left(Moves) &
    Moves==3
<- 
    do(pick); 
    .abolish(gold_at(GoldX,GoldY));
    if( carrying_capacity(Carry) & carrying_gold(Gold) & Carry == Gold ){ 
        !depos; 
    }
    !collect.
//print end of collect

+!collect:
    pos(X,Y) &
    gold_at(GoldX,GoldY) &
    X==GoldX & 
    Y==GoldY  
<-  
    while ( moves_left(A) & A\==0 ) {
        do(skip);
    }//while
    !collect.   
//print end of collect
                                                        
+!collect: 
    pos(X,Y) &
    gold_at(GoldX,GoldY)
<- 
    if( carrying_wood(Gold) & Gold\==0 ){
        !depos;
    }
    !go_toB(GoldX,GoldY);
    !collect.
//print end of collect

+!collect: 
    true 
<- 
    .print("Collecting done");.
//print end of collect
                         

+!check_area: 
    pos(X,Y) &
    gold(A,B) 
<- 
    Left    =   X-1; 
    Right   =   X+1;
    Top     =   Y+1;
    Bottom  =   Y-1;
//add the 8 cells around you to the BB
    +seen(Left,Top);    +seen(X,Top);       +seen(Right,Top);
    +seen(Left,Y);                          +seen(Right,Y);
    +seen(Left,Bottom); +seen(X,Bottom);    +seen(Right,Bottom);
    +gold_at(A,B);.
//end of check_area


+!check_area: 
    pos(X,Y) &
    wood(A,B) 
<-
    Left    =   X-1; 
    Right   =   X+1;
    Top     =   Y+1;
    Bottom  =   Y-1;
//add the 8 cells around you to the BB
    +seen(Left,Top);    +seen(X,Top);       +seen(Right,Top);
    +seen(Left,Y);                          +seen(Right,Y);
    +seen(Left,Bottom); +seen(X,Bottom);    +seen(Right,Bottom);
    +wood_at(A,B);  .
//end of check_area


+!check_area: 
    pos(X,Y) 
<-
    Left    =   X-1; 
    Right   =   X+1;
    Top     =   Y+1;
    Bottom  =   Y-1;
    +seen(Left,Top);    +seen(X,Top);       +seen(Right,Top);
    +seen(Left,Y);                          +seen(Right,Y);
    +seen(Left,Bottom); +seen(X,Bottom);    +seen(Right,Bottom);.
//end of check_area

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
                      
                             
