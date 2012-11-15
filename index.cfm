<cfif cgi.HTTP_USER_AGENT contains "iphone" OR ( cgi.HTTP_USER_AGENT contains "ipad" AND structKeyExists(cookie,'teamID') AND cookie.teamID eq 6 )>
	<cflocation url="/m/">
</cfif>

<cfset variables.teamID = 0>
<cfif structKeyExists(cookie,'teamID')>
	<cfset variables.teamID = cookie.teamID>
</cfif>

<!--- GET PENDING TRADES --->
<cfset sPendingDeal = deserializeJson( application.cfc.data.getPendingTrades() )> 
<!--- GET STANDINGS --->
<cfif NOT structKeyExists(session,'qStandings')>
	<cfset application.cfc.data.loadStandings()>
</cfif>
<!--- GET SCORES --->
<cfset sPrevWeekScores = deserializeJson( application.cfc.scores.getScores(application.prevwk) )> 
<cfset sCurrWeekScores = deserializeJson( application.cfc.scores.getScores(application.currwk) )> 
<!--- GET WEEK MVP --->
<cfset sWeekStar = deserializeJson( application.cfc.data.getWeekMVP(application.prevwk) )>
<!--- GET WEEK MVP --->
<cfset aTrades = deserializeJson( application.cfc.data.getTrades() )>
<!--- GET POSTS --->
<!--- TODO: MOVE TO CFC CALL --->
<cfquery name="qPosts" datasource="#application.dsn#">
	/* MATCHUP POSTS */
	SELECT 		p.postID,NULL as subject,p.fullname,p.teamID,p.comment,'' as link,
				p.parentPostID "itemID",
				"post" as type
	FROM 		v_posts_post p
	WHERE		p.parentPostID = 0
	UNION
	/* MATCHUP POSTS */
	SELECT 		p.postID,p.subject,p.fullname,p.sourceTeamID "teamID",p.comment,concat('<A href="box.cfm?showheader=false&gameID=',p.gameID,'&width=600&height=370" class="thickbox">') "link",
				p.gameID "itemID",
				"matchup" as type
	FROM 		v_posts_game p
	UNION
	/* TEAM POSTS */
	SELECT 		p.postID,p.subject,p.fullname,p.sourceTeamID "teamID",p.comment,concat('<A href="teampage.cfm?teamID=',p.targetTeamID,'">') "link",
				p.targetTeamID "itemID",
				"team" as type
	FROM 		v_posts_team p
	UNION
	/* TRADE POSTS */
	SELECT 		p.postID,p.subject,p.fullname,p.sourceTeamID "teamID",p.comment,'<A href="transactions.cfm">' as link,
				p.claimID "itemID",
				"claim" as type
	FROM 		v_posts_claim p
	UNION
	/* TRADE POSTS */
	SELECT 		p.postID,p.subject,p.fullname,p.sourceTeamID "teamID",p.comment,concat('<A href="dsp_offer.cfm?viewOnly=1&tradeID=',p.tradeID,'&team1=',p.tradeTeam1,'&team2=',p.tradeTeam2,'&width=600&height=300&KeepThis=true&TB_iframe=true&inlineId=myOnPageContent" class="thickbox">') "link",
				p.tradeID "itemID",
				"trade" as type
	FROM 		v_posts_trade p
	UNION
	/* PLAYER POSTS */
	SELECT 		p.postID,p.playername "subject",p.fullname,p.teamID,p.comment,concat('<A href="playerpage.cfm?playerID=',p.playerID,'">') "link",
				p.playerID "itemID",
				"player" as type
	FROM 		v_posts_player p
	ORDER BY	postID desc
</cfquery>
<cfset sPosts = { records = [] }>
<cfloop query="qPosts">
	<cfset sPosts[ 'records' ][ qPosts.currentrow ] = {
		abbv = application.aAbbv[qPosts.teamID]
		, subject = qPosts.subject		
		, comment = qPosts.comment
		, user = qPosts.fullname
		, type = qPosts.type
		, link = qPosts.link
		, postID = qPosts.postID
		, itemID = qPosts.itemID
		, teamID = qPosts.teamID
		, replies = []
	}>
	<cfquery name="qReply" datasource="lwfa">
		SELECT		*
		FROM		v_posts_post
		WHERE		parentPostID = #qPosts.postID#
		ORDER BY 	postID 
	</cfquery>
	<cfif qReply.recordcount>
		<cfset sPosts[ 'records' ][ qPosts.currentrow ][ 'replies' ] = []>
		<cfloop query="qReply">
			<cfset sPosts[ 'records' ][ qPosts.currentrow ][ 'replies' ][ qReply.currentrow ] = {
				abbv = application.aAbbv[qReply.teamID]
				, comment = qReply.comment
				, user = qReply.fullname
				, postID = qReply.postID
				, teamID = qReply.teamID
			}>
		</cfloop>
	</cfif>
