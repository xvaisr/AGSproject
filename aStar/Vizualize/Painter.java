/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package aStar.Vizualize;

import aStar.Grid;
import aStar.IStack;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.Point;

/**
 *
 * @author Speeddrat
 */
class Painter {
    private final Color[][] colorGrid = new Color[40][40];
    private static final Color GRID = Color.BLACK;
    private static final Color OBSTACLE = Color.GRAY;
    private static final Color FREE = Color.WHITE;
    private static final Color START = Color.BLUE;
    private static final Color DESTINATION = Color.RED;
    private static final Color PATH = Color.GREEN;
    private static final int SIZE = 10;

    public Painter(Point start, Point destination, Grid grid, IStack<Point> path) {
        for (int x = 0; x < 40; x++) {
            for (int y = 0; y < 40; y++) {
                if (!grid.getIsFree(x, y))
                    colorGrid[x][y] = OBSTACLE;
                else colorGrid[x][y] = FREE;
            }
        }
        
        while(!path.empty()) {
            Point p = path.getPeek();
            colorGrid[p.x][p.y] = PATH;
            path = path.pop();
        }
        
        colorGrid[start.x][start.y] = START;
        colorGrid[destination.x][destination.y] = DESTINATION;
    }
    
    

    void paintContent(Graphics g) {
        g.setColor(FREE);
        g.fillRect(0, 0, 500, 500);
        
        
        g.setColor(GRID);
        
        for (int i = 0; i <= 40; i++) {
            int x = i*11;    
            g.drawLine(x, 0, x, 440);
        }
        
        for (int i = 0; i <= 40; i++) {
            int y = i*11;    
            g.drawLine(0, y, 440, y);
        }
        
        for (int x = 0; x < 40; x++) {
            for (int y = 0; y < 40; y++) {
                Color c = colorGrid[x][y];
                if (c != Color.WHITE) {
                    g.setColor(c);
                    g.fillRect(x*(SIZE + 1), y*(SIZE + 1), SIZE, SIZE);
                }                    
            }
        }
        
    }
    
}
