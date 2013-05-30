#!/bin/bash
aws stop i-af7478d0
pid=`ps aux | ack ssh.*remote_awsmicro | ack -v perl | awk '{ print $2 }'`
kill $pid
