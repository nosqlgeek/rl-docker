# Admin Training

## Requirements

* A laptop or computer
  - Any HW spec will do as the training will use Cloud instances
  - Permission to execute 3rd party tools
* The following software should be installed on you computer:
  - SSH Client (i.e. Putty)
  - SCP (i.e. WinSCP)
  - UNZIP (i.e. WinZip)
  - PDF Viewer (i.e. Adobe Reader)
* Full internet access
  - Access to several administrative ports will be necessary (i.e. port 22 for SSH access)
  - If your company Wifi is blocking such ports, then please organize yourself a Guest Wifi access (assuming that Guest Wifi-s are not as restrictive as the corporate ones)
  
## Exercise 0

### Environment preparations

* Read the instructions here https://github.com/nosqlgeek/rl-docker/blob/master/training/README.md
  - Your trainer should already have prepared the environment for you!
* Configure the built-in DNS server
  - Ensure that the Bind container is running
  - Login to the Webmin UI
  - Navigate to the Bind DNS config
  - Create a new master zone `cluster.ubuntu-docker.org`
  - Read and understand the `example_dns_records.txt` file
  - Edit the records file and replace the current contents with the contents of the file `example_dns_records.txt`
  - Apply the bind configuration
* Open the Redis Enterprise Software documentation site: https://docs.redislabs.com/latest/rs/

## Exercise 1

### Outline
  
1. Perform a standard installation of Redis Enterprise Software
2. List all Redis Enterprise processes
3. Use the Admin REST service in order to create a small test database
4. Perform some operations against the test database

### 1.1 - Perform a standard installation of Redis Enterprise Software

* Start a the ’vanilla’ Ubuntu instance by using the script ‘start_vanilla.bash’
* Login to the container via `docker exec –it $id bash`
* Change to root via `sudo bash`
* Perform a standard installation by using the `install.sh` script
* Redis Enterprise is usually started automatically after the installation. However, running in a container means that you need to start it by using the `start.sh` script
* Connect to the Redis Enterprise Admin Web UI by navigating to `https://$public_ip:8443`
* Initialize the cluster by following the steps in the setup wizard
* Login to the Admin Web UI and look around. Then kill the ‘vanilla’ Ubuntu instance!

### 1.2 - List all Redis Enterprise processes    

* Provision an entire 3 node cluster by using the `reprovision.bash` script
* Check if you can access the Admin Web UI: `https://$public_ip:18443`
* Execute `login.bash` in order to get shell access to the first node
* Execute `rladmin status`
* Execute `ps –elf | grep redis-server`
* Which shard is belonging to which Redis process?

### 1.3 - Use the Admin REST service in order to create a small test database

* Copy the file `create_db.json` to the first node’s temp. directory (using ‘docker cp’)
* Edit the JSON file by modifying the database port
* Execute `curl -k -u $USER:$PASSWD -H 'Content-type: application/json' -d @/tmp/create_db.json -X POST http://localhost:8080/v1/bdbs`
* Take a look at the `create_clustered_db.json` file

### 1.4 - Perform some operations against the test database

   
* Use `redis-cli` in order  to  connect  to  the  test  database
* Create a Hash item with  the  key ‘user:$your_email‘ and  the  properties 'first_name' and 'last_name'
* Run `memtier_benchmark` against the test database

## Exercise 2

### Designing for production

* Read the documentation article here: [https://redislabs.com/redis-enterprise-documentation/administering/designing-production/hardware-requirements/](https://redislabs.com/redis-enterprise-documentation/administering/designing-production/hardware-requirements/)
* Create a checklist for the recommended configuration
  - Cluster size?
  - CPU cores per node?
  - RAM size per node?
  - Is more than 60% of the node’s RAM assigned to Redis Enterprise?
  - Is the network fast enough?
  - Does the disk sizing look OK?

## Exercise 3

### Outline
  
1. Identify the master of the cluster
2. Create a replicated database
3. Trigger the failover of the master shard by using rladmin’s failover command
   a. Show the ops/sec on this database via the Redis Enterprise Web UI
   
### 3.1 - Identify the 'Master of the Cluster'

* Execute `rladmin status nodes`
* Which node is the master of the cluster?

### 3.2 - Trigger a failover of the master shard

* Inject some continuous traffic via `memtier_benchmark`
* Open the Admin Web UI and monitor the database statistics
* Use `rladmin` in order to failover the master shards
* The `help` subcommand is your friend!
* Use `rladmin status` again
* Which roles do the shards play?
* Which shard is located on which node?

## Exercise 4

### AOF

* Create a replicated database with ‘AOF – every second’ persistence
* Load some data (i.e. via `memtier_benchmark`)
* Locate the database files on a node with Slave shards
  * The default location is `/var/opt/redislabs/persist/redis`
* Open the AO-file with an editor of your choice (i.e. `vim`)

## Exercise 5

### Outline
 
1. Which cluster/node/database level alerts are available?
2. Use the Statistics REST service in order to retrieve the database metrics
3. Advanced: Install a local Prometheus server and consume the exported cluster metrics

### 5.1 - Alerts

* Open the  Redis Enterprise Admin Web UI
* Navigate  to  the  cluster alert settings
* Open the  database  configuration  page
* Navigate  to  the  database alert settings

### 5.2 - Stats REST service

* Execute `curl -k -u $USER:$PASSWD http://localhost:8080/v1/bdbs/stats/$bdb_id?interval=1sec`
* The REST API documentation  is  part  of  the  installation  package (`rlec_rest_api.tar`)
* Download and extract the documentation and open REST API documentation in a browser  of  your  choice

### 5.3 - Consume the Prometheus metrics 

* Install a local Prometheus server
* Configure  your Prometheus installation  to  point  to  the  master  of  the  cluster‘sPrometheus endpoint
  * `http://$master_of_the_cluster:8070/`

## Exercise 6

### Outline

1. Identify and access the shard log file
2. Process/service statuses

### 6.1 - Identify and access the shard log file

* Use `rladmin` in order to identify the shard id of a shard which is running on the current node
* Find the process which belongs to this shard
* Navigate to the log directory and identify the log file which belongs to it

### 6.2 - Process/service statuses
  
* Execute `supervisorctl status`
* What’s the status of the individual services?
* Which service is eye catching?

## Exercise 7

### Optional

* Create an account under [https://app.redislabs.com](https://app.redislabs.com/)
* Navigate to the ‘My requests’ page of Redis Lab’s support portal: [https://support.redislabs.com/hc/en-us/requests](https://support.redislabs.com/hc/en-us/requests)

