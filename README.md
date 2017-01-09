# bluemix-dynatrace
Helper scripts and files supporting Dynatrace IBM Bluemix configuration 

## Purpose
Provides a simple nginx static web app repository to host Dynatrace Agent Unix Jars and **index.yml** file pointers on private (Dedicated && Local) Bluemix environments.  This facilitates Dynatrace monitoring integrations with Liberty applications where outbound network access is constrained (e.g. Firewalls) or legacy Dynatrace Agent distributions (6.2) are required.  For completeness and convenience, a test HelloWorld Liberty web archive and dynatrace.sh deploy script are also co-hosted for quick access.   

## Pre-Reqs
1. [Cloud Foundry](https://github.com/cloudfoundry/cli/releases) or [Bluemix](https://plugins.ng.bluemix.net/ui/home.html) Command Line Interface (CLI)
2. A network accessible Dynatrace Collector Server

## Usage
1. ```git clone https://github.com/ibmjstart/bluemix-dynatrace```
2. ```cd bluemix-dynatrace```
3. ```cf push``` OR ```bx cf push```
4. ```cf logs dynabin --recent | grep -A100000 Welcome```<br/>Results in a Bluemix static web application deployment named **dynabin** with a random url route assigned per the Bluemix environment configuration's domain rules.  Dynatrace Unix Agent jar files are pre-populated for 6.2, 6.3 and 6.5.  **index.yml** file pointers web urls are automatically configured.
>The availability of index.yml urls are the **key outcome** given their important role in facilitating the self-hosting of Dynatrace agents and [Dynatrace integration with Liberty applications](https://console.ng.bluemix.net/docs/runtimes/liberty/dynatrace.html#hosting_dynatrace_agent).

5. **Sanity Test Script**<br/>```./dist/dynatrace.sh [Dynatrace_Collector_Server:Port] ./dist/JavaHelloWorldApp.war [Web URL Repository Hosting Index.yml] {Optional_App_Name} {Optional_Profile_Name}```<br/><br/>**Example**<br/>```./dist/dynatrace.sh 10.10.10.10:9998 ./dist/JavaHelloWorldApp.war https://dynabin.mybluemix.net/dist/6.3.0_1305 dynatest dynaprofile```<br/><br/>If all goes well, your app staging output will include output similiar to:<br/>
<pre>
OUT -----> Retrieving App Management 1.22.0_20161113-2134 (app-mgmt_v1.22-20161113-2134.zip) ... (0.0s)
OUT          Expanding App Management to .app-management (0.1s)
OUT -----> **Downloading Dynatrace Appmon Agent 6.3.0_1305 from<br/>https://dynabin.mybluemix.net/dist/6.3.0_1305/dynatrace-agent-unix.jar** (1.5s)
OUT          Expanding archive ... (1.0s)
OUT -----> Retrieving com.ibm.ws.liberty-16.0.0.4-201612091351.tar.gz ... (0.0s)
</pre>

## Under the Hood
The **first** automated action is found within the **.profile.d** folder's shell script which attempts to fetch the Dynatrace Unix Agent jar files from the site [http://downloads.dynatracesaas.com/](http://downloads.dynatracesaas.com/) and automatically loads them into the static web app.  Prior to fetch, a check is made to ascertain if a given agent jar file per version already exists in a specific location (e.g. user-provided prior to deployment).  If found, the fetch for that particular version is aborted. All fetch activity generates web app log messages.  

>The automated fetches are only useful from the Bluemix environment if the following routes are network accessible:
>
-  http://downloads.dynatracesaas.com/6.2/dynatrace-agent-unix.jar
-  http://downloads.dynatracesaas.com/6.3/dynatrace-agent-unix.jar
-  https://files.dynatrace.com/downloads/OnPrem/dynaTrace/6.5/6.5.0.1289/dynatrace-agent-6.5.0.1289-unix.jar

The **second** automated action is to dynamically rewrite the skeleton **index.yml** to reflect the correct route url for the dynatrace-agent-unix.jar file.

The **dynatrace.sh** sanity test script executes the following phases:

1. Creates a User-Provided Service that maps the Dynatrace Collector configuration into a Cloud Foundry bindable service.
2. Deploys a simple HelloWorld Java web archive (WAR) based Liberty application
3. Attaches the JBP_CONFIG_DYNATRACEAPPMONAGENT environment variable to the application
4. Restages the application   

#License: Apache-2.0