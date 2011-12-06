
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

	$( ".transmitButton" ).removeClass("ui-disabled");
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
		
		$( ".transmitButton" ).addClass("ui-disabled");
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
    
    for(var idx = 0; idx < results.statistics.length; idx++){
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
    }
    tab.appendChild(tbo);
    root.appendChild(crt);
    root.appendChild(tab);
	
	pieChart( results.question + "chart", results.question + "chartData");
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
	
	var innerHTML = "";
	
	for (var idx = 0; idx < results.questions.length; idx++)
	{
		var question = results.questions[idx].question;
		innerHTML += "<div data-role='collapsible' data-theme='b' data-content-theme='d' id='" + question.split(' ').join('') + "'>";
		innerHTML += "<h3>" + question + "</h3>";
		innerHTML += "<div id='" + question.split(' ').join('') + "globalResponse" + "'>Loading Results...</div>";
		innerHTML += "</div>";
	}
	
	element.innerHTML = innerHTML;
	
	for (var idx = 0; idx < results.questions.length; idx++)
	{
		var name = "#" + results.questions[idx].question.split(' ').join('');
		$(name).bind('expand', Home.loadResult);
	}
	
	
	for (var idx = 0; idx < results.questions.length; idx++)
	{
		
	}
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