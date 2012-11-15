<cfquery name="qMyteam" datasource="lwfa">
	select	first,last,pos,nflteam,playerID
	FROM	players
	WHERE	teamID = #cookie.teamID#
	order by view,last
</cfquery>
<cfquery name="qLoad" datasource="lwfa">
	select 	t.*,tp.playerID
	from		tradeblock t join tradeblock_players tp using (teamID)
	where	teamID = #cookie.teamID#
</cfquery>

<style>
	#tradeBlockDiv DIV {
		float:	left;
		font:12px arial;
		margin:3px;
		text-align:left;
	}
	#tradeBlockDiv DIV#needsDiv {
		font-size:20px;
	}
	#tradeBlockDiv DIV#blockPlayersDiv {
		font-size:12px;
	}
</style>

<cfoutput>
<form id="tradeBlockForm">
<div id="tradeBlockDiv">
	<div id="blockPlayersDiv">
		<cfloop query="qMyteam">
			<input type="checkbox" name="blockPlayers" value="#playerID#"<cfif listFind(valuelist(qLoad.playerID),playerID)> CHECKED</cfif>> #pos# #last#, #first# (#pos# - #nflteam#)<br />
		</cfloop>
	</div>
	<div id="notesDiv">
		Notes:<br />
		<textarea name="notes" style="height:250px;width:200px;">
			#qLoad.notes#
		</textarea>
		<P></P><input type="button" value="Save" id="saveTradeBlockBtn">
	</div>
	<div id="needsDiv">
		<cfloop list="QB,RB,WR,TE,K,D" index="pos">
			<input type="checkbox" name="needs" value="#pos#"<cfif listFind(qLoad.needs,pos)> CHECKED</cfif>> #pos# <p />
		</cfloop>
	</div>
</div>
<input type="hidden" name="teamID" value="#cookie.teamID#">
</form>
</cfoutput>