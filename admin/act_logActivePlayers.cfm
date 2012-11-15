<cfsetting requesttimeout="3600">

<cfquery datasource="lwfa">
	truncate table active_player_log
</cfquery>

<!--- <cfquery datasource="lwfa">
	DROP TABLE IF EXISTS active_player_log
</cfquery>
<cfquery datasource="lwfa">
	CREATE TABLE `active_player_log` (
	  `playerID` int(11) NOT NULL,
	  UNIQUE KEY `playerID` (`playerID`)
	) ENGINE=MyISAM DEFAULT CHARSET=latin1
</cfquery> --->

<cfoutput>
<cfloop list="QB,RB,WR,TE,K,LB,DT,CB,S,NT,DE" index="searchPos">
	
	<cfhttp
	  url="http://sports.yahoo.com/nfl/players?type=position&c=NFL&pos=#searchPos#"
	  resolveurl=1
	  throwOnError="Yes"
	>
	<CFSET pageCont=cfhttp.filecontent>	
	<cfset pageCont=rereplacenocase(pageCont,'[[:cntrl:]]','','ALL')>
	<CFIF pageCont contains "/nfl/players/">
		<cfset startr=find("Players by Position:",pageCont,1)>
		<CFSET nextPlr=find("/nfl/players/",pageCont,startr)+13>		
	 	<CFLOOP condition="nextPlr gt 13">
			<CFSET nextPlrEnd=find("/tr",pageCont,nextPlr)-1>
			<CFSET plrString=mid(pageCont,nextPlr,(nextPlrEnd-nextPlr))>
			<CFSET plrString=replacenocase(plrString,'">',',','ALL')>
			<CFSET plrString=rereplacenocase(plrString,'<(/)?[a-z]{1,2}[^>]>',',','ALL')>
			<CFSET plrString=rereplacenocase(plrString,'<a[^>]>','','ALL')>
			<CFSET plrString=replacenocase(plrString,' ',',','ALL')>
			<CFSET plrString=rereplacenocase(plrString,'<(/)?a(>)?','','ALL')>
			<CFSET plrString=replacenocase(plrString,'http://sports.yahoo.com:80','','ALL')>
			<CFSET plrString=replacenocase(plrString,'href="/nfl/teams/','','ALL')>
			<CFSET plrString=replace(plrString,' #searchPos#',',#searchPos#','ALL')>
			<CFSET cID=listGetAt(plrString,1)>
			<cfquery datasource="lwfa">
				INSERT INTO active_player_log (playerID) values (#cID#)
			</cfquery>
			<CFIF listlen(plrString) lt 5>#plrString#<cfexit method="EXITTEMPLATE"></CFIF>
			<CFSET pageCont=removechars(pageCont,1,nextPlr)>
			<CFSET nextPlr=find("/nfl/players/",pageCont)+13>
		</CFLOOP>
	</cfif>
	<cfset sleep(3000)>
	
</cfloop>
</cfoutput>
		
<!--- <cfquery name="q1" datasource="lwfa">select count(*) from active_player_log</cfquery><cfdump var="#q1#"> --->

<cfquery name="qMissing" datasource="lwfa">
	SELECT		playerID 
	FROM		active_player_log
	WHERE		playerID NOT IN (select distinct playerID from players)
</cfquery>

<cfloop query="qMissing">
	<cfhttp url="http://www.lwfa.org/2012/admin/admin.cfc?method=loadPlayer&playerID=#qMissing.playerID#"></cfhttp>
	Imported <cfoutput>#qMissing.playerID#</cfoutput>
	<cfset sleep(5000)>
</cfloop>