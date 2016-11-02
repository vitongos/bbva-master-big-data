# Sample 1
# -----------------------------------------------------------------------------------------------
# Among actors with 5+ movies, who ones only appear in movies with runtime longer than 3 hours?

MATCH (a:Actor)-[:ACTS_IN]->(m) WITH a, collect(m) AS list WHERE LENGTH(list) >= 5 AND ALL(movie IN list WHERE movie.runtime >= 180) RETURN a.name;

# Sample 2
# -----------------------------------------------------------------------------------------------
# List the countries that report exportations over 100 billions.
