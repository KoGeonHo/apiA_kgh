

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
				$(this).parent().find(".slide").css("left",(-(slideWidth - $(window).width())-150)+"px");
			}else{			
				$(this).parent().find(".slide").css("left",(parseInt(left)-(210*3))+"px");
			}
		});	
	});


	//네비 하위 메뉴 열기, 닫기
	$(function(){
		/*$(".upperMenu").mouseover(function(){
			let menu = $(this).next('.secondMenu');
			menu.css("height",(menu.find("ul").find("li").length*31)+"px");
		});
		
		$(".upperMenu").mouseout(function(){
			let menu = $(this).next('.secondMenu');
			menu.css("height","0px");
		});
		
		$(".secondMenu").mouseover(function(){			
			$(this).css("height",($(this).find("ul").find("li").length*31)+"px");			
		});
		
		$(".secondMenu").mouseout(function(){
			$(this).css("height","0px");
		});*/
	});
	
	
	
	function openMenu(obj){
		$(obj).css("height",($(obj).find("li").length)*31+"px");
		//$(obj).next(".secondMenu").css("height",($(obj).find("li").length*31)+"px");
	}
	
	function closeMenu(obj){
		$(obj).css("height","0px");
	}
	
	