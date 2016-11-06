package mongodb.sample01;

import static spark.Spark.get;

import java.net.URLDecoder;
import java.net.UnknownHostException;

import org.bson.Document;

import com.mongodb.*;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;

public class App 
{
	public static void main(String[] args) {
		App app = new App();
        get("/mongodb/sample01/:name", (req, res) -> { 
        	String param1 = URLDecoder.decode(req.params(":name"), "UTF-8");
        	return app.getDogName(param1); 
    	});
    }
	
	public Document getDog(String name) throws UnknownHostException {
		MongoClient client = new MongoClient("localhost");
		try {
			MongoDatabase database = client.getDatabase("samples");
			MongoCollection<Document> collection = database.getCollection("dogs");
			Document query = new Document("name", name);
			FindIterable<Document> docsIterator = collection.find(query);
			return docsIterator.first();
		} finally {
			client.close();
		}
	}
	
	public String getDogName(String name) throws UnknownHostException {
		Document dog = this.getDog(name);
		return dog.getString("name").toString();
	}
}
