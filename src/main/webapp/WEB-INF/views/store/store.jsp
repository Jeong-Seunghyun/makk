<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../index/blackheader.jsp" %>
<link rel="stylesheet" href="/resources/css/board.css">
<link rel="stylesheet" href="/resources/css/weather.css">
<style>
	form{
		text-align: center;
	}
	label{
		background-color: #1ABC9C;
		color: white;
		border : none;
		border-radius: 20px;
		font-size: 13px;
		padding: 3px 15px;
	}
	input[type=button]{
		background-color: #ff5a5a;
		color: white;
		border: none;
		padding: 5px;
		border-radius: 3px;
	}
      .mapBody {
      	margin: 50px auto 0 auto;
        width: 900px;
        height: 500px;
        border: 1px solid #gray;
        border-radius: 5px;
      }
      div.left {
        width: 70%;
        height: 100%;
        float: left;
        box-sizing: border-box;
      }
      div.right {
        width: 30%;
        height: 100%;
        float: right;
        box-sizing: border-box;
      }
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<div class="mapBody">
		<div class="left" id="map">
		</div>
		<div class="right">
			<div id="sunShower" class="icon sun-shower" style="display:none;">
			  <div class="cloud"></div>
			  <div class="sun">
			    <div class="rays"></div>
			  </div>
			  <div class="rain"></div>
			</div>
			
			<div id="thunder" class="icon thunder-storm" style="display:none;">
			  <div class="cloud"></div>
			  <div class="lightning">
			    <div class="bolt"></div>
			    <div class="bolt"></div>
			  </div>
			</div>
			
			<div id="cloudy" class="icon cloudy" style="display:none;">
			  <div class="cloud"></div>
			  <div class="cloud"></div>
			</div>
			
			<div id="snow" class="icon flurries" style="display:none;">
			  <div class="cloud"></div>
			  <div class="snow">
			    <div class="flake"></div>
			    <div class="flake"></div>
			  </div>
			</div>
			
			<div id="sunny" class="icon sunny" style="display:none;">
			  <div class="sun">
			    <div class="rays"></div>
			  </div>
			</div>
			
			<div id="rainy" class="icon rainy" style="display:none;">
			  <div class="cloud"></div>
			  <div class="rain"></div>
			</div>
						
		    <span id="content" style="color:white; font-weight:bold; ">
		    </span><br><br>
		    <span id="alert" style="color:white; font-weight:bold; ">
		    </span><br><br>
		    <i style="color:white; font-size: 4px;">우천시 배달료가 할증되거나 안내 시간보다 배달이 늦을 수 있습니다.</i>
			<form action="" method="get" style="text-align: center; margin-top: 50px;">
				<label>매장찾기</label><br><br>
				<input type="text" name="store" id="store" style="width:130px"> &nbsp;
				<input type="button" value="검색" onclick="findStore();">
			</form>
		</div>
	</div>
<script>
	//날씨 결과 값에 따라 보여질 Div 세팅
function showWeather(obj){
	document.getElementById("content").innerHTML = "접속 위치 : "+obj.name;
	var weather = obj.weather[0].main;
	if (weather == "Clouds") {
		document.getElementById("alert").innerHTML = "날씨 : 구름";
		document.getElementById("cloudy").style.display= "";
	} else if (weather == "Clear") {
		document.getElementById("alert").innerHTML = "날씨 : 맑음";
		document.getElementById("sunny").style.display= "";
	} else if (weather == "Thunderstorm") {
		document.getElementById("alert").innerHTML = "날씨 : 천둥번개";
		document.getElementById("thunder").style.display= "";
	} else if (weather == "Drizzle") {
		document.getElementById("alert").innerHTML = "날씨 : 천둥번개";
		document.getElementById("thunder").style.display= "";
	} else if (weather == "Rain") {
		document.getElementById("alert").innerHTML = "날씨 : 비";
		document.getElementById("rainy").style.display= "";
	} else if (weather == "Snow") {
		document.getElementById("alert").innerHTML = "날씨 : 눈";
		document.getElementById("snow").style.display= "";
	} else if (weather == "Atmosphere") {
		document.getElementById("alert").innerHTML = "날씨 : 흐림";
		document.getElementById("cloudy").style.display= "";
	} else {
		document.getElementById("alert").innerHTML = "날씨 : 흐림";
		document.getElementById("cloudy").style.display= "";
	}
}


