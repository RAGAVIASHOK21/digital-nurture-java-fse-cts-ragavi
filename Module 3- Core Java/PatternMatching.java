public class PatternMatching {

    public static void main(String[] args) {

        Object obj = "Hello";

        String result =
                switch(obj)
                {
                    case Integer i ->
                        "Integer : " + i;

                    case String s ->
                        "String : " + s;

                    case Double d ->
                        "Double : " + d;

                    default ->
                        "Unknown Type";
                };

        System.out.println(result);
    }
}