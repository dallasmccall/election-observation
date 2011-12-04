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
	
	function load() 
	{
		Home.initializeIndex();
        navigator.geolocation.getCurrentPosition(showLocation, showError, {enableHighAccuracy:true,maximumAge:600000});
	}
	
	function showError(error) 
	{
        var locationBox = document.getElementById("LocationInformation");
        locationBox.innerHTML = "Error: Could not locate device";
	}
	
	function showLocation(position) 
	{
        var locationBox = document.getElementById("LocationInformation");
        //var message ="<h1><img src=" + "http://maps.google.com/maps/api/staticmap?sensor=false&center=" + position.coords.latitude + "," +  
		//position.coords.longitude + "&zoom=18&size=300x400&markers=color:blue|label:S|" +  
		//position.coords.latitude + ',' + position.coords.longitude + "/></h1>";
	    var message = position.coords.latitude + ", " + position.coords.longitude;
	    

		var formCache = localStorage.getItem("ElectionObservationSendCache");
		if (null === formCache)
		{
			formCache = "";
		}
		
		formCache += "&userLocation=" + message;
		
		localStorage.setItem("ElectionObservationSendCache", formCache);
		
		message = "Using Location : <" + message + ">";
		
        locationBox.innerHTML = message;
	}
	</script>


	<title>Election Observation Tool</title>
  
 
</head>
<body onload="load();">

  <div id="globalResults">
    <div id="resultsContent">
    No results to display.
    </div>
  	<a href="#home" data-role="button" data-transition="fade">Go Home</a>
  </div>


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
		<li> <a href="#globalResults" onclick="Home.loadResults();"> View Current Results </a> </li>
		<li> <a href="#cloudPoints" data-rel="dialog" data-transition="fade"> Learn about Cloud Points! </a> </li>
	  </ul>	
	</div>
	
	
	
	
	
			<!-- FOOTER AND NAVBAR -->
		<div data-role="footer"  data-position="fixed" data-id="global-nav-bar">	
			<span id="LocationInformation" style="text-align: center">Determining Location...</span>
					
			<div class="navbarMenu">
				<div data-role="navbar" data-position="fixed">
					<ul>
					<li><a href="#AlreadyHome" data-role="button" data-transition="fade">Home</a></li>
					<li><a href="#cloudPoints" data-role="button" data-rel="dialog" data-transition="fade">Cloud Points</a></li>
					<li><a href="#newForm" data-role="button" data-transition="fade">Restart</a></li>
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
  
  
    <!-- CLOUD POINTS -->
  <div id="cloudPoints" data-role="page">
    <div data-role="header">
	  <h1> Cloud Points </h1>
	</div>
	
	<div data-role="content">
	  <p>Cloud Points allow you to post a message on our publically viewable Cloud Board. The more points the larger your post will be, and the longer you can keep it visible!
	  Earn points by: Submitting a survey (3 points), sending a link to a friend (1 point), and a friend you recommend submitting a survey (2 points)!</p>
	  <p> 1 Point: Small text size, visible for 1+ day. </p>
	  <p> 4 Points: Medium text size OR visible for 3+ days. </p>
	  <p> 8 Points: Medium text size OR visible for 7+ days. </p>
	  <p> 12 Points: Large text size OR visible for 14+ days. </p>
	  <p> 20 Points: Extra Large Text Size </p>
	</div>
  </div>
  
    <!-- CLOUD POINTS -->
  <div id="infoPage" data-role="page">
    <div data-role="header">
	  <h1>How To Use The Tool</h1>
	</div>
	
	<div data-role="content">
	  <p>Use the buttons on the bottom to navigate. The button in the middle brings up a menu. (TODO: add more explanation.)</p>
	</div>
  </div>


  
    <!-- MENU fadeUP -->
  <div id="menu" data-role="page" data-overlay-theme="e">
    <div data-role="header">
	  <h1> Menu </h1>
	</div>

	<div data-role="content">

			<ul>
				<li><a href="#home" data-role="button" data-transition="fade">Home</a></li>
				<li><a href="#cloudPoints" data-role="button" data-rel="dialog" data-transition="fade">Cloud Points</a></li>
				<li><a href="#newForm" data-role="button" data-transition="fade">Restart</a></li>
			</ul>

	</div>
	
  </div>
  
    <%=QuestionMap.generateSurvey()%>
  
</body>
</html>
