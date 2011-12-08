
function Home ()
{
	return false;
}

var responseCache = new Array();

Home.initializeIndex = function()
{
	var responseCacheJSON = localStorage.getItem("ElectionObservationResponseCache");
	
	
	if (responseCacheJSON != null)
	{
		responseCache = eval(responseCacheJSON);
		for (var idx = 0; idx < responseCache.length; idx++)
		{
			var elem = document.getElementById(responseCache[idx][1]);
			
			var name = "#" + responseCache[idx][1];
			
			if (responseCache[idx][2] === "radio")
			{
				elem.checked = true;
				try
				{
					$(name).prop("checked",true).checkboxradio("refresh");
				}
				catch (err){}
				
			}
			else if (responseCache[idx][2] === "checkbox")
			{
				if (responseCache[idx][3] === "true")
				{
					elem.checked = true;
					try
					{
						$(name).prop("checked",true).checkboxradio("refresh");
					}
					catch (err){}
				}
			}
			else
			{
				elem.value = responseCache[idx][3];
			}
		}
	}
	
	Home.attemptResultsTransmission();
	return false;
};

Home.addResponseToCache = function(name, id, type, response)
{
	for (var idx = 0; idx < responseCache.length; idx++)
	{
		if (responseCache[idx][0] === name)
		{
			responseCache[idx][1] = id;
			responseCache[idx][2] = type;
			responseCache[idx][3] = response;
			
			localStorage.setItem("ElectionObservationResponseCache", JSON.stringify(responseCache));
			return false;
		}
	}
	var elem = [name, id, type, response];
	responseCache.push(elem);
	
	localStorage.setItem("ElectionObservationResponseCache", JSON.stringify(responseCache));
	return false;
};

Home.attemptResultsTransmission = function()
{
	function transmit() 
	{
		var formCache = localStorage.getItem("ElectionObservationSendCache");
		var sessionID = localStorage.getItem("sessionID");
		
		if (null !== formCache && "" !== formCache)
		{
			var url = "../servlet/Home?" + "userResponse=" + sessionID + formCache;
			Request.sendRequest(url, Home.handleTransmitResponse);
		}
		
        setTimeout(transmit, 5000);
    }
    transmit();
    return false;
};

Home.loadResultsList = function()
{
	var url = "../servlet/Home?" + "type=getShortQuestions";
	
	var onResponse = Home.handleLoadResultsList;
	Request.sendRequest(url, onResponse);
	
	return false;
};


Home.putElement = function()
{	
	var question = document.getElementById("questionTitle").innerHTML;
	var item = document.getElementById("SimpleTextArea");
	var url = "../servlet/Home?" + "type=put" + "&question=" + question + "&response=" + item.value;
	
	var onResponse = Home.handlePutResponse;
	Request.sendRequest(url, onResponse);
	
	return false;
};


Home.submitElement = function(item)
{	
	var question = item.innerHTML;
	var url = "../servlet/Home?" + "type=put" + "&question=" + question + "&response=" + item.value;

	
	var onResponse = Home.handlePutResponse;
	Request.sendRequest(url, onResponse);
	
	return false;
};

Home.loadResult = function(item)
{
	var url = "../servlet/Home?" + "type=loadResult" + "&item=" + item.target.id;
	
	var onResponse = Home.handleLoadedResult;
	Request.sendRequest(url, onResponse);
	
};

Home.handleFormChange = function(item)
{
	var formCache = localStorage.getItem("ElectionObservationSendCache");
	if (null === formCache)
	{
		formCache = "";
	}
	
	if ("radio" === item.type)
	{
		formCache += "&" + item.getAttribute("caption") + "=" + item.getAttribute("choice");
		Home.addResponseToCache(item.name, item.id, "radio", item.getAttribute("choice"));
	}
	else if ("checkbox" === item.type)
	{
		formCache += "&" + item.getAttribute("caption") + ":" + item.getAttribute("choice") + "=";
		if (true === item.checked)
		{
			formCache += "true";
			Home.addResponseToCache(item.id, item.id, "checkbox", "true");
		}
		else
		{
			Home.addResponseToCache(item.id, item.id, "checkbox", "false");
			formCache += "false";
		}
	}
	else
	{
		formCache += "&" + item.getAttribute("caption") + "=" + item.value;
		Home.addResponseToCache(item.name, item.id, "textbox", item.value);
	}

	$(".transmitButton span.ui-icon").addClass("ui-icon-alert").removeClass("ui-icon-check");
	localStorage.setItem("ElectionObservationSendCache", formCache);
	return true;
};


