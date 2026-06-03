class Student {

    public void display() {

        System.out.println(
                "Reflection Method Called");
    }
}

public class ReflectionExample {

    public static void main(String[] args)
            throws Exception {

        Class<?> cls =
                Class.forName("Student");

        Object obj =
                cls.getDeclaredConstructor()
                .newInstance();

        java.lang.reflect.Method method =
                cls.getDeclaredMethod(
                "display");

        method.invoke(obj);
    }
}