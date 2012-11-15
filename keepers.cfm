<h3>Eligible 2013 Keepers</h3>
<i>Players are listed with the 2013 round selection that it would cost to keep them</i>
<cfquery name="qKeepers" datasource="#application.dsn#">
	select p.first,p.last,p.pos,p.nflteam,( d.round - 2 ) "cost",t.name "team"
	from draft d join players p using (playerID) join teams t on p.teamID=t.teamID
	where d.round > 8 and d.playerID NOT IN (select playerid from v_players_moved)
	order by team,round
</cfquery>

<style>
	ol {
		margin-left : 50px;
	}
	#keeperArea {
		width : 720px;
		height : 570px;
		overflow-y : scroll;
		margin-top : 20px;
	}
	.teamkeepers {
		float : left;
		width : 300px;
		font-size : 12px;
		margin-top : 10px;
	}
</style>

<div id="keeperArea">
<cfset currtm = ''>
<cfoutput query="qKeepers">
	<cfif qKeepers.team neq currtm>
		<cfif currentrow gt 1></ol></div></cfif>
		<div class="teamkeepers">
		<h4>#team#</h4><ol>
	</cfif>
	<li>#pos# #first# #last#, #nflteam# [#cost#]</li>
	<cfset currtm = team>
</cfoutput>
</div>