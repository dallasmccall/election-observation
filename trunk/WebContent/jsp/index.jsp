<!DOCTYPE html> 

<html>
<head>
	<%@ page import="backend.*" %>
	<%@ page import="java.util.UUID" %>

	<link rel="stylesheet" href="../css/jquery.mobile-1.0.css">
	<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1, maximum-scale=1">
	<script src="../js/jquery-1.7.1.js" type="text/javascript" charset="utf-8"></script>
	<script src="../js/underscore-min.js" type="text/javascript" charset="utf-8"></script>
	<script src="../js/backbone-min.js" type="text/javascript" charset="utf-8"></script>
	<script src="../js/backbone.localStorage-min.js" type="text/javascript" charset="utf-8"></script>
	<script src="../js/jquery.mobile-1.0.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="../js/chartMaker.js" type="text/javascript" charset="utf-8"></script>

	<script type="text/javascript" src="../js/Home.js"></script>
	<script type="text/javascript" src="../js/Request.js"></script>

	<script type="text/javascript" src="../js/Navigation.js"></script>


	<script src="http://maps.google.com/maps/api/js?sensor=false"></script>


	
	<script type="text/javascript">
	if (null === localStorage.getItem("sessionID"))
	{
		localStorage.setItem("sessionID", "<%=UUID.randomUUID().toString()%>");
	}
	
	$(window).bind("load", function() {
		Home.loadResultsList();		
		Home.initializeIndex();
		var position = localStorage.getItem("ElectionObservationLocation");
		if (null != position)
		{
			updateLocationMessage(position);
		}
		else
		{
			navigator.geolocation.getCurrentPosition(showLocation, showError, {enableHighAccuracy:true,maximumAge:600000});
		}
        
	});
	
	function load() 
	{
		//window.location.hash = "home";
		
	}
	
	function showError(error) 
	{
//        var locationBox = document.getElementById("LocationInformation");
//        
//        var message = locationBox.innerHTML;
//        message = message.replace("Using Location", "No Location");
//		message = message.replace("Determining Location", "Using Location");	
//        
//        locationBox.innerHTML = "No Location";
	}
	
	function showLocation(position) 
	{
		
        
        //var message ="<h1><img src=" + "http://maps.google.com/maps/api/staticmap?sensor=false&center=" + position.coords.latitude + "," +  
		//position.coords.longitude + "&zoom=18&size=300x400&markers=color:blue|label:S|" +  
		//position.coords.latitude + ',' + position.coords.longitude + "/></h1>";
	    var message = position.coords.latitude + ", " + position.coords.longitude;
	    
		
		updateLocationMessage(message);
	}
	
	function updateLocationMessage(message)
	{
		var locationBox = document.getElementById("LocationInformation");
		var formCache = localStorage.getItem("ElectionObservationSendCache");
		if (null === formCache)
		{
			formCache = "";
		}
		
		formCache += "&userLocation=" + message;
		
		localStorage.setItem("ElectionObservationLocation", message);
		
		localStorage.setItem("ElectionObservationSendCache", formCache);
	}
	</script>
	
	<script>
	
	 var geocoder;
 	 var map;
 	 var newMarker;
 	// When map page opens get location and display map
	$("#pageMyLocation").live("pageinit", function() {
		
		
		
	    $('#findAddress').keypress(function(e)
	    	    {
	    	        code= (e.keyCode ? e.keyCode : e.which);
	    	        if (code == 13) {
	    	        	
	    	        	
	    	        	
	    	    	    var address = $("#findAddress").val();
	    	    	    
	    	    	    geocoder.geocode( { 'address': address}, function(results, status) {
	    	    	      if (status == google.maps.GeocoderStatus.OK) {
	    	    	        map.setCenter(results[0].geometry.location);
	    	    	        newMarker = new google.maps.Marker({
	    	    	            map: map,
	    	    	            position: results[0].geometry.location,
	    	    	            title:"New Location",
	    	    	            draggable:true
	    	    	        });
	    	    	      } else {
	    	    	        alert("Geocode was not successful for the following reason: " + status);
	    	    	      }
	    	    	    });
	    	        	
	    	        	
	    	        	
	    	        	e.preventDefault();
	    	        }
	    	        
	   });
		
		
		
		geocoder = new google.maps.Geocoder();
		var position = localStorage.getItem("ElectionObservationLocation");
		if (null != position)
		{
			updateLocationMessage(position);
			var coords = position.split(", ");
			
		    addMap(coords[0], coords[1], "map_canvas");
		}
		else
		{
			navigator.geolocation.getCurrentPosition(showLocation, showError, {enableHighAccuracy:true,maximumAge:600000});
		}

	    
	});
	
 	
 	

 	
	
	
	function addMap(lat,lng,divID) {
		var latlng = new google.maps.LatLng(lat, lng);
		var myOptions = {
			zoom: 16,
			center: latlng,
			mapTypeId: google.maps.MapTypeId.ROADMAP
	    };
		
		
		$("#" + divID).height($(document).height()*0.50);
	    map = new google.maps.Map(document.getElementById(divID),myOptions);
	    
	    
	    

	    
	    
	    
	    
	    var marker = new google.maps.Marker({
	        position: latlng,
	        map: map,
	        title:"Currently Used Location"
	    });
	}
	
	
	
	</script>

	<title>Election Observation Tool</title>

