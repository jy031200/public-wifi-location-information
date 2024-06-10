package com.example.demo;

import javax.servlet.http.HttpServlet;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.PrintWriter;
import java.sql.*;

public class ConnectAPI extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/console?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "user";

    static void connectsql(PrintWriter out) {
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

            // SQL 파일 경로
            String sqlFilePath = "C:/Users/jy031/AppData/Roaming/JetBrains/IntelliJIdea2024.1/consoles/db/dcce4915-1063-4859-b4f2-b9a3ea38eb51/console.sql";

            // SQL 파일 읽기
            BufferedReader reader = new BufferedReader(new FileReader(sqlFilePath));
            StringBuilder sql = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sql.append(line).append("\n");
            }
            reader.close();

            // SQL 실행
            for (String statement : sql.toString().split(";")) {
                if (!statement.trim().isEmpty()) {
                    stmt.execute(statement);
                }
            }
            out.println("SQL file executed successfully!!!");
        } catch (Exception e) {
            out.println("Error executing SQL file.");
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