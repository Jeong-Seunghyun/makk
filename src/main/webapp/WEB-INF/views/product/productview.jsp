<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../index/whiteheader.jsp" %>
<sec:authentication property="principal" var="user"/>

<style>
	.pro-container {
		margin: 80px auto;
		text-align: center;
	}
	.pro-container img {
		width: 600px;
	}
	span {
		padding : 20px;
	}
	button {
		width: 150px;
		height: 30px;
		margin: 0 10px 50px 10px;
		color: white;
		background-color: #ff5a5a;
		border: none;
		border-radius: 3px;
	}
</style>
<script type="text/javascript">
	function backList(){
		history.go(-1);
	}


</script>
	<div class="pro-container">
		<div class="pro-explane">
			<img alt="상품이미지" src="/resources/img/${productDTO.proImage }">
			<h2>${productDTO.proName }</h2>
			<span>${productDTO.proExplane }</span><br><br>
			<span><fmt:setLocale value="ko_KR"/><fmt:formatNumber type="currency" value="${productDTO.proPrice}" /></span><br><br>
			<div>
				<form method="post" name="frm" id="frm" action="">
					<sec:csrfInput/>
					<sec:authorize access="isAuthenticated()">
						<input type="hidden" name="proCode" value="${productDTO.proCode}">
						<input type="hidden" name="userId" value="${user.username}">
						<button id="order" name="order">주문하기</button>
						<button id="cart" name="cart">장바구니</button>				
					</sec:authorize>
					<sec:authorize access="isAnonymous()">
						<button type="button" onclick="needAuth();">주문하기</button>
						<button type="button" onclick="needAuth();">장바구니</button>	
					</sec:authorize>
					<button type="button" onclick="backList();" style="background-color: lightgray; color: gray;">목록보기</button>
				</form>			
			</div>
		</div>
	</div>
<script type="text/javascript">
	function needAuth(){
		
		location.href="/product/addCart";
	}
	
	$(document).ready(function(){
		$("#cart").on("click",function(){
			$("#frm").attr("action","/product/addCart").submit();
		});
	});
	
</script>
</body>
</html>