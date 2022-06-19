<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>player</title>
<script src="../js/jquery-3.6.0.js"></script>
</head>
<body>
<video id="player" controls onmouseover="capture()">
	<source src="../Videos/Trailer.mp4" type="video/mp4">
</video>
<button onclick="capture()">캡쳐</button>
<body>

	<canvas id="tcanvas" width="300" height="200" style='border: 1px solid #000;'></canvas>



	<script> 

			
			function capture(){
				var canvas = document.getElementById("tcanvas");
				
				var context = canvas.getContext("2d");
				
				let video = document.getElementById("player"); 
					
				context.drawImage(video,0,0,300,200)
			}
						
	</script>

</body>
</html>