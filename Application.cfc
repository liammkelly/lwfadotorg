<cfcomponent output="false">
	
	<!--- Application name, should be unique --->
	<cfset this.name = "LWFA.org">
	<!--- How long application vars persist --->
	<cfset this.applicationTimeout = createTimeSpan(0,2,0,0)>
	<!--- Should client vars be enabled? --->
	<cfset this.clientManagement = false>
	<!--- Where should we store them, if enable? --->
	<cfset this.clientStorage = "registry">
	<!--- Where should cflogin stuff persist --->
	<cfset this.loginStorage = "session">
	<!--- Should we even use sessions? --->
	<cfset this.sessionManagement = true>
	<!--- How long do session vars persist? --->
	<cfset this.sessionTimeout = createTimeSpan(0,0,20,0)>
	<!--- Should we set cookies on the browser? --->
	<cfset this.setClientCookies = true>
	<!--- should cookies be domain specific, ie, *.foo.com or www.foo.com --->
	<cfset this.setDomainCookies = false>
	<!--- should we try to block 'bad' input from users --->
	<cfset this.scriptProtect = "none">
	<!--- should we secure our JSON calls? --->
	<cfset this.secureJSON = false>
	<!--- Should we use a prefix in front of JSON strings? --->
	<cfset this.secureJSONPrefix = "">
	<!--- Used to help CF work with missing files and dir indexes --->
	<cfset this.welcomeFileList = "">
	
	<!--- define custom coldfusion mappings. Keys are mapping names, values are full paths  --->
	<cfset this.mappings = structNew()>
	<!--- define a list of custom tag paths. --->
	<cfset this.customtagpaths = "d:\home\tallkellys.com\wwwroot\CustomTags">
	
	<!--- Run when application starts up --->
	<cffunction name="onApplicationStart" returnType="boolean" output="false">

		<cfset application.cfc = {}>
		<cfset application.cfc.data = CreateObject('component','cfc.data')>
		<cfset application.cfc.scores = CreateObject('component','cfc.scores')>
		<cfset application.cfc.functions = CreateObject('component','cfc.functions')>
		<cfset application.cfc.json = CreateObject('component','CustomTags.json')>
	
		<cfset application.aAbbv = deserializeJSON( application.cfc.functions.getAbbreviations() )>
		<cfset application.aTeams = deserializeJSON( application.cfc.functions.getTeams(isArray=1) )>
	
		<cfset application.mailAttributes = 
		{
		   server="mail.tallkellys.com",
		   username="web@tallkellys.com",
		   password="waj4Gani"
		} />

		<cfset application.lLineupConfimOptOut = "0">

		<cfset application.dsn			= "lwfa">			
		<cfinvoke component="cfc.ajax" method="getWeek" returnvariable="application.currwk"> 
		<!--- <cfset application.currwk = 6>--->
		
		<!--- <cfif application.currwk lt 1>
			<cfset application.currwk	= 1>								
		</cfif>
		
		<cfif application.currwk gt 1 AND ( dayofweek(now()) eq 2 OR ( dayofweek(now()) eq 3 AND hour(now()) lt 9 ) )>
			<cfset application.currwk	= application.currwk-1>					
		</cfif> --->
		
		<cfif application.currwk gt 1>
			<cfset application.prevwk	= application.currwk-1>			
		<cfelse>
			<cfset application.prevwk	= application.currwk>			
		</cfif>
	
		<cfreturn true>
	</cffunction>

	<!--- Run when application stops --->
	<cffunction name="onApplicationEnd" returnType="void" output="false">
		<cfargument name="applicationScope" required="true">
	</cffunction>

	<!--- Fired when user requests a CFM that doesn't exist. --->
	<cffunction name="onMissingTemplate" returnType="boolean" output="false">
		<cfargument name="targetpage" required="true" type="string">
		<cfreturn true>
	</cffunction>
	
	<!--- Run before the request is processed --->
	<cffunction name="onRequestStart" output="true">
		<cfif structKeyExists(url,'refresh') OR dayofweek(now()) eq 3>
			<cfset onApplicationStart()>
			<cfset onSessionStart()>
		</cfif>
		<cfif cgi.script_name DOES NOT CONTAIN "act_" AND cgi.script_name DOES NOT CONTAIN "dsp_" AND cgi.query_string DOES NOT CONTAIN "showheader=false">
			<cfinclude template="header.cfm">
		</cfif>
	</cffunction>

	<!--- Runs before request as well, after onRequestStart --->
	<!--- 
	WARNING!!!!! THE USE OF THIS METHOD WILL BREAK FLASH REMOTING, WEB SERVICES, AND AJAX CALLS. 
	DO NOT USE THIS METHOD UNLESS YOU KNOW THIS AND KNOW HOW TO WORK AROUND IT!
	EXAMPLE: http://www.coldfusionjedi.com/index.cfm?mode=entry&entry=ED9D4058-E661-02E9-E70A41706CD89724
	<cffunction name="onRequest" returnType="void">
		<cfargument name="thePage" type="string" required="true">
		<cfinclude template="#arguments.thePage#">
	</cffunction>
	--->

	<!--- Runs at end of request --->
	<cffunction name="onRequestEnd" output="true">
		<cfif cgi.script_name DOES NOT CONTAIN "act_" AND cgi.script_name DOES NOT CONTAIN "dsp_" AND cgi.query_string DOES NOT CONTAIN "showheader=false">
			<cfinclude template="footer.cfm">
		</cfif>
	</cffunction>

	<!--- Runs on error --->
	<cffunction name="onError" returnType="void" output="false">
		<cfargument name="exception" required="true">
		<cfargument name="eventname" type="string" required="true">
		<cfdump var="#arguments#"><cfabort>
	</cffunction>

	<!--- Runs when your session starts --->
	<cffunction name="onSessionStart" returnType="void" output="false">

		<cfset session[ 'thisWeek1' ] = application.currwk>
		<cfset session[ 'thisWeek2' ] = application.currwk+1>
		<cfset session[ 'thisWeek3' ] = application.currwk+2>
		<cfset session[ 'thisWeek4' ] = application.currwk+3>
		
		<!--- <cfset session[ 'functionObj' ] = CreateObject('component','cfc.functions')> --->
	</cffunction>

	<!--- Runs when session ends --->
	<cffunction name="onSessionEnd" returnType="void" output="false">
		<cfargument name="sessionScope" type="struct" required="true">
		<cfargument name="appScope" type="struct" required="false">
	</cffunction>
</cfcomponent>