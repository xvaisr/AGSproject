/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Astar.Vizualize;
import Astar.Grid;
import Astar.IStack;
import Astar.ImutableStack;
import java.awt.Canvas;
import java.awt.Point;
/**
 *
 * @author Speeddrat
 */
public class Vizualize {
    private static final Vizualize instance = new Vizualize();
    private Window w;
    
    private Vizualize() {
        this.w = new Window();
        Screen s = new Screen(this.getPainter());
        w.setScreen(s);
    }
    
    public static Vizualize getInstance() {
        return instance;
    }
    
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(Window.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(Window.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(Window.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(Window.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                Vizualize instance;
                instance = Vizualize.getInstance();
                instance.run();
            }
        });
    }

    private Painter getPainter() {
        Grid g = new Grid(40, 40);
        IStack<Point> path;// = new ImutableStack();
        Point start, dest;
        
        // Point(x, y);
        start = new Point(6, 27);
        dest = new Point(39, 39);
        
        Grid.setWorld2(g);
        path = Astar.Astar.getPath(start, dest, g);
        
        return new Painter(start, dest, g, path);
        
    }

    private void run() {
        java.awt.EventQueue.invokeLater(this.w);
    }
}