Home.handlePutResponse = function(response)
{
	if (response.status != 200)
	{
		alert("ERROR: Failed to put item");
		return false;
	}
};

Home.handleTransmitResponse = function(response)
{
	if (response.status != 200)
	{
		return false;
	}
	else
	{

		$(".transmitButton span.ui-icon").addClass("ui-icon-check").removeClass("ui-icon-alert");
		localStorage.setItem("ElectionObservationSendCache", "");
	}
};

Home.getElement = function()
{
	var item = document.getElementById("SimpleTextArea");
	var url = "../servlet/Home?" + "type=get" + "&item=" + item.value;
	
	var onResponse = Home.handleGetResponse;
	Request.sendRequest(url, onResponse);
	
	return false;
};

Home.getQuestion = function()
{
	var url = "../servlet/Home?" + "type=get" + "&question=true";
	
	var onResponse = Home.handleGetQuestionResponse;
	Request.sendRequest(url, onResponse);
	
	return false;
};

Home.handleGetResponse = function(response)
{
	if (response.status != 200)
	{
		alert("ERROR: Failed to get item");
		return false;
	}
	
	var results = eval(response.responseText);
	
	var alertMessage = "RESULTS: ";
	
	for (var idx = 0; idx < results.queryResults.length; idx++)
	{
		alertMessage += results.queryResults[idx].item + " ";
	}
	alert(alertMessage);
	return false;
};

