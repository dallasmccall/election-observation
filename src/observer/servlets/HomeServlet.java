package observer.servlets;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.*;

import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;

import backend.*;

/**
 * This is the servlet that is accessed by index.jsp
 * @author Dallas McCall
 *
 */
public class HomeServlet extends HttpServlet
{
	/** Serial Version of this servlet **/
    private static final long serialVersionUID = 1L;
    
    private static final String TYPE = "type";
    
    private static final String GET = "get";
    
    private static final String PUT = "put";
    
    private static final String JSON_TYPE = "application/json";
    
    private HashMap<String, ArrayList<String>> simpleDatabase = new HashMap<String, ArrayList<String>>();
    
    //private ArrayList<String> simpleDatabase = new ArrayList<String>();

    public void doGet(HttpServletRequest request,
	                  HttpServletResponse response)
	{
    	ServletOutputStream out = null;
		try
        {
			out = response.getOutputStream();
			String userResponse = request.getParameter("userResponse");
			
			if (null != userResponse)
			{
				Map<String, String[]> params = request.getParameterMap();
				
				for (String question : params.keySet())
				{
					if (question.equals("userResponse"))
					{
						continue;
					}
					for (String answer : params.get(question))
					{
						Database.PUT(userResponse, question, answer);
						//System.out.println(question + " " + answer);
					}
					
				}
			}
			
		    String requestType = request.getParameter(TYPE);
		    
		    StringBuffer responseText = new StringBuffer();
		    
		    if (null != requestType)
		    {
		    	
		        response.setContentType(JSON_TYPE);
		        
		        if (requestType.equals("getStats"))
		    	{
		    		responseText.append(Database.getDatabaseJSON());
		    	}
		        else if (requestType.equals("getShortQuestions"))
		        {
		        	responseText.append(Database.getShortQuestionsJSON());
		        }
		        else if (requestType.equals("loadResult"))
		        {
		        	String item = request.getParameter("item");
		        	if (null != item)
		        	{
		        		responseText.append(Database.getRequestedResult(item));
		        	}
		        }
		        else if (requestType.equals("submitComment"))
		        {
		        	String comment = request.getParameter("comment");
		        	String commentResponse = request.getParameter("response");
		        	if (null != comment && null != commentResponse)
		        	{
		        		Database.submitCommentResponse(comment, commentResponse);
		        	}
		        }
		        else if (requestType.equals("loadComments"))
		        {
		        	String comment = request.getParameter("comment");
		        	if (null != comment)
		        	{
		        		responseText.append(Database.loadTopComments(comment));
		        	}
		        }
		        else if (requestType.equals("loadMap"))
		        {
		        	responseText.append(Database.loadMaps(request.getParameter("map"), request.getParameter("value")));
		        }
		        
		        else if (requestType.equals("shareLink"))
		        {
		        	sendEmailToFriends(request.getParameter("friends"));
		        }
		        
		        else if (requestType.equals(GET))
		        {
		        	String isQuestion = request.getParameter("question");
		        	String isSurvey = request.getParameter("survey");
		        	
		        	if ("true".equals(isQuestion))
		        	{		        	
		        		String question = QuestionMap.getMap().getNextQuestion();
		        		responseText.append("({question:'");
		        		responseText.append(question);
		        		responseText.append("',statistics:[");
		        		
		        		ArrayList<String> responsesSoFar = simpleDatabase.get(question);
		        		
		        		if (null == responsesSoFar)
		        		{
		        			responsesSoFar = new ArrayList<String>();
		        		}
		        		
		        		HashMap <String, Integer> mappings = new HashMap<String, Integer>();
		        		
		        		for (String str : responsesSoFar)
		        		{
		        			String normalizedStr = str.toLowerCase().trim();
		        			Integer countSoFar = (mappings.get(normalizedStr));
		        			countSoFar = (null == countSoFar) ? 0 : countSoFar;
		        			
		        			countSoFar += 1;
		        			
		        			mappings.put(normalizedStr, countSoFar);
		        		}
		        		
		        		boolean first = true;
		        		for (String str : mappings.keySet())
		        		{
		        			if (!first)
			                   {
			                       responseText.append(",");
			                   }
			                   else
			                   {
			                       first = false;
			                   }
			                   
			                   responseText.append("{");
			                   responseText.append("item:'")
			                       .append(str);
			                   responseText.append("',");
			                   responseText.append("count:'")
			                       .append(mappings.get(str));
			                   responseText.append("'}");
		        		}
		        		
		        		responseText.append("]})");
		        	}else if ("true".equals(isSurvey)){
		        		System.out.println("getting survey!!");
		        		QuestionMap.generateSurvey();
		        	}
		        	/*
		            responseText.append("({queryResults:[");
		            
		            boolean first = true;
		            for (String elem : simpleDatabase)
		            {
		               if (elem.startsWith(requestedItem))
		               {
		                   if (!first)
		                   {
		                       responseText.append(",");
		                   }
		                   else
		                   {
		                       first = false;
		                   }
		                   
		                   responseText.append("{");
		                   responseText.append("item:'")
		                       .append(elem);
		                   responseText.append("'}");
		               }
		            }
		            
		            responseText.append("]});");
		            */
		        }
		        
		        else if (requestType.equals(PUT))
		        {
		        	String question = request.getParameter("question");
		        	String questResponse = request.getParameter("response");
		        	
		        	if (null != question && questResponse != null)
		        	{
		        		ArrayList<String> questionList = simpleDatabase.get(question);
		        		
		        		if (null != questionList)
		        		{
		        			questionList.add(questResponse);
		        		}
		        		else
		        		{
		        			questionList = new ArrayList<String>();
		        			questionList.add(questResponse);
		        			simpleDatabase.put(question, questionList);
		        		}
		        	}
		        	System.out.println("PUT: " + question + "\n--->\n" + questResponse);
		            //simpleDatabase.add(requestedItem);
		        }
		    }
		    
            String responseResult = responseText.toString();
            out.print(responseResult);
        }
        catch (IOException e)
        {
            System.err.println("ERROR: Failed to send response.");
        }
		finally 
		{
	        if (out != null) 
	        {
	            try 
	            {
					out.close();
				} 
	            catch (IOException e) 
				{
				}
	        }
		}
	}
    
    private void sendEmailToFriends(String friendsList)
    {
    	try
    	{
    		Properties fMailServerConfig = new Properties();
    		
    		String[] listOfFriends = friendsList.split(" ");
    		
    		Session session = Session.getDefaultInstance( fMailServerConfig, null );
    	    MimeMessage message = new MimeMessage( session );
    	    try {
    	      message.setFrom( new InternetAddress("dallas@gatech.edu") );
    	    	for(String friend : listOfFriends)
    	    	{
    	    		message.addRecipient(
    	        	        Message.RecipientType.TO, new InternetAddress(friend)
    	        	      );
    	    	}
    	      
    	      message.setSubject( "Try Election Observer" );
    	      message.setText( "Hello, a friend of yours suggested you try out this cool election observer webapp: http://143.215.103.185:8080/ElectionObservation/jsp/index.jsp" );
    	      Transport.send( message );
    	    }
    	    catch (Exception ex){
    	      System.err.println("Cannot send email. " + ex);
    	    }
    	}
    	catch (Exception e)
    	{
    		
    	}
    }
}
