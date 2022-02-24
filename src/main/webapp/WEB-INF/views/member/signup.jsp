<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../index/whiteheader.jsp" %>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script type="text/javascript" src="../../resources/js/member.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	var csrfHeaderName = "${_csrf.headerName}";
    var csrfTokenValue = "${_csrf.token}";
    
	$("#userid").blur(function(){ //아이디 인증
	    
		var id = $(this).val();
		if (id == "") {
			$("#userid").val("");
			alert("아이디를 입력해주세요.");
		}else {
			if (regId.test(id) && !regBlank.test(id)) { //아이디 유효성 검증
				$.ajax({
					type : "post",
					url : "/idCheck",
					dataType : "json",
					data : {"id" : id},
					beforeSend: function(xhr){
						xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
					},
					success : function(data){
						if (data != 1) {
							$("#message").show();
							$("#message").html("이미 존재하는 아이디입니다.").css("color","red");
							$("#userid").val("");
						} else {
							$("#message").show();
							$("#message").html("사용 가능한 아이디입니다.").css("color","blue");
						}
					},
					fail : function(){
						alert("system error");
					}
				});	
			} else {
				alert("아이디는 공백을 제외한 영문, 숫자 5~20자만 입력가능합니다.")
				$("#userid").val("");
			}
		}
	});
	
	
	var code2 = ""; //인증번호용 변수 초기화
	
	$("#phonesign").click(function(){ 
		var phone = $("#phone").val();
		
		if (phone == "") {
			alert("휴대폰 번호를 입력하세요");
		} else {
			if (regPhone.test(phone)) {
				alert("인증번호 발송이 완료되었습니다.\n휴대폰에서 인증번호를 확인해주세요.");
				$.ajax({ 
					type:"post", 
					url:"/sendSMS",
					data : {"phone" : phone},
					cache : false,
					beforeSend: function(xhr){
						xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
					},
					success:function(data){ 
						$("#phone").attr("readonly",true); //입력한 휴대폰 번호는 잠금
						code2 = data; //code2에 랜덤 넘버값 세팅
						$("#customNum").show();
					} 
				}); 
			} else {
				alert("잘못된 휴대폰 번호 양식입니다.");
				$("#phone").val("");
				
			}
		}
	});
	//인증번호 유효성 검사
	$("#customNum").blur(function(){
		var inputPhone = $("#customNum").val(); //유저가 입력한 인증번호와 code2값을 비교
		var outputPhone = code2;
		if (inputPhone != outputPhone) {
			alert("인증번호가 일치하지 않습니다.");
			$("#customNum").val("");
			
		}
	});
	
	var regBlank = /\s/g; //공백
	var regId = RegExp(/^[A-Za-z0-9]{5,20}$/); //대,소문자 숫자 5~20자
	var regPw = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,20}$/; //대,소문자 특문 숫자 1건 이상 포함 8~20자
	var regName = /[가-힣]{2,6}$/; //이름 한글 2~6자
	var regPhone = /^01([0|1|6|7|8|9])-?([0-9]{3,4})-?([0-9]{4})$/; //폰번호 01(0179) 이후 3~4숫자 + 4숫자제한
	var regEmailId = /^[A-Za-z0-9_]+[A-Za-z0-9]{4,20}$/; //메일 아이디 첫글자 _허용 +영문숫자 4~20자
	var regEmailAddr = /^[A-Za-z0-9]*[.]{1}[A-Za-z]{1,3}$/; //메일 도메인  .은 반드시 한번만 입력 이후 1~3자까지 제한

});
</script>
<link rel="stylesheet" href="../../resources/css/signup.css">
	<div class="sign-container">
		<form action="" method="post" name="frm" class="sign-form" >
			<label>필수입력</label>
			<input type="text" id="userid" name="userid" placeholder="아이디를 입력하세요" maxlength="20"><br><span style="font-size:9px; display: none;" id="message"></span><br>
			<input type="password" id="userpwd1" name="userpwd1" placeholder="비밀번호를 입력하세요(영문,특수문자,숫자 1건이상포함)" ><br>
			<input type="password" id="userpwd2" name="userpwd2" placeholder="비밀번호를 다시 입력하세요"><br>
			<input type="text" id="username" name="username" maxlength="6" placeholder="이름을 입력하세요" >	<br>
			<input type="text" id="phone" name="phone" maxlength="11" placeholder="휴대폰번호를 입력하세요(숫자만 입력)">
			<input type="button" name="phonesign" id="phonesign" value="인증번호요청" class="sign-btn" ><br>
			<input type="text" name="customNum" id="customNum" maxlength="4"  placeholder="인증번호를 입력하세요" style="display: none;"><br>
			<div class="email-div">
			<input class="email-tag" type="text" id="emailid" name="emailid" placeholder="이메일을 입력하세요">@
			<input class="email-tag" type="text" id="emailaddr" name="emailaddr">
			<select name="emailDom" onchange="emailDomain();">
				<option value="">직접입력</option>
				<option value="naver.com">네이버</option>
				<option value="daum.net">다음</option>
				<option value="gmail.com">구글</option>
				<option value="nate.com">네이트</option>
			</select></div>
			<p style="font-size: 8px;">email은 비밀번호 찾기에 이용됩니다.</p>
			<br><br>
			<hr>
			<label>선택입력</label>
			<input type="text" id="zipcode" name="zipcode" readonly="readonly" onclick="post_zip();">
			<input type="button" value="우편번호찾기" onclick="post_zip()"><br>
			<input type="text" id="addr" name="addr" readonly="readonly"><br>
			<input type="text" name="addr-detail" placeholder="상세 주소를 입력하세요."><br>
			<div><input type="checkbox"><span>기본 배송주소로 등록</span></div><br>
			<input type="button" class="submit" value="회원가입" style="color:white; width: 200px; background-color: #FF5A5A;" onclick="goNext();">
			<input type="button" value="취소" class="sign-btn" onclick="back();">
			<sec:csrfInput/>
		</form>
	</div>
