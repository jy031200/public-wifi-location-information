<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>와이파이 정보 구하기</title>
    <style>
        #title {
            font-size: 25px; /* 기본 글씨 크기 */
            font-family: "맑은 고딕";
            font-weight: bold;
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
        #label1 {
            font-size: 12px;
        }
        #label2 {
            font-size: 12px;
        }
        #label3 {
            font-size: 12px;
            font-family: "맑은 고딕";
        }
        #label4 {
            font-size: 12px;
            font-family: "맑은 고딕";
        }
        #textbox1 {
            width: 130px;
            height: 13px;
        }
        #textbox2 {
            width: 120px;
            height: 13px;
        }
        #button1 {
            font-size: 12px;
            width: 107px;
            height: 20px;
        }
        #button2 {
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
    <script>
        function createTable() {
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
            var data = [
                ['0.1849','WF120043','마포구','망원한강안내센터','마포나루길 467 망원안내센터','사무실 3층',' ','7-1, 커뮤니티- 행정','서울시(AP)','공공WIFI','임대망','2020','실내',' ','37.552788','126.8939','2022-05-07' +
                '10:57:58.0']
            ];

            // 기본값 단일 행 생성
            if (data.length === 0) {
            var rowHtml = '<tr>';
            for (var i = 0; i < headers.length; i++) {
                // 중간 지점에 데이터를 삽입
                if (i === Math.floor(headers.length / 2)) {
                    rowHtml += '<td>' + data[0] + '</td>';
                } else {
                    rowHtml += '<td>' + ' ' + '</td>';
                }
            }
            rowHtml += '</tr>';
            tbody.innerHTML = rowHtml;
            } else{ // 데이터가 들어오면 다중 행 생성
                for (var i = 0; i < data.length; i++) {
                    var row = document.createElement('tr'); // tr을 데이터 길이 만큼 생성

                    for (var j = 0; j < data[i].length; j++) { //td에 내용을 넣어서 tr에 추가하기
                        var td = document.createElement('td');
                        td.innerText = data[i][j];
                        row.appendChild(td);
                    }
                    tbody.appendChild(row); // tr을 tbody에 넣기
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
    <a id="hyper_link3" href="wifi.jsp">Open API 와이파이 정보 가져오기</a>
</div>
<br>
<div>
    <LABEL id="label3">LAT:</LABEL>
    <input type="text" id="textbox1">
    <LABEL id="label4">, LNT:</LABEL>
    <input type="text" id="textbox2">
    <button id = "button1">내 위치 가져오기</button>
    <button id = "button2">근처 WIFI 정보 보기</button>
</div>
<div id="table-container" >

</div>
</body>
</html>