package com.example.demo;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

@WebServlet("/location-api")
public class CreateLocation extends HttpServlet { // table 삭제
    private static final String DB_URL = "jdbc:mysql://localhost:3306";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "user";
    private static final String DB_NAME = "console";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            out.println("MySQL Driver loaded successfully<br>");
        } catch (ClassNotFoundException e) {
            out.println("MySQL Driver not found<br>");
            e.printStackTrace(out);
            return;
        }

        // 데이터베이스가 없으면 생성
        createLocation(out);
    }

    public static void createLocation(PrintWriter out) {
        try (Connection connection = DriverManager.getConnection(DB_URL + "/" + DB_NAME + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", DB_USER, DB_PASSWORD);
             Statement statement = connection.createStatement()) {
            String sql = "DROP TABLE IF EXISTS mylocation_data";
            statement.executeUpdate(sql);

            statement.execute("USE " + DB_NAME); // 데이터베이스 선택

            sql = "CREATE TABLE IF NOT EXISTS mylocation_data ( " +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "X VARCHAR(255) NOT NULL, " +
                    "Y VARCHAR(255) NOT NULL, " +
                    "today VARCHAR(255) DEFAULT '' " +
                    ")";

            statement.executeUpdate(sql);
        } catch (Exception e) {
            out.println("Error executing SQL file~~~~~~~~~");
            e.printStackTrace(out);
        }
    }
}
