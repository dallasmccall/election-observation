<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE HTML>
<html manifest="questions.appcache">
<head>

    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    
    <link rel="stylesheet" href="/ElectionObservationServer/jsp/mystyle.css" type="text/css">
    
    <script type="text/javascript" src="/ElectionObservationServer/js/Home.js">
    </script>
    <script type="text/javascript" src="/ElectionObservationServer/js/Request.js">
    </script>
    
    <script type="text/javascript">

    
    ////////////////////////////////////////        
    // Initialization
    ////////////////////////////////////////
    function doOnLoad(form){
        
        // Create getElementsByClassName method if necessary
        if (document.getElementsByClassName == undefined) {
            document.getElementsByClassName = function(className){
                    var hasClassName = new RegExp("(?:^|\\s)" + className + "(?:$|\\s)");
                    var allElements = document.getElementsByTagName("*");
                    var results = [];
    
                    var element;
                    for (var i = 0; (element = allElements[i]) != null; i++) {
                        var elementClass = element.className;
                        if (elementClass && elementClass.indexOf(className) != -1 && hasClassName.test(elementClass))
                            results.push(element);
                    }
    
                    return results;
                };
            }
                
            // Find all of the "pages" in the form
            findallPages();
    
            // Set the current page to 0, update the page progress accordingly
            curPage = 0;
            showPage(allPages[curPage]);
            updateProgress();
        }
        
        function closeEditorWarning(){
            // Needs to be updated to check to see whethe the form has been filled out and submited
            return 'It looks like you have been editing something -- if you leave before submitting your changes will be lost.';
        }
        window.onbeforeunload = closeEditorWarning;
        
        
        function handleKeyPress(e,form)
        {
            var key = e.keyCode || e.which;
            if (key==13){
                Home.putElement();
            }
        }        

        
        ////////////////////////////////////////        
        // Page Navigation
        ////////////////////////////////////////
        var curPage;
        var allPages = [];
        function findallPages(){
            allPages = [];                        
            var allPageElements = getSubElementsByClassName(document,"page"); 
            var len = allPageElements.length;
            for(var i=0; i<len; i++) {
                allPages[i] = allPageElements[i].id;
            }
        }
                        
        function gotoPage(curPg, nextPg) {
           hidePage(curPg);
           showPage(nextPg);
        }

        function hidePage(pg) {
           document.getElementById(pg).
              style.visibility = 'hidden';     
        }
        function showPage(pg) {
           document.getElementById(pg).
              style.visibility = 'visible';     
        }
        function togglePage(pg) {
            var visibility = document.getElementById(pg).style.visibility;
            if(visibility == 'hidden'){
                showPage(pg);
            }else{
                hidePage(pg);
            }    
        }

     function updateProgress(){
            var progText = (curPage+1).toString(10).concat("/").concat(allPages.length.toString(10));
            document.getElementById("meter-text").textContent = progText;
            
            var progPerc =  (99.7*((curPage+1)/allPages.length)).toString(10).concat("%");
            document.getElementById("meter-value").style.width = progPerc;
            
            if(curPage == allPages.length-1){
                document.getElementById("C").textContent = "Submit";
            }else{
                document.getElementById("C").textContent = "Next";
            }
            
            if(curPage == 0){
                document.getElementById("H").textContent = "Home";
                document.getElementById("H").onClick = "goHome()";
            }else{
                document.getElementById("H").textContent = "Prev";
            }            
        }
         
     
	     function goHome(){
	         	window.location = "index.jsp";
	     }
        function prevPage(){
            if(curPage < (allPages.length-1)){                
                gotoPage(allPages[curPage], allPages[curPage+1]);
                curPage = curPage+1;
                updateProgress();
            }else if(curPage == allPages.length-1){
                submitFormWrapper();
            }
        }
        
        function nextPage(){
            if(curPage > 0){
                gotoPage(allPages[curPage], allPages[curPage-1]);
                curPage = curPage-1;
                updateProgress();
            }else if(curPage == 0){
                window.location = "index.jsp";
            }
        }         
            
        

        function getSubElementsByClassName(element, className){

           var hasClassName = new RegExp("(?:^|\\s)" + className + "(?:$|\\s)");
           var allElements = element.getElementsByTagName("*");
           var results = [];

           var element;
           for (var i = 0; (element = allElements[i]) != null; i++) {
               var elementClass = element.className;
               if (elementClass && elementClass.indexOf(className) != -1 && hasClassName.test(elementClass))
                   results.push(element);
           }

           return results;
       }
        
        
        
        ////////////////////////////////////////        
        // Submit Values
        ////////////////////////////////////////
        var timerCheckServer = null;       
        function submitFormWrapper(){

               ifServerOnline(
               function() 
               {    
                    //  server online code here            
                   submitForm();
               },
               
               function () 
               {
                    //  server offline code here        
                   alert("You are offline, will try again in 5s.");        
                   timerCheckServer = setInterval("submitForm()",5000);
               },1000);
               
               
        }
        
        function submitForm() {
           ifServerOnline(function()
           {
                //  server online code here
               if(timerCheckServer != null){                   
                   clearInterval(timerCheckServer);
               }
                
               var allAnswers = getSubElementsByClassName(document,"answer");               
               
               var values = '';
               var len = allAnswers.length;
               for(var i=0; i<len; i++) {
                     values += (allAnswers[i].id).toString();
                     values += ': ';
                     values += (allAnswers[i].value).toString();
                     values += '\n';                     
                     //Home.submitElement(form[i]);
                  }
                 alert(values);    
               
           },
           function ()
           {            
               alert("Still Offline..!");
           },1000);
           

        }
        
        ////////////////////////////////////////        
        // Clear Values
        ////////////////////////////////////////
        
        function clearValuesOnPage(pgId){
        	var pg = document.getElementById(pgId);
        	var answersToClear = getSubElementsByClassName(pg,"answer");
        	var len = answersToClear.length;
        	for(var i=0;i<len;i++){
        		clearValue(answersToClear[i]);
        	}
        }
        
        function clearValue(elem){
        	elem.value = "";
        }
        
        ////////////////////////////////////////        
        // Check Server Status
        ////////////////////////////////////////
        var timerTimeout;
        function ifServerOnline(ifOnline, ifOffline, timeout)
        {        
        	// Create function to execute on timeout
            doOnTimeout = function(){                
                removeAllPingImgs();
                ifOffline && ifOffline.constructor == Function && ifOffline();
            };
            
            // Set the timeout function (needed in case the "onerror" event is never triggered)
            timerTimeout = setTimeout(doOnTimeout,timeout);
            
            // Create a hidden image            
            var img = document.body.appendChild(document.createElement("img"));
            img.id = "PingImage";            
            img.style.display = "none";
            img.style.visibility = "hidden";
            
            // The src is on the server
            img.src = "http://localhost:9001/ElectionObservationServer/jsp/ping.bmp?" + (new Date()).getTime();
            		
            // The "onload" event will trigger if the image is succesfully loaded from our server
            img.onload = function()
            {
                if(timerTimeout!=null){
                    clearTimeout(timerTimeout);
                }
                removeAllPingImgs();
                ifOnline && ifOnline.constructor == Function && ifOnline();
            };
            
            // The "onerror" event will trigger if it fails to load (on most browsers)
            img.onerror = function()
            {
                if(timerTimeout!=null){
                    clearTimeout(timerTimeout);
                }
                removeAllPingImgs();
                ifOffline && ifOffline.constructor == Function && ifOffline();
            };

    }

    function removeAllPingImgs(){
        // Remove all Ping images (even though they are hidden we don't want them trashing up the html)
        var elem = null;
        do{
            elem=document.getElementById("PingImage");
            if(elem != null){
                elem.parentNode.removeChild(elem);
            }
        }while(elem!=null);
    }
        
    </script>
    
    <meta name = "viewport" content = "width = device-width, user-scalable = no"> 
    
    <title>Observation Question</title>
