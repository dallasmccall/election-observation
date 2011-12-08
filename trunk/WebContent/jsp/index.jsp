<!DOCTYPE html> 

<html>
<head>
	<%@ page import="backend.*" %>
	<%@ page import="java.util.UUID" %>

	<link rel="stylesheet" href="../css/jquery.mobile-1.0.css">
	<meta name="viewport" content="width=device-width, minimum-scale=1, initial-scale=1, maximum-scale=1">
	<meta name="apple-mobile-web-app-capable" content="yes" />
	<meta names="apple-mobile-web-app-status-bar-style" content="black-translucent" />
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
	
	
	function verifyPage()
	{
		localStorage.removeItem("ElectionObservationResponseCache");
		localStorage.removeItem("sessionID");
	}
	
	$('[data-role=dialog]div[id="sharePage"]').live('pagecreate', function (event) {
	     $("a[data-icon='delete']").hide();
	});
	
	</script>

	<title>Election Observer</title>

</head>
<body onload="load();">



  <!-- HOME PAGE -->
  <div id="home" data-role="page">
    <div data-role="header" data-theme="a">
    
    
   
	  <a href="#pageMyLocation" data-role="button" data-theme="d" data-icon="gear" data-iconpos="notext" data-rel="dialog" data-transition="fade"></a>
	  <a class="transmitButton ui-disabled ui-btn-right ui-btn ui-btn-up-d ui-btn-icon-notext ui-btn-corner-all ui-shadow" data-role="button" data-theme="d" data-icon="check" data-iconpos="notext" title=""><span class="ui-btn-inner ui-btn-corner-all" aria-hidden="true"><span class="ui-btn-text"></span><span class="ui-icon ui-icon-check ui-icon-shadow"></span></span></a>
     
	  <h1  data-theme="a">Election Observer</h1>	  
	</div>
	
	<div data-role="content" style="width:100%; height:100%; padding:0;">

	<h3><center>Welcome to the Election Observation Tool!</center></h3>
	<div style="margin:10px 10px 10px 10px;">
		<div data-role="controlgroup">
		<a href="#infoPage" data-role="button" data-rel="dialog" data-transition="fade" data-theme="d">Learn about Observer</a>
		</div>
		
		<div data-role="controlgroup">
			<a href="#mapPage" data-role="button" data-transition="fade" data-rel="dialog" data-theme="c">View Map of Results</a>
			<a href="#globalResults" data-role="button" data-rel="dialog" data-transition="fade" data-theme="c">View Graph of Results</a>
		</div>	
		
		<div data-role="controlgroup">
		<a href="#page1" data-role="button"  data-transition="fade" data-theme="b">Start Survey</a>
		</div>
	</div>
	</div>
  </div>
  
  <div id="verificationPage" data-role="page">
		<div data-role="header"><h1>Finalize Submission</h1></div>
		<div id="verificationPageContents" data-role="content">
			<h1>Thank You</h1>
			<p>You have completed the survey. To change a response, close this window. To finalize your submission, press Submit.</p>
			<a href="#sharePage" data-role="button" onclick="verifyPage();" data-rel="dialog" data-transition="fade">Submit</a>
		</div>
  </div>
  
  <div id="sharePage" data-role="page">
		<div data-role="header"><h1>Finalize Submission</h1></div>
		<div id="sharePageContents" data-role="content">
			<h1>Share with friends</h1>
			<p>If you would like to share this with your friends, enter their email addresses below:</p>
			
			<textarea id="sharePageTextArea"></textarea>
			<a href="#home" data-role="button" onclick="Home.shareWithFriends();" data-transition="fade">Share</a>
			<a href="#home" data-role="button" data-transition="fade">No Thanks</a>
		</div>
  </div>
  
  	<div id="pageMyLocation" data-role="page">
		<div data-role="header"><h1>Map View</h1></div>
		<div id="pageMyLcationContent" data-role="content"> 
			<div id="map_canvas" style="width:100%; height:100px; text-align:left">
				<!-- map loads here... -->
			</div>
			

			<input type="search" name="findAddress" id="findAddress" value="Enter Address" />

			<div data-role="controlgroup" data-type="horizontal">
				<a data-role="button">Address</a>
				<a data-role="button">Detect</a>
			</div>
			<a data-role="button">Use New Location</a>
			
		</div>
	</div>
  
  
  
  
  <!-- GLOBAL RESULTS -->
  <div id="globalResults" data-role="page">
    <div data-role="header">
	  <h1> Results </h1>
	</div>
	
    <div data-role="content">	
      <div data-role="collapsible-set" id="resultsContent">Loading Results...</div>
    </div>
  	
  </div>

  <!-- MAP PAGE -->
  <div id="mapPage" data-role="page">
    <div data-role="header">
	  <h1> Maps </h1>
	</div>
	
    <div data-role="content">	
      <div data-role="collapsible-set" id="mapPageContent">Loading Results...</div>
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


	<p>Press a button below for more information. Information is shown in the <strong style="color:#3385FF;">blue box</strong> below.</p>
	  
	  
