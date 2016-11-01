# Sample 1
# ----------------------------------------------------------------------
# Insert movie “Gravity” http://www.imdb.com/title/tt1454468/
# and create relationships to actors

MATCH (g { name:'George Clooney' })-[:ACTS_IN]->(m)<-[:ACTS_IN]-(s { name:'Sandra Bullock' }) RETURN m

MATCH (g { name:'George Clooney' }), (s { name:'Sandra Bullock' }) CREATE (g)-[:ACTS_IN]->(m:Movie {title:'Gravity', description:'A medical engineer and an astronaut work together to survive after an accident leaves them adrift in space. Dr. Ryan Stone is a brilliant medical engineer on her first shuttle mission, with veteran astronaut Matt Kowalsky. But on a seemingly routine spacewalk, disaster strikes. The shuttle is destroyed, leaving Stone and Kowalsky completely alone—tethered to nothing but each other and spiraling out into the blackness. The deafening silence tells them they have lost any link to Earth... and any chance for rescue. As fear turns to panic, every gulp of air eats away at what little oxygen is left. But the only way home may be to go further out into the terrifying expanse of space.', language : 'en', genre: 'Drama', studio: 'Warner Bros. Pictures', runtime: 90 })<-[:ACTS_IN]-(s) RETURN g, s, m

# Create relationship to director

MATCH (d:Director {name:'Alfonso Cuarón'}), (m:Movie {title:'Gravity'}) CREATE (d)-[:DIRECTED]->(m) RETURN d, m


# Sample 2
# ----------------------------------------------------------------------
# Insert movie “Celda 211” http://www.imdb.com/title/tt1242422/
# and create relationships to director and main actors

CREATE p = (d:Director {name:'Daniel Monzón'})-[:DIRECTED]->(m:Movie {title:'Celda 211', description:'The story of two men on different sides of a prison riot - the inmate leading the rebellion and the young guard trapped in the revolt, who poses as a prisoner in a desperate attempt to survive the ordeal.', language : 'es', genre: 'Action', studio: 'Canal+ España', runtime: 113 })<-[:ACTS_IN]-(lt:Actor {name: 'Luis Tosar', birthplace: 'Lugo, Galicia, Spain'}), (aa:Actor {name: 'Alberto Ammann', birthplace: 'Córdoba, Argentina'})-[:ACTS_IN]->(m), (ar:Actor {name: 'Antonio Resines', birthplace: 'Torrelavega, Cantabria, Spain'})-[:ACTS_IN]->(m), (cb:Actor {name: 'Carlos Bardem', birthplace: 'Madrid, Spain'})-[:ACTS_IN]->(m) RETURN d, m, aa, ar, cb, lt
