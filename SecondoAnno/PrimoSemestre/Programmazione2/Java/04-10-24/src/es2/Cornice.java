package es2;

public class Cornice extends Disegni {
    private static char border = '@';
    private static char area = ' ';

    public static void stampa(int n) {
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                if (i == 0 || i == n - 1) {
                    System.out.print(border);
                } else if (j == 0 || j == n-1) {
                    System.out.print(border);
                } else {
                    System.out.print(area);
                }
            }
            System.out.println();
        }
    }

    public static void setBorder(char border) {
        Cornice.border = border;
    }

    public static void setArea(char area) {
        Cornice.area = area;
    }

    public static char getBorder() {
        return border;
    }

    public static char getArea() {
        return area;
    }

}
