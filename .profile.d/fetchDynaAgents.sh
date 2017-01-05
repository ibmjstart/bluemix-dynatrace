#!/bin/bash -e
# Bash Shell Script to facilitate Dynatrace App Setup

#__author__ = "Sanjay Joshi, Jay Allen"
#__copyright__ = "Copyright 2016 IBM"
#__credits__ = ["Sanjay Joshi", "Jay Allen"]
#__license__ = "Apache 2.0"
#__version__ = "1.0"
#__maintainer__ = "Sanjay Joshi, Jay Allen"
#__email__ = "joshisa@us.ibm.com, allenj@us.ibm.com"
#__status__ = "Demo"

# Reference
#   https://console.ng.bluemix.net/docs/runtimes/liberty/dynatrace.html

# Overview:
# Dynatrace provides unique operational insights. Leverage full stack
# monitoring from the front-end to the back-end, to infrastructure,
# to the cloud. Understand how application performance impacts your customers.

##########
# Colors##
##########
Green='\x1B[0;32m'
Red='\x1B[0;31m'
Yellow='\x1B[0;33m'
Cyan='\x1B[0;36m'
no_color='\x1B[0m' # No Color
beer='\xF0\x9f\x8d\xba'
delivery='\xF0\x9F\x9A\x9A'
beers='\xF0\x9F\x8D\xBB'
eyes='\xF0\x9F\x91\x80'
cloud='\xE2\x98\x81'
crossbones='\xE2\x98\xA0'
litter='\xF0\x9F\x9A\xAE'
fail='\xE2\x9B\x94'
harpoons='\xE2\x87\x8C'
tools='\xE2\x9A\x92'
present='\xF0\x9F\x8E\x81'
hourglass='\xE2\x8F\xB3'
#############

clear

rootURL='http://downloads.dynatracesaas.com/'
DynatraceDescrip="fetchDynaAgents.sh"

#wget http://stedolan.github.io/jq/download/linux64/jq -nv
#chmod +x ./jq
#appuri=$(echo $VCAP_APPLICATION | ./jq -r '.application_uris[0]')
appuri=$(echo $VCAP_APPLICATION | sed -e 's/^.*"application_uris":\["\([^"]*\)".*$/\1/')

echo -e "${tools}${Cyan}  Welcome to the Dynatrace Agent Jar Fetch Helper Script${no_color}"
echo -e "${tools}${Green}  Brought to you courtesy of IBM jStart (ibm.com/jstart)${no_color}"
echo -e "${tools}  fetchDynaAgents.sh${Cyan} invoked using format ${Yellow}${DynatraceDescrip}${no_color}"

# Testing if the file has already been provided by the user
if [ ! -f ./public/dist/6.2.0_1239/dynatrace-agent-unix.jar ]; then
  echo -e "${delivery}${Yellow}  Fetching ${Cyan}6.2.0_1239 dynatrace-agent-unix.jar from ${Green}${rootURL}/6.2/dynatrace-agent-unix.jar${no_color}"
  wget ${rootURL}6.2/dynatrace-agent-unix.jar -nv -O ./public/dist/6.2.0_1239/dynatrace-agent-unix.jar
else
  echo -e "${beers}${Yellow}  ${Cyan}6.2.0_1239 dynatrace-agent-unix.jar already exists @ ${Green}./public/dist/6.2.0_1239/dynatrace-agent-unix.jar${no_color}";
fi
# Dynamically adjusting the abstracted index.yml skeleton into a concrete representation
sed -i.orig "s/custom.bluemixdomain.mybluemix.net/${appuri}/g" ./public/dist/6.2.0_1239/index.yml

# Testing if the file has already been provided by the user
if [ ! -f ./public/dist/6.3.0_1305/dynatrace-agent-unix.jar ]; then
  echo -e "${delivery}${Yellow}  Fetching ${Cyan}6.3_0_1305 dynatrace-agent-unix.jar from ${Green}${rootURL}/6.3/dynatrace-agent-unix.jar${no_color}"
  wget ${rootURL}6.3/dynatrace-agent-unix.jar -nv -O ./public/dist/6.3.0_1305/dynatrace-agent-unix.jar
else
  echo -e "${beers}${Yellow}  ${Cyan}6.3_0_1305 dynatrace-agent-unix.jar already exists @ ${Green}./public/dist/6.3_0_1305/dynatrace-agent-unix.jar${no_color}";
fi
# Dynamically adjusting the abstracted index.yml skeleton into a concrete representation
sed -i.orig "s/custom.bluemixdomain.mybluemix.net/${appuri}/g" ./public/dist/6.3.0_1305/index.yml

# Testing if the file has already been provided by the user
if [ ! -f ./public/dist/6.5.0_1289/dynatrace-agent-unix.jar ]; then
  echo -e "${delivery}${Yellow}  Fetching ${Cyan}6.5_0_1289 dynatrace-agent-unix.jar from ${Green}https://files.dynatrace.com/downloads/OnPrem/dynaTrace/6.5/6.5.0.1289/dynatrace-agent-6.5.0.1289-unix.jar${no_color}"
  wget https://files.dynatrace.com/downloads/OnPrem/dynaTrace/6.5/6.5.0.1289/dynatrace-agent-6.5.0.1289-unix.jar -nv -O ./public/dist/6.5.0_1289/dynatrace-agent-unix.jar
else
  echo -e "${beers}${Yellow}  ${Cyan}6.5_0_1289 dynatrace-agent-unix.jar already exists @ ${Green}./public/dist/6.5_0_1289/dynatrace-agent-unix.jar${no_color}";
fi
# Dynamically adjusting the abstracted index.yml skeleton into a concrete representation
sed -i.orig "s/custom.bluemixdomain.mybluemix.net/${appuri}/g" ./public/dist/6.5.0_1289/index.yml

echo -e "${beers}  ${Green}finis coronat opus${no_color}"
