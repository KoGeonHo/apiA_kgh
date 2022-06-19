<%@page import="playnet.Vo.AskVo"%>
<%@page import="playnet.user.UserMethods"%>
<%@page import="playnet.admin.Vo.CategoryVo"%>
<%@page import="java.util.*"%>
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
int aidx = 0;

if(request.getParameter("aidx") != null){
	aidx = Integer.parseInt(request.getParameter("aidx"));
}else{
	out.print("<script>alert('잘못된 접근입니다.'); history.back();</script>");
}

UserMethods UM = new UserMethods();
AskVo AskV = UM.selAsk(aidx);
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


<%@ include file="../../common/nav.jsp" %>

<div class="wrap">
	<%@ include file="../../common/header.jsp" %>	
	<div id="contents2" style="color:white;">
		<div style="padding-top:20px; display:block; vertical-align:top;">
			<h2>공지사항 등록</h2>
			<div>
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
								<img src='${ path }/images/askAttach/<%=AskV.getAttach()%>' width='800px' height='auto'>
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
							답변자
						</th>
						<td colspan='3'>
							<%if(AskV.getAnsWriter() != null){
								out.print(AskV.getAnsWriter());
							}else{
								out.print("-");
							}
							%>
						</td>
					</tr>
					<tr>
						<th>
							답변
						</th>
						<td colspan='3'>
							<%if(AskV.getAnscontent() != null){
								out.print(AskV.getAnscontent());
							}else{
								out.print("답변 대기중입니다.");
							}
							%>
						</td>
					</tr>
					<tr>
						<td colspan="4" style="text-align:right;">
							<button type="button" onclick="javascript:location.href='${ path }/user/ask.go';">목록</button>
						</td>
					</tr>
				</table>
			</div>			
		</div>
	</div>
	<%@ include file="../../common/footer.jsp" %>
</div>
</body>
</html>