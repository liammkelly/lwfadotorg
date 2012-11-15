	<!--- UPDATE SCORES --->
	<cfset msg5 = "Updated scores.">
	<cftry>
	<cfquery name="qWeekGames" datasource="lwfa">
		select 	*
		from	schedule
		where 	week=#application.currwk#
	</cfquery>
	<cfloop query="qWeekGames">
		<cfquery name="qHomeTotal" datasource="lwfa">
			select 	sum(total) as tmPoints 
			from		playerdata
			where 	teamID=#homeTeamID# and weekno=#application.currwk# and active='Y'
		</cfquery>
		<cfset homeTotal=qHomeTotal.tmPoints> 
		<cfquery name="qAwayTotal" datasource="lwfa">
			select 	sum(total) as tmPoints 
			from		playerdata
			where 	teamID=#awayTeamID# and weekno=#application.currwk# and active='Y'
		</cfquery>
		<cfset awayTotal=qAwayTotal.tmPoints>
		<cfquery name="uScore" datasource="lwfa">
			update	schedule
			set 		homescore=#numberformat(homeTotal,"0.00")#,awayscore=#numberformat(awayTotal,"0.00")#
			where 	gameID=#gameID#
		</cfquery>
	</cfloop>
	<cfcatch type="any"><cfset msg5 = "There was a problem with the update scores process."><cfdump var="#cfcatch#"></cfcatch>
	</cftry>
	<cfoutput>#msg5#</cfoutput>
	
	<P>
