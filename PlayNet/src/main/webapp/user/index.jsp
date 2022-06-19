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
<link rel="stylesheet" type="text/css" href="${path}/css/main.css">
<link rel="stylesheet" type="text/css" href="${path}/css/nav.css">
<script src="${path}/js/jquery-3.6.0.js"></script>
<script src="${path}/js/main.js"></script>
<%
UserMethods UM = new UserMethods();
ArrayList<ContentDetailVo> CDList = UM.selContentDetailPopuler();
%>
<script>		
	$(function(){
		$(".slide").css("width",(220*<%=CDList.size()%>)+"px");
	});
</script>
</head>
<body>

<%@ include file="../common/nav.jsp" %>	

<div class="wrap">
	<%@ include file="../common/header.jsp" %>	
	<div id="contents2">
		<div class="container">
			<h2 style="padding:5px;">PlayNet 인기작</h2>
			<div class="slide" id="slider" style="left:0px;">
				<% for(ContentDetailVo CDV : CDList){%>
				<div class="items" 
					onclick="javascript:location.href='${path}/user/conViewDetails.go?CdIdx=<%=CDV.getCdIdx()%>'"
					style="background:url(../images/poster/<%=CDV.getPoster1()%>); background-size:cover;"></div>				
				<%} %>
			</div>
			<div class="slide_move_btn slide_move_btn_left">
				<div>◀</div>
			</div>
			<div class="slide_move_btn slide_move_btn_right">
				<div>▶</div>
			</div>
		</div>
	</div>
	<%@ include file="../common/footer.jsp" %>
</div>
</body>
</html>