Home.handleLoadedResult = function(response)
{
	if (response.status != 200)
	{
		alert("ERROR: Failed to get item");
		return false;
	}
	
	var results = eval(response.responseText);

	var question = results.question.split(' ').join('') + "globalResponse";
	
    var defualtColors = ["#0DA068", "#194E9C", "#ED9C13", "#ED5713", "#057249", "#5F91DC"];
    
    var root = document.getElementById(question);
    
    root.innerHTML = "";
    
    if (results.type !== "text")
    {
    	var rc = document.getElementById("resultsContent");
    	var crt = document.createElement('canvas');
        crt.id = results.question + "chart";
        crt.width = rc.clientWidth;
    	crt.height = rc.clientWidth;
        
        var tab = document.createElement('table');
        
        tab.style.width = "100%";
        tab.id = results.question + "chartData";
        var tbo = document.createElement('tbody');
        
        var thd = document.createElement('thead');
        
        var headerRow = document.createElement('tr');
        
        var leftHeader = document.createElement('th');
        var rightHeader = document.createElement('th');
        
        leftHeader.appendChild(document.createTextNode(results.leftHeader));
        rightHeader.appendChild(document.createTextNode(results.rightHeader));
        
        headerRow.appendChild(leftHeader);
        headerRow.appendChild(rightHeader);
        
        thd.appendChild(headerRow);
        tab.appendChild(thd);
        

        var listview = document.createElement('ul');
        listview.setAttribute("data-role", "listview");
        listview.setAttribute("data-inset", "true");
        listview.setAttribute("class", "ui-listview ui-listview-inset ui-corner-all ui-shadow");
        
        var dividerHeader = document.createElement('li');
        dividerHeader.setAttribute("data-role", "list-divider");
        dividerHeader.setAttribute("role", "heading");
        dividerHeader.setAttribute("class", "ui-li ui-li-divider ui-btn ui-bar-d ui-li-has-count ui-corner-top ui-btn-hover-undefined ui-btn-up-undefined");
        dividerHeader.appendChild(document.createTextNode(results.leftHeader));
         
        
        var isMap = false;
        
        if (results.statistics.length > 0 && results.statistics[0].count === "-1")
        {
        	isMap = true;
        }
        
        if (!isMap)
        {
        	var dividerRight = document.createElement('span');
            dividerRight.setAttribute("class", "ui-li-count ui-btn-up-c ui-btn-corner-all");
            dividerRight.appendChild(document.createTextNode(results.rightHeader));
            dividerHeader.appendChild(dividerRight);  
        }
          
        listview.appendChild(dividerHeader);
        
        
        
        var buttons = [];
        for(var idx = 0; idx < results.statistics.length; idx++)
        {
        	var rowColor = defualtColors[idx % defualtColors.length];
        	
        	var row = document.createElement('tr');
        	row.style.color = rowColor;
        	
        	var leftCell = document.createElement('td');
        	var rightCell = document.createElement('td');
        	
        	leftCell.appendChild(document.createTextNode(results.statistics[idx].item));
        	rightCell.appendChild(document.createTextNode(results.statistics[idx].count));
        	
        	row.appendChild(leftCell);
        	row.appendChild(rightCell);
        	
        	tbo.appendChild(row);
        
        	
        	
        	var liItem = document.createElement('li');
        	liItem.setAttribute("data-theme", "c");
        	liItem.setAttribute("class", "ui-btn ui-btn-icon-right ui-li-has-arrow ui-li ui-li-has-count ui-btn-up-c");
        	var divItem1 = document.createElement('div');
        	divItem1.setAttribute("aria-hidden", "true");
        	divItem1.setAttribute("class", "ui-btn-inner ui-li");    	
        	var divItem2 = document.createElement('div');
        	divItem2.setAttribute("class", "ui-btn-text");    
        	var aItem = document.createElement('a');
        	aItem.style.color = rowColor;
        	aItem.setAttribute("class", "ui-link-inherit");
        	aItem.setAttribute("data-slice", idx);
        	aItem.setAttribute("onclick", "toggleSlice(" + idx +");");
        	var spanItem1 = document.createElement('span');
        	spanItem1.setAttribute("class", "ui-li-count ui-btn-up-c ui-btn-corner-all");
        	var spanItem2 = document.createElement('span');
        	spanItem2.setAttribute("class", "ui-icon ui-icon-arrow-r ui-icon-shadow");
        	
        	
        	liItem.appendChild(divItem1);
        	divItem1.appendChild(divItem2);
        	divItem2.appendChild(aItem);
        	aItem.appendChild(document.createTextNode(results.statistics[idx].item));
        	
        	if (!isMap)
        	{
        		aItem.appendChild(spanItem1);
        		spanItem1.appendChild(document.createTextNode(results.statistics[idx].count));
        	}
        	else
        	{
        		aItem.setAttribute("onclick", "Home.loadMap('" + results.question + "', '" + results.statistics[idx].item + "');");
        		aItem.setAttribute("href", "#" + results.question + "MapPage");
        		aItem.setAttribute("data-rel", "dialog");
        		aItem.setAttribute("data-transition", "fade");
        	}
        	divItem1.appendChild(spanItem2);

        	
        	listview.appendChild(liItem);
        	
        	buttons[idx] = aItem;
        	
        	
        }
        
        // HACK: didn't feel like changing all the chartMaker.js code so I just
        // hide the table. (Currently, chartMaker.js builds the based on the 
        // table--but the table is no longer necessary because now we have nicely 
        // formated clickable ones now).
        tab.style.display = "none";
        
        tab.appendChild(tbo);
        if (!isMap)
        {
        	root.appendChild(crt);
            root.appendChild(tab);
            pieChart( results.question + "chart", results.question + "chartData", buttons);
        }
        
        root.appendChild(listview);
    }
    else
    {
    	var listId = results.question + "TextList";
    	var topList = document.createElement('ul');
    	topList.setAttribute("id", listId);
    	topList.setAttribute("data-role", "listview");
    	topList.setAttribute("data-inset", "true");
    	//topList.setAttribute("class", "ui-listview ui-listview-inset ui-corner-all ui-shadow");
    	
    	for(var idx = 0; idx < results.statistics.length; idx++)
    	{
    		
    		var textEntry = results.statistics[idx].item;
    		var responsePageName = idx + "Response";
    		var textLi = document.createElement('li');
    		var countBubble = document.createElement('span');
    		var resultLink = document.createElement('a');
    		var resultText = document.createElement('p');
    		
    		resultText.appendChild(document.createTextNode(textEntry));
    		
    		resultLink.setAttribute("href", "#" + responsePageName);
    		resultLink.setAttribute("data-rel", "dialog");
    		resultLink.setAttribute("data-role", "button");
    		resultLink.setAttribute("data-transition", "fade");
    		resultLink.setAttribute("onclick", "Home.loadCommentsForPageDirect('" + textEntry + "')");
    		resultLink.appendChild(resultText);
    		
    		topList.setAttribute("data-theme", "c");
    		countBubble.setAttribute("class", "ui-li-count");
    		countBubble.appendChild(document.createTextNode(results.statistics[idx].count));
    		textLi.appendChild(resultLink);
    		textLi.appendChild(countBubble);
    		topList.appendChild(textLi);
    		
    		//var responsePage = document.createElement('div');
    		//responsePage.setAttribute("data-role", "page");
    		//responsePage.setAttribute("id", responsePageName);
    		
    		//var responsePageContent = document.createElement('div');
    		
    		var doesPageExist = false;
    		
    		if (document.getElementById(responsePageName) != null)
    		{
    			doesPageExist = true;
    		}
    		
    		
    		if (!doesPageExist)
    		{
    			var responsePage = $("<div data-role=page id=" + responsePageName + " targetQuestion='" + textEntry + "'><div data-role=header><h1>Respond</h1></div><div data-role=content id=" + responsePageName +"Content>Page Content</div></div");
    			responsePage.appendTo($.mobile.pageContainer);
    			
        		
        		var responsePageContent = document.getElementById(responsePageName + "Content");
        		
        		responsePageContent.innerHTML = "<strong>Original Comment:</strong>";
        		
        		responsePageContent.innerHTML += "<p>" + textEntry + "<br><br><strong>Top Responses:</strong></p>";
        		responsePageContent.innerHTML += "<p style='padding-left:10%;' id='" + textEntry + "CommentsArea'></p>";
        		responsePageContent.innerHTML +="<br><strong>Give a Reply:</strong>";
        		responsePageContent.innerHTML += "<textarea id='" + textEntry + "TextArea'></textarea>";
        		responsePageContent.innerHTML += "<a href='#' data-rel='back' onclick='Home.submitQuestionComment(this);' id='" + textEntry + "' data-role='button'>Reply</a>";

    		}
    	}
    	
    	root.appendChild(topList);
    	
    	$("#" + listId).listview();
    	$("#" + listId).listview("refresh");
    }
};

