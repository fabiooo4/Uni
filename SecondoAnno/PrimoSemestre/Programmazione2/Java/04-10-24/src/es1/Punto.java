package es1;

import java.util.Random;

public class Punto {
    public double x;
    public double y;

    Punto() {
        Random rand = new Random();
        x = rand.nextDouble(-1,1);
        y = rand.nextDouble(-1,1);
    }

    // Debug
    Punto(double x, double y) {
        this.x = x;
        this.y = y;
    }

    public boolean isInCircle(double radius) {
        return Math.sqrt((this.x * this.x) + (this.y * this.y)) - radius <= 0;
    }
}
