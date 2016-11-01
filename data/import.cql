USING PERIODIC COMMIT 200
LOAD CSV WITH HEADERS FROM 'file:///home/centos/big-data-src/data/comtrade.2015.nodes.csv' AS line 
CREATE (c:Country {id:toInt(line.id), name:line.name, code:line.code});

CREATE INDEX ON :Country(id)

USING PERIODIC COMMIT 200
LOAD CSV WITH HEADERS FROM 'file:///home/centos/big-data-src/data/comtrade.2015.rels.csv' AS line
MATCH (c1:Country {id:toInt(line.id1)}), (c2:Country {id:toInt(line.id2)}) 
CREATE path=(c1)-[:line.flow {value:line.value}]->(c2);
