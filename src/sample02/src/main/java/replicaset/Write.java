package replicaset;

import java.net.UnknownHostException;

import org.bson.Document;

import com.mongodb.*;
import com.mongodb.client.*;

/**
 * Hello world!
 *
 */
public class Write 
{
    public static void main( String[] args ) throws UnknownHostException, InterruptedException
    {
    	@SuppressWarnings("resource")
		MongoClient client = new MongoClient(new ServerAddress("localhost", 30001));
        MongoCollection<Document> collection = client.getDatabase("samples").getCollection("ids");
        collection.drop();
        
        for (int i = 0; i < Integer.MAX_VALUE; i++) {
        	try {
        		collection.insertOne(new Document("_id", i));
        		System.out.println("Inserted : " + i);
        	}
        	catch (Exception exception) {
        		System.out.println(exception.getMessage());
        	}
        	Thread.sleep(500);
        }
    }
}