</head>
<body onload="load();">



  <!-- HOME PAGE -->
  <div id="home" data-role="page">
    <div data-role="header" data-theme="a">
	  <a href="#pageMyLocation" data-role="button" data-theme="d" data-icon="gear" data-iconpos="notext" data-rel="dialog" data-transition="fade"></a>
	  <a class="transmitButton ui-disabled" data-role="button"  data-theme="d" data-icon="check" data-iconpos="notext"></a> 
	  <h1  data-theme="a">Election Observation Tool</h1>	  
	</div>
	
	<div data-role="content" style="width:100%; height:100%; padding:0;">

	<h4>Welcome to the Election Observation Tool!</h4>
	<p>Press the arrow button at the bottom right to start the survey, or press the info on the bottom left button for help on using the tool.</p>
	<p>Be sure to check out our sponsors, they have offered some cool rewards for completing a survey. And don't forget to tell your friends!</p>
		
		
	</div>
	
	
	
	
	
			<!-- FOOTER AND NAVBAR -->
		<div data-role="footer"  data-position="fixed" data-id="global-nav-bar">
					
			<div class="navbarMenu">
				<div data-role="navbar" data-position="fixed">
					<ul>
					<li><a data-icon="home"  href="#home" data-role="button" data-transition="fade">Home</a></li>
					<li><a data-icon="check" href="#sponsorsPage" data-role="button" data-rel="dialog" data-transition="fade">Sponsors</a></li>
					<li><a data-icon="star"  href="#mapPage" data-role="button" data-transition="fade" data-rel="dialog">Map</a></li>
					</ul>
					<ul>
					<li><a data-icon="gear" href="#mySurveyPage" data-role="button" data-transition="fade">My Survey</a></li>
					<li><a data-icon="arrow-u"  href="#globalResults" data-role="button" data-rel="dialog" data-transition="fade">Results</a></li>
					<li><a data-icon="back"  href="#page1" data-role="button" data-transition="fade">Restart</a></li>
					</ul>
				</div><!-- /navbar -->				
			</div>
			
		
			<!-- FOOTER AND NAVBAR -->
			<div data-role="navbar" data-position="fixed">
				
				<ul>
					<!-- INFO BUTTON -->
					<li>
						<a href="#infoPage" data-role="button" onclick="hideButtonDescriptions();" data-rel="dialog" data-transition="fade" data-icon="info"></a>
					</li>
					
					<!-- MENU BUTTON -->
					<li><a href="Javascript:toggleMenu()" data-role="button" data-icon="grid" ></a></li>
					
					<!-- NEXT BUTTON -->
					<li>
						<a href="#page1" data-role="button" data-icon="arrow-r"  data-transition="slide" data-direction="forward"></a>
					</li>
					
					
					
				</ul>
			</div><!-- /navbar -->
		</div><!-- /footer -->	
  </div>
  
  
  
  	<div id="pageMyLocation" data-role="page">
		<div data-role="header"><h1>Map View</h1></div>
		<div id="pageMyLcationContent" data-role="content"> 
			<div id="map_canvas" style="width:100%; height:100px; text-align:left">
				<!-- map loads here... -->
			</div>
			

			<input type="search" name="findAddress" id="findAddress" value="Enter Address" />

			<div class="ui-grid-a">
				<div class="ui-block-a">
					<div data-role="controlgroup" data-type="horizontal">
						<a data-role="button">Address</a>
						<a data-role="button">Detect</a>
					</div>
				</div>
				<div class="ui-block-b">
					<a data-role="button">Use New Location</a>
				</div>
			</div>
			
		</div>
	</div>
  
  
  
  
  <!-- GLOBAL RESULTS -->
  <div id="globalResults" data-role="page">
    <div data-role="header">
	  <h1> Results </h1>
	</div>
	
    <div data-role="content">	
      <div id="resultsContent">Loading Results...</div>
    </div>
  	
  </div>

    <!-- SPONSORS -->

  <div id="sponsorsPage" data-role="page">
    <div data-role="header">
	  <h1> Sponsors </h1>
	</div>

