	<!--- update stats --->
	<cfset msg4 = "Updated player totals.">
	<cftry>
	<cfquery name="qPlayers" datasource="lwfa">
		TRUNCATE TABLE playerstats
	</cfquery>	
	<cfquery name="qPlayers" datasource="lwfa">
		select distinct playerID from playerdata where weekNo = #prevwk#
	</cfquery>	
	<cfloop query="qPlayers">
		<cfquery name="q1" datasource="lwfa">
			CALL sp_compile(#qPlayers.playerID#);
		</cfquery>	
	</cfloop>
	<cfquery name="q2" datasource="lwfa">
		INSERT INTO playerstats (playerID) 
		select 	playerID
		from 	players
		where 	playerID not in (select distinct playerID from playerstats) 
	</cfquery>		
	<cfcatch type="any"><cfset msg4 = "There was a problem with updating the totals."><cfdump var="#cfcatch#"></cfcatch>
	</cftry>
	<cfoutput>#msg4#</cfoutput><P>
