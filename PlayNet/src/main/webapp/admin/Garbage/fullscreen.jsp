<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Document</title>
<script src="../js/jquery-3.6.0.js"></script>
<script>
$(function(){
	let enterFullscreenBtn = document.('.enterFullscreenBtn')
	let exitFullscreenBtn = document.querySelector('.exitFullscreenBtn')
	let toggleFullscreenBtn = document.querySelector('.toggleFullscreenBtn')
	
	const container = document.querySelector('.container')
	
	enterFullscreenBtn.addEventListener('click', e => {
	  fullscreen(container)
	})
	
	exitFullscreenBtn.addEventListener('click', e => {
	  exitFullScreen()
	})
	
	toggleFullscreenBtn.addEventListener('click', e => {
	  toggleFullScreen(container)
	})
	
	const fullscreen = element => {
	  if (element.requestFullscreen) return element.requestFullscreen()
	  if (element.webkitRequestFullscreen) return element.webkitRequestFullscreen()
	  if (element.mozRequestFullScreen) return element.mozRequestFullScreen()
	  if (element.msRequestFullscreen) return element.msRequestFullscreen()
	}
	
	const exitFullScreen = () => {
	  if (document.exitFullscreen) return document.exitFullscreen()
	  if (document.webkitCancelFullscreen) return document.webkitCancelFullscreen()
	  if (document.mozCancelFullScreen) return document.mozCancelFullScreen()
	  if (document.msExitFullscreen) return document.msExitFullscreen()
	}
	
	function toggleFullScreen(element) {
	  if (!document.fullscreenElement) {
	    if (element.requestFullscreen) return element.requestFullscreen()
	    if (element.webkitRequestFullscreen)
	      return element.webkitRequestFullscreen()
	    if (element.mozRequestFullScreen) return element.mozRequestFullScreen()
	    if (element.msRequestFullscreen) return element.msRequestFullscreen()
	  } else {
	    if (document.exitFullscreen) return document.exitFullscreen()
	    if (document.webkitCancelFullscreen)
	      return document.webkitCancelFullscreen()
	    if (document.mozCancelFullScreen) return document.mozCancelFullScreen()
	    if (document.msExitFullscreen) return document.msExitFullscreen()
	  }
	}
});
</script>
<style>
	.container {
	  background-color: #fff;
	  width: 100%;
	  display: flex;
	  justify-content: center;
	  align-items: center;
	}
</style>
</head>
<body>
	 <div class="container">
	  <button class="enterFullscreenBtn">Fullscreen</button>
	  <button class="exitFullscreenBtn">Cancel Fullscreen</button>
	  <button class="toggleFullscreenBtn">Toggle Fullscreen</button>
	</div>

</body>
</html>

