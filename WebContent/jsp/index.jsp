<html>
<head>
	<%@ page import="backend.*" %>

	<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta charset="utf-8"></meta>
	<link rel="stylesheet" href="../css/jquery.mobile-1.0.css"></link>
	<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1, maximum-scale=1"></meta>
	<script src="../js/jquery-1.7.1.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="../js/underscore-min.js" type="text/javascript" charset="utf-8"></script>
	<script src="../js/backbone-min.js" type="text/javascript" charset="utf-8"></script>
	<script src="../js/backbone.localStorage-min.js" type="text/javascript" charset="utf-8"></script>
	<script src="../js/jquery.mobile-1.0.min.js" type="text/javascript" charset="utf-8"></script>

	<script type="text/javascript" src="../js/Home.js"></script>
	<script type="text/javascript" src="../js/Request.js"></script>

	<title>Election Observation Tool</title>
  
 
</head>
<body>



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
		<li> <a href="#globalResults"> View Current Results </a> </li>
		<li> <a href="#cloudPoints" data-rel="dialog" data-transition="fade"> Learn about Cloud Points! </a> </li>
	  </ul>	
	</div>
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
  
  
    <!-- MENU fadeUP -->
  <div id="menu" data-role="page" data-theme="b">
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
  
  <%
  	String xslPath ="/Users/dallas/Documents/workspace/ElectionObservation/src/backend/survey.xsl";
	String xmlPath ="/Users/dallas/Documents/workspace/ElectionObservation/src/backend/survey.xml";
  %>
  
  <%=SurveyTransformer.transform(xslPath, xmlPath)%>
  
</body>
</html>
