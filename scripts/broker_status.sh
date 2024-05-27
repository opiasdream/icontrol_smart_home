#!/bin/bash

echo "::::::::::::::::::::::::::::::::::::"
echo "Brew Services:"
brew services
echo "::::::::::::::::::::::::::::::::::::"
echo "Active Netstat:"
netstat -an | grep "1883" 