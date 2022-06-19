<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<div id="navigator">
	<div id="nav_logo">
		<b style="color:rgb(46,117,182);">P</b><b style="font-size:0.8em;">lay</b><b style="color:rgb(112,173,71);">N</b><b style="font-size:0.8em;">et</b>
	</div>
	<div style="color:white; text-align:center;">
		<ul id="menu">
			<li onclick="javascript:location.href='<%=request.getContextPath()%>/user/announce.go'">공지사항</li>
			<li onclick="javascript:location.href='<%=request.getContextPath()%>/user/ask.go'">문의하기</li>
			<li onclick="javascript:location.href='<%=request.getContextPath()%>/user/myPage.go'">My Page</li>		
		</ul>
	</div>	
</div>