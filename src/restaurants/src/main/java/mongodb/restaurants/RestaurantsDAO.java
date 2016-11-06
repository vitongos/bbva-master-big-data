package mongodb.restaurants;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;


import org.bson.BsonDocument;
import org.bson.BsonInt32;
import org.bson.BsonString;
import org.bson.Document;
import org.bson.conversions.Bson;

import com.mongodb.client.*;
import static com.mongodb.client.model.Projections.*;

public class RestaurantsDAO {
	MongoCollection<Document> restaurantsCollection;

    public RestaurantsDAO(final MongoDatabase restaurantDatabase) {
        restaurantsCollection = restaurantDatabase.getCollection("restaurants");
    }
    
    public Document findByPermalink(String permalink) {
    	BsonDocument findCriteria = 
			new BsonDocument("restaurant_id", new BsonString(permalink));
        return restaurantsCollection.find(findCriteria).first();
    }

    public List<Document> findByIdAscending(int limit) {
        BsonDocument sortCriteria = new BsonDocument("restaurant_id", new BsonInt32(1));
        Bson projection = include("restaurant_id", "name", "borough", "cuisine", "grades");
        MongoCursor<Document> cursor = restaurantsCollection
    		.find()
    		.projection(projection)
    		.sort(sortCriteria)
    		.limit(limit)
    		.iterator();
        return this.toRestaurantList(cursor);
    }
    
    private List<Document> toRestaurantList(MongoCursor<Document> cursor) {
    	List<Document> documents = new ArrayList<Document>();
    	while (cursor.hasNext()) {
        	Document document = cursor.next();
        	document.append("permalink", document.get("restaurant_id"));
        	documents.add(document);
        }
        return documents;
    }
    
    public List<String> findAllLocations() {
    	MongoCursor<String> iterable = 
			restaurantsCollection.distinct("borough", String.class).iterator();
        return this.toFieldList(iterable);
    }
    
    public List<String> findAllCuisines() {
    	MongoCursor<String> iterable = 
			restaurantsCollection.distinct("cuisine", String.class).iterator();
        return this.toFieldList(iterable);
    }
    
    private List<String> toFieldList(MongoCursor<String> iterable) {
    	List<String> fields = new ArrayList<String>();
    	while (iterable.hasNext()) {
        	fields.add(iterable.next());
        }
    	Collections.sort(fields);
        return fields;
    }

    public List<Document> findByLocation(String location) {
    	BsonDocument findCriteria = new BsonDocument("borough", new BsonString(location));
        BsonDocument sortCriteria = new BsonDocument("name", new BsonInt32(1));
        Bson projection = include("restaurant_id", "name", "borough", "cuisine", "grades");
        MongoCursor<Document> cursor = restaurantsCollection
    		.find(findCriteria)
    		.projection(projection)
    		.sort(sortCriteria)
    		.iterator();
        return this.toRestaurantList(cursor);
    }
    
    public List<Document> findByCuisine(String cuisine) {
    	BsonDocument findCriteria = new BsonDocument("cuisine", new BsonString(cuisine));
        BsonDocument sortCriteria = new BsonDocument("name", new BsonInt32(1));
        Bson projection = include("restaurant_id", "name", "borough", "cuisine", "grades");
        MongoCursor<Document> cursor = restaurantsCollection
    		.find(findCriteria)
    		.projection(projection)
    		.sort(sortCriteria)
    		.iterator();
        return this.toRestaurantList(cursor);
    }
    
    public String addRestaurant(String name, String borough, String cuisine) {
        System.out.println("inserting restaurant " + name + " in " + borough);
        String permalink = name.replaceAll("\\s", "_");
        permalink = permalink.replaceAll("\\W", "");
        permalink = permalink.toLowerCase();
        Document restaurant = new Document("name", name)
    		.append("borough", borough)
    		.append("cuisine", cuisine)
    		.append("restaurant_id", permalink);
        restaurantsCollection.insertOne(restaurant);
        return permalink;
    }
}
