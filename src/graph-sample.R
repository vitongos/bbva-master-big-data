library(igraph)
library(RNeo4j)

#
# 1. Conect to database
#
graph <- startGraph("http://localhost:7474/db/data/")

query <- "MATCH (c:Country {id:{id}}) RETURN c"

from <- getSingleNode(graph, query, id = 24)

to <- getSingleNode(graph, query, id = 96)

p <- shortestPath(from, "EXPORT", to, max_depth = 10)
n <- nodes(p)
sapply(n, function(x) x$name)

#
# 2. Create igraph
#
query <- "MATCH (c1:Country)-->(c2:Country) RETURN c1.name, c2.name LIMIT 500"

edgelist <- cypher(graph, query)
g <- graph.data.frame(edgelist, directed = F)
g

#
# 3. Plot the graph
#
plot(g, 
	edge.color = 'Black',
	vertex.size = 10,
	vertex.label.cex = .8,
	layout = layout.fruchterman.reingold(g, niter = 10000))

