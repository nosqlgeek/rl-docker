docker kill $(docker ps -q)
docker rm $(docker ps -a -q)
docker ps -a

cd /home/ubuntu
rm -Rf *
ls -al


cd /srv/docker
rm -Rf *
ls -al
