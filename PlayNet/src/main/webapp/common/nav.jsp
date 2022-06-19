<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%> 
<%
if(session.getAttribute("midx") == null){
	out.print("<script>alert('로그인이 필요합니다.'); location.href='"+request.getContextPath()+"/user/Login.go'</script>");
}
%>
<div id="navigator" style="background:url(../images/common/pattern4.jpg);  background-repeat: repeat;">
	<div id="navBtn">
		<div id="close" class="navBtnbox" style="display:none;"><div class="navBtn" onclick="navClose()">◀</div></div>
		<div id="open" class="navBtnbox" style="display:flex;"><div class="navBtn" onclick="navOpen()">▶</div></div>
	</div>
	<div id="nav_logo" onclick="location.href='<%=request.getContextPath()%>/user/index.go'">
		<b style="color:rgb(46,117,182);">P</b><b style="font-size:0.8em;">lay</b><b style="color:rgb(112,173,71);">N</b><b style="font-size:0.8em;">et</b>
	</div>
	<div style="color:white; text-align:center; flex:1;">
		<ul id="menu">
			<li onclick="javascript:location.href='<%=request.getContextPath()%>/user/announce.go'">공지사항</li>
			<li onclick="javascript:location.href='<%=request.getContextPath()%>/user/ask.go'">문의하기</li>
			<!--li onclick="alert('준비중입니다.')">My Page</li-->
			<li onclick="javascript:location.href='<%=request.getContextPath()%>/user/myPage.go'">My Page</li>
		</ul>
	</div>	
	<div style="position:absolute; bottom:0px; color:white; padding:15px; cursor:pointer; " onclick="location.href='<%=request.getContextPath()%>/user/logout.ok'">
		<div><img src="<%=request.getContextPath()%>/images/common/logout.png" style="vertical-align:middle; margin:5px;" width="18px" height="18px">로그아웃</div>
	</div>
</div>