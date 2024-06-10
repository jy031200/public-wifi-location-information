package com.example.demo;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonSyntaxException;
import com.google.gson.stream.JsonReader;
import com.google.gson.stream.JsonToken;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;

@WebServlet("/connect-api")
public class OpenApiServlet2 extends HttpServlet {

    private static final String API_URL_TEMPLATE = "http://openapi.seoul.go.kr:8088/7845417a6e6a79303132306550734250/json/TbPublicWifiInfo/%d/%d/";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        try (CloseableHttpClient httpClient = HttpClients.createDefault()) {
            int start = 1;
            int end = 1000;
            int totalRecords = 24593;

            while (start <= totalRecords) {
                String apiUrl = String.format(API_URL_TEMPLATE, start, end);
                HttpGet request = new HttpGet(apiUrl);
                try (CloseableHttpResponse response = httpClient.execute(request);
                     InputStreamReader reader = new InputStreamReader(response.getEntity().getContent());
                     JsonReader jsonReader = new JsonReader(reader)) {
                    jsonReader.setLenient(true);
                    JsonToken token = jsonReader.peek();
                    if (token == JsonToken.STRING) {
                        // JSON 응답이 문자열로 시작하는 경우 처리
                        String tbPublicWifiInfoString = jsonReader.nextString();
                        ConnectAPI.connectsql(out);
                        processStringTbPublicWifiInfo(tbPublicWifiInfoString, out);
                    } else if (token == JsonToken.BEGIN_OBJECT) {
                        // JSON 응답이 객체로 시작하는 경우 처리
                        jsonReader.beginObject();
                        while (jsonReader.hasNext()) {
                            String name = jsonReader.nextName();
                            if ("TbPublicWifiInfo".equals(name)) {
                                JsonToken innerToken = jsonReader.peek();
                                if (innerToken == JsonToken.STRING) {
                                    ConnectAPI.connectsql(out);
                                    processStringTbPublicWifiInfo(jsonReader.nextString(), out);
                                } else if (innerToken == JsonToken.BEGIN_OBJECT) {
                                    ConnectAPI.connectsql(out);
                                    processObjectTbPublicWifiInfo(jsonReader, out);
                                } else {
                                    out.println("Unexpected token: " + innerToken.toString());
                                    jsonReader.skipValue();
                                }
                            } else {
                                jsonReader.skipValue();
                            }
                        }
                        jsonReader.endObject();
                    } else {
                        // Unexpected token
                        out.println("Unexpected token: " + token.toString());
                    }

                    out.println("Data fetched and saved successfully.");
                }

                start += 1000;
                end = Math.min(end + 1000, totalRecords);
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Log the exception
            log("An error occurred while fetching data from the API", e);
            out.println("An error occurred while fetching data from the API. Please check the logs for more information.");
        }
    }

    private void processStringTbPublicWifiInfo(String tbPublicWifiInfoString, PrintWriter out) throws IOException {
        // "TbPublicWifiInfo" 필드가 문자열인 경우 처리
        out.println("TbPublicWifiInfo field contains a large String. Processing...");

        // 문자열을 JsonArray로 변환
        JsonArray jsonArray;
        try {
            jsonArray = JsonParser.parseString(tbPublicWifiInfoString).getAsJsonArray();
            // 예시: 데이터베이스에 저장하는 로직 추가
            SaveDataToDB.saveDataToDatabase(jsonArray, out);
        } catch (JsonSyntaxException e) {
            e.printStackTrace();
            out.println("Error parsing the string as JsonArray: " + e.getMessage());
        }
    }

    private void processObjectTbPublicWifiInfo(JsonReader jsonReader, PrintWriter out) throws IOException {
        jsonReader.beginObject();
        while (jsonReader.hasNext()) {
            String name = jsonReader.nextName();
            if ("row".equals(name)) {
                JsonArray jsonArray = new JsonArray();
                jsonReader.beginArray();
                while (jsonReader.hasNext()) {
                    JsonObject wifiInfo = JsonParser.parseReader(jsonReader).getAsJsonObject();
                    jsonArray.add(wifiInfo);
                }
                jsonReader.endArray();
                SaveDataToDB.saveDataToDatabase(jsonArray, out);
            } else {
                jsonReader.skipValue();
            }
        }
        jsonReader.endObject();
    }

}