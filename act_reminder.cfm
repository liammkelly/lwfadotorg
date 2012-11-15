<cfif structKeyExists(form,'email')>
	<cfquery name="qReminder" datasource="lwfa">
		SELECT		un,pw,email,fullname
		FROM		users
		WHERE		0=0
						<cfif form.email neq ''>AND email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#"></cfif>
						<cfif form.username neq ''>AND un = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.username#"></cfif>
	</cfquery>
	<cfmail 
			to="#qReminder.email#" 
			from="reminder@blue-vellum.com" 
			subject="LWFA.org Password Reminder" 
			username="liam@blue-vellum.com" 
			password="wan99ker" 
			server="mail.blue-vellum.com" 
			type="html"
			>
	<html><body>
	<table border=0>
		<tr>
			<td colspan=2>User info for #qReminder.fullname#</td>
		</tr>
		<tr>
			<td>Username:</td><td>#qReminder.un#</td>
		</tr>
		<tr>
			<td>Password:</td><td>#qReminder.pw#</td>
		</tr>
	</table>
	</body></html>
	</cfmail>
	<script>parent.$('A#reminderLink').html('password reminder sent');parent.tb_remove();</script>
	<cfabort>
</cfif>

<form action="<cfoutput>#cgi.script_name#</cfoutput>" method="post">
	<table border=0>
		<tr>
			<td style="font:bold 12px verdana;">Username:</td><td><input type="text" name="username"></td>
		</tr>
		<tr>
			<td style="font:bold 12px verdana;">or email:</td><td><input type="text" name="email"></td>
		</tr>
		<tr>
			<td colspan=2 align=right><input type="submit" value="Send Reminder"></td>
		</tr>
	</table>
</form>