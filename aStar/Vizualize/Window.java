/**
 * Thesis project, BP, anthill strategy game refactored
 *
 * @author  Roman Vais, xvaisr00
 * @date    2015/05/27
 */

package aStar.Vizualize;

import java.awt.Dimension;
import java.awt.event.WindowEvent;
import java.awt.event.WindowListener;
import javax.swing.JFrame;
import javax.swing.WindowConstants;

public class Window extends JFrame implements Runnable, WindowListener {
    private static final String TITLE = "A* vizualization";
    public static final int MIN_HEIGHT = 500;
    public static final int MIN_WIDTH = 500;
    private Screen screen;
    

    public Window() {
        super(TITLE);
    }
    
    public void setScreen(Screen screen) {
        if (screen == null) {
            throw new NullPointerException("Screen parametr must not be NULL!");
        }
        this.screen = screen;
        this.screen.setWindow(this);
        this.init();
    }    
    private void init() {
        this.addWindowListener(this);
        Dimension size = new Dimension(MIN_WIDTH, MIN_HEIGHT);
        
        this.screen.setMinimumSize(size);
        this.screen.setPreferredSize(size);
        this.add(this.screen);
        
        this.setMinimumSize(size);
        this.setPreferredSize(size);
        this.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        this.setLocationRelativeTo(null);
        pack();        
    }

    @Override
    public void run() {
        if (this.screen == null) {
            return;
        }
        this.setVisible(true);
    }

    @Override
    public void windowOpened(WindowEvent e) {
        this.screen.start();
    }

    @Override
    public void windowClosing(WindowEvent e) {}

    @Override
    public void windowClosed(WindowEvent e) {}

    @Override
    public void windowIconified(WindowEvent e) {}

    @Override
    public void windowDeiconified(WindowEvent e) {}

    @Override
    public void windowActivated(WindowEvent e) {}

    @Override
    public void windowDeactivated(WindowEvent e) {}
}
