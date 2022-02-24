/**
 * 
 */
var regBlank = /\s/g; //공백
var regName = /[가-힣]{2,6}$/; //이름 한글 2~6자
var regPhone = /^01([0|1|6|7|8|9])-?([0-9]{3,4})-?([0-9]{4})$/; //폰번호 01(0179) 이후 3~4숫자 + 4숫자제한
 
 $(document).on("click","#orderSubmit",function(){
	var receiveName = $("#receiveName").val();
	var receivePhone = $("#receivePhone").val();
	var receiveZipcode = $("#receiveZipcode").val();

	
	if (regBlank.test(receiveName) || !regName.test(receiveName)) {
		alert("수령인 성함은 공백을 제외한 한글만 입력 가능합니다.");
		$("#receiveName").focus();
		return;
	}
	if (regBlank.test(receivePhone) || !regPhone.test(receivePhone)) {
		alert("수령인 휴대폰 번호 양식이 올바르지 않습니다.");
		$("#receivePhone").focus();
		return;
	}
	if (receiveZipcode == "") {
		alert("배달 받으실 주소를 입력해주세요");
		return;
	}
	iamport();
});
 
 function iamport(){
	//가맹점 식별코드
	IMP.init("imp19190636");
	IMP.request_pay({
	    pg : 'inicis', // version 1.1.0부터 지원.
	    pay_method : 'card',
	    merchant_uid : 'merchant_' + new Date().getTime(),
	    name : '주문명:결제테스트',
	    amount : 100, //판매 가격
	    buyer_email : 'iamport@siot.do',
	    buyer_name : '구매자이름',
	    buyer_tel : '010-1234-5678',
	    buyer_addr : '서울특별시 강남구 삼성동',
	    buyer_postcode : '123-456'
	}, function(rsp) {
	    if ( rsp.success ) {
	        console.log(rsp);
	        $.ajax({
				type:"post",
				url : "/verifyIamport/" + rsp.imp_uid,
				contentType: 'application/json',
				headers: { "Content-Type": "application/json" },
         		data: {
              	imp_uid: rsp.imp_uid,
              	merchant_uid: rsp.merchant_uid
          		}//기타 필요한 데이터가 있으면 추가 전달
			}).done(function(data){
				//서버에서 결제가 정상 승인되었을때
				if(rsp.paid_amount == data.response.amount){ //발행된 토큰의 금액과 실제결제액을 비교함
		        	alert("결제 및 결제검증완료");
	        	} else {
	        		alert("결제 실패");
	        	}
			});
	    } else {
	        var msg = '결제에 실패하였습니다.';
	        msg += '에러내용 : ' + rsp.error_msg;
	    }
	    alert(msg);
	});
}