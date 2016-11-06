package mongodb.restaurants;

import static spark.Spark.get;
import static spark.Spark.post;

import java.io.IOException;
import java.io.StringWriter;
import java.io.Writer;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;

import org.apache.commons.lang3.StringEscapeUtils;
import org.bson.Document;

import freemarker.template.*;

import com.mongodb.*;
import com.mongodb.client.MongoDatabase;

import spark.*;

public class HomeController {
	private final Configuration cfg;
    private final RestaurantsDAO restaurantsDAO;

    public static void main(String[] args) throws IOException {
        if (args.length == 0) {
            new HomeController("mongodb://localhost");
        }
        else {
            new HomeController(args[0]);
        }
    }

    public HomeController(String mongoURIString) throws IOException {
    	@SuppressWarnings("resource")
		final MongoClient mongoClient = new MongoClient(new MongoClientURI(mongoURIString));
        final MongoDatabase restaurantDatabase = mongoClient.getDatabase("samples");
    	restaurantsDAO = new RestaurantsDAO(restaurantDatabase);

        cfg = createFreemarkerConfiguration();
        initializeRoutes();
    }

    abstract class FreemarkerBasedRoute implements Route {
        final Template template;

        protected FreemarkerBasedRoute(final String templateName) throws IOException {
            template = cfg.getTemplate(templateName);
        }

        public Object handle(Request request, Response response) {
            StringWriter writer = new StringWriter();
            try {
                doHandle(request, response, writer);
            } catch (Exception e) {
                e.printStackTrace();
                response.redirect("/internal_error");
            }
            return writer;
        }

        protected abstract void doHandle(final Request request, final Response response, final Writer writer)
                throws IOException, TemplateException;

    }

    private void initializeRoutes() throws IOException {
        get("/", new FreemarkerBasedRoute("home.ftl") {
            @Override
            public void doHandle(Request request, Response response, Writer writer) throws IOException, TemplateException {
                List<Document> restaurants = restaurantsDAO.findByIdAscending(10);
                SimpleHash root = new SimpleHash();
                root.put("restaurants", restaurants);
                template.process(root, writer);
            }
        });

        get("/restaurant/:permalink", new FreemarkerBasedRoute("restaurant.ftl") {
            @Override
            protected void doHandle(Request request, Response response, Writer writer) throws IOException, TemplateException {
                String permalink = request.params(":permalink");

                System.out.println("/restaurant: get " + permalink);

                Document restaurant = restaurantsDAO.findByPermalink(permalink);
                if (restaurant == null) {
                    response.redirect("/not_found");
                }
                else {
                	SimpleHash root = new SimpleHash();
                    root.put("restaurant", restaurant);
                    template.process(root, writer);
                }
            }
        });

        get("/locations", new FreemarkerBasedRoute("locations.ftl") {
            @Override
            protected void doHandle(Request request, Response response, Writer writer) throws IOException, TemplateException {
                List<String> locations = restaurantsDAO.findAllLocations();
                SimpleHash root = new SimpleHash();
                root.put("locations", locations);
                template.process(root, writer);
            }
        });

        get("/cuisines", new FreemarkerBasedRoute("cuisines.ftl") {
            @Override
            protected void doHandle(Request request, Response response, Writer writer) throws IOException, TemplateException {
                List<String> cuisines = restaurantsDAO.findAllCuisines();
                SimpleHash root = new SimpleHash();
                root.put("cuisines", cuisines);
                template.process(root, writer);
            }
        });

        get("/location/:location", new FreemarkerBasedRoute("location.ftl") {
            @Override
            protected void doHandle(Request request, Response response, Writer writer) throws IOException, TemplateException {
            	String location = URLDecoder.decode(request.params(":location"), "UTF-8");

                System.out.println("/location: get " + location);
                List<Document> restaurants = restaurantsDAO.findByLocation(location);
                SimpleHash root = new SimpleHash();
                root.put("location", location);
                root.put("restaurants", restaurants);
                template.process(root, writer);
            }
        });

        get("/cuisine/:cuisine", new FreemarkerBasedRoute("location.ftl") {
            @Override
            protected void doHandle(Request request, Response response, Writer writer) throws IOException, TemplateException {
            	String cuisine = URLDecoder.decode(request.params(":cuisine"), "UTF-8");

                System.out.println("/cuisine: get " + cuisine);
                List<Document> restaurants = restaurantsDAO.findByCuisine(cuisine);
                SimpleHash root = new SimpleHash();
                root.put("location", cuisine);
                root.put("restaurants", restaurants);
                template.process(root, writer);
            }
        });

        get("/new", new FreemarkerBasedRoute("new.ftl") {
            @Override
            protected void doHandle(Request request, Response response, Writer writer) throws IOException, TemplateException {
                SimpleHash root = new SimpleHash();
                template.process(root, writer);
            }
        });

        post("/new", new FreemarkerBasedRoute("new.ftl") {
            @Override
            protected void doHandle(Request request, Response response, Writer writer)
                    throws IOException, TemplateException {

                String name = StringEscapeUtils.escapeHtml4(request.queryParams("name"));
                String borough = StringEscapeUtils.escapeHtml4(request.queryParams("borough"));
                String cuisine = StringEscapeUtils.escapeHtml4(request.queryParams("cuisine"));
                
                if (name.equals("") || borough.equals("") || cuisine.equals("")) {
                    HashMap<String, String> root = new HashMap<String, String>();
                    root.put("errors", "Por favor, introduzca los datos necesarios.");
                    root.put("name", name);
                    root.put("borough", borough);
                    root.put("cuisine", cuisine);
                    template.process(root, writer);
                }
                else {
                    String permalink = restaurantsDAO.addRestaurant(name, borough, cuisine);

                    response.redirect("/restaurant/" + permalink);
                }
            }
        });

        get("/internal_error", new FreemarkerBasedRoute("error.ftl") {
            @Override
            protected void doHandle(Request request, Response response, Writer writer) throws IOException, TemplateException {
                SimpleHash root = new SimpleHash();

                root.put("error", "System has encountered an error.");
                template.process(root, writer);
            }
        });
        
        get("/not_found", new FreemarkerBasedRoute("not_found.ftl") {
            @Override
            protected void doHandle(Request request, Response response, Writer writer) throws IOException, TemplateException {
                SimpleHash root = new SimpleHash();

                root.put("error", "Restaurant not found.");
                template.process(root, writer);
            }
        });
    }

    private Configuration createFreemarkerConfiguration() {
        Configuration retVal = new Configuration();
        retVal.setClassForTemplateLoading(HomeController.class, "/");
        return retVal;
    }
}
