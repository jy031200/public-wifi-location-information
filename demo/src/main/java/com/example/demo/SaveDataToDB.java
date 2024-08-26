package com.example.demo;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;

import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class SaveDataToDB {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/console?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "user";

    public static void saveDataToDatabase(JsonArray jsonArray, PrintWriter out) {
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String sql = "INSERT INTO location_data (distance_num, wifi, area, wifi_name, address, detail_address, floor, wifi_type, wifi_organ, service, mesh, install_year, in_out, connect, X, Y, work_year) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                for (JsonElement element : jsonArray) {
                    if (!element.isJsonObject()) continue;

                    JsonObject obj = element.getAsJsonObject();
                    statement.setString(1, ""); // distance_num 기본값 설정
                    statement.setString(2, getStringOrNull(obj, "X_SWIFI_MGR_NO")); // 관리번호
                    statement.setString(3, getStringOrNull(obj, "X_SWIFI_WRDOFC")); // 자치구
                    statement.setString(4, getStringOrNull(obj, "X_SWIFI_MAIN_NM")); // 와이파이명
                    statement.setString(5, getStringOrNull(obj, "X_SWIFI_ADRES1")); // 도로명 주소
                    statement.setString(6, getStringOrNull(obj, "X_SWIFI_ADRES2")); // 상세주소
                    statement.setString(7, getStringOrNull(obj, "X_SWIFI_INSTL_FLOOR")); // 설치층
                    statement.setString(8, getStringOrNull(obj, "X_SWIFI_INSTL_TY")); // 설치유형
                    statement.setString(9, getStringOrNull(obj, "X_SWIFI_INSTL_MBY")); // 설치기관
                    statement.setString(10, getStringOrNull(obj, "X_SWIFI_SVC_SE")); // 서비스 구분
                    statement.setString(11, getStringOrNull(obj, "X_SWIFI_CMCWR")); // 망종류
                    statement.setString(12, getStringOrNull(obj, "X_SWIFI_CNSTC_YEAR")); // 설치년도
                    statement.setString(13, getStringOrNull(obj, "X_SWIFI_INOUT_DOOR")); // 실내외구분
                    statement.setString(14, getStringOrNull(obj, "X_SWIFI_REMARS3")); // 와이파이 접속환경
                    statement.setString(15, getStringOrNull(obj, "LAT")); // X좌표
                    statement.setString(16, getStringOrNull(obj, "LNT")); // Y좌표
                    statement.setString(17, getStringOrNull(obj, "WORK_DTTM")); // 작업일자
                    statement.addBatch(); // 배치 추가
                }
                statement.executeBatch();
                out.println("Data fetched and saved successfully!!!!!!!!!!!!!!!");
            }
        } catch (Exception e) {
            out.println("Error saving data to the database.");
            e.printStackTrace(out);
        }
    }

    private static String getStringOrNull(JsonObject obj, String memberName) {
        JsonElement elem = obj.get(memberName);
        return elem != null && !elem.isJsonNull() ? elem.getAsString() : null;
    }
}
