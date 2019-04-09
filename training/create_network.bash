export GCP_NUM_IP=16
export GCP_VPC=dmaier-training
export REGION=europe-west1

## Network
gcloud compute networks subnets create dmaier-training-$REGION-subnet --network=$GCP_VPC --region=$REGION --range=10.10.2.0/24


## Public IP-s
for i in `seq 1 $GCP_NUM_IP`
do
   gcloud compute addresses create "dmaier-$REGION-ip$i" --region $REGION
done

