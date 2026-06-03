import java.sql.*;

public class TransactionExample {

    public static void main(String[] args) {

        try {

            Connection con =
            DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/studentdb",
            "root",
            "password");

            con.setAutoCommit(false);

            PreparedStatement ps1 =
            con.prepareStatement(
            "UPDATE accounts SET balance=balance-1000 WHERE id=1");

            PreparedStatement ps2 =
            con.prepareStatement(
            "UPDATE accounts SET balance=balance+1000 WHERE id=2");

            ps1.executeUpdate();
            ps2.executeUpdate();

            con.commit();

            System.out.println(
                    "Transaction Successful");
        }

        catch(Exception e)
        {
            System.out.println(e);
        }
    }
}