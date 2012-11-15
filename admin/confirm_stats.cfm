<cfsetting showdebugoutput="yes">

<!--- BEGIN: Set default values --->
<CFPARAM name="searchTeam" default="BAL">
<CFPARAM name="manualStats" default=0>
<CFPARAM name="searchWeek" default="#application.currwk#">
<CFPARAM name="fuseaction" default="update">
<CFPARAM name="nextfuseaction" default="post_update">
<CFPARAM name="updDate" default="#dateformat(now()+52,'MM/DD')#">
<!--- END: Set default values --->

<cftry>
<CFSWITCH expression="#fuseaction#">
	<CFCASE value="showupdates">
		<cfparam name="tm" default="">
		<cfquery name="seeupdates" datasource="lwfa">
			select * 
			from playerdata 
			where updated='Y' 
			<cfif trim(tm) neq "">and nflteam='#tm#'</cfif>
			order by nflteam
		</cfquery>
		<CFIF seeupdates.recordcount gt 0>
			<TABLE>
				<cfoutput query="seeupdates">
				<TR>
					<Td>#playerID#</Td>
					<td>#line#</td>
					<td>#nflteam#</td>
					<td>#team#</td>
				</TR>	
				</cfoutput>
			</TABLE>
		<CFELSE>
			No updated players.
		</CFIF>
	</CFCASE>
	<CFCASE value="update">
		<CFSET nextfuseaction="post_update">
		<CFIF isDefined("selUpdateTm")>
			<cfquery name="updateteam" datasource="lwfa">
			SELECT players.view, players.first, players.last, players.pos, players.view, playerdata.*
			FROM players INNER JOIN playerdata ON players.nflid=playerdata.playerid
			WHERE playerdata.weekno=#trim(searchWeek)# AND playerdata.nflteam='#trim(selUpdateTm)#'
			ORDER BY players.pos
			</cfquery>
		</CFIF>
		<CFINCLUDE template="dsp_admin_statUpd.cfm">
	</CFCASE>
	<CFCASE value="post_update">
		<!---  --->
		<cfset updates=0>
		<CFSET Inserts=listlen(PlayerID)> 
		<CFLOOP from=1 to=#Inserts# index="i">
			<cfset transactionCleared=0>
			<CFSET gm_PlayerID=listGetAt(PlayerID,i)>
			<CFSET gm_pos=listGetAt(pos,i)>
			<CFSET gm_first=listGetAt(first,i)>
			<CFSET gm_last=listGetAt(last,i)>
			<CFSET gm_nflteam=listGetAt(nflteam,i)>
			<CFSET gm_active=listGetAt(active,i)>
			<CFSET gm_team=listGetAt(team,i)>
			<CFSET gm_sacks=listGetAt(sack,i)>
			<CFSET gm_ff=listGetAt(forcedfum,i)>
			<CFSET gm_defint=listGetAt(int,i)>
			<CFSET gm_fr=listGetAt(fumbrec,i)>
			<CFSET gm_sfgoal=listGetAt(shortFG,i)>
			<CFSET gm_fgoal=listGetAt(regFG,i)>
			<CFSET gm_lfgoal=listGetAt(longFG,i)>
			<CFSET gm_xpts=listGetAt(xp,i)>
			<CFSET gm_passYds=listGetAt(passYds,i)>
			<CFSET gm_passTD=listGetAt(passTD,i)>	
			<CFSET gm_passINT=listGetAt(passINT,i)>
			<CFSET gm_pass2PC=listGetAt(pass2PC,i)>	
			<CFSET gm_rushYds=listGetAt(rushYds,i)>
			<CFSET gm_rushTD=listGetAt(rushTD,i)>	
			<CFSET gm_rush2PC=listGetAt(rush2PC,i)>
			<CFSET gm_recYds=listGetAt(recYds,i)>
			<CFSET gm_recTD=listGetAt(recTD,i)>	
			<CFSET gm_rec2PC=listGetAt(rec2PC,i)>
			<CFSET gm_krYds=listGetAt(krYds,i)>
			<CFSET gm_krTD=listGetAt(krTD,i)>
			<CFSET gm_prYds=listGetAt(prYds,i)>
			<CFSET gm_prTD=listGetAt(prTD,i)>
			<CFSET gm_frTD=listGetAt(frTD,i)>
			<CFSET gm_intTD=listGetAt(intTD,i)>
			<CFSET gm_fumbloss=listGetAt(fumbloss,i)>
			<CFSET gm_tackles=listGetAt(tack,i)>
			<CFSET gm_asstack=listGetAt(asstack,i)>
			<CFSET gm_defintyds=listGetAt(defintyds,i)>

			<!--- BEGIN: build the score total --->
			<!--- <CFSET scoreline=tackles+((sacks+defint)*3)+((inttd+fumtd)*6)+(forced*2)+(passyds/20)+(passTD*4)+((rushyds+recyds)/10)+((recTD+rushTD)*6)-((totalfum+passINT)*2)+(sfgoal*2)+(fgoal*3)+(lfgoal*4)+xpts+pass2pc> --->
			<CF_STAT_COMPILE_NEW
				passyds=#gm_passyds#
				passTD=#gm_passTD#
				passINT=#gm_passINT#
				rushTD=#gm_rushTD#
				rushyds=#gm_rushyds#
				recyds=#gm_recyds#
				recTD=#gm_recTD#
				totalfum=#gm_fumbloss#
				tackles=#gm_tackles#
				sacks=#gm_sacks#
				defint=#gm_defint#
				inttd=#gm_inttd#
				fumrec=#gm_fr#
				fumtd=#gm_frtd#
				forced=#gm_ff#
				lfgoal=#gm_lfgoal#
				sfgoal=#gm_sfgoal#
				fgoal=#gm_fgoal#
				xpts=#gm_xpts#
				kryds=#gm_kryds#
				krtd=#gm_krtd#
				pryds=#gm_pryds#
				prtd=#gm_prtd#
				pass2pc=#gm_pass2pc#
				rec2pc=#gm_rec2pc#
				rush2pc=#gm_rush2pc# 
				defintyds=#gm_defintyds# 
				asstack=#gm_asstack# 
				>
			<cfset gm_scoreline=scoreline>
			<cfset gm_scoredetail=scoredetail>
			<!--- END: build the score total --->
			<!--- <cftransaction> --->
			<cfquery name="checkSeason" datasource="lwfa">
				select 	lastupdweek
				from 	playerstats
				where 	playerID=#trim(gm_PlayerID)#
			</cfquery>
			<cftry>
			<cfif manualStats eq 0>
				<cfquery name="updateWeeklyStats" datasource="lwfa">
					UPDATE 	playerdata 
					SET 			updated='Y', total='#gm_scoreline#', line='#gm_scoredetail#', passyds=#gm_passyds#, passTD=#gm_passTD#, passint=#gm_passint#, rushyds=#gm_rushyds#, rushtd=#gm_rushtd#, recyds=#gm_recyds#, rectd=#gm_rectd#, fumble=#gm_fumbloss#, sfg=#gm_sfgoal#, fg=#gm_fgoal#, lfg=#gm_lfgoal#, xp=#gm_xpts#, tackle=#gm_tackles#, sack=#gm_sacks#, defint=#gm_defint#, ff=#gm_ff#, fr=#gm_fr#, frtd=#gm_frtd#, inttd=#gm_inttd#, kryds=#gm_kryds#, krtd=#gm_krtd#, pryds=#gm_pryds#, prtd=#gm_prtd#, pass2pc=#gm_pass2pc#, rush2pc=#gm_rush2pc#, rec2pc=#gm_rec2pc#, defintyds=#gm_defintyds#, asstack=#gm_asstack#
					WHERE 		playerID=#trim(gm_PlayerID)# AND weekno=#int(trim(currwk))#
				</cfquery>			
			<cfelse>
				<cfquery name="insertWeeklyStats" datasource="lwfa" debug>
					INSERT INTO
						playerdata
							(
							passyds, 
							passTD, 
							passint, 
							rushyds, 
							rushtd, 
							recyds, 
							rectd, 
							fumble, 
							sfg, 
							fg, 
							lfg, 
							xp, 
							tackle, 
							sack, 
							defint, 
							ff, 
							fr, 
							frtd, 
							inttd, 
							kryds, 
							krtd, 
							pryds, 
							prtd, 
							pass2pc, 
							rush2pc, 
							rec2pc,
							asstack,
							defintyds,
							playerID,
							line,
							total,
							weekno,
							team,
							nflteam,
							active,
							updated
							)
						values
							(
							#gm_passyds#,
							#gm_passTD#,
							#gm_passint#,
							#gm_rushyds#,
							#gm_rushtd#,
							#gm_recyds#,
							#gm_rectd#,
							#gm_fumbloss#,
							#gm_sfgoal#,
							#gm_fgoal#,
							#gm_lfgoal#,
							#gm_xpts#,
							#gm_tackles#,
							#gm_sacks#,
							#gm_defint#,
							#gm_ff#,
							#gm_fr#,
							#gm_frtd#,
							#gm_inttd#,
							#gm_kryds#,
							#gm_krtd#,
							#gm_pryds#,
							#gm_prtd#,
							#gm_pass2pc#,
							#gm_rush2pc#,
							#gm_rec2pc#,
							#gm_asstack#,
							#gm_defintyds#,
							#trim(gm_PlayerID)#,
							'#gm_scoredetail#',
							'#gm_scoreline#',
							#application.currwk#,
							'#gm_team#',
							'#gm_nflteam#',
							'#gm_active#',
							'Y'
							)
				</cfquery>
			</cfif>
			<cfcatch>
				Problem updating <b>playerdata</b> table
				#cfcatch.message#<P>
				<cfabort>
			</cfcatch>
			</cftry>
			<cfif checkSeason.recordcount>
				<cfif checkSeason.lastupdweek neq currwk>
					<cfquery name="updateSeasonStats" datasource="lwfa" debug>
						UPDATE 	playerstats 
						SET 	passyds=passyds+#gm_passyds#, passTD=passTD+#gm_passTD#, passint=passint+#gm_passint#, rushyds=rushyds+#gm_rushyds#, rushtd=rushtd+#gm_rushtd#, recyds=recyds+#gm_recyds#, rectd=rectd+#gm_rectd#, fumble=fumble+#gm_fumbloss#, sfg=sfg+#gm_sfgoal#, fg=fg+#gm_fgoal#, lfg=lfg+#gm_lfgoal#, xp=xp+#gm_xpts#, tackle=tackle+#gm_tackles#, sack=sack+#gm_sacks#, defint=defint+#gm_defint#, ff=ff+#gm_ff#, fr=fr+#gm_fr#, frtd=frtd+#gm_frtd#, inttd=inttd+#gm_inttd#, kryds=kryds+#gm_kryds#, krtd=krtd+#gm_krtd#, pryds=pryds+#gm_pryds#, prtd=prtd+#gm_prtd#, pass2pc=pass2pc+#gm_pass2pc#, rush2pc=rush2pc+#gm_rush2pc#, rec2pc=rec2pc+#gm_rec2pc#, asstack=asstack+#gm_asstack#, defintyds=defintyds+#gm_defintyds#, nflteam='#gm_nflteam#', pos='#gm_pos#', fppg=(fppg+#gm_scoreline#)/(games+1), games=games+1,lastupdweek=#application.currwk#
						WHERE 	playerID=#trim(gm_PlayerID)#
					</cfquery>
				</cfif>
			<cfelse>
				<cftry>
				<cfquery name="insertSeasonStats" datasource="lwfa" debug>
					INSERT INTO
						playerstats
							(
							passyds, 
							passTD, 
							passint, 
							rushyds, 
							rushtd, 
							recyds, 
							rectd, 
							fumble, 
							sfg, 
							fg, 
							lfg, 
							xp, 
							tackle, 
							sack, 
							defint, 
							ff, 
							fr, 
							frtd, 
							inttd, 
							kryds, 
							krtd, 
							pryds, 
							prtd, 
							pass2pc, 
							rush2pc, 
							rec2pc,
							asstack,
							defintyds,
							playerID,
							nflteam,
							pos,
							fppg,
							games,
							lastupdweek
							)
						values
							(
							#gm_passyds#,
							#gm_passTD#,
							#gm_passint#,
							#gm_rushyds#,
							#gm_rushtd#,
							#gm_recyds#,
							#gm_rectd#,
							#gm_fumbloss#,
							#gm_sfgoal#,
							#gm_fgoal#,
							#gm_lfgoal#,
							#gm_xpts#,
							#gm_tackles#,
							#gm_sacks#,
							#gm_defint#,
							#gm_ff#,
							#gm_fr#,
							#gm_frtd#,
							#gm_inttd#,
							#gm_kryds#,
							#gm_krtd#,
							#gm_pryds#,
							#gm_prtd#,
							#gm_pass2pc#,
							#gm_rush2pc#,
							#gm_rec2pc#,
							#gm_asstack#,
							#gm_defintyds#,
							#trim(gm_PlayerID)#,
							'#gm_nflteam#',
							'#gm_pos#',
							'#gm_scoreline#',
							1,
							#application.currwk#
							)
				</cfquery>
				<cfcatch>
					Problem updating <b>playerstats</b> table
					#cfcatch.message#<P>
					<cfabort>
				</cfcatch>
				</cftry>
			</cfif>
			<!--- </cftransaction> --->
			<cfset updates=updates+1>
		</CFLOOP>
		<CFLOCATION url="confirm_stats.cfm?updates=#updates#">
	</CFCASE>
</CFSWITCH>
<cfcatch><CFOUTPUT>#cfcatch.Detail# / #cfcatch.Message#</CFOUTPUT></cfcatch></cftry>