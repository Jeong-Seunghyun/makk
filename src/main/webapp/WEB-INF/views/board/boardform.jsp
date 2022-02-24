<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../index/whiteheader.jsp" %>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script type="text/javascript" src="/resources/js/member.js"></script>
<sec:authentication property="principal" var="user"/>
<link rel="stylesheet" href="/resources/css/board.css">
	<div class="boardform-con">
		<div class="boardform-header">
			<h2>문의하기</h2>
		</div><br><br>
		<form class="boardform-form" name="frm" id="frm" method="post" enctype="multipart/form-data">
			<sec:csrfInput/>
			<input type="hidden" name="writerId" value="${user.username}">
			<input type="text" id="title" name="title" placeholder="제목을 입력해주세요."><br><br>
			<textarea rows="15" id="content" name="content" cols="76" placeholder="불만사항이나 칭찬사항을 상세히 작성해주세요."></textarea><br><br>
			<input type="file" id="fileName" name="fileName" multiple="multiple">
			<div class="uploadResult">
				<ul>
				</ul>
			</div>
			<div class="boardform-btn">
				<sec:authorize access="hasRole('ROLE_ADMIN')">
					<input type="button" id="btnNotice" value="공지작성" style="background-color: #ff5a5a; color:white;">
				</sec:authorize>
				<button type="button" onclick="back();" style="height:40px; width:100px; border-radius: 3px">목록으로</button>
				<input type="button" id="btnSubmit" value="글쓰기" style="background-color: #ff5a5a; color:white;">
			</div>
		</form>
	</div>
<script type="text/javascript">
$(document).ready(function(){
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";
	
    //Ajax spring security header..
    $(document).ajaxSend(function(e, xhr, options){
    	xhr.setRequestHeader(csrfHeaderName,csrfTokenValue);
    });
	
	//이미지파일만 업로드
	var regex = new RegExp("(.*?)\.(jpg|jpeg|png|gif|bmp|pdf)$");
	var maxSize = 5242880; //5MB
	function checkExtension(fileName, fileSize) {
		if(fileSize >= maxSize) {
			alert("파일 사이즈 초과");
			return false;
		}
		if(!regex.test(fileName)) {
			alert("이미지 파일만 업로드 가능합니다.");
			return false;
		}
		return true;
	}
	
	//input 태그 변화감지..
	$("input[type='file']").on("change", function(){
		var formData = new FormData();
		var inputFile = $("input[name='fileName']");
		var fileList = inputFile[0].files;
		console.log(fileList);
		
		if (fileList.length > 5) {
			alert("이미지는 5개까지만 등록 가능합니다.");
			return;
		}
		
		for (var i = 0; i < fileList.length; i++) {
			if(!checkExtension(fileList[i].name, fileList[i].size) ){
				return false;
			}
			formData.append("multiFile", fileList[i]);
		}
		$.ajax({
			url: "/file/uploadFile",
			processData: false, 
			contentType: false,
			data: formData,
			type: "POST",
			dataType:"json",
			success: function(result){
				console.log(result); 
				showUploadResult(result); //업로드 결과 처리 함수
			}
		}); //Ajax
	});
	
	function showUploadResult(uploadResultArr) {
	    
	    if(!uploadResultArr || uploadResultArr.length == 0) { 
	    	return;
	    }
		    
	    var uploadUL = $(".uploadResult ul");
	    var str ="";
		    
	    $(uploadResultArr).each(function(i, obj) {
			var fileCallPath = encodeURIComponent(obj.uploadPath+obj.uuid + "_" + obj.fileName);
			str += "<li data-path='" + obj.uploadPath + "'";
			str +=" data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "'><div>";
			str += "<span> " + obj.fileName +"&nbsp;" +"</span>";
			str += "<button type='button' style='margin-bottom:0;' data-file=\'" + fileCallPath + "\'> 삭제</button>";
			str += "</div>";
			str +"</li>";
		});
		    
		uploadUL.append(str);
	}
	
	
	$(".uploadResult").on("click", "button", function(e) {
	    
		console.log("delete file");
		      
		var targetFile = $(this).data("file");
		var targetLi = $(this).closest("li");
		$.ajax({
			url: "/file/deleteFile",
			data: {"fileName": targetFile},
			dataType:"text",
			type: "POST",
			success: function(result){
				alert(result);
				targetLi.remove();
			}
		});
	});
	

	// submit 버튼 클릭이벤트 감지..
	$("input[type=button]").on("click", function(e){
		var button = $(this).val();
		e.preventDefault();
		
		var title = $("#title").val();
		var content = $("#content").val();
		var formObj = $("#frm");
		
		if (title != "" && content != "") {
			var str = "";
			    
			$(".uploadResult ul li").each(function(i, obj){
				var jobj = $(obj);
				console.dir(jobj);
				console.log("-------------------------");
				console.log(jobj.data("filename"));
			      
				str += "<input type='hidden' name='fileList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
				str += "<input type='hidden' name='fileList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
				str += "<input type='hidden' name='fileList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
			});
			
			if (button == "글쓰기") {
				formObj.attr("action","/board/register")
				formObj.append(str).submit();				
			} else {
				formObj.attr("action","/board/registerNotice")
				formObj.append(str).submit();				
				
			}
			
		} else {
			alert("제목과 내용은 필수 입력입니다.");
		}
	}); //post
	
}); //jQuery
</script>
</body>
</html>