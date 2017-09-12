# Docker for Centos upgrade test script

## Usage

this is a test of the upgrade from 4.8.x to 5.1.x.   Follow the README.md to bring up the 4.8.x version.  

There are two ways to do the upgrade:

1.  Docker style:  bring up the container in an DataStax version, stop the container, bring up the container with a new version.  Do not have /usr directory as a volume in the Dockerfile for this to work.

2.  Old School style:  more for testing out upgrades on raw machines.  Change the /usr directory to be a Volume and do the upgrade "in place" on the image. 

##  Setup for test

1.  Follow steps in README.md to have the 4.8.x version running with one opscenter node and 

2.  log in to test node
```console
./dovi.sh dsecent1
```
3.  run data load for weather_sensors demo  (ignore errors for hadoop commands.  only need to have some tables loaded)
```console
cd /usr/share/dse/demos/weather_sensors/bin
./create-and-load
```
4.  verify the following tables were loaded:  monthly, station, daily
```console
cqlsh  
cqlsh> desc keyspaces
cqlsh> use weathercql;
cqlsh:weathercql> select count(*) from daily;
cqlsh:weathercql> select count(*) from monthly;
cqlsh:weathercql> select count(*) from station;
```
##  Old-school upgrade (hard metal style)

NOTE:   Must have /usr as a Volume for this to work

1.  upgrade a node to 5.0.9 using upgrade50 script  (this is run on docker host not container)
```console
./upgrade50.sh dsecent1
```
2.  stop and start the docker node
```console
docker stop dsecent1
docker start dsecent1
```
3.  verify datastax version using cqlsh (note the DSE 5.0.9 in output)
```console
jhaugland-rmbp15:dse-docker-centos jasonhaugland$ cqlsh
Connected to Test Cluster at jphmac:9042.
[cqlsh 5.0.1 | Cassandra 3.0.13.1735 | DSE 5.0.9 | CQL spec 3.4.0 | Native protocol v4]
Use HELP for help.
cassandra@cqlsh> 
```
4.  upgrade the sstables on a node using nodetool sstableupgrade
```console
nodetool sstableupgrade
```
5.  verify the tables have data running cqlsh queries from step 3
6.  Repeat steps 1-5 on each node 
7.  Finally, repeat steps 1-5 on each node using upgrade51.sh instead of upgrade50.sh to get to DataStax 5.1 

## Docker-style upgrade (this only seems to work for minor upgrades not major
##  so, it worked for 5.0.7 to 5.0.9 for example
NOTE:   Can't have /usr as a Volume for this to work

1. Have 3 images available dsecent48, dsecent50, and dsecent51

2. Have dsecent1 and dsecent2 running from dsecent48, complete setup steps 1-4

3. stop dsecent1
```console
docker stop dsecent1
```
4. start dsecent1 with the dsecent50 image
```console
docker stop dsecent1
```










