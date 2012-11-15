<cfquery name="qTeams" datasource="#application.dsn#">
	SELECT 		*
	FROM		teams
	ORDER BY	abbv
</cfquery>

<cfset sTeams = {}>
<cfloop query="qTeams">
	<cfset sTeams[ abbv ] = teamID>
</cfloop>

<style>
	#tiebreakTbl {
		border: 1px solid black;
		border-width: 1px 0 0 1px;
	}
	#tiebreakTbl TD,#tiebreakTbl TH {
		border: 1px solid black;
		border-width: 0 1px 1px 0;
		text-align:center;
	}
	.loss {
		font-weight: bold;
		background-color: red;
		color:#FFF;
	}
	.unknown {
		font-weight: bold;
		background-color: black;
		color: yellow;
	}
	.win {
		font-weight: bold;
		background-color: green;
		color:#FFF;
	}
	.nil {
		font-size:24px;
		background-color:#FFF;
		color:#000;		
	}
	TD A {
		display:block;
		color:#FFF;
	}
	#tiebreakHeader {
		width : 100%;
		text-align : center;
	}
</style>

<cfoutput>
<div id="tiebreakHeader">
	<h2>Tiebreaker Comparison Grid</h2>
	<i>click on any result to see tiebreak details</i>
</div>
<table id="tiebreakTbl" cellspacing=0>
	<tr>
		<th>&nbsp;</th>
	<cfloop list="#valuelist( qTeams.abbv )#" index="tm">
		<th>#tm#</th>
	</cfloop>	
	</tr>
	<cfloop query="qTeams">
		<tr>
			<td style="text-align:left;font-size:12px;">#name#</td>
			<cfloop list="#valuelist( qTeams.abbv )#" index="tm">
				<cfif sTeams[ tm ] eq qTeams.teamID>
					<td class="nil">-</td>
				<cfelse>
					<cf_compare teamID="#qTeams.teamID#" compTeamID="#sTeams[ tm ]#">
					<cfif sCompare.winnerID eq qTeams.teamID>
						<td class="win"><A href="teamCompare.cfm?teamID=#qTeams.teamID#&compTeamID=#sTeams[ tm ]#" target="_blank">W</A></td>
					<cfelseif sCompare.winnerID eq 0>
						<td class="unknown">?</td>
					<cfelse>
						<td class="loss"><A href="teamCompare.cfm?teamID=#qTeams.teamID#&compTeamID=#sTeams[ tm ]#" target="_blank">L</A></td>
					</cfif>
				</cfif>
			</cfloop>	
		</tr>
	</cfloop>
</table>
</cfoutput>