<div data-role="content">
	<div data-role="collapsible" data-theme="b" data-content-theme="d">
	   <h3>Sponsor 1</h3>
	   <p>Information about Sponsor 1.</p>
	</div>
	<div data-role="collapsible" data-theme="b" data-content-theme="d">
	   <h3>Sponsor 2</h3>
	   <p>Information about Sponsor 2.</p>
	</div>
	<div data-role="collapsible" data-theme="b" data-content-theme="d">
	   <h3>Sponsor 3</h3>
	   <p>Information about Sponsor 3.</p>
	</div>
		<div data-role="collapsible" data-theme="b" data-content-theme="d">
	   <h3>Sponsor 4</h3>
	   <p>Information about Sponsor 4.</p>
	</div>
</div>
  </div>

    <!-- INFO PAGE -->
  <div id="infoPage" data-role="page">
    <div data-role="header">
	  <h1>How To Use The Tool</h1>
	</div>
	
	<div data-role="content"   >
	  <p>Use the buttons on the bottom to navigate. The button in the middle brings up a menu.</p>
	  <p>Your answers are automatically submited as you take the survey. If you are offline, your answers will automatically be submited when you go back online.</p>
	  <p>Press a button below for more information.</p>
	
				<div data-role="navbar">
					<ul>
					<li><a onclick="selectButtonDescription('buttonDescriptionHome');" data-icon="home"  data-role="button" data-theme="a">Home</a></li>
					<li><a onclick="selectButtonDescription('buttonDescriptionSponsors');" data-icon="check"data-role="button" data-theme="a">Sponsors</a></li>
					<li><a onclick="selectButtonDescription('buttonDescriptionMap');" data-icon="star" data-role="button" data-theme="a">Map</a></li>
					</ul>
					<ul>
					<li><a onclick="selectButtonDescription('buttonDescriptionMySurvey');" data-icon="gear" data-role="button" data-theme="a">My Survey</a></li>
					<li><a onclick="selectButtonDescription('buttonDescriptionResults');" data-icon="arrow-u" data-role="button" data-theme="a">Results</a></li>
					<li><a onclick="selectButtonDescription('buttonDescriptionRestart');" data-icon="back" data-role="button" data-theme="a">Restart</a></li>
					</ul>
					<ul>
					<li><a onclick="selectButtonDescription('buttonDescriptionBack');" data-role="button" data-icon="arrow-l" data-theme="a"></a></li>
					<li><a id="buttonDescriptionButtonMenu" onclick="selectButtonDescription('buttonDescriptionMenu');" data-role="button" data-icon="grid" data-theme="a"></a></li>
					<li><a onclick="selectButtonDescription('buttonDescriptionNext');" data-role="button" data-icon="arrow-r" data-theme="a"></a></li>		
					</ul>
				</div><!-- /navbar -->		
				
				<div id="buttonDescriptions">
					<p id="buttonDescriptionHome">Goes to the home page.</p>
					<p id="buttonDescriptionSponsors">Shows our sponsors, and the prizes they offer for completing a form.</p>
					<p id="buttonDescriptionMap">Shows the survey results map.</p>

					<p id="buttonDescriptionMySurvey">Shows the answers to the survey that you took.</p>
					<p id="buttonDescriptionResults">Shows the latest results from other contributers.</p>
					<p id="buttonDescriptionRestart">Restart</p>

					<p id="buttonDescriptionBack">Goes to the previous page in the survey. On the Home page, this brings up this How-To page.</p>
					<p id="buttonDescriptionMenu">Opens the menu. Includes the Home, Sponsors, Map, My Survey, Results, and Restart buttons seen above.</p>
					<p id="buttonDescriptionNext">Goes to the next page in the survey. On the Home page, this starts the survey.</p>
				</div>
	
	</div>
  </div>

    <%=QuestionMap.generateSurvey()%>
  
</body>
</html>
