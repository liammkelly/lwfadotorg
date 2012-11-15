<cfparam name="url.week" default="#application.currwk#">

<cfquery name="qImport" datasource="lwfa">
select (select count(*) from stat_import_log where weekNo=#url.week#) "attempts",
(select count(*) from playerdata where weekNo=#url.week#) "success",
(select concat(first,' ',last,', ',nflteam,' - ',playerID) from players where playerID not in (select playerID from stat_import_log where weekNo=#url.week#) order by nflteam limit 1) "next"
</cfquery>

<!--- <Cfdump var="#qImport#"> --->

<cfoutput query="qImport">
Import attempts: #attempts#<br />
Records added: #success#<br />
Next player: #next#
</cfoutput>