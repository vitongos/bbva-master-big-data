for (var i=1; i<=100000; i++) {
  var doc = { _id: i, name: "Name " + i };
  db.coll.insert(doc);
  if (i % 10000 == 0) {
    print("Inserted: " + i);
  } 
}
