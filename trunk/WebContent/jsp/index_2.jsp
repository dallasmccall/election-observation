<!DOCTYPE html>

<html lang="en">
<head>
  <meta charset="utf-8">
  <link rel="stylesheet" href="../css/jquery.mobile-1.0.css">
  <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1, maximum-scale=1">
  <script src="../js/jquery-1.7.1.min.js" type="text/javascript" charset="utf-8"></script>
  <script src="../js/underscore-min.js" type="text/javascript" charset="utf-8"></script>
  <script src="../js/backbone-min.js" type="text/javascript" charset="utf-8"></script>
  <script src="../js/backbone.localStorage-min.js" type="text/javascript" charset="utf-8"></script>
  <script src="../js/jquery.mobile-1.0.min.js" type="text/javascript" charset="utf-8"></script>
  
  <script type="text/javascript" src="../js/Home.js"></script>
  <script type="text/javascript" src="../js/Request.js"></script>
</head>

<body >
  <!-- HOME PAGE -->
  <div id="home" data-role="page">
    <div data-role="header">
	  <h1> Election Observation Tool  </h1>
	</div>
	
	<div data-role="content">
	  <!--<p>Hey there! Make this election free and fair!
	  Results will be publicly viewable here:</p>
	  <a href="#"> Super Citizen Observer </a>
	  <p>Don't worry! All publicly posted information is anonymous.</p>
	  -->
	  <a href="#newForm" data-role="button" data-icon="plus" data-theme="b">
	  Fill out a new form!
	  </a>
	  
	  <button onclick="Home.getSurvey()">Get Survey...!</button>
	  
	  
	  <ul data-role="listview" data-inset="true">
	    <li> <a href="#myForm"> View My Submission </a> </li>
		<li> <a href="#globalResults"> View Current Results </a> </li>
		<li> <a href="#cloudPoints" data-rel="dialog" data-transition="fade"> Learn about Cloud Points! </a> </li>
	  </ul>	
	</div>
	
	<div data-role="footer"  data-position="fixed" data-id="global-nav-bar">		
		<div data-role="navbar"   >
			<ul>
				<li><a href="#page4" data-role="button" data-icon="arrow-l"  data-transition="slide" data-direction="reverse"></a></li>
				<li><a href="#menu" data-role="button" data-icon="grid" data-rel="dialog" data-transition="fade"></a></li>
				<li><a href="#newForm" data-role="button" data-icon="arrow-r"  data-transition="slide" data-direction="forward" ></a></li>
			</ul>
		</div><!-- /navbar -->
	</div><!-- /footer -->
  </div>
  
  
  <!-- FORM PAGE -->
  <div id="newForm" data-role="page">
    <div data-role="header" data-position="fixed" >
	  <h1> Form (1/4) </h1>	  

	</div>
	
	<div data-role="content">
	  <fieldset data-role="controlgroup">
		<legend>How long did it take to complete the voting?</legend>
     	<input type="radio" name="radio-choice-1" id="radio-choice-1" value="choice-1" checked="checked" />
     	<label for="radio-choice-1">0-10 Minutes</label>

     	<input type="radio" name="radio-choice-1" id="radio-choice-2" value="choice-2"  />
     	<label for="radio-choice-2">10-20 Minutes</label>

     	<input type="radio" name="radio-choice-1" id="radio-choice-3" value="choice-3"  />
     	<label for="radio-choice-3">20-30 Minutes</label>

     	<input type="radio" name="radio-choice-1" id="radio-choice-4" value="choice-4"  />
     	<label for="radio-choice-4">30 Minutes - 1 Hour</label>
		
		<input type="radio" name="radio-choice-1" id="radio-choice-5" value="choice-5"  />
     	<label for="radio-choice-5">1 - 2 Hours</label>
		
		<input type="radio" name="radio-choice-1" id="radio-choice-6" value="choice-6"  />
     	<label for="radio-choice-6">2 - 4 Hours</label>

	  </fieldset>


		
	</div>
	
	
	<div data-role="footer"  data-position="fixed" data-id="global-nav-bar">	
		<div data-role="navbar" data-position="fixed">
			<ul>
				<li><a href="#home" data-role="button" data-icon="arrow-l"  data-transition="slide" data-direction="reverse"></a></li>
				<li><a href="#menu" data-role="button" data-icon="grid" data-rel="dialog" data-transition="fade"></a></li>
				<li><a href="#page2" data-role="button" data-icon="arrow-r"  data-transition="slide" data-direction="forward"   ></a></li>
			</ul>
		</div><!-- /navbar -->
	</div><!-- /footer -->
	
	
  </div>
  
  <div id="page2" data-role="page">
    <div data-role="header">
	  <h1> Form (2/4) </h1>
	</div>
	
	<div data-role="content">
		<fieldset data-role="controlgroup">
		<legend>Were you intimidated or coerced?</legend>
     	<input type="radio" name="radio-choice-1" id="radio-choice-1" value="choice-1" checked="checked" />
     	<label for="radio-choice-1">Yes</label>

     	<input type="radio" name="radio-choice-1" id="radio-choice-2" value="choice-2"  />
     	<label for="radio-choice-2">No</label>
		</fieldset>

	</div>
	
	
		<div data-role="footer"  data-position="fixed" data-id="global-nav-bar">		
		<div data-role="navbar">
			<ul>
				<li><a href="#newForm" data-role="button" data-icon="arrow-l"  data-transition="slide" data-direction="reverse"></a></li>
				<li><a href="#menu" data-role="button" data-icon="grid" data-rel="dialog" data-transition="fade"></a></li>
				<li><a href="#page3" data-role="button" data-icon="arrow-r"  data-transition="slide" data-direction="forward"   ></a></li>
			</ul>
		</div><!-- /navbar -->
	</div><!-- /footer -->
  </div>
  
  <div id="page3" data-role="page">
    <div data-role="header">
	  <h1> Form (3/4) </h1>
	</div>
	
	<div data-role="content">
	
		<fieldset data-role="controlgroup">
			<legend>Which of the following statements (if any) apply to your voting experience?</legend>
			<input type="checkbox" name="checkbox-1" id="checkbox-1" class="custom" />
			<label for="checkbox-1">I considered my voting experience to be good overall.</label>

			<input type="checkbox" name="checkbox-2" id="checkbox-2" class="custom" />
			<label for="checkbox-2">I felt that election officials were helpful.</label>
			
			<input type="checkbox" name="checkbox-3" id="checkbox-3" class="custom" />
			<label for="checkbox-3">I was able to successfully cast my ballot and vote for my official of choice</label>
			
			<input type="checkbox" name="checkbox-4" id="checkbox-4" class="custom" />
			<label for="checkbox-4">I believe that my vote will be counted.</label>
		
		</fieldset>		

	</div>	
	
		<div data-role="footer"  data-position="fixed" data-id="global-nav-bar">		
		<div data-role="navbar">
			<ul>
				<li><a href="#page2" data-role="button" data-icon="arrow-l"  data-transition="slide" data-direction="reverse"></a></li>
				<li><a href="#menu" data-role="button" data-icon="grid" data-rel="dialog" data-transition="fade"></a></li>
				<li><a href="#page4" data-role="button" data-icon="arrow-r"  data-transition="slide" data-direction="forward"   ></a></li>
			</ul>
		</div><!-- /navbar -->
	</div><!-- /footer -->
  </div>
  
  <div id="page4" data-role="page">
    <div data-role="header">
	  <h1> Form (4/4) </h1>
	</div>
	<div data-role="content">
	<label for="textarea-a">Do you have any final thoughts about your voting experience? </label>
	<textarea name="textarea-a" id="textarea-a"></textarea>

	</div>
	
		<div data-role="footer"  data-position="fixed" data-id="global-nav-bar">		
		<div data-role="navbar"  >
			<ul>
				<li><a href="#page3" data-role="button" data-icon="arrow-l"  data-transition="slide" data-direction="reverse"></a></li>
				<li><a href="#menu" data-role="button" data-icon="grid" data-rel="dialog" data-transition="fade"></a></li>
				<li><a href="#home" data-role="button" data-icon="arrow-r"  data-transition="slide" data-direction="forward"></a></li>
			</ul>
		</div><!-- /navbar -->
	</div><!-- /footer -->
  </div>
  

    <!-- CLOUD POINTS fadeUP -->
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
  
</body>
</html>