Home.loadMap = function(mapName, value)
{
	var url = "../servlet/Home?" + "type=loadMap" + "&map=" + mapName + "&value=" + value;
	
	var onResponse = Home.handleLoadMap;
	Request.sendRequest(url, onResponse);
	
	var mapPageId = mapName + "MapPage";
	
	
	var doesPageExist = false;
	
	if (document.getElementById(mapPageId) != null)
	{
		doesPageExist = true;
	}
	
	
	if (!doesPageExist)
	{
		var mapPage = $("<div data-role=page id=" + mapPageId + "><div data-role=header><h1>Response Locations</h1></div><div data-role=content><div id=" + mapPageId + "Content></div></div></div");
		mapPage.appendTo($.mobile.pageContainer);
		
		
		var mapPageContent = document.getElementById(mapPageId + "Content");
		
		mapPageContent.innerHTML = "<strong>Load Map</strong>";

	}
};

Home.shareWithFriends = function()
{
	var elementValue = document.getElementById("sharePageTextArea").value;
	
	var url = "../servlet/Home?" + "type=shareLink" + "&friends=" + elementValue;
	
	var onResponse = Home.handlePutResponse;
	Request.sendRequest(url, onResponse);
};

Home.handleLoadMap = function(response)
{
	if (response.status != 200)
	{
		alert("ERROR: Failed to get item");
		return false;
	}
	
	var results = eval(response.responseText);
	
	var position = localStorage.getItem("ElectionObservationLocation");
	if (null != position)
	{
		var coords = position.split(", ");
		
	    Home.addMapWithPins(results.map + "MapsMapPageContent", results.locations, coords[0], coords[1]);
	}
	else
	{
		Home.addMapWithPins(results.map + "MapsMapPageContent", results.locations, 33.7784626, -84.3988806);
	}
	
};

