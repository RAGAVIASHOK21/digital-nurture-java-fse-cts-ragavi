import java.util.Scanner;

class InvalidAgeException extends Exception {

    InvalidAgeException(String message) {
        super(message);
    }
}

public class InvalidAgeExceptionDemo {

    public static void main(String[] args) {

        Scanner sc = new Scanner(System.in);

        try {

            System.out.print("Enter Age: ");
            int age = sc.nextInt();

            if(age < 18)
            {
                throw new InvalidAgeException(
                        "Age must be 18 or above");
            }

            System.out.println("Eligible");
        }

        catch(InvalidAgeException e) {

            System.out.println(e.getMessage());
        }

        sc.close();
    }
}