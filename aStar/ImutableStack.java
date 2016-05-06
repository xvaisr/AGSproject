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
 */
public class ImutableStack<E> implements IStack<E>{
    private final ArrayList<IStack<E>> list;
    private final E element;
    private final int index;
    private final int top;

    public ImutableStack() {
        this.list = new ArrayList();
        this.element = null;
        this.index = -1;
        this.top = -1;
        this.list.add(this);
    }
    
    public ImutableStack(E element) {
        this.list = new ArrayList();
        this.element = element;
        IStack prev = new ImutableStack(this.list, null, -1);
        this.list.add(prev);
        this.index = this.list.size() - 1;
        this.top = list.get(this.index).getTop() + 1;
        this.list.add(this);
    }
    
    private ImutableStack(ArrayList<IStack<E>> list, E element, int i) {
        this.list = list;
        this.element = element;
        this.index = i;
        this.top = ((i < 0)? -1 : list.get(this.index).getTop() + 1);
        this.list.add(this);
    }

    @Override
    public int getSize() {
        return this.index;
    }
    
    @Override
    public int getTop() {
        return this.top;
    }

    @Override
    public boolean empty() {
        return this.top < 0;
    }

    @Override
    public E getPeek() {
        return this.element;
    }

    @Override
    public IStack<E> pop() {
        return this.list.get(this.index);
    }

    @Override
    public IStack<E> push(E element) {
        return new ImutableStack(this.list, element, this.list.indexOf(this));
    }

    @Override
    public ArrayList<E> toArrayList() {
        ArrayList<E> array = new ArrayList(this.getSize());
        IStack<E> tmp = this;
        while (!tmp.empty()) {
            array.add(tmp.getPeek());
            tmp = tmp.pop();
        }
        return array;
    }

}
