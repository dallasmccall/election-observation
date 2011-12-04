package backend;

import java.util.Hashtable;

public class Database 
{
	//Session -> (question -> response)
	private static Hashtable<String, Hashtable<String, String>> database;
	
	private static Integer accumulatorStarted = 0;
	
	private static StatsAccumulator sa;
	
	public Database()
	{
		sa = new StatsAccumulator();
		new Thread(sa).start();
	}
	
	public static void PUT(String sessionName, String question, String response)
	{
		if (null == database)
		{
			database = new Hashtable<String, Hashtable<String, String>>();
		}
		synchronized(accumulatorStarted)
		{
			if (accumulatorStarted.equals(0))
			{
				new Database();
				accumulatorStarted = 1;
			}
		}
		
		
		Hashtable<String, String> session = database.get(sessionName);
		
		if (null == session)
		{
			session = new Hashtable<String, String>();
		}
		
		session.put(question, response);
		database.put(sessionName, session);
	}
	
	public static String getDatabaseJSON()
	{
		Hashtable<String, Hashtable<String, Integer>> accumulatedDatabase = sa.getAccumulatedDatabase();
		return null;
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
				Hashtable<String, Hashtable<String, Integer>> tempAccumulator = new Hashtable<String, Hashtable<String, Integer>>();
				
				for (String session : Database.database.keySet())
				{
					Hashtable<String, String> sessionQuestions = Database.database.get(session);
					
					for (String question : sessionQuestions.keySet())
					{
						String questionResponse = sessionQuestions.get(question);
						
						Hashtable<String, Integer> responseMap = tempAccumulator.get(questionResponse);
						
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
				
				//TODO remove this code
				/*for (String question : accumulatedDatabase.keySet())
				{
					Hashtable<String, Integer> responses = accumulatedDatabase.get(question);
					
					System.out.println(question);
					for (String questionResponse : responses.keySet())
					{
						System.out.println("\t" + questionResponse + " seen " + responses.get(questionResponse) + " times.");
					}
				}*/
				try 
				{
					Thread.sleep(5000);
				} 
				catch (InterruptedException e) 
				{
					e.printStackTrace();
				}
			}
		}
		
	}
}
