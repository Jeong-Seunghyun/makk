<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../index/whiteheader.jsp" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<sec:authentication property="principal" var="user"/>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="/resources/js/board.js"></script>
<link rel="stylesheet" href="/resources/css/board.css">
	<div class="boardview-con">
		<div class="boardview-header">
			<div class="view1">글 번호 ㆍ ${boardDTO.postNo}</div>
			<!-- 공지글인지 확인.. 작성자이름 또는 관리자로 표시 -->
			<c:choose>
				<c:when test="${boardDTO.noticePost eq 'y'.charAt(y)}">
					<div class="view2">작성자 ㆍ 관리자</div>			
				</c:when>
				<c:otherwise>
					<div class="view2">작성자 ㆍ ${boardDTO.writerName}</div>				
				</c:otherwise>		
			</c:choose>
			<div class="view3">작성일시 ㆍ <fmt:formatDate value="${boardDTO.reportDate}" pattern="yy-MM-dd HH:mm"/></div> 
		</div><br><br>
		<form class="boardview-form" method="post" action="" id="frm" name="frm" enctype="multipart/form-data">
			<sec:csrfInput/>
			<input type="hidden" value="${boardDTO.postNo}" name="postNo">
			<input type="hidden" name="page" value="${page}">
			<sec:authorize access="isAuthenticated()">
				<input type="hidden" id="writerId" name="writerId" value="${user.username}">
			</sec:authorize>
			<input type="text" value="${boardDTO.title}" name="title" id="title" disabled="disabled"><br><br>
			<textarea rows="15" cols="76" name="content" id="content" disabled="disabled">${boardDTO.content}</textarea><br><br>
			<input type="file" name="fileName" id="fileName" multiple="multiple" style="display:none; margin-left:100px;">
			<div class="uploadResult">
				<ul>
				</ul>
			</div>
			<div class="bigPictureWrapper">
				<div class="bigPicture">
				</div>
			</div>
			<c:choose>
				<c:when test="${boardDTO.fileList != null}">
				<!-- 첨부파일이 있으면 표시됨 -->
					<c:forEach items="${boardDTO.fileList}" var="fileList" varStatus="status">
						<span>
							<input type="hidden" name="fileList[${status.index}].uploadPath" value="${fileList.uploadPath}">
							<input type="hidden" name="fileList[${status.index}].uuid" value="${fileList.uuid}">
							<input type="hidden" name="fileList[${status.index}].fileName" value="${fileList.fileName}">
							<img src="/resources/attach/${fileList.uploadPath}/${fileList.uuid}_${fileList.fileName}" style="width:150px;">
							<i style="display:none;"><button type="button" style="border-radius:50%; width:25px; height:25px;">X</button></i>	
						</span>
					</c:forEach>
				</c:when>
			</c:choose>
			<div class="boardview-btn">
				<input type="button" id="tolist" name="tolist" value="목록으로" onclick="backToList(${page});">
				<!-- 유저가 인증된 상태일때 표시되는 버튼 -->
				<sec:authorize access="isAuthenticated()">
					<!-- 작성자 본인에게 보이는 버튼 -->
					<c:if test="${user.username eq boardDTO.writerId}">
						<input type="button" id="todelete" name="todelete" value="삭제하기" onclick="deletePost();">
						<input type="button" id="modifyCancle" name="modifyCancle"  value="취소" style="display:none;" onclick="cancle(${boardDTO.postNo},${page});">
						<input type="button" id="modifySubmit" name="modifySubmit" value="수정반영" style="display:none; background-color: #ff5a5a; color:white;">
						<input type="button" id="tomodify" name="tomodify" value="수정하기" style="background-color: #ff5a5a; color:white;" onclick="frm_modify();">				
					</c:if>
					<input type="button" class="modalBtn" onclick="openModal();" style="background-color:#5587ED; color:white;"value="댓글 작성">
				</sec:authorize>
				<!-- 댓글작성 버튼을 누르면 활성화 되는 DIV -->
				<div id="modal" class="searchModal" style="display: none;">
					<div class="search-modal-content">
						<textarea rows="4" cols="76" name="reply" id="reply"></textarea>
						<input type="button" value="취소" onclick="closeModal();">
						<input type="button" value="댓글등록" style="background-color: #ff5a5a; color:white;" onclick="saveReply();">
					</div>
				</div>
			</div>

			 <!-- 답변글이 있으면 보이기 -->
			 <section class="replySection">
				<div class="boardview-footer">
					<c:forEach items="${boardDTO.replyList}" var="replyList">
					<div>
						<div class="boardview-icon">
							<button style="pointer-events:none;">${replyList.replyerId }</button>
							<span style="font-size: 10px;">${replyList.replyDate}</span>
						</div>
						<input type="hidden" id="replyNo" name="replyNo" value="${replyList.replyNo}">
						<textarea rows="2" cols="76" name="replyText" id="replyText" disabled="disabled">${replyList.reply}</textarea>
						<sec:authorize access="isAuthenticated()">
							<input type="hidden" name="replyerId" value="${user.username}">
							<c:if test="${replyList.replyerId eq user.username}">
								<span class="boardview-btn" style="display: block;">
									<input type="button" value="댓글삭제" id="rep_rem_btn">
									<input type="button" value="댓글수정" id="rep_mod_btn">
									<input type="button" value="수정반영하기" id="rep_mod_submit" style="display:none; background-color: #ff5a5a; color:white;">
								</span>
							</c:if>
						</sec:authorize>
					</div>
					</c:forEach>
				</div>
			</section>
			
		</form>

	</div>
