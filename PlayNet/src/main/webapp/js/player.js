

	let timeSet; 										//타임셋을 설정하기위한 변수
	let playInterval;									//인터벌을 설정하기위한 변수
	let playing;										//재생중인지 확인하기위한 변수 1일때 재생 0일때 일시정지


//페이지 로드후 실행	
$(() =>{
	
	
	//오른쪽 클릭 금지
	$(document).bind("contextmenu", function(e) {  return false; });
	
	let video = document.getElementById("video");
	let playProg;
	let progChk = 0;									//재생바를 마우스 다운 중인지 확인하기위한 변수 1일때 마우스 다운 중. 마우스 업 이벤트가 일어나면 0  
	let volChk = 0;										//볼륨바를 마우스 다운 중인지 확인하기위한 변수 1일때 마우스 다운 중. 마우스 업 이벤트가 일어나면 0  
	let nowPlaying;										//현재 재생시간
	let runTime;										//총 재생 시간
	let min = 0;										//재생시간(분)
	let sec = 0;										//재생시간(초)
	
	$(".playBtn").show(); 								//재생버튼 보이기
	$(".pauseBtn").hide();								//일시정지 버튼 숨기기
	
	
	//재생버튼 클릭시 이벤트
	$(".playBtn").click(() =>{
		videoPlay();
	});
	
	
	//일시정지 버튼 클릭시 이벤트
	$(".pauseBtn").click(() =>{
		videoPause();
	});
	
	//전체화면	
	$("#FullScreenBtn").click(fullScreen);
	$("#wrap").dblclick(fullScreen);
	
	function fullScreen(){
		let wrap = document.querySelector('#wrap');
		if (!document.fullscreenElement) {
			if (wrap.requestFullscreen) {return wrap.requestFullscreen()}
			if (wrap.webkitRequestFullscreen) {return wrap.webkitRequestFullscreen()}
			if (wrap.mozRequestFullScreen) {return wrap.mozRequestFullScreen()}
			if (wrap.msRequestFullscreen) {return wrap.msRequestFullscreen()}			  
		} else {
			if (document.exitFullscreen){ return document.exitFullscreen()}
			if (document.webkitCancelFullscreen){ return document.webkitCancelFullscreen()}
			if (document.mozCancelFullScreen){ return document.mozCancelFullScreen()}
			if (document.msExitFullscreen){ return document.msExitFullscreen()}
		}
	}
	
	//마우스를 움직이면 컨트롤바 보이기
	$("#wrap").mousemove(() => {
		$(".hide_after_3sec").fadeIn();
		$("#wrap").css("cursor","default");
		clearTimeout(timeSet);
		timeSet = setTimeout(function(){
			if(	$(".hide_after_3sec").css("display") != "none"){
				$(".hide_after_3sec").fadeOut();
				$("#wrap").css("cursor","none");
			}
		}, 3000);
	});

	//재생바	
	video.addEventListener('timeupdate', () =>{
		
		/* 영상 재생시간 출력 */
		if(Math.floor(video.currentTime / 60) < 10){
			min = "0"+ Math.floor(video.currentTime / 60);
		}else{
			min = Math.floor(video.currentTime / 60);
		}
		
		if(Math.floor(video.currentTime % 60) < 10){
			sec = "0"+ Math.floor(video.currentTime % 60);
		}else{
			sec = Math.floor(video.currentTime % 60);
		}
		nowPlaying = min + ":" + sec;
		runTime = Math.floor(video.duration / 60) + ":" + Math.floor(video.duration % 60);
		
		$("#nowPlaying").html(nowPlaying);
		
		
		
		if(playing == 1){
			playProg = (video.currentTime / video.duration); //currentTime : 현재 재생 시간 , duration : 총 재생시간
			$("#progress_bar").val(playProg.toFixed(3));
			
			if(playProg == 1){
				
				$(".hide_after_3sec").fadeIn();
				$(".controller").addClass("hide_after_3sec");
				$(".pauseBtn").hide();
				$(".playBtn").show();
				clearInterval(playInterval);
			}
		}
	});
	

	//재생바를 클릭시 재생위치 변경
	$("#progress_bar").click(() => {
		video.currentTime = $("#progress_bar").val() * video.duration;
	});
	
	//재생바 마우스 다운시 재생바 자동으로 이동되지 않도록 playing을 0으로 바꿈
	$("#progress_bar").mousedown(() => {
		progChk = 1;
		playing = 0;
	});
	
	//마우스 이동중 재생바를 클릭중일때 클릭 이벤트와 동일한 작업 수행
	$(window).mousemove(() => {
		if(progChk == 1){
			video.currentTime = $("#progress_bar").val() * video.duration;
		}
	});
	

	//볼륨바 이미지에 마우스 엔터시 나타남
	$("#volImg").mouseenter(() => {
		$("input[name=volume]").animate({width:'80px'});
	});
	//마우스가 volDiv를 빠저나가면 사라짐
	$("#volDiv").mouseleave(() => {
		$("input[name=volume]").animate({width:'0px'});
	});
	
	//볼륨바를 클릭시 볼륨 변화
	$("input[name=volume]").click(() => {
		video["volume"] = $("input[name=volume]").val();
		//$("#volTxt").html(Math.floor(video["volume"]*100));
	});
	
	$("input[name=volume]").mousedown(() => {
		volChk = 1;
	});
	
	//재생바 클릭중 마우스 이동에 따라 볼륨 변화
	$(window).mousemove(() => {
		if(volChk == 1){
			video["volume"] = $("input[name=volume]").val();
			//$("#volTxt").html(Math.floor(video["volume"]*100));
		}
	});
	
	$(window).mouseup(() => {
		volChk = 0;
		if(progChk == 1){
			playing = 1;
		}
		progChk = 0;
	});
	
	//볼륨 이미지 클릭시 음소거 토글
	$("#volImg").click(() => {
		toggleMute();
	});	
	
	//키보드 컨트롤러 
	$(document).keydown((e) => {
		let videoCurrentTime = document.getElementById("video");
		//console.log(e.keyCode);
		if(e.keyCode == 13){ //엔터 - 전체화면
			fullScreen();
		}else if(e.keyCode == 39){ //오른쪽 방향키 - 영상 5초 뒤로
			videoCurrentTime.currentTime = videoCurrentTime.currentTime + 5;
			$("#progress_bar").val(videoCurrentTime.currentTime/videoCurrentTime.duration.toFixed(3));
			$(".hide_after_3sec").fadeIn();
			$("#wrap").css("cursor","default");
			clearTimeout(timeSet);
			timeSet = setTimeout(() => {
				if(	$(".hide_after_3sec").css("display") != "none"){
					$(".hide_after_3sec").fadeOut();
					$("#wrap").css("cursor","none");
				}
			}, 3000);
		}else if(e.keyCode == 37){ //왼쪽 방향키 - 영상 5초 전으로
			videoCurrentTime.currentTime = videoCurrentTime.currentTime - 5;
			$("#progress_bar").val(videoCurrentTime.currentTime/videoCurrentTime.duration.toFixed(3));
			$(".hide_after_3sec").fadeIn();
			$("#wrap").css("cursor","default");
			clearTimeout(timeSet);
			timeSet = setTimeout(() => {
				if(	$(".hide_after_3sec").css("display") != "none"){
					$(".hide_after_3sec").fadeOut();
					$("#wrap").css("cursor","none");
				}
			}, 3000);
		}else if(e.keyCode == 38){ //위쪽 방향키 - 볼륨 업
			if((videoCurrentTime["volume"] + 0.05) > 1){
				videoCurrentTime["volume"] = 1;
			}else{
				videoCurrentTime["volume"] += 0.05;
			}
			$("input[name=volume]").val(videoCurrentTime["volume"]);
			
			//console.log(videoCurrentTime["volume"]);
		}else if(e.keyCode == 40){ //아래 방향키 - 볼륨 다운
			if((videoCurrentTime["volume"] - 0.05) < 0){
				videoCurrentTime["volume"] = 0;				
			}else{
				videoCurrentTime["volume"] -= 0.05;
			}
			$("input[name=volume]").val(videoCurrentTime["volume"]);
			//console.log(videoCurrentTime["volume"]);
		}else if(e.keyCode == 77){ //M키 버튼 - 음소거 토글
			toggleMute();
		}else if(e.keyCode == 32){ //스페이스바 - 재생, 일시정지 토글
			if(playing == 1){
				videoPause();
				clearTimeout(timeSet);
				timeSet = setTimeout(() => {
					if(	$(".hide_after_3sec").css("display") != "none"){
						$(".hide_after_3sec").fadeOut();
						$("#wrap").css("cursor","none");
					}
				}, 3000);
			}else{
				videoPlay();
			}
		}
	});
});

