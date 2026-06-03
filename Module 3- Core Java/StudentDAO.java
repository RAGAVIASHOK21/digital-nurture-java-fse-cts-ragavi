import java.sql.*;

public class StudentDAO {

    public static void main(String[] args) {

        try {

            Connection con =
            DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/studentdb",
            "root",
            "password");

            PreparedStatement ps =
            con.prepareStatement(
            "INSERT INTO students VALUES(?,?)");

            ps.setInt(1,3);
            ps.setString(2,"Arun");

            ps.executeUpdate();

            PreparedStatement ps2 =
            con.prepareStatement(
            "UPDATE students SET name=? WHERE id=?");

            ps2.setString(1,"Kumar");
            ps2.setInt(2,3);

            ps2.executeUpdate();

            System.out.println(
                    "Insert and Update Successful");

            con.close();
        }

        catch(Exception e)
        {
            System.out.println(e);
        }
    }
}