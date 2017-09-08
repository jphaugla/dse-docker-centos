# Docker for Centos upgrade test script

## Usage

this is a test of the upgrade from 4.8.x to 5.1.x.   Follow the README.md to bring up the 4.8.x version.  to test the upgrade the following steps occur:

1.  log in to test node
```console
./dovi.sh dsecent1
```
2.  run data load for weather_sensors demo  (ignore errors for hadoop commands.  only need to have some tables loaded)
```console
cd /usr/share/dse/demos/weather_sensors/bin
./create-and-load
```
3.  verify the following tables were loaded:  monthly, station, daily
```console
cqlsh  
cqlsh> desc keyspaces
cqlsh> use weathercql;
cqlsh:weathercql> select count(*) from daily;
cqlsh:weathercql> select count(*) from monthly;
cqlsh:weathercql> select count(*) from station;
```
4.  upgrade a node to 5.0.9 using upgrade50 script  (this is run on docker host not container)
```console
./upgrade50.sh dsecent1
```
5.  stop and start the docker node
```console
docker stop dsecent1
docker start dsecent1
```
6.  verify datastax version using cqlsh (note the DSE 5.0.9 in output)
```console
jhaugland-rmbp15:dse-docker-centos jasonhaugland$ cqlsh
Connected to Test Cluster at jphmac:9042.
[cqlsh 5.0.1 | Cassandra 3.0.13.1735 | DSE 5.0.9 | CQL spec 3.4.0 | Native protocol v4]
Use HELP for help.
cassandra@cqlsh> 
```
7.  upgrade the sstables on a node using nodetool sstableupgrade
```console
nodetool sstableupgrade
```
8.  verify the tables have data running cqlsh queries from step 3
9.  Repeat steps 4-7 on each node 
10.  Finally, repeat steps 4-7 on each node using upgrade51.sh instead of upgrade50.sh to get to DataStax 5.1 