<script type="text/javascript">

$(document).ready(function(){
		//첨부파일 클릭 이벤트
	$("img").on("click",function(){
		var path = $(this).attr("src");
		showImage(path);
	});
	
	function showImage(path) {
		
	    $(".bigPictureWrapper").css("display", "flex").show();
	    
	    $(".bigPicture")
	    .html("<img src='" + path + "'>")
	    .animate({width:'100%', height:'100%'}, 1000);
	 }
	 
	 $(".bigPictureWrapper").on("click", function(e) {
	    $(".bigPicture").animate({width:'0%', height:'0%'}, 1000);
	    setTimeout(function() {
	       $('.bigPictureWrapper').hide();
	    }, 1000);
	 });
	 
	 
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
	
	var originFileList = "${boardDTO.fileList}";

	$("input[type='file']").on("change", function(){
		var formData = new FormData();
		var inputFile = $("input[name='fileName']");
		var fileList = inputFile[0].files;
		
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
	
	function showUploadResult(uploadResultArr) { //이미지 첨부 가상 엘리먼트
	    
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
			str += "<button type='button' style='margin-bottom:0; width:40px; height:25px;' data-file=\'" + fileCallPath + "\'> 삭제</button>";
			str += "</div>";
			str +"</li>";
		});
		    
		uploadUL.append(str);
	}
	
	
	$(".uploadResult").on("click", "button", function(e) { //이미지 삭제 비동기 ajax
	    
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
		}); //Ajax
	});
	
	$("i").on("click", function(){
		var x = confirm("이미지를 삭제 하시겠습니까?"); //글 수정 이미지 목록 삭제
		var target = $(this).closest("span");
		
		if (x) {
			target.remove();
		}
	});
	
	$("input[type=button]").on("click", function(e){ //submit
		e.preventDefault();
		var button = $(this).val();
		var title = $("#title").val();
		var content = $("#content").val();
		var reply = $("#reply").val();
		var replyText = $("#replyText").val();
		var x = $(this).closest("div");
		var replyNo = x.children("#replyNo").val();
		var formObj = $("#frm");
		
		if (title != "" && content != "") {
			var str = "";  
			$(".uploadResult ul li").each(function(i, obj){
				var jobj = $(obj);
				console.dir(jobj);
				console.log("-------------------------");
				console.log(jobj.data("filename"));
			      
				str += "<input type='hidden' name='fileList["+i+5+"].fileName' value='"+jobj.data("filename")+"'>";
				str += "<input type='hidden' name='fileList["+i+5+"].uuid' value='"+jobj.data("uuid")+"'>";
				str += "<input type='hidden' name='fileList["+i+5+"].uploadPath' value='"+jobj.data("path")+"'>";
			});
			if (button == "수정반영") { //button의 value값으로 분기 처리
				formObj.attr("action","/board/modifyAction");
				formObj.append(str).submit();			
			} else if (button == "댓글등록") {
				if (reply != "") {
					formObj.attr("action","/board/addReply");
					formObj.submit();					
				} else {
					alert("댓글 내용을 입력해주세요.");
					return;
				}
			} else if (button == "수정반영하기"){
				if (replyText == "") {
					alert("댓글 내용을 입력해주세요.");
					return;
				} else {
					str += "<input type='hidden' name='realReplyNo' value='"+replyNo+"'>";
					formObj.attr("action","/board/modifyReply");
					formObj.append(str).submit();
				}
			}
			
		} else {
			alert("수정할 글의 제목과 내용을 입력해주세요.");
			return;
		}
	}); //post
});
</script>
<script type="text/javascript">
	var msg = "${message}";
	if (msg != "") {
		alert(msg);
	}
	
	$(document).on("click","#rep_mod_btn",function(){ //댓글 수정 클릭시
		var button = $(this).val();
		if (button == "댓글수정") {
			$(this).hide();
			var x = $(this).closest("div");
			$(this).closest("span").children("#rep_mod_submit").show();
			x.children("#replyText").attr("disabled",false);
			x.children("#replyText").css("border","inset");
			var replyNo = x.children("#replyNo").val();
		}
	});
	
	$(document).on("click","#rep_mod_submit",function(){ //댓글 수정 submit
		var replyText = $("#replyText").val();
		var x = $(this).closest("div");
		var replyNo = x.children("#replyNo").val();
		var formObj = $("#frm");
		var str = "";
		if (replyText == "") {
			alert("댓글 내용을 입력해주세요.");
			return;
		} else {
			str += "<input type='hidden' name='realReplyNo' value='"+replyNo+"'>";
			formObj.attr("action","/board/modifyReply");
			formObj.append(str).submit();
		}
	});
	$(document).on("click","#rep_rem_btn",function(){ //댓글 삭제
		var x = $(this).closest("div");
		var replyNo = x.children("#replyNo").val();
		var formObj = $("#frm");
		var conf = confirm("댓글을 삭제하시겠습니까?");
		var str = "";
		if (conf) {
			str += "<input type='hidden' name='realReplyNo' value='"+replyNo+"'>";
			formObj.attr("action","/board/removeReply");
			formObj.append(str).submit();
		}
	});
	
	$(function() {
		
		let count = 1; //쿼리 실행을 위한 count 값 초기 세팅
		var event = $(window).scroll(function(event){ //스크롤 이벤트 감지
			let $window = $(this);
			let scrollTop = $window.scrollTop();
			let windowHeight = $window.height();
			let documentHeight = $(document).height();
			if (scrollTop + windowHeight >= documentHeight ) {
				count++; //이벤트 감지시 count 증가, parameter로 전달
				replyList(count);
			}
			
		});
		
		function replyList(cnt){ //댓글 조회 Ajax 함수
			var count = cnt;
			var postNo = "${boardDTO.postNo}";
			
			$.ajax({
				url: "/board/infiReply",
				data: { "postNo": postNo, 
						"count": count},
				dataType:"json",
				type: "get",
				success: function(result){
					showReplyResult(result); //댓글 생성 함수실행
				},
				error: function(result){
					
				}
			});
		}
		function showReplyResult(replyList){ //Ajax result 값으로 댓글 div생성 함수
			if (!replyList || replyList.length == 0) {
				return;
			}
			var uploadSection = $(".replySection");
			var str = "";
			var auth = "${user}";
			
			if (auth == 'anonymousUser') { //비로그인 회원 접근시 button 활성화 안됨
				$(replyList).each(function(i, obj){
					str += '<div class="boardview-footer">';
					str += '<input type="hidden" name="replyNo" value="'+obj.replyNo+'">';
					str += '<div class="boardview-icon">';
					str += '<button style="pointer-events:none;">'+obj.replyerId+'</button>';
					str += '<span style="font-size: 10px;"> '+obj.replyDate+'</span>'
					str += '</div>';
					str += '<textarea rows="2" cols="76" name="replyText" id="replyText" disabled="disabled">'+obj.reply+'</textarea>';
					str += '<sec:authorize access="isAuthenticated()">';
					str += '<input type="hidden" name="replyerId" value="${user.username}">';
					str += '</sec:authorize>';
					str += '</div>';
				});
				uploadSection.append(str);
				return;
			} else if (auth != 'anonymousUser'){ //인증회원 접근시 
				var username = $("#writerId").val();
				$(replyList).each(function(i, obj){
					str += '<div class="boardview-footer">';
					str += '<input type="hidden" name="replyNo" id="replyNo" value="'+obj.replyNo+'">';
					str += '<div class="boardview-icon">';
					str += '<button style="pointer-events:none;">'+obj.replyerId+'</button>';
					str += '<span style="font-size: 10px;"> '+obj.replyDate+'</span>'
					str += '</div>';
					str += '<textarea rows="2" cols="76" name="replyText" id="replyText" disabled="disabled">'+obj.reply+'</textarea>';
					str += '<sec:authorize access="isAuthenticated()">';
					str += '<input type="hidden" name="replyerId" value="${user.username}">';
					if (obj.replyerId == username) { //댓글 작성자 본인일경우 버튼 활성화..
						str += '<span class="boardview-btn" style="display: block;">';
						str += '<input type="button" value="댓글삭제" id="rep_rem_btn">';
						str += '<input type="button" value="댓글수정" id="rep_mod_btn">';
						str += '<input type="button" value="수정반영하기" id="rep_mod_submit" style="display:none; background-color: #ff5a5a; color:white;">';
						str += '</span>';
					}
					str += '</sec:authorize>';
					str += '</div>';
				});
			}
			
			uploadSection.append(str);
		}
		
		
	});

	
	function cancle(no,page){ //게시글 수정 취소
		location.href="/board/boardview?postNo="+no+"&page="+page+"&count=1";
	}
	function deletePost(){ //게시글 삭제
		var x = confirm("삭제하시겠습니까??");
		if (x==true) {
			document.frm.action="/board/deletePost";
			document.frm.submit();
		}
	}
	
	function backToList(page){ //목록으로
		 location.href="/board?page="+page;
	 }
	
	function frm_modify(){ //게시글 수정버튼 클릭
		document.getElementById("title").disabled= false;
		document.getElementById("content").disabled= false;
		document.getElementById("fileName").style.display= "block";
		document.getElementById("modifySubmit").style.display= "inline";
		document.getElementById("modifyCancle").style.display= "inline";
		document.getElementById("tomodify").style.display= "none";
		document.getElementById("todelete").style.display= "none";
		document.getElementById("tolist").style.display= "none";
		$("i").show();
	}
	
	function openModal(){ //댓글 입력창 열기
		$('#modal').show();
		$('#tolist').hide();
		$('#tomodify').hide();
		$('#todelete').hide();
		$("#reply").css("border", "inset");
	}
	function closeModal() { //댓글 입력창 닫기
		$('.searchModal').hide();
		$('#tolist').show();
		$('#tomodify').show();
		$('#todelete').show();
	};
</script>
</body>
</html>