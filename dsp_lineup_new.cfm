<cfparam name="url.teamID" default="0">
<cfparam name="url.tradeTeamID" default="23">

<cfif url.teamID gt 0>
	<cfset thisTeamID = url.teamID>
<cfelse>
	<cfset thisTeamID = cookie.teamID>
</cfif>

<cfquery name="qTeam" datasource="lwfa">
	select 	p.*,t.name,t.nickname,ps.seasonPPG,ps.seasonRank,ps.recentPPG,ps.recentRank,x1.scheduleDate,x1.opp,x1.tv,x1.scheduleDate<cfif (application.currwk-1) lt 17>,x2.opp "opp2"<cfif (application.currwk-2) lt 17>, x3.opp "opp3"<cfif (application.currwk-3) lt 17>, x4.opp "opp4"</cfif></cfif></cfif>
	from 	players p 
				join standings s on p.teamID=s.teamID 
				join teams t on p.teamID=t.teamID 
				join playerstats ps on p.playerID=ps.playerid
				left join (
					select * from nflschedule where weekno=#application.currwk#
				) x1 on p.nflteam=x1.nfltm 
				<cfif (application.currwk-1) lt 17>
					left join (
						select * from nflschedule where weekno=#application.currwk+1#
					) x2 on p.nflteam=x2.nfltm 
					<cfif (application.currwk-2) lt 17>
						left join (
							select * from nflschedule where weekno=#application.currwk+2#
						) x3 on p.nflteam=x3.nfltm 
						<cfif (application.currwk-3) lt 17>
							left join (
								select * from nflschedule where weekno=#application.currwk+3#
							) x4 on p.nflteam=x4.nfltm 
						</cfif>
					</cfif>
				</cfif>
	where 	p.teamID = #thisTeamID# 
	order by p.inj,p.active desc,p.view
</cfquery>

<cfset sLineup = structnew()>
<cfset activeCount = 0>
<cfloop query="qTeam">
	<cfif active eq 'Y'>
		<cfif NOT structKeyExists(sLineup, pos)>
			<cfset sLineup[ pos ] = 0>	
		</cfif>
		<cfset sLineup[ pos ] += 1>	
		<cfif qTeam.active eq 'Y'>
			<cfset activeCount += 1>	
		</cfif>
	</cfif>
</cfloop>
<cfset blankrow = ''>
<cfset insertoffset = 0>
<cfif activeCount lt 8 AND activeCount gt 0>
	<cfif sLineup[ 'WR' ] eq 1>
		<cfset blankrow = 'WR'>
		<cfset insertoffset = 4>
	<cfelseif NOT structKeyExists(sLineup,'TE')>	
		<cfset blankrow = 'TE'>
		<cfset insertoffset = 6>
	<cfelseif NOT structKeyExists(sLineup,'QB')>	
		<cfset insertoffset = 1>
		<cfset blankrow = 'QB'>
	<cfelseif NOT structKeyExists(sLineup,'K')>	
		<cfset blankrow = 'K'>
		<cfset insertoffset = 7>
	<cfelseif NOT structKeyExists(sLineup,'D')>	
		<cfset blankrow = 'D'>
		<cfset insertoffset = 8>
	<cfelse>
		<cfset blankrow = 'RB'>
		<cfset insertoffset = 2>
	</cfif>
</cfif>

