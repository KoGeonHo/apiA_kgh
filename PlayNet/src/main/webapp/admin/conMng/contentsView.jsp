<%@page import="playnet.Vo.ContentsVo"%>
<%@page import="playnet.Vo.ContentDetailVo"%>
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
<link rel="stylesheet" type="text/css" href="${path}/css/modal.css">
<script src="${path}/js/jquery-3.6.0.js"></script>
<script src="${path}/js/mainForAdmin.js"></script>
<script src="${path}/js/modal.js"></script>
<%
int cidx = 0;
String isSeries = "";

if(request.getParameter("cidx") == null || request.getParameter("cidx") == ""){
	out.print("<script>alert('잘못된 접근입니다.'); history.back();</script>");
}else{
	cidx = Integer.parseInt(request.getParameter("cidx"));
}

AdminMethods AM = new AdminMethods();

ContentsVo CV = AM.selContents(cidx);

ContentDetailVo cdv = AM.selContentDetail(CV.getCdIdx());
isSeries = cdv.getIsSeries();
String rSdate = cdv.getrSdate();
%>
<style>		
	th {
		padding:10px;
		width:80px;
	}
	
	td {
		width:300px;
	}
	
	select {
		width:120px;
		height:20px;
	}
	
	img {
		border-radius:5px;
	}		
	
</style>
<script>
	$(function(){
		
		$("input[name=title]").val("<%=CV.getTitle()%>");
		$("select[name=division]").val(<%=CV.getDivision()%>);		
		if(<%=CV.getDivision()%> == 2){	$(".isSeries").attr("disabled",false); }		
		$("input[name=season]").val(<%=CV.getSeason()%>);
		$("input[name=episode]").val(<%=CV.getEpisode()%>);
		$("input[name=releaseDate]").val("<%=CV.getReleaseDate()%>");
		$("input[name=contentsUrl]").val("<%=CV.getURL()%>");
		$("input[name=runMin]").val(<%=CV.getRunMin()%>);
		$("input[name=runSec]").val(<%=CV.getRunSec()%>);
		if("<%=CV.getThumbNail()%>" == "null"){
			$("#divThumbNail").html("<span> No ThumbNail </span>");
		}else{
			$("#divThumbNail").html("<img class='thumbNails'src='${path}/images/thumbNails/<%=CV.getThumbNail()%>' width='200px' height='auto'>");
		}
		$("textarea[name=description]").val("<%=CV.getDescription()%>");
		
		
		
		
		if("<%=isSeries%>" == "Y"){
			$("select[name=division]").change(function(){
				if($(this).find("option:selected").val() == 2){
					$(".isSeries").val("");
					$(".isSeries").attr("disabled",false);
					$(".isSeries:first").focus();
				}else{
					$(".isSeries").val("0");
					$(".isSeries").attr("disabled",true);
				}
			});
		}else{
			$(".isSeries").parent().parent().css("display","none");
		}
		
		
		
		
		
		$("#conFrm").submit(function(){
			let title = $(this).find("input[name=title]");
			let division = $(this).find("select[name=division]");
			let season = 0;
			let episode = 0;
			if("<%=isSeries%>" == "Y") {
				season = $(this).find("input[name=season]");
				episode = $(this).find("input[name=episode]");
			}			
			let releaseDate = $(this).find("input[name=releaseDate]");
			let contentsUrl = $(this).find("input[name=contentsUrl]");
			let runMin = $(this).find("input[name=runMin]");
			let runSec = $(this).find("input[name=runSec]");
			let description = $(this).find("textarea[name=description]");
			
			if(title.val() == ""){
				alert("제목을 입력하세요");
				title.focus();
				return false;
			}else if(division.val() == "0"){
				alert("구분을 선택하세요")
				division.focus();
				return false;
			}else if("<%=isSeries%>" == "Y" && division.val() == 2){
				if(season.val() <= 0){
					alert('잘못된 입력입니다.');
					season.focus();
					return false;
				}else if(episode.val() <= 0){
					alert('잘못된 입력입니다.');
					episode.focus();
					return false;
				}
			}else if(releaseDate.val() < "<%=rSdate%>" ){
				alert("콘텐츠 공개일(<%=rSdate%>) 보다 빠를수 없습니다.");
				return false;
			}else if(contentsUrl.val() == ""){
				alert("영상 파일의 경로를 입력해주세요");
				contentsUrl.focus();
				return false;
			}else if(runMin.val() == "" || runSec.val() == ""){
				alert("영상 재생시간을 입력해주세요");
				runMin.focus()
				return false;
			}else if(description.val() == ""){
				alert("줄거리를 입력해주세요");
				discription.focus()
				return false;
			}else{
				$(".isSeries").attr("disabled",false);
			}
			
		});
		
		
	});
	
	function chkDate(obj){
		if($(obj).val() < "<%=rSdate%>" ){
			alert("콘텐츠 공개일(<%=rSdate%>) 보다 빠를수 없습니다.");
			$(obj).val("<%=rSdate%>");
			$(obj).blur();
		}else{
			$(obj).blur();
		}
	}
	
	function showModal(){
		$(".modal").fadeIn();
	}
	
	function hideModal(){
		$(".modal").fadeOut();
	}
	
	function modThumbNail(){
		let frm = $("#modalFrm")[0];
		let frmData = new FormData(frm);
		
		if($("input[name=thumbNail]").val() == ""){
			alert("업로드할 이미지를 선택해주세요.");
		}
		
		$.ajax({
			url : "conMng/ajax/modThumbNail.jsp",
	        type : 'POST',
	        data : frmData,
	        contentType : false,
	        processData : false,
			success : function(data){
				let json = JSON.parse(data.trim());
				if(json[0].result == 1){
					alert("수정 완료");
					$(".thumbNails").attr("src","${path}/images/thumbNails/"+json[0].thumbNail);
					if("<%=CV.getThumbNail()%>" == "null"){
						$("#divThumbNail").html("<img class='thumbNails' src='${path}/images/thumbNails/"+json[0].thumbNail+"'  width='200px' height='auto'>");
						$("#modalThumbNail").html("<img class='thumbNails' src='${path}/images/thumbNails/"+json[0].thumbNail+"' width='auto' height='150px'>");
					}
				}else{
					alert("수정 실패");
				}
			}
		});
		
	}
	
	function delChk(){
		
		if(confirm("정말 삭제하시겠습니까?")){
			location.href="${path}/admin/contentsDel.ok?CIdx=<%=CV.getCIdx()%>&CdIdx=<%=CV.getCdIdx()%>";
		}
	}
