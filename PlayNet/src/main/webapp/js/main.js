

	//슬라이드 
	$(function() {
		/*$(window).resize(function(){
			
		});*/
		
		$(".slide_move_btn_left").click(function(){			
			let left = $(this).parent().find(".slide").css("left").split("px")[0];
			let thisBtn = $(this);			
			$(this).css("display","none");
			setTimeout(function(){thisBtn.css("display","inline")},500);
			if((210*3)+parseInt(left) > 0 ){
				$(this).parent().find(".slide").css("left","0px");
			}else{
				$(this).parent().find(".slide").css("left",((210*3)+parseInt(left))+"px");
			}
		});
		
		$(".slide_move_btn_right").click(function(){			
			let left = $(this).parent().find(".slide").css("left").split("px")[0];
			let thisBtn = $(this);
			let slideWidth = $(this).parent().find(".slide").css("width").split("px")[0];
			
			$(this).css("display","none");
			
			setTimeout(function(){thisBtn.css("display","inline")},500);				
			
			if(-(slideWidth - $(window).width()) > parseInt(left)-(210*3)){							
				$(this).parent().find(".slide").css("left",(-(slideWidth - $(window).width()))+"px");
			}else{			
				$(this).parent().find(".slide").css("left",(parseInt(left)-(210*3))+"px");
			}
		});	
		
		
		$("#conSearchFrm").submit(function(){
			//키워드 유효성 검사.
			let KW = $("input[name=key_word]");
			if(KW.val() != ""){
				if(KW.val().includes("#")){
					if(KW.val().trim().replaceAll("#","") == ""){
						alert("유효하지 않은 검색입니다.");
						KW.val("");
						KW.focus();	
						return false;
					}
				}
			}else{
				alert("검색어를 입력해주세요");
				KW.focus();
				return false;
			}
		});	
		
		
		$.ajax({
			url: '../ajax/getMenuCate.jsp',
			success : function(data){
				let json = JSON.parse(data.trim());
				let html = "";
				for(let i = 0; i < json.length; i++){
					html = "<li id='menu"+(i+1)+"'>"+json[i].cateName+"</li>";
					$("#menu").prepend(html);
					$("#menu"+(i+1)).click(function(){
						location.href="../user/conSearch.go?cateidx="+json[i].cateIdx;
					})
				}
				
			}
		});
		
		
		
		
	});

	//네비 메뉴열기
	function navOpen(){
		$("#navigator").css("left","0px");
		$("#open").css("display","none");
		$("#close").css("display","flex");
	}
	
	//네비 메뉴닫기
	function navClose(){
		$("#navigator").css("left","-160px");
		$("#open").css("display","flex");
		$("#close").css("display","none");
	}
	
	
	
	