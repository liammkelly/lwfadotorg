<cfparam name="url.sqlstatement" default="select now()">

<cfoutput>
<cfsavecontent variable="LOCAL.sqlStatement">
	#url.sqlstatement#
</cfsavecontent>
</cfoutput>

<cfif structKeyExists(form,'execute')>
	
	<cfquery name="qRunSQL" datasource="lwfa" result="result">
		#preserveSingleQuotes( form.execute )#
	</cfquery>
	
	<cfdump var="#result#">
	<cfdump var="#qRunSQL#">
	
<cfelse>
	
	<cfoutput>
	<form action="#cgi.script_name#" method="post">
		<h1>EXECUTE SQL?</h1>
		<h3>#LOCAL.sqlStatement#</h3>
		<input type="hidden" name="execute" value="#LOCAL.sqlStatement#">
		<input type="submit" value="Execute SQL">
	</form>
	</cfoutput>
	
</cfif>