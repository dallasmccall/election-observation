package backend;

import java.io.FileOutputStream;
import java.io.StringWriter;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;

public class SurveyTransformer {
	
	
	  public static String transform(String xslPath, String xmlPath){
		    TransformerFactory tFactory = TransformerFactory.newInstance();
		    String result = "";
		    try{
		    Transformer transformer =  tFactory.newTransformer(new javax.xml.transform.stream.StreamSource(xslPath));

		    
		    StringWriter writer = new StringWriter();
		    
		    transformer.transform(
		    		new javax.xml.transform.stream.StreamSource(xmlPath),
		    		new javax.xml.transform.stream.StreamResult( writer ));

		    result = writer.toString();

		    }  catch (Exception e) {
		        e.printStackTrace( );
		    }
		    return result;
	  }
	
	  public static void transform(String xslPath, String xmlPath, String htmlOutPath){
		    TransformerFactory tFactory = TransformerFactory.newInstance();
		    try{
		    Transformer transformer =  tFactory.newTransformer(new javax.xml.transform.stream.StreamSource(xslPath));

		    transformer.transform(
		    		new javax.xml.transform.stream.StreamSource(xmlPath),
		    		new javax.xml.transform.stream.StreamResult( new FileOutputStream(htmlOutPath)));

		    }  catch (Exception e) {
		        e.printStackTrace( );
		    }
	  }
}
