/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Astar;

import java.util.ArrayList;

/**
 *
 * @author Speeddrat
 * @param <E>
 */
public interface IStack<E> {
    public int getSize();
    public int getTop();
    public boolean empty();
    public E getPeek();
    public IStack<E> pop();
    public IStack<E> push(E element);
    public ArrayList<E> toArrayList();
    
}
