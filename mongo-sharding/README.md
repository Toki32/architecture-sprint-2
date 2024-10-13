```shell
docker compose up -d
```

# Инициализация configSrv:

```shell
docker exec -it configSrv mongosh --port 27017

> rs.initiate(
  {
    _id : "config_server",
       configsvr: true,
    members: [
      { _id : 0, host : "configSrv:27017" }
    ]
  }
);
> exit(); 
```


# Инициализация shard1, shard2:

```shell
docker exec -it shard1 mongosh --port 27011

> rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1:27011" },
      ]
    }
);
> exit();

docker exec -it shard2 mongosh --port 27021

> rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 1, host : "shard2:27021" }
      ]
    }
  );
> exit();
```

# Инцициализация роутера и наполнение его тестовыми данными (script/addData.sh):

```shell
docker exec -it mongos_router mongosh --port 27020

> sh.addShard( "shard1/shard1:27011");
> sh.addShard( "shard2/shard2:27021");

> sh.enableSharding("somedb");
> sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )

> use somedb

> for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})

> db.helloDoc.countDocuments() 
> exit(); 
```

# Проверка addData.sh (script/check_shard1.sh и script/check_shard2.sh)

```shell
docker exec -it shard1 mongosh --port 27011
 > use somedb;
 > db.helloDoc.countDocuments();
 > exit(); 

 docker exec -it shard2 mongosh --port 27021
 > use somedb;
 > db.helloDoc.countDocuments();
 > exit(); 
```
