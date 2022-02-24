<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="../../resources/css/login.css">
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
	$('.agree,.forgot, #toggle-terms, .log-in, .sign-up').on('click', function(event) {
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
</script>
</head>
<body>
	<div class="nav-title">
      <a href="/"><img alt="logo" src="../../resources/img/blacklogo.PNG" style="width:180px;"></a>
    </div>
     <!-- LOGIN MODULE -->
    <div class="login">
        <div class="wrap">
            <!-- SLIDER -->
            <div class="content" style="background-color:lightgray;">
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
                        <h3 class="login-tab"><a class="log-in active" href="#login-tab-content"><span>비밀번호 찾기<span></a></h3>
                		<h3 class="signup-tab"><a class="sign-up" href="#signup-tab-content"><span>아이디 찾기</span></a></h3>
                	</div>
                    <!-- TABS CONTENT -->
                	<div class="tabs-content">
                        <!-- TABS CONTENT LOGIN -->
                		<div id="login-tab-content" class="active">
                			<form class="login-form" action="" method="post" name="frm">
                				<br>
                				<input type="text" class="input" id="id" name="id" autocomplete="off" placeholder="아이디를 입력하세요">
                				<input type="text" class="input" id="email" name="email" autocomplete="off" placeholder="이메일을 입력하세요">
                				<label style="font-size: 8px;">회원가입시 등록된 이메일로 재설정 비밀번호를 발송합니다.</label><br>
                				<div class="aaaa" >
	                				<input type="button" class="button" value="비밀번호 찾기" onclick="findPW();">
                				</div>
                				<sec:csrfInput/>
                			</form>
                		</div>
                        <!-- TABS CONTENT SIGNUP -->
                		<div id="signup-tab-content">
                			<form class="signup-form" action="" method="post">
                				<br><br>
                				<input type="button" class="button" value="본인명의의 휴대폰으로 인증" onclick="ready();" style="width:287px; background-color:ff5a5a;">
                			</form>
                			<br><br>
                			<div class="help-action">
                				<p><i class="fa fa-arrow-left" aria-hidden="true" style="font-size:8px; text-align:center; margin-left:80px">회원님의 명의로 등록된 휴대폰으로<br>본인 확인을 진행합니다.</i></p>
                			</div>
                		</div>
                	</div>
            	</div>
            </div>
        </div>
    </div>
<script type="text/javascript">
	var msg = "${message}";
	(function(){
		if (msg != "") {
			alert(msg);
		}
	})();

	function ready(){
		alert("준비중 입니다.");
	}
	function findPW() {
		var blank = /\s/g; //공백 체크
		var id = document.getElementById("id").value;
		var email = document.getElementById("email").value;
		
		if (id != "" && email != "") {
			if (!blank.test(id) && !blank.test(email)) {
				document.frm.action="/findPassword";
				document.frm.submit();
			} else {
				alert("space bar는 입력 불가능합니다.");
			}
		}else {
			alert("아이디와 가입시 등록한 email주소를 입력하세요.")
		}
	}
</script>
</body>
</html>