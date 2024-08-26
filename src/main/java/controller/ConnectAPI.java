package controller;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.http.HttpServlet;

public class ConnectAPI extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/console?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "user";

    static void connectsql(PrintWriter out) throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            out.println("MySQL Driver not found");
            e.printStackTrace(out);
            return;
        }

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             Statement stmt = connection.createStatement()) {
            // SQL 파일 경로
            String sqlFilePath = "C:/Users/User/Downloads/IdeaProjects/IdeaProjects/demo/src/main/db.sql";
            // SQL 파일 읽기
            try (BufferedReader reader = new BufferedReader(new FileReader(sqlFilePath))) {
                StringBuilder sql = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    sql.append(line).append("\n");
                }

                // SQL 실행
                for (String statement : sql.toString().split(";")) {
                    if (!statement.trim().isEmpty()) {
                        stmt.execute(statement);
                    }
                }
                out.println("SQL file executed successfully!!!");
            } catch (FileNotFoundException e) {
                out.println("SQL file not found.");
                e.printStackTrace(out);
            } catch (IOException e) {
                out.println("Error reading SQL file.");
                e.printStackTrace(out);
            }
        } catch (SQLException e) {
            out.println("Error executing SQL file.");
            e.printStackTrace(out);
        }
    }
}
