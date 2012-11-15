<cfquery name="qActives" datasource="lwfa">
	SELECT		first,last,nflteam,playerID
	FROM		players
	WHERE		active='Y'
	order by 	playerid
</cfquery>

<script language="javascript" src="/scripts/jquery-1.3.2.min.js"></script>
<script language="javascript" type="text/javascript">
	$().ready( function() {
		$('.updateStats').click( function() {
			var playerID = $(this).attr('playerID');
			var stat = $(this).attr('stat');
			var newValue = $(this).html();
				$.ajax({
					type:		"POST",
					url:		"cfc/admin.cfc",
					data:		{
						method:'updateLiveStats',
						playerID:playerID,
						stat:stat,
						value:newValue,
						currwk:<cfoutput>#application.currwk#</cfoutput>
					},
					success:	function(data) {
					}
				})
		})
	})
</script>
<style>
.updateStats {
	cursor:pointer;
}
</style>

<table>
	<tr>
		<th>Player</th>
		<th>Stat</th>
		<th>Live</th>
		<th>Import</th>
	</tr>
	<cftry>
	<cfprocessingdirective suppresswhitespace="true">
	<cfoutput>
		<cfloop query="qActives">
			<cfquery name="qLiveStats" datasource="lwfa">
				SELECT		*
				FROM		livedata
				WHERE		playerID = #qActives.playerID#
			</cfquery>
			<cfquery name="qImportStats" datasource="lwfa">
				SELECT		*
				FROM		playerdata p join weeks w on p.weekno=w.currwk
				WHERE		playerID = #qActives.playerID#  
			</cfquery>
			<!--- #first# #last#<br /> --->
			<cfloop list="passyds,passTD,passint,rushyds,rushtd,recyds,rectd,fumble,fg,xp,tackle,sack,defint,ff,fr,inttd,kryds,krtd,pryds,prtd,asstack,defintyds" index="LOCAL.statName">
				<cfif qLiveStats[ LOCAL.statname ][1] neq qImportStats[ LOCAL.statname ][1] AND qImportStats[ LOCAL.statname ][1] neq '' AND qLiveStats[ LOCAL.statname ][1] neq ''>
					<tr id="row#qActives.currentrow#">
						<td>#qActives.first[ qActives.currentrow]# #qActives.last[ qActives.currentrow]#, #qActives.nflteam[ qActives.currentrow]# [#qActives.playerid[ qActives.currentrow]#]</td>
						<td>#LOCAL.statname#</td>
						<td><div class="updateStats" stat="#LOCAL.statname#" playerID="#qActives.playerID#">#qLiveStats[ LOCAL.statname ][1]#</div></td>
						<td><div class="updateStats" stat="#LOCAL.statname#" playerID="#qActives.playerID#">#qImportStats[ LOCAL.statname ][1]#</div></td>
					</tr>
<!--- 				<cfelse>
					<tr>
						<td>#qActives.first[ qActives.currentrow]# #qActives.last[ qActives.currentrow]#, #qActives.nflteam[ qActives.currentrow]#</td>
						<td><div class="updateStats" stat="#LOCAL.statname#" playerID="#qActives.playerID#">#qLiveStats[ LOCAL.statname ][1]#</div></td>
						<td><div class="updateStats" stat="#LOCAL.statname#" playerID="#qActives.playerID#">#qImportStats[ LOCAL.statname ][1]#</div></td>
					</tr> --->
				</cfif>
			</cfloop>
		</cfloop>
	</cfoutput>
	</cfprocessingdirective>
	<cfcatch type="any"><cfdump var="#cfcatch#"><cfabort></cfcatch>
	</cftry>
</table>