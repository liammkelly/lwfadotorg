<CFQUERY NAME="LookStands" datasource="lwfa">
	SELECT		t.name,t.teamID
	FROM		standings s join teams t on s.teamID=t.teamID
	ORDER BY	t.name
</CFQUERY>

<HTML>
<HEAD></HEAD>
<BODY>
<P>Select team to update in standings:
<FORM METHOD="post" ACTION="manual_standings2.cfm">
	<select name=updteam>
	<CFOUTPUT QUERY="LookStands">
	<option value="#teamID#">#name#</option>
	</CFOUTPUT>
	</select>	
	<INPUT TYPE=SUBMIT VALUE="Go">
</FORM>
</BODY>
</HTML>