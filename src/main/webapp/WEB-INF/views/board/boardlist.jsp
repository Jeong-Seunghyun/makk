<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../index/whiteheader.jsp" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<sec:authentication property="principal" var="user"/>
<link rel="stylesheet" href="../../resources/css/board.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script type="text/javascript">
	var msg = "${message}";
	if (msg != "") {
		alert(msg);
	}
	
	function goWrite(){
		var user = "${user}";
		if (user == "anonymousUser") {
			alert("로그인이 필요한 서비스입니다.");
			location.href="/loginForm";
			return;
		}
		location.href="/board/boardform";
	}
	
	function stop() {
		alert("작성자 본인만 열람 가능합니다.");
	}
	function readPost(postNo, pageNum){
		location.href="/board/boardview?postNo="+postNo+"&page="+pageNum+"&count=1";
	}
</script>
	<div class="board-container">
		<div class="board-header">
			<h1>고객의 소리</h1>
		</div>
		<hr>
		<table class="board-table">
			<tr>
				<th class="list1">번호</th>
				<th></th>
				<th>제목</th>
				<th>작성자</th>
				<th>작성일</th>
			</tr>
			<!--공지글은 항상 최상단 3개 배치 -->
			<c:forEach items="${noticeList}" var="notice">
				<tr>
					<td width="10%"></td> 
					<td width="10%"><button style=" background-color:#ff5a5a; color:white; border: none; border-radius: 3px;">공지</button></td>
					<td class="boardtitle" width="50%"><a href="/board/boardview?postNo=${notice.postNo}&page=${pageMaker.paging.page}&count=1">${notice.title }</a></td>
					<td width="15%">관리자</td>
					<td width="15%"><fmt:formatDate value="${notice.reportDate }" pattern="yyyy-MM-dd HH:mm" /></td>
				</tr>
			</c:forEach>
			<!--일반글은 목록 반복문 -->
			<c:forEach items="${postList}" var="post">
				<tr>
					<td>${post.postNo}</td>
					<td>
						<c:if test="${!empty post.replyList}">
							<button style="background-color:#1ABC9C; color:white; border: none; border-radius: 3px;">답변</button>
						</c:if>
					</td>
					<!-- 비회원에게는 비밀글로만 처리 -->
					<sec:authorize access="isAnonymous()">
						<td class="boardtitle"><a href="javascript:stop()">비밀글 입니다.</a></td>
					</sec:authorize>
					<!-- 글쓴이 본인이거나 관리자 권한이 있으면 비밀글 열람 가능 및 원래 제목으로확인 -->
					<sec:authorize access="isAuthenticated()">
						<c:choose>
							<c:when test="${user.username eq post.writerId || user.authorities eq '[ROLE_MEMBER, ROLE_ADMIN]'}">
								<td class="boardtitle"><a href="javascript:readPost(${post.postNo},${pageMaker.paging.page})">${post.title}</a></td>
							</c:when>
							<c:when test="${user.username ne post.writerId || user.authorities ne '[ROLE_MEMBER, ROLE_ADMIN]'}">
								<td class="boardtitle"><a href="javascript:stop()">비밀글 입니다.</a></td>
							</c:when>
						</c:choose>
					</sec:authorize>
					<td>${post.writerName }</td>
					<td><fmt:formatDate value="${post.reportDate }" pattern="yy-MM-dd HH:mm" /></td>
				</tr>
			</c:forEach>
			<tr><td></td></tr>
			<tr>
				<td colspan="5"><button onclick="goWrite();" style="width:250px; height:30px; border-radius: 5px; border: none; background-color: #ff5a5a; color:white;">작성하기</button></td>

			</tr>
			<tr>
				<td colspan="5">
					<c:if test="${pageMaker.prev == true }"><a href="/board?page=${pageMaker.beginPage-1}">&lt;&lt;</a></c:if>
					<c:forEach var="x" begin="${pageMaker.beginPage}" end="${pageMaker.endPage}" step="1">
						<c:choose>
							<c:when test="${pageMaker.paging.page == x}">
								<a href="/board?page=${x}" style="color:red; font-size:23px; font-weight: bold;">[${x}]</a>
							</c:when>
							<c:otherwise><a href="/board?page=${x}">[${x}]</a></c:otherwise>
						</c:choose>
					</c:forEach>
					<c:if test="${pageMaker.next == true }"><a href="/board?page=${pageMaker.endPage+1}">&gt;&gt;</a></c:if>
				</td>
			</tr>
		</table>
	</div>

</body>
</html>