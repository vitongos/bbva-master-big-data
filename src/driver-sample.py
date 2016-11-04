'''
Created on Nov 5, 2016

@author: Victor
'''

from neo4j.v1 import GraphDatabase, basic_auth
driver = GraphDatabase.driver("bolt://localhost", auth=basic_auth("neo4j", "neo"))
session = driver.session()

session.run("CREATE (a:King {name:'Arthur', title:'King'})")

result = session.run("MATCH (a:King) WHERE a.name = 'Arthur' RETURN a.name AS name, a.title AS title")
for record in result:
  print("%s %s" % (record["title"], record["name"]))

session.close()
