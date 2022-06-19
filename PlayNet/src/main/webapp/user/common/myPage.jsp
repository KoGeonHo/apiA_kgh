<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>PlayNet</title>
<link rel="stylesheet" type="text/css" href="${ path }/css/main.css">
<link rel="stylesheet" type="text/css" href="${ path }/css/nav.css">
<script src="${ path }/js/jquery-3.6.0.js"></script>
<script src="${ path }/js/main.js"></script>
<script>
	let isKM;
	isKM = 0;

	$(document).on('click', '#toggleBG', function () {
	    let toggleBG = $(this);
	    let toggleFG = $(this).find('#toggleFG');
	    let left = toggleFG.css('left');
	    if(isKM == 1) {
	        toggleBG.css('background', '#444');
	        toggleActionStart(toggleFG, 'TO_LEFT');
	        isKM = 0;
	    }else if(isKM == 0) {
	        toggleBG.css('background', 'rgb(46,117,182)');
	        toggleActionStart(toggleFG, 'TO_RIGHT');
	        isKM = 1;
	    }
	});
	
	$(function(){
		if(isKM == 1){
			$("#toggleBG").css('background', 'rgb(46,117,182)');
	        toggleActionStart($("#toggleFG"), 'TO_RIGHT');
		}else if(isKM == 0){
			$("#toggleBG").css('background', '#444');
	        toggleActionStart($("#toggleFG"), 'TO_LEFT');
		}
	})
	 
	// 토글 버튼 이동 모션 함수
	function toggleActionStart(toggleBtn, LR) {
	    // 0.01초 단위로 실행
	    let intervalID = setInterval(
	        function() {
	            // 버튼 이동
	            let left = parseInt(toggleBtn.css('left'));
	            left += (LR == 'TO_RIGHT') ? 5 : -5;
	            if(left >= 0 && left <= 25) {
	                left += 'px';
	                toggleBtn.css('left', left);
	            }
	        }, 10);
	    setTimeout(function(){
	        clearInterval(intervalID);
	    }, 201);
	}
	
	
</script>
<style type="text/css">
    #toggleBG{
    	background: #444; 
    	width: 45px; 
    	height: 20px; 
    	border: 1px solid #444; 
    	border-radius: 15px;
    	padding:3px;
    	margin:5px;
    	display:inline-block;
    }
    #toggleFG{
    	background: #FFFFFF; 
    	width: 20px; 
    	height: 20px; 
    	border: none; 
    	border-radius: 15px; 
    	position: relative; 
    	left: 0px;
    }
    
    td {
    	height:40px;
    }
</style>
</head>
<body>

<%@ include file="../../common/nav.jsp" %>	


<div class="wrap">
	<%@ include file="../../common/header.jsp" %>	
	<div id="contents2" style="color:white;">
		<h1 style="margin:0px;">My Page</h1>
		<div>
			<table style="color:white; font-size:1.2em;">
				<tr>
					<td>
						고건호(gjy5247@gmail.com)
					</td>
				</tr>
				<!-- tr>
					<td>
						Kid's Mod
						<div id='toggleBG'>
						    <button id='toggleFG'></button>
						</div>
					</td>
				</tr -->
				<tr>
					<td>
						비밀번호변경
					</td>
				</tr>
				<tr>
					<td>
						좋아요
					</td>
				</tr>
				<tr>
					<td>
						관심 콘텐츠
					</td>
				</tr>
				<tr>
					<td>
						회원탈퇴
					</td>
				</tr>
			</table>
		</div>
	</div>
	<%@ include file="../../common/footer.jsp" %>
</div>
</body>
</html>