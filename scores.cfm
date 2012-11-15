<cfsilent>
<cfparam default="#application.currwk#" name="thisWeek">
<CFIF NOT isDefined('URL.wk') or URL.wk eq application.currwk>
	<CFSET seeWeek=application.currwk>
<CFELSE>
	<CFSET seeWeek=URL.wk>
</CFIF>
<CFIF ((seeWeek gt application.currwk) and (NOT isDefined('URL.admin'))) OR (seeWeek eq application.currwk AND dayofweek(now()) lt 6 AND dayofweek(now()) gt 2)>
	<CFQUERY name="getWeek" datasource="lwfa">
		SELECT 	p.first,p.last,p.nflteam,p.pos,p.teamID,'' as source, (select (sum(total)/count(total)) as newFPPG from playerdata where playerID=p.playerID) as total,ucase(n.opp) as line,n.weekno
		FROM		(players p LEFT JOIN nflschedule n ON p.nflteam=n.nfltm) 
		WHERE		p.active='Y' and p.inj='N' and n.weekno=#seeWeek#
		ORDER BY view
	</CFQUERY>
	<CFSET status="preview">
	<!--- Set temporary week --->
<cfelseif seeWeek eq application.currwk>
	<CFQUERY name="getWeek" datasource="lwfa">
		SELECT 	p.view,p.first,p.last,p.nflteam,p.pos,p.teamID,
				pd.line,pd.total,pd.source,
				nt.weekno
		FROM	players p	
					JOIN v_current_stats pd using (playerID)
					JOIN nflschedule nt on (nt.nfltm=p.nflteam AND nt.weekNo=#application.currwk# )
		WHERE	nt.scheduleDate < now() AND p.active='Y'
		UNION
		SELECT 	p.view,p.first,p.last,p.nflteam,p.pos,p.teamID,
				nt.opp as line,s.seasonPPG as total,'TBD' as source,
				nt.weekno
		FROM	players p 
					JOIN nflschedule nt ON (nt.nfltm=p.nflteam AND nt.weekNo=#application.currwk#)
					JOIN playerstats s using (playerID)
		WHERE	nt.scheduleDate > now() AND p.active='Y'
		ORDER BY view
	</CFQUERY>
<CFELSE>	
	<cfset zdate=createODBCdate(now())>
	<CFQUERY name="getWeek" datasource="lwfa">
		SELECT 	p.view,p.first,p.last,pd.nflteam,p.pos,t.teamID,'' as source, pd.line,pd.total,pd.weekno
		FROM		(players p LEFT JOIN nflschedule n ON p.nflteam=n.nfltm) left join playerdata pd on p.playerID=pd.playerid left join teams t on p.teamID=t.teamID
		WHERE		p<cfif seeWeek neq application.currwk>d</cfif>.active='Y' and pd.weekno=#seeWeek# and n.gamedate < #zdate#
		UNION
		SELECT 	p.view,p.first,p.last,p.nflteam,p.pos,t.teamID,'' as source, ifnull(l.line,n.opp) as line,ifnull(l.total,(select (sum(total)/count(total)) as newFPPG from playerdata where playerID=p.playerID)) as total,n.weekno
		FROM		(players p LEFT JOIN nflschedule n ON p.nflteam=n.nfltm) left join teams t on p.teamID=t.teamID left join v_current_stats l on p.playerID=l.playerID 
		WHERE		p.active='Y' and p.inj='N' and n.weekno=#seeWeek# and n.gamedate >= #zdate#
		ORDER BY view
	</CFQUERY>
	<CFSET status="scores">
</CFIF>


<cfquery name="qMan" dbtype="query">
	select 		sum(total) as projected,teamID as teamSum
	from 		getWeek
	where		line <> 'BYE'
	group by 	teamID
</cfquery>

<CFQUERY name="getTeams" datasource="lwfa">
	SELECT homeTeamID as homers,awayTeamID as awayers 
	FROM 	schedule 
	WHERE 	week=#seeWeek#
</CFQUERY>
<CFSET homeList = valueList(getTeams.homers)>
<CFSET awayList = valueList(getTeams.awayers)>

<CFSET homescore=arraynew(1)>
<CFSET awayscore=arraynew(1)>

<CFIF isDefined('URL.wk')>
	<CFSET titleStr="LWFA: Week "&#URL.wk#&" Boxscores">
<CFELSE>
	<CFSET titleStr="LWFA: Current Boxscores">
</CFIF>
<cfset no_prev_days="2,7,1">
</cfsilent>


<!--- <cf_lwfa_header pgName=#titleStr#> --->
<STYLE>
td {
	font:12px Verdana;
}
#scores {
	width:620px;
}
.weeks A {
	font:11px arial;
	color:black;
	text-decoration:none;
}
SPAN.scoreTm {
	font:bold 16px verdana;
}
 SPAN.scoreNickname {
	font:bold 12px verdana;
}
</STYLE>
<STYLE media="print">
td {
	font:12px Verdana;
}
table#header {
	display:none;
}
span.pastWeeks {
	display:none;
}
span.viewWeek, span.divider {
	display:none;
}
</STYLE>

