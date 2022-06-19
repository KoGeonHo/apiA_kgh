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
		$("#skip").click(function(){
			location.href="${ path }/user/index.go";
		});
	});
</script>
<style>
	.sbsInfo {
		border:2px dashed #fff; 
		padding:20px; 
		border-radius:5px;
		margin:5px;
		cursor:pointer;
	}
	.sbsInfo:hover {
		background:rgb(46,117,182);
		border:2px dashed #000;
	}
</style>

</head>
<body>
<div class="wrap">
	<%@ include file="../../common/header.jsp" %>
	<div id="contents">
		<div style="margin:auto; ">
			<h2 style="padding:5px;">회원가입 2 / 2</h2>
			<div id="Box" style="padding:0px;">
				<table style="border-spacing:30px">
					<tr>
						<td class="sbsInfo">
							1 개월 구독<br>
							* 혜택 1<br>
							* 혜택 2<br>
							* 혜택 3							
						</td>
						<td class="sbsInfo">
							3 개월 구독<br>
							* 혜택 1<br>
							* 혜택 2<br>
							* 혜택 3							
						</td>
						<td class="sbsInfo">
							6 개월 구독<br>
							* 혜택 1<br>
							* 혜택 2<br>
							* 혜택 3							
						</td>
						<td class="sbsInfo">
							12 개월 구독<br>
							* 혜택 1<br>
							* 혜택 2<br>
							* 혜택 3							
						</td>
					</tr>
					<tr>
						<td style="text-align:right; font-size:1.2em;" colspan="4">
							<span id="skip">건너뛰기</span>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
	<%@ include file="../../common/footer.jsp" %>
</div>
</body>
</html>