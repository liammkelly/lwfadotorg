<cfquery name="qTeam" datasource="lwfa">
	select p.*,t.name,t.nickname from players p join teams t on p.teamID=t.teamID where p.teamID = #cookie.teamID# AND inj = 'N' order by p.view
</cfquery>
<cfquery name="qTradeTeam" datasource="lwfa">
	select p.*,t.name,t.nickname from players p join teams t on p.teamID=t.teamID where p.teamID <> #cookie.teamID# AND inj = 'N' order by p.teamID,p.view
</cfquery>

<cfset teamID = cookie.teamID>
<cfset tradeTeamID = qTradeTeam.teamID[1]>

<div id="tradeDialog">
	<cfoutput>
	<div class="teamDiv">
		<div class="teamDivHeader">
			<div class="teamDivHeaderName">
				<h4>#qTeam.name#</h4>
			</div>
		</div>
		<select  name="from" class="playerSelect" multiple="true" size="16">
		<cfloop query="qTeam">
		<option value="#playerID#">#first# #last#, #pos#</option>
		</cfloop>
		</select>
		<div id="fromPlayers"></div>
	</div>
	<cfloop query="qTradeTeam">
		<cfif qTradeTeam.currentrow eq 1 OR qTradeTeam.teamID[currentrow] neq qTradeTeam.teamID[currentrow-1]>
		<div id="tradeTeam#teamID#Div" class="tradeTeamDiv"<cfif teamID eq tradeTeamID> style="display:block;"</cfif>>
		<div class="teamDivHeader">
			<div class="teamDivHeaderName">
				<h4>#name#</h4>
			</div>
		</div>
		<select  name="to" class="playerSelect" multiple="true" size="16">
		</cfif>
		<option value="#playerID#">#first# #last#, #pos#</option>
		<cfif qTradeTeam.currentrow eq qTradeTeam.recordcount OR qTradeTeam.teamID[currentrow] neq qTradeTeam.teamID[currentrow+1]>
		</select>
		<cfif teamID eq tradeTeamID><div id="toPlayers"></div></cfif>
		</div>
		</cfif>
	</cfloop>
	</cfoutput>
	<div id="buttonsDiv">
		<img src="images/prev_arrow.gif" id="prevTeam"/><p><br />
		<A name="submit" class="tradeBtn" href="javascript:;">Make Offer</A><p/><br />
		<A name="cancel" class="tradeBtn"><< Back</a><br />&nbsp;<br />
		<img src="images/next_arrow.gif" id="nextTeam"/>
	</div>
</div>