Home.addMapWithPins = function (divID, locations, lat, lng) {
	var latlng = new google.maps.LatLng(lat, lng);
	var myOptions = {
		zoom: 10,
		center: latlng,
		mapTypeId: google.maps.MapTypeId.ROADMAP
    };
	
	
	$("#" + divID).height($(document).height() * .7);
    map = new google.maps.Map(document.getElementById(divID),myOptions);
    
    
    for (var idx = 0; idx < locations.length; idx++)
    {
    	latlng = new google.maps.LatLng(locations[idx].lat, locations[idx].lng);
    	var marker = new google.maps.Marker({
            position: latlng,
            map: map,
            title:"Responses so far"
        });
    }
 
};


Home.shareWithFriends = function()
{
	var elementValue = document.getElementById("sharePageTextArea").value;
	
	var url = "../servlet/Home?" + "type=shareLink" + "&friends=" + elementValue;
	
	var onResponse = Home.handlePutResponse;
	Request.sendRequest(url, onResponse);
};



Home.startSurvey = function()
{

	var sessionIDJSON = localStorage.getItem("sessionID");
	
	
	if (sessionIDJSON != null)
	{
		
		$.mobile.changePage("#page1");

		
	}else{

		localStorage.setItem("sessionID", "<%=UUID.randomUUID().toString()%>");
		
		$.mobile.changePage( "#mapCurrentLocationSettings", { transition: "fade"} );
		
		
		$("#applyNewUserLocation").attr("href", "#page1");
		$("#applyNewUserLocation").removeAttr("data-rel");
		
		$("#startSurveyButton .ui-btn-text").text("Continue Survey");
	}
};


Home.loadUserLocationMap = function()
{

	var mapPageContent = "mapCurrentLocation";
	mapPageContent.innerHTML = "<strong>Loading Map...</strong>";

	var position = localStorage.getItem("ElectionObservationLocation");


		if (null != position)
		{
			if("" != position){
				var coords = position.split(", ");
			
		    	Home.addMapWithPin("mapCurrentLocation", coords[0], coords[1]);
			}else{
				Home.addMapWithPin("mapCurrentLocation", 33.7784626, -84.3988806);
			}
		}
		else
		{
			Home.addMapWithPin("mapCurrentLocation", 33.7784626, -84.3988806);
		}

};

