<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="./blackheader.jsp" %>
<!-- Hero Unit -->
<section class="hero-unit">

  <div class="row">
    <div class="large-12 columns">
<!--       <hgroup>
        <h1>Code. Design. Education.</h1>
        <h3>Just keep learning. Make new opportunities.</h3>
      </hgroup> -->


      <ul class="small-block-grid-2 medium-block-grid-3 flip-cards">

        <li ontouchstart="this.classList.toggle('hover');">
          <div class="large button card-front" style="padding-top: 60px;">
            <a href="#">DELIVERY</a>
          </div>
          <a href="#" class="panel card-back" style="background-size: cover;">
          	<img alt="#" src="../../resources/img/deli.png" style=" width:inherit; height:inherit;">
<!--             <div class="hub-info">
              <a href="#"></a>
            </div> -->
          </a>
        </li>

        <li ontouchstart="this.classList.toggle('hover');">
          <div class="large button card-front" style="padding-top: 60px;">
            <a href="#">TO GO</a>
          </div>
			<a href="#" class="panel card-back" style="background-size: cover;">
          	<img alt="#" src="../../resources/img/togo.png" style=" width:inherit; height:inherit;">
          	</a>
        </li>

        <li ontouchstart="this.classList.toggle('hover');">
          <div class="large button card-front" style="padding-top: 60px;">
            <a href="">CART</a>
          </div>
          <sec:authorize access="isAuthenticated()">
        	<a href="/product/goCart" class="panel card-back" style="background-size: cover;">
         	<img src="../../resources/img/cart.png" style=" width:inherit; height:inherit;">
         	</a>          
          </sec:authorize>
          <sec:authorize access="isAnonymous()">
         	<a href="javascript:confirms()" class="panel card-back" style="background-size: cover;">
         	<img src="../../resources/img/cart.png" style=" width:inherit; height:inherit;">
         	</a> 
          </sec:authorize>
        </li>

        <li ontouchstart="this.classList.toggle('hover');">
          <div class="large button card-front" style="padding-top: 60px;">
            <a href="">EVENT</a>
          </div>

          <a href="#" class="panel card-back" style="background-size: cover;">
          	<img alt="#" src="../../resources/img/event.png" style=" width:inherit; height:inherit;">
          	</a>
        </li>

        <li ontouchstart="this.classList.toggle('hover');">
          <div class="large button card-front" style="padding-top: 60px;">
            <a href="/store">STORE</a>
          </div>

           <a href="/store" class="panel card-back" style="background-size: cover;">
          	<img alt="#" src="../../resources/img/store.png" style=" width:inherit; height:inherit;">
          	</a>
        </li>

        <li ontouchstart="this.classList.toggle('hover');">
          <div class="large button card-front" style="padding-top: 60px;">
            <a href="http://www.aicfchurch.org">GIFT</a>
            <!-- <i class="fa fa-users card-icon"></i> -->
          </div>

           <a href="#" class="panel card-back" style="background-size: cover;">
          	<img alt="#" src="../../resources/img/gift.png" style=" width:inherit; height:inherit;">
          	</a>
        </li>

      </ul>
    </div>
  </div>
</section>
<script type="text/javascript">
	var successMsg = "${success}";
	var failMsg = "${fail}";
	(function() {
		if (successMsg != "" || failMsg != "") {
			alert(successMsg+failMsg);
			if (successMsg != "") {
				logout(logoutAction);
			}
		}
	})();
	
	function logout(logoutAction){
		logoutAction.submit();
	}
	
	function confirms(){
		alert("로그인이 필요한 서비스입니다.");
		location.href="/loginForm";
	}
</script>
<%@ include file="./footer.jsp"%>