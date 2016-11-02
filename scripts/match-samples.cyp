# Sample 1
# ----------------------------------------------------------------------
# How many movies Anthony Hopkins acts in?

MATCH (n {name: 'Anthony Hopkins'})-[:ACTS_IN]->(d) RETURN n.name, COUNT(d)

# Sample 2
# ---------------------------------------------------------------------------
# List the movies directed by Spielberg and genre of each, sorted by runtime.
