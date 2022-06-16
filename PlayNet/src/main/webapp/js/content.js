$(function() {		
				
		//부모 카테고리 변경시 변경된 부모 카테고리의 자식 카테고리를 불러온다.
		$("select[name=cate1]").change(function(){			
			let pCateIdx = $(this).find("option:selected").val();
			let html = "<option value='0'>-</option>";
			if(pCateIdx != 0){
				$.ajax({
					url : "conMng/ajax/getChildCate.jsp",
					data : "cateIdx="+pCateIdx,
					success : function(data){
						let json = JSON.parse(data.trim());
						if(json.length > 0){
							html ="<option value='0'>카테고리 선택</option>";
							for(let i = 0; i<json.length;i++){
								html += "<option value="+json[i].cateIdx+">"+json[i].cateName+"</option>";
							}
						}
						$("select[name=cate2]").html(html);
					}
				});
			}else{
				$("select[name=cate2]").html(html);
			}
		});
		
		
		//input:file 추가 / 삭제하기 max 5개
		let fileCnt = 2;
		$("#AddFileBtn").click(function(){
			if(fileCnt <= 5){
				$(this).parent().append("<input style='display:block;' type='file' name='image"+fileCnt+ "'>");
				fileCnt++;
			}
		});
		
		$("#RemoveFileBtn").click(function(){
			if(fileCnt > 2){
				$(this).parent().find("input:file").filter(":last").remove();
				fileCnt--;
			}
		});
		
		//contentdetail submit
		$("#frm").submit(function(){
			let title = $(this).find("input[name=title]");
			/*let division = $(this).find("select[name=division]");
			let contentsUrl = $(this).find("input[name=contentsUrl]");
			let runMin = $(this).find("input[name=runMin]");
			let runSec = $(this).find("input[name=runSec]");*/
			if(title.val() == ""){
				alert("제목을 입력해주세요");
				title.focus();
				return false;
			}
			
		});
		
	});