package somepackage;

import java.io.BufferedOutputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.PrintStream;

public class Hello {
    public static void main(String[] args) throws InterruptedException, FileNotFoundException {
        System.setOut(new PrintStream(new BufferedOutputStream(new FileOutputStream("file.txt")), true));
        System.out.println("Hello, world! From Java :X");
        SayHi(args);

    }

    public static void SayHi(String[] args) {
    System.out.println("Hello " +  args[0]+ "!");
    }
}
