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
public class Node<E> {
    private final E element;
    private final int cost;

    public Node(E element, int cost) {
        this.element = element;
        this.cost = cost;
    }
        
    public E getElement() {
        return element;
    }

    public int getCost() {
        return cost;
    }
}
