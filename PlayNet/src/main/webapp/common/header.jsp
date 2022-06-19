<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>    
    <%
	String uri = request.getRequestURI();
	//프로젝트이름 추출
	String pj = request.getContextPath();
	//프로젝트 이름을 제외한 나머지 가상경로 추출
	String command = uri.substring(pj.length());
	
	String[] subPath = command.split("/");
	String location = subPath[1];// /member/login.Ok에서 member를 추출
	if(location.equals("common")){
		location = "user";
	}
	%>
<div id="header" style="min-width:600px;">
	<div id="logo" onclick="javascript:location.href='<%=request.getContextPath()%>/<%=location%>/index.go'">
		<b style="color:rgb(46,117,182);">P</b><b style="font-size:0.8em;">lay</b><b style="color:rgb(112,173,71);">N</b><b style="font-size:0.8em;">et</b>
	</div>
	<%if(location.equals("user")) {%>
	<div id="searchBar" style="flex:1; text-align:right; padding:20px;">
		<form id="conSearchFrm" method="POST" action="<%=request.getContextPath()%>/user/conSearch.go">
			<input type="hidden" name="cateidx" value="0">
			<input type="text" name="key_word" class="SearchTxt" autocomplete="off" <%if(request.getParameter("key_word") != null){ out.print("value='"+ request.getParameter("key_word") +"'"); }%>>
			<button type="submit" style="border:0; background:black;">
				<span style="font-size:1.5em; padding:10px; color:white;">검색</span>
			</button>
		</form>
	</div>
	<%} %>
</div>
