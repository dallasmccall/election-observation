package backend;

import java.util.Hashtable;

public class Database 
{
	//Session -> (question -> response)
	private static Hashtable<String, Hashtable<String, String>> database;
	
	private static StatsAccumulator sa;
	
	public Database()
	{
		if (null == sa)
		{
			sa = new StatsAccumulator();
			sa.run();
		}
	}
	
	public static void PUT(String sessionName, String question, String response)
	{
		Hashtable<String, String> session = database.get(sessionName);
		
		if (null == session)
		{
			session = new Hashtable<String, String>();
		}
		
		session.put(question, response);
	}
	
	
	private class StatsAccumulator implements Runnable
	{
		//Question -> (response -> count)
		private Hashtable<String, Hashtable<String, Integer>> accumulatedDatabase;
		
		public StatsAccumulator()
		{
			accumulatedDatabase = new Hashtable<String, Hashtable<String, Integer>>();
		}

		public void run() 
		{
			for (String session : Database.database.keySet())
			{
				Hashtable<String, String> sessionQuestions = Database.database.get(session);
				
				for (String question : sessionQuestions.keySet())
				{
					String questionResponse = sessionQuestions.get(question);
					
					
				}
			}
		}
		
	}
}
