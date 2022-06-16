<%@page import="playnet.admin.AdminMethods"%>
<%@page import="playnet.Vo.AskVo"%>
<%@page import="java.util.*"%>
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
int aidx = 0;

if(request.getParameter("aidx") != null){
	aidx = Integer.parseInt(request.getParameter("aidx"));
}else{
	out.print("<script>alert('잘못된 접근입니다.'); history.back();</script>");
}

AdminMethods AM = new AdminMethods();
AskVo AskV = AM.selAsk(aidx);
%>
<script>
$(function(){
	$("#askFrm").submit(function(){
		let title = $("input[name=title]");
		if(title.val() == ""){
			alert("제목을 입력해주세요");
			title.focus();
			return false;
		}
	});
});

</script>
<style>
	table {		
		border-collapse: collapse;
	}
	th, td{
		padding:15px;
		border-top : 2px solid #222;
	}
	
	th {
		width:100px;
		text-align:center;
		background:#444;
	}
</style>
</head>
<body>

<%@ include file="../../common/adminNav.jsp" %>

<div class="wrap">
	<%@ include file="../../common/header.jsp" %>	
	<div id="contents2" style="padding-left:180px; color:white;">
		<div style="padding-top:20px; display:block; vertical-align:top;">
			<h2>공지사항 등록</h2>
			<div>
				<form id="askFrm" method="POST" action="${path}/admin/answer.ok">
					<input type="hidden" name="aidx" value="<%=aidx%>">
					<table>
						<tr>
							<th >제목</th>
							<td style="width:450px;">
								<%=AskV.getTitle()%>
							</td>
							<th>
								처리상태
							</th>
							<td style="width:100px;">
								<%if(AskV.getAnspn()==0){ %>
									대기
								<%}else if(AskV.getAnspn()==1){%>
									처리중
								<%}else if(AskV.getAnspn()==2){%>
									처리완료
								<%} %>
							</td>
						</tr>
						<tr>
							<th>
								첨부 이미지
							</th>
							<td colspan='3' id="imageTd">
								<%if(AskV.getAttach() != null){ %>
									<img src='${path}/images/askAttach/<%=AskV.getAttach()%>' width='800px' height='auto'>
								<%}else{%>
									No Image
								<%}%>
							</td>
						</tr>
						<tr>
							<th>
								내용
							</th>
							<td colspan='3'>
								<%=AskV.getContent()%>
							</td>
						</tr>
						<tr>
							<th>
								처리현황
							</th>
							<td colspan='3'>
								<select name="anspn">
									<option value="0" <%if(AskV.getAnspn() == 0){ out.print("selected"); }%>>대기</option>
									<option value="1" <%if(AskV.getAnspn() == 1){ out.print("selected"); }%>>처리중</option>
									<option value="2" <%if(AskV.getAnspn() == 2){ out.print("selected"); }%>>처리완료</option>
								</select>
							</td>
						</tr>
						<tr>
							<th>
								답변
							</th>
							<td colspan='3'>
								<textarea name='anscontent' rows="10" cols="100" style="width:100%;"><%if(AskV.getAnscontent() != null){ out.print(AskV.getAnscontent()); }%></textarea>
							</td>
						</tr>
						<tr>
							<td colspan="4" style="text-align:right;">
								<button type="submit">등록</button>
								<button type="button" onclick="javascript:location.href='${path}/admin/ask.go';">목록</button>
							</td>
						</tr>
					</table>
				</form>
			</div>			
		</div>
	</div>
</div>
</body>
</html>