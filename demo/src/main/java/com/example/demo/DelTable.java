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

public class DelTable extends HttpServlet { // table 삭제
    private static final String DB_URL = "jdbc:mysql://localhost:3306/console?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "user";
    private static final String DB_NAME = "console";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        deltable(out);

        out.println("Table deletion executed successfully.");
    }

    public static void deltable(PrintWriter out) {
        Connection conn = null;
        Statement stmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            out.println("MySQL Driver not found");
            e.printStackTrace(out);
            return;
        }

        try {
            // 데이터베이스 연결
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            stmt = conn.createStatement();

            // 존재하는 데이터베이스 확인
            ResultSet resultSet = conn.getMetaData().getCatalogs();
            boolean dbExists = false;
            while (resultSet.next()) {
                String databaseName = resultSet.getString(1);
                if (databaseName.equalsIgnoreCase(DB_NAME)) {
                    dbExists = true;
                    break;
                }
            }
            resultSet.close();

            if (!dbExists) { // 데이터베이스가 없는 경우에만 생성 및 사용
                stmt.execute("CREATE DATABASE IF NOT EXISTS " + DB_NAME);
            } else { // 데이터베이스가 있는 경우에 삭제하고 생성 및 사용
                stmt.execute("Drop DATABASE IF EXISTS " + DB_NAME);
                stmt.execute("CREATE DATABASE " + DB_NAME);
            }
            stmt.execute("USE " + DB_NAME); // 데이터베이스 선택
            stmt.execute("DROP TABLE IF EXISTS location_data");
            stmt.execute("CREATE TABLE IF NOT EXISTS location_data ( " +
                    "id INT AUTO_INCREMENT PRIMARY KEY NOT NULL, " +
                    "distance_num VARCHAR(255) DEFAULT '', " +
                    "wifi VARCHAR(255) NOT NULL, " +
                    "area VARCHAR(255) NOT NULL, " +
                    "wifi_name VARCHAR(255) NOT NULL, " +
                    "address VARCHAR(255) NOT NULL, " +
                    "detail_address VARCHAR(255) DEFAULT '', " +
                    "floor VARCHAR(255) DEFAULT '', " +
                    "wifi_type VARCHAR(255) DEFAULT '', " +
                    "wifi_organ VARCHAR(255) DEFAULT '', " +
                    "service VARCHAR(255) DEFAULT '', " +
                    "mesh VARCHAR(255) DEFAULT '', " +
                    "install_year VARCHAR(255) DEFAULT '', " +
                    "in_out VARCHAR(255) DEFAULT '', " +
                    "connect VARCHAR(255) DEFAULT '', " +
                    "X VARCHAR(255) NOT NULL, " +
                    "Y VARCHAR(255) NOT NULL, " +
                    "work_year VARCHAR(255) DEFAULT ''" +
                    ")");

            out.println("SQL file executed successfully.");
        } catch (Exception e) {
            out.println("Error executing SQL file..!!!!!!!!!!!!");
            e.printStackTrace(out);
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                out.println("Error closing SQL resources.");
                e.printStackTrace(out);
            }
        }
    }
}