<div style="border:2px solid black;">
	  
	<fieldset class="ui-grid-b ui-bar-a" style="padding:3px 3px 3px 3px;">
		<div class="ui-block-a">
			<a class="descriptionButton" onclick="selectButtonDescription(this,'buttonDescriptionLocationIndicator');" data-role="button" data-theme="d" data-icon="gear" data-iconpos="notext" style="margin-left:8px; margin-right:auto;"></a>
		</div>
		<div class="ui-block-b"><p style="margin-top:10px; margin-bottom:auto; text-align:center; align:center;">Page 1/10</p></div>
		<div class="ui-block-c">
			<a class="descriptionButton" onclick="selectButtonDescription(this,'buttonDescriptionSynchedIndicator');" data-role="button" data-theme="d" data-icon="check" data-iconpos="notext" style="margin-left:auto; margin-right:8px;"></a>
		</div>	   
	</fieldset>


	<img align="left" src="../imgs/PressMeLeft.png" alt="Press Me!"/>
	<img align="right" src="../imgs/PressMeRight.png" alt="Press Me!"/>

	  <br/>
	  <div  style="padding:20px 20px 20px 20px; ">
	  
	  <p>The election observation question will be here.</p>
	  
	  <ul>
		  <li>Your answers are automatically synchronized with our database as you take the survey.</li>
		  <li>Changing your answer will replace your old answer in our database.</li>
		  <li>If you are offline, all answers that have not already been sent to the server will automatically be sent when you are online again.</li>
	  </ul>
	  
	  
	  </div>
	  
	  <img src="../imgs/PressMeDown.png" alt="Press Me!"/>
		<div data-role="navbar" style="background-color:black;">
			<ul>
			<li><a class="descriptionButton" onclick="selectButtonDescription(this,'buttonDescriptionHelp');" data-icon="info" data-role="button" data-theme="a">Help</a></li>			
			<li><a class="descriptionButton" onclick="selectButtonDescription(this,'buttonDescriptionHome');" data-icon="home"  data-role="button" data-theme="a">Home</a></li>
			<li><a class="descriptionButton" onclick="selectButtonDescription(this,'buttonDescriptionRestart');" data-icon="back" data-role="button" data-theme="a">Restart</a></li>
			</ul>
			<ul>
			<li><a class="descriptionButton" onclick="selectButtonDescription(this,'buttonDescriptionBack');" data-role="button" data-icon="arrow-l" data-theme="a"></a></li>
			<li><a class="descriptionButton" id="buttonDescriptionButtonMenu" onclick="selectButtonDescription(this,'buttonDescriptionMenu');" data-role="button" data-icon="grid" data-theme="a"></a></li>
			<li><a class="descriptionButton" onclick="selectButtonDescription(this,'buttonDescriptionNext');" data-role="button" data-icon="arrow-r" data-theme="a"></a></li>		
			</ul>
		</div><!-- /navbar -->			
</div>
	
		<div id="buttonDescriptions" style="border:2px solid #3385FF; padding:0px 10px 0px 10px;">
			<p id="buttonDescriptionLocationIndicator">Shows the currently used location.</p>
			<p id="buttonDescriptionSynchedIndicator">Indicates whether synched with server.</p>
			
			<p id="buttonDescriptionHome">Goes to the home page.</p>
			<p id="buttonDescriptionHelp">Shows this page.</p>
			<p id="buttonDescriptionRestart">Goes to the first page in the survey.</p>
			
					
			<p id="buttonDescriptionBack">Goes to the previous page in the survey. On the Home page, this brings up this How-To page.</p>
			<p id="buttonDescriptionMenu">Opens the menu. Includes the Help, Home, and Restart buttons seen above.</p>
			<p id="buttonDescriptionNext">Goes to the next page in the survey. On the Home page, this starts the survey.</p>
		</div>


</div>
</div>

    <%=QuestionMap.generateSurvey()%>
  
</body>
</html>
