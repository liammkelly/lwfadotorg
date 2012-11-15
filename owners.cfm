<cfquery name="qOwners" datasource="lwfa">
	select 	t.name,u.email,u.fullname
	from		teams t join users u on t.teamID=u.teamID
	order by t.name
</cfquery>



	<table style="background-color:#F7D3A1;padding:14px;" cellspacing="9">
		<tr>
			<th>Team</th>
			<th>Owner</th>
			<th>Email</th>
		</tr>
		<cfset curTeam = 'x'>
		<cfoutput query="qOwners">
		<tr>
			<td><cfif name neq curTeam>#name#</cfif></td>
			<td>#fullname#</td>
			<td><a href="mailto:#email#">#email#</a></td>
		</tr>
		<cfset curTeam = name>
		</cfoutput>
	</table>

