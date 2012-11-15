<cfset qTasks = application.cfc.functions.getScheduledTasks()>



<table style="background-color:#FFF" border=1>
	<tr>
		<th>TASK</th>
		<th>LAST RUN</th>
		<th>INTERVAL</th>
		<th>START TIME</th>
	</tr>
	<cfoutput query="qTasks">
		<cfif task contains "LWFA">
			<tr>
				<td>#task#</td>
				<td>#last_run#</td>
				<td>#interval#</td>
				<td>#start_time#</td>
			</tr>
		</cfif>
	</cfoutput>
</table>

Time: <cfdump var="#now()#">