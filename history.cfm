<link rel="stylesheet" type="text/css" href="css/history.css">
<cfset qLWFAHistory = application.cfc.data.getLeagueHistory()>



<center>
<P><h3 align=center>Historical Records</h3>
<table class="overviewTbl" cellspacing=0 cellpadding=0 border=0>
	<tr>
		<th style="border-width:1px;"></th>
		<th>OWNER</th>
		<th>W</th>
		<th>L</th>
		<th>T</th>
		<th>WIN%</th>
		<th>YRS</th>
	</tr>
	<cfoutput query="qLWFAHistory">
	<tr>
		<td class="leftCell">#currentrow#.</td>
		<td>#fullname#</td>
		<td>#wins#</td>
		<td>#losses#</td>
		<td>#ties#</td>
		<td style="font-weight:bold;padding:2px 5px;">#numberformat(winpct,'0.000')#</td>
		<td><cfif (ties+wins+losses) gt 0>#ceiling((ties+wins+losses)/13)#<cfelse>0.000</cfif></td>
	</tr>
	</cfoutput>
</table>
</center>
