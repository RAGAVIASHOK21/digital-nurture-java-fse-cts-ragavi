import java.util.List;

record Person(
        String name,
        int age) {}

public class RecordExample {

    public static void main(String[] args) {

        List<Person> list = List.of(
                new Person("Ravi",20),
                new Person("Priya",17),
                new Person("Arun",25));

        list.stream()
            .filter(p -> p.age() >= 18)
            .forEach(System.out::println);
    }
}