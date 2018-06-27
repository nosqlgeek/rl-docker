# How to set up a custom DNS server for your Docker containers

Redis Enterprise is allowing you to connect via a fully qualified endpoint name. The demo database which is created by our `create_db.bash` script is for instance accessible via the public endpoint `redis-16379.cluster.ubuntu-docker.org:16379` and the private endpoint `redis-16379.internal.cluster.ubuntu-docker.org:16379`. The naming scheme is i.e. `redis-{port}.internal.{fqcn}`, whereby 'fqcn' is the fully qualified cluster name.

We need to have an extra DNS server in order to leverage this endpoint name. This article is describing how we can set it up in Docker by enabling other containers to use the fully qualified endpoint name of such a database.

## Installing and starting the DNS server

First of all, we need to start and install a DNS server. We are using 'Bind' in our example. A quick Google search pointed me to the following image, which comes with a nice graphical interface:

* sameersbn/bind

```
sudo ./start_dns.bash
```

I disabled the access from the outside world because this DNS will be used within your internal Docker network. It's also worth to mention that the DNS is stateful, which means that it will store the configuration files to `/srv/docker/bind` on your local host.

## Discovering the DNS server's IP address

In the next step we need to know on which internal IP our name server is listening.

```
./list_dns.bash
```

This gave me for instance `172.17.0.6`.

## Pass the DNS to a container

The script `start.bash` was adapted by adding a `--dns` flag to it. This flag ensures that each container has the name server set inside the `/etc/resolv.conf`

