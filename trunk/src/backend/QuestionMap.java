package backend;

import backend.SurveyTransformer;

import java.util.ArrayList;
import java.util.Random;

public class QuestionMap {
	
	private static QuestionMap singletonMap = null;
	private ArrayList<String> questions = new ArrayList<String>();
	private Random generator = new Random();
	
	private QuestionMap()
	{
		questions.add("What is your favorite color?");
		questions.add("Does this work?");
		questions.add("Is it hard to come up with questions?");
		questions.add("What kind of phone do you have?");
		questions.add("Is this an interesting question?");
		questions.add("How many of these questions do you think there are?");
	}
	
	public static QuestionMap getMap()
	{
		if (null == singletonMap)
		{
			singletonMap = new QuestionMap();
		}
		
		return singletonMap;
	}
	
	public String getNextQuestion()
	{
		int index = generator.nextInt(questions.size());
		return questions.get(index);
	}
	
	public static void addQuestion(String question)
	{
		getMap().questions.add(question);
	}
	
	public static void generateSurvey()
	{
		
		String xslPath ="/Users/dallas/Documents/workspace/ElectionObservationServer/src/backend/survey.xsl";
		String xmlPath ="/Users/dallas/Documents/workspace/ElectionObservationServer/src/backend/survey.xml";
		String outPath ="/Users/dallas/Documents/workspace/ElectionObservationServer/WebContent/jsp/index.jsp";

		SurveyTransformer.transform(xslPath,xmlPath,outPath);

	
	}

}






