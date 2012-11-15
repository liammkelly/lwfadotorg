<cfif structKeyExists(cookie,'teamID')>
	<cfquery name="qMoves" datasource="lwfa">
		SELECT 		*
		FROM		lineupchanges l 
						join players p using (playerID)
		WHERE		<cfif structKeyExists(url,'all')>0=0<cfelse>l.teamID=#cookie.teamID#</cfif>
		ORDER BY	changeDate desc
		LIMIT		20
	</cfquery>
	
	<div style="background-color:#D3E1F1">
	<h3>LAST 20 LINEUP CHANGES</h3>
	<ul listtype="square" style='margin-left:20px;'>
	<cfoutput query="qMoves">
		<li>#dateformat(changeDate,'ddd m/d')# @ #hour(changeDate)+1#:<cfif minute(changeDate) lt 10>0</cfif>#minute(changeDate)# - #status# #first# #last#</li>
	</cfoutput>
	</ul>

</cfif>