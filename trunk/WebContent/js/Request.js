function Request()
{
	
}

Request.sendRequest = function(url, onResponse)
{
	var request = Request.generateRequest();
	
	if (undefined == url)
	{
		return false;
	}
	
	if (undefined != onResponse)
	{
		request.onreadystatechange = function()
		{
			if (4 == request.readyState)
			{
				onResponse(request);
			}
		};
	}
	request.open("GET", url, true);
	request.send(null);
};



Request.generateRequest = function()
{
	try
	{
		return new XMLHttpRequest();
	}
	catch (error)
	{
		//do nothing
	}
	
	try
	{
		return new ActiveXObject("MSXML3.XMLHTTP");
	}
	catch (error)
	{
		//do nothing
	}
	
	try
	{
		return new ActiveXObject("Microsoft.XMLHTTP");
	}
	catch (error)
	{
		//I'm out of ideas....
	}
	
	throw new Error("Could not create http request");
};