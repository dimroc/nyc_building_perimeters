#!/bin/bash

external_ip="199.20.218.149"

echo Starting AWS instance
aws start i-af7478d0

output=`aws din | ack running`
while [ -z "$output" ]; do
  echo Waiting to enter running state
  sleep 10
  output=`aws din | ack running`
done

# Associate elastic ip
echo Associating elastic ip
aws aad $external_ip -i i-af7478d0

sleep 5

# Set up remote forwarding
echo Setting up SSH Remote Forwarding
ssh -f -N remote_awsmicro

echo Tunnel successfully set up on $external_ip