</head>

<body onload="doOnLoad(this.form)">

  

    <div class="meter-wrap">                
        <div></div>                        
    </div>
    <div id="meter-value" class="meter-value" id="meter-value">
        <div></div>
    </div>
    <div class="meter-text" id="meter-text"> 1/N </div>


<form id="multiForm" method="POST" 
   action="javascript:void(0)" 
   onSubmit="submitFormWrapper(this)">
    

<div id="page1" class="page">       
    <p class="questions">Question 1 <input type="text" id="T1" size="20" class="answer"></p>    
    <p class="questions">Question 2 <input type="text" id="T2" size="20" class="answer"></p>
    <p class="questions">Question 3 <input type="text" id="T3" size="20" class="answer"></p>
    <p class="questions">Question 4 <input type="text" id="T4" size="20" class="answer"></p>
    <p class="questions">Question 5 <input type="text" id="T5" size="20" class="answer"></p>      
</div>

<div id="page2" class="page">    
    <p class="questions">Question 6 <input type="text" id="T6" size="20" class="answer"></p>    
    <p class="questions">Question 7 <input type="text" id="T7" size="20" class="answer"></p>
    <p class="questions">Question 8 <input type="text" id="T8" size="20" class="answer"></p>
    <p class="questions">Question 9 <input type="text" id="T9" size="20" class="answer"></p>
    <p class="questions">Question 10 <input type="text" id="T10" size="20" class="answer"></p>  
