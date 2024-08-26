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
import java.sql.SQLException;
import java.sql.Statement;

@WebServlet("/open-api")
public class DelTable extends HttpServlet {
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
        createDatabase(out);

        // 테이블이 이미 있으면 삭제하고 새로 생성
        createOrReplaceTable(out);

        out.println("Database and table setup completed successfully.<br>");
    }

    private void createDatabase(PrintWriter out) {
        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             Statement statement = connection.createStatement()) {
            String sql = "CREATE DATABASE IF NOT EXISTS " + DB_NAME;
            statement.executeUpdate(sql);
            out.println("Database '" + DB_NAME + "' created or already exists.<br>");
        } catch (SQLException e) {
            out.println("Error creating database '" + DB_NAME + "'.<br>");
            e.printStackTrace(out);
        }
    }

    private void createOrReplaceTable(PrintWriter out) {
        String dbUrlWithDbName = DB_URL + "/" + DB_NAME + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";

        try (Connection connection = DriverManager.getConnection(dbUrlWithDbName, DB_USER, DB_PASSWORD);
             Statement statement = connection.createStatement()) {
            String sql = "DROP TABLE IF EXISTS location_data";
            statement.executeUpdate(sql);
            out.println("Table 'location_data' dropped if existed.<br>");

            sql = "CREATE TABLE location_data (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "distance_num DOUBLE, " +
                    "wifi VARCHAR(255) NOT NULL, " +
                    "area VARCHAR(255) NOT NULL, " +
                    "wifi_name VARCHAR(255) NOT NULL, " +
                    "address VARCHAR(255) NOT NULL, " +
                    "detail_address VARCHAR(255), " +
                    "floor VARCHAR(255), " +
                    "wifi_type VARCHAR(255), " +
                    "wifi_organ VARCHAR(255), " +
                    "service VARCHAR(255), " +
                    "mesh VARCHAR(255), " +
                    "install_year VARCHAR(255), " +
                    "in_out VARCHAR(255), " +
                    "connect VARCHAR(255), " +
                    "X DOUBLE NOT NULL, " +
                    "Y DOUBLE NOT NULL, " +
                    "work_year VARCHAR(255)" +
                    ")";
            statement.executeUpdate(sql);
            out.println("Table 'location_data' created successfully.<br>");
        } catch (SQLException e) {
            out.println("Error creating or replacing table 'location_data'.<br>");
            e.printStackTrace(out);
        }
    }
}