Home.addMapWithPin = function (divID, lat, lng) {
	var latlng = new google.maps.LatLng(lat, lng);
	var myOptions = {
		zoom: 14,
		center: latlng,
		mapTypeId: google.maps.MapTypeId.ROADMAP
    };
	
	$("#" + divID).height($(document).height() * .5);
	$("#" + divID).addClass("hasMap");
    map = new google.maps.Map(document.getElementById(divID),myOptions);


	var latlng = new google.maps.LatLng(lat, lng);
	var marker = new google.maps.Marker({
        position: latlng,
        map: map,
        title:"Your Location",
    	draggable: true
    });
	
	
	
	$("#applyNewUserLocation").bind("click", marker, function(event) {

		var marker = event.data;
		var position = marker.getPosition();
		
	    var message = position.lat() + ", " + position.lng();

		updateLocationMessage(message);


	});
	
	
	$("#searchAddressLocation").bind("click", marker, function(e) {

		Home.geolocate();


	});
	
	
	
	$('#searchAddressLocation').bind('locationFound', marker, function(e, ltlng) {
		
		
		
		var marker = e.data;
		marker.setPosition(ltlng);
		
		
		var map = marker.getMap();
		map.setCenter(ltlng);

	});
	
	
    $('#searchAddressLocation').keypress(function(e){
    	        code= (e.keyCode ? e.keyCode : e.which);
    	        
    	        
    	        if (code == 13) {
    	        	

    	        	Home.geolocate();
    	        	
    	        	
    	        	e.preventDefault();
    		}

	});
	
	$("#searchAddressLocationButton").bind("click", function(event) {

		Home.geolocate();

	});
	
	
	
	
	
	
	$("#detectLocationButton").bind("click", function(e) {

		
		navigator.geolocation.getCurrentPosition(Home.handleDetectedLocation, showError, {enableHighAccuracy:true,maximumAge:600000});


	});
	
	
	
	
	
	
	$('#detectLocationButton').bind('locationDetected', marker, function(e, ltlng) {

		var marker = e.data;
		marker.setPosition(ltlng);
		
		
		var map = marker.getMap();
		map.setCenter(ltlng);

	});
	

	
	$("#pageMyLocation").bind("pageshow", marker, function(e) {

		var position = localStorage.getItem("ElectionObservationLocation");

		if (null != position)
		{
			var coords = position.split(", ");
		    var lat = coords[0];
		    var lng = coords[1];
		    
		    var latlng = new google.maps.LatLng(lat, lng);
			
			var marker = e.data;
			marker.setPosition(latlng);
			
			
			var map = marker.getMap();
			map.setCenter(latlng);

		}
		


	});
    
    
	
};



Home.handleDetectedLocation = function(position){
    var lat = position.coords.latitude;
    var lng = position.coords.longitude;
    
    var latlng = new google.maps.LatLng(lat, lng);
    
	
    $('#detectLocationButton').trigger('locationDetected', latlng);
	
};


Home.geolocate = function(){

	var address = $("#searchAddressLocation").val();
	var geocoder = new google.maps.Geocoder();    	    	    
	geocoder.geocode( { 'address': address}, function(results, status) {
	  if (status == google.maps.GeocoderStatus.OK) {
		
		  /*
	    map.setCenter(results[0].geometry.location);
	    
	    marker.setOptions({
	        position: results[0].geometry.location
	    });
	    */
		  
		  var ltlng = results[0].geometry.location;
		
	    $('#searchAddressLocation').trigger('locationFound', ltlng);
	    
	    
	  } else {
	    alert("Geocode was not successful for the following reason: " + status);
	  }
	});

};




Home.loadCommentsForPage = function(pageId)
{
	Home.loadCommentsForPageDirect(pageId.currentTarget.getAttribute("targetQuestion"));
};

Home.loadCommentsForPageDirect = function(pageId)
{
	var url = "../servlet/Home?" + "type=loadComments" + "&comment=" + pageId;
	
	var onResponse = Home.handleLoadComments;
	Request.sendRequest(url, onResponse);
};

Home.submitQuestionComment = function(comment)
{
	var commentResponse = document.getElementById(comment.id + "TextArea").value;
	document.getElementById(comment.id + "TextArea").value = "";
	
	var url = "../servlet/Home?" + "type=submitComment" + "&comment=" + comment.id + "&response=" + commentResponse;
	
	var onResponse = Home.handlePutResponse;
	Request.sendRequest(url, onResponse);
};

Home.handleLoadComments = function(response)
{
	if (response.status != 200)
	{
		alert("ERROR: Failed to get item");
		return false;
	}
	
	var results = eval(response.responseText);
	
	var element = document.getElementById(results.comment + "CommentsArea");
	
	element.innerHTML = "";
	
	for (var idx = 0; idx < results.topComments.length; idx++)
	{
		element.innerHTML += results.topComments[idx].item + "<br><br>";
	};
};

