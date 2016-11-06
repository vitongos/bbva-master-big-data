package mongodb.sample02;

import java.net.UnknownHostException;

import org.bson.Document;

import com.mongodb.MongoClient;
import com.mongodb.ServerAddress;
import com.mongodb.client.MongoCollection;

public class Read {
	public static void main( String[] args ) throws UnknownHostException, InterruptedException
    {
        @SuppressWarnings("resource")
		MongoClient client = new MongoClient(new ServerAddress("localhost", 30001));
        MongoCollection<Document> collection = client.getDatabase("samples").getCollection("ids");
        
        for (int i = 0; i < Integer.MAX_VALUE; i++) {
        	try {
        		Document document = collection.find().sort(new Document("_id", -1)).first();
        		System.out.println("Readed : " + document.get("_id").toString());
        	}
        	catch (Exception exception) {
        		System.out.println(exception.getMessage());
        	}
        	Thread.sleep(500);
        }
    }
}
