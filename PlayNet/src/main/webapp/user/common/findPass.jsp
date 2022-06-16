<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>PlayNet</title>
<link rel="stylesheet" type="text/css" href="${ path }/css/main.css">
<script src="${ path }/js/jquery-3.6.0.js"></script>
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
		location.href="${ path }/user/index.go";
	</script>
<%}%>
<div class="wrap">
	<%@ include file="../../common/header.jsp" %>
	<div id="contents">
		<div style="margin:auto; ">
			<h2 style="padding:5px;">비밀번호 찾기</h2>
			<div id="Box">
				<form name="findFrm" method="POST" >
					<table>
						<tr>
							<td colspan='2' style='font-size:0.8em;'>
								가입시 입력한 정보를 입력해주세요.
							</td>
						</tr>
						<tr>
							<td>
								<input type="text" name="mName" placeholder="이름">
							</td>
							<td rowspan="2">
								<button type="button" onclick='alert("준비중입니다.")' style="height:50px;">찾기</button>
							</td>
						</tr>
						<tr>
							<td>
								<input type="email" name="email" placeholder="비밀번호">
							</td>
						</tr>
						<tr>
							<td colspan='2' style="text-align:right;">
								<span onclick="location.href='${ path }/user/Login.go'">돌아가기</span>
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