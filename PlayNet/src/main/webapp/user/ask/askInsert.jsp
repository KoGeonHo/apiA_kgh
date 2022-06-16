<%@page import="playnet.admin.Vo.CategoryVo"%>
<%@page import="java.util.*"%>
<%@page import="playnet.admin.AdminMethods"%>
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
<script>
$(function(){
	$("#askFrm").submit(function(){
		let title = $("input[name=title]");
		if(title.val() == ""){
			alert("제목을 입력해주세요");
			title.focus();
			return false;
		}
		
		//alert($("input[name=attach]").val());
		//return false;
	});	
	
	$("input[name=attach]").change(function(){
		let frm = $("#askFrm")[0];
		let frmData = new FormData(frm);
		if($("input[name=attach]").val() != ""){
			$.ajax({
				url : "ask/ajax/uploadAttach.jsp",
		        type : 'POST',
		        data : frmData,
		        contentType : false,
		        processData : false,
				success : function(data){
					let json = JSON.parse(data.trim());
					//console.log(data.trim())
					//if(json[0].result == 1){
					$("#imageTd").html("<img src='<%=request.getContextPath()%>/images/askAttach/"+json[0].attach+"' width='800px' height='auto'>");
						//if( == "null"){
						//	$("#divThumbNail").html("<img class='thumbNails' src='/PlayNet/images/thumbNails/"+json[0].thumbNail+"'  width='200px' height='auto'>");
						//	$("#modalThumbNail").html("<img class='thumbNails' src='/PlayNet/images/thumbNails/"+json[0].thumbNail+"' width='auto' height='150px'>");
						//}
					//}else{
					//	alert("수정 실패");
					//}
				}
			});
		}else{
			$("#imageTd").html("No Image");
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
	
	td {
		width:900px;
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
				<form id="askFrm" method="POST" action="${ path }/user/askInsert.ok">
					<table>
						<tr>
							<th style="width:90px;">제목</th>
							<td>
								<input class="inputBox" type="text" name="title" >
							</td>
						</tr>
						<tr>
							<th>
								첨부 이미지
							</th>
							<td>
								<input type="file"accept="image/*" name="attach">
							</td>
						</tr>
						<tr>
							<th>
								첨부 이미지 미리보기
							</th>
							<td id="imageTd">
								No Image
							</td>
						<tr>
							<th>
								내용
							</th>
							<td>
								<textarea id="txtContent" name='content' rows="10" cols="100" style="width:100%;"></textarea>
							</td>
						</tr>
						<tr>
							<td colspan="2" style="text-align:right;">
								<button type="submit">등록</button>
								<button type="button" onclick="javascript:location.href='${ path }/user/ask.go';">목록</button>
							</td>
						</tr>
					</table>
				</form>
			</div>			
		</div>
	</div>
	<%@ include file="../../common/footer.jsp" %>
</div>
</body>
</html>