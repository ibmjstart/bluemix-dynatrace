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

serverPort=$1
pathToWar=$2
repoRoot=$3
appName=$4
profile=$5
collectorSvcName=dynatrace-collector-$RANDOM

DynatraceDescrip="dynatrace.sh {ServerPort} {Path to App War File} {URL to Repo root hosting index.yml} {App Name} {profile Name}"

echo -e "${tools}${Cyan}  Welcome to the Dynatrace Helper Script${no_color}"
echo -e "${tools}${Green}  Brought to you courtesy of IBM jStart (ibm.com/jstart)${no_color}"
echo -e "${tools}  dyntrace.sh${Cyan} invoked using format ${Yellow}${DynatraceDescrip}${no_color}"
if [ $# -eq 0 ]
  then
    echo -e "${crossbones}${Red}  Three (3) Arguments required, none provided. :-(${no_color}"
    echo -e "${crossbones}${Yellow}  Dynatrace Collector Server and Port (0.0.0.0:1234): ${Red}missing${no_color}"
    echo -e "${crossbones}${Yellow}  Local Path to Application WAR file: ${Red}missing${no_color}"
    echo -e "${crossbones}${Yellow}  Repository Root URL hosting Dynatrace Agent index.yml: ${Red}missing${no_color}"
    echo -e "${crossbones}${Yellow}  Application Name: ${Red}missing${no_color}"
    echo -e "${crossbones}${Yellow}  Dynatrace Profile Name {Optional}: ${Red}missing${no_color}"
    exit 1
elif [ $# -eq 1 ]
  then
    echo -e "${crossbones}${Red}  Three (3) Arguments required, one provided. :-(${no_color}"
    echo -e "${crossbones}${Yellow}  Dynatrace Collector Server and Port (#.#.#.#:#####): ${Cyan}${serverPort}${no_color}"
    echo -e "${crossbones}${Yellow}  Local Path to Application WAR file: ${Red}missing${no_color}"
    echo -e "${crossbones}${Yellow}  Repository Root URL hosting Dynatrace Agent index.yml: ${Red}missing${no_color}"
    echo -e "${crossbones}${Yellow}  Application Name: ${Red}missing${no_color}"
    echo -e "${crossbones}${Yellow}  Dynatrace Profile Name {Optional}: ${Red}missing${no_color}"
    exit 1
elif [ $# -eq 2 ]
  then
    echo -e "${crossbones}${Red}  Three (3) Arguments required, two provided. :-(${no_color}"
    echo -e "${crossbones}${Yellow}  Dynatrace Collector Server and Port (#.#.#.#:#####): ${Cyan}${serverPort}${no_color}"
    echo -e "${crossbones}${Yellow}  Local Path to Application WAR file: ${Cyan}${pathToWar}${no_color}"
    echo -e "${crossbones}${Yellow}  Repository Root URL hosting Dynatrace Agent index.yml: ${Red}missing${no_color}"
    echo -e "${crossbones}${Yellow}  Application Name: ${Red}missing${no_color}"
    echo -e "${crossbones}${Yellow}  Dynatrace Profile Name {Optional}: ${Red}missing${no_color}"
    exit 1
elif [ $# -eq 3 ]
  then
    echo -e "${eyes}${Red}  Three (3) Arguments required, three provided. Optional Appname defaulting to ${Yellow}${appName:-dynatest}${Red}. Optional Dynatrace Profile Name not provided.${no_color}"
elif [ $# -eq 4 ]
  then
    echo -e "${eyes}${Red}  Three (3) Arguments required, three provided. Optional Appname set to ${Yellow}${appName:-dynatest}${Red}. Optional Dynatrace Profile Name not provided.${no_color}"
fi

loginCheckFail=$(cf target | grep "Not logged in" || true)
if [ ! -z "${loginCheckFail}" ]; then
    echo -e "${crossbones}${Red}  No Bluemix Cloud Foundry login context detected ${no_color}"
    exit 1
fi

echo -e "${delivery}${Yellow}  Creating a Dynatrace Collector User Provided Service named ${Cyan}${collectorSvcName}${no_color}"
if [ -z "${profile}" ]; then
  cf create-user-provided-service ${collectorSvcName} -p """'{\"server\":\"${serverPort}\"}'"""
else
  cf create-user-provided-service ${collectorSvcName} -p """'{\"server\":\"${serverPort}\",\"profile\":\"${profile}\"}'"""
fi

echo -e "${delivery}${Yellow}  Creating ${Cyan}${appName:-dynatest}${Yellow} within Bluemix${no_color}"
cf push ${appName:-dynatest} -m 256m -p ${pathToWar}

echo -e "${delivery}${Yellow}  Adding ${Cyan}JBP_CONFIG_DYNATRACEAPPMONAGENT${Yellow} environment variable with a value of 'repository_root: ${repoRoot}'${no_color}"
cf se ${appName:-dynatest} JBP_CONFIG_DYNATRACEAPPMONAGENT "repository_root: ${repoRoot}"

echo -e "${delivery}${Yellow}  Binding ${Cyan}${collectorSvcName}${Yellow} to ${Cyan}${appName:-dynatest}{$Yellow} ...${no_color}"
cf bs ${appName:-dynatest} ${collectorSvcName}

echo -e "${delivery}${Yellow}  Restaging ${Cyan}${appName:-dynatest}${Yellow} ...${no_color}"
cf restage ${appName:-dynatest}

echo -e ""
cf logs ${appName:-dynatest} --recent

echo -e "${beers}  ${Green}finis coronat opus${no_color}"
