<%@page import="playnet.Vo.PlayTimeVo"%>
<%@page import="playnet.user.UserMethods"%>
<%@page import="playnet.Vo.ContentsVo"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>player</title>
<%
int cidx = 0;
int midx = 0;
int wmin = 0;												//시청 기록이 있을때의 시청 시간(분)
int wsec = 0;												//시청 기록이 있을때의 시청 시간(초)
int watched = 0;											//시청기록 유무

if(session.getAttribute("midx") == null){
	out.print("<script>alert('로그인이 필요합니다.');location.href='"+request.getContextPath()+"/user/Login.go'</script>");
}else{
	midx = (int)session.getAttribute("midx");
}

if(request.getParameter("cidx") != null){
	cidx = Integer.parseInt(request.getParameter("cidx"));
}else{
	out.print("<script>alert('잘못된 접근입니다.'); history.back();</script>");
}

UserMethods UM = new UserMethods();
ContentsVo CV = UM.selCon(cidx);

if(UM.ViewLogChk(cidx, midx) > 0){
	PlayTimeVo PV = UM.getPlayTime(midx, cidx);
	wmin = PV.getMin();
	wsec = PV.getSec();
	watched = 1;
}

%>
<link rel="stylesheet" type="text/css" href="${ path }/css/player.css">
<script src="${ path }/js/jquery-3.6.0.js"></script>
<script src="${ path }/js/player.js"></script>
<script>
	//비디오가 로드 되었을때 설정
	$(window).on("load",function(){
		video["volume"] = 0.5;
		$("input[name=volume]").val(video["volume"]);
		$("#volTxt").html(Math.floor(video["volume"]*100));
		//시청 기록이 있다면 이어서 볼수있도록 설정.
		if(<%=watched%> == 1){
			video.currentTime = ((<%=wmin%> * 60) + (<%=wsec%>-5));
			$("#progress_bar").val((((<%=wmin%> * 60) + (<%=wsec%>-5))/((<%=CV.getRunMin()%>*60) +<%=CV.getRunSec()%>)).toFixed(3));
		}
	});
	
	//시청 로그 기록.
	function ViewLog(min,sec){
		$.ajax({
			url : "content/ajax/ViewLog.jsp",
			data : "cidx=<%=cidx%>&midx=<%=session.getAttribute("midx")%>&min="+min+"&sec="+sec ,
			success : function(data){
				console.log(data.trim());
			}
		});
	}
</script>
</head>
<body>
	<div id="wrap">
		<div class="controller">	
			<div style="width:100%; height:80px;">
				<div style="text-align:left; color:white; padding:5px; float:left;">
					<h2 style="display:inline-block">
						<span style="cursor:pointer;"onclick="history.back()">◁</span>
						<%=CV.getTitle()%>
					</h2>
				</div>
			</div>	
			<div style="display:flex; flex:1;">
				<div class="playBtn centerBtn"><img src="${ path }/images/player/playButton.png" width="100px" height="100px"></div>
				<div class="pauseBtn centerBtn"><img src="${ path }/images/player/pauseButton.png" width="100px" height="100px"></div>
			</div>
			<div style="width:100%; height:50px; display:flex;">
				<div style="width:50px; height:50px;" >
					<div style="padding:5px;" class="playBtn"><img src="${ path }/images/player/playButton.png" width="40px" height="40px"></div>
					<div style="padding:5px;" class="pauseBtn"><img src="${ path }/images/player/pauseButton.png" width="40px" height="40px"></div>
				</div>
				<div id="volDiv">
					<div style="width:100%; margin:auto;">
						<div id="volImg"><img src="${ path }/images/player/vol.png" width="20px" height="20px"></div>
					 	<input class="vol_bar" style="width:0px; overflow:hidden;" type="range" name="volume" min="0" max="1" step="0.05" value="0.5">
					</div>					
				</div>
				<div class="progress__filled">
					<div style="width:100%;">
					 	<input id="progress_bar" style="width:100%;" type="range" min="0" max="1" step="0.001" value="0">
					</div>					
				</div>
				<div class="runTime">
					<div style="width:100%; color:white;">
						<span id="nowPlaying">00:00</span>/<span id="runTime">00:00</span>
					</div>					
				</div>
				<div id="FullScreenBtn" >
					<img src="${ path }/images/player/fullScreen.png" width="30px" height="30px">
				</div>
			</div>
		</div>
		<div id='VideoArea'>
			<div class="player">
				<video id="video" poster="${ path }/images/thumbNails/<%=CV.getThumbNail()%>">
					<source src="<%=CV.getURL()%>" type="video/mp4">
				</video>	
			</div>
		</div>
	</div>
</body>
</html>