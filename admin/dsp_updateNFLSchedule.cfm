<cfif structKeyExists(URL,'wk')>

	<cfquery name="qMatchups" datasource="lwfa">
		SELECT		*
		FROM		nflschedule
		WHERE		weekNo = #url.wk# AND opp NOT LIKE '@%'
	</cfquery>

	<style>
		td { font:14px arial; }
	</style>
	<table border="1" bgcolor="#F0EAE1">
		<tr>
			<th>MATCHUP</th>
			<th>DATE</th>
			<th>TIME</th>
			<th>&nbsp;</th>
		</tr>
		<cfoutput query="qMatchups">
			<tr>
				<td>#opp# @ #nfltm#</td>
				<td>#dateformat(scheduledate,'ddd mmmm d')#</td>
				<td>#timeformat(scheduledate,'h:mm tt')#</td>
				<td><a href="#cgi.script_name#?team=#nfltm#&weekno=#url.wk#">edit</a></td>
			</tr>
		</cfoutput>
	</table>

<cfelseif structKeyExists(form,'teams')>

	<cfquery name="qUPDGame" datasource="lwfa">
		UPDATE		nflschedule
		SET				scheduledate='#form.scheduledate#'
		WHERE			weekNo=#form.week# AND nfltm IN (#preserveSingleQuotes(form.teams)#)
	</cfquery>

	Done. <P><a href="<cfoutput>#cgi.script_name#</cfoutput>">Fix another</a>

<cfelseif structKeyExists(URL,'team')>

	<cfquery name="qMatchups" datasource="lwfa">
		SELECT		*
		FROM		nflschedule
		WHERE		nfltm = '#url.team#' AND weekno=#url.weekno#
	</cfquery>

	<cfform method="post">
	<table bgcolor="#F0EAE1">
		<cfoutput query="qMatchups">
			<tr>
				<td>MATCHUP</td>
				<td>#opp# @ #nfltm#</td>
			</tr>
			<tr>
				<td>WEEK</td>
				<td><cfinput type="text" value="#weekno#" name="week"></td>
			</tr>
			<tr>
				<td>DATE</td>
				<td><input class="datepicker" type="text" value="#scheduledate#" name="scheduledate"></td>
			</tr>
		</cfoutput>
	</table>
	<cfinput type="hidden" name="teams" value="'#qMatchups.nfltm#','#qMatchups.opp#'">
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