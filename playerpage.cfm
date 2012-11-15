<cfparam name="playerID" default="0">
<cfparam name="playerName" default="">
<cfparam name="noStats" default="0">

<cfif playerID eq 0 AND playerName neq ''>
	<cfquery name="qPlayerID" datasource="lwfa">
		select playerID from players where last='#trim(listGetAt(playerName,1))#'	AND first='#trim(listGetAt(playerName,2))#'
	</cfquery>
	<cfset playerID = qPlayerID.playerID>
</cfif>

<cfset sGameLog = deserializeJson( application.cfc.data.getPlayerGamelog(playerID) )>
<cfset qplayerdata = application.cfc.data.getPlayerData(playerID)>
<cfset qTransHistory = application.cfc.data.getPlayerTransactions(playerID)>

<cfif qplayerdata.recordcount eq 0>
	<cfset noStats = 1>
	<cfquery name="qplayerdata" datasource="lwfa">
		SELECT 	p.first,p.last,p.pos,p.playerID,
						tn.city,tn.nickname,tn.color,
						t.name  "lwfaTeam",
						NULL as mvpList,
						NULL as overallPos 
		FROM 		players p
						LEFT JOIN  teams t on p.teamID=t.teamID
						JOIN teamnames tn on p.nflteam=tn.nflteam
		WHERE		p.playerID=#playerID# 
	</cfquery>
</cfif>


<link rel="stylesheet" type="text/css" href="css/playerpage.css" />
<script language="javascript" type="text/javascript">
	$().ready( function() {
		$('div#gameLogDiv').hide();
		$('div#gameLogBar').toggle( function() {
			$('div#gameLogDiv').slideDown('fast');
			$('div#gameLogBar').width(500);
			$('img#gameLogImg').attr('src','images/up_arrow.gif');
		},function() {
			$('div#gameLogDiv').slideUp('fast');
			$('div#gameLogBar').width(120);
			$('img#gameLogImg').attr('src','images/down_arrow.gif');
		})

		$('#claimPlayerDiv')
			.css({'font-size':12})
			.dialog({modal:true,autoOpen:false,title:'Transaction'});
		
		$('#addPlayerLnk').click( function() {
			$('#claimPlayerDiv')
				.load('dsp_claimPlayer.cfm?playerID=<cfoutput>#playerID#</cfoutput>')
				.dialog('open');
		})
		
	})
