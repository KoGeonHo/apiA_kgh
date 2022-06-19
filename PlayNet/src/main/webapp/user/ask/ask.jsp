<%@page import="playnet.Vo.AskVo"%>
<%@page import="java.util.ArrayList"%>
<%@page import="playnet.user.UserMethods"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>PlayNet</title>
<link rel="stylesheet" type="text/css" href="${ path }/css/main.css">
<link rel="stylesheet" type="text/css" href="${ path }/css/nav.css">
<script src="${ path }/js/jquery-3.6.0.js"></script>
<script src="${ path }/js/main.js"></script>
<%
int midx = 0;
int pageNum = 1;
if(session.getAttribute("midx") != null){
	midx = (int)session.getAttribute("midx");
}

if(request.getParameter("pageNum") != null){
	pageNum = Integer.parseInt(request.getParameter("pageNum"));
}

UserMethods UM = new UserMethods();
ArrayList<AskVo> aList = UM.selAskAll(midx);

int cntAskList = UM.cntAsk(midx);

//페이지별 출력 회원수,페이지번호수 
int indexNum = UM.getIndexNum();

int pageIdx = UM.getPageNumIdx();

//총페이지 수
int totalPageNum = (int)(Math.ceil((double)cntAskList/(double)indexNum));

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
</head>
<body>

<%@ include file="../../common/nav.jsp" %>	

<div class="wrap">
	<%@ include file="../../common/header.jsp" %>	
	<div id="contents2" style=" color:white;">
		<h1 style="margin:0px;">문의하기</h1><hr>
		<table>
			<thead>
				<tr>
					<th style="width:500px;">제목</th>
					<th style="width:120px;">작성일</th>
					<th style="width:100px;">처리상태</th>
				</tr>
			</thead>
			<tbody>
				<%
				for(AskVo AsV : aList){
				%>
					<tr onclick="location.href='${ path }/user/askView.go?aidx=<%=AsV.getAidx()%>'">
						<td style="text-align:center;"><%=AsV.getTitle()%></td>
						<td style="text-align:center;"><%=AsV.getAskdate()%></td>
						<td style="text-align:center;">
							<%if(AsV.getAnspn() == 0){ 
								out.print("대기"); 
							}else if(AsV.getAnspn() == 1){
								out.print("처리중");
							}else if(AsV.getAnspn() == 2){
								out.print("처리 완료");
							}%>
						</td>
					</tr>
				<%} %>
				<tr>
					<td colspan='3'>
						<div id="paging" style="text-align:center;">
							<ol style="list-style:none;">
								<li style="cursor:pointer;" onclick="javascript:location.href='${ path }/user/ask.go?pageNum=1'">처음으로</li>
								<%
								for(int i = pageStartNum; i <= pageEndNum; i++){%>
									<li style="cursor:pointer;" onclick="javascript:location.href='${ path }/user/ask.go?pageNum=<%=pageNum%>'"><%=i%></li>
								<%}%>
								<li style="cursor:pointer;" onclick="javascript:location.href='${ path }/user/ask.go?pageNum=<%=totalPageNum%>'">마지막으로</li>
							</ol>
						</div>
					</td>
					<td style="text-align:center;">
						<button type="button" onclick="location.href='${ path }/user/askInsert.go'">글쓰기</button>
					</td>
				</tr>			
			</tbody>
		</table>
	</div>
	<%@ include file="../../common/footer.jsp" %>
</div>
</body>
</html>