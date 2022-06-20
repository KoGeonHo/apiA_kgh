<%@page import="playnet.Vo.ContentDetailVo"%>
<%@page import="java.util.ArrayList"%>
<%@page import="playnet.user.UserMethods"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>PlayNet</title>
<link rel="stylesheet" type="text/css" href="/PlayNet/css/main.css">
<link rel="stylesheet" type="text/css" href="/PlayNet/css/nav.css">
<script src="/PlayNet/js/jquery-3.6.0.js"></script>
<script src="/PlayNet/js/main.js"></script>
<%
UserMethods UM = new UserMethods();
ArrayList<ContentDetailVo> likeList = UM.mngFavorite((int)session.getAttribute("midx"));
%>
<style type="text/css">
  
    td {
    	height:40px;
    }
</style>
</head>
<body>

<%@ include file="/common/nav.jsp" %>	

<div class="wrap">
	<%@ include file="/common/header.jsp" %>	
	<div id="contents2" style="color:white;">
		<h1 style="margin:0px;">Liked Content</h1>
		<div>
			<table style="color:white; font-size:1.2em;">
				<%for(ContentDetailVo CDV : likeList) { 
					out.print("<tr><td>"+CDV.getCdIdx()+"</td>"); 
					out.print("<td>"+CDV.getPoster1()+"</td>"); 
					out.print("<td>"+CDV.getTitle()+"</td></tr>"); 
				}%>
			</table>
		</div>
	</div>
	<%@ include file="/common/footer.jsp" %>
</div>
</body>
</html>