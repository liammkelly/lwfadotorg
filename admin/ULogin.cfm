<cfif structKeyExists(form,'uLogin')>

	<CFQUERY name="UserAuth" datasource="lwfa">
	    SELECT 	u.un,u.pw,u.teamID,t.divID,t.name "team",t.nickname
	    FROM		users u join teams t on u.teamID=t.teamID
	    WHERE		u.teamID=#uloginTm#
	</CFQUERY>

    <CFCOOKIE name="lwfauser" expires="NEVER" value="#UserAuth.un#">
    <CFCOOKIE name="lwfapass" expires="NEVER" value="#UserAuth.pw#">
    <CFCOOKIE name="lwfateam" expires="NEVER" value="#UserAuth.team#">
    <CFCOOKIE name="teamID" expires="NEVER" value="#UserAuth.teamID#">
    <CFCOOKIE name="divID" expires="NEVER" value="#UserAuth.divID#">

<cfelse>

<CFQUERY name="allLogin" datasource="lwfa">
	SELECT 		u.*,t.name
	FROM		users u join teams t on t.teamID=u.teamID
	ORDER BY	t.name
</CFQUERY>

<form action="<cfoutput>#cgi.script_name#</cfoutput>" method=post>
<TABLE>
	<CFSET currTm="">
	<CFLOOP query="allLogin">
	<CFOUTPUT>	
	<CFIF currTm neq name>
	<TR>
		<td><input type="radio" name="uloginTm" value="#teamID#"></td>
		<TD>#name#</TD>
	</TR>
	<CFSET currTm=name>
	</CFIF>
	</CFOUTPUT>
	</CFLOOP>
</TABLE>
<input type="submit" name="uLogin">
</form>

</cfif>
