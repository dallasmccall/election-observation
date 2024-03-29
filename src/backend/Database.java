package backend;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Random;
import java.util.UUID;

import javax.xml.bind.JAXBContext;
import javax.xml.transform.stream.StreamSource;

public class Database 
{
	//Session -> (question -> response)
	private static Hashtable<String, Hashtable<String, String>> database;
	
	private static Hashtable<String, ArrayList<String>> commentsDB;
	
	private static Integer accumulatorStarted = 0;
	
	private static StatsAccumulator sa;
	
	private static DataStore ds;
	
	private static Survey svy;
	
	private static DataFaker df;
	
	public Database()
	{
		sa = new StatsAccumulator();
		new Thread(sa).start();
		
		ds = new DataStore();
		ds.clearDataStore();
		database = ds.attemptLoad();
		commentsDB = ds.attemptCommentsLoad();
		new Thread(ds).start();
		
		df = new DataFaker();
		new Thread(df).start();
	}
	
	public static void loadSurvey()
	{
		try {
			URL xmlUrl = QuestionMap.class.getResource("./survey.xml");
			String xmlPath = xmlUrl.getPath().replaceAll("%20", " ");		

			StreamSource s = new javax.xml.transform.stream.StreamSource(xmlPath);
		    JAXBContext context = JAXBContext.newInstance(Survey.class);
		    svy = (Survey) context.createUnmarshaller().unmarshal(s);
		  } catch(Exception e) {
		    
		  }
		//System.out.println("Survey xml loaded successfully.");
	}
	
	public static void PUT(String sessionName, String question, String response)
	{
		loadIfNecessary();
		
		Hashtable<String, String> session = database.get(sessionName);
		
		if (null == session)
		{
			session = new Hashtable<String, String>();
		}
		
		session.put(question, response);
		database.put(sessionName, session);
	}
	
	private static void loadIfNecessary()
	{
		synchronized(accumulatorStarted)
		{
			if (accumulatorStarted.equals(0))
			{
				new Database();
				loadSurvey();
				accumulatorStarted = 1;
			}
			if (null == database)
			{
				database = new Hashtable<String, Hashtable<String, String>>();
			}
			if (null == commentsDB)
			{
				commentsDB = new Hashtable<String, ArrayList<String>>();
			}
		}
	}
	
	public static String getShortQuestionsJSON()
	{
		loadIfNecessary();
		
		//Hashtable<String, Hashtable<String, Integer>> accumulatedDatabase = sa.getAccumulatedDatabase();
		StringBuilder responseText = new StringBuilder();
		try
		{
			responseText.append("({questions:[");
			
			boolean firstQuestion = true;
			
			for (TypeQuestion question : svy.getQuestion())
			{
				if (!firstQuestion)
				{
					responseText.append(",");
				}
				else
				{
					firstQuestion = false;
				}
				
				responseText.append("{question:'");
				responseText.append(question.getCaptionAndShortNameAndLeftHeader().get(1).getValue());
				responseText.append("'}");
			}
			responseText.append("]})");
		}
		catch (Exception e)
		{
			
		}
		return responseText.toString();
	}
	
