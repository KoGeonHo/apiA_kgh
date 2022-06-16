<%@page import="playnet.Vo.ContentsVo"%>
<%@page import="playnet.admin.Vo.CategoryVo"%>
<%@page import="java.util.ArrayList"%>
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
<script src="${path}/js/content.js"></script>
<%
	int cdidx = 0;

	if(request.getParameter("CdIdx") != null){
		cdidx = Integer.parseInt(request.getParameter("CdIdx"));
	}

	if(cdidx == 0){
		out.print("<script> alert('잘못된 접근입니다.'); history.back();</script>");
	}
	
	int pageNum;

	if(request.getParameter("pageNum") != null){
		pageNum = Integer.parseInt(request.getParameter("pageNum"));
	}else{
		pageNum = 1;
	}

	AdminMethods AM = new AdminMethods();
	ContentDetailVo cdv = AM.selContentDetail(cdidx);
	ArrayList<CategoryVo> CatePList = AM.selParentCate();
	
	int cate1 = cdv.getCate1();
	int cate2 = cdv.getCate2();
	String isSeries = cdv.getIsSeries();
		
	
	int cntConList = AM.CountContents(cdidx);
	
	//페이지별 출력 회원수,페이지번호수 
	int indexNum = AM.getIndexNum();
	
	int pageIdx = AM.getPageNumIdx();
	
	// 총페이지 수
	int totalPageNum = (int)(Math.ceil((double)cntConList/(double)indexNum));
	
	//페이지 시작번호
	int pageStartNum = (((pageNum-1)/pageIdx)*pageIdx)+1;
	
	//페이지 끝번호
	int pageEndNum = pageStartNum + (pageIdx - 1);
	
	if(pageEndNum > totalPageNum){
		pageEndNum = totalPageNum;
	}
%>
<script>
	$(function() {	
		
		if(<%=request.getParameter("tab")%> == 2){
			$("#details").css("display","none");
			$("#conList").css("display","block");	
		}else{
			$("#details").css("display","block");
			$("#conList").css("display","none");
		}
		
		if(<%=cate1%> != 0){
			let pCateIdx = <%=cate1%>;
			let html = "<option value='0'>-</option>";
			if(pCateIdx != 0){
				$.ajax({
					url : "conMng/ajax/getChildCate.jsp",
					data : "cateIdx="+pCateIdx,
					success : function(data){
						let json = JSON.parse(data.trim());
						if(json.length > 0){
							html ="<option value='0'>카테고리 선택</option>";
							for(let i = 0; i<json.length;i++){
								html += "<option value='"+json[i].cateIdx+"' ";
								if(<%=cate2%> == json[i].cateIdx){
									html += " selected ";
								}
								html += ">";
								html += json[i].cateName+"</option>";
							}
						}
						$("select[name=cate2]").html(html);
					}
				});
			}else{
				$("select[name=cate2]").html(html);
			}
		}
		
		$(".thumbNail").mouseover(function(){
			$(this).find("img").css("display","inline-block");
		});
		
		$(".thumbNail").mouseout(function(){
			$(this).find("img").css("display","none");
		});
		
		
		$("#detailsFrm").submit(function(){
			let title = $(this).find("input[name=title]");
			if(title.val() == ""){
				alert("제목을 입력해주세요");
				title.focus();
				return false;
			}
		});
		
	});
	
	function changeTab(num){
		if(num == 0){
			$("#details").css("display","block");
			$("#conList").css("display","none");
		}else{
			$("#details").css("display","none");
			$("#conList").css("display","block");			
		}
	}
	
	function movePages(pageNum){
		$("input[name=pageNum]").val(pageNum);
		$("input[name=tab]").val(2);
		$("#conListFrm").submit();
		
	}
	
	function moveToViewPage(cidx){
		location.href = '${path}/admin/contentsView.go?cidx='+cidx;
	}
	
	function modPoster(){
		let frm = $("#modalFrm")[0];
		let frmData = new FormData(frm);
		
		if($("input[name=poster1]").val() == "" && $("input[name=poster2]").val() == ""&& $("input[name=poster3]").val() == "" && $("input[name=poster4]").val() == "" && $("input[name=poster5]").val() == ""){
			alert("업로드할 이미지를 선택해주세요.");
		}else{
		
			$.ajax({
				url : "conMng/ajax/modPosters.jsp",
		        type : 'POST',
		        data : frmData,
		        contentType : false,
		        processData : false,
				success : function(data){
					let json = JSON.parse(data.trim());		
					let result = json[0].result;
					let poster1 = json[0].poster1;
					if(poster1 != null){
						$("#modal_poster1").html("<img class='Poster' src='${path}/images/poster/"+poster1+"'>");
						$("#poster1").html("<img src='${path}/images/poster/"+poster1+"' style='width:150px; height:220px; margin:5px;'>");
					}
					let poster2 = json[0].poster2;
					if(poster2 != null){
						$("#modal_poster2").html("<img class='Poster' src='${path}/images/poster/"+poster2+"'>");
						$("#poster2").html("<img src='${path}/images/poster/"+poster2+"' style='width:150px; height:220px; margin:5px;'>");
					}
					let poster3 = json[0].poster3;
					if(poster3 != null){
						$("#modal_poster3").html("<img class='Poster' src='${path}/images/poster/"+poster3+"'>");
						$("#poster3").html("<img src='${path}/images/poster/"+poster3+"' style='width:150px; height:220px; margin:5px;'>");
					}
					let poster4 = json[0].poster4;
					if(poster4 != null){
						$("#modal_poster4").html("<img class='Poster' src='${path}/images/poster/"+poster4+"'>");
						$("#poster4").html("<img src='${path}/images/poster/"+poster4+"' style='width:150px; height:220px; margin:5px;'>");
					}
					let poster5 = json[0].poster5;
					if(poster5 != null){
						$("#modal_poster5").html("<img class='Poster' src='${path}/images/poster/"+poster5+"'>");
						$("#poster5").html("<img src='${path}/images/poster/"+poster5+"' style='width:150px; height:220px; margin:5px;'>");
					}
					
					/*if(result == 1){
						alert("정상 처리되었습니다.");
						$(".modal").fadeOut();
					}*/
				}
			});
		}
		
	}
	