<table id="teamTbl" cellpadding="0" cellspacing="0">
	<tr>
		<th>Pos</th>
		<th></th>
		<th></th>
		<th colspan=2>Opp</th>
		<th align="center">TV</th>
		<th align="center">Recent<br /> PPG/Rank</th>
		<th align="center">Season<br /> PPG/Rank</th>
		<th>Upcoming</th>
	</tr>
	<cfoutput query="qTeam">
		<cfif insertoffset eq qTeam.currentrow>
			<tr id="0">
				<td class="posSect">#blankrow#</td>
				<td class="nameSect">&nbsp;</td>
				<cfif structKeyExists(cookie,'teamID') AND (cookie.teamID eq url.teamID OR url.teamID eq 0)>
					<td>	
						<button class="lineupBtn" locked="#1 eq 0#" active="Y" pos="#blankrow#" rowid="0" playerID="0">move</button>
					</td>
				<cfelse>
					<td style="height:23px;width:20px;">&nbsp;</td>
				</cfif>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td class="recentSect"> &nbsp;</td>
				<td class="seasonSect"> &nbsp;</td>
				<td class="oppSect"> &nbsp;</td>
			</tr>
		</cfif>
		<!---  
		<cfset qTeam.gametime[currentrow] = tostring(qTeam.gametime[currentrow])>
		<cfset date = qTeam.scheduleDate[currentrow]>
		<cfset gametime = qTeam.gametime[currentrow]>
		<cfset ztime = qTeam.gametime[currentrow]>
		<cfset xtime = createDateTime(year(now()),month(qTeam.scheduleDate[currentrow]),day(qTeam.scheduleDate[currentrow]),hour(ztime),minute(ztime),0)>
		--->
		<cfif cgi.server_name CONTAINS "localhost">
			<cfset LOCAL.currtime = createODBCDatetime(now()-2)>
		<cfelse>
			<cfset theHour = hour(now())+1>
			<cfif theHour gt 23>
				<cfset theHour = 23>
			</cfif>
			<cfset LOCAL.currtime = createDateTime(year(now()),month(now()),day(now()),theHour,minute(now()),0)>
		</cfif>
		<tr id="#playerID#"<cfif inj eq 'Y'> class="inj"</cfif>>
			<td class="posSect"><cfif inj eq 'Y'><img src="images/red_cross.jpg" class="activateBtn" id="#playerID#" /><cfelse><cfif active eq 'y'>#pos#<cfelse>BN</cfif></cfif></td>
			<td class="nameSect"><a href="playerpage.cfm?playerID=#playerID#">#first# #last#, #nflteam#</a></td>
			<cfif (structKeyExists(cookie,'teamID') AND (cookie.teamID eq url.teamID OR url.teamID eq 0))>
			<td>	
				<!--- #qTeam.scheduleDate[currentrow]#//#LOCAL.currtime# --->
				<!--- <select name="status" class="statusSect"><option value="0"></option><option value="#playerID#"<cfif active eq "Y"> SELECTED</cfif>>#pos#</option></select> --->
				<button class="<cfif qTeam.scheduleDate[currentrow] lt LOCAL.currtime>locked</cfif>lineupBtn<cfif inj eq 'Y'> DL</cfif>" locked="#qTeam.scheduleDate[currentrow] lt LOCAL.currtime#" active="#qTeam.active[currentrow]#" pos="#pos#" rowid="#currentrow#" playerID="#playerid#">move</button>
			</td>
			<cfelse>
			<td style="height:23px;width:20px;">&nbsp;</td>
			</cfif>
			<td>#opp#</td>
			<td><cfif opp neq 'BYE'>#left(dayofweekasstring(dayofweek(qTeam.scheduleDate)),3)# #timeformat(qTeam.scheduleDate,'h:mm')#</cfif></td>
			<td><cfif opp neq 'BYE'><img src="images/#trim(lcase(tv))#_logo.gif" height=13 width=24 /></cfif></td>
			<td class="recentSect<cfif recentRank eq 1> best</cfif>"> <cfif recentPPG neq ''>#numberformat(recentPPG,'0.00')#<cfelse>0.00</cfif> (###recentRank#)</td>
			<td class="seasonSect<cfif seasonRank eq 1> best</cfif>"> <cfif seasonPPG neq ''>#numberformat(seasonPPG,'0.00')#<cfelse>0.00</cfif> (###seasonRank#)</td>
			<td class="oppSect"><cfif structKeyExists(qTeam,'opp2')><cfif qTeam.opp2 eq ''><em>BYE</em><cfelse>#opp2#</cfif><cfif structKeyExists(qTeam,'opp3')>, <cfif qTeam.opp3 eq ''><em>BYE</em><cfelse>#opp3#</cfif><cfif structKeyExists(qTeam,'opp4')>, <cfif qTeam.opp4 eq ''><em>BYE</em><cfelse>#opp4#</cfif></cfif></cfif></cfif></td>
		</tr>
		<cfif qTeam.active eq 'Y' AND  qTeam.active[qTeam.currentrow+1] eq 'N'>
			<tr id="-1" class="benchRow">
				<td class="posSect">BN</td>
				<td class="nameSect">&nbsp;</td>
				<td><button class="lineupBtn" locked="#1 eq 0#" active="N" playerID="-1" pos="QB" rowid="0" id="benchRowBtn" playerID="0">move</button></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td class="recentSect"> &nbsp;</td>
				<td class="seasonSect"> &nbsp;</td>
				<td class="oppSect"> &nbsp;</td>
			</tr>		
		</cfif>
	</cfoutput>
</table>