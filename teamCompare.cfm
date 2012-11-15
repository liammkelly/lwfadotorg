


<div id="tiebreakDiv">
<cfif structKeyExists(form,'submit_button') OR structKeyExists(url,'teamID')>
	<cfset loc = {}>
	<cfif structKeyExists(url,'teamID')>
		<cfset loc.teamID = url.teamID>
		<cfset loc.compTeamID = url.compTeamID>
	<cfelse>
		<cfset loc.teamID = form.teamID>
		<cfset loc.compTeamID = form.compTeamID>
	</cfif>
	
	<cfquery name="qTeams" datasource="lwfa">
		select teamID,name,'team1' as label from teams where teamID=#loc.teamID#
		UNION
		select teamID,name,'team2' as label from teams where teamID=#loc.compTeamID#
		order by label
	</cfquery>
	<cf_compare teamID=#loc.teamID# compTeamID=#loc.compTeamID#>
	<cfif structKeyExists(cookie,'teamID') AND cookie.teamID eq 1>
		<cfdump var="#comparison#" expand=0>
	</cfif>

	<cfoutput>
	<table cellspacing=10>
		<tr>
			<td colspan=2>Tiebreak comparison between<br /><b>#qTeams.name[1]#</b> and <b>#qTeams.name[2]#</b><P>&nbsp;</P></th>
		</tr>
		<tr>
			<td colspan=2>These teams ARE <cfif comparison[ 'sameDiv' ] neq 0>NOT</cfif> in the same division<P>&nbsp;</P></td>
		</tr>
		<tr>
			<td>
				Head to head winner: 
			</td>
			<td>
				<cfif comparison[ 'tmH2HWinPct' ] gt comparison[ 'compTmH2HWinPct' ]>
					<cfset complete = 1>
					#qTeams.name[1]#<!--- <br/>(#comparison[ 'tmH2HWin' ]#-#comparison[ 'tmH2HLoss' ]# to #comparison[ 'compTmH2HWin' ]#-#comparison[ 'compTmH2HLoss' ]#) --->
				<cfelseif comparison[ 'tmH2HWinPct' ] lt comparison[ 'compTmH2HWinPct' ]>
					#qTeams.name[2]#<!--- <br/>(#comparison[ 'compTmH2HWin' ]#-#comparison[ 'compTmH2HLoss' ]# to #comparison[ 'tmH2HWin' ]#-#comparison[ 'tmH2HLoss' ]#) --->
				<cfelse>
					NONE
				</cfif>			
			</td>
		</tr>
		<cfif comparison[ 'sameDiv' ] eq 0>
			<tr>
				<td>
					Divisional record winner: 
				</td>
				<td>
					<cfif comparison[ 'tmDivWinPct' ] gt comparison[ 'compTmDivWinPct' ]>
						#qTeams.name[1]#<br/>(#comparison[ 'tmDivWin' ]#-#comparison[ 'tmDivLoss' ]# to #comparison[ 'compTmDivWin' ]#-#comparison[ 'compTmDivLoss' ]#)
					<cfelseif comparison[ 'tmDivWinPct' ] lt comparison[ 'compTmDivWinPct' ]>
						#qTeams.name[2]#<br/>(#comparison[ 'compTmDivWin' ]#-#comparison[ 'compTmDivLoss' ]# to #comparison[ 'tmDivWin' ]#-#comparison[ 'tmDivLoss' ]#)
					<cfelse>
						NONE
					</cfif>			
				</td>
			</tr>
		</cfif>
		<tr>
			<td>
				Common opponents winner:
				<cfquery name="qCommon" datasource="lwfa">
					select name from teams where teamID IN (#comparison[ 'commonOpponents' ]#)
				</cfquery>
				<cfsavecontent variable="opps"><cfloop list="#valuelist(qCommon.name)#" index="r"><span style="font-size:10px;">#r#</span>, </cfloop></cfsavecontent>
			</td>
			<td>
				<cfif comparison[ 'tmCommonWinPct' ] gt comparison[ 'compTmCommonWinPct' ]>
					#qTeams.name[1]#<br/>(#comparison[ 'tmCommonWin' ]#-#comparison[ 'tmCommonLoss' ]# to #comparison[ 'compTmCommonWin' ]#-#comparison[ 'compTmCommonLoss' ]#)
				<cfelseif comparison[ 'tmCommonWinPct' ] lt comparison[ 'compTmCommonWinPct' ]>
					#qTeams.name[2]#<br/>(#comparison[ 'compTmCommonWin' ]#-#comparison[ 'compTmCommonLoss' ]# to #comparison[ 'tmCommonWin' ]#-#comparison[ 'tmCommonLoss' ]#)
				<cfelse>
					NONE (#comparison[ 'tmCommonWin' ]#-#comparison[ 'tmCommonLoss' ]# to #comparison[ 'compTmCommonWin' ]#-#comparison[ 'compTmCommonLoss' ]#)
				</cfif>			
			</td>
		</tr>
		<tr>
			<td valign="top">Common opponents:</td>
			<td style="width:150px;">#left(trim(opps),len(opps)-2)#</td>
		</tr>
		<cfif comparison[ 'sameDiv' ] eq 0>
			<tr>
				<td>
					Divisional points scored: 
				</td>
				<td>
					<cfif comparison[ 'tmDivPts' ] gt comparison[ 'compTmDivPts' ]>
						#qTeams.name[1]#<br/>(#numberFormat(comparison[ 'tmDivPts' ],'0.00')# to #numberFormat(comparison[ 'compTmDivPts' ],'0.00')#)
					<cfelseif comparison[ 'tmDivPts' ] lt comparison[ 'compTmDivPts' ]>
						#qTeams.name[2]#<br/>(#numberFormat(comparison[ 'compTmDivPts' ],'0.00')# to #numberFormat(comparison[ 'tmDivPts' ],'0.00')#)
					<cfelse>
						NONE
					</cfif>			
				</td>
			</tr>
		</cfif>
		<tr>
			<td>
				Total points scored: 
			</td>
			<td>
				<cfif comparison[ 'tmPts' ] gt comparison[ 'compTmPts' ]>
					#qTeams.name[1]#<br/>(#numberFormat(comparison[ 'tmPts' ],'0.00')# to #numberFormat(comparison[ 'compTmPts' ],'0.00')#)
				<cfelseif comparison[ 'tmPts' ] lt comparison[ 'compTmPts' ]>
					#qTeams.name[2]#<br/>(#numberFormat(comparison[ 'compTmPts' ],'0.00')# to #numberFormat(comparison[ 'tmPts' ],'0.00')#)
				<cfelse>
					NONE
				</cfif>			
			</td>
		</tr>
		<tr>
			<td>TIEBREAK WINNER:</td>
			<td>
				<cfif tbWinnerTeamID eq qTeams.teamID[1]>
					<b>#qTeams.name[1]#</b>
				<cfelseif tbWinnerTeamID eq qTeams.teamID[2]>
					<b>#qTeams.name[2]#</b>
				<cfelse>
					<b>None yet</b>
				</cfif>
			</td>
		</tr>
	</table>
	</cfoutput>

<cfif structKeyExists(form,'debug')>
<cfdump var="#comparison#">
</cfif>
	
<cfelse>

	<cfquery name="qTeams" datasource="lwfa">
		SELECT		t.name,d.division,t.teamID
		FROM		teams t join divisions d on t.divID=d.divID
		ORDER BY	t.name 
	</cfquery>
	<cfoutput>
	<h2>Compare tiebreakers</h2>
	<form action="#cgi.script_name#" method="post">
		<select name="teamID" size="16" multiple="true">
			<cfloop query="qTeams">
				<option value="#teamID#">#name#</option>
			</cfloop>
		</select>
		<select name="compTeamID" size="16" multiple="true">
			<cfloop query="qTeams">
				<option value="#teamID#">#name#</option>
			</cfloop>
		</select>
		<cfif structKeyExists(url,'debug')>
		<input type="hidden" value="1" name="debug">
		</cfif>
		<input type="submit" name="submit_button" value="Compare">
	</form>
	</cfoutput>

</cfif>
</div>

