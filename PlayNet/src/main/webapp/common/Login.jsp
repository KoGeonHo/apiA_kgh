<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>PlayNet</title>
<link rel="stylesheet" type="text/css" href="../css/main.css">
<script src="../js/jquery-3.6.0.js"></script>
<script>
	$(function(){
		$("#searchBar").css("display","none");
		$("form[name=loginFrm]").submit(function(){
			let email = $(this).find("input[name=email]");
			let pwd = $(this).find("input[name=pwd]");
			if(email.val() == ""){
				alert("이메일주소를 입력해주세요");
				email.focus();
				return false;
			}else if(pwd.val() == ""){
				alert("비밀번호를 입력해주세요");
				pwd.focus();
				return false;
			}
		});
	});
	
</script>

</head>
<body>
<% if(session.getAttribute("midx") != null){%>
	<script>
		location.href="<%=request.getContextPath()%>/user/index.go";
	</script>
<%}%>
<div class="wrap">
	<%@ include file="../common/header.jsp" %>
	<div id="contents">
		<div style="margin:auto; ">
			<h2 style="padding:5px;">로그인</h2>
			<div id="Box">
				<form name="loginFrm" method="POST" action="<%=request.getContextPath()%>/user/login.ok">
					<table>
						<tr>
							<td>
								<input type="email" name="email" placeholder="이메일">
							</td>
							<td rowspan="2">
								<button type="submit" style="height:65px;">로그인</button>
							</td>
						</tr>
						<tr>
							<td>
								<input type="password" name="pwd" placeholder="비밀번호">
							</td>
						</tr>
						<tr>
							<td>
								<span onclick='location.href="<%=request.getContextPath()%>/user/findPass.go"'>비밀번호 찾기</span>
							</td>
							<td>
								<span style="cursor:pointer" onclick="javascript:location.href='<%=request.getContextPath()%>/user/joinS1.go'">회원가입</span>
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>
	</div>
	<%@ include file="../common/footer.jsp" %>
</div>
</body>
</html>