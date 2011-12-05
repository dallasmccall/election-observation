package backend;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.URL;
import java.util.Hashtable;

import javax.xml.bind.JAXBContext;
import javax.xml.transform.stream.StreamSource;

public class Database 
{
	//Session -> (question -> response)
	private static Hashtable<String, Hashtable<String, String>> database;
	
	private static Integer accumulatorStarted = 0;
	
	private static StatsAccumulator sa;
	
	private static DataStore ds;
	
	private static Survey svy;
	
	public Database()
	{
		sa = new StatsAccumulator();
		new Thread(sa).start();
		
		ds = new DataStore();
		database = ds.attemptLoad();
		new Thread(ds).start();
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
		System.out.println("Survey xml loaded successfully.");
	}
	
	public static void PUT(String sessionName, String question, String response)
	{
		synchronized(accumulatorStarted)
		{
			if (accumulatorStarted.equals(0))
			{
				new Database();
				accumulatorStarted = 1;
			}
			if (null == database)
			{
				database = new Hashtable<String, Hashtable<String, String>>();
			}
			loadSurvey();
		}
		
		Hashtable<String, String> session = database.get(sessionName);
		
		if (null == session)
		{
			session = new Hashtable<String, String>();
		}
		
		session.put(question, response);
		database.put(sessionName, session);
	}
	
	public static String getShortQuestionsJSON()
	{
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
			responseText.append("'}");
		}
		responseText.append("]})");
		
		return responseText.toString();
	}
	
	public static String getDatabaseJSON()
	{
		synchronized(accumulatorStarted)
		{
			if (accumulatorStarted.equals(0))
			{
				new Database();
				accumulatorStarted = 1;
			}
			if (null == database)
			{
				database = new Hashtable<String, Hashtable<String, String>>();
			}
		}
		
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
	
	private class DataStore implements Runnable
	{
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
