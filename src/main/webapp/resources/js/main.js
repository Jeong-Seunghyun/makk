/**
 * 
 */
	function accessDenied(){
		alert("로그인이 필요한 서비스입니다.");
		location.href="/loginForm";
	}
 
 	function logoutConfirm(logoutAction) {
		var x = confirm('로그아웃 하시겠습니까?');
		if (x) {
			logoutAction.submit();
		}
	}
	
	
	function ready(){
		alert("준비중 입니다.");
	}