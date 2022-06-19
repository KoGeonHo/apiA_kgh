<%@page import="playnet.admin.Vo.CategoryVo"%>
<%@page import="java.util.*"%>
<%@page import="playnet.admin.AdminMethods"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>PlayNet Admin</title>
<link rel="stylesheet" type="text/css" href="${path}/css/main.css">
<link rel="stylesheet" type="text/css" href="${path}/css/navFixed.css">
<script src="${path}/js/jquery-3.6.0.js"></script>
<script src="${path}/js/mainForAdmin.js"></script>
<style>	
	
	#details th {
		padding:10px;
		width:80px;
	}
	
	#details td {
		width:300px;
	}
	
	
</style>
<!-- 네이버 스마트에디터  -->
<script type="text/javascript" src="${path}/libs/smarteditor/js/service/HuskyEZCreator.js" charset="utf-8"></script>
<script>
$(function(){
	$("#annFrm").submit(function(){
		let title = $(this).find("input[name=title]");
		oEditors.getById["txtContent"].exec("UPDATE_CONTENTS_FIELD", []);  
		
		if(title.val() == ""){
			alert("제목을 입력해주세요");
			title.focus();
			return false;
		}
	});	
});	

function checkTop(){
	$.ajax({
		url : "../ajax/getCntTopAnn.jsp",
		success : function(data){
			let cnt = data.trim();
			console.log(cnt);
			if(cnt >= 5){
				alert("상단 고정 공지는 최대 5개까지만 등록이 가능합니다.");
				$("#isTop").prop("checked",false);
			}
		}
	});
}
</script>
</head>
<body>


<%@ include file="../../common/adminNav.jsp" %>

<div class="wrap">
	<%@ include file="../../common/header.jsp" %>	
	<div id="adminContents" style="padding-left:180px; color:white;">
		<div style="padding-top:20px; display:block; vertical-align:top; width:1150px;">
			<h2>공지사항 등록11</h2>
			<div id="details">
				<form id="annFrm" method="POST" action="${path}/admin/announceInsert.ok">
					<table>
						<tr>
							<th style="width:90px;">제목</th>
							<td style="width:900px;">
								<input class="inputBox" type="text" name="title" >
								<input type="checkbox" name="isTop" value="Y" id="isTop" onclick="checkTop()"> <label for="isTop">상단고정</label>
							</td>
						</tr>
						<tr>
							<th>
								내용
							</th>
							<td>
								<textarea id="txtContent" name='content' rows="10" cols="100" style="width:100%;"></textarea>
								<!-- textarea 밑에 script 작성하기 -->
								<script id="smartEditor" type="text/javascript"> 
									var oEditors = [];
									nhn.husky.EZCreator.createInIFrame({
									    oAppRef: oEditors,
									    elPlaceHolder: "txtContent",  //textarea ID 입력
									    sSkinURI: "${path}/libs/smarteditor/SmartEditor2Skin.html",  //martEditor2Skin.html 경로 입력
									    fCreator: "createSEditor2",
									    htParams : { 
								    	// 툴바 사용 여부 (true:사용/ false:사용하지 않음) 
								        bUseToolbar : true, 
										// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음) 
										bUseVerticalResizer : false, 
										// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음) 
										bUseModeChanger : true 
									    }
									});
								</script>
							</td>
						</tr>
						<tr>
							<td colspan="2" style="text-align:right;">
								<button type="submit" >등록</button>
								<button type="button" onclick="javascript:location.href='${path}/admin/announce.go';">목록</button>
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