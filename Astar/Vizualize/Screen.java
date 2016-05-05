/**
 * Thesis project, BP, anthill strategy game refactored
 *
 * @author  Roman Vais, xvaisr00
 * @date    2015/05/27
 */
package Astar.Vizualize;

import java.awt.Canvas;
import java.awt.Graphics;
import java.awt.Toolkit;
import java.awt.image.BufferStrategy;

public class Screen extends Canvas implements Runnable {   // constants
    private static final int bufferSize = 4;
    private static final int framerate = 60;
    private static final int sec2ms = 1000;
    private static final int sleepTimeMs = sec2ms / framerate;
    
    // Print runtime statistic (frame rate) to console
    private static final boolean verbose = true;
    
    private static volatile long lastFrame = 0;

    // drawing and windoew
    private Window window;
    private Thread thread;

    // curent state
    private volatile boolean run;
    private boolean inProgress;
    private volatile int frames;
    private volatile int fps;
    private Painter painter;
    
    
    public Screen(Painter p) {
        super();
        this.setIgnoreRepaint(true);
        this.thread = new Thread(this, "repaint");
        this.window = null;
        this.painter = p;
        this.inProgress = false;
        this.run = false;
        
        this.frames = 0;
        this.fps = 0;
        
    }
    
    public void setWindow(Window w) {
        if (w == null) {
            throw new NullPointerException("Window parametr must not be NULL!");
        }
        this.window = w;
    }
    
    public void init() {
        this.run = true;
        this.createBufferStrategy(bufferSize);
    }
    
    public int getFPS() {
        return this.fps;
    }
    
    public static int getDelta() {
        long currentTime = System.currentTimeMillis();
        return (int) (currentTime - lastFrame);
    }
    
    public void render () {
        boolean progress;
        synchronized(this) {
            progress = this.inProgress;
        }
        if (progress) {
            return;
        }
        Graphics g = null;
        BufferStrategy buffer = this.getBufferStrategy();
        try {
            synchronized(this) {
               this.inProgress = true;
            }
            g = buffer.getDrawGraphics();
            this.painter.paintContent(g);
        }
        finally {
            this.frames++;
            if (g != null) {
                g.dispose();
            }
            buffer.show();
            Toolkit.getDefaultToolkit().sync(); 
            synchronized(this) {
               this.inProgress = false;
            } 
        }
        
    }
    
    /**
     * Method starts thread handleing drawing loop 
     */
    void start() {
        if (this.window == null) {
            return;
        }
        this.init();
        this.requestFocus();
        this.thread.start();
    }
    
    /**
     * Method drops running-flag so drawing loop ends after finising last cycle 
     */
    private void stop() {
        synchronized(this) {
            this.run = false;
        }
    }

    @Override
    public void run() {
        long stFrame, now, delta;
        boolean running = true;
        
        if (!run) {
            return;
        }
        now = System.currentTimeMillis();
        stFrame = now;
        
        int avgrender, avgsleep;
        
        avgrender = 0;
        avgsleep = 0;
        
        // main draw loop
        while (running) {
            
            // rendering content and getting execution time
            lastFrame = now;
            this.render();
            now = System.currentTimeMillis();
            
            // getting execution lenght so game is fluent and not locked on framerate
            delta = now - lastFrame;
            avgrender += delta;
            
            // if we are fast sleep a while, no need to draw more
            if (delta < sleepTimeMs) {
                try {
                    avgsleep += sleepTimeMs - delta;
                    Thread.sleep(sleepTimeMs - delta);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
            
            // evaluating framerate
            if (System.currentTimeMillis() - stFrame >= sec2ms) {
                stFrame += sec2ms;
                this.fps = this.frames;
                avgrender = (avgrender/frames);
                avgsleep = (avgsleep/frames);
                if (verbose) {
                    System.out.println("Repaint:" + frames + " frames, " + avgrender + " ms avg render, " + avgsleep + " ms avg sleep");
                }
                frames = 0;
            }
            
            // checking if we should continue or stop the loop ...
            synchronized(this) {
                running = this.run;
            }
        }
    }
   
}
