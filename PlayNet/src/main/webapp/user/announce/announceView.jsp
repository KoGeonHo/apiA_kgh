<%@page import="playnet.Vo.AnnounceVo"%>
<%@page import="playnet.admin.Vo.CategoryVo"%>
<%@page import="java.util.*"%>
<%@page import="playnet.admin.AdminMethods"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>PlayNet</title>
<link rel="stylesheet" type="text/css" href="${ path }/css/main.css">
<link rel="stylesheet" type="text/css" href="${ path }/css/nav.css">
<script src="${ path }/js/jquery-3.6.0.js"></script>
<script src="${ path }/js/main.js"></script>
<%

int anidx = 0; 

if(request.getParameter("anidx") != null){
	anidx = Integer.parseInt(request.getParameter("anidx"));
}else{
	out.print("<script>alert('잘못된 접근입니다.'); history.back();</script>");
}

AdminMethods AM = new AdminMethods();

AnnounceVo ANV = AM.selAnnounce(anidx);

%>
<style>
	table {
		width:1000px;
		border-collapse: collapse;
	}
	th, td{
		padding:15px;
		border-top : 2px solid #222;
	}
	
	th {
		width:80px;
		text-align:center;
		background:#444;
	}
</style>
</head>
<body>

<%@ include file="../../common/nav.jsp" %>

<div class="wrap">
	<%@ include file="../../common/header.jsp" %>	
	<div id="contents2" style=" color:white;">	
	
		<h1 style="margin:0px;  color:white;">공지사항</h1>	<hr>
		<div>
			<table>
				<tr>
					<th style="font-size:1.5em;">
						제목
					</th>
					<td colspan='5'>
						<h2><%=ANV.getTitle()%></h2>
					</td>
					
				</tr>
				<tr>
					<th>
						작성자
					</th>
					<td>
						<%=ANV.getWriter()%>
					</td>
					<th>
						작성일
					</th>
					<td>
						<%=ANV.getwDate()%>
					</td>
					<th>
						조회수
					</th>
					<td>
						<%=ANV.getHit()%>
					</td>
				</tr>
				<tr>
					<td colspan='6'>
						<%=ANV.getContent()%>
					</td>
				</tr>
				<tr>
					<td colspan='6' style="text-align:right;">
						<button type="button" onclick="location.href='${ path }/user/announce.go'">목록으로</button>
					</td>
				</tr>
			</table>
		</div>
	</div>	
	<%@ include file="../../common/footer.jsp" %>
</div>
</body>
</html>