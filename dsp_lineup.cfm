<cfparam name="url.teamID" default="0">
<cfparam name="url.tradeTeamID" default="23">

<cfif url.teamID gt 0>
	<cfset thisTeamID = url.teamID>
<cfelse>
	<cfset thisTeamID = cookie.teamID>
</cfif>

<cfquery name="qTeam" datasource="lwfa">
	select 	p.*,t.name,t.nickname,ps.seasonPPG,ps.seasonRank,ps.recentPPG,ps.recentRank,x1.opp,x1.tv,ifnull(x1.gametime,'13:00:00') "gametime",x1.date<cfif session[ 'thisWeek2' ] lt 17>,x2.opp opp2<cfif session[ 'thisWeek3' ] lt 17>, x3.opp opp3<cfif session[ 'thisWeek4' ] lt 17>, x4.opp opp4</cfif></cfif></cfif>
	from 	players p 
					join standings s on p.teamID=s.teamID 
					join teams t on p.teamID=t.teamID 
					join playerstats ps on p.playerID=ps.playerid
					left join (
						select * from nflschedule where weekno=#session[ 'thisWeek1' ]#
					) x1 on p.nflteam=x1.nfltm 
					<cfif session[ 'thisWeek2' ] lt 17>
					left join (
						select * from nflschedule where weekno=#session[ 'thisWeek2' ]#
					) x2 on p.nflteam=x2.nfltm 
					<cfif session[ 'thisWeek3' ] lt 17>
					left join (
						select * from nflschedule where weekno=#session[ 'thisWeek3' ]#
					) x3 on p.nflteam=x3.nfltm 
					<cfif session[ 'thisWeek4' ] lt 17>
					left join (
						select * from nflschedule where weekno=#session[ 'thisWeek4' ]#
					) x4 on p.nflteam=x4.nfltm 
					</cfif>
					</cfif>
					</cfif>
	where 	p.teamID = #thisTeamID# 
	order by p.inj desc,p.active desc,p.view
</cfquery>

<table id="teamTbl" cellpadding="0" cellspacing="0">
	<tr>
		<th></th>
		<th></th>
		<th colspan=2>Opp</th>
		<th align="center">TV</th>
		<th align="center">Recent<br /> PPG/Rank</th>
		<th align="center">Season<br /> PPG/Rank</th>
		<th>Upcoming</th>
	</tr>
	<cfoutput query="qTeam">
	<cfset qTeam.gametime[currentrow] = tostring(qTeam.gametime[currentrow])>
	<cfset date = qTeam.date[currentrow]>
	<cfset gametime = qTeam.gametime[currentrow]>
	<cfset ztime = qTeam.gametime[currentrow]>
	<cfset xtime = createDateTime(year(now()),month(qTeam.date[currentrow]),day(qTeam.date[currentrow]),hour(ztime),minute(ztime),0)>
	<cfif cgi.server_name CONTAINS "localhost">
		<cfset currtime = createDateTime(year(now()),month(now()),day(now()),hour(now()),minute(now()),0)>	
	<cfelse>
		<cfset currtime = createDateTime(year(now()),month(now()),day(now()),hour(now())+1,minute(now()),0)>
	</cfif>
	<cfif inj neq 'Y'>
	<tr>
		<td class="nameSect"><a href="playerpage.cfm?playerID=#playerID#">#first# #last#, #nflteam#</a></td>
		<cfif structKeyExists(cookie,'teamID') AND (cookie.teamID eq url.teamID OR url.teamID eq 0)>
		<td>
			<cfif xtime gt currtime>
			<select name="status" class="statusSect"><option value="0"></option><option value="#playerID#"<cfif active eq "Y"> SELECTED</cfif>>#pos#</option></select>
			<cfelse>
			<div style="height:16px;padding-top:7px;"><cfif active eq 'Y'>#pos#<cfelse>&nbsp;</cfif></div>
			<input type="hidden" name="status" value="<cfif active eq 'Y'>#playerID#<cfelse>0</cfif>">
			</cfif>
		</td>
		<cfelse>
		<td style="height:23px;"><cfif active eq 'Y'>#pos#</cfif></td>
		</cfif>
		<td>#opp#</td>
		<td><cfif opp neq 'BYE'>#left(dayofweekasstring(dayofweek(date)),3)# #timeformat(gametime,'h:mm')#</cfif></td>
		<td><cfif opp neq 'BYE'><img src="images/#trim(tv)#_logo.gif" height=13 width=24 /></cfif></td>
		<td class="recentSect<cfif recentRank eq 1> best</cfif>"> <cfif recentPPG neq ''>#numberformat(recentPPG,'0.00')#<cfelse>0.00</cfif> (###recentRank#)</td>
		<td class="seasonSect<cfif seasonRank eq 1> best</cfif>"> <cfif seasonPPG neq ''>#numberformat(seasonPPG,'0.00')#<cfelse>0.00</cfif> (###seasonRank#)</td>
		<td class="oppSect"><cfif structKeyExists(qTeam,'opp2')><cfif qTeam.opp2 eq ''><em>BYE</em><cfelse>#opp2#</cfif><cfif structKeyExists(qTeam,'opp3')>, <cfif qTeam.opp3 eq ''><em>BYE</em><cfelse>#opp3#</cfif><cfif structKeyExists(qTeam,'opp4')>, <cfif qTeam.opp4 eq ''><em>BYE</em><cfelse>#opp4#</cfif></cfif></cfif></cfif></td>
	</tr>
	</cfif>
	</cfoutput>
</table>
<cfif qTeam.inj[1] eq 'Y'>
<div id="injuredPlayersDiv">
<b>Disabled List: </b>
<cfset injuries = 0>
<cfoutput query="qTeam">
<cfif inj eq 'Y'>
<cfif injuries eq 1>|</cfif>
<cfset injuries = 1>
<cfif structKeyExists(cookie,'teamID') AND (cookie.teamID eq url.teamID OR url.teamID eq 0)><img src="images/add.gif" class="activateBtn" id="#playerID#" /> </cfif>#pos# #first# #last#, #nflteam#
</cfif>
</cfoutput>
</div>
</cfif>
