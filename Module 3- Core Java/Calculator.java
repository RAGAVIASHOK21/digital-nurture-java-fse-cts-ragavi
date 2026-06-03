import java.util.Scanner;

public class Calculator {

    public static void main(String[] args) {

        Scanner sc = new Scanner(System.in);

        System.out.print("Enter first number: ");
        double num1 = sc.nextDouble();

        System.out.print("Enter second number: ");
        double num2 = sc.nextDouble();

        System.out.println("Choose Operation");
        System.out.println("1.Addition");
        System.out.println("2.Subtraction");
        System.out.println("3.Multiplication");
        System.out.println("4.Division");

        int choice = sc.nextInt();

        switch(choice)
        {
            case 1:
                System.out.println("Addition = " + (num1+num2));
                break;

            case 2:
                System.out.println("Subtraction = " + (num1-num2));
                break;

            case 3:
                System.out.println("Multiplication = " + (num1*num2));
                break;

            case 4:
                System.out.println("Division = " + (num1/num2));
                break;

            default:
                System.out.println("Invalid Choice");
        }

        sc.close();
    }
}