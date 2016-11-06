package mongodb.sample01;

import static spark.Spark.get;

import java.io.*;
import java.net.URLDecoder;
import java.util.*;

import freemarker.template.*;

public class FreemarkerSample extends App {

	public static void main(String[] args) {
		FreemarkerSample app = new FreemarkerSample();
		get("/mongodb/sample01/:name", (req, res) -> { 
			String param1 = URLDecoder.decode(req.params(":name"), "UTF-8");
			return app.getIndex(app.getDogName(param1)); 
		});
	}
	
	public String getIndex(String dog) {
		Configuration configuration = new Configuration();
		configuration.setClassForTemplateLoading(FreemarkerSample.class, "/");
		try {
			// Creamos el template
			Template template = configuration.getTemplate("index.ftl");
			
			// Para procesar el template necesitamos un StringWriter y un Map
			StringWriter stringWriter = new StringWriter();
			Map<String, Object> map = new HashMap<String, Object>();
			
			// Poblamos el Map
			map.put("dog", dog);
			
			// Procesamos el template
			template.process(map, stringWriter);
			
			return stringWriter.toString();
			
		} catch (IOException e) {
			e.printStackTrace();
		} catch (TemplateException e) {
			e.printStackTrace();
		}
		return null;
	}
}