//사용자 위치의 도시 정보, 날씨
function onGeoOk(position) {
	const API_KEY = '836dd720e7941f47159052de960d998f';
	const latitude = position.coords.latitude;
	const longitude = position.coords.longitude;
	const apiURI = "https://api.openweathermap.org/data/2.5/weather?lat="+latitude+"&lon="+longitude+"&appid="+API_KEY+"&units=metric&lang=kr";
	
	$.ajax({
        url: apiURI,
        dataType: "json",
        type: "GET",
        async: "false",
        success: function(resp) {
            showWeather(resp); //사용자 위치로 날씨정보를 받아왔을때 실행
        }
    })
}

function onGeoError(err) { //사용자 위치 정보 사용동의 거부시
	console.log(err.code);
	console.log(err.message);
    var aAPI_KEY = '836dd720e7941f47159052de960d998f';
	var alatitude = 37.557745;
	var alongitude = 126.943060;
	var aapiURI = "https://api.openweathermap.org/data/2.5/weather?lat="+alatitude+"&lon="+alongitude+"&appid="+aAPI_KEY+"&units=metric&lang=kr";
    initMap(alatitude,alongitude);
    $.ajax({
        url: aapiURI,
        dataType: "json",
        type: "GET",
        async: "false",
        success: function(resp) {
            console.log(resp);
            console.log("현재온도 : "+ (resp.main.temp) );
            console.log("현재습도 : "+ resp.main.humidity);
            console.log("날씨 : "+ resp.weather[0].main );
            console.log("상세날씨설명 : "+ resp.weather[0].description );
            console.log("날씨 이미지 : "+ resp.weather[0].icon );
            console.log("바람   : "+ resp.wind.speed );
            console.log("나라   : "+ resp.sys.country );
            console.log("도시이름  : "+ resp.name );
            console.log("구름  : "+ (resp.clouds.all) +"%" );
            showWeather(resp);
        }
    })
}

navigator.geolocation.getCurrentPosition(onGeoOk,onGeoError);
navigator.geolocation.getCurrentPosition((position) => {
		//사용자 위치로 실행될 영역
	  initMap(position.coords.latitude, position.coords.longitude);
	});
              
//지도 호출 함수
function initMap(latitude,longitude) {

    // 지도 스타일
    const map = new google.maps.Map(document.getElementById("map"), {
        zoom: 16,
        center: { lat: latitude, lng: longitude },
    });

    // 마커 정보
    var locations = [
        {place: "마깐 신촌 본점", lat: 37.557745, lng: 126.943060},
        {place: "마깐 광주 충장점", lat: 35.151802, lng:126.913880},
        {place: "마깐 광주 첨단점", lat:35.213644, lng:126.843265}
    ];

    //인포윈도우
    var infowindow = new google.maps.InfoWindow();

    //마커 생성
    var myIcon = new google.maps.MarkerImage("/resources/img/marker2.png", null, null, null, new google.maps.Size(50,50));
    var myStore = new google.maps.MarkerImage("/resources/img/store.png", null, null, null, new google.maps.Size(50,50));
    var marker = new google.maps.Marker({
        map: map,
        icon: myIcon,
        position: new google.maps.LatLng(latitude, longitude)
    });
    for (var i = 0; i < locations.length; i++) {
        var marker = new google.maps.Marker({
            map: map,
            //label: locations[i].place,
            position: new google.maps.LatLng(locations[i].lat, locations[i].lng),
            icon:myStore
        });


        google.maps.event.addListener(marker, 'click', (function(marker, i) {
            return function() {
                //html로 표시될 인포 윈도우의 내용
                infowindow.setContent(locations[i].place);
                //인포윈도우가 표시될 위치
                infowindow.open(map, marker);
            }
        })(marker, i));
        
        if (marker) {
            marker.addListener('click', function() {
                //중심 위치를 클릭된 마커의 위치로 변경
                map.setCenter(this.getPosition());
                //마커 클릭 시의 줌 변화
                map.setZoom(15);
            });
        }
    }
}
</script>
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBKDED9Ukh8gZ2nXW_xDpeDgQSWR1TeuGM&libraries=&v=weekly" async></script>
</body>
</html>