<%@page import="playnet.Vo.MemberVo"%>
<%@page import="java.util.*"%>
<%@page import="playnet.admin.AdminMethods"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%

int midx = 0; 

if(request.getParameter("midx") != null){
	midx = Integer.parseInt(request.getParameter("midx"));
}else{
	//out.print("<script>alert('잘못된 접근입니다.'); history.back();</script>");
}


AdminMethods AM = new AdminMethods();
MemberVo MV = new MemberVo();
MV = AM.selMember(midx);
%>
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
<script>
	$(function(){
		$("select[name=isAdmin]").change(function(){
			let isAdmin = $(this).val();
			let midx = <%=midx%>;
			//console.log(isAdmin);
			//console.log(midx);
			$.ajax({
				url : "memMng/ajax/toggleUserAdmin.jsp",
				data : "midx="+midx+"&isAdmin="+isAdmin,
				success : function(data){
					//console.log(data.trim());
				}
			});
		});
	})
</script>
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

<%@ include file="../../common/adminNav.jsp" %>

<div class="wrap">
	<%@ include file="../../common/header.jsp" %>	
	<div id="adminContents" style="padding-left:180px; color:white;">
		<div style="padding-top:20px; display:block; vertical-align:top; width:1150px;">
			<h2>회원 조회</h2>
			<div id="details">
				<table>
					<tr>
						<th style="width:90px;">이름</th>
						<td style="width:900px;">
							<%=MV.getmName()%>
						</td>
					</tr>
					<tr>
						<th>이메일</th>
						<td>
							<%=MV.getmEmail()%>
						</td>
					</tr>
					<tr>
						<th>가입일</th>
						<td>
							<%=MV.getjDate()%>
						</td>
					</tr>
					<tr>
						<th>회원 구분</th>
						<td>
							<select name="isAdmin" onchange="">
								<option value="N" <%if(MV.getIsAdmin().equals("N")){ out.print("selected"); }%>>회원</option>
								<option value="Y" <%if(MV.getIsAdmin().equals("Y")){ out.print("selected"); }%>>관리자</option>
							</select>
						</td>
					</tr>
					<tr>
						<td colspan="2" style="text-align:right;">
							<button type="button" onclick="javascript:location.href='${path}/admin/memberList.go';">목록</button>
						</td>
					</tr>
				</table>
			</div>			
		</div>
	</div>
</div>
</body>
</html>