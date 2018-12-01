#!/bin/bash

echo "### network ###"
echo Just ensuring that the required network exists ...
./create_network.bash

echo "### kill dns ###"
./kill_dns.bash

echo "### start dns ###"
./start_dns_onmac.bash
