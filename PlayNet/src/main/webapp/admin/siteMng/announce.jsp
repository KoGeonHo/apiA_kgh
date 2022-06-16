<%@page import="playnet.Vo.AnnounceVo"%>
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
<style>
	#paging li{
		display:inline-block;
	}
</style>
</head>
<body>

<%

String title = "";
String content = "";
String sDate = "";
String eDate = "";

if(request.getParameter("title") != null){
	title = request.getParameter("title");
}
if(request.getParameter("content") != null){
	content = request.getParameter("content");
}
if(request.getParameter("sDate") != null){
	sDate = request.getParameter("sDate");
}
if(request.getParameter("title") != null){
	eDate = request.getParameter("eDate");
}




//현재 페이지번호 null이면 1로 설정
int pageNum;

if(request.getParameter("pageNum") != null){
	pageNum = Integer.parseInt(request.getParameter("pageNum"));
}else{
	pageNum = 1;
}

AdminMethods AM = new AdminMethods();
ArrayList<AnnounceVo> aList = AM.selAnnounceAll(title,content,sDate,eDate,pageNum);

int cntAnList = AM.cntAnnounce(title,content,sDate,eDate);

//페이지별 출력 회원수,페이지번호수 
int indexNum = AM.getIndexNum();

int pageIdx = AM.getPageNumIdx();

//총페이지 수
int totalPageNum = (int)(Math.ceil((double)cntAnList/(double)indexNum));

//페이지 시작번호
int pageStartNum = (((pageNum-1)/pageIdx)*pageIdx)+1;

//페이지 끝번호
int pageEndNum = pageStartNum + (pageIdx - 1);

if(pageEndNum > totalPageNum){
	pageEndNum = totalPageNum;
}


%>

<%@ include file="../../common/adminNav.jsp" %>

<div class="wrap">
	<%@ include file="../../common/header.jsp" %>	
	<div id="contents2" style="padding-left:180px; color:white;">	
	
		<h1 style="margin:0px;  color:white;">공지사항</h1>	<hr>
		<div class="Search">
			<form name="frm" method="POST" action="${path}/admin/announce.go">
				<table>
					<tr>
						<th>제목</th>
						<td><input type="text" name="title" value="<%=title%>"></td>
						<th>작성일</th>
						<td><input type="date" name="sDate" style="width:120px;" value="<%=sDate%>"> ~ <input type="date" name="eDate" style="width:120px;" value="<%=eDate%>"></td>
					</tr>
					<tr>
						<th>내용</th>
						<td><input type="text" name="content" value="<%=content%>"></td>
						<td>
							<button>검색</button>
						</td>
					</tr>
				</table>
			</form>
			<hr>
		</div>
		<div style="width:1200px;">		
			<table>
				<thead>
					<tr>
						<th style="width:100px;">글번호</th>
						<th style="width:500px;">제목</th>
						<th style="width:150px;">작성자</th>
						<th style="width:120px;">작성일</th>
						<th style="width:100px;">조회수</th>
					</tr>
				</thead>
				<tbody style="text-align:center;">	
					<%ArrayList<AnnounceVo> aListTf = AM.selAnnTop();
					for(AnnounceVo anv : aListTf){%>
						<tr>
							<td>
								공지
							</td>
							<td style="cursor:pointer;" onclick="javascript:location.href='${path}/admin/announceView.go?anidx=<%=anv.getAnidx()%>&istop=Y'">
								<%=anv.getTitle()%>
							</td>
							<td>
								<%=anv.getWriter()%>
							</td>
							<td>
								<%=anv.getwDate()%>
							</td>
							<td>
								<%=anv.getHit()%>
							</td>
						</tr>
					<%}%>					
					<%for(AnnounceVo anv : aList){%>
						<tr>
							<td>
								<%=anv.getAnidx()%>
							</td>
							<td style="cursor:pointer;" onclick="javascript:location.href='${path}/admin/announceView.go?anidx=<%=anv.getAnidx()%>'">
								<%=anv.getTitle()%>
							</td>
							<td>
								<%=anv.getWriter()%>
							</td>
							<td>
								<%=anv.getwDate()%>
							</td>
							<td>
								<%=anv.getHit()%>
							</td>
						</tr>
					<%}%>
				</tbody>
				<tfoot>
					<tr>
						<td colspan='5' style="text-align:right;">
							<button type="button" onclick="location.href='${path}/admin/announceInsert.go'">등록</button>
						</td>
					</tr>	
					<tr>
						<td colspan='5'>
							<div id="paging" style="text-align:center;">
								<ol style="list-style:none;">
									<li style="cursor:pointer;" onclick="javascript:location.href='${path}/admin/announce.go?pageNum=1'">처음으로</li>
									<%
									for(int i = pageStartNum; i <= pageEndNum; i++){%>
										<li style="cursor:pointer;" onclick="javascript:location.href='${path}/admin/announce.go?pageNum=<%=pageNum%>'"><%=i%></li>
									<%}%>
									<li style="cursor:pointer;" onclick="javascript:location.href='${path}/admin/announce.go?pageNum=<%=totalPageNum%>'">마지막으로</li>
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