<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>와이파이 정보 구하기</title>
    <style> /* CSS */
        #title {
            font-size: 25px;
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
        #label1 {
            font-size: 12px;
        }
        #label2 {
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
            var headerCol = document.createElement('th');
            var headers = ['거리(Km)', '관리번호', '자치구', '와이파이명', '도로명주소', '상세주소', '설치위치(층)', '설치유형', '설치기관', '서비스구분', '망종류', '설치년도', '실내외구분', 'WIFI접속환경', 'X좌표', 'Y좌표', '작업일자'];
            for (var i = 0; i < headers.length; i++) {
                var tr = document.createElement('tr');
                tr.innerText = headers[i];
                headerCol.appendChild(th);
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
            var colHtml = '<th>';
            for (var i = 0; i < headers.length; i++) {
                rowHtml += '<td>' + ' ' + '</td>';
            }
            rowHtml += '</th>';
            tbody.innerHTML = rowHtml;
            table.appendChild(tbody);

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
</div>
<br>
<div id="table-container" >

</div>
</body>
</html>
