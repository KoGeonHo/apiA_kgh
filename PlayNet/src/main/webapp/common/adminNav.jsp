<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%> 
<%
//로그인처리 임시
if(session.getAttribute("midx") != null){
	if(session.getAttribute("isAdmin").equals("N")){%>
		<script>
			alert("잘못된 접근입니다.");
			location.href="<%=request.getContextPath()%>/user/index.go";
		</script>
	<%}
}else{%>
	<script>
		alert("로그인이 필요합니다.");
		location.href="<%=request.getContextPath()%>/user/Login.go";
	</script>
<%}%>
<div id="navigator" style="display:flex; flex-direction: column;">
	<div id="nav_logo" onclick="javascript:location.href='${path}/admin/index.go'">
		<b style="color:rgb(46,117,182);">P</b><b style="font-size:0.8em;">lay</b><b style="color:rgb(112,173,71);">N</b><b style="font-size:0.8em;">et</b>
	</div>
	<div style="flex:1;">
		<div style="color:white; text-align:center;">
			<ul>
				<li onclick="javascript:location.href='${path}/admin/memberList.go'">회원관리</li>
				<li class="upperMenu" 
				onmouseover="openMenu($(this).next('.secondMenu'))" 
				onmouseout="closeMenu($(this).next('.secondMenu'))"
				onclick="javascript:location.href='${path}/admin/contentDetailList.go?menuNum=2'">
					콘텐츠관리
				</li>
				<li class="secondMenu"
				onmouseover="openMenu($(this))" 
				onmouseout="closeMenu($(this))">
					<ul>
						<li onclick="javascript:location.href='${path}/admin/contentDetailList.go'">
							콘텐츠
						</li>	
						<li onclick="javascript:location.href='${path}/admin/category.go'">
							카테고리
						</li>
					</ul>
				</li>
				<li class="upperMenu" 
				onmouseover="openMenu($(this).next('.secondMenu'))" 
				onmouseout="closeMenu($(this).next('.secondMenu'))"
				onclick="javascript:location.href='${path}/admin/announce.go'">
					사이트관리
				</li>
				<li class="secondMenu"
				onmouseover="openMenu($(this))" 
				onmouseout="closeMenu($(this))">
					<ul>
						<li onclick="javascript:location.href='${path}/admin/announce.go'">
							공지사항
						</li>
						<li onclick="javascript:location.href='${path}/admin/ask.go'">
							문의답변
						</li>
					</ul>
				</li>
				<li onclick="javascript:window.open('${path}/user/index.go')">홈페이지<br>바로가기</li>
			</ul>
		</div>
	</div>
	<div style='color:white; padding:20px; text-align:center; cursor:pointer;' onclick="location.href='${path}/admin/logout.ok'">
		<div><img src="${path}/images/common/logout.png" style="vertical-align:middle; margin:5px;" width="18px" height="18px">로그아웃</div>
	</div>
</div>