<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
    <sec:authentication property="principal" var="principal"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="../../resources/css/login.css">
<script type="text/javascript" src="../../resources/js/member.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script type="text/javascript">


//LOGIN TABS
$(function() {
	var tab = $('.tabs h3 a');
	tab.on('click', function(event) {
		event.preventDefault();
		tab.removeClass('active');
		$(this).addClass('active');
		tab_content = $(this).attr('href');
		$('div[id$="tab-content"]').removeClass('active');
		$(tab_content).addClass('active');
	});
});

//SLIDESHOW
$(function() {
	$('#slideshow > div:gt(0)').hide();
	setInterval(function() {
		$('#slideshow > div:first')
		.fadeOut(1000)
		.next()
		.fadeIn(1000)
		.end()
		.appendTo('#slideshow');
	}, 3850);
});

//CUSTOM JQUERY FUNCTION FOR SWAPPING CLASSES
(function($) {
	'use strict';
	$.fn.swapClass = function(remove, add) {
		this.removeClass(remove).addClass(add);
		return this;
	};
}(jQuery));

//SHOW/HIDE PANEL ROUTINE (needs better methods)
//I'll optimize when time permits.
 $(function() {
	$('.agree').on('click', function(event) {
		event.preventDefault();
		var terms = $('.terms'),
     recovery = $('.recovery'),
     close = $('#toggle-terms'),
     arrow = $('.tabs-content .fa');
		if ($(this).hasClass('agree') || $(this).hasClass('log-in') || ($(this).is('#toggle-terms')) && terms.hasClass('open')) {
			if (terms.hasClass('open')) {
				terms.swapClass('open', 'closed');
				close.swapClass('open', 'closed');
				arrow.swapClass('active', 'inactive');
			} else {
				if ($(this).hasClass('log-in')) {
					return;
				}
				terms.swapClass('closed', 'open').scrollTop(0);
				close.swapClass('closed', 'open');
				arrow.swapClass('inactive', 'active');
			}
		}
		else if ($(this).hasClass('forgot') || $(this).hasClass('sign-up') || $(this).is('#toggle-terms')) {
			if (recovery.hasClass('open')) {
				recovery.swapClass('open', 'closed');
				close.swapClass('open', 'closed');
				arrow.swapClass('active', 'inactive');
			} else {
				if ($(this).hasClass('sign-up')) {
					return;
				}
				recovery.swapClass('closed', 'open');
				close.swapClass('closed', 'open');
				arrow.swapClass('inactive', 'active');
			}
		}
	}); 
});

//DISPLAY MSSG
$(function() {
	$('.recovery .button').on('click', function(event) {
		event.preventDefault();
		$('.recovery .mssg').addClass('animate');
		setTimeout(function() {
			$('.recovery').swapClass('open', 'closed');
			$('#toggle-terms').swapClass('open', 'closed');
			$('.tabs-content .fa').swapClass('active', 'inactive');
			$('.recovery .mssg').removeClass('animate');
		}, 2500);
	});
});

//DISABLE SUBMIT FOR DEMO
$(function() {
	$('.button').on('click', function(event) {
		$(this).stop();
		event.preventDefault();
		return false;
	});
});

