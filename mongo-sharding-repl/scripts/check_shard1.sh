docker compose exec -T shard1 mongosh --port 27011 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF