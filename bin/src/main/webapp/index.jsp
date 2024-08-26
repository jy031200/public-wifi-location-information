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
        String sql = "SELECT * FROM location_data ORDER BY id ASC LIMIT 10";
        statement = connection.prepareStatement(sql);

        // 쿼리 실행
        resultSet = statement.executeQuery();

        // 결과 처리 및 데이터 저장
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

    // 데이터를 JSON 형식으로 변환
    String jsonData = new Gson().toJson(dataList);
%>

<!DOCTYPE html>
<html>
<head>
    <title>와이파이 정보 구하기</title>
    <style>
        #title {
            font-size: 25px;
            font-family: "맑은 고딕";
            font-weight: bold;
        }
        #hyper_link1, #hyper_link2, #hyper_link3 {
            font-size: 12px;
            font-family: "맑은 고딕";
        }
        #label1, #label2, #label3, #label4 {
            font-size: 12px;
            font-family: "맑은 고딕";
        }
        #textbox1, #textbox2 {
            width: 130px;
            height: 13px;
        }
        #button1, #button2 {
            font-size: 12px;
            width: 125px;
            height: 20px;
        }
        #data-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        #data-table th, #data-table td {
            font-size: 12px;
            border: 1px solid white;
            border-bottom: 1px solid grey;
            border-left: 1px solid grey;
            border-right: 1px solid grey;
            padding: 8px;
            text-align: center;
        }
        #data-table th {
            background-color: #04AA6D;
            color: white;
            font-size: 12px;
        }
        tr:nth-child(even) {background-color: #f2f2f2;}
    </style>
</head>
<body>

<h1 id="title">와이파이 정보 구하기</h1>

<div>
    <a id="hyper_link1" href="index.jsp" onclick="del()">홈</a>
    <label id="label1"> | </label>
    <a id="hyper_link2" href="location.jsp">위치 히스토리 목록</a>
    <label id="label2"> | </label>
    <a id="hyper_link3" href="${pageContext.request.contextPath}/FetchwifiInfo" onclick="connectapi()">Open API 와이파이 정보 가져오기</a>
</div>
<br>
<div>
    <label id="label3">LAT:</label>
    <input type="text" id="textbox1" placeholder="0.0" required>
    <label id="label4">, LNT:</label>
    <input type="text" id="textbox2" placeholder="0.0" required>
    <button id="button1" onclick="getLocation()">내 위치 가져오기</button>
    <button id="button2" onclick="fetchData()">근처 WIFI 정보 보기</button>
</div>
<div id="table-container"></div>

<script>
    function createTable(data) {
        // 테이블 생성
        var table = document.createElement('table');
        table.id = 'data-table';

        // 테이블 헤더 생성
        var thead = document.createElement('thead');
        var headerRow = document.createElement('tr');
        var headers = ['거리(Km)', '관리번호', '자치구', '와이파이명', '도로명주소', '상세주소', '설치위치(층)', '설치유형', '설치기관', '서비스구분', '망종류', '설치년도', '실내외구분', 'WIFI접속환경', 'X좌표', 'Y좌표', '작업일자'];
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

    function getLocation() {
        navigator.geolocation.getCurrentPosition(function(position) {
            const lat = position.coords.latitude;
            const lng = position.coords.longitude;
            document.getElementById('textbox1').value = lat;
            document.getElementById('textbox2').value = lng;

            // 서버로 데이터 전송
            fetch('${pageContext.request.contextPath}/location-api2', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ latitude: lat, longitude: lng })
            })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok ' + response.statusText);
                    }
                    return response.json();
                })
                .then(data => {
                    console.log('Success:', data);
                })
                .catch((error) => {
                    console.error('Error:', error);
                });

            // 서버로 데이터 전송
            fetch('${pageContext.request.contextPath}/distance', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ latitude: lat, longitude: lng })
            })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok ' + response.statusText);
                    }
                    return response.json();
                })
                .then(data => {
                    console.log('Success:', data);
                })
                .catch((error) => {
                    console.error('Error:', error);
                });
        });
    }


    function fetchData() {
        var lat = document.getElementById('textbox1').value;
        var lng = document.getElementById('textbox2').value;

        if (lat && lng) {
            fetch(`/demo_war_exploded/display.jsp?lat=` + lat + '&lng=' + lng)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    // 응답 확인을 위해 response 로그 출력
                    console.log(response);
                    return response.json();
                })
                .then(data => {
                    createTable(data);
                })
                .catch(error => console.error('Error fetching data:', error));
        } else {
            alert("위치 정보를 입력한 후에 조회해 주세요.");
        }
        location.reload();
    }

    function connectapi() {
        fetch('${pageContext.request.contextPath}/connect-api')
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok ' + response.statusText);
                }
                return response.json();
            })
            .then(data => {
                console.log('OpenApi response:', data);
                // 서버에서 받은 데이터를 가지고 필요한 처리를 수행
                processData(data);
            })
            .catch(error => console.error('Error fetching OpenApi:', error));
    }

    function processData(data) {
        // 데이터를 가지고 필요한 처리를 수행
        createTable(data.data); // Display data in the table
        // 기타 필요한 처리
    }

    function del(){
        fetch(`${pageContext.request.contextPath}/open-api`)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok ' + response.statusText);
                }
                return response.json();
            })
            .then(data => {
                console.log('OpenApi response:', data);
                //createTable(data); // Display data in the table
            })
            .catch(error => console.error('Error fetching OpenApi:', error));

        // Handle jsonData from server-side rendering
        var jsonData = '<%= jsonData %>';
        if (jsonData) {
            try {
                var data = JSON.parse(jsonData);
                createTable(data);
            } catch (error) {
                console.error('Error parsing jsonData:', error);
            }
        }
        location.reload();
    }

    window.onload = function() {
        fetch('${pageContext.request.contextPath}/location-api')
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok ' + response.statusText);
                }
            })
            .catch(error => console.error('Error loading API data:', error));

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
</body>
</html>