function goLogin() {
	var blank = /\s/g; //공백 체크
	var id = document.getElementById("user_login").value;
	var pw = document.getElementById("user_pass").value;
	if (id != "" && pw != "") {
		if (!blank.test(id) && !blank.test(pw)) {
			document.memberform.action="/loginConfirm";
			document.memberform.submit();
		} else {
			alert("space bar는 입력할 수 없습니다.");
		}
	} else {
		alert("ID / PW는 필수입력입니다.");
	}
}
function goSignup(){
	location.href="/term";
}
</script>
</head>
<body>
	<div class="nav-title">
      <a href="/"><img alt="logo" src="../../resources/img/blacklogo.PNG" style="width:180px;"></a>
    </div>
     <!-- LOGIN MODULE -->
    <div class="login">
        <div class="wrap">
            <!-- TOGGLE -->
            <!-- TERMS -->
            <div class="terms">
                <h2>약관 보기</h2>
                <p>준비중인데요?</p>
            </div>

            <!-- RECOVERY -->


            <!-- SLIDER -->
            <div class="content">
                <!-- SLIDESHOW -->
                <div id="slideshow" >
                    <div class="one">
                        <h2><span></span></h2>
                        <p></p>
                    </div>
						<div class="two">
                        <h2><span></span></h2>
                        <p></p>
                    </div>
                    <div class="three">
                        <h2><span></span></h2>
                        <p></p>
                    </div>
                </div>
            </div>
            <!-- LOGIN FORM -->
            <div class="user">
                <!-- ACTIONS
                <div class="actions">
                    <a class="help" href="#signup-tab-content">Sign Up</a><a class="faq" href="#login-tab-content">Login</a>
                </div>
                -->
                <div class="form-wrap">
                    <!-- TABS -->
                	<div class="tabs">
                        <h3 class="login-tab"><a class="log-in active" href="#login-tab-content"><span>로그인<span></a></h3>
                		<h3 class="signup-tab"><a class="sign-up" href="#signup-tab-content"><span>비회원 주문</span></a></h3>
                	</div>
                    <!-- TABS CONTENT -->
                	<div class="tabs-content">
                        <!-- TABS CONTENT LOGIN -->
                		<div id="login-tab-content" class="active">
                			<form action="" method="post" class="signupform" name="memberform">
                				<input type="text" class="input" name="id" id="user_login" autocomplete="off" placeholder="아이디를 입력하세요">
                				<input type="password" class="input" name="pw" id="user_pass" autocomplete="off" placeholder="비밀번호를 입력하세요">
                				<input type="checkbox" class="checkbox" id="remember_me" onclick="ready();">
                				<label for="remember_me">아이디 기억하기</label><br>
                				<div class="aaaa">
	                				<input type="button" class="button" value="로그인" onclick="goLogin();">
	                				<input type="button" class="button" value="회원가입" onclick="goSignup();">
                				</div>
                				<sec:csrfInput/>
                			</form>
                		<!-- 	<div class="help-action">
                				<span><i class="fa fa-arrow-left" aria-hidden="true"></i><a class="forgot" href="find.html">아이디 / 비밀번호 찾기</a></span>
                			</div> -->
                			<a class="forgot" href="/forgot">아이디 / 비밀번호 찾기</a>
                		</div>
                        <!-- TABS CONTENT SIGNUP -->
                		<div id="signup-tab-content">
                			<form class="signup-form" action="" method="post">
                				<input type="email" class="input" id="user_name" autocomplete="off" placeholder="이름">
                				<div class="inlineinput">
	                				<input type="text" class="input" id="user_phone" autocomplete="off" placeholder="휴대폰번호(숫자만입력)">
	                				<button onclick="ready();">인증요청</button>
                				</div>
                				<input type="password" class="input" id="phone_pass" autocomplete="off" placeholder="인증번호">
                				<input type="checkbox" class="checkbox" checked id="agree1">
                				<label for="agree1">개인정보 수집 및 이용동의</label><br>
                				<input type="checkbox" class="checkbox" checked id="agree2">
                				<label for="agree2">위치기반 서비스 이용동의</label>
                				<input type="submit" onclick="ready();" class="button" value="비회원 주문하기">
                			</form>
                			<div class="help-action">
                				<p><i class="fa fa-arrow-left" aria-hidden="true"></i><a class="agree" href="#">이용 약관 보기</a></p>
                			</div>
                		</div>
                	</div>
            	</div>
            </div>
        </div>
    </div>
<script type="text/javascript">

	//loginFailHandler를 통해 받은 msg
	var x = "${requestScope.loginFailMsg}";
	(function () { 
		if (x != "") {
			alert(x);
		}
	})();
	
	var msg = "${message}";
	(function(){
		if (msg != "") {
			alert(msg);
		}
	})();
	
    function ready(){
		alert("준비중 입니다.");
	}
</script>
</body>
</html>