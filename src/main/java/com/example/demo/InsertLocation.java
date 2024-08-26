package com.example.demo;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/location-api2")
public class InsertLocation extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/console?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "user";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();

        StringBuilder sb = new StringBuilder();
        BufferedReader reader = request.getReader();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }

        try {
            JsonObject jsonRequest = JsonParser.parseString(sb.toString()).getAsJsonObject();
            double lat = jsonRequest.get("latitude").getAsDouble();
            double lng = jsonRequest.get("longitude").getAsDouble();

            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
                String sql = "INSERT INTO mylocation_data (id, X, Y, today) VALUES (?, ?, ?, ?)";
                try (PreparedStatement statement = conn.prepareStatement(sql)) {
                    statement.setString(1, ""); // id 기본값 설정
                    statement.setString(2, Double.toString(lat)); // X 좌표
                    statement.setString(3, Double.toString(lng)); // X 좌표
                    statement.setString(4, ""); // today 기본값 설정
                    statement.executeUpdate();

                    jsonResponse.addProperty("status", "success");
                    jsonResponse.addProperty("message", "Data fetched and saved successfully.");
                }
            } catch (Exception e) {
                jsonResponse.addProperty("status", "error");
                jsonResponse.addProperty("message", "Error saving data to the database.");
                jsonResponse.addProperty("details", e.getMessage());
            }
        } catch (Exception e) {
            jsonResponse.addProperty("status", "error");
            jsonResponse.addProperty("message", "Invalid JSON format.");
            jsonResponse.addProperty("details", e.getMessage());
        }

        out.print(jsonResponse.toString());
    }
}
