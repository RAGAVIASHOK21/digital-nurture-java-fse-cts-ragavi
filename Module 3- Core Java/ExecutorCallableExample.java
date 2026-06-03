import java.util.concurrent.*;

public class ExecutorCallableExample {

    public static void main(String[] args)
            throws Exception {

        ExecutorService executor =
                Executors.newFixedThreadPool(2);

        Callable<Integer> task1 =
                () -> 10 + 20;

        Callable<Integer> task2 =
                () -> 50 + 50;

        Future<Integer> result1 =
                executor.submit(task1);

        Future<Integer> result2 =
                executor.submit(task2);

        System.out.println(
                "Result 1 = "
                + result1.get());

        System.out.println(
                "Result 2 = "
                + result2.get());

        executor.shutdown();
    }
}