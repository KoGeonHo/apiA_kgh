		$(function(){
			$("#episode").css("display","flex");
			$("#images").css("display","none");
			$("#recommend").css("display","none");
			$("#tab1").css("background","rgb(255,255,255)");
			$("#tab2").css("background","rgba(255,255,255,0.5)");
			$("#tab3").css("background","rgba(255,255,255,0.5)");
			
			
			$("#tab1").click(function(){
				$("#tab1").css("background","rgb(255,255,255)");
				$("#tab2").css("background","rgba(255,255,255,0.5)");
				$("#tab3").css("background","rgba(255,255,255,0.5)");
				$("#episode").css("display","flex");
				$("#images").css("display","none");
				$("#recommend").css("display","none");
			});
		
		
			$("#tab2").click(function(){
				$("#tab1").css("background","rgba(255,255,255,0.5)");
				$("#tab2").css("background","rgb(255,255,255)");
				$("#tab3").css("background","rgba(255,255,255,0.5)");
				$("#episode").css("display","none");
				$("#images").css("display","block");
				$("#recommend").css("display","none");
			});
			
			
			$("#tab3").click(function(){
				$("#tab1").css("background","rgba(255,255,255,0.5)");
				$("#tab2").css("background","rgba(255,255,255,0.5)");
				$("#tab3").css("background","rgb(255,255,255)");
				$("#episode").css("display","none");
				$("#images").css("display","none");
				$("#recommend").css("display","block");
			});
		
		
		
			$(".slide_move_btn_left").click(function(){			
				let left = $("#slider").css("left").split("px")[0];
				if(parseInt(left) < 0){
					$(".slide_move_btn_left").css("display","none");
					setTimeout('$(".slide_move_btn_left").css("display","inline")',500);
					$("#slider").css("left",((210*5)+parseInt(left))+"px");
				}
			});
			
			$(".slide_move_btn_right").click(function(){			
				let left = $("#slider").css("left").split("px")[0];
				if(parseInt(left) > -210 * 3){
					$(".slide_move_btn_right").css("display","none");
					setTimeout('$(".slide_move_btn_right").css("display","inline")',500);
					$("#slider").css("left",(parseInt(left)-(210*5))+"px");
				}
			});
		});