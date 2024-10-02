docker compose exec -T shard1 mongosh --port 27011 <<EOF
rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1:27011" },
        { _id : 1, host : "shard1-2:27012" },
        { _id : 2, host : "shard1-3:27024" },
      ]
    }
);
EOF