package it.univr.figures;

public class Square extends Rectangle{

    public Square(double length, Color color) {
        super(length, length, color);
    }

    @Override
    public String toString() {
        return "Square " + super.toString();
    }
}
