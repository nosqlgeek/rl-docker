# The following should be the case after setting up the training environment
# * Nodes 1-3 should be running
# * The Bind DNS server should be running
# * Our vanilla Ubuntu image should be existing

while read m; do
  echo "$m"
  ssh -n -i training ubuntu@${m} 'sudo docker ps' > .ps.out

  CHECK1=`cat .ps.out | grep rs-1`
  CHECK2=`cat .ps.out | grep rs-2`
  CHECK3=`cat .ps.out | grep rs-3`
  CHECK4=`cat .ps.out | grep bind`

  ssh -n -i training ubuntu@${m} 'sudo docker image ls' > .img.out
  
  CHECK5=`cat .img.out | grep ubuntu-server`
  
  if [ "${CHECK1}x" == "x" ]
  then
    CHECK1=0
  else
    CHECK1=1
  fi

  if [ "${CHECK2}x" == "x" ]
  then
    CHECK2=0
  else 
    CHECK2=1
  fi

  if [ "${CHECK3}x" == "x" ]
  then
    CHECK3=0
  else 
    CHECK3=1
  fi

  if [ "${CHECK4}x" == "x" ]
  then
    CHECK4=0
  else 
    CHECK4=1
  fi

  if [ "${CHECK5}x" == "x" ]
  then
    CHECK5=0
  else 
    CHECK5=1
  fi

  echo node1=$CHECK1
  echo node2=$CHECK2
  echo node3=$CHECK3
  echo bind=$CHECK4
  echo vanilla=$CHECK5

done < machines.txt
