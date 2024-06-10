<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>와이파이 정보 구하기</title>
    <style>
        #title {
            font-size: 25px;
            font-family: "맑은 고딕";
            font-weight: bold;
            text-align: center;
        }
        .link-container {
            font-size: 12px;
            font-family: "맑은 고딕";
            font-weight: bold;
            text-align: center;
        }
    </style>
</head>
<body>
<%
    // 서블릿에서 전달된 listTotalCount 값 가져오기
    Integer listTotalCount = (Integer) request.getAttribute("listTotalCount");
%>
<h1 id="title"><%= listTotalCount != null ? listTotalCount : "알 수 없음" %>개의 WIFI정보를 정상적으로 저장하였습니다.</h1>

<div class="link-container">
    <a href="index.jsp">홈으로 가기</a>
</div>
</body>
</html>
