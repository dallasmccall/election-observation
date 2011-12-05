
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

Home.loadResults = function()
{
	var url = "../servlet/Home?" + "type=getStats";
	
	var onResponse = Home.handleLoadedResults;
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

Home.handleLoadedResults = function(response)
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
		var questionBlock = results.questions[idx];
		innerHTML += "<br>" + questionBlock.question + ":<br>";
		
		for (var innerIdx = 0; innerIdx < questionBlock.statistics.length; innerIdx++)
		{
			innerHTML += "&nbsp;&nbsp;&nbsp;&nbsp;";
			innerHTML += questionBlock.statistics[innerIdx].item + " has: ";
			innerHTML += questionBlock.statistics[innerIdx].count + " instance(s)<br>";
		}
	}
	element.innerHTML = innerHTML;
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