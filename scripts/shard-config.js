sh.addShard( "localhost:30101" );
sh.addShard( "localhost:30102" );
sh.addShard( "localhost:30103" );
use samples
sh.enableSharding("samples")
sh.shardCollection("samples.coll",{_id:1})
