<%@page import="playnet.Vo.ContentsVo"%>
<%@page import="playnet.Vo.ContentDetailVo"%>
<%@page import="java.util.ArrayList"%>
<%@page import="playnet.user.UserMethods"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>PlayNet</title>
<link rel="stylesheet" type="text/css" href="${ path }/css/main.css">
<link rel="stylesheet" type="text/css" href="${ path }/css/viewDetails.css">
<link rel="stylesheet" type="text/css" href="${ path }/css/nav.css">
<script src="${ path }/js/jquery-3.6.0.js"></script>
<script src="${ path }/js/main.js"></script>
<script src="${ path }/js/viewDetails.js"></script>
<%
int cdidx = 0;
if(request.getParameter("CdIdx") != null){
	cdidx = Integer.parseInt(request.getParameter("CdIdx"));
}

UserMethods UM = new UserMethods();
ContentDetailVo CDV = UM.selConDetail(cdidx);

int cidx = 0;

cidx = UM.getLastEpisode(cdidx,(int)session.getAttribute("midx"));

%>
<script>
	let liked = <%=UM.chkLike(cdidx,(int)session.getAttribute("midx"))%>;
	let fav = <%=UM.chkFav(cdidx,(int)session.getAttribute("midx"))%>;
	console.log(<%=cdidx%>);
	console.log(fav);
	$(function(){
		
		if(liked == 0){
    		$("#LikeImg").attr('src', '${ path }/images/common/Like.png');
    	}else if(liked == 1){
    		$("#LikeImg").attr('src', '${ path }/images/common/Liked.png');
    	}
		
		if(fav == 0){
    		$("#FavImg").attr('src', '${ path }/images/common/Favorite.png');
    	}else if(fav == 1){
    		$("#FavImg").attr('src', '${ path }/images/common/FavoriteAdded.png');
    	}
		
		if(<%=CDV.getIsSeries().equals("N")%>) {
			$("#tab1").css("background","rgba(255,255,255,0.5)");
			$("#tab2").css("background","rgba(255,255,255,0.5)");
			$("#tab3").css("background","rgb(255,255,255)");
			$("#episode").css("display","none");
			$("#images").css("display","none");
			$("#recommend").css("display","block");
		}
		$("input[name=cateidx]").val(<%=CDV.getCate1()%>);
		
		
		
		$(".seasonTab").mouseover(function(){
			$(this).css("background","#aaa");
		});
		
		$(".seasonTab").mouseout(function(){
			$(this).css("background","#444");
		});
		
		$(".seasonTab").eq(0).off("mouseover");
		$(".seasonTab").eq(0).off("mouseout");
		
		$("#LikeImg").on("click",function(){
			toggleLike();
		});
		
		$("#FavImg").on("click",function(){
			toggleFav();
		});
	});
	
	function toggleLike(){
		$("#LikeImg").off("click");
		$("#LikeImg").fadeOut('fast', function () {
	    	if(liked == 0){
	    		liked = 1;
	    		$("#LikeImg").attr('src', '${ path }/images/common/Liked.png');
	    	}else if(liked == 1){
	    		liked = 0;
	    		$("#LikeImg").attr('src', '${ path }/images/common/Like.png');
	    	}

	    	//console.log('liked='+liked+'&cdidx=<%=cdidx%>&midx=<%=session.getAttribute("midx")%>');
			
	 
	    	$.ajax({
	    		url : "content/ajax/addLike.jsp",
	    		data : "liked="+liked+"&cdidx=<%=cdidx%>&midx=<%=session.getAttribute("midx")%>",
	    		success : function(data){
	    			let result = data.trim();
	    			//console.log(result);
	    		}
	    	});
			 	
	    	
	    	$("#LikeImg").fadeIn('fast');
	    	$("#LikeImg").on("click",function(){
				toggleLike();
			});
	    });
	}
	
	
	
	function toggleFav(){
		$("#FavImg").off("click");
		$("#FavImg").fadeOut('fast', function () {
	    	if(fav == 0){
	    		fav = 1;
	    		$("#FavImg").attr('src', '${ path }/images/common/FavoriteAdded.png');
	    	}else if(fav == 1){
	    		fav = 0;
	    		$("#FavImg").attr('src', '${ path }/images/common/Favorite.png');
	    	}
	    	
	    	$.ajax({
	    		url : "content/ajax/addFav.jsp",
	    		data : "fav="+fav+"&cdidx=<%=cdidx%>&midx=<%=session.getAttribute("midx")%>",
	    		success : function(data){
	    			let result = data.trim();
	    			console.log(result);
	    		}
	    	});
	    	
	    	$("#FavImg").fadeIn('fast');
	    	$("#FavImg").on("click",function(){
	    		toggleFav();
	    	});
	    });
	}
	
	
	function toggleSTab(cdidx,season,seasons){
		
		for(let i = 1; i <= seasons; i++){
			
			if(i == season){
				$("#season"+i).css("background","#aaa");
				$("#season"+i).off("mouseover");
				$("#season"+i).off("mouseout");
			}else{
				$("#season"+i).css("background","#444");
				$("#season"+i).mouseover(function(){
					$(this).css("background","#aaa");
				});
				$("#season"+i).mouseout(function(){
					$(this).css("background","#444");
				});
			}
		}
		
		$.ajax({
			url : "content/ajax/getEpisodes.jsp",
			data : "cdidx="+cdidx+"&season="+season,
			success : function(data){
				let html = "";
				let json = JSON.parse(data.trim());
				for(let i = 0; i < json.length; i++){
					html += '<div class="episodes">';
					html += '<div class="epD1">';
					html += '<img src="../images/thumbNails/'+json[i].thumbNail+'">';
					html += '<button type="button" ';
					html += 'onclick="javascript:location.href=\'<%=request.getContextPath()%>/user/player.go?cidx='+json[i].cidx;
					html += '\'">재생 ▶</button>';
					html += '</div>';
					html += '<div class="epD2" style="margin-left:4px">';
					html += '<h3>'+json[i].title+'</h3>';
					html += '<span>'+json[i].description+'</span>';
					html += '</div>';
					html += '</div>';
				}
				$("#eplist").html(html);
			}
		});
		
		
	}
