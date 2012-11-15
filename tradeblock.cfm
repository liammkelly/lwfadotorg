<cfquery name="qTradeblock" datasource="lwfa">
	SELECT		t.name "team",
					tb.needs,tb.notes,tb.teamID,
					group_concat(v.fullname separator '|') "players"

	FROM		teams t
						JOIN tradeblock tb ON (t.teamID=tb.teamID)
						LEFT JOIN tradeblock_players tbp ON (t.teamID=tbp.teamID)
						LEFT JOIN v_players_all v USING (playerID) 

	group by 	t.name,tb.needs,tb.notes
</cfquery>

<link rel="stylesheet" type="text/css" href="css/trade_block.css">

<div id="pointsLeaderboardDiv">
<h3>Trade Block</h3>

<table id="blockTbl" cellpadding="0" cellspacing="0">
	<tr>
		<th style="width:90px;">Team</th>
		<th style="width:200px;">Offering</th>
		<th style="width:60px;">Needs</th>
		<th style="width:280px;">Notes</th>
	</tr>
	<cfoutput query="qTradeblock">
	<tr<cfif structKeyExists(cookie,'teamID') AND qTradeblock.teamID eq cookie.teamID> style="background-color:##C9C5BE;font-weight:bold;"</cfif>>
		<td>#team#</td>
		<td align="center"><cfloop list="#qTradeblock.players#" index="name" delimiters="|">#name#<br /></cfloop></td>
		<td align="center">#needs#</td>
		<td align="center">#notes#</td>
	</tr>
	</cfoutput>
</table>
</div>