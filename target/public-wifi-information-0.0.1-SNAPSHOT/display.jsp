<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.google.gson.Gson" %>

<%
    request.setCharacterEncoding("UTF-8");
    String lat = request.getParameter("lat");
    String lng = request.getParameter("lng");

    // 데이터를 저장할 리스트
    List<List<String>> dataList = new ArrayList<>();

    if (lat != null && lng != null && !lat.trim().isEmpty() && !lng.trim().isEmpty()) {
        // 데이터베이스 연결
        String DB_URL = "jdbc:mysql://localhost:3306/console?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
        String DB_USER = "root";
        String DB_PASSWORD = "user";

        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // SQL 쿼리 준비
            String sql = "SELECT * FROM location_data ORDER BY distance_num ASC LIMIT 10";
            // 쿼리 실행
            statement = connection.prepareStatement(sql);

            // 결과 처리 및 데이터 저장
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                List<String> row = new ArrayList<>();
                row.add(resultSet.getString("distance_num"));
                row.add(resultSet.getString("wifi"));
                row.add(resultSet.getString("area"));
                row.add(resultSet.getString("wifi_name"));
                row.add(resultSet.getString("address"));
                row.add(resultSet.getString("detail_address"));
                row.add(resultSet.getString("floor"));
                row.add(resultSet.getString("wifi_type"));
                row.add(resultSet.getString("wifi_organ"));
                row.add(resultSet.getString("service"));
                row.add(resultSet.getString("mesh"));
                row.add(resultSet.getString("install_year"));
                row.add(resultSet.getString("in_out"));
                row.add(resultSet.getString("connect"));
                row.add(resultSet.getString("X"));
                row.add(resultSet.getString("Y"));
                row.add(resultSet.getString("work_year"));
                dataList.add(row);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        } finally {
            // 자원 해제
            if (resultSet != null) try { resultSet.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (statement != null) try { statement.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    } else {
        out.print("{\"error\": \"위도와 경도를 모두 입력하세요.\"}");
    }

    // 데이터를 JSON 형식으로 변환하여 응답
    String jsonData = new Gson().toJson(dataList);
    out.print(jsonData);
%>
