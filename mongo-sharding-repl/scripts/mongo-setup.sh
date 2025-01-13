#!/bin/bash

# Инициализация сервера конфигурации
docker exec -i configSrv mongosh --port 27017 <<EOF
rs.initiate(
  {
    _id : "config_server",
    configsvr: true,
    members: [
      { _id : 0, host : "configSrv:27017" }
    ]
  }
);
exit();
EOF


# Инициализация шардов
docker exec -i shard1 mongosh --port 27018 <<EOF
rs.initiate({
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1:27018" },
        { _id : 10, host : "shard1-1:27028" },
        { _id : 20, host : "shard1-2:27038" }
      ]
    }
);
exit();
EOF

docker exec -i shard2 mongosh --port 27019 <<EOF
rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 1, host : "shard2:27019" },
        { _id : 11, host : "shard2-1:27029" },
        { _id : 12, host : "shard2-2:27039" },
      ]
    }
);
exit();
EOF

# Инициализация роутера
docker exec -i mongos_router mongosh --port 27020 <<EOF
sh.addShard( "shard1/shard1:27018");
sh.addShard( "shard2/shard2:27019");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
exit();
EOF