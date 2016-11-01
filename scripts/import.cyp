USING PERIODIC COMMIT 200
LOAD CSV WITH HEADERS FROM 'file:///comtrade.2015.nodes.csv' AS line 
CREATE (c:Country {id:toInt(line.id), name:line.name, code:line.code});

CREATE INDEX ON :Country(id);

USING PERIODIC COMMIT 200
LOAD CSV WITH HEADERS FROM 'file:///comtrade.2015.rels.csv' AS line
MATCH (c1:Country {id:toInt(line.id1)}), (c2:Country {id:toInt(line.id2)}) 
WITH c1,c2, 
  CASE WHEN line.flow = "Import" THEN [line.value] ELSE [] END AS import,
  CASE WHEN line.flow = "Export" THEN [line.value] ELSE [] END AS export
FOREACH (x IN import | CREATE (c1)-[:IMPORT {value:x}]->(c2))
FOREACH (x IN export | CREATE (c1)-[:EXPORT {value:x}]->(c2));
