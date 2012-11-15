<link rel="stylesheet" type="text/css" href="css/points.css">

<cfset leaderTotal = 0>
<cfset sTeamPoints = deserializeJson( application.cfc.data.getTeamPoints() )>

<div id="pointsLeaderboardDiv">
<h3>Current Points Leaderboard</h3>

<table id="pointsTbl" cellpadding="0" cellspacing="0">
	<tr>
		<th style="width:250px;">Team</th>
		<th style="width:80px;">Total</th>
		<th style="width:80px;">PPG</th>
		<th style="width:80px;">Diff</th>
	</tr>
	<cfoutput>
	<cfloop query="session.qStandings">
		<cfset thisTeam = sTeamPoints['records'][currentrow]>
		<tr<cfif leaderTotal eq 0> style="background-color:##D3A069;font-weight:bold;"<cfelseif structKeyExists(cookie,'teamID') AND teamID eq cookie.teamID> style="background-color:##BBE198;"</cfif>>
			<td><A href="teampage.cfm?teamID=#teamID#">#currentrow#. #thisTeam.name# #thisTeam.nickname#</A></td>
			<td align="center">#numberformat(thisTeam.pf,'0.00')#</td>
			<td align="center">#numberformat(thisTeam.ppg,'0.0')#</td>
			<td align="center"><cfif leaderTotal eq 0><cfset leaderTotal = thisTeam.pf><cfelse>#numberformat(thisTeam.pf-leaderTotal,'0.00')#</cfif></td>
		</tr>
	</cfloop>
	</cfoutput>
</table>
</div>
