<%@page import="playnet.Vo.ContentDetailVo"%>
<%@page import="java.util.ArrayList"%>
<%@page import="playnet.admin.AdminMethods"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>PlayNet Admin</title>
<link rel="stylesheet" type="text/css" href="${path}/css/main.css">
<link rel="stylesheet" type="text/css" href="${path}/css/navFixed.css">
<script src="${path}/js/jquery-3.6.0.js"></script>
<script src="${path}/js/mainForAdmin.js"></script>
<%
AdminMethods AM = new AdminMethods(); 
ArrayList<ContentDetailVo> CDList = AM.selContentDetailPopuler();

%>
<script>
	$(function(){
		$(".slide").css("width",(220*<%=CDList.size()%>)+"px");
	});	
</script>
</head>
<body>

<%@ include file="../common/adminNav.jsp" %>

<div class="wrap">
	<%@ include file="../common/header.jsp" %>	
	<div id="adminContents" style="padding-left:180px; color:white;">
		<div class="container">
			<h2 style="padding:5px;">PlayNet 인기급상승</h2>
			<div class="slide" style="left:0px;">
				<% for(ContentDetailVo CDV : CDList){%>
					<div class="items" 
					onclick="javascript:location.href='${path}/admin/contentDetailView.go?CdIdx=<%=CDV.getCdIdx()%>'"
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
</div>
</body>
</html>