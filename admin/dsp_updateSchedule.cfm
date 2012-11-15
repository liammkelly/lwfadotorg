<cfif structKeyExists(URL,'wk')>

	<cfquery name="qMatchups" datasource="lwfa">
		SELECT		s.*,
						t.name "away",
						t2.name "home"
		FROM		schedule s left join teams t on s.awayTeamID=t.teamID left join teams t2 on s.homeTeamID=t2.teamID
		WHERE		s.week = #url.wk#
	</cfquery>

	<table border="1" bgcolor="#F0EAE1">
		<cfoutput query="qMatchups">
			<tr>
				<td>#away# @ #home#</td>
				<td><a href="#cgi.script_name#?gameID=#gameID#">edit</a></td>
			</tr>
		</cfoutput>
	</table>

<cfelseif structKeyExists(form,'updGameID')>

	<cfquery name="qUPDGame" datasource="lwfa">
		UPDATE		schedule
		SET				awayTeamID=#form.awayTeamID#,homeTeamID=#form.homeTeamID#
		WHERE			gameID = #updGameID#
	</cfquery>

	Done. <P><a href="<cfoutput>#cgi.script_name#</cfoutput>">Fix another</a>

<cfelseif structKeyExists(URL,'gameID')>

	<cfquery name="qTeams" datasource="lwfa">
		SELECT			teamID,name
		FROM			teams
		ORDER BY		name
	</cfquery>
	<cfquery name="qMatchups" datasource="lwfa">
		SELECT			*
		FROM			schedule
		WHERE			gameID = #url.gameID#
	</cfquery>

	<cfform method="post">
		<table bgcolor="#F0EAE1">
			<cfoutput query="qMatchups">
				<tr>
					<td>AWAY</td>
					<td>
						<cfselect name="awayTeamID" display="name" query="qTeams" value="teamID" queryposition="below" selected="#qMatchups.awayTeamID#">
							<option value=0>TBD</option>
						</cfselect>
					</td>
				</tr>
				<tr>
					<td>HOME</td>
					<td>
						<cfselect name="homeTeamID" display="name" query="qTeams" value="teamID" queryposition="below" selected="#qMatchups.homeTeamID#">
							<option value=0>TBD</option>
						</cfselect>
					</td>
				</tr>
			</cfoutput>
		</table>
		<cfinput type="hidden" name="updGameID" value="#gameID#">
		<cfinput type="submit" name="submit">
	</cfform>	

<cfelse>

	Select a week: 
	<cfform method="get">
	<select name="wk">
		<cfoutput>
		<cfloop from=1 to=16 index="week">
		<option value="#week#">#week#</option>
		</cfloop>
		</cfoutput>
	</select>
	<cfinput type="submit" name="submit">
	</cfform>
	
</cfif>