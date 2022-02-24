<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../index/whiteheader.jsp" %>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<link rel="stylesheet" href="../../resources/css/signup.css">
<script type="text/javascript" src="../../resources/js/member.js"></script>
	<div class="sign-container">
		<form action="" method="post" name="frm" class="sign-form">
			<label>정보수정</label>
			<input type="text" id="userid" name="userid" readonly="readonly" value="${member.userid}"><br>
			<input type="password" id="originPW" name="originPW" placeholder="현재 비밀번호를 입력하세요"><br>
			<input type="password" id="userpwd1" name="userpwd1" placeholder="변경할 비밀번호를 입력하세요"><br>
			<input type="password" id="userpwd2" name="userpwd2" placeholder="비밀번호를 다시 입력하세요"><br>
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
			<input style="margin-left: 125px;" type="text" id="zipcode" name="zipcode" placeholder="주소를 입력하세요" readonly="readonly" onclick="post_zip();">
			<input type="button" style="border:none;" value="우편번호찾기" onclick="post_zip();"><br>
			<input type="text" id="addr" name="addr" readonly="readonly" placeholder="주소를 입력하세요"><br>
			<input type="text" name="addr-detail" placeholder="상세 주소를 입력하세요."><br>
			<div><input type="checkbox"><span>기본 배송주소로 등록</span></div><br>
			<input type="button" style="border:none;" class="sign-drop" value="회원탈퇴" onclick="dropMember();">
			<input type="button" style="border:none;" value="취소" class="sign-btn" onclick="back();"><br>
			<input type="button" class="submit" value="정보수정" onclick="goModify()" style="width: 200px; background-color: #FF5A5A; border: none; border-radius: 3px;	color: white;">
			<sec:csrfInput/>
		</form>
	</div>
<script type="text/javascript">
	var msg = "${message}";
	(function () { 
		if (msg != "") {
			alert(msg);
			
		}
	})();
	
	
	function goModify() {
		var regBlank = /\s/g; //공백
		var regId = RegExp(/^[A-Za-z0-9]{5,20}$/); //대,소문자 숫자 5~20자
		var regPw = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,20}$/; //영문 특문 숫자 1건 이상 포함 8~20자
		var regName = /[가-힣]{2,6}$/; //이름 한글 2~6자
		var regPhone = /^01([0|1|6|7|8|9])-?([0-9]{3,4})-?([0-9]{4})$/; //폰번호 01(0179) 이후 3~4숫자 + 4숫자제한
		var regEmailId = /^[A-Za-z0-9_]+[A-Za-z0-9]{4,20}$/; //메일 아이디 첫글자 _허용 +영문숫자 4~20자
		var regEmailAddr = /^[A-Za-z0-9]*[.]{1}[A-Za-z]{1,3}$/; //메일 도메인  .은 반드시 한번만 입력 이후 1~3자까지 제한
		
		var pw = document.getElementById("originPW").value;
		var pwd1 = document.getElementById("userpwd1").value;
		var pwd2 = document.getElementById("userpwd2").value;
		var email = document.getElementById("emailid").value;
		var emailAddr = document.getElementById("emailaddr").value;
		
		if (pwd1 != "") {
			if (!regPw.test(pwd1)) {
				alert("비밀번호는 공백을 제외한 영문,특문,숫자 조합 8~20자를 입력하세요");
				return;
			}else {
				if (pwd1 != pwd2) {
					alert("새로 입력한 비밀번호가 일치하지 않습니다.");
					return;
				}
			}
		}
		if (email != "") {
			if (!regEmailId.test(email)) {
				alert("이메일 아이디 형식이 올바르지 않습니다.");
				return;
			}else {
				if (!regEmailAddr.test(emailAddr)) {
					alert("이메일 도메인 형식이 올바르지 않습니다.");
					return;
				}
			}
		}
		if (pw != "") {
			document.frm.action= "/modifyAction";
			document.frm.submit();
		} else {
			alert("현재 비밀번호를 입력하세요!");
		}
	}

	function dropMember(){
		var pw = document.getElementsByName("originPW");
		if (pw != "") {
			document.frm.action="/makkan/member/dropmember.makkan";
			document.frm.submit();
		} else {
			alert("기존 비밀번호를 입력해주세요.");
		}
		
	}
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
</script>
</body>
</html>