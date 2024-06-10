package com.example.demo;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import com.google.gson.*;
import com.google.gson.stream.JsonReader;

@WebServlet("/FetchwifiInfo")
public class FetchWifiInfoServlet extends HttpServlet { // 총 데이터 갯수 반환(wifi.jsp)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String apiUrl = "http://openapi.seoul.go.kr:8088/7845417a6e6a79303132306550734250/json/TbPublicWifiInfo/1/10/";

        HttpURLConnection conn = null;
        BufferedReader br = null;

        try {
            URL url = new URL(apiUrl);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            InputStream is = conn.getInputStream();
            InputStreamReader isr = new InputStreamReader(is, "UTF-8");
            JsonReader reader = new JsonReader(isr);
            reader.setLenient(true); // Malformed JSON을 허용

            JsonParser parser = new JsonParser();
            JsonObject jsonResponse = parser.parse(reader).getAsJsonObject(); // 여기서 에러 Not a JSON Object: "<RESULT><CODE>ERROR-336<"

            // JSON 응답에서 TbPublicWifiInfo 객체 확인 및 파싱
            JsonObject wifiInfo = jsonResponse.getAsJsonObject("TbPublicWifiInfo");
            int listTotalCount = 0;
            if (wifiInfo != null) {
                JsonElement listTotalCountElement = wifiInfo.get("list_total_count");
                if (listTotalCountElement != null && !listTotalCountElement.isJsonNull()) {
                    listTotalCount = listTotalCountElement.getAsInt();
                } else {
                    response.getWriter().write("list_total_count가 응답에 없습니다.");
                    return;
                }
            } else {
                response.getWriter().write("TbPublicWifiInfo가 응답에 없습니다.");
                return;
            }

            // JSP 페이지로 값을 전달
            request.setAttribute("listTotalCount", listTotalCount);
            request.getRequestDispatcher("wifi.jsp").forward(request, response);
        } catch (JsonSyntaxException e) {
            e.printStackTrace();
            response.getWriter().write("Malformed JSON: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Errorrr: " + e.getMessage());
        } finally {
            if (br != null) try { br.close(); } catch (IOException ignore) {}
            if (conn != null) conn.disconnect();
        }
    }
}