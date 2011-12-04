package observer.servlets;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.*;

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
		try
        {
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
						System.out.println(question + " " + answer);
					}
					
				}
			}
			
		    String requestType = request.getParameter(TYPE);
		    
		    StringBuffer responseText = new StringBuffer();
		    
		    if (null != requestType)
		    {
		        response.setContentType(JSON_TYPE);
		        
		        if (requestType.equals(GET))
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
		    
            ServletOutputStream out = response.getOutputStream();
            out.print(responseText.toString());
        }
        catch (IOException e)
        {
            System.err.println("ERROR: Failed to send response.");
        }
	}
}