</script>
<cfoutput query="qplayerdata">
<div id="playerDiv">
	<div id="playerNameDiv">
		<cfif fileExists(expandPath('images/players/#playerID#.jpg'))>
			<img src="images/players/#playerID#.jpg" id="playerimg" style="margin:0 5px 0 0">
		<cfelse>
			<img src="images/players/unknown.jpg" id="playerimg" style="margin:0 5px 0 0">
		</cfif>
		<img src="images/icon_post.png" id="posticon" style="margin:3px 5px 0 0" onclick="postComment('player',#playerID#,'#first# #last#')">
		<DIV id="firstName">#ucase(first)#</DIV>
		<DIV id="lastName">#ucase(last)#</DIV>
		<DIV id="nflTeam">#pos# - <span style="color:###color#">#ucase(city)# #ucase(nickname)#</span></DIV>
	</div>
	<div id="playerStatsDiv">
		&nbsp;<P><b>LWFA TEAM:</b> <cfif lwfaTeam eq ''>none<cfif structKeyExists(cookie,'teamID')><a href="javascript:;" id="addPlayerLnk"><img src="images/add2.gif" border=0 /></a></cfif><cfelse>#lwfaTeam#</cfif><P>
		<cfif noStats>
			No stats yet this season.
		<cfelse>
			<cfif weekNo eq application.prevwk AND weekPassYds neq ''>
			<P><b>Last Week: </b>
				<cfif pos eq 'QB'>
					#weekPassYds# pass yds, #weekPassTD# pass TD, #weekPassINT# INT, #weekRushYds# rush yds, #weekRushTD# rush TD, #weekFumble# fumbles
				<cfelseif pos eq 'RB'>
					#weekRushYds# rush yds, #weekRushTD# rush TD, #weekRecYds# rec yds, #weekRecTD# rec TD<cfif weekPRYds gt 0>,#weekPRYds# PR yds<cfif weekPRTD gt 0>, #weekPRTD# PR TD</cfif></cfif><cfif weekKRYds gt 0>,#weekKRYds# KR yds<cfif weekKRTD gt 0>, #weekKRTD# KR TD</cfif></cfif>, #weekFumble# fumbles
				<cfelseif pos eq 'WR'>
					#weekRecYds# rec yds, #weekRecTD# rec TD<cfif weekPRYds gt 0>,#weekPRYds# PR yds<cfif weekPRTD gt 0>, #weekPRTD# PR TD</cfif></cfif><cfif weekKRYds gt 0>,#weekKRYds# KR yds<cfif weekKRTD gt 0>, #weekKRTD# KR TD</cfif></cfif>,  #weekFumble# fumbles
				<cfelseif pos eq 'TE'>
					#weekRecYds# rec yds, #weekRecTD# rec TD,  #weekFumble# fumbles
				<cfelseif pos eq 'K'>
					#weekSFG# short FG yds, #weekFG# FG,  #weekLFG# long FG, #weekXP# XP
				<cfelseif pos eq 'D'>
					#weekTackle#/#weekAssTack# tackles, #weekSack# sack,  #weekDefINT# INTs for #weekDefINTYds#, #weekFF# forced fumbles, #weekFR# fumble recoveries<cfif weekPRYds gt 0>,#weekPRYds# PR yds, #weekPRTD# PR TD</cfif><cfif weekKRYds gt 0>,#weekKRYds# KR yds, #weekKRTD# KR TD</cfif>
				</cfif>
			<!--- <cfelse>
				No stats last week --->
			</cfif>
			<P><b>Last Month:</b> 
			<cfif recentPPG neq '' AND recentPassYds neq ''>
				<cfif pos eq 'QB'>
					#recentPassYds# pass yds, #recentPassTD# pass TD, #recentPassINT# INT, #recentRushYds# rush yds, #recentRushTD# rush TD, #recentFumble# fumbles
				<cfelseif pos eq 'RB'>
					#recentRushYds# rush yds, #recentRushTD# rush TD, #recentRecYds# rec yds, #recentRecTD# rec TD<cfif recentPRYds gt 0>,#recentPRYds# PR yds<cfif recentPRTD gt 0>, #recentPRTD# PR TD</cfif></cfif><cfif recentKRYds gt 0>,#recentKRYds# KR yds<cfif recentKRTD gt 0>, #recentKRTD# KR TD</cfif></cfif>, #recentFumble# fumbles
				<cfelseif pos eq 'WR'>
					#recentRecYds# rec yds, #recentRecTD# rec TD<cfif recentPRYds gt 0>,#recentPRYds# PR yds<cfif recentPRTD gt 0>, #recentPRTD# PR TD</cfif></cfif><cfif recentKRYds gt 0>,#recentKRYds# KR yds<cfif recentKRTD gt 0>, #recentKRTD# KR TD</cfif></cfif>,  #recentFumble# fumbles
				<cfelseif pos eq 'TE'>
					#recentRecYds# rec yds, #recentRecTD# rec TD,  #recentFumble# fumbles
				<cfelseif pos eq 'K'>
					#recentSFG# short FG yds, #recentFG# FG,  #recentLFG# long FG, #recentXP# XP
				<cfelseif pos eq 'D'>
					#recentTackle#/#recentAssTack# tackles, #recentSack# sack,  #recentDefINT# INTs for #recentDefINTYds#, #recentFF# forced fumbles, #recentFR# fumble recoveries<cfif recentPRYds gt 0>,#recentPRYds# PR yds, #recentPRTD# PR TD</cfif><cfif recentKRYds gt 0>,#recentKRYds# KR yds, #recentKRTD# KR TD</cfif>
				</cfif>
			<cfif isNumeric(recentPPG)>
				<br /><b>Recent #pos# Rank:</b> ###recentRank# (#recentPPG# PPG<cfif recentLowerPlayer neq '' OR recentHigherPlayer neq ''>, </cfif> <cfif recentLowerPlayer neq ''>ahead of #recentLowerPlayer#</cfif><cfif recentLowerPlayer neq '' AND recentHigherPlayer neq ''> and </cfif><cfif recentHigherPlayer neq ''>behind #recentHigherPlayer#</cfif>)
			</cfif>
			<cfelse>
				No stats over the last month
			</cfif>
			<P><b>Season:</b> 
			<cfif pos eq 'QB'>
				#PassYds# pass yds, #PassTD# pass TD, #PassINT# INT, #RushYds# rush yds, #RushTD# rush TD, #Fumble# fumbles
			<cfelseif pos eq 'RB'>
				#RushYds# rush yds, #RushTD# rush TD, #RecYds# rec yds, #RecTD# rec TD<cfif PRYds gt 0>,#PRYds# PR yds<cfif PRTD gt 0>, #PRTD# PR TD</cfif></cfif><cfif KRYds gt 0>,#KRYds# KR yds<cfif KRTD gt 0>, #KRTD# KR TD</cfif></cfif>, #Fumble# fumbles
			<cfelseif pos eq 'WR'>
				#RecYds# rec yds, #RecTD# rec TD<cfif PRYds gt 0>,#PRYds# PR yds<cfif PRTD gt 0>, #PRTD# PR TD</cfif></cfif><cfif KRYds gt 0>,#KRYds# KR yds<cfif KRTD gt 0>, #KRTD# KR TD</cfif></cfif>,  #Fumble# fumbles
			<cfelseif pos eq 'TE'>
				#RecYds# rec yds, #RecTD# rec TD,  #Fumble# fumbles
			<cfelseif pos eq 'K'>
				#SFG# short FG yds, #FG# FG,  #LFG# long FG, #XP# XP
			<cfelseif pos eq 'D'>
				#Tackle#/#AssTack# tackles, #Sack# sack,  #DefINT# INTs for #DefINTYds#, #FF# forced fumbles, #FR# fumble recoveries<cfif PRYds gt 0>,#PRYds# PR yds, #PRTD# PR TD</cfif><cfif KRYds gt 0>,#KRYds# KR yds, #KRTD# KR TD</cfif>
			</cfif>
			<cfif isNumeric(seasonPPG)>
				<br /><b>Season #pos# Rank:</b> ###seasonRank# (#seasonPPG# PPG<cfif seasonLowerPlayer neq '' OR seasonHigherPlayer neq ''>, </cfif> <cfif seasonLowerPlayer neq ''>ahead of #seasonLowerPlayer#</cfif><cfif seasonLowerPlayer neq '' AND seasonHigherPlayer neq ''> and </cfif><cfif seasonHigherPlayer neq ''> behind #seasonHigherPlayer#</cfif>)
			</cfif>
		</cfif>
		<cfif arraylen( sGameLog.rows )>
		<div id="gameLogBar"><img src="images/down_arrow.gif" id="gameLogImg" />GAME LOG</div>
		<div id="gameLogDiv">
		<table cellpadding="0" cellspacing="0" id="gameLogTbl">
			<tr>
				<th style="width:40px;">Wk</th>
				<th style="width:40px;">Total</th>
				<th style="width:420px;">Line</th>
			</tr>
			<cfloop from="1" to="#arraylen( sGameLog.rows )#" index="gm">
			<tr>
				<td>#sGameLog['rows'][gm]['cell'][1]#</td>
				<td>#sGameLog['rows'][gm]['cell'][2]#</td>
				<td>#sGameLog['rows'][gm]['cell'][3]#</td>
			</tr>
			</cfloop>
		</table>
		</div>
		<P>
		</cfif>
		<cfif mvpList neq ''>
			<cfset mvpWeeks = structnew()>
			<cfloop list="#mvpList#" index="t">
				<cfset mvpWeeks[t] = 1>
			</cfloop>
			<cfset mvpWeeks = structKeyList(mvpWeeks)>
			<div id="mvpWeeksDiv">
				<cfloop list="#mvpWeeks#" index="r">
				<h4>Week MVP for Week #r#</h4><br />
				</cfloop>
			</div>
		</cfif>
		<div id="transHistoryDiv">
		<cfif overallPos neq ''>
		drafted #round#.#selection# (###overallPos# overall) by #draftTeam#
		<cfelse>
		undrafted in 2012
		</cfif><br />
		<cfloop query="qTransHistory">
		#act# #team# on #dateformat(transDate,'m/d/yyyy')#<br />
		</cfloop>
		</div>
	</div>
</div>
</cfoutput>

<div id="claimPlayerDiv"></div>
