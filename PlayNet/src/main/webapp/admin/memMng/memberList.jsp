<%@page import="playnet.Vo.MemberVo"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="playnet.admin.AdminMethods" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>PlayNet Admin</title>
<link rel="stylesheet" type="text/css" href="${path}/css/main.css">
<link rel="stylesheet" type="text/css" href="${path}/css/navFixed.css">
<link rel="stylesheet" type="text/css" href="${path}/css/memberList.css">
<script src="${path}/js/jquery-3.6.0.js"></script>
<script src="${path}/js/mainForAdmin.js"></script>
<%
//파라미터 받을 변수 선언
String mName = "";
String mEmail = "";
String jDate1 = "";
String jDate2 = "";
String isadmin = "";

//파라미터 값이 있다면 변수에 파라미터값 입력
if(request.getParameter("mName") != null){
	mName = request.getParameter("mName");
}
if(request.getParameter("mEmail") != null){
	mEmail = request.getParameter("mEmail");
}
if(request.getParameter("jDate1") != null){
	jDate1 = request.getParameter("jDate1");
}
if(request.getParameter("jDate2") != null){
	jDate2 = request.getParameter("jDate2");
}
if(request.getParameter("isadmin") != null){
	isadmin = request.getParameter("isadmin");
}

//현재 페이지번호 null이면 1로 설정
int pageNum;

if(request.getParameter("pageNum") != null){
	pageNum = Integer.parseInt(request.getParameter("pageNum"));
}else{
	pageNum = 1;
}


AdminMethods AM = new AdminMethods();
ArrayList<MemberVo> mList = new ArrayList<>();
mList = AM.MemberList(mName,mEmail,jDate1,jDate2,pageNum,isadmin);

int cntMemList = AM.CountMemberList(mName, mEmail, jDate1, jDate2,isadmin);

//페이지별 출력 회원수,페이지번호수 
int indexNum = AM.getIndexNum();

int pageIdx = AM.getPageNumIdx();

// 총페이지 수
int totalPageNum = (int)(Math.ceil((double)cntMemList/(double)indexNum));

//페이지 시작번호
int pageStartNum = (((pageNum-1)/pageIdx)*pageIdx)+1;

//페이지 끝번호
int pageEndNum = pageStartNum + (pageIdx - 1);

if(pageEndNum > totalPageNum){
	pageEndNum = totalPageNum;
}
%>
</head>
<body>

<%@ include file="../../common/adminNav.jsp" %>

<div class="wrap">
	<%@ include file="../../common/header.jsp" %>	

	<div id="adminContents" style="padding-left:180px; color:white;">
		<h1>회원관리</h1>
		<div id="userSearch">
			<hr>
			<form method="POST" action="${path}/admin/memberList.go">
				<table>
					<tr>
						<th>이름</th>
						<td><input type="text" name="mName" value="<%=mName%>"></td>
						<th>가입일</th>
						<td><input type="date" name="jDate1" style="width:120px;" value="<%=jDate1%>"> ~ 
						<input type="date" name="jDate2" style="width:120px;" value="<%=jDate2%>"></td>
					</tr>
					<tr>
						<th>이메일</th>
						<td><input type="text" name="mEmail" value="<%=mEmail%>"></td>
						<th>
							회원구분
						</th>
						<td>
							<select name="isadmin">
								<option value="">전체</option>
								<option value="N" <%if(isadmin.equals("N")){ out.print("selected"); } %>>회원</option>
								<option value="Y" <%if(isadmin.equals("Y")){ out.print("selected"); } %>>관리자</option>
							</select>
							<!--select>
								<option value="0" selected>전체</option>
								<option value="1">구독회원</option>
								<option value="2">일반</option>
								<option value="3">탈퇴</option>
							</select-->
							<button type="submit">검색</button>
						</td>
					</tr>
				</table>
			</form>
			<hr>
		</div>
		<div id="userList">
			<table>
				<thead>
					<tr>
						<th style="width:500px;">
							이름(이메일)
						</th>
						<!-- th style="width:100px;">
							회원구분
						</th-->
						<th style="width:120px;">
							가입일
						</th>
						<!--  >th style="width:300px;">
							구독정보
						</th-->
						<th>
							관리자
						</th>
					</tr>
				</thead>
				<tbody>
					<%
					for(MemberVo mlv : mList) {
					%>
						<tr onclick="location.href='<%=request.getContextPath()%>/admin/memberView.go?midx=<%=mlv.getMidx()%>'">
							<td>
								<%=mlv.getmName()%>(<%=mlv.getmEmail()%>)
							</td>
							<!-- td>
								-
							</td-->
							<td>
								<%=mlv.getjDate()%>
							</td>
							<!-- td>
								-
							</td -->
							<td>
								<%if(mlv.getIsAdmin().equals("Y")) { out.print("관리자");}else if(mlv.getIsAdmin().equals("N")){ out.print("회원"); }%>
							</td>
						</tr>
					<%} %>
				</tbody>
				<tfoot>
					<tr>
						<td colspan='3'>
							<div id="paging" style="width:820px; text-align:center;">
								<ol style="list-style:none;">
									<li style="cursor:pointer;" onclick="javascript:location.href='<%=request.getContextPath()%>/admin/memberList.go?pageNum=1'">처음으로</li>
									<%
									for(int i = pageStartNum; i <= pageEndNum; i++){%>
										<li style="cursor:pointer;" onclick="javascript:location.href='<%=request.getContextPath()%>/admin/memberList.go?pageNum=<%=pageNum%>'"><%=i%></li>
									<%}%>
									<li style="cursor:pointer;" onclick="javascript:location.href='<%=request.getContextPath()%>/admin/memberList.go?pageNum=<%=totalPageNum%>'">마지막으로</li>
								</ol>
							</div>
						</td>
					</tr>	
				</tfoot>
			</table>
		</div>
	</div>
</div>
</body>
</html>