Home.handleLoadResultsList = function(response)
{
	if (response.status != 200)
	{
		alert("ERROR: Failed to get item");
		return false;
	}
	
	var results = eval(response.responseText);
	
	var element = document.getElementById("resultsContent");
	
	var innerHTML = "<div data-role='collapsible-set'>";
	
	for (var idx = 0; idx < results.questions.length; idx++)
	{
		var question = results.questions[idx].question;
		innerHTML += "<div data-role='collapsible' data-theme='b' data-content-theme='d' id='" + question.split(' ').join('') + "'>";
		innerHTML += "<h3>" + question + "</h3>";
		innerHTML += "<div id='" + question.split(' ').join('') + "globalResponse" + "'>Loading Results...</div>";
		innerHTML += "</div>";
	}
	innerHTML += "</div>";
	element.innerHTML = innerHTML;
	
	element = document.getElementById("mapPageContent");
		
	innerHTML = "</div><div data-role='collapsible-set'>";
	
	for (var idx = 0; idx < results.questions.length; idx++)
	{
		var question = results.questions[idx].question;
		innerHTML += "<div data-role='collapsible' data-theme='b' data-content-theme='d' id='" + question.split(' ').join('') + "Maps'>";
		innerHTML += "<h3>" + question + "</h3>";
		innerHTML += "<div id='" + question.split(' ').join('') + "MapsglobalResponse" + "'>Loading Results...</div>";
		innerHTML += "</div>";
	}
	
	innerHTML += "</div>";
	
	element.innerHTML = innerHTML;
	
	for (var idx = 0; idx < results.questions.length; idx++)
	{
		var name = "#" + results.questions[idx].question.split(' ').join('');
		$(name).bind('expand', Home.loadResult);
	}
	
	for (var idx = 0; idx < results.questions.length; idx++)
	{
		var name = "#" + results.questions[idx].question.split(' ').join('') + "Maps";
		$(name).bind('expand', Home.loadResult);
	};
};

Home.handleGetQuestionResponse = function(response)
{
	if (response.status != 200)
	{
		alert("ERROR: Failed to get question");
		return false;
	}
	
	var results = eval(response.responseText);
	
	var questionTitle = document.getElementById("questionTitle");
	
	questionTitle.innerHTML = results.question;
	
	var item = document.getElementById("SimpleTextArea");
	item.value = "";
	
	var statsArea = document.getElementById("stats");
	statsArea.innerHTML = "";
	
	for (var idx = 0; idx < results.statistics.length; idx++)
	{
		var elem = results.statistics[idx];
		var item = elem.item;
		var count = elem.count;
		
		statsArea.innerHTML += item + " has been seen " + count + " times.<br>";
	}
	
	return false;
};

Home.generateRequest = function()
{
	
};


Home.getSurvey = function()
{
	var url = "../servlet/Home?" + "type=get" + "&survey=true";
	
	var onResponse = Home.handleGetSurveyResponse;
	Request.sendRequest(url, onResponse);
	
	return false;
};

Home.handleGetSurveyResponse = function(response)
{
	if (response.status != 200)
	{
		alert("ERROR: Failed to get question");
		return false;
	}
	
	var results = eval(response.responseText);
	
	var questionTitle = document.getElementById("questionTitle");
	
	questionTitle.innerHTML = results.question;
	
	var item = document.getElementById("SimpleTextArea");
	item.value = "";
	
	var statsArea = document.getElementById("stats");
	statsArea.innerHTML = "";
	
	for (var idx = 0; idx < results.statistics.length; idx++)
	{
		var elem = results.statistics[idx];
		var item = elem.item;
		var count = elem.count;
		
		statsArea.innerHTML += item + " has been seen " + count + " times.<br>";
	}
	
	return false;
};

