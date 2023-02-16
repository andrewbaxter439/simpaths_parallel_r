package somepackage;

public class Calculator {
    public static int addUp(int[] numbers) {
        int solution = 0;
        for (int num : numbers) {
            solution += num;
        }

        return solution;
    }
}