<script>
	
	
	function emailDomain(){ //이메일 select option
		document.frm.emailaddr.value = document.frm.emailDom.value;
	}
	
	function post_zip(){ //우편번호 찾기
	    new daum.Postcode({
	    oncomplete: function(data) {
	        document.getElementById("zipcode").value = data.zonecode; // 우편번호 넣기
	        document.querySelector("input[name=zipcode]").focus();
	        document.getElementById("addr").value = data.address; // 주소 넣기
	        document.querySelector("input[name=addr]").focus();
	    }
	    }).open();
	}
	
	function goNext() {
		var regBlank = /\s/g; //공백
		var regId = RegExp(/^[A-Za-z0-9]{5,20}$/); //대,소문자 숫자 5~20자
		var regPw = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,20}$/; //대,소문자 특문 숫자 1건 이상 포함 8~20자
		var regName = /[가-힣]{2,6}$/; //이름 한글 2~6자
		var regPhone = /^01([0|1|6|7|8|9])-?([0-9]{3,4})-?([0-9]{4})$/; //폰번호 01(0179) 이후 3~4숫자 + 4숫자제한
		var regEmailId = /^[A-Za-z0-9_]+[A-Za-z0-9]{4,20}$/; //메일 아이디 첫글자 _허용 +영문숫자 4~20자
		var regEmailAddr = /^[A-Za-z0-9]*[.]{1}[A-Za-z]{1,3}$/; //메일 도메인  .은 반드시 한번만 입력 이후 1~3자까지 제한
		
		var id = document.getElementById("userid").value;
		var pwd1 = document.getElementById("userpwd1").value;
		var pwd2 = document.getElementById("userpwd2").value;
		var name = document.getElementById("username").value;
		var phone = document.getElementById("phone").value;
		var email = document.getElementById("emailid").value;
		var emailAddr = document.getElementById("emailaddr").value;
 		var customNum = document.getElementById("customNum").value;
		
		if (regPw.test(pwd1) && !regBlank.test(pwd1)) {
		} else {
			alert("비밀번호는 공백을 제외한 영문,특수문자,숫자 조합 8~20자 입력하세요.");
			$("#userpwd1").val("");
			$("#userpwd1").focus();
			return;
		}
		
		if (pwd1 != pwd2) {
			alert("비밀번호가 일치하지 않습니다.");
			$("#userpwd2").val("");
			$("#userpwd2").focus();
			return;
		}

		if (regName.test(name) && !regBlank.test(name)) {
		} else {
			alert("이름은 공백을 제외한 한글 2~6자 입력가능합니다.");
			$("#username").val("");
			$("#username").focus();
			return;
		}

		if (regEmailId.test(email) && !regBlank.test(email)) {
			
		} else{
			alert("이메일 아이디는 공백을 제외한 영문,숫자 4~20자 입니다.");
			$("emailid").val("");
			$("emailid").focus();
			return;
		}

		if (regEmailAddr.test(emailAddr) && !regBlank.test(emailAddr)) {
			
		} else{
			alert("이메일 주소 양식이 올바르지 않습니다.");
			$("emailaddr").val("");
			$("emailaddr").focus();
			return;
		}
	
		if (id != "" && pwd1 != "" && pwd2 != "" && name != "" && email != "" && emailAddr != "" && phone != "" && customNum != "") {
			document.frm.action= "/signupSubmit";
			document.frm.submit();
		} else {
			alert("필수 입력 사항을 확인해주세요.");
		}
	}

	
</script>
</body>
</html>