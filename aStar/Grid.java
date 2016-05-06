/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package aStar;

/**
 *
 * @author Speeddrat
 */
public class Grid {
    private final boolean grid[][];
    private final int width;
    private final int heigth;

    public Grid(int width, int heigth) {
        this.width = width;
        this.heigth = heigth;
        this.grid = new boolean[this.width][this.heigth];
        for (int i = 0; i < this.width; i++) {
             for (int j = 0; j < this.heigth; j++) {
                 this.grid[i][j] = true;
             }
        }
    }
    
    public void setObstacle(int x, int y) {
        if (outOfBounds(x, this.width) || outOfBounds(y, this.heigth))
            return;
        grid[x][y] = false;
    }
    
    public void clearObstacle(int x, int y) {
        if (outOfBounds(x, this.width) || outOfBounds(y, this.heigth))
            return;
        grid[x][y] = true;
    }
    
    public boolean getIsFree(int x, int y) {
        if (outOfBounds(x, this.width) || outOfBounds(y, this.heigth))
            return false;
        return grid[x][y];
    }
    
    private boolean outOfBounds(int value, int bound) {
        return (value < 0 || value >= bound);
    }
    
    public static void setWorld6 (Grid g) {
        for (int i = 0; i<5; i++)
            for (int i2 = 0; i2<5; i2++)
                for (int j= 0; j<8; j++) {
                    if((j<3)||(j>4)){
                        g.setObstacle( i*8+j, i2*8); 
                        g.setObstacle( i*8, i2*8+j);
                    }	
                }
    }
    
    public static void setWorld5 (Grid g) {
        for (int i = 0; i<40; i++) {
            if((i<4)||(i>8))
                g.setObstacle( i, 10); 
            if((i<23)||(i>27))
                g.setObstacle( i, 20); 
            if((i<14)||(i>18))
                g.setObstacle( i, 30); 

        }
    }
    
    public static void setWorld2 (Grid g) {
        g.setObstacle( 12, 3);
        g.setObstacle( 13, 3);
        g.setObstacle( 14, 3);
        g.setObstacle( 15, 3);
        g.setObstacle( 18, 3);
        g.setObstacle( 19, 3);
        g.setObstacle( 20, 3);
        g.setObstacle( 14, 8);
        g.setObstacle( 15, 8);
        g.setObstacle( 16, 8);
        g.setObstacle( 17, 8);
        g.setObstacle( 19, 8);
        g.setObstacle( 20, 8);

        g.setObstacle( 12, 32);
        g.setObstacle( 13, 32);
        g.setObstacle( 14, 32);
        g.setObstacle( 15, 32);
        g.setObstacle( 18, 32);
        g.setObstacle( 19, 32);
        g.setObstacle( 20, 32);
        g.setObstacle( 14, 28);
        g.setObstacle( 15, 28);
        g.setObstacle( 16, 28);
        g.setObstacle( 17, 28);
        g.setObstacle( 19, 28);
        g.setObstacle( 20, 28);

        g.setObstacle( 3, 12);
        g.setObstacle( 3, 13);
        g.setObstacle( 3, 14);
        g.setObstacle( 3, 15);
        g.setObstacle( 3, 18);
        g.setObstacle( 3, 19);
        g.setObstacle( 3, 20);
        g.setObstacle( 8, 14);
        g.setObstacle( 8, 15);
        g.setObstacle( 8, 16);
        g.setObstacle( 8, 17);
        g.setObstacle( 8, 19);
        g.setObstacle( 8, 20);

        g.setObstacle( 32, 12);
        g.setObstacle( 32, 13);
        g.setObstacle( 32, 14);
        g.setObstacle( 32, 15);
        g.setObstacle( 32, 18);
        g.setObstacle( 32, 19);
        g.setObstacle( 32, 20);
        g.setObstacle( 28, 14);
        g.setObstacle( 28, 15);
        g.setObstacle( 28, 16);
        g.setObstacle( 28, 17);
        g.setObstacle( 28, 19);
        g.setObstacle( 28, 20);

        g.setObstacle( 13, 13);
        g.setObstacle( 13, 14);

        g.setObstacle( 13, 16);
        g.setObstacle( 13, 17);

        g.setObstacle( 13, 19);
        g.setObstacle( 14, 19);

        g.setObstacle( 16, 19);
        g.setObstacle( 17, 19);

        g.setObstacle( 19, 19);
        g.setObstacle( 19, 18);

        g.setObstacle( 19, 16);
        g.setObstacle( 19, 15);

        g.setObstacle( 19, 13);
        g.setObstacle( 18, 13);

        g.setObstacle( 16, 13);
        g.setObstacle( 15, 13);

        // labirinto
        g.setObstacle( 2, 32);
        g.setObstacle( 3, 32);
        g.setObstacle( 4, 32);
        g.setObstacle( 5, 32);
        g.setObstacle( 6, 32);
        g.setObstacle( 7, 32);
        g.setObstacle( 8, 32);
        g.setObstacle( 9, 32);
        g.setObstacle( 10, 32);
        g.setObstacle( 10, 31);
        g.setObstacle( 10, 30);
        g.setObstacle( 10, 29);
        g.setObstacle( 10, 28);
        g.setObstacle( 10, 27);
        g.setObstacle( 10, 26);
        g.setObstacle( 10, 25);
        g.setObstacle( 10, 24);
        g.setObstacle( 10, 23);
        g.setObstacle( 2, 23);
        g.setObstacle( 3, 23);
        g.setObstacle( 4, 23);
        g.setObstacle( 5, 23);
        g.setObstacle( 6, 23);
        g.setObstacle( 7, 23);
        g.setObstacle( 8, 23);
        g.setObstacle( 9, 23);
        g.setObstacle( 2, 29);
        g.setObstacle( 2, 28);
        g.setObstacle( 2, 27);
        g.setObstacle( 2, 26);
        g.setObstacle( 2, 25);
        g.setObstacle( 2, 24);
        g.setObstacle( 2, 23);
        g.setObstacle( 2, 29);
        g.setObstacle( 3, 29);
        g.setObstacle( 4, 29);
        g.setObstacle( 5, 29);
        g.setObstacle( 6, 29);
        g.setObstacle( 7, 29);
        g.setObstacle( 7, 28);
        g.setObstacle( 7, 27);
        g.setObstacle( 7, 26);
        g.setObstacle( 7, 25);
        g.setObstacle( 6, 25);
        g.setObstacle( 5, 25);
        g.setObstacle( 4, 25);
        g.setObstacle( 4, 26);
        g.setObstacle( 4, 27);
    }
    
}
