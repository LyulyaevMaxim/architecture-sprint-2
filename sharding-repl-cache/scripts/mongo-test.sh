# 1й шард
docker compose exec -T shard1 mongosh --port 27018 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

docker compose exec -T shard1-1 mongosh --port 27028 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

docker compose exec -T shard1-2 mongosh --port 27038 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

# 2й шард
docker compose exec -T shard2 mongosh --port 27019 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

docker compose exec -T shard2-1 mongosh --port 27029 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

docker compose exec -T shard2-2 mongosh --port 27039 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF