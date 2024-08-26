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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        StringBuilder sb = new StringBuilder();
        BufferedReader reader = request.getReader();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        JsonObject jsonRequest = JsonParser.parseString(sb.toString()).getAsJsonObject();
        double lat = jsonRequest.get("latitude").getAsDouble();
        double lng = jsonRequest.get("longitude").getAsDouble();

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String sql = "INSERT INTO mylocation_data (X, Y) VALUES (?, ?)";
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                statement.setDouble(1, lat); // X 좌표
                statement.setDouble(2, lng); // Y 좌표
                statement.executeUpdate();
                out.println("Data fetched and saved successfully.");
            }
        } catch (Exception e) {
            out.println("Error saving data to the database.");
            e.printStackTrace(out);
        }
    }
}
