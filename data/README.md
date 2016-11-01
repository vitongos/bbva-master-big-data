Sample datasets
===============

Setup
-----------

### Import Comtrade 2015 graph
Run in console:
```bash
cd /home/centos/big-data-src
cp data/comtrade.2015.*.csv /opt/neo4j-community-3.0.6/import/
bunzip2 samples-database.tar.bz2
tar -xf samples-database.tar
rm samples-database.tar
mongorestore -d samples -c students samples/students.bson
rm -rf samples
```

Download the [Dataset](https://mega.co.nz/#!WVgSFYBZ!5C28emvkBqMWTlnEmYFvKxOej671tdKT7INiNsrbNQA) into **/opt**

### Restore students collection
Run in console:
```bash
cd /opt
bunzip2 samples-database.tar.bz2
tar -xf samples-database.tar
rm samples-database.tar
mongorestore -d samples -c students samples/students.bson
rm -rf samples
```

### Import zips collection and restaurant collection
Run in console:
```bash
cd /home/centos/big-data-src/data
mongoimport --db samples --collection zips --drop --file zips.json
mongoimport --db samples --collection restaurants --drop --file restaurants.json
```

### Import people collection from people.csv
Run in console:
```bash
cd /home/centos/big-data-src/data
mongoimport --db samples --collection people --type csv --headerline --file people.csv
```

### Import XML into MongoDB using an external tool
Run in console:
```bash
sudo yum install -y xmlstarlet
cd /home/centos/big-data-src
echo "ssn;name;lastname;email;gender;company" > data/persons.csv
xmlstarlet sel -T -t -m /persons/person -v "concat(@ssn,';',@name,';',@lastname,';',email,';',gender,';',company)" -n data/persons.xml >> data/persons.csv
mongoimport --db samples --collection people --type csv --headerline --file persons.csv
```

