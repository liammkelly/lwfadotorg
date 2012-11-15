<!--- STAT IMPORT - RUN HOURLY --->
	
<cfschedule
	action="update"
	task="LWFA - Process Week"
	URL="http://www.lwfa.org/2012/tasks/proc_update.cfm"
	interval="weekly"
	operation="httprequest"
	StartDate="#DateFormat(Now())#"
	StartTime="#TimeFormat("08:00:00")#"
	publish="no"
	/>
	
	
<!---  	
<!--- CLAIMS - RUN DAILY --->
<cfschedule
	action="delete"
	task="LWFA - Claims"
	/>

<cfschedule
	action="update"
	task="LWFA - Claims"
	URL="http://www.lwfa.org/2012/tasks/proc_claims.cfm"
	interval="daily"
	operation="httprequest"
	StartDate="#DateFormat(Now())#"
	StartTime="#TimeFormat("18:00:00")#"
	publish="no"
	/>
	
<!--- LIVE SCORING - RUN HOURLY --->
<cfschedule
	action="update"
	task="LWFA - Live Scoring"
	URL="http://www.lwfa.org/2012/scoring/liveUpdate.cfm"
	interval="3600"
	operation="httprequest"
	StartDate="#DateFormat(Now())#"
	StartTime="#TimeFormat("00:00:00")#"
	publish="no"
	/>
	
<!--- SUNDAY CLAIMS - RUN WEEKLY --->
<cfschedule
	action="update"
	task="LWFA - Sunday Claims"
	URL="http://www.lwfa.org/2012/tasks/proc_claims.cfm"
	interval="weekly"
	operation="httprequest"
	StartDate="#DateFormat(Now()+6)#"
	StartTime="#TimeFormat("11:00:00")#"
	publish="no"
	/>
	
	
<!--- GERMBOOK IMPORT - RUN HOURLY --->
<cfschedule
	action="update"
	task="Germbok - import"
	URL="http://germbook.org/feedTools/tasks/act_parseFeeds.cfm"
	interval="3600"
	operation="httprequest"
	StartDate="#DateFormat(Now())#"
	StartTime="#TimeFormat("00:00:00")#"
	publish="no"
	/>
	--->