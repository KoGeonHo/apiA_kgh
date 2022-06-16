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
		$("form[name=joinFrm]").submit(function(){
			let mName = $(this).find("input[name=mName]");
			let email = $(this).find("input[name=email]");
			let pwd = $(this).find("input[name=pwd]");
			let pwd2 = $("input[name=pwd2]");
			let emailChk = $("input[name=emailChk]");
			let pwdChk = $("input[name=pwdChk]");
			
			if(mName.val() == ""){
				alert("이름을 입력하세요");
				mName.focus();
				return false;
			}else if(email.val() == ""){
				alert("이메일을 입력하세요");
				email.focus();
				return false;
			}else if(pwd.val() == ""){
				alert("비밀번호를 입력하세요");
				pwd.focus();
				return false;
			}else if(pwd2.val() == ""){
				alert("비밀번호를 입력하세요");
				pwd2.focus();
				return false;
			}else if(emailChk.val() == 0){
				alert("이메일을 확인해주세요");
				return false;
			}		
		});
		
		$(".pass").keyup(function(){
			let pwd = $("input[name=pwd]");
			let pwd2 = $("input[name=pwd2]");
			let pwdChk = $("input[name=pwdChk]");
			if(pwd.val().trim() != "" && pwd2.val().trim() != ""){
				if(pwd.val() == pwd2.val()){
					//console.log("비밀번호 일치");
					pwdChk.val(1);
					$("#correct").css("display","block");
					$("#incorrect").css("display","none");
				}else{
					//console.log("비밀번호 불일치");
					pwdChk.val(0);
					$("#correct").css("display","none");
					$("#incorrect").css("display","block");
				}
			}
		});
	});
	
	function emailCheck(){
		if($("input[name=email]").val() != ""){
			let email = $("input[name=email]").val();
			//console.log(email);
			$.ajax({
				url : "join/ajax/emailChk.jsp",
				data : "Email="+email,
				success : function(data){					
					let json = JSON.parse(data.trim());
					let result = json[0].emailChk;
					if(result == 0){
						if(confirm("사용 가능한 이메일입니다. 사용하시겠습니까?\n(확인을 누르시면 변경이 불가능 합니다.)")){
							$("input[name=email]").prop("readonly",true);
							$("input[name=emailChk]").val(1);
							$("#EmailCheckBtn").prop("disabled",true);
						}
					}else{
						alert("이미 존재하는 이메일입니다.");
					}
				}
			});
		}else{
			alert("이메일을 입력해주세요");
			$("input[name=email]").focus();
		}
	}
</script>
</head>
<body>
<div class="wrap">
	<%@ include file="../../common/header.jsp" %>
	<div id="contents">
		<div style="margin:auto;">
			<h2 style="padding:5px;">회원가입</h2>
			<div id="Box">
				<form method="POST" name="joinFrm" action="${ path }/user/join.ok">
					<input type="hidden" name="emailChk" value="0">
					<input type="hidden" name="pwdChk" value="0">
					<table>
						<tr>
							<td>
								<input type="text" name="mName" placeholder="이름">
							</td>
						</tr>
						<tr>
							<td>
								<input type="email" name="email" placeholder="이메일">
								<button type="button" id="EmailCheckBtn" onclick="emailCheck()">이메일 확인</button>
							</td>
						</tr>
						<tr>
							<td>
								<input class="pass" type="password" name="pwd" placeholder="비밀번호">
							</td>
						</tr>
						<tr>
							<td>
								<input class="pass" type="password" name="pwd2" placeholder="비밀번호확인">
								<span id='correct' style="display:none; color:blue;">비밀번호가 일치합니다.</span>
								<span id='incorrect' style="display:none; color:red;">비밀번호가 일치하지 않습니다.</span>
							</td>
						</tr>
						<tr>
							<td style="text-align:right;">
								<button type="submit">가입하기</button>
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