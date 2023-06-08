<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>제목을 입력하세요</title>
</head>
<body>
	<form id="reservationForm" method="post">
		<table>
			<tr>
				<td>숙소 이름:</td>
				<td><input type="text" name="accomname" value="${accommodation.accomname}" readonly="readonly"></td>
			</tr>
			<tr>
				<td>숙소 사진:</td>
				<td><img src="${accommodation.accompic}" alt="숙소 사진"></td>
			</tr>
			<tr>
				<td>숙소 설명:</td>
				<td><textarea class="textareabox" rows="8" cols="30" name="accomdes" readonly="readonly">${accommodation.accomdes}</textarea></td>
			</tr>
			<tr>
				<td>숙소 위치:</td>
				<td><input type="text" name="accomlocation" value="${accommodation.accomlocation}" readonly="readonly"></td>
			</tr>
			<tr>
				<td>숙박 가격:</td>
				<td><input type="text" name="accomprice" value="${accommodation.accomprice}" readonly="readonly"></td>
			</tr>
			<tr>
				<td>
					<input type="button" value="예약하기" onclick="checkLoginAndSubmit()">&nbsp;&nbsp;
				</td>
			</tr>
		</table>
	</form>
</body>
<script>
function checkLoginAndSubmit() {
    <% String sessionId = (String) session.getAttribute("sessionId");
    if (sessionId == null) { %>
        alert("로그인이 필요한 페이지입니다. 로그인 후 이용해주세요.");
        window.location.href = "login";
        return false;
    <% } else { %>
        var accomcode = "${accommodation.accomcode}";
        window.location.href = "reservationOk?accomcode=" + accomcode;
    <% } %>
}
</script>
</html>