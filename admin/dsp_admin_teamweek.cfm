<cfif structKeyExists(form,'week')>

	<cfstoredproc datasource="lwfa" procedure="sp_updateTeamWeek">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#form.teamID#">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#form.week#">
	</cfstoredproc>
	
	<cfset totalpoints = 0>
	
	<cfquery name="homepoints" datasource="lwfa">
		select sum(homescore) "ttl" from schedule where homeTeamID = #form.teamID#
	</cfquery>
	<cfif homepoints.ttl neq ''>
		<cfset totalpoints = homepoints.ttl>
	</cfif>

	<cfquery name="awaypoints" datasource="lwfa">
		select sum(awayscore) "ttl" from schedule where awayTeamID = #form.teamID#
	</cfquery>
	<cfif awaypoints.ttl neq ''>
		<cfset totalpoints = totalpoints + awaypoints.ttl>
	</cfif>
	<cfquery name="awaypoints" datasource="lwfa">
		UPDATE standings SET pf = #totalpoints# WHERE teamID = #form.teamID#
	</cfquery>


<cfelse>

	<style>
		body {
			font:bold 12px verdana;
			color:yellow;
		}
	</style>
	<cfquery name="qTeams" datasource="lwfa">
		SELECT *
		from		teams
		order by name
	</cfquery>

	<cfoutput>
	<form action="#cgi.script_name#" method=post>
	Team: 
	<select name="teamID">
		<option>select</option>
		<cfloop query="qTeams">
		<option value="#teamID#">#name#</option>
		</cfloop>	
	</select><br />
	Week:
	<select name="week">
		<option>select</option>
		<cfloop from=1 to=#application.currwk# index="r">
		<option value="#r#">#r#</option>
		</cfloop>
	</select>
	</cfoutput>
<P></P>
	<input type="submit" value="Run Process">
	</form>

</cfif>