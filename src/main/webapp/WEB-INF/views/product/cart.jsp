<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../index/whiteheader.jsp" %>
<sec:authentication property="principal" var="user"/>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.1.5.js"></script>
<script type="text/javascript" src="../../resources/js/import.js"></script>
<style>
	.cart-container {
		margin: 80px auto;
		text-align: center;
		width: 768px;
	}
	.cart-container table{
		width:768px;
		margin: 0;
		padding: 0;
	}
	.cart-container td{
		padding : 20px 0 20px 0;
	}
	.cart-container button {
		background-color: #ff5a5a;
		color:white;
		border: none;
		height: 30px;
		width: 70px;
		border-radius: 5px;
		
	}
	
	body img{
		width: 18px;
	}
	
	label {
		background-color: #1ABC9C;
		color: white;
		border : none;
		border-radius: 20px;
		font-size: 13px;
		padding: 6px 15px;
		margin : 40px;
	}
	input {
		width: 400px;
		margin: 10px;
		border: 0.2px inset;
		height: 30px;
	}
	
	#orderFrm {
		text-align: left;
		padding-left: 100px;
	}
</style>
	<div class="cart-container">
		<h1>장바구니</h1><br><br>
		<table>
			<thead>
				<tr>
					<th width="40%">메뉴</th>
					<th width="25%">수량</th>
					<th width="20%">금액</th>
					<th width="15%"></th>
					
				</tr>
			</thead>
			<tbody>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="2" style="text-align: right;">합계 :</td>
					<td id="totalPrice"></td>
					<td><button style="background-color: #1ABC9C;" onclick="goOrder();">주문하기</button></td>
				</tr>
			</tfoot>
		</table>
		<hr>
<!-- 		주문하기 button누를때 보일 DIV -->
		<div class="orderDiv" id="orderDiv" style="display:none;">
			<form id="orderFrm" action="" method="post">
				<label>구매자 정보</label><br><br>
				성함　　<input type="text" id="orderName" name="orderName" readonly="readonly"><br>
				연락처　<input type="text" id="orderPhone" name="orderPhone" readonly="readonly"><br>
				이메일　<input type="text" id="orderEmail" name="orderEmail" readonly="readonly"><br><br>
				<label>받는사람 정보</label><br><br>
				성함　　<input type="text" id="receiveName" name="receiveName" maxlength="6"><br>
				연락처　<input type="text" id="receivePhone" name="receivePhone"><br>
				우편번호<input type="text" id="receiveZipcode" name="receiveZipcode" onclick="post_zip();" readonly="readonly"><br>
				주소　　<input type="text" id="receiveAddr" name="receiveAddr" onclick="post_zip();" readonly="readonly"><br>
				상세주소<input type="text" id="receiveAddrDetail" name="receiveAddrDetail"><br>
				요청사항<input type="text" id="receiveRequest" name="receiveRequest">
			</form>
			<hr>
			<button type="submit" id="orderSubmit" style="margin-left: 550px;">결제</button>
			<br><br><br><br>
		</div>
	</div>
<script type="text/javascript">
function post_zip(){ //우편번호 찾기
    new daum.Postcode({
    oncomplete: function(data) {
        document.getElementById("receiveZipcode").value = data.zonecode; // 우편번호 넣기
        document.querySelector("input[name=receiveZipcode]").focus();
        document.getElementById("receiveAddr").value = data.address; // 주소 넣기
        document.querySelector("input[name=receiveAddr]").focus();
    }
    }).open();
}

function goOrder(){ //주문하기 버튼 누를때 숨겨진 div 보이기 , 주문자 정보 자동입력 Ajax
	var user = "${user.username}";
	document.getElementById("orderDiv").style.display = "";
	$.ajax({
		url: "/product/goOrder",
		data: {"userId": user},
		dataType: "json",
		type: "post",
		success: function(result){
			document.getElementById("orderName").value = result.name;
			document.getElementById("orderPhone").value = result.phone;
			document.getElementById("orderEmail").value = result.email;
		}
	})
}

$(document).on("click","#removeAll", function(){ //장바구니 목록 비우기 비동기처리
	var user = "${user.username}";
	var prodNo = $(this).val();
 	$.ajax({
		url: "/product/removeThis",
		data: {"userId": user,
			   "prodNo": prodNo},
		dataType:"text",
		type: "POST",
		success: function(result){
			if (result == "success") {
				location.reload();				
			}else {
				alert(result);
			}
		}
	})
});

$(document).on("click","#minus",function(){ //상품 수량 감소 클릭이벤트 감지
	
	var user = "${user.username}";
	var x = $(this).closest("td");
	var form = x.children("#frm");
	var code = form.children("#code").val();
	$.ajax({
		url: "/product/decrease",
		data: {"userId": user,
			   "prodNo": code},
		dataType:"text",
		type: "POST",
		success: function(result){
			if (result == "success") {
				location.reload();				
			} else {
				alert(result);
			}
		}
	})
});

$(document).on("click","#plus",function(){ //상품 증가 버튼 클릭이벤트 감지
	var user = "${user.username}";
	var x = $(this).closest("td");
	var form = x.children("#frm");
	var code = form.children("#code").val();
	$.ajax({
		url: "/product/increase",
		data: {"userId": user,
			   "prodNo": code},
		dataType:"text",
		type: "POST",
		success: function(result){
			if (result == "success") {
				location.reload();				
			} else {
				alert(result);
			}
		}
	})
	
});
	
$(document).ready(function(){
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";
	
	//Ajax spring security header..
	$(document).ajaxSend(function(e, xhr, options){
		xhr.setRequestHeader(csrfHeaderName,csrfTokenValue);
	});
		
		
	
	
	function emptyCart(){ //장바구니 목록이 비어있을때 실행되는 함수
		var tBody = $("tbody");
		var tFoot = $("tfoot");
		var str = "";
		str += '<tr>';
		str += '<td colspan="4">장바구니가 비어있습니다.</td>';
		str += '</tr>';
		tBody.append(str);
		tFoot.remove();
	}
	
	function showCartResult(result){ //장바구니 목록이 있을때 실행되는 함수
		var totalPrice = 0;
		var tBody = $("tbody");
		var td = $("#totalPrice");
		var str = "";
		$(result).each(function(i,obj){
			totalPrice += (obj.proPrice * obj.amount);
			str += '<tr>';
			str += '<td>'+obj.proName+'</td>';
			str += '<td><img id="minus" src="/resources/img/minus.png"> &nbsp;'+obj.amount+'&nbsp;';
			str += '<img id="plus" src="/resources/img/plus.png"> <form id="frm"><input type="hidden" id="code" value="'+obj.prodNo+'"></form></td>';
			str += '<td>'+ obj.proPrice * obj.amount +'</td>';
			str += '<td><button id="removeAll" value="'+obj.prodNo+'">삭제</button></td>';
			str += '</tr>';
		});
		tBody.append(str);
		td.append(totalPrice);
	}
	
	$(function(){ //페이지 로드시 장바구니 목록 데이터 불러오기
		var userId = "${user.username}";
		$.ajax({
			url: "/product/cartList",
			data: {"userId": userId},
			dataType:"json",
			type: "POST",
			success: function(result){
				showCartResult(result); //데이터가 있을때
			},
			error: function(err){ //데이터가 없을때
				emptyCart();
			}
		}); //Ajax
	});

});
	
	
</script>
</body>
</html>