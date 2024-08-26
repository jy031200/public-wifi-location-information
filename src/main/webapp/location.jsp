<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.google.gson.Gson" %>

<%
    // 데이터베이스 연결 정보
    String DB_URL = "jdbc:mysql://localhost:3306/console?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    String DB_USER = "root";
    String DB_PASSWORD = "user";

    Connection connection = null;
    PreparedStatement statement = null;
    ResultSet resultSet = null;

    // 데이터를 저장할 리스트
    List<List<String>> dataList = new ArrayList<>();

    try {
        // MySQL 드라이버 로드
        Class.forName("com.mysql.cj.jdbc.Driver");

        // 데이터베이스 연결
        connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

        // SQL 쿼리 준비
        String sql = "SELECT * FROM mylocation_data";
        statement = connection.prepareStatement(sql);

        // 쿼리 실행
        resultSet = statement.executeQuery();

        // 결과 처리 및 데이터 저장
        while (resultSet.next()) {
            List<String> row = new ArrayList<>();
            row.add(resultSet.getString("X"));
            row.add(resultSet.getString("Y"));
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

    // 데이터를 JSON 형식으로 변환
    String jsonData = new Gson().toJson(dataList);
%>

<html>
<head>
    <title>위치 히스토리 목록</title>
    <style>
        #title {
            font-size: 25px; /* 기본 글씨 크기 */
            font-family: "맑은 고딕";
            font-weight: bold;
        }
        #label1 {
            font-size: 12px;
        }
        #label2 {
            font-size: 12px;
        }
        #hyper_link1 {
            font-size: 12px;
            font-family: "맑은 고딕";
        }
        #hyper_link2 {
            font-size: 12px;
            font-family: "맑은 고딕";
        }
        #hyper_link3 {
            font-size: 12px;
            font-family: "맑은 고딕";
        }
        #data-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        #data-table th, #data-table td {
            border: 1px solid white;
            border-bottom: 1px solid gray;
            border-left: 1px solid gray;
            padding: 8px;
            text-align: center;
        }
        #data-table th {
            background-color: mediumseagreen;
            color: white;
            font-size: 12px;
        }
    </style>
    <script>
        function createTable(data) {
            // 테이블 생성
            var table = document.createElement('table');
            table.id = 'data-table';

            // 테이블 헤더 생성
            var thead = document.createElement('thead');
            var headerRow = document.createElement('tr');
            var headers = ['ID','X좌표','Y좌표','조회일자','비고'];
            for (var i = 0; i < headers.length; i++) {
                var th = document.createElement('th');
                th.innerText = headers[i];
                headerRow.appendChild(th);
            }
            thead.appendChild(headerRow);
            table.appendChild(thead);

            // 테이블 바디 생성
            var tbody = document.createElement('tbody');

            // 데이터로 테이블 행 생성
            if (data.length === 0) { // 데이터가 없으면
                var row = document.createElement('tr');
                var td = document.createElement('td');
                td.colSpan = headers.length;
                td.innerText = "위치 정보를 입력 후 조회해 주세요.";
                row.appendChild(td);
                tbody.appendChild(row);
            } else {
                for (var i = 0; i < data.length; i++) {
                    var row = document.createElement('tr');
                    for (var j = 0; j < data[i].length; j++) {
                        var td = document.createElement('td');
                        td.innerText = data[i][j];
                        row.appendChild(td);
                    }
                    tbody.appendChild(row);
                }
            }
            table.appendChild(tbody);

            // 기존 표가 있으면 제거
            var existingTable = document.getElementById('data-table');
            if (existingTable) {
                existingTable.remove();
            }

            // 표를 문서에 추가
            document.getElementById('table-container').appendChild(table);
        }


        window.onload = function() {
            var jsonData = '<%= jsonData %>';
            if (jsonData) {
                try {
                    var data = JSON.parse(jsonData);
                    createTable(data);
                } catch (error) {
                    console.error('Error parsing jsonData:', error);
                }
            }
        }
    </script>
</head>
<body>
<h1 id="title">와이파이 정보 구하기</h1>

<div>
    <a id="hyper_link1" href="index.jsp">홈</a>
    <LABEL id="label1"> | </LABEL>
    <a id="hyper_link2" href="location.jsp">위치 히스토리 목록</a>
    <LABEL id="label2"> | </LABEL>
</div>
<div id="table-container" >

</div>
</body>
</html>
