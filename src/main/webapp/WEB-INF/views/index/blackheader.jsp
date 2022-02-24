<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<sec:authentication property="principal" var="user"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="../../resources/css/index.css">
<script type="text/javascript" src="/resources/js/main.js"></script>
<script type="text/javascript">
function confirms(){
	alert("로그인이 필요한 서비스입니다.");
	location.href="/loginForm";
}
</script>
</head>
<body>
	<div class="nav">
	  <input type="checkbox" id="nav-check">
	  <div class="nav-header">
	    <div class="nav-title">
	      <a href="/"><img alt="logo" src="../../resources/img/blacklogo.PNG" style="width:180px;"></a>
	    </div>
	  </div>
	  <div class="loginbtn">
		<sec:authorize access="isAnonymous()">
			  	<a href="/loginForm">로그인</a>
			  	<a href="/term">회원가입</a>
		</sec:authorize>
		<sec:authorize access="isAuthenticated()">
	  	<span style="color:white; padding-top:5px;">${user.username}님&nbsp;&nbsp;</span>
	  			<a href="javascript:logoutConfirm(logoutAction);">로그아웃</a>
			  	<a href="/modifyMember">정보수정</a>
	  	</sec:authorize>
		<form action="/logout" name="logoutAction" method="post">
			<sec:csrfInput/>
		</form>
	  </div>
	  <div class="nav-btn">
	    <label for="nav-check">
	      <span></span>
	      <span></span>
	      <span></span>
	    </label>
	  </div>
	  
	  <div class="nav-links">
	    <a href="/product">메뉴소개</a>
	    <a href="/store">매장안내</a>
	    <sec:authorize access="isAnonymous()">
	    	<a href="javascript:confirms()">장바구니</a>
	    </sec:authorize>
	    <sec:authorize access="isAuthenticated()">
	    	<a href="/product/goCart">장바구니</a>
	    </sec:authorize>
	    <a href="/board">고객센터</a>
	  </div>
	</div>