</div>
              
<div id="page3" class="page"> 
    <p class="questions">
        Username: <input type="text" id="U" size="20" class="answer">
    </p>   
</div>

<div id="page4" class="page">    
    <p class="questions">Question 11 <input type="text" id="T11" size="20" class="answer"></p>    
    <p class="questions">Question 12 <input type="text" id="T12" size="20" class="answer"></p>
    <p class="questions">Question 13 <input type="text" id="T13" size="20" class="answer"></p>
    <p class="questions">Question 14 <input type="text" id="T14" size="20" class="answer"></p>
    <p class="questions">Question 15 <input type="text" id="T15" size="20" class="answer"></p>  
</div>


<div id="page5" class="page">    
  <p>This is a dummy page.</p>
</div>

<div id="submitedpage" class="submited">
  <p>You have completed the survey. The results will be automatically submitted the next time your phone is connected to the Internet. </p>
</div>


</form>


<div class="menu" id="mainmenu" style=    "visibility:hidden;">
    <p class="buttons">
        <button type="button" class="menuItemButton" onClick="clearValuesOnPage(allPages[curPage])" >
            Clear
        </button>   
        <button type="button" class="menuItemButton" onClick="goHome()" >
            Home
        </button> 
        <button type="button" class="menuItemButton" name="continue" onClick="alert('TODO: This will make you go to the Acct page!')">
            Acct
        </button>
    </p>
    <p class="buttons">
        <button type="button" class="menuItemButton" onClick="alert('TODO: This will make you go to the About page!')">
            About
        </button>   
        <button type="button" class="menuItemButton" onClick="alert('TODO: This will make you go to the Cloud page!')" >
            Cloud
        </button> 
        <button type="button" class="menuItemButton" onClick="alert('TODO: This will make you logout!')">
            Logout
        </button>
    </p>

</div>

<div class="navbuttons">
    <p class="buttons">
        <button type="button" class="prevButton" onClick="nextPage()" id="H">
            Prev
        </button>   
        <button type="button" class="mainMenuButton" onClick="togglePage('mainmenu')" id="MainMenuButton">
            Menu
        </button> 
        <button type="button" class="nextButton" onClick="prevPage()" id="C">
            Next
        </button>
    </p>
</div>









</body>
</html>