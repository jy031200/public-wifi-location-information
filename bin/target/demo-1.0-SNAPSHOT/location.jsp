<%--
  Created by IntelliJ IDEA.
  User: jy031
  Date: 2024-05-27
  Time: 오후 8:03
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
        function createTable() {
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
            var data = [
                [ ],
            ];

            for (var i = 0; i < data.length; i++) {
                var row = document.createElement('tr'); // tr을 데이터 길이 만큼 생성

                for (var j = 0; j < data[i].length; j++) { //td에 내용을 넣어서 tr에 추가하기
                    var td = document.createElement('td');
                    td.innerText = data[i][j];
                    row.appendChild(td);
                }
                tbody.appendChild(row); // tr을 tbody에 넣기
            }
            table.appendChild(tbody); // 테이블에 넣기*/

            // 기존 표가 있으면 제거
            var existingTable = document.getElementById('data-table');
            if (existingTable) {
                existingTable.remove();
            }

            // 표를 문서에 추가
            document.getElementById('table-container').appendChild(table);
        }
        window.onload = function() { // 자동 실행
            createTable('table-container');
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
    <a id="hyper_link3" href="load-wifi.jsp">Open API 와이파이 정보 가져오기</a>
</div>
<div id="table-container" >

</div>
</body>
</html>
