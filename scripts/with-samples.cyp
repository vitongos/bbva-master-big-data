# Sample 1
# -----------------------------------------------------------------------------------
# Among directors with 12+ movies, who ones deliver the longest runtime in average?

MATCH (d)-[:DIRECTED]->(m) WITH d, avg(m.runtime) AS rt, count(m.runtime) AS c WHERE c >= 12 RETURN d.name, ROUND(rt) as runtime ORDER BY runtime DESC LIMIT 10

# Sample 2
# -----------------------------------------------------------------------------------
# List the 20 actors having more movies, sorted descendant by number of appearances.

