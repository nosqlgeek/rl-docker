source ./settings.bash

export NUM_BOXES=$1
export CLEAN=$2
export START=$3
export REGION=europe-west1
export ZONE=$REGION-d


## Validate
if [ "x$NUM_BOXES" == "x" ]
then
   echo "Use: ./$0 <num_boxes> <clean> <start>"
   echo "whereby clean/start from [0,1]"
fi

## Clean
if [ "$CLEAN" == "1" ]
then
   rm machines.txt
   for i in `seq 1 $NUM_BOXES`;
   do
      echo "Deleting machine $i ..."
      gcloud compute instances stop dmaier-training-$i --zone=$ZONE
      gcloud compute instances delete dmaier-training-$i --zone=$ZONE
   done
fi

## Create
if [ "$START" == "1" ]
then
   for i in `seq 1 $NUM_BOXES`;
   do
      echo "Provisioning machine $i ..."
      EXT_IP=`gcloud compute instances create "dmaier-training-$i" --source-instance-template dmaier-training-$REGION-template --zone=$ZONE --address="dmaier-$REGION-ip$i" --format json | grep natIP | cut -f '2' -d':' | cut -f2 -d'"'`
      echo $EXT_IP >> machines.txt
   done
fi