</script>
<style>
	
	#details th {
		padding:10px;
		width:80px;
	}
	
	#details td {
		width:300px;
	}
	select {
		width:120px;
		height:20px;
	}
	table li {
		display:inline-block;
	}
	img {
		border-radius:5px;
	}
		
	table ol {
		padding-inline-start:0px;
	}
		
	#conList table{
		border-collapse:collapse;
		text-align:center;
	}
	
	#conList td, #conList th{
		padding:5px 0;
	}
	
	#conList tbody tr:hover{
		background:white;
		color:black;
	}	
		
</style>
</head>
<body>

<div class="modal">
	<div class="modalContent" style="height:600px; width:550px;">			
		<div style="display:flex; min-height:100%; flex-direction:column;">
			<div><h3>포스터 수정하기</h3></div>
			<div style="margin:auto;">
				<div id="modal_poster1" style="display:inline-block;"><%
					if(cdv.getPoster1() == null){ out.print("<div class='noPoster'>No Image</div>"); }else{ out.print("<img class='Poster' src='/PlayNet/images/poster/"+cdv.getPoster1()+"'>");}
				%></div>
				<div id="modal_poster2" style="display:inline-block;"><%
						if(cdv.getPoster2() == null){ out.print("<div class='noPoster'>No Image</div>"); }else{ out.print("<img class='Poster' src='/PlayNet/images/poster/"+cdv.getPoster2()+"'>");}
				%></div>
				<div id="modal_poster3" style="display:inline-block;"><%
						if(cdv.getPoster3() == null){ out.print("<div class='noPoster'>No Image</div>"); }else{ out.print("<img class='Poster' src='/PlayNet/images/poster/"+cdv.getPoster3()+"'>");}
				%></div>
				<div id="modal_poster4" style="display:inline-block;"><%
						if(cdv.getPoster4() == null){ out.print("<div class='noPoster'>No Image</div>"); }else{ out.print("<img class='Poster' src='/PlayNet/images/poster/"+cdv.getPoster4()+"'>");}
				%></div>
				<div id="modal_poster5" style="display:inline-block;"><%
						if(cdv.getPoster5() == null){ out.print("<div class='noPoster'>No Image</div>"); }else{ out.print("<img class='Poster' src='/PlayNet/images/poster/"+cdv.getPoster5()+"'>");}
				%></div>
			</div>
			<div>
				<form id="modalFrm">
					<input type='hidden' name='cdIdx' value='<%=cdidx%>'>
					포스터1(대표)<br>
					<input type="file" name="poster1"><br>
					포스터2<br>
					<input type="file" name="poster2"><br>
					포스터3<br>
					<input type="file" name="poster3"><br>
					포스터4<br>
					<input type="file" name="poster4"><br>
					포스터5<br>
					<input type="file" name="poster5">
				</form>
			</div>
			<div style="height:30px; padding-top:10px; text-align:right;">				
				<button type="button" onclick="modPoster()" >수정</button>&nbsp;<button type="button" onclick="hideModal()">닫기</button>
			</div>
		</div>
	</div>
</div>

<%@ include file="../../common/adminNav.jsp" %>

<div class="wrap">
	<%@ include file="../../common/header.jsp" %>	
	<div id="adminContents" style="padding-left:180px; color:white;">
		<div style="padding-top:20px; display:block; vertical-align:top; width:1150px;">
			<div>
				<button type="button" onclick="changeTab(0)">상세정보</button>
				<button type="button" onclick="changeTab(1)">콘텐츠관리</button>
			</div>
		
			<div id="details">
				<form method="post" id="detailsFrm" action="${path}/admin/contentDetailModify.ok">
				<input type="hidden" name="cdidx" value="<%=cdidx%>">
				<table>
					<tr>
						<th style="width:90px;">제목</th>
						<td style="width:900px;"><input class="inputBox" type="text" name="title" value="<%=cdv.getTitle()%>"></td>
					</tr>
					<tr>
						<th>카테고리</th>
						<td>
							<select name="cate1">
								<option value="0">카테고리 선택</option>
								<%
									for(CategoryVo category : CatePList) {
										out.print("<option value='"+category.getCateIdx()+"'");
										
										if(category.getCateIdx() == cate1){
											out.print(" selected");
										}
										
										out.print(">"+category.getCateName()+"</option>");
									}
								%>
							</select>
							<select name="cate2">
								<option value="0">카테고리 선택</option>
							</select>
						</td>
					</tr>
					<tr>
						<th>공개여부</th>
						<td>
							<div style="display:inline;">
								<input type="radio" class="radio" name="isRelease" value="Y" <% if(cdv.getIsRelease().equals("Y")){ out.print("checked");}%>><span>공개</span></div>
							<div style="display:inline;"><input type="radio" class="radio" name="isRelease" value="N" <%if(cdv.getIsRelease().equals("N")){ out.print("checked");}%>><span>미공개</span></div>
						</td>
					</tr>
					<tr>
						<th>시리즈</th>
						<td>
							<div style="display:inline;"><input type="radio" class="radio" name="isSeries" value="N" <%if(cdv.getIsSeries().equals("N")) { out.print("checked");}%>><span>비시리즈</span></div>
							<div style="display:inline;"><input type="radio" class="radio" name="isSeries" value="Y" <%if(cdv.getIsSeries().equals("Y")) { out.print("checked");}%>><span>시리즈</span></div>
						</td>
					</tr>
					<tr>
						<th>공개일</th>
						<td>
							<input class="inputDate" type="date" name="rSdate" value="<%=cdv.getrSdate()%>"> ~ 
							<input class="inputDate" type="date" name="rEdate" value="<%=cdv.getrEdate()%>">
						</td>
					</tr>
					<tr>
						<th>출연</th>
						<td><input class="inputBox" style="width:300px" type="text" name="casting" value="<%=cdv.getCasting()%>"></td>
					</tr>
					<tr>
						<th>키워드</th>
						<td><input class="inputBox" style="width:300px" type="text" name="key_word" value="<%=cdv.getKeyword()%>"></td>
					</tr>
					<tr>
						<th>이미지<br>(포스터)<br><button type="button" style="margin:5px;" onclick="showModal()">수정하기</button>
						</th>
						<td>
							<div id="poster1" style="display:inline-block;">
							<%if(cdv.getPoster1() != null) {%>
								<img src="${path}/images/poster/<%=cdv.getPoster1()%>" style="width:150px; height:220px; margin:5px;">
							<%}	%>
							</div>
							<div id="poster2" style="display:inline-block;">
								<%if(cdv.getPoster2() != null){%>
									<img src="${path}/images/poster/<%=cdv.getPoster2()%>" style="width:150px; height:220px; margin:5px;">
								<%}%>
							</div>
							<div id="poster3" style="display:inline-block;">
								<%if(cdv.getPoster3() != null){%>
									<img src="${path}/images/poster/<%=cdv.getPoster3()%>" style="width:150px; height:220px; margin:5px;">
								<%}%>
							</div>
							<div id="poster4" style="display:inline-block;">
								<%if(cdv.getPoster4() != null){ %>
									<img src="${path}/images/poster/<%=cdv.getPoster4()%>" style="width:150px; height:220px; margin:5px;">
								<%}%>
							</div>
							<div id="poster5" style="display:inline-block;">
								<%if(cdv.getPoster5() != null){%>
									<img src="${path}/images/poster/<%=cdv.getPoster5()%>" style="width:150px; height:220px; margin:5px;">
								<%}%>
							</div>
						</td>
					</tr>
					<tr>
						<th>
							소개
						</th>
						<td>
							<textarea name="description" cols="120" rows="20" style="resize:none; padding:10px;" spellcheck="false"><%=cdv.getDescription()%></textarea>
						</td>
					</tr>
					<tr>
						<td colspan="2" style="text-align:right;">
							<button type="submit">수정</button>
							<button type="button" onclick="javascript:location.href='${path}/admin/contentDetailList.go'">목록</button>
						</td>
					</tr>
				</table>
				</form>
			</div>		
			
			<!-- 등록된 콘텐츠 목록 및 관리 -->	
			<div id="conList" style="display:none;">
				<form id="conListFrm" method="POST" action="${path}/admin/contentDetailView.go">
					<input type="hidden" name="pageNum" value="<%=pageNum%>">
					<input type="hidden" name="CdIdx" value="<%=cdidx%>">
					<input type="hidden" name="tab" value="<%=request.getParameter("tab")%>">				
				</form>
				<table>
					<thead>
						<tr>
							<th style="width:300px;">
								제목
							</th>
							<th style="width:80px;">
								구분
							</th>
							<th style="width:50px;">
								시즌
							</th>
							<th style="width:80px;">
								에피소드
							</th>
							<th style="width:450px;">
								URL
							</th>
							<th style="width:120px;">
								공개일
							</th>
						</tr>
					</thead>
					<tbody>
						<%
							ArrayList<ContentsVo> conList = new ArrayList<>();
							conList = AM.selContentsAll(cdidx);
							
							for(ContentsVo CV : conList){
								out.print("<tr style='cursor:pointer;' onclick='moveToViewPage("+CV.getCIdx()+")'>");
								out.print("<td class='thumbNail'>"+CV.getTitle());
								if(CV.getThumbNail()!=null){
									out.print("<img style='display:none; width:200px; height:auto; position:absolute;' src='/PlayNet/images/thumbNails/"+CV.getThumbNail()+"'>");
								}
									
								out.print("</td>");
								if(CV.getDivision() == 1){
									out.print("<td>예고편</td>");
								}else if(CV.getDivision() == 2){
									out.print("<td>비디오</td>");
								}else{
									out.print("<td>기타</td>");
								}
								if(CV.getSeason() == 0){
									out.print("<td>-</td>");
								}else{
									out.print("<td>"+CV.getSeason()+"</td>");
								}
								if(CV.getEpisode() == 0){
									out.print("<td>-</td>");
								}else{
									out.print("<td>"+CV.getEpisode()+"</td>");
								}
								out.print("<td>"+CV.getURL()+"</td>");
								out.print("<td>"+CV.getReleaseDate()+"</td></tr>");
								
							}
						%>										
					</tbody>
					<tfoot>
						<tr>
							<td colspan='7'style="text-align:right;">
								<button type="button" onclick="javascript:location.href='${path}/admin/contentsInsert.go?CdIdx=<%=cdidx%>'">등록</button>
								<button type="button" onclick="javascript:location.href='${path}/admin/contentDetailList.go'">목록</button>
							</td>
						</tr>
						<tr>
							<td colspan='7'>
								<div id="paging" style="text-align:center;">
									<ol style="list-style:none;">
										<li style="cursor:pointer;" onclick="movepages(1)">처음으로</li>
										<%
										for(int i = pageStartNum; i <= pageEndNum; i++){%>
											<li style="cursor:pointer;" onclick="movepages(<%=pageNum%>)"><%=i%></li>
										<%}%>
										<li style="cursor:pointer;" onclick="movePages(<%=totalPageNum%>)">마지막으로</li>
									</ol>
								</div>
							</td>
						</tr>	
					</tfoot>
				</table>
			</div>
		</div>
	</div>
</div>
</body>
</html>