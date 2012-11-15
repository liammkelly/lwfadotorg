<cfif structKeyExists(url,'clear') AND url.clear eq 1>
	<cfset structDelete(session,'cfc')>
</cfif>

<cfdump label="application" var="#application#" expand="0">

<cfdump label="CGI" var="#CGI#" expand="0">

<cfdump label="cookie" var="#cookie#" expand="0">

<cfdump label="server" var="#server#" expand="0">

<cfdump label="session" var="#session#" expand=0>
