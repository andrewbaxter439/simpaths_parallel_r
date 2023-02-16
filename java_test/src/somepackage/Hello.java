package somepackage;

public class Hello {
    public static void main(String[] args) {
    System.out.println("Hello, world! From Java :X");
    Calculator calc = new Calculator();
    calc.addUp(new int[]{1, 2, 3});
    SayHi(args);

    }

    public static void SayHi(String[] args) {
    System.out.println("Hello " +  args[0]+ "!");
    }
}
