// Internal action code for project jasonTeam.mas2j



package aStar;



import jason.*;
import jason.asSemantics.Unifier;
import jason.asSyntax.Term;
import jason.asSemantics.*;
import aStar.Grid;
import jason.asSyntax.*;
import java.awt.Point;
import java.util.HashMap;
import java.util.Iterator;
import java.util.ArrayList;
import java.util.Collections;
import jason.asSyntax.ListTerm;
import jason.asSyntax.ListTermImpl;
import jason.asSyntax.StringTermImpl;

public class road_to extends DefaultInternalAction {
	
	
	private static HashMap<String, Grid> h = new HashMap();
	
    @Override
	
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
		
		//System.gc();
        // execute the internal action
		//road_to(Sx, Sy, Dx, Dy, K, L)
        //ts.getAg().getLogger().info("executing internal action 'aStar.road_to'");
		int x = (int)((NumberTerm) args[0]).solve();
		int y = (int)((NumberTerm) args[1]).solve();
		
		Point s = new Point(x,y);
		
		//System.out.println("Start X " + args[0]);
		//System.out.println("Start Y " + args[1]);
		//System.out.println("Goal X " + args[2]);
		//System.out.println("Goal Y " + args[3]);
		//System.out.println("Number of moves " + args[4]);
		 x = (int)((NumberTerm) args[2]).solve();
		 y = (int)((NumberTerm) args[3]).solve();
		
		Point d = new Point(x,y);
		
		String agent = ts.getUserAgArch().getAgName();
		Grid grid1;
		if(!road_to.h.containsKey(agent))
		{	
			int sizeX = 0;
			int sizeY = 0;
			try{
				Literal pattern = Literal.parseLiteral("grid_size(_,_)");	
				Iterator<Literal> i = ts.getAg().getBB().getCandidateBeliefs(pattern, un);
				ListTerm result = new ListTermImpl();	
				Literal l = i.next();
				Term[] term2 = l.getTermsArray();
				sizeX = (int)((NumberTerm) term2[0]).solve();
				sizeY = (int)((NumberTerm) term2[1]).solve();
				
			}catch (Exception e){
				
				return false;
				//logger.warning("Error in internal action 'get_rules'! "+e);
			}	
			grid1 = new Grid(sizeX,sizeY);
			//System.out.println("adding to hashmap");
			road_to.h.put(agent,grid1);
		}
		else {
		
		grid1 = road_to.h.get(agent);
		}
				
		try {
            Literal pattern = Literal.parseLiteral("obstacle_at(_,_)");
			
			//String obstacleXY = ((StringTerm)pattern).getString();
            Iterator<Literal> i = ts.getAg().getBB().getCandidateBeliefs(pattern, un);
			
            ListTerm result = new ListTermImpl();
			
            while (i!= null && i.hasNext()) {
                Literal l = i.next();
				String functor;
				
				functor = l.getFunctor();
				if(!functor.equals("obstacle_at") )
				{
					continue;
				}
				Term[] term = l.getTermsArray();
				int obstacleX = (int)((NumberTerm) term[0]).solve();
				int obstacleY = (int)((NumberTerm) term[1]).solve();
				grid1.setObstacle(obstacleX,obstacleY);

			}
			//System.out.println("get here " + agent);
			IStack<Point> path;
			path = aStar.getPath(s, d, grid1);
			//System.out.println("Top of path" + path.getPeek());
			
			while(path.getTop() > (int)((NumberTerm) args[4]).solve()) {
				//System.out.println("Top of path" + path.getPeek());
				path = path.pop();
			}
			ArrayList<Point> newpath = path.toArrayList();
			
			Collections.reverse(newpath);
			//System.out.println("Top of path" + path.getPeek());
			//System.out.println(newpath);
			ListTerm res = new ListTermImpl();
			Point start = null;
			for ( Point item : newpath ){
				if(start == null){
					start = item;	
				}else{
					if( item.x > start.x){
						res.add(new StringTermImpl("right"));	
					}else if( item.x < start.x){
						res.add(new StringTermImpl("left"));	
					}else if ( item.y > start.y){
						res.add(new StringTermImpl("down"));
					}else if( item.y < start.y){
						res.add(new StringTermImpl("up"));	
					}
				}
			}
	
			
			
            return un.unifies(args[5],res);
			
			} catch (Exception e) {
			e.printStackTrace();
			return false;
            //logger.warning("Error in internal action 'get_rules'! "+e);
		}
        
		
		
        
	}
	
}


