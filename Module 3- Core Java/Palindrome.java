import java.util.Scanner;

public class Palindrome {

    public static void main(String[] args) {

        Scanner sc = new Scanner(System.in);

        System.out.print("Enter String: ");
        String str = sc.nextLine();

        str = str.replaceAll("[^a-zA-Z0-9]","").toLowerCase();

        String reverse =
                new StringBuilder(str).reverse().toString();

        if(str.equals(reverse))
        {
            System.out.println("Palindrome");
        }
        else
        {
            System.out.println("Not Palindrome");
        }

        sc.close();
    }
}