</script>
</head>
<body>


<div class="modal">
	<div class="modalContent">			
		<div style="display:flex; min-height:100%; flex-direction: column;">
			<div><h3>썸네일 수정하기</h3></div>
			<div style="margin:auto;" id="modalThumbNail">
				<%if(CV.getThumbNail() == null){ out.print("No Image"); }else{ out.print("<img class='thumbNails' src='/PlayNet/images/thumbNails/"+CV.getThumbNail()+"' width='auto' height='150px'>"); } %>
			</div>
			<div>
				<form id="modalFrm">
					<input type='hidden' name='cIdx' value='<%=CV.getCIdx()%>'>
					<input type="file" name="thumbNail" data-width="250" data-height="150">
				</form>
			</div>
			<div style="height:30px; padding-top:10px; text-align:right;">				
				<button type="button" onclick="modThumbNail()" >수정</button>&nbsp;<button type="button" onclick="hideModal()">닫기</button>
			</div>
		</div>
	</div>
</div>


<%@ include file="../../common/adminNav.jsp" %>

<div class="wrap">
	<%@ include file="../../common/header.jsp" %>	
	<div id="adminContents" style="padding-left:180px; color:white;">
		<div style="margin:20px;">
			<h2><%=CV.getTitle()%> - 콘텐츠 수정</h2>	
			<form id="conFrm" method="POST" action="${path}/admin/contentsModify.ok">
			<input type="hidden" name="cIdx" value="<%=CV.getCIdx()%>">
				<table>
					<tr>
						<th>
							제목
						</th>
						<td>
							<input class="inputBox" type="text" name="title" placeholder="제목" >
						</td>
					</tr>
					<tr>
						<th>
							구분
						</th>
						<td>
							<select name="division">
								<option value="0">선택</option>
								<option value="1">예고편</option>
								<option value="2">메인콘텐츠</option>
								<option value="3">비하인드 및 기타</option>
							</select>
						</td>
					</tr>
					<!-- division option을 2(에피소드)로 선택했을때 활성 -->
					<tr>
						<th>
							시즌
						</th>
						<td>
							<input class="inputBox isSeries" type="number" value="0" name="season" style="width:50px;" disabled>
						</td>
					</tr>
					<tr>
						<th>
							에피소드
						</th>
						<td>
							<input class="inputBox isSeries" type="number" value="0" name="episode" style="width:50px;" disabled>
						</td>
					</tr>
					<tr>
						<th>
							공개일
						</th>
						<td>
							<input class="inputBox" name="releaseDate" type="date" onchange="chkDate(this)"><!-- default는 contentdetail의 releaseSDate를 따라감 -->
						</td>
					</tr>
					<tr>
						<th>
							영상URL
						</th>
						<td>
							<input class="inputBox" type="text" name="contentsUrl" value=""><br>
							<span>ex) /playnet/videos/wandavision/s01/e01.mp4</span>
						</td>
					</tr>
					<tr>
						<th>
							재생시간
						</th>
						<td>
							<input class="inputBox" type='number' name="runMin" style="width:50px;"> 분
							<input class="inputBox" type='number' name="runSec" style="width:50px;"> 초
						</td>
					</tr>
					<tr>
						<th>
							썸네일
						</th>
						<td>
							<div id="divThumbNail"></div>
							<button type="button" id="ThumbNailBtn" onclick="showModal()">썸네일 수정하기</button>
						</td>
					</tr>
					<tr>
						<th>
							줄거리
						</th>
						<td>
							<textarea name="description" cols="100" rows="10" style="resize:none; padding:10px;" placeholder="줄거리를 입력하세요"></textarea>
						</td>
					</tr>
					<tr>
						<td colspan='2' style="text-align:right;">
							<button type="submit">수정</button>
							<button type="button" onclick="delChk()">삭제</button>
							<button type="button" onclick="javascript:location.href='${path}/admin/contentDetailView.go?CdIdx=<%=CV.getCdIdx()%>&tab=2';">목록</button>
						</td>
					</tr>
				</table>
			</form>
		</div>
	</div>
</div>
</body>
</html>