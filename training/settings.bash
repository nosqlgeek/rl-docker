## Ignore old entries for the same IP
alias ssh='ssh -o StrictHostKeyChecking=no'
alias scp='scp -o StrictHostKeyChecking=no'

## Path
export GCLOUD_PATH=/Users/david/opt/google-cloud-sdk/bin
export PATH=$GCLOUD_PATH:$PATH

## Project and user settings
gcloud info

## Machine type
GCLOUD_MACHINE=n1-standard-8
