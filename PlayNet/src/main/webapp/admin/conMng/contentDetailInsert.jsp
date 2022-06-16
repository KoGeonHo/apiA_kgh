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
<script src="${path}/js/content.js"></script>
<style>	
	
	#details th {
		padding:10px;
		width:80px;
	}
	
	#details td {
		width:300px;
	}
	
	
</style>
</head>
<body>
<%
	AdminMethods AM = new AdminMethods();
	ArrayList<CategoryVo> CatePList = AM.selParentCate();
%>

<%@ include file="../../common/adminNav.jsp" %>

<div class="wrap">
	<%@ include file="../../common/header.jsp" %>	
	<div id="adminContents" style="padding-left:180px; color:white;">
		<div style="padding-top:20px; display:block; vertical-align:top; width:1150px;">
			<h2>콘텐츠 등록</h2>
			<div id="details">
				<form id="frm" method="POST" enctype="multipart/form-data" action="${path}/admin/contentDetailInsert.ok">
					<table>
						<tr>
							<th style="width:90px;">제목</th>
							<td style="width:900px;"><input class="inputBox" type="text" name="title" value=""></td>
						</tr>
						<tr>
							<th>카테고리</th>
							<td>
								<select class="select" name="cate1">
									<option value="0">카테고리 선택</option>
									<%
									for(CategoryVo category : CatePList) {
										out.print("<option value='"+category.getCateIdx()+"'>"+category.getCateName()+"</option>");
									}%>
								</select>
								<select class="select" name="cate2">
									<option value="0">-</option>
								</select>
							</td>
						</tr>
						<tr>
							<th>시리즈</th>
							<td>
								<div style="display:inline;"><input type="radio" class="radio" name="isSeries" value="N" checked><span>비시리즈</span></div>
								<div style="display:inline;"><input type="radio" class="radio" name="isSeries" value="Y"><span>시리즈</span></div>
							</td>
						</tr>
						<tr>
							<th>공개여부</th>
							<td>
								<div style="display:inline;"><input type="radio" class="radio" name="isRelease" value="Y" checked><span>공개</span></div>
								<div style="display:inline;"><input type="radio" class="radio" name="isRelease" value="N"><span>미공개</span></div>
							</td>
						</tr>
						<tr>
							<th>공개일</th>
							<td>
								<input class="inputDate" type="date" name="rSdate"> ~ 
								<input class="inputDate" type="date" name="rEdate">
							</td>
						</tr>
						<tr>
							<th>출연</th>
							<td>
								<input class="inputBox" style="width:300px;" type="text" name="casting">
							</td>
						</tr>
						<tr>
							<th>키워드</th>
							<td><input class="inputBox" style="width:300px" type="text" name="key_word" value=""></td>
						</tr>
						<tr>
							<th>이미지<br>(포스터)
							</th>
							<td>
								<input type="file" name="image1">
								<button type="button" id="AddFileBtn">+</button>
								<button type="button" id="RemoveFileBtn">-</button>
							</td>
						</tr>
						<tr>
							<th>
								소개
							</th>
							<td>
								<textarea name="description" style="padding:10px;" cols="120" rows="20" placeholder="내용을 입력하세요"></textarea>
							</td>
						</tr>
						<tr>
							<td colspan="2" style="text-align:right;">
								<button type="submit" >등록</button>
								<button type="button" onclick="javascript:history.back();">목록</button>
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