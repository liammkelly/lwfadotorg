<cfset jsonSchedule = application.cfc.data.getSchedule(teamID=thisTeamID)>
<cfset sSchedule = deserializeJson( jsonSchedule )>

<cfoutput>
<div id="teamScheduleDiv">
	<div class="teamWeek" align="center" style="background-color:##D1D2D1"><h4>2012 SCHEDULE</h4></div>
	<div class="teamWeek schedHeader">
		<div class="teamWeekNo schedHeader">Wk</div>
		<div class="teamWeekOpponent schedHeader">Opponent</div>
		<div class="teamWeekScore schedHeader">Final Score</div>
		<div class="teamWeekStar schedHeader">Top Player</div>
	</div>
	<cfloop from=1 to="#arraylen(sSchedule['records'])#" index="r">
		<div class="teamWeek" id="teamWeek_#r#">
			<div class="teamWeekNo">#sSchedule['records'][ r ][ 'WEEK' ]#</div>
			<div class="teamWeekOpponent">
				<cfif sSchedule['records'][ r ][ 'LOCATION' ] eq 'away'>
					at #sSchedule['records'][ r ][ 'HOMETEAM' ]#
				<cfelse>
					vs #sSchedule['records'][ r ][ 'AWAYTEAM' ]#
				</cfif>
			</div>
			<div class="teamWeekScore">
				<cfif sSchedule['records'][ r ][ 'AWAYSCORE' ] gt 0>
					<A href="box.cfm?showheader=false&gameID=#sSchedule['records'][ r ][ 'GAMEID' ]#&width=600&height=370" class="thickbox">
					#sSchedule['records'][ r ][ 'RESULT' ]# 
					<cfif sSchedule['records'][ r ][ 'AWAYTEAMID' ] eq cookie.teamID>
						<cfif sSchedule['records'][ r ][ 'RESULT' ] eq "W">
							#sSchedule['records'][ r ][ 'AWAYSCORE' ]#-#sSchedule['records'][ r ][ 'HOMESCORE' ]# 
						<cfelse>
							#sSchedule['records'][ r ][ 'HOMESCORE' ]#-#sSchedule['records'][ r ][ 'AWAYSCORE' ]# 
						</cfif>
					<cfelse>
						<cfif sSchedule['records'][ r ][ 'RESULT' ] eq "W">
							#sSchedule['records'][ r ][ 'HOMESCORE' ]#-#sSchedule['records'][ r ][ 'AWAYSCORE' ]# 
						<cfelse>
							#sSchedule['records'][ r ][ 'AWAYSCORE' ]#-#sSchedule['records'][ r ][ 'HOMESCORE' ]# 
						</cfif>
					</cfif>
					</A>
				</cfif>
			</div>
			<div class="teamWeekStar"><cfif sSchedule['records'][ r ][ 'WEEK' ] lt application.currwk>#sSchedule['records'][ r ][ 'POS' ]# #sSchedule['records'][ r ][ 'FIRST' ]# #sSchedule['records'][ r ][ 'LAST' ]# -- #sSchedule['records'][ r ][ 'TOTAL' ]#</cfif></div>
		</div>
	</cfloop>
</div>
</cfoutput>