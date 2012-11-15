<cfif structKeyExists(form,'active')>

	<cfquery name="qTeams" datasource="lwfa">
		select teamID from standings
	</cfquery>
	<cfloop query="qTeams">
		<cfquery name="updQuery" datasource="lwfa">
			UPDATE		standings
			SET 			claimsRank=#form['rank_' & qTeams.teamID ]#
			WHERE		teamID=#qTeams.teamID#
		</cfquery>
	</cfloop>

<cfelse>
	
	<cfquery name="qQuery" datasource="lwfa">
		SELECT		s.claimsRank,t.name,t.teamID
		FROM		standings s join teams t using (teamID)
		ORDER BY	t.name
	</cfquery>
	
	<cfoutput>
	<form action="#cgi.script_name#" method="post">
	<table>
		<tr>
			<th>Team</th>
			<th>Rank</th>	
		</tr>
		<cfloop query="qQuery">
			<tr>
				<td>#name#</td>
				<td>
					<select name="rank_#teamID#">
						<cfloop from=0 to=16 index="rk">
							<option value="#rk#"<cfif rk eq qQuery.claimsRank> SELECTED</cfif>>#rk#</option>
						</cfloop>
					</select>
				</td>
			</tr>
		</cfloop>
	</table>
	<input type="hidden" name="active" value="1">
	<input type="submit">
	</form>
	</cfoutput>

</cfif>