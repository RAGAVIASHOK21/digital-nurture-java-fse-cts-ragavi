import java.util.HashMap;

public class HashMapExample {

    public static void main(String[] args) {

        HashMap<Integer,String> map =
                new HashMap<>();

        map.put(101,"Ravi");
        map.put(102,"Priya");
        map.put(103,"Arun");

        System.out.println(map);

        System.out.println(
                "Student 101 = " +
                map.get(101));
    }
}