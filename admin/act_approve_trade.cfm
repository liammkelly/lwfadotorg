<cfquery name="qTradeSpecs" datasource="lwfa">
	select * from trades where tradeID=#tradeID# 
</cfquery>

<cfloop query="qTradeSpecs">
	<cfif offerTeam eq 1>
		<cfset newToTeamID = qTradeSpecs.teamID>
	<cfelse>
		<cfset newFromTeamID = qTradeSpecs.teamID>
	</cfif>
</cfloop>

<cfloop query="qTradeSpecs">
	<cfif waive eq 0>
		<cfif teamID eq newFromTeamID>
			<cfquery name="qTradeActionWaive" datasource="lwfa">
				UPDATE 	players
				SET			teamID = #newToTeamID#, active = 'N', inj = 'N'
				WHERE		playerID = #playerID#
			</cfquery>
		<cfelse>
			<cfquery name="qTradeActionWaive" datasource="lwfa">
				UPDATE 	players
				SET			teamID = #newFromTeamID#, active = 'N', inj = 'N'
				WHERE		playerID = #playerID#
			</cfquery>
		</cfif>
	<cfelse>
		<cfquery name="qTradeActionWaive" datasource="lwfa">
			UPDATE 	players
			SET			teamID = 0, active = 'N', inj = 'N'
			WHERE		playerID = #playerID#
		</cfquery>
	</cfif>
</cfloop>
<cfquery name="qTradeActionWaive" datasource="lwfa">
	UPDATE 	trades
	SET			statusID = 3, last_updated_date=now()
	WHERE		tradeID = #tradeID#
</cfquery>

<cfquery name="qOtherTrades" datasource="lwfa">
	UPDATE trades SET statusID = 6 WHERE playerID IN (#qTradeSpecs.playerID#) AND statusID=1
</cfquery>