# Docker for Centos Package Install Testing

## Usage

> **Note:** Not meant for production use. See [this whitepaper on DataStax.com][whitepaper] for 
> details on setting up DSE and Docker in production.

### Starting DSE

By default, this image will start DSE *in Cassandra only* mode. For example:

To build the DataStax Docker image, run:
```console
./dockerBuild.sh
```
To build the Opscenter Docker image, run:
```console
./dockerOpsBuild.sh
```


The image's entrypoint script runs the command `dse cassandra` and will append any switches you
provide to that command. So it's possible to start DSE in any of the other supported modes by
adding switches to the end of your `docker run` command.

#### Example: Start a Graph Node

```console
docker run -d --name dsecent1 dsecentos -g
```

In the container, this will run `dse cassandra -g` to start a graph node.

#### Example: Start an Analytics (Spark) Node

```console
docker run -d --name dsecent1 dsecentos -k
```

In the container, this will run `dse cassandra -k` to start an analytics node.

#### Example: Start a Search Node

```console
docker run -d --name dsecent1 dsecentos -s
```

In the container, this will run `dse cassandra -s` to start a search node.

You can also use combinations of those switches. For more examples, see the [Starting DSE][start-dse]
documentation.

### Exposing Ports on the Host

Chances are you'll want to expose some ports on the host so that you can talk to DSE from 
outside of Docker (for example, from code running on your local machine). You can do that using
the `-p` switch when calling `docker run` and the most common port you'll probably want to
expose is **9042** which is where CQL clients communicate. For example:

```console
docker run -d --name dsecent1 -p 9042:9042 dsecentos -s
```

This will expose the container's CQL client port (9042) on the host at port 9042. For a list of
the ports used by DSE, see the [Securing DataStax Enterprise ports][dse-ports] documentation.

### Starting Related Tools

With a node running, use `docker exec` to run other tools. For example, the `nodetool status` 
command:

```console
docker exec -it dsecent1 nodetool status
```

Or to connect with `cqlsh`:

```console
docker exec -it dsecent1 cqlsh
```

### Environment Variables

The following environment variables can be set at runtime to override configuration. Setting the 
following values will override the corresponding settings in the `cassandra.yaml` configuration 
file:

 - **`LISTEN_ADDRESS`**: The IP address to listen for connections from other nodes. Defaults to 
     the hostname's IP address.
 - **`BROADCAST_ADDRESS`**: The IP address to advertise to other nodes. Defaults to the same 
     value as the `LISTEN_ADDRESS`.
 - **`RPC_ADDRESS`**: The IP address to listen for client/driver connections. Defaults to 
     `0.0.0.0` (i.e. wildcard).
 - **`BROADCAST_RPC_ADDRESS`**: The IP address to advertise to clients/drivers. Defaults to the 
    same value as the `BROADCAST_ADDRESS`.
 - **`SEEDS`**: The comma-delimited list of seed nodes for the cluster. Defaults to this node's 
     `BROADCAST_ADDRESS` if not set and will only be set the first time the node is started.
 - **`START_RPC`**: Whether to start the Thrift RPC server. Will leave the default in the 
     `cassandra.yaml` file if not set.
 - **`CLUSTER_NAME`**: The name of the cluster. Will leave the default in the `cassandra.yaml` 
     file if not set.
 - **`NUM_TOKENS:`**: The number of tokens randomly assigned to this node. Will leave the 
     default in the `cassandra.yaml` file if not set.

If you need more advanced control over the configuration, the configuration files are exposed
as a volume (under `/etc/dse`) which would allow you to mount a more customized
configuration file from the host. See below for more information on volumes.

### Volumes

The following volumes are created and can be mounted to the host system:

- **`/var/lib/cassandra`**: Data from Cassandra
- **`/var/lib/spark`**: Data from DSE Analytics w/ Spark
- **`/var/lib/dsefs`**: Data from DSEFS
- **`/var/log/cassandra`**: Logs from Cassandra
- **`/var/log/spark`**: Logs from Spark
- **`/etc/dse`**: Most configuration files including `cassandra.yaml`, `dse.yaml`, and
    more can be found here.

### Logging

You can view logs via Docker's container logs:

```console
docker logs dsecent1
```

## Builds

Build and publish scripts are available in the `build` folder of the repository. All those 
scripts are meant to be run from the root of the repository. For example:

```console
> dockerBuild.sh
```

change the datastax.repo full to have your credentials to access the datastax repository
