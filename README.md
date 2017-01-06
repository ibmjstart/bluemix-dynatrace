# bluemix-dynatrace
Helper scripts and files supporting Dynatrace IBM Bluemix configuration 

## Purpose
Provides a simple nginx static web app repository to host Dynatrace Agent Unix Jars and **index.yml** file pointers on private (Dedicated && Local) Bluemix environments.  This facilitates Dynatrace monitoring integrations with Websphere Liberty Bluemix buildpacks where outbound network access is constrained (e.g. Firewalls) or legacy Dynatrace Agent distributions (6.2) are required.  For completeness and convenience, a test HelloWorld Liberty web archive and dynatrace.sh deploy script are also co-hosted.   

## Pre-Reqs
1. [Bluemix](https://plugins.ng.bluemix.net/ui/home.html) or [Cloud Foundry](https://github.com/cloudfoundry/cli/releases) Command Line Interface (CLI)

## Usage
1. ```git clone https://github.com/ibmjstart/bluemix-dynatrace```
2. ```cf push``` OR ```bx cf push```
3. Results in a Bluemix static web application deployment named **dynabin** with a random route assigned per the Bluemix environment configuration's domain rules.

## Under the Hood
The **first** automated action is found within the **.profile.d** folder's shell script which attempts to fetch the Dynatrace Unix Agent jar files from the site [http://downloads.dynatracesaas.com/](http://downloads.dynatracesaas.com/) and automatically loads them into the static web app.  Prior to fetch, a check is made to ascertain if a given agent jar file per version already exists in a specific location (e.g. user-provided prior to deployment).  If found, the fetch for that particular version is aborted.  

>The automated fetches are only useful from the Bluemix environment if the following routes are network accessible:
>
-  http://downloads.dynatracesaas.com/6.2/dynatrace-agent-unix.jar
-  http://downloads.dynatracesaas.com/6.3/dynatrace-agent-unix.jar
-  https://files.dynatrace.com/downloads/OnPrem/dynaTrace/6.5/6.5.0.1289/dynatrace-agent-6.5.0.1289-unix.jar

The **second** automated action is to dynamically rewrite the skeleton **index.yml** to reflect the correct route url for the dynatrace-agent-unix.jar file.  

#License: Apache-2.0



