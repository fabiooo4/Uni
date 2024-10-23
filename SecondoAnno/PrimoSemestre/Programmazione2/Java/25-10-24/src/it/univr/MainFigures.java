package it.univr;

import it.univr.figures.*;

public class MainFigures {
    public static void main(String[] args) {
        Rectangle r = new Rectangle(3,4, Color.RED);
        System.out.println(r);

        Square s = new Square(5, Color.BLUE);
        System.out.println(s);

        Circle c = new Circle(7, Color.YELLOW);
        System.out.println(c);

        GreenDot d = new GreenDot();
        System.out.println(d);
    }
}
