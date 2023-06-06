package somepackage;

public class Calculator {
    public static int addUp(int[] numbers) throws InterruptedException {
        int solution = 0;
        for (int num : numbers) {
            solution += num;
        }
        Thread.sleep(1000);
        return solution;
    }

}