</script>
</head>
<body>


<%@ include file="../../common/nav.jsp" %>	

<div class="wrap">
	<%@ include file="../../common/header.jsp" %>
	<div id="contents2" style="margin:auto;">
		<!-- 콘텐츠 detail -->
		<div id="conDetail">
			<div id="sec1">
				<div id="sec1_img"style="background:url(${ path }/images/<%=CDV.getPoster1()%>); background-size:cover;">
				</div>
				<div style="margin-top:10px;">
					<%if(cidx != 0){ %>
						<button type="button" onclick="javascript:location.href='${ path }/user/player.go?cidx=<%=cidx%>'">재생 ▶</button>
					<%}else{%>
					 	<button type="button" onclick="javascript:alert('준비 중 입니다.')">재생 ▶</button>
					<%}%>
				</div>
			</div>
			<div id="sec2">
				<div>
					<h2 style="display:inline-block; padding:10px;"><%=CDV.getTitle()%></h2>
					<div style="display:inline-block;"> 
						<div style="display:inline-block;">
							<img id="LikeImg" src="${ path }/images/common/Like.png" style='vertical-align:middle;' width="30px" height="30px">
						</div>
						<div style="display:inline-block;">
							<img id="FavImg" src="${ path }/images/common/Favorite.png" style='vertical-align:middle;' width="25px" height="25px">
						</div>
					</div> 			
				</div>
				<table style="width:800px;">
					<tr>
						<td colspan="2">
							<hr>
						</td>
					</tr>
					<tr>
						<td style="text-align:center; width:100px;">
							출연
						</td>
						<td style="width:auto;">
							 <%=CDV.getCasting()%>
						</td>
					</tr>
					<tr>
						<td style="vertical-align:top; text-align:center;">
							 줄거리
						</td>
						<td>
							 <%=CDV.getDescription()%>
						</td>
					</tr>
					<tr>
						<td style="text-align:center;">
							 
						</td>
						<td>
							<%=CDV.getKeyword()%>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<hr>
						</td>
					</tr>
				</table>
			</div>
		</div>		
		<div id="tabs">
			<div id="tabBtns">
				<%if(CDV.getIsSeries().equals("Y")){ %>
					<button type="button" id="tab1">시즌</button>
				<%}%>
				<button type="button" id="tab3">관련영상</button>
				<button type="button" id="tab2">이미지</button>
			</div>
			<%if(CDV.getIsSeries().equals("Y")){ 
				int seasons = UM.getSeason(cdidx);%>			
				<div id="episode">
					<div id="seasonList" style="">
						<ol>
							<%for(int i = 1; i <= seasons; i++){ %>
								<li id="season<%=i%>" class="seasonTab" <%if(i==1) { out.print("style='background:#aaa;'");}%> onclick="toggleSTab(<%=cdidx%>,<%=i%>,<%=seasons%>)">Season<%=i%></li>
							<%} %>
						</ol>					
					</div>
					<div id="eplist">
						<%ArrayList<ContentsVo> eList = UM.selEpisodes(cdidx,1);
						for(ContentsVo CV : eList){%>
							<div class="episodes">
								<div class="epD1">
									<img src="${ path }/images/thumbNails/<%=CV.getThumbNail()%>">
									<button type="button" onclick="javascript:location.href='<%=request.getContextPath()%>/user/player.go?cidx=<%=CV.getCIdx()%>'">재생 ▶</button>
								</div>
								<div class="epD2">
									<h3><%=CV.getTitle()%></h3>
									<span><%=CV.getDescription()%></span>
								</div>
							</div>
						<%}%>
					</div>
				</div>
				
			<%}%>
				
				
			<!-- 해당 콘텐츠와 관련된 추천 콘텐츠 출력 -->
			<div id="recommend" style="overflow:overlay;">
				<div class="container" style="padding:10px; width:auto;">
					<div id="eplist">
					<%ArrayList<ContentsVo> conList = UM.selConAll(cdidx);
					for(ContentsVo CV : conList){%>
						<div class="episodes">
							<div class="epD1">
								<img src="${ path }/images/thumbNails/<%=CV.getThumbNail()%>">
								<button type="button" onclick="javascript:location.href='${ path }/user/player.go?cidx=<%=CV.getCIdx()%>'">재생 ▶</button>
							</div>
							<div class="epD2">
								<h3><%=CV.getTitle()%></h3>
								<span><%=CV.getDescription()%></span>
							</div>
						</div>
					<%}%>
					</div>
				</div>
			</div>
			
			<!-- 콘텐츠 정보에 입력된 이미지 출력 -->
			<div id="images">
				<div class="container" style="padding:10px;">
					<h2 style="padding:5px; color:black;">영화 이미지(포스터)</h2>
					<div>
						<%if(CDV.getPoster1() != null){%>
							<div class="items" style="background:url(${ path }/images/<%=CDV.getPoster1()%>); background-size:cover;"></div>
						<%}%>
						<%if(CDV.getPoster2() != null){%>
							<div class="items" style="background:url(${ path }/images/<%=CDV.getPoster2()%>); background-size:cover;"></div>
						<%}%>
						<%if(CDV.getPoster3() != null){%>
							<div class="items" style="background:url(${ path }/images/<%=CDV.getPoster3()%>); background-size:cover;"></div>
						<%}%>
						<%if(CDV.getPoster4() != null){%>
							<div class="items" style="background:url(../images/<%=CDV.getPoster4()%>); background-size:cover;"></div>
						<%}%>
						<%if(CDV.getPoster5() != null){%>
							<div class="items" style="background:url(../images/<%=CDV.getPoster5()%>); background-size:cover;"></div>
						<%}%>
					</div>
				</div>
			</div>	
			
			<div>
				<div style="float:right;">
					<button onclick="history.back()">돌아가기</button>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="../../common/footer.jsp" %>
</div>
</body>
</html>