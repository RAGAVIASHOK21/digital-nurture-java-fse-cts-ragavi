public class VirtualThreadExample {

    public static void main(String[] args)
            throws Exception {

        for(int i=1;i<=10;i++)
        {
            int num = i;

            Thread.startVirtualThread(() -> {

                System.out.println(
                        "Virtual Thread "
                        + num);
            });
        }

        Thread.sleep(1000);
    }
}