<%@page import="playnet.Vo.ContentDetailVo"%>
<%@page import="java.util.ArrayList"%>
<%@page import="playnet.admin.AdminMethods"%>
<%@page import="playnet.admin.Vo.CategoryVo"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>PlayNet Admin</title>
<link rel="stylesheet" type="text/css" href="${path}/css/main.css">
<link rel="stylesheet" type="text/css" href="${path}/css/navFixed.css">
<link rel="stylesheet" type="text/css" href="${path}/css/ConDetailList.css">
<script src="${path}/js/jquery-3.6.0.js"></script>
<script src="${path}/js/mainForAdmin.js"></script>
<script src="${path}/js/content.js"></script>
<%
int pageNum;

if(request.getParameter("pageNum") == null){
	pageNum = 1;
}else{
	pageNum = Integer.parseInt(request.getParameter("pageNum"));
}

int cate1 = 0;
int cate2 = 0;
String title = "";
String sDate = "";
String eDate = "";
String key_word = "";

String isRelease = "";

if(request.getParameter("cate1") != null){
	cate1 = Integer.parseInt(request.getParameter("cate1"));
}

if(request.getParameter("cate2") != null){
	cate2 = Integer.parseInt(request.getParameter("cate2"));
}

if(request.getParameter("title") != null){
	title = request.getParameter("title");
}

if(request.getParameter("sDate") != null){
	sDate = request.getParameter("sDate");
}

if(request.getParameter("eDate") != null){
	eDate = request.getParameter("eDate");
}

if(request.getParameter("key_word") != null){
	key_word = request.getParameter("key_word");
}

if(request.getParameter("isRelease") != null){
	isRelease = request.getParameter("isRelease");
}

//카테고리 리스트 get
AdminMethods AM = new AdminMethods();
ArrayList<CategoryVo> CatePList = AM.selParentCate();

//contentDetail 리스트 get
ArrayList<ContentDetailVo> conDetailList = AM.selContentDetailAll(pageNum,cate1,cate2,title,sDate,eDate,key_word,isRelease);

int cntConList = AM.CntContentDetail(cate1,cate2,title,sDate,eDate,key_word,isRelease);

//페이지별 출력 회원수,페이지번호수 
int indexNum = AM.getConIndexNum();

int pageIdx = AM.getPageNumIdx();

//총페이지 수
int totalPageNum = (int)(Math.ceil((double)cntConList/(double)indexNum));

//페이지 시작번호
int pageStartNum = (((pageNum-1)/pageIdx)*pageIdx)+1;

//페이지 끝번호
int pageEndNum = pageStartNum + (pageIdx - 1);

if(pageEndNum > totalPageNum){
	pageEndNum = totalPageNum;
}

//ContentDetail List for문 index변수 
int CDIndex = 1;
%>
<script>
	$(function(){
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
		
		$("#searchFrm").submit(function(){
			//키워드 유효성 검사.
			let KW = $("input[name=key_word]");
			if(KW.val().includes("#")){
				if(KW.val().trim().replaceAll("#","") == ""){
					alert("유효하지 않은 검색입니다.");
					KW.val("");
					KW.focus();	
					return false;
				}
			}
		});
		
	});
	
	function ConDetailView(CdIdx){
		location.href="${path}/admin/contentDetailView.go?CdIdx="+CdIdx;
	}
</script>
</head>
<body>

<%@ include file="../../common/adminNav.jsp" %>

<div class="wrap">
	<%@ include file="../../common/header.jsp" %>	
	<div id="adminContents" style="padding-left:180px; color:white;">
		<h1>콘텐츠</h1>
		<div id="conSearch">
			<hr>
			<form id="searchFrm" method="post" action="${path}/admin/contentDetailList.go">
				<table style="width:760px;">
					<tr>
						<th style="width:200px;">
							카테고리
						</th>
						<td>
							<select class="select" name="cate1">
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
							<select class="select" name="cate2">
								<option value="0">-</option>
							</select>
						</td>
						<th style="width:200px;">제목</th>
						<td>
							<input class="inputBox" type="text" name="title" value="<%=title%>">
						</td>					
					</tr>
					<tr>
						<th>
							등록일
						</th>
						<td>
							<input class="inputDate" type="date" name="sDate" value="<%=sDate%>"> ~ <input class="inputDate" type="date" name="eDate" value="<%=eDate%>">
						</td>
						<th>
							공개여부
						</th>
						<td>
							<select name="isRelease">
								<option value="">전체</option>
								<option value="Y" <%if(isRelease.equals("Y")) { out.print("selected"); }%>>공개</option>
								<option value="N" <%if(isRelease.equals("N")) { out.print("selected"); }%>>미공개</option>
							</select>
						</td>	
					</tr>
					<tr>
						<th>
							키워드
						</th>
						<td>
							<input class="inputBox" name="key_word" type="text" value="<%=key_word%>"> <br><span style="font-size:0.9em;">'#'을 사용하여 다중키워드로 검색합니다.</span>
						</td>
						<th>
							<button type="submit" id="searchBtn">검색</button>
						</th>
					</tr>
				</table>
			</form>
			<hr>			
		</div>		
		
		<div id="contentsList">			
			<table>
				<tr>
					<td colspan="4" style="width:1300px;">
						<div style="text-align:right;">
							<button type="button" onclick="javascript:location.href='${path}/admin/contentDetailInsert.go'">등록</button>
						</div>
					</td>
				</tr>
				<tbody>				
				<%for(ContentDetailVo cdv : conDetailList){
					if(CDIndex == 1){ 
							out.print("<tr>");
						} 
						CategoryVo getCateName = AM.getCateInfo(cdv.getCate1());
						CategoryVo getCateName2 = AM.getCateInfo(cdv.getCate2());
					%>
					<td>
						<div class="con_items" style="width:300px;" onclick="ConDetailView(<%=cdv.getCdIdx()%>)">
							<span><%=cdv.getTitle()%></span>
							<div style="margin:5px; font-size:0.8em;">
								<img src="${path}/images/poster/<%=cdv.getPoster1()%>" style="width:100px; height:auto;">
								<div style="vertical-align:top; padding:10px; display:inline-block;">
									<span style="display:block; padding:5px;">
										<%=getCateName.getCateName()%>
										<%if(cdv.getCate2() != 0) {
											out.print(" - "+getCateName2.getCateName());
										} %> 
									</span>									
									<%if(cdv.getIsRelease().equals("N")) { 
										out.print("<span style='display:block; padding:5px; color:red;'>미공개</span>"); 
									}%>									
									<span style="display:block; padding:5px;">등록일 : <%=cdv.getIstDate()%></span>
									<span style="display:block; padding:5px;">공개일 :<br> <%=cdv.getrSdate()%><br>~<%=cdv.getrEdate()%></span>
								</div>
							</div>
						</div>
					</td>
					<%
					if(CDIndex < conDetailList.size()){
						if(CDIndex % 4 == 0 && CDIndex > 0) {
							out.print("</tr><tr>");
						}
					}else{
						out.print("</tr>");
					}
					CDIndex++;} %>
				</tbody>
				<tr>
					<td colspan='4'>
						<div id="paging" style="width:1300px; text-align:center;">
							<ol style="list-style:none;">
								<li style="cursor:pointer;" onclick="javascript:location.href='${path}/admin/contentDetailList.go?pageNum=1'">처음으로</li>
								<%
								for(int i = pageStartNum; i <= pageEndNum; i++){%>
									<li style="cursor:pointer;" onclick="javascript:location.href='${path}/admin/contentDetailList.go?pageNum=<%=pageNum%>'"><%=i%></li>
								<%}%>
								<li style="cursor:pointer;" onclick="javascript:location.href='${path}/admin/contentDetailList.go?pageNum=<%=totalPageNum%>'">마지막으로</li>
							</ol>
						</div>
					</td>
				</tr>	
			</table>
		</div>
	</div>
</div>
</body>
</html>