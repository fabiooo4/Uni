package it.univr.figures;

public class Figure {
    private Color color;

    public Figure(Color color) {
        this.color = color;
    }

    public double perimeter() {
        return 0;
    }

    public double area() {
        return 0;
    }

    public String toString() {
        return "Area: " + area() + "\n" +
               "Perimeter: " + perimeter() + "\n" +
               "Color: " + getColor()+ "\n";
    }

    protected Color getColor() {
        return color;
    }
}
