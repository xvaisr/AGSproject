/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Astar;
import java.awt.Point;
import java.util.ArrayList;

/**
 *
 * @author Speeddrat
 */
public class Astar {
    private static final PriorityQueue<IStack<Point>> openQueue = new PriorityQueue();
    private static final ArrayList<Point> closeList = new ArrayList();
    
    public static IStack<Point> getPath(Point s, Point d, Grid grid) {
        IStack<Point> currentPath = new ImutableStack(s);
        openQueue.add(0, currentPath);
        
        while (!openQueue.empty()) {
            IStack<Point> generated;
            currentPath = openQueue.pull();
            
            Point p = currentPath.getPeek();
            
            boolean contain = false;
            for(Point q : closeList){
                if (p.equals(q)) {
                    contain = true;
                    break;
                }
            }
            
            if (contain) {
                continue;
            }
            if (p.equals(d)) {
                return currentPath;
            }
            closeList.add(p);
            
            for (int i = 0; i < 3; i++) {
                for (int j = 0; j < 3; j++) {
                    int dx, dy;
                    dx = i-1;
                    dy = j-1;
                    
                    // podminka umoznuje zmenu jen jedne souradnice
                    if (Math.abs(dx + dy) != 1) {
                        continue;
                    }
                    
                    Point q = p.getLocation();
                    q.translate(dx, dy);
                    
                    if (!grid.getIsFree(q.x, q.y)) {
                        continue;
                    }
                    
                    generated = currentPath.push(q);
                    openQueue.add(getCost(generated, d), generated);
                }
            }
        }
        
        return currentPath;
    }
    
    private static int getCost(IStack<Point> path, Point d) {
        Point s = path.getPeek();
        int x = d.x - s.x;
        int y = d.y - s.y;
        double distance = Math.sqrt(x*x + y*y);
        
        return path.getSize() + (int) Math.round(distance);
    }
    
}