</cfloop>

<cfif structKeyExists(url,'debug')>
	<cfdump var="#sPendingDeal#" label="sPendingDeal">
	<cfdump var="#sPrevWeekScores#" label="sPrevWeekScores">
	<cfdump var="#sCurrWeekScores#" label="sCurrWeekScores">
	<cfdump var="#sWeekStar#" label="sWeekStar">
</cfif>

<cfset standStruct = structnew()>
<cfset standStruct['Madden'] = 'Ditka'>
<cfset standStruct['Ditka'] = 'Madden'>
<cfset standStruct['McMahon'] = 'Butkus'>
<cfset standStruct['Butkus'] = 'McMahon'>



<!---  --->
<link rel="stylesheet" type="text/css" href="css/home.css" />
<script language="javascript" src="js/home.js"></script>
<!---  --->

<div id="mainIndexDiv">
	<cfset lastDivision = ''>
	<cfoutput>
		<div class="outerTbl1" style="height:134px;"><div class="outerTbl2" style="height:132px;">
		<div class="conference" style="color:white">#session.qStandings.conference[1]# Conference</div>
		<table border=0 cellpadding="0" cellspacing="0" class="standingsTbl" style="width:360px;">
		<cfloop query="session.qStandings">
			<cfif currentrow eq 1 OR session.qStandings.conference[currentrow] neq session.qStandings.conference[currentrow-1]>
				<cfset offset = 20>
			<cfelse>
				<cfset offset = 0>
			</cfif>
			<cfif division neq lastDivision>
			<cfset lastDivision = division>
			<cfif currentrow neq 1>
				</tr>
			</table>
			</div></div>
			<div class="outerTbl1" style="height:#114+offset#px;"><div class="outerTbl2" style="height:#112+offset#px;">
			<cfif currentrow eq 1 OR session.qStandings.conference[currentrow] neq session.qStandings.conference[currentrow-1]>
				<div class="conference" style="color:white">#conference# Conference</div>
			</cfif>
			<table border=0 cellpadding="0" cellspacing="0" class="standingsTbl" style="width:360px;">
			</cfif>
			<tr class="divisionHeader">
				<td colspan=2>#division#</td>  
				<td>Record</td>  
				<td>Win%</td>  
				<!--- <td>GB</td>  
				<td>PF</td>  
				<td>PA</td> --->  
				<td>Strk</td>  
			</tr>		
			</cfif>
			<tr<cfif teamID eq variables.teamID> class="userteam"</cfif>>
				<td><img src="images/helmets/#abbv#.gif" class="helmet" align="absmiddle" title="#application.aTeams[teamID]#"></td>  
				<td class="teamName"><a href="teampage.cfm?teamID=#teamID#">#name#</a></td>  
				<td style="text-align:center;margin:4px 14px;">#win#-#loss#<cfif tie gt 0>-#tie#</cfif></td>  
				<td>#numberformat(winpct,'.000')#</td>  
				<!--- <td>#gb#</td>  
				<td>#round(pf)#</td>  
				<td>#round(pa)#</td> --->  
				<td>#streak#</td>  
			</tr>		
		</cfloop>
		</table>
	</div></div>
	</cfoutput>
	</div>
	
	<div id="tabsArea">
		<ul class="hometabs">
			<li><a href="#postsTab"><span>Posts</span></a></li>
			<li><a href="#movesTab"><span>Claims</span></a></li>
			<li><a href="#tradesTab"><span>Trades</span></a></li>
			<li><a href="#matchupsTab"><span>Matchups</span></a></li>
			<cfif application.currwk gt 1><li><a href="#scoresTab"><span>Scores</span></a></li></cfif>
		</ul>
		<!--- POSTS --->
		<div id="postsTab">
			<div class="postCommentLnk">
				<a href="javascript:;" onclick="postComment('post',0,'')"><img src="images/icon_post.png" border=0 style="cursor:pointer;"> Post a comment</a>
			</div>
			<cfoutput>
			<cfloop array="#sPosts['records']#" index="sPost">
				<div class="homePost #sPost.type#">
					<cfif sPost.type eq "player">
						<cfif fileExists(expandPath('images/players/#sPost.itemID#.jpg'))>
							<img src="images/players/#sPost.itemID#.jpg" class="playerimg">
						<cfelse>
							<img src="images/players/unknown.jpg" class="playerimg">
						</cfif>
					<cfelse>
						<img src="images/helmets/#sPost.abbv#.gif" class="helmet" align="middle" title="#application.aTeams[sPost.teamID]#"> 
					</cfif>
					<div class="comment">
						<b>#sPost.user#</b> commented<cfif sPost.itemID> on <cfif sPost.link neq ''>#sPost.link#</cfif><b>#sPost.subject#</b><cfif sPost.link neq ''></a></cfif></cfif>:<br/>#sPost.comment#
					</div>
					<div class="link">
						<img src="images/icon_post.png" onclick="postComment('post',#sPost.postID#,'#sPost.user#\'s comment')" style="cursor:pointer;">
						<cfif sPost.teamID eq variables.teamID>
						<br/><img src="images/delete3.gif" onclick="deleteComment(#sPost.postID#)">
						</cfif>
					</div>
					<cfloop array="#sPost['replies']#" index="sReply">
						<div class="reply">
							<img src="images/helmets/#sReply.abbv#.gif" class="helmet" align="middle" title="#application.aTeams[sReply.teamID]#"> 
							<div class="comment">
								<b>#sReply.user#</b>:<br/>#sReply.comment#
							</div>						
						</div>
					</cfloop>
				</div>
			</cfloop>
			</cfoutput>
		</div>
		<!--- MATCHUPS --->
		<div id="matchupsTab">
			<div class="postCommentLnk">
				<a href="javascript:;" onclick="postComment('post',0,'')"><img src="images/icon_post.png" border=0 style="cursor:pointer;"> Post a comment</a>
			</div>
			<div class="printableLink"><A href="scores.cfm?showheader=false&wk=<cfoutput>#application.currwk#</cfoutput>" target="_blank">PRINTABLE</div>
			<cfoutput>
				<cfloop from=1 to="#arraylen(sCurrWeekScores.records)#" index='sc'>
					<cfset thisScore = sCurrWeekScores['records'][ sc ]>
					<div class="scorelineDiv">
						<A href="box.cfm?showheader=false&gameID=#thisScore.gameID#&width=600&height=370" class="thickbox">
							<div class="awayhelmet">
								<img src="images/helmets/#thisScore.awayabbv#.gif" align="baseline">
							</div>
							<div class="teams">
								#thisScore.away# at #thisScore.home# 								
							</div>
							<div class="homehelmet">
								<img src="images/helmets/#thisScore.homeabbv#.gif" align="baseline">
							</div>
						</A>
					</div>
				</cfloop>
			</cfoutput>
		</div>
		<!--- SCORES --->
		<cfif application.currwk gt 1>
			<div id="scoresTab">
				<div class="postCommentLnk">
					<a href="javascript:;" onclick="postComment('post',0,'')"><img src="images/icon_post.png" border=0 style="cursor:pointer;"> Post a comment</a>
				</div>
				<div class="printableLink"><A href="scores.cfm?showheader=false&wk=<cfoutput>#application.prevwk#</cfoutput>" target="_blank">PRINTABLE</div><p/>
				<cfoutput>
					<cfloop from=1 to="#arraylen(sPrevWeekScores.records)#" index='sc'>
						<cfset thisScore = sPrevWeekScores['records'][ sc ]>
						<div class="scorelineDiv">
							<A href="box.cfm?showheader=false&gameID=#thisScore.gameID#&width=600&height=370" class="thickbox">
								<div class="awayhelmet">
									<img src="images/helmets/#thisScore.awayabbv#.gif" align="baseline">
								</div>
								<div class="teams">
									<cfif thisScore.awayscore gt thisScore.homescore><b></cfif>#thisScore.awayabbv# #thisScore.awayscore#<cfif thisScore.awayscore gt thisScore.homescore></b></cfif> @
									<cfif thisScore.awayscore lt thisScore.homescore><b></cfif>#thisScore.homeabbv# #thisScore.homescore#<cfif thisScore.awayscore lt thisScore.homescore></b></cfif>
								</div>
								<div class="homehelmet">
									<img src="images/helmets/#thisScore.homeabbv#.gif" align="baseline">
								</div>
							</A>
						</div>
					</cfloop>
				</cfoutput>
			</div>
		</cfif>
		<!--- CLAIMS --->
		<div id="movesTab">
			<div class="postCommentLnk">
				<a href="javascript:;" onclick="postComment('post',0,'')"><img src="images/icon_post.png" border=0 style="cursor:pointer;"> Post a comment</a>
			</div>
			<cfset lastdate = ''>
			<cfquery name="qClaims" datasource="lwfa">
				select * from v_claims_all order by claimID desc limit 8
			</cfquery>
			<cfoutput query="qClaims">
				<div class="transactionDiv<cfif lastdate neq dateformat(qClaims.dt,'dd-mmm-yy')> newdate<cfset lastdate = dateformat(qClaims.dt,'dd-mmm-yy')></cfif>">
					<div class="link">
						<img src="images/helmets/#application.aAbbv[qClaims.teamID]#.gif" class="helmet" title="#application.aTeams[qClaims.teamID]#">
						<img src="images/icon_post.png" class="add" onclick="postComment('claim',#qClaims.claimID#,'#qClaims.name#\'s claim of #qClaims.added#')">
					</div>
					<div class="claimed">
						<div class="playerdetail">
							<cfif fileExists(expandPath('images/players/#qClaims.claimedID#.jpg'))>
								<img src="images/players/#qClaims.claimedID#.jpg" class="playerimg">
							<cfelse>
								<img src="images/players/unknown.jpg" class="playerimg">
							</cfif>
							<div class="playername">CLAIMED<br/>#added#</div>
						</div>
					</div>
					<div class="dropped">
						<div class="playerdetail">
							<cfif fileExists(expandPath('images/players/#qClaims.droppedID#.jpg'))>
								<img src="images/players/#qClaims.droppedID#.jpg" class="playerimg">
							<cfelse>
								<img src="images/players/unknown.jpg" class="playerimg">
							</cfif>
							<div class="playername"><cfif qClaims.deactivate>TO I.R.<cfelse>DROPPED</cfif><br/>#dropped#</div>
						</div>
					</div>
				</div>
			</cfoutput>
		</div>
		<!--- TRADES --->
		<div id="tradesTab">
			<div class="postCommentLnk">
				<a href="javascript:;" onclick="postComment('post',0,'')"><img src="images/icon_post.png" border=0 style="cursor:pointer;"> Post a comment</a>
			</div>
			<cfset lastdate = ''>
			<cfoutput>
				<cfloop from=1 to="#arraylen(aTrades)#" index="tr">
					<div class="<cfif aTrades[tr]['isPending']>pending </cfif>tradeDiv">
						<div class="tradeTeamArea">
							<img src="images/helmets/#application.aAbbv[aTrades[tr]['toTeamID']]#.gif" class="toTeam helmet">
							<div class="toTeamPlayers">#aTrades[tr]['toTeamPlayers']#</div>
							<div class="toTeamArrow"><img src="images/arrow_ltr_down.gif"></div>
							<img src="images/icon_post.png" class="add" style="cursor:pointer;" onclick="postComment('trade',#aTrades[tr]['tradeID']#,'the #application.aTeams[aTrades[tr]['toTeamID']]#/#application.aTeams[aTrades[tr]['fromTeamID']]# trade')">
						</div>
						<div class="tradeTeamArea">
							<img src="images/helmets/#application.aAbbv[aTrades[tr]['fromTeamID']]#.gif" class="fromTeam helmet">
							<div class="fromTeamPlayers">#aTrades[tr]['fromTeamPlayers']#</div>
							<div class="fromTeamArrow"><img src="images/arrow_ltr_up.gif"></div>
						</div>
					</div>
				</cfloop>
			</cfoutput>
		</div>
	</div>
	
	
</div>