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
<script>
	$(function(){
		let frm = $("#cateFrm");
		let input_cateIdx = frm.find("input[name=cateIdx]");
		let input_name = frm.find("input[name=name]");
		let select_cateParent = frm.find("select[name=cateParent]");
		let select_isUse = frm.find("select[name=isUse]");
				
		
		$("#btn2").css("display","none");
		$("#btn3").css("display","none");
		
		
		$(".categories").click(function(){
			$.ajax({
				url : "conMng/ajax/getCate.jsp",
				data : "cateIdx="+$(this).find("input:hidden").val(),
				success : function(data){
					let json = JSON.parse(data.trim());
					input_cateIdx.val(json[0].cateIdx);
					input_name.val(json[0].cateName);
					select_cateParent.val(json[0].cateParent);
					select_isUse.val(json[0].isUse);
					$("#btn1").css("display","none");
					$("#btn2").css("display","inline");
					$("#btn3").css("display","inline");
				}
			})
		});
		
		
		//카테고리 등록
		$("#btn1").click(function(){
			if(input_name.val() == ""){
				alert("카테고리 이름을 입력해 주세요");
				input_name.focus();
			}else{
				frm.submit();
			}
		});
		
		
		//카테고리 수정
		$("#btn2").click(function(){
			if(input_name.val() == ""){
				alert("카테고리 이름을 입력해 주세요");
				input_name.focus();
			}else{
				frm.attr("action","${path}/admin/cateModify.ok");
				frm.submit();
			}
		});
		
		//수정을 취소함.
		$("#btn3").click(function(){
			input_cateIdx.val("");
			input_name.val("");
			select_cateParent.val(0);
			select_isUse.val('Y');
			$("#btn1").css("display","inline");
			$("#btn2").css("display","none");
			$("#btn3").css("display","none");
		});
		
		
	});
</script>
<style>
	#cateList ol {
		list-style:none;
		padding-inline-start: 0px;
		text-align:left;
		padding-left:20px;
	}
	
	#cateList li {
		cursor:pointer;
	}
	
	#cateList .child {
		font-size:0.8em;
		padding-left:20px;
	}
</style>
</head>
<body>

<%
AdminMethods AM = new AdminMethods();
	ArrayList<CategoryVo> pCateList = new ArrayList<>();
	pCateList = AM.selParentCate();
%>

<%@ include file="../../common/adminNav.jsp" %>

<div class="wrap">
	<%@ include file="../../common/header.jsp" %>	
	<div id="adminContents" style="padding-left:180px; color:white;">
		<h1>카테고리</h1>
		<div id="List" style="text-align:center; width:300px; min-height:300px; background:white; border-radius:20px; display:inline-block; color:black; vertical-align:top;">
			<!-- 부모카테고리 출력 -->
			<%
			if(pCateList.size() == 0) {
			%>
				<div style="vertical-align:middle; padding:10px;">등록된 카테고리가 없습니다.</div>
			<%
			}else{
			%>
				<div id="cateList">
					<ol>
						<%
						for(CategoryVo pCategory : pCateList){
							String isUse = pCategory.getIsUse().toString();
							out.print("<li class='categories' style='margin:10px;'><input type='hidden' value='"+pCategory.getCateIdx()+"'>"+pCategory.getCateName());
							if(isUse.equals("Y")){
								out.print("<button style='float:right; margin-right:20px; background:green; border:0px; border-radius:20px; width:12px; height:12px;'></button>");
							}else{
								out.print("<button style='float:right; margin-right:20px; background:red; border:0px; border-radius:20px; width:12px; height:12px;'></button>");
							}
							out.print("</li>");							
							//자식 카테고리 출력
							ArrayList<CategoryVo> cCateList = new ArrayList<>();
							
							cCateList = AM.selChildCate(pCategory.getCateIdx()); 
							if(cCateList.size() != 0){
								for(CategoryVo cCategory : cCateList){
									String cisUse = cCategory.getIsUse().toString();
									out.print("<li class='child categories' style='margin:10px;'><input type='hidden' value='"+cCategory.getCateIdx()+"'>"+cCategory.getCateName());
									if(cisUse.equals("Y")){
										out.print("<button style='float:right; margin-right:20px; background:green; border:0px; border-radius:20px; width:12px; height:12px;'></button>");
									}else{
										out.print("<button style='float:right; margin-right:20px; background:red; border:0px; border-radius:20px; width:12px; height:12px;'></button>");
									}
									out.print("</li>");	
								}
							}
						}
						%>
					</ol>
				</div>
			<%
			}
			%>
		</div>
		<div id="InsertFrm" style="width:500px; background:white; border-radius:20px; display:inline-block; color:black; vertical-align:top;">
			<form id="cateFrm" method="POST" action="${path}/admin/cateInsert.ok">
			<input type="hidden" name="cateIdx" value="">
			<div style="height:100%;">
				<div>					
					<table style="padding:20px;">
						<tr>
							<td>이름
							</td>
							<td>
								<input type="text" name="name" style="height:20px; width:120px;">
							</td>
						</tr>
						<tr>
							<td>상위 카테고리
							</td>
							<td>
								<select name="cateParent">
									<option value="0">상위 카테고리</option>
									<%
									for(CategoryVo pCategory : pCateList){
									%>
										<option value="<%=pCategory.getCateIdx()%>"><%=pCategory.getCateName()%></option>
									<%}%>
								</select>
							</td>
						</tr>
						<tr>
							<td>사용여부
							</td>
							<td>
								<select name="isUse">
									<option value="Y">사용</option>
									<option value="N">미사용</option>
								</select>
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div style="text-align:right; margin:20px;">
				<button type="button" id="btn1">등록</button>
				<button type="button" id="btn2">수정</button>
				<button type="button" id="btn3">취소</button>
			</div>
			</form>
		</div>
	</div>
</div>
</body>
</html>