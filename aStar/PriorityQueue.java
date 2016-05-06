/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package aStar;

import java.util.ArrayList;

/**
 *
 * @author Speeddrat
 * @param <E>
 */
public class PriorityQueue<E> {
    private final ArrayList<Node<E>> queue;

    public PriorityQueue() {
        this.queue = new ArrayList();
    }
    
    public void add(int priority, E element) {
        Node<E> n = new Node(element, priority);
        boolean added = false;
        for (int i = 0; i < this.queue.size(); i++) {
            if (this.queue.get(i).getCost() > priority) {
                this.queue.add(i, n);
                added = true;
                break;
            }
        }
        if (!added) {
            this.queue.add(n);
        }
    }
    
    public boolean empty() {
        return this.queue.isEmpty();
    }
    
    public E pull() {
        return this.queue.remove(0).getElement();
    }
}
