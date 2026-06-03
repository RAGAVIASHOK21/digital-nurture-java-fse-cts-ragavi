import java.util.Scanner;
import java.util.Random;

public class GuessGame {

    public static void main(String[] args) {

        Scanner sc = new Scanner(System.in);
        Random rand = new Random();

        int randomNumber = rand.nextInt(100) + 1;
        int guess = 0;

        while(guess != randomNumber)
        {
            System.out.print("Guess Number (1-100): ");
            guess = sc.nextInt();

            if(guess > randomNumber)
            {
                System.out.println("Too High!");
            }
            else if(guess < randomNumber)
            {
                System.out.println("Too Low!");
            }
            else
            {
                System.out.println("Correct Guess!");
            }
        }

        sc.close();
    }
}