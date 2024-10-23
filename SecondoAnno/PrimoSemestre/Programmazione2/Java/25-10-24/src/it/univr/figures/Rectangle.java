package it.univr.figures;

public class Rectangle extends Figure{
    private double base;
    private double height;

    public Rectangle(double base, double height, Color color) {
        super(color);
        this.base = base;
        this.height = height;
    }

    @Override
    public double perimeter() {
        return 2 * base + 2 * height;
    }

    @Override
    public double area() {
        return base * height;
    }

    @Override
    public String toString() {
        return "Rectangle with: \n" + super.toString();
    }
}