//비디오 재생
function videoPlay(){
	$("#video").get(0).play();
	
	/* 영상 런타임 출력 */
	if(Math.floor(video.duration / 60) < 10){
		min = "0"+ Math.floor(video.duration / 60);
	}else{
		min = Math.floor(video.duration / 60);
	}
	
	if(Math.floor(video.duration % 60) < 10){
		sec = "0"+ Math.floor(video.duration % 60);
	}else{
		sec = Math.floor(video.duration % 60);
	}
	runTime = min + ":" + sec;
	
	$("#runTime").html(runTime);
	
	playInterval = setInterval(() => {
		ViewLog(Math.floor(video.currentTime / 60),Math.floor(video.currentTime % 60));				
	}, 1000 * 10);									//10초마다 시청 시간 저장, 시청 기록이 있다면 update
	
	playing = 1;
	$(".controller").addClass("hide_after_3sec");
	clearTimeout(timeSet);
	timeSet = setTimeout(() => {
		if(	$(".hide_after_3sec").css("display") != "none"){
			$(".hide_after_3sec").fadeOut();
			$("#wrap").css("cursor","none");
		}
	}, 3000);
	
	$(".playBtn").hide();
	$(".pauseBtn").show();
}


//비디오 일시정지
function videoPause(){
	$("#video").get(0).pause();
	clearInterval(playInterval);
	playing = 0;
	$(".hide_after_3sec").fadeIn();
	$("#wrap").css("cursor","default");
	$(".controller").removeClass("hide_after_3sec");
	$(".pauseBtn").hide();
	$(".playBtn").show();
}

//음소거 토글
function toggleMute(){
	if($("#video").prop("muted") == false){
		$("#video").prop("muted",true);
		$("#volImg").find("img").attr("src","../images/player/mute.png");
	}else{
		$("#video").prop("muted",false);
		$("#volImg").find("img").attr("src","../images/player/vol.png");
	}
}

//드래그 금지
$(document).bind('selectstart',() => {
	return false;
}); 

$(document).bind('dragstart',() => {
	return false;
});