<cfif dayofweek(now()) eq 1>
	<cfquery name="qQuery" datasource="lwfa">
		SELECT		updateTime
		FROM		liveUpdate
	</cfquery>
	Last update: <cfoutput>#datediff('n',qQuery.updateTime,now())#:#numberformat(datediff('s',qQuery.updateTime,now()) mod 60,'00')#</cfoutput> ago<br />
</cfif>


<CFQUERY name="getNumGames" datasource="lwfa">
	select 	count(homeTeamID) as games 
	from 	schedule 
	where 	week=#seeWeek#
</CFQUERY>
<TABLE id="scores">
	<!--- <tr>
		<td align="center" class="weeks">
		Weeks: <cfloop from=1 to=16 index="w">
		<cfoutput>
		<cfif w neq seeWeek><a href="/2010/scores.cfm?wk=#w#"><cfelse><B></cfif>#w#<cfif w neq seeWeek></a><cfelse></B></cfif><cfif w neq 16> &bull;</cfif>
		</cfoutput>
		</cfloop>
		</td>
	</tr> --->
	<!--- 
	<tr>
		<th>WEEK <cfoutput>#seeWeek#</cfoutput> SCORES</th>
	</tr>
	--->
	<TR>
		<TD>
		<CFLOOP from="1" to="#getNumGames.games#" index="L">
		<cfoutput>
		<CFSET thisAwayTeam=ListGetAt(awaylist,L)>
		<CFQUERY name="seeAwayHead" datasource="lwfa">
			SELECT t.name,t.nickname,s.win,s.loss,s.tie,t.teamID 
			FROM 	standings s join teams t on s.teamID=t.teamID 
			WHERE t.teamID=#thisAwayTeam#
		</CFQUERY>
		<CFSET thisHomeTeam=ListGetAt(homelist,L)>
		<CFQUERY name="seeHomeHead" datasource="lwfa">
			SELECT t.name,t.nickname,s.win,s.loss,s.tie,t.teamID 
			FROM 	standings s join teams t on s.teamID=t.teamID 
			WHERE t.teamID=#thisHomeTeam#
		</CFQUERY>
		<TABLE class="scorebox" id="box#L#">
			<TR>
				<TD valign="top">
				<TABLE border=1 width="290">
					<TR>
						<TH colspan=4 align="center">
							<table cellpadding="0" cellspacing="3">
								<tr>
									<!---  
									<td rowspan=3>
										<A href="/2010/teampage.cfm?teamID=#seeAwayHead.teamID#">
										<IMG align="absmiddle" SRC="/2010/_images/helmets/#left(ucase(rereplace(seeAwayHead.name,'[^A-Za-z\.]','','ALL')),3)#.gif" width=70 height=57 border=0>
										</a>
									</td>
									--->
									<td valign="bottom">
										<SPAN class="scoreTm">
											#ucase(seeAwayHead.name)#
										</SPAN>
										<SPAN class="scoreNickname">
											<!--- #ucase(seeAwayHead.nickname)# --->  (#seeAwayHead.win#-#seeAwayHead.loss#-#seeAwayHead.tie#)
										</SPAN>
									</td>
								</tr>
							</table>
						</TH>
					</TR>
					<CFSET awayscore[L]=0>
					<CFLOOP query="getWeek">
					<CFIF teamID eq ListGetAt(awaylist,L)>
						<CFSET plr="#left(first,1)#. #last#, #nflteam#">
						<TR>
							<TD>#pos#</TD>
							<TD>#plr#</TD>
							<TD><cfif line eq "BYE"><em>#line#</em><cfset projPts = 0><cfelse>#line#<cfset projPts = total></cfif></TD>
							<TD><CFIF (len(line) lt 4 OR line contains '@') AND len(line) lt 5 and no_prev_days contains dayofweek(now())>0.00<cfelse>#numberformat(projPts,'0.00')#<cfif source eq 'LIVE'>*</cfif></cfif></TD>
						</TR>
						<CFIF (len(line) gt 4 OR line does not contain '@') AND len(line) gt 3>
							<CFSET awayscore[L]=awayscore[L]+total>
						</CFIF>
					</CFIF>
					</CFLOOP>
					<!--- <CFIF seeWeek gt 13 and seeWeek lt 16>
						<TR>
							<TD colspan=3>&nbsp;</TD>
							<TD>&nbsp;</TD>
						</TR>
					</CFIF> --->
					<CFIF awayscore[L] gt 0>
						<TR>
							<TD colspan=3>TOTAL</TD>
							<TD style="font-weight:bold;color:990000;">#numberformat(awayscore[L],'0.00')#</TD>
						</TR>
					</CFIF>
					<cfif dayofweek(now()) neq 7 AND dayofweek(now()) neq 1 AND dayofweek(now()) neq 2 AND wk gt application.currwk>
						<TR>
							<TD colspan=3>PROJECTED</TD>
							<TD style="font-weight:bold;color:990000;">
							<cfloop query="qMan">
							<cfif teamSum eq thisAwayTeam>
							#numberformat(projected,'0.00')#
							</cfif>
							</cfloop>
							</TD>
						</TR>						
					</cfif>
				</TABLE>
				</TD>
				<TD style="width:20px">
				</TD>
				<TD valign="top">
				<TABLE border=1 width="290">
					<TR>
						<TH colspan=4 align="center">
							<table cellpadding="0" cellspacing="3">
								<tr>
									<!---  
									<td rowspan=3>
										<A href="/2010/teampage.cfm?teamID=#seeHomeHead.teamID#">
											<IMG align="absmiddle" SRC="/2010/_images/helmets/#left(ucase(rereplace(seeHomeHead.name,'[^A-Za-z\.]','','ALL')),3)#.gif" width=70 height=57 border=0>
										</a>
									</td>
									--->
									<td valign="bottom">
										<SPAN class="scoreTm">#ucase(seeHomeHead.name)#</SPAN>
										<SPAN class="scoreNickname"><!--- #ucase(seeHomeHead.nickname)# ---> (#seeHomeHead.win#-#seeHomeHead.loss#-#seeHomeHead.tie#)</SPAN>
									</td>
								</tr>
							</table>
						</TH>
					</TR>
					<!--- <CFIF seeWeek gt 13 and seeWeek lt 16>
						<CFSET homescore[L]=3>
					<CFELSE>
						<CFSET homescore[L]=0>
					</CFIF> --->
					<CFSET homescore[L]=0>
					<CFLOOP query="getWeek">
					<CFIF teamID eq ListGetAt(homelist,L)>
						<CFSET plr="#left(first,1)#. #last#, #nflteam#">
						<TR>
							<TD>#pos#</TD>
							<TD>#plr#</TD>
							<TD><cfif line eq "BYE"><em>#line#</em><cfset projPts = 0><cfelse>#line#<cfset projPts = total></cfif></TD>
							<TD><CFIF (len(line) lt 4 OR line contains '@') AND len(line) lt 5 and no_prev_days contains dayofweek(now())>0.00<cfelse>#numberformat(projPts,'0.00')#</cfif></TD>
						</TR>
						<CFIF (len(line) gt 4 OR line does not contain '@') AND len(line) gt 3>
							<CFSET homescore[L]=homescore[L]+total>
						</CFIF>
					</CFIF>
					</CFLOOP>
					<!--- <CFIF seeWeek gt 13 and seeWeek lt 16>
						<TR>
							<TD colspan=3>HOME FIELD</TD>
							<TD>3</TD>
						</TR>
					</CFIF> --->
					<CFIF homescore[L] gt 0>
						<TR>
							<TD colspan=3>TOTAL</TD>
							<TD style="font-weight:bold;color:990000;">#numberformat(homescore[L],'0.00')#</TD>
						</TR>
					</CFIF>
					<cfif dayofweek(now()) neq 7 AND dayofweek(now()) neq 1 AND dayofweek(now()) neq 2 AND wk gt application.currwk>
						<TR>
							<TD colspan=3>PROJECTED</TD>
							<TD style="font-weight:bold;color:990000;">
							<cfloop query="qMan">
							<cfif teamSum eq thisHomeTeam>
							#numberformat(projected,'0.00')#
							</cfif>
							</cfloop>
							</TD>
						</TR>						
					</cfif>
				</TABLE>
				</TD>
			</TR>
		</TABLE>
		</cfoutput>
		<P>
		</CFLOOP>
		</TD>
	</TR>
</TABLE>

<!--- </cf_lwfa_header> --->