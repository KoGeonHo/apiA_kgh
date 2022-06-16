<%@page import="playnet.Vo.AskVo"%>
<%@page import="java.util.ArrayList"%>
<%@page import="playnet.admin.AdminMethods"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>PlayNet</title>
<link rel="stylesheet" type="text/css" href="${path}/css/main.css">
<link rel="stylesheet" type="text/css" href="${path}/css/navFixed.css">
<script src="${path}/js/jquery-3.6.0.js"></script>
<script src="${path}/js/mainForAdmin.js"></script>
<%
int pageNum = 1;
String writer = "";
String wdate1 = "";
String wdate2 = "";
String title = "";
String content = "";

if(request.getParameter("pageNum") != null){
	pageNum = Integer.parseInt(request.getParameter("pageNum"));
}

if(request.getParameter("writer") != null){
	writer = request.getParameter("writer");
}
if(request.getParameter("wdate1") != null){
	wdate1 = request.getParameter("wdate1");
}
if(request.getParameter("wdate2") != null){
	wdate2 = request.getParameter("wdate2");
}
if(request.getParameter("title") != null){
	title = request.getParameter("title");
}
if(request.getParameter("content") != null){
	content = request.getParameter("content");
}

AdminMethods AM = new AdminMethods();
ArrayList<AskVo> aList = AM.selAskAll(writer,wdate1,wdate2,title,content);

int cntAsk = AM.cntAsk(writer,wdate1,wdate2,title,content);

//페이지별 출력 회원수,페이지번호수 
int indexNum = AM.getIndexNum();

int pageIdx = AM.getPageNumIdx();

//총페이지 수
int totalPageNum = (int)(Math.ceil((double)cntAsk/(double)indexNum));

//페이지 시작번호
int pageStartNum = (((pageNum-1)/pageIdx)*pageIdx)+1;

//페이지 끝번호
int pageEndNum = pageStartNum + (pageIdx - 1);

if(pageEndNum > totalPageNum){
	pageEndNum = totalPageNum;
}
%>
<style>
	#paging li{
		display:inline-block;
	}
</style>
<script>
	function pageMove(pageNum){
		$("input[name=pageNum]").val(pageNum);
		$("#searchFrm").submit();
	}
</script>
</head>
<body>

<%@ include file="../../common/adminNav.jsp" %>

<div class="wrap">
	<%@ include file="../../common/header.jsp" %>	
	<div id="contents2" style="padding-left:180px; color:white;">
		<h1 style="margin:0px;">문의답변</h1><hr>
		<div id="Search">
			<form id="searchFrm" method="POST" action="${path}/admin/ask.go">
				<input type="hidden" name="pageNum" value="<%=pageNum%>">
				<table>
					<tr>
						<th>작성자</th>
						<td><input type="text" name="writer" value="<%=writer%>"></td>
						<th>작성일</th>
						<td colspan="2"><input type="date" name="wdate1" style="width:120px;"> ~ <input type="date" name="wdate2" style="width:120px;"></td>
					</tr>
					<tr>
						<th>제목</th>
						<td>
							<input type="text" name="title" value="<%=title%>">
						</td>
						<th>내용</th>
						<td>
							<input type="text" name="content" value="<%=content%>">
						</td>
						<td>
							<button>검색</button>
						</td>
					</tr>
				</table>
			</form>
			<hr>
		</div>
		<div style="width:820px;">
			<table>
				<thead>
					<tr>
						<th style="width:500px;">제목</th>
						<th style="width:120px;">작성일</th>
						<th style="width:120px;">작성자</th>
						<th style="width:100px;">처리상태</th>
					</tr>
				</thead>
				<tbody>
					<%
					for(AskVo AskV : aList){
					%>
						<tr onclick="location.href='${path}/admin/askView.go?aidx=<%=AskV.getAidx()%>'">
							<td style="text-align:center;"><%=AskV.getTitle()%></td>
							<td style="text-align:center;"><%=AskV.getAskdate()%></td>
							<td style="text-align:center;"><%=AskV.getWriter()%></td>
							<td style="text-align:center;">
								<%if(AskV.getAnspn() == 0){ %>
									대기
								<%}else if(AskV.getAnspn() == 1) {%>
									처리중
								<%}else if(AskV.getAnspn() == 2) {%>
									처리완료
								<%} %>
							</td>
						</tr>
					<%}%>
				</tbody>
				<tfoot>
					<tr>
						<td colspan='3'>
							<div id="paging" style="text-align:center;">
								<ol style="list-style:none;">
									<li style="cursor:pointer;" onclick="pageMove(1)">처음으로</li>
									<%
									for(int i = pageStartNum; i <= pageEndNum; i++){%>
										<li style="cursor:pointer;" onclick="pageMove(<%=pageNum%>)"><%=i%></li>
									<%}%>
									<li style="cursor:pointer;" onclick="pageMove(<%=totalPageNum%>)">마지막으로</li>
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