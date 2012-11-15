<cfsetting requesttimeout="3600">

<cfparam name="url.nflteam" default="">
<cfparam name="url.week" default="#application.currwk#">
<cfparam name="url.date" default="#dateformat(createODBCDate(now()-1),'YYYY-MM-DD')#">
<cfparam name="url.sort" default="nflteam">
<cfparam name="url.clear" default="0">

<cfif month(now()) eq 8 OR (month(now()) eq 9 AND day(now()) lt 5)><cfabort></cfif>

<cfset currDOW = dayofweek(now())>
<cfset currHour = hour(now())>

<!--- <cfif currDOW eq 4 OR currDOW eq 5>z<cfabort></cfif> --->

<cfif currHour lt 5>x<cfabort></cfif>

<cfif url.clear>
	<cfquery datasource="lwfa">
		delete from stat_import_log where weekNo = #url.week#
	</cfquery>
</cfif>
<cfquery datasource="lwfa">
	insert ignore into stat_import_log (playerID,weekNo) select distinct playerID,weekNo from playerdata
</cfquery>

<cfquery name="imported" datasource="lwfa">
	select playerID from stat_import_log where weekNo = #url.week#
</cfquery>

<cfoutput>
<h1>imports: #imported.recordcount#</h1>
</cfoutput>

<cfquery name="qPlayers" datasource="lwfa">
	select 		p.first,p.last,p.playerID,n.scheduleDate,p.pos,p.active,p.teamID,p.nflteam
	from	 		players p join nflschedule n on (p.nflteam=n.nfltm  AND n.weekNo = '#url.week#')
	where		date_format(n.scheduleDate,'%Y-%m-%d') = '#url.date#'
					<cfif nflteam neq ''>
						AND p.nflteam = '#url.nflteam#'
					</cfif>
					AND p.playerID NOT IN (select distinct playerID from stat_import_log where weekNo = #url.week#)
	order by 	p.active desc,p.#url.sort#
	limit 			1000
</cfquery>

<!--- <cfdump var="#qPlayers#" expand="0"> --->

<cfloop query="qPlayers">
	
	<cfset problem = 0>	
	<cftry>
		<CF_getline_new 
			SelectedID="#qPlayers.playerID#"
			pos="#qPlayers.pos#"
			targetDate="#dateformat(qPlayers.scheduleDate,'MM/DD')#"
			active="#qPlayers.active#"
			teamID="#qPlayers.teamID#"
			nflteam="#qPlayers.nflteam#"
			week="#url.week#"
			>
		<cfcatch type="any"><cfdump var="#cfcatch#"><cfset problem = 1></cfcatch>
	</cftry>
	
	<cfset sleep(2500)>

	<cfif problem>
		<cfoutput>
			An error occurred with 	#qPlayers.pos# #qPlayers.first# #qPlayers.last#<cfabort>
		</cfoutput>
	<cfelse>
		<cfquery datasource="lwfa">
			insert ignore into stat_import_log (playerID,weekNo) values (#qPlayers.playerID#,#url.week#)
		</cfquery>
	</cfif>
	
</cfloop>


<cfquery name="imported2" datasource="lwfa">
	select playerID from stat_import_log where weekNo = #url.week#
</cfquery>

<cfoutput>
<h1>imports: #imported2.recordcount#</h1>
</cfoutput>