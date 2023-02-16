package somepackage;

public class Hello {
    public static void main(String[] args) {
    System.out.println("Hello, world! From Java :X");
    SayHi(args);
    }
    
    public static void SayHi(String[] args) {
    System.out.println("Hello " +  args[0]+ "!");
    }
}