	public static String loadMaps(String name, String value)
	{
		try
		{
			name = name.replaceAll("Maps", "");
			
			ArrayList<ArrayList<String>> locations = new ArrayList<ArrayList<String>>();
			
			for (TypeQuestion question : svy.getQuestion())
			{
				String shortName = question.getCaptionAndShortNameAndLeftHeader().get(1).getValue().toString().replaceAll(" ", "");
				if (shortName.equals(name))
				{
					String caption = question.getCaptionAndShortNameAndLeftHeader().get(0).getValue().toString();
					
					//Also get from map value of response to question.
					
					for (String uid : database.keySet())
					{
						Hashtable<String, String> uidTable = database.get(uid);
						
						String location = uidTable.get("userLocation");
						String response = uidTable.get(caption);
						
						if (null != location && null != response)
						{
							if (value.equals(response))
							{
								String[] loc = location.split(",");
								if (loc.length == 2)
								{
									ArrayList<String> tempLoc = new ArrayList<String>();
									tempLoc.add(loc[0].trim());
									tempLoc.add(loc[1].trim());
									locations.add(tempLoc);
								}
							}
						}
					}
				}
			}
			StringBuilder responseText = new StringBuilder();
			
			responseText.append("({map:'");
			responseText.append(name);
			
			
			if (locations != null)
			{
				responseText.append("',");
				responseText.append("locations:[");
				
				boolean first = true;
				for (ArrayList<String> location : locations)
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
		            responseText.append("lat:'")
		            	.append(location.get(0));
		            responseText.append("',");
		            responseText.append("lng:'");
		            	
		            responseText.append(location.get(1));
		            
		            responseText.append("'}");
				}
				
				responseText.append("]");
				
				
				
			}
			responseText.append("})");
			return responseText.toString();
		}
		catch (Exception e)
		{
			return "";
		}
	}
	
	public static String getRequestedResult(String item)
	{
		loadIfNecessary();
		try
		{
			StringBuilder responseText = new StringBuilder();
			responseText.append("({question:'");
			responseText.append(item);
			responseText.append("',");
			
			if (item.endsWith("Maps"))
			{
				item = item.replaceAll("Maps", "");
				for (TypeQuestion question : svy.getQuestion())
				{
					String shortName = question.getCaptionAndShortNameAndLeftHeader().get(1).getValue().toString().replaceAll(" ", "");
					if (shortName.equals(item))
					{
						responseText.append("leftHeader:'");
						responseText.append(question.getCaptionAndShortNameAndLeftHeader().get(2).getValue());
						responseText.append("',");
						
						Object actualQuestion = question.getCaptionAndShortNameAndLeftHeader().get(4).getValue();
						List<String> choices = null;
								
						if (actualQuestion instanceof TypeRadio)
						{
							TypeRadio rQuestions = (TypeRadio)actualQuestion;
							choices = rQuestions.getChoice();
						}
						else if (actualQuestion instanceof TypeCheck)
						{
							TypeCheck cQuestions = (TypeCheck)actualQuestion;
							choices = cQuestions.getChoice();
						}
						
						if (choices != null)
						{
							responseText.append("statistics:[");
							
							boolean first = true;
							for (String choice : choices)
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
					            	.append(choice.replace("'", ""));
					            responseText.append("',");
					            responseText.append("count:'");
					            	
					            responseText.append("-1");
					            
					            responseText.append("'}");
							}
							
							responseText.append("]");
							
							responseText.append("})");
							return responseText.toString();
						}
					}
				}
			}
			
			
			//Question -> (Response -> Count)
			HashMap<String, Integer> requestedResult = new LinkedHashMap<String, Integer>();
			String type = "";
			
			for (TypeQuestion question : svy.getQuestion())
			{
				String shortName = question.getCaptionAndShortNameAndLeftHeader().get(1).getValue().toString().replaceAll(" ", "");
				if (shortName.equals(item))
				{
					responseText.append("leftHeader:'");
					responseText.append(question.getCaptionAndShortNameAndLeftHeader().get(2).getValue());
					responseText.append("',");
					responseText.append("rightHeader:'");
					responseText.append(question.getCaptionAndShortNameAndLeftHeader().get(3).getValue());
					responseText.append("',");
					String dbName = question.getCaptionAndShortNameAndLeftHeader().get(0).getValue().toString();
					
					Object actualQuestion = question.getCaptionAndShortNameAndLeftHeader().get(4).getValue();
					List<String> choices = null;
							
					if (actualQuestion instanceof TypeRadio)
					{
						TypeRadio rQuestions = (TypeRadio)actualQuestion;
						choices = rQuestions.getChoice();
						responseText.append("type:'radio',");
					}
					else if (actualQuestion instanceof TypeCheck)
					{
						TypeCheck cQuestions = (TypeCheck)actualQuestion;
						choices = cQuestions.getChoice();
						responseText.append("type:'check',");
					}
					else
					{
						type = "text";
						responseText.append("type:'text',");
					}
					
					Hashtable<String, Hashtable<String, Integer>> accumulatedDatabase = sa.getAccumulatedDatabase();
					
					for (String dbQuestion : accumulatedDatabase.keySet())
					{
						if (dbQuestion.startsWith(dbName))
						{
							Hashtable<String, Integer> tempResult = accumulatedDatabase.get(dbQuestion);
							
							String actualName = dbQuestion;
							boolean isSplit = false;
							if (dbQuestion.contains(":"))
							{
								actualName = dbQuestion.split(":")[1];
								isSplit = true;
							}
							
							if (!isSplit)
							{
								if (null != choices)
								{
									for (String choice : choices)
									{
										requestedResult.put(choice, 0);
									}
								}
								for (String dbAnswer : tempResult.keySet())
								{
									requestedResult.put(dbAnswer, tempResult.get(dbAnswer));
								}
								break;
							}
							else
							{
								if (null != choices)
								{
									for (String choice : choices)
									{
										if (null == requestedResult.get(choice))
										{
											requestedResult.put(choice, 0);
										}
									}
								}
								Integer resultCount = tempResult.get("true");
								if (null == resultCount)
								{
									resultCount = 0;
								}
								requestedResult.put(actualName, resultCount);
							}
						}
					}
					break;
				}
			}
			
			responseText.append("statistics:[");

			boolean first = true;
			for (String userResponse : requestedResult.keySet())
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
	            	.append(userResponse.replace("'", ""));
	            responseText.append("',");
	            responseText.append("count:'");
	            if ("text" != type)
	            {
	            	
	            	responseText.append(requestedResult.get(userResponse));
	            }
	            else
	            {
	            	responseText.append(getCommentResponseCount(userResponse));
	            }
	            
	            responseText.append("'}");
			}
			
			responseText.append("]");
			
			responseText.append("})");
			return responseText.toString();
		}
		catch (Exception e)
		{
			
		}
		return "";
	}
	
	public static String loadTopComments(String comment)
	{
		ArrayList<String> topComments = new ArrayList<String>();
		
		ArrayList<String> allComments = commentsDB.get(comment);
		
		if (null != allComments)
		{
			for (int idx = 0; idx < Math.min(5, allComments.size()); idx++)
			{
				topComments.add(allComments.get(idx));
			}
		}
		
		StringBuilder responseText = new StringBuilder();
		responseText.append("({comment:'");
		responseText.append(comment);
		responseText.append("',");
		
		responseText.append("topComments:[");
		
		boolean first = true;
		
		for (String topComment : topComments)
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
            	.append(topComment.replace("'", ""));
            responseText.append("'}");
		}
		
		responseText.append("]");
		
		responseText.append("})");
		
		return responseText.toString();
	}
	
	private static int getCommentResponseCount(String comment)
	{
		ArrayList<String> responses = commentsDB.get(comment);
		
		if (null == responses)
		{
			responses = new ArrayList<String>();
			commentsDB.put(comment, responses);
		}
		
		return responses.size();
	}
	
	public static String getDatabaseJSON()
	{
		loadIfNecessary();
		
		Hashtable<String, Hashtable<String, Integer>> accumulatedDatabase = sa.getAccumulatedDatabase();
		
		StringBuilder responseText = new StringBuilder();
		
		responseText.append("({questions:[");
		
		boolean firstQuestion = true;
		
		for (String question : accumulatedDatabase.keySet())
		{
			if (!firstQuestion)
			{
				responseText.append(",");
			}
			else
			{
				firstQuestion = false;
			}
			responseText.append("{question:'");
			responseText.append(question);
			responseText.append("',statistics:[");
			
			Hashtable<String, Integer> responseMap = accumulatedDatabase.get(question);
			
			boolean first = true;
			
			for (String questionResponse : responseMap.keySet())
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
	                   .append(questionResponse);
	               responseText.append("',");
	               responseText.append("count:'")
	                   .append(responseMap.get(questionResponse));
	               responseText.append("'}");
			}
			
			responseText.append("]}");
		}
		responseText.append("]})");
		
		return responseText.toString();
	}
	
	public static void submitCommentResponse(String comment, String commentResponse)
	{
		ArrayList<String> responses = commentsDB.get(comment);
		
		if (null == responses)
		{
			responses = new ArrayList<String>();
		}
		responses.add(commentResponse);
		commentsDB.put(comment, responses);
	}
	
	private class DataFaker implements Runnable
	{
		private int maxDBSize = 1000;//0000;
		private Random rand = new Random();
		
		private int count = 0;
		
		public void run() 
		{
			while (true)
			{
				try
				{
					loadIfNecessary();
					
					String id = UUID.randomUUID().toString();
					
					List<TypeQuestion> questions = svy.getQuestion();
					
					for (TypeQuestion question : questions)
					{
						Object actualQuestion = question.getCaptionAndShortNameAndLeftHeader().get(4).getValue();
						String caption = question.getCaptionAndShortNameAndLeftHeader().get(0).getValue().toString();
						
						if(actualQuestion instanceof TypeRadio)
						{
							TypeRadio radio = (TypeRadio)actualQuestion;
							
							List<String> choices = radio.getChoice();
							
							String choice = choices.get(rand.nextInt(choices.size()));
							
							PUT(id, caption, choice);
						}
					}
					double baseLat = 33.775867;
					double baseLong = -84.39733;
					
					double latOffset = (rand.nextDouble() * 1) - .5;
					double longOffset = (rand.nextDouble() * 1) - .5;
					
					String label = "userLocation";
					
					PUT(id, label, String.valueOf(baseLat + latOffset) + "," + String.valueOf(baseLong + longOffset));
					
					if (count > maxDBSize)
					{
						Thread.sleep(5000);
					}
					
					
					count = count + 1;
				}
				catch (Exception e)
				{
					
				}
			}
		}
	}
	
	private class DataStore implements Runnable
	{
		public void clearDataStore()
		{
			File f = new File("db.ser");
			f.delete();
		}
		public void run() 
		{
			while (true)
			{
				try 
				{
					FileOutputStream fos = new FileOutputStream("db.ser");
					ObjectOutputStream oos = new ObjectOutputStream(fos);
					oos.writeObject(Database.database);
					oos.flush();
					oos.close();
					
					fos = new FileOutputStream("commentDB.ser");
					oos = new ObjectOutputStream(fos);
					oos.writeObject(Database.commentsDB);
					oos.flush();
					oos.close();
					Thread.sleep(30000);
				} 
				catch (Exception e) 
				{
					e.printStackTrace();
				}
			}
		}
		
		public Hashtable<String, Hashtable<String, String>> attemptLoad()
		{
			Hashtable<String, Hashtable<String, String>> deserializedDB = null;
			try 
			{
				FileInputStream fis = new FileInputStream("db.ser");
				ObjectInputStream ois = new ObjectInputStream(fis);
				deserializedDB = 
						(Hashtable<String, Hashtable<String, String>>)ois.readObject();
				ois.close();
			} catch (Exception e) 
			{
				e.printStackTrace();
			}
			return deserializedDB;
		}
		
		public Hashtable<String, ArrayList<String>> attemptCommentsLoad()
		{
			Hashtable<String, ArrayList<String>> deserializedDB = null;
			try 
			{
				FileInputStream fis = new FileInputStream("commentDB.ser");
				ObjectInputStream ois = new ObjectInputStream(fis);
				deserializedDB = 
						(Hashtable<String, ArrayList<String>>)ois.readObject();
				ois.close();
			} catch (Exception e) 
			{
				e.printStackTrace();
			}
			return deserializedDB;
		}
		
	}
	
	
	private class StatsAccumulator implements Runnable
	{
		//Question -> (response -> count)
		private Hashtable<String, Hashtable<String, Integer>> accumulatedDatabase;
		
		public StatsAccumulator()
		{
			accumulatedDatabase = new Hashtable<String, Hashtable<String, Integer>>();
		}
		
		public Hashtable<String, Hashtable<String, Integer>> getAccumulatedDatabase()
		{
			return accumulatedDatabase;
		}

		public void run() 
		{
			while (true)
			{
				try
				{
					Hashtable<String, Hashtable<String, Integer>> tempAccumulator = new Hashtable<String, Hashtable<String, Integer>>();
					
					for (String session : Database.database.keySet())
					{
						Hashtable<String, String> sessionQuestions = Database.database.get(session);
						
						for (String question : sessionQuestions.keySet())
						{
							String questionResponse = sessionQuestions.get(question);
							
							Hashtable<String, Integer> responseMap = tempAccumulator.get(question);
							
							if (null == responseMap)
							{
								responseMap = new Hashtable<String, Integer>();
							}
							
							Integer responseCount = responseMap.get(questionResponse);
							
							if (null == responseCount)
							{
								responseCount = 0;
							}
							
							responseCount = responseCount + 1;
							
							responseMap.put(questionResponse, responseCount);
							tempAccumulator.put(question, responseMap);
						}
					}
					//System.out.println("Database has been updated.");
					accumulatedDatabase = tempAccumulator;
					Thread.sleep(5000);
				}
				catch (Exception e)
				{
					
				}
			}
		}
		
	}
}
