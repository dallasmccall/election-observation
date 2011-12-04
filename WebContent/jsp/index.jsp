<!DOCTYPE html> 

<html>
<head>
	<%@ page import="backend.*" %>
	<%@ page import="java.util.UUID" %>

	<link rel="stylesheet" href="../css/jquery.mobile-1.0.css">
	<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1, maximum-scale=1">
	<script src="../js/jquery-1.7.1.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="../js/underscore-min.js" type="text/javascript" charset="utf-8"></script>
	<script src="../js/backbone-min.js" type="text/javascript" charset="utf-8"></script>
	<script src="../js/backbone.localStorage-min.js" type="text/javascript" charset="utf-8"></script>
	<script src="../js/jquery.mobile-1.0.min.js" type="text/javascript" charset="utf-8"></script>

	<script type="text/javascript" src="../js/Home.js"></script>
	<script type="text/javascript" src="../js/Request.js"></script>

	<script type="text/javascript" src="../js/Navigation.js"></script>

	
	<script type="text/javascript">
	if (null === localStorage.getItem("sessionID"))
	{
		localStorage.setItem("sessionID", "<%=UUID.randomUUID().toString()%>");
	}
	
	$(window).bind("load", function() {
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
        var locationBox = document.getElementById("LocationInformation");
        locationBox.innerHTML = "Error: Could not locate device";
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
		
		message = "Using Location : <" + message + ">";
		
        locationBox.innerHTML = message;
	}
	</script>


	<title>Election Observation Tool</title>
  
 
</head>
<body onload="load();">





  <!-- HOME PAGE -->
  <div id="home" data-role="page">
    <div data-role="header">
	  <h1> Election Observation Tool  </h1>
	  
	</div>
	
	<div data-role="content">

	  <a href="#page1" data-role="button" data-icon="plus" data-theme="b" data-transition="slide" data-direction="forward">
	  Begin Survey
	  </a>
	  
	  <ul data-role="listview" data-inset="true">
	    <li> <a href="#myForm"> View My Submission </a> </li>
		<li> <a href="#globalResults" onclick="Home.loadResults();" data-rel="dialog" data-transition="fade"> View Current Results </a> </li>
		<li> <a href="#sponsorsPage" data-rel="dialog" data-transition="fade"> Learn about our sponsors! </a> </li>
	  </ul>	
	</div>
	
	
	
	
	
			<!-- FOOTER AND NAVBAR -->
		<div data-role="footer"  data-position="fixed" data-id="global-nav-bar">	
			<span id="LocationInformation" style="text-align: center">Determining Location...</span>
					
			<div class="navbarMenu">
				<div data-role="navbar" data-position="fixed">
					<ul>
					<li><a href="#AlreadyHome" data-role="button" data-transition="fade">Home</a></li>
					<li><a href="#sponsorsPage" data-role="button" data-rel="dialog" data-transition="fade">Sponsors</a></li>
					<li><a href="#mapPage" data-role="button" data-transition="fade">Map</a></li>
					</ul>
					<ul>
					<li><a href="#mySurveyPage" data-role="button" data-transition="fade">My Survey</a></li>
					<li><a href="#globalResults" onclick="Home.loadResults();" data-role="button" data-rel="dialog" data-transition="fade">Results</a></li>
					<li><a href="#page1" data-role="button" data-transition="fade">Restart</a></li>
					</ul>
				</div><!-- /navbar -->				
			</div>
			
		
			<!-- FOOTER AND NAVBAR -->
			<div data-role="navbar" data-position="fixed">
				
				<ul>
					<!-- INFO BUTTON -->
					<li>
						<a href="#infoPage" data-role="button" data-rel="dialog" data-transition="fade" data-icon="info"></a>
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
  
  
  
  
  
  
  
  <div id="globalResults" data-role="page">
    <div data-role="header">
	  <h1> Results </h1>
	</div>
	
	<div data-role="content">
	    <div id="resultsContent">
	    No results to display.
	    </div>
	</div>
  </div>
  
  
  
  
  
  
    <!-- SPONSORS -->

  <div id="sponsorsPage" data-role="page">
    <div data-role="header">
	  <h1> Sponsors </h1>
	</div>
	
	<div data-role="content">
	  <p>Here is info about our sponsors</p>
	</div>
  </div>
  
    <!-- INFO PAGE -->
  <div id="infoPage" data-role="page">
    <div data-role="header">
	  <h1>How To Use The Tool</h1>
	</div>
	
	<div data-role="content">
	  <p>Use the buttons on the bottom to navigate. The button in the middle brings up a menu. (TODO: add more explanation.)</p>
	</div>
  </div>


  
    <%=QuestionMap.generateSurvey()%>
  
</body>
</html>
