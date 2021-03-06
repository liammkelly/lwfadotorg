<cfquery name="qtopPlayers" datasource="lwfa">
	SELECT 		p.*,
				pd.total,pd.line,pd.teamID "myTeamID",
				s.opp,s.weekNo,
				t.name "team"
	FROM		players p
					join playerdata pd USING (playerID)
					join teams t ON (t.teamID=pd.teamID)
					join nflschedule s ON (pd.weekNo=s.weekNo AND p.nflteam=s.nfltm)
	WHERE		s.weekNo < #application.currwk# AND
				t.teamID = #cookie.teamID# AND
				pd.active='Y'
	ORDER BY	pd.total desc
	limit 25
</cfquery>

<style>
	#topPlayersTbl {
		background-color:#DAE6FA;
		width:730px;
	}
	#topPlayersHeader {
		width:730px;
		text-align:center;
		color:yellow;
		font:bold 24px verdana;
	}
	#other25Lnk {
		width:730px;
		text-align:center;
		color:red;
	}
	.details {
		font-size:11px;
	}
	.player {
		font-size:12px;	
	}
	.player A {
		color:black;	
	}
	.rank {
		text-align:right;
		font-size:12px;
		font-weight:bold;		
		padding-right:5px;
	}
	.total {
		padding:0 10px 0 5px;
		text-align:center;	
	}
	.week {
		font-size:12px;	
		text-align:center;	
	}
	.myTeam {
		background-color:#D3A069;
	}
	.lastWeek {
		font-style:italic;
	}
</style>

<div id="topPlayersHeader">
My Top 25
</div>
<table id="topPlayersTbl" cellspacing=0>
	<tr>
		<th>#</th>
		<th>PLAYER</th>
		<th>WK</th>
		<th class="total">PTS</th>
		<th>DETAILS</th>
	</tr>
	<cfoutput query="qtopPlayers">
		<tr class="<cfif weekNo eq application.prevwk> lastWeek</cfif>">
			<td class="rank">#currentrow#</td>
			<td class="player"><a href="playerpage.cfm?playerID=#playerID#">#pos# #first# #last#, #team#</a></td>
			<td class="week">#weekNo#</td>
			<td class="total">#numberformat(total,'0.00')#</td>
			<td class="details">#line# <cfif opp DOES NOT CONTAIN "@">vs #opp#<cfelse>#replace(opp,"@","at ")#</cfif> </td>
		</tr>
	</cfoutput>
</table>

<div id="other25Lnk"><a href="top25.cfm">the top 25</a> | <a href="bottom25.cfm">the bottom 25</a></div>
