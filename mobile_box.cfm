<cfparam name="isMobile" default="0">

<cfquery name="qBox" datasource="lwfa">
	select 	* 
    from 	schedule 
    where 	GameID=#gameID#
</cfquery>

<cfif qBox.week eq currwk>
    <cfquery name="qAway" datasource="lwfa">
        select 	p.*,
				s.opp,
				t.name "team",
				l.total,l.line,
				ps.seasonPPG
        from 	players p 
					join nflschedule s on p.nflteam=s.NFLTM  
					join teams t on p.teamID=t.teamID 
					join playerstats ps USING (playerID)
					left join liveData l on p.playerID=l.playerID
        where 	t.teamID=#qBox.awayTeamID# AND
                	s.weekno=#qBox.week# AND
                	p.active='Y'
    </cfquery>
    <cfquery name="qHome" datasource="lwfa">
        select 	p.*,
				s.opp,
				t.name "team",
				l.total,l.line,
				ps.seasonPPG
        from 	players p 
					join nflschedule s on p.nflteam=s.NFLTM  
					join teams t on p.teamID=t.teamID 
					join playerstats ps USING (playerID)
					left join liveData l on p.playerID=l.playerID
        where 	t.teamID=#qBox.homeTeamID# AND
                	s.weekno=#qBox.week# AND
                	p.active='Y'
    </cfquery>
	<cfquery name="qIsLive" datasource="lwfa">
        select 	NULL 
        from 	playerdata 
        where 	weekNo=#qBox.week#
    </cfquery>
	<cfif qIsLive.recordcount>
		<cfset totalAverages = 0>
	<cfelse>
		<cfset totalAverages = 1>
	</cfif>

<cfelseif qBox.week gt currwk>
    <cfquery name="qAway" datasource="lwfa">
        select 	p.*,concat('OPPONENT: ',s.opp) "line",s.opp,ps.seasonPPG "total",t.name "team"
        from 	players p join nflschedule s on p.nflteam=s.NFLTM  join teams t on p.teamID=t.teamID join playerstats ps on p.playerID=ps.playerID
        where 	t.teamID=#qBox.awayTeamID# AND
                	s.weekno=#qBox.week# AND
                	p.active='Y'
    </cfquery>
    <cfquery name="qHome" datasource="lwfa">
        select 	p.*,concat('OPPONENT: ',s.opp) "line",s.opp,ps.seasonPPG "total",t.name "team"
        from 	players p join nflschedule s on p.nflteam=s.NFLTM  join teams t on p.teamID=t.teamID join playerstats ps on p.playerID=ps.playerID
        where 	t.teamID=#qBox.homeTeamID# AND
                	s.weekno=#qBox.week# AND
                	p.active='Y'
    </cfquery>
<cfelse>
    <cfquery name="qAway" datasource="lwfa">
        select 	p.playerID,p.first,p.last,p.pos,p.view,p.nflteam,'#qBox.awayTeamID#' as teamID,pd.line,pd.total,'' as opp 
        from 	players p join playerdata pd on p.playerID=pd.playerID join teams t   on pd.teamID=t.teamID
        where 	t.teamID=#qBox.awayTeamID# AND
                	pd.weekNo=#qBox.week# AND
                	pd.active='Y'
    </cfquery>
    <cfquery name="qHome" datasource="lwfa">
        select 	p.playerID,p.first,p.last,p.pos,p.view,p.nflteam,'#qBox.homeTeamID#' as teamID,pd.line,pd.total,'' as opp
        from 	players p join playerdata pd on p.playerID=pd.playerID join teams t   on pd.teamID=t.teamID
        where 	t.teamID=#qBox.homeTeamID# AND
                	pd.weekNo=#qBox.week# AND
                	pd.active='Y'
    </cfquery>
</cfif>

<cfset thisGame=structnew()>
<cfset thisGame.homeTeam=structnew()>
<cfset thisGame.awayTeam=structnew()>
<cfset thisGame.homeTeam.QB=structnew()>
<cfset thisGame.awayTeam.QB=structnew()>
<cfset thisGame.homeTeam.RB=structnew()>
<cfset thisGame.awayTeam.RB=structnew()>
<cfset thisGame.homeTeam.FX=structnew()>
<cfset thisGame.awayTeam.FX=structnew()>
<cfset thisGame.homeTeam.WR1=structnew()>
<cfset thisGame.awayTeam.WR1=structnew()>
<cfset thisGame.homeTeam.WR2=structnew()>
<cfset thisGame.awayTeam.WR2=structnew()>
<cfset thisGame.homeTeam.TE=structnew()>
<cfset thisGame.awayTeam.TE=structnew()>
<cfset thisGame.homeTeam.K=structnew()>
<cfset thisGame.awayTeam.K=structnew()>
<cfset thisGame.homeTeam.D=structnew()>
<cfset thisGame.awayTeam.D=structnew()>
<cfset thisGame.homeTeam.total=0>
<cfset thisGame.awayTeam.total=0>

<!--- set defaults --->
<cfloop list="home,away" index="l">
	<cfloop list="QB,RB,FX,WR1,WR2,TE,K,D" index="p">
		<cfset thisGame[l&"Team"][p]['last'] = 'empty'>
		<cfset thisGame[l&"Team"][p]['nflteam'] = ''>
		<cfset thisGame[l&"Team"][p]['opp'] = ''>
		<cfset thisGame[l&"Team"][p]['first'] = ''>
		<cfset thisGame[l&"Team"][p]['playerID'] = 'empty'>
		<cfset thisGame[l&"Team"][p]['image'] = '/2009/images/players/unknown.jpg'>
		<cfset thisGame[l&"Team"][p]['line'] = ''>
		<cfset thisGame[l&"Team"][p]['total'] = 0>
	</cfloop>
</cfloop>

<cfloop query="qHome">
    <cfquery name="qTeam" datasource="lwfa">
        select 	t.name "team",t.nickname,s.win,s.loss,s.tie
        from 	standings s join teams t on s.teamID=t.teamID
        where 	t.teamID=#qHome.teamID#
    </cfquery>
	<cfif qHome.line neq '' AND qHome.total neq ''>
		<cfset variables.line = qHome.line>
		<cfset variables.total = qHome.total>
	<cfelse>
		<cfquery name="qStats" datasource="lwfa">
	        select 	* 
	        from 	playerdata 
	        where 	playerID=#playerID# AND
	        			weekNo=#qBox.week#
	    </cfquery>
	    <cfif qStats.recordcount gt 0 AND qBox.week lte currwk>
			<cfset variables.line=qStats.line>
	    	<cfset variables.total=qStats.total>
		<cfelse>
	    	<cfset variables.line=''>
			<cfif isNumeric(qHome.seasonPPG) AND totalAverages>
		    	<cfset variables.total=qHome.seasonPPG>
			<cfelse>
		    	<cfset variables.total=0>
			</cfif>
		</cfif>
	</cfif>
    <cfset thisGame.homeTeam.team=qTeam.team>
    <cfset thisGame.homeTeam.nickname=qTeam.nickname>
    <cfset thisGame.homeTeam.record="("&qTeam.win&"-"&qTeam.loss&")">
    <cfset thisGame.homeTeam.total=thisGame.homeTeam.total+variables.total>
   	<cfset variables.imageView="images/players/"&playerid&".jpg">
	<cfif pos eq 'QB'>
		<cfset thisGame.homeTeam.QB.first=left(first,1)&". ">
		<cfset thisGame.homeTeam.QB.last=last>
		<cfset thisGame.homeTeam.QB.nflteam=nflteam>
		<cfset thisGame.homeTeam.QB.opp=opp>
		<cfset thisGame.homeTeam.QB.playerID=playerID>
		<cfset thisGame.homeTeam.QB.image=variables.imageView>
		<cfset thisGame.homeTeam.QB.line=variables.line>
		<cfset thisGame.homeTeam.QB.total=variables.total>
	<cfelseif pos eq 'RB'>
    	<cfif structKeyExists(thisGame.homeTeam.RB,'first') AND thisGame.homeTeam.RB.first neq ''>
			<cfset thisGame.homeTeam.FX.first=left(first,1)&". ">
			<cfset thisGame.homeTeam.FX.last=last>
			<cfset thisGame.homeTeam.FX.nflteam=nflteam>
			<cfset thisGame.homeTeam.FX.opp=opp>
			<cfset thisGame.homeTeam.FX.playerID=playerID>
			<cfset thisGame.homeTeam.FX.image=variables.imageView>
			<cfset thisGame.homeTeam.FX.line=variables.line>
			<cfset thisGame.homeTeam.FX.total=variables.total>
		<cfelse>
			<cfset thisGame.homeTeam.RB.first=left(first,1)&". ">
			<cfset thisGame.homeTeam.RB.last=last>
			<cfset thisGame.homeTeam.RB.nflteam=nflteam>
			<cfset thisGame.homeTeam.RB.opp=opp>
			<cfset thisGame.homeTeam.RB.playerID=playerID>
			<cfset thisGame.homeTeam.RB.image=variables.imageView>
			<cfset thisGame.homeTeam.RB.line=variables.line>
			<cfset thisGame.homeTeam.RB.total=variables.total>
		</cfif>
	<cfelseif pos eq 'WR'>
    	<cfif structKeyExists(thisGame.homeTeam.WR1,'first') AND thisGame.homeTeam.WR1.first neq ''>
			<cfif structKeyExists(thisGame.homeTeam.WR2,'first') AND thisGame.homeTeam.WR2.first neq ''>
	   			<cfset thisGame.homeTeam.FX.first=left(first,1)&". ">
				<cfset thisGame.homeTeam.FX.last=last>
				<cfset thisGame.homeTeam.FX.nflteam=nflteam>
				<cfset thisGame.homeTeam.FX.opp=opp>
				<cfset thisGame.homeTeam.FX.image=variables.imageView>
				<cfset thisGame.homeTeam.FX.playerID=playerID>
				<cfset thisGame.homeTeam.FX.line=variables.line>
				<cfset thisGame.homeTeam.FX.total=variables.total>
			<cfelse>
				<cfset thisGame.homeTeam.WR2.first=left(first,1)&". ">
                <cfset thisGame.homeTeam.WR2.last=last>
                <cfset thisGame.homeTeam.WR2.nflteam=nflteam>
                <cfset thisGame.homeTeam.WR2.opp=opp>
				<cfset thisGame.homeTeam.WR2.image=variables.imageView>
				<cfset thisGame.homeTeam.WR2.playerID=playerID>
				<cfset thisGame.homeTeam.WR2.line=variables.line>
				<cfset thisGame.homeTeam.WR2.total=variables.total>
			</cfif>
		<cfelse>
			<cfset thisGame.homeTeam.WR1.first=left(first,1)&". ">
			<cfset thisGame.homeTeam.WR1.last=last>
			<cfset thisGame.homeTeam.WR1.nflteam=nflteam>
			<cfset thisGame.homeTeam.WR1.opp=opp>
			<cfset thisGame.homeTeam.WR1.playerID=playerID>
			<cfset thisGame.homeTeam.WR1.image=variables.imageView>
			<cfset thisGame.homeTeam.WR1.line=variables.line>
			<cfset thisGame.homeTeam.WR1.total=variables.total>
		</cfif>
	<cfelseif pos eq 'TE'>
		<cfset thisGame.homeTeam.TE.first=left(first,1)&". ">
		<cfset thisGame.homeTeam.TE.last=last>
		<cfset thisGame.homeTeam.TE.nflteam=nflteam>
		<cfset thisGame.homeTeam.TE.opp=opp>
		<cfset thisGame.homeTeam.TE.playerID=playerID>
		<cfset thisGame.homeTeam.TE.image=variables.imageView>
		<cfset thisGame.homeTeam.TE.line=variables.line>
		<cfset thisGame.homeTeam.TE.total=variables.total>
	<cfelseif pos eq 'K'>
		<cfset thisGame.homeTeam.K.first=left(first,1)&". ">
		<cfset thisGame.homeTeam.K.last=last>
		<cfset thisGame.homeTeam.K.nflteam=nflteam>
		<cfset thisGame.homeTeam.K.opp=opp>
		<cfset thisGame.homeTeam.K.playerID=playerID>
		<cfset thisGame.homeTeam.K.image=variables.imageView>
		<cfset thisGame.homeTeam.K.line=variables.line>
		<cfset thisGame.homeTeam.K.total=variables.total>
	<cfelseif pos eq 'D'>
		<cfset thisGame.homeTeam.D.first=left(first,1)&". ">
		<cfset thisGame.homeTeam.D.last=last>
		<cfset thisGame.homeTeam.D.nflteam=nflteam>
		<cfset thisGame.homeTeam.D.opp=opp>
		<cfset thisGame.homeTeam.D.playerID=playerID>
		<cfset thisGame.homeTeam.D.image=variables.imageView>
		<cfset thisGame.homeTeam.D.line=variables.line>
		<cfset thisGame.homeTeam.D.total=variables.total>
	</cfif>
</cfloop>
<cfloop query="qAway">
    <cfquery name="qTeam" datasource="lwfa">
        select 	t.name "team",t.nickname,s.win,s.loss,s.tie
        from 	standings s join teams t on s.teamID=t.teamID
        where 	t.teamID=#qAway.teamID#
    </cfquery>
	<cfif qAway.line neq '' AND qAway.total neq ''>
		<cfset variables.line = qAway.line>
		<cfset variables.total = qAway.total>
	<cfelse>
		<cfquery name="qStats" datasource="lwfa">
	        select 	* 
	        from 	playerdata 
	        where 	playerID=#playerID# AND
	        			weekNo=#qBox.week#
	    </cfquery>
	    <cfif qStats.recordcount AND qBox.week lte currwk>
			<cfset variables.line=qStats.line>
	    	<cfset variables.total=qStats.total>
		<cfelse>
	    	<cfset variables.line=''>
			<cfif isNumeric(qAway.seasonPPG) AND totalAverages>
		    	<cfset variables.total=qAway.seasonPPG>
			<cfelse>
		    	<cfset variables.total=0>
			</cfif>
		</cfif>
	</cfif>
   	<cfset variables.imageView="images/players/"&playerID&".jpg">
    <cfset thisGame.awayTeam.team=qTeam.team>
    <cfset thisGame.awayTeam.nickname=qTeam.nickname>
    <cfset thisGame.awayTeam.record="("&qTeam.win&"-"&qTeam.loss&")">
    <cfset thisGame.awayTeam.total=thisGame.awayTeam.total+variables.total>
	<cfif pos eq 'QB'>
		<cfset thisGame.awayTeam.QB.first=left(first,1)&". ">
		<cfset thisGame.awayTeam.QB.last=last>
		<cfset thisGame.awayTeam.QB.nflteam=nflteam>
		<cfset thisGame.awayTeam.QB.opp=opp>
		<cfset thisGame.awayTeam.QB.playerID=playerID>
		<cfset thisGame.awayTeam.QB.image=variables.imageView>
		<cfset thisGame.awayTeam.QB.line=variables.line>
		<cfset thisGame.awayTeam.QB.total=variables.total>
	<cfelseif pos eq 'RB'>
    	<cfif structKeyExists(thisGame.awayTeam.RB,'first') AND thisGame.awayTeam.RB.first neq ''>
			<cfset thisGame.awayTeam.FX.first=left(first,1)&". ">
			<cfset thisGame.awayTeam.FX.last=last>
			<cfset thisGame.awayTeam.FX.nflteam=nflteam>
			<cfset thisGame.awayTeam.FX.opp=opp>
			<cfset thisGame.awayTeam.FX.playerID=playerID>
			<cfset thisGame.awayTeam.FX.image=variables.imageView>
			<cfset thisGame.awayTeam.FX.line=variables.line>
			<cfset thisGame.awayTeam.FX.total=variables.total>
		<cfelse>
			<cfset thisGame.awayTeam.RB.first=left(first,1)&". ">
			<cfset thisGame.awayTeam.RB.last=last>
			<cfset thisGame.awayTeam.RB.nflteam=nflteam>
			<cfset thisGame.awayTeam.RB.opp=opp>
			<cfset thisGame.awayTeam.RB.playerID=playerID>
			<cfset thisGame.awayTeam.RB.image=variables.imageView>
			<cfset thisGame.awayTeam.RB.line=variables.line>
			<cfset thisGame.awayTeam.RB.total=variables.total>
		</cfif>
	<cfelseif pos eq 'WR'>
    	<cfif structKeyExists(thisGame.awayTeam.WR1,'first') AND thisGame.awayTeam.WR1.first neq ''>
			<cfif structKeyExists(thisGame.awayTeam.WR2,'first') AND thisGame.awayTeam.WR2.first neq ''>
	   			<cfset thisGame.awayTeam.FX.first=left(first,1)&". ">
				<cfset thisGame.awayTeam.FX.last=last>
				<cfset thisGame.awayTeam.FX.nflteam=nflteam>
				<cfset thisGame.awayTeam.FX.opp=opp>
				<cfset thisGame.awayTeam.FX.playerID=playerID>
				<cfset thisGame.awayTeam.FX.image=variables.imageView>
				<cfset thisGame.awayTeam.FX.line=variables.line>
				<cfset thisGame.awayTeam.FX.total=variables.total>
			<cfelse>
				<cfset thisGame.awayTeam.WR2.first=left(first,1)&". ">
                <cfset thisGame.awayTeam.WR2.last=last>
                <cfset thisGame.awayTeam.WR2.nflteam=nflteam>
                <cfset thisGame.awayTeam.WR2.opp=opp>
				<cfset thisGame.awayTeam.WR2.playerID=playerID>
				<cfset thisGame.awayTeam.WR2.line=variables.line>
				<cfset thisGame.awayTeam.WR2.image=variables.imageView>
				<cfset thisGame.awayTeam.WR2.total=variables.total>
			</cfif>
		<cfelse>
			<cfset thisGame.awayTeam.WR1.first=left(first,1)&". ">
			<cfset thisGame.awayTeam.WR1.last=last>
			<cfset thisGame.awayTeam.WR1.nflteam=nflteam>
			<cfset thisGame.awayTeam.WR1.opp=opp>
			<cfset thisGame.awayTeam.WR1.playerID=playerID>
			<cfset thisGame.awayTeam.WR1.image=variables.imageView>
			<cfset thisGame.awayTeam.WR1.line=variables.line>
			<cfset thisGame.awayTeam.WR1.total=variables.total>
		</cfif>
	<cfelseif pos eq 'TE'>
		<cfset thisGame.awayTeam.TE.first=left(first,1)&". ">
		<cfset thisGame.awayTeam.TE.last=last>
		<cfset thisGame.awayTeam.TE.nflteam=nflteam>
		<cfset thisGame.awayTeam.TE.opp=opp>
		<cfset thisGame.awayTeam.TE.playerID=playerID>
		<cfset thisGame.awayTeam.TE.image=variables.imageView>
		<cfset thisGame.awayTeam.TE.line=variables.line>
		<cfset thisGame.awayTeam.TE.total=variables.total>
	<cfelseif pos eq 'K'>
		<cfset thisGame.awayTeam.K.first=left(first,1)&". ">
		<cfset thisGame.awayTeam.K.last=last>
		<cfset thisGame.awayTeam.K.nflteam=nflteam>
		<cfset thisGame.awayTeam.K.opp=opp>
		<cfset thisGame.awayTeam.K.playerID=playerID>
		<cfset thisGame.awayTeam.K.image=variables.imageView>
		<cfset thisGame.awayTeam.K.line=variables.line>
		<cfset thisGame.awayTeam.K.total=variables.total>
	<cfelseif pos eq 'D'>
		<cfset thisGame.awayTeam.D.first=left(first,1)&". ">
		<cfset thisGame.awayTeam.D.last=last>
		<cfset thisGame.awayTeam.D.nflteam=nflteam>
		<cfset thisGame.awayTeam.D.opp=opp>
		<cfset thisGame.awayTeam.D.playerID=playerID>
		<cfset thisGame.awayTeam.D.image=variables.imageView>
		<cfset thisGame.awayTeam.D.line=variables.line>
		<cfset thisGame.awayTeam.D.total=variables.total>
	</cfif>
</cfloop>

<cfoutput>
<table cellpadding="0" cellspacing="0"<cfif isMobile eq 0> class="thisBoxTbl"</cfif>>
	<cfif isMobile>
		<tr>
			<td colspan=5 align="center" style="background-color:black;">
				#thisGame.awayTeam.team# AT #thisGame.homeTeam.team#
			</td>
		</tr>
	<cfelse>
		<tr>
	    	<td colspan=3 class="header" align="right">#thisGame.awayTeam.team# #thisGame.awayTeam.nickname# #thisGame.awayTeam.record#</td>
	    	<td class="header" align="center">AT</td>
	    	<td colspan=3 class="header" align="left">#thisGame.homeTeam.team# #thisGame.homeTeam.nickname# #thisGame.homeTeam.record#</td>
	    </tr>
	</cfif>
	<tr>
    	<td class="total">#numberformat(thisGame.awayTeam.QB.total,'0.00')#</td>
    	<td align="center" class="line"><cfif thisGame.awayTeam.QB.line neq ''>#thisGame.awayTeam.QB.line#<cfelse>OPPONENT:<br>#thisGame.awayTeam.QB.opp#</cfif></td>
        <td class="name">#thisGame.awayTeam.QB.first# #thisGame.awayTeam.QB.last#, #thisGame.awayTeam.QB.nflteam#</td>
        <!--- <td class="image"><img src="#thisGame.awayTeam.QB.image#" /></td> --->
        <td class="pos">QB</td>
        <!--- <td class="image"><img src="#thisGame.homeTeam.QB.image#" /></td> --->
        <td class="name">#thisGame.homeTeam.QB.first# #thisGame.homeTeam.QB.last#, #thisGame.homeTeam.QB.nflteam#</td>
    	<td align="center" class="line"><cfif thisGame.homeTeam.QB.line neq ''>#thisGame.homeTeam.QB.line#<cfelse>OPPONENT:<br>#thisGame.homeTeam.QB.opp#</cfif></td>
    	<td class="total end">#numberformat(thisGame.homeTeam.QB.total,'0.00')#</td>
    </tr>
	<tr>
    	<td class="total">#numberformat(thisGame.awayTeam.RB.total,'0.00')#</td>
    	<td align="center" class="line"><cfif thisGame.awayTeam.RB.line neq ''>#thisGame.awayTeam.RB.line#<cfelse>OPPONENT:<br>#thisGame.awayTeam.RB.opp#</cfif></td>
        <td class="name">#thisGame.awayTeam.RB.first# #thisGame.awayTeam.RB.last#, #thisGame.awayTeam.RB.nflteam#</td>
        <!--- <td class="image"><img src="#thisGame.awayTeam.RB.image#" /></td> --->
        <td class="pos">RB</td>
        <!--- <td class="image"><img src="#thisGame.homeTeam.RB.image#" /></td> --->
        <td class="name">#thisGame.homeTeam.RB.first# #thisGame.homeTeam.RB.last#, #thisGame.homeTeam.RB.nflteam#</td>
    	<td align="center" class="line"><cfif thisGame.homeTeam.RB.line neq ''>#thisGame.homeTeam.RB.line#<cfelse>OPPONENT:<br>#thisGame.homeTeam.RB.opp#</cfif></td>
    	<td class="total end">#numberformat(thisGame.homeTeam.RB.total,'0.00')#</td>
    </tr>
	<tr>
    	<td class="total">#numberformat(thisGame.awayTeam.FX.total,'0.00')#</td>
    	<td align="center" class="line"><cfif thisGame.awayTeam.FX.line neq ''>#thisGame.awayTeam.FX.line#<cfelse>OPPONENT:<br>#thisGame.awayTeam.FX.opp#</cfif></td>
        <td class="name">#thisGame.awayTeam.FX.first# #thisGame.awayTeam.FX.last#, #thisGame.awayTeam.FX.nflteam#</td>
        <!--- <td class="image"><img src="#thisGame.awayTeam.FX.image#" /></td> --->
        <td class="pos">FX</td>
        <!--- <td class="image"><img src="#thisGame.homeTeam.FX.image#" /></td> --->
        <td class="name">#thisGame.homeTeam.FX.first# #thisGame.homeTeam.FX.last#, #thisGame.homeTeam.FX.nflteam#</td>
    	<td align="center" class="line"><cfif thisGame.homeTeam.FX.line neq ''>#thisGame.homeTeam.FX.line#<cfelse>OPPONENT:<br>#thisGame.homeTeam.FX.opp#</cfif></td>
    	<td class="total end">#numberformat(thisGame.homeTeam.FX.total,'0.00')#</td>
    </tr>
	<tr>
    	<td class="total">#numberformat(thisGame.awayTeam.WR1.total,'0.00')#</td>
    	<td align="center" class="line"><cfif thisGame.awayTeam.WR1.line neq ''>#thisGame.awayTeam.WR1.line#<cfelse>OPPONENT:<br>#thisGame.awayTeam.WR1.opp#</cfif></td>
        <td class="name">#thisGame.awayTeam.WR1.first# #thisGame.awayTeam.WR1.last#, #thisGame.awayTeam.WR1.nflteam#</td>
        <!--- <td class="image"><img src="#thisGame.awayTeam.WR1.image#" /></td> --->
        <td class="pos">WR</td>
        <!--- <td class="image"><img src="#thisGame.homeTeam.WR1.image#" /></td> --->
        <td class="name">#thisGame.homeTeam.WR1.first# #thisGame.homeTeam.WR1.last#, #thisGame.homeTeam.WR1.nflteam#</td>
    	<td align="center" class="line"><cfif thisGame.homeTeam.WR1.line neq ''>#thisGame.homeTeam.WR1.line#<cfelse>OPPONENT:<br>#thisGame.homeTeam.WR1.opp#</cfif></td>
    	<td class="total end">#numberformat(thisGame.homeTeam.WR1.total,'0.00')#</td>
    </tr>
	<tr>
    	<td class="total">#numberformat(thisGame.awayTeam.WR2.total,'0.00')#</td>
    	<td align="center" class="line"><cfif thisGame.awayTeam.WR2.line neq ''>#thisGame.awayTeam.WR2.line#<cfelse>OPPONENT:<br>#thisGame.awayTeam.WR2.opp#</cfif></td>
        <td class="name">#thisGame.awayTeam.WR2.first# #thisGame.awayTeam.WR2.last#, #thisGame.awayTeam.WR2.nflteam#</td>
        <!--- <td class="image"><img src="#thisGame.awayTeam.WR2.image#" /></td> --->
        <td class="pos">WR</td>
        <!--- <td class="image"><img src="#thisGame.homeTeam.WR2.image#" /></td> --->
        <td class="name">#thisGame.homeTeam.WR2.first# #thisGame.homeTeam.WR2.last#, #thisGame.homeTeam.WR2.nflteam#</td>
    	<td align="center" class="line"><cfif thisGame.homeTeam.WR2.line neq ''>#thisGame.homeTeam.WR2.line#<cfelse>OPPONENT:<br>#thisGame.homeTeam.WR2.opp#</cfif></td>
    	<td class="total end">#numberformat(thisGame.homeTeam.WR2.total,'0.00')#</td>
    </tr>
	<tr>
    	<td class="total">#numberformat(thisGame.awayTeam.TE.total,'0.00')#</td>
    	<td align="center" class="line"><cfif thisGame.awayTeam.TE.line neq ''>#thisGame.awayTeam.TE.line#<cfelse>OPPONENT:<br>#thisGame.awayTeam.TE.opp#</cfif></td>
        <td class="name">#thisGame.awayTeam.TE.first# #thisGame.awayTeam.TE.last#, #thisGame.awayTeam.TE.nflteam#</td>
        <!--- <td class="image"><img src="#thisGame.awayTeam.TE.image#" /></td> --->
        <td class="pos">TE</td>
        <!--- <td class="image"><img src="#thisGame.homeTeam.TE.image#" /></td> --->
        <td class="name">#thisGame.homeTeam.TE.first# #thisGame.homeTeam.TE.last#, #thisGame.homeTeam.TE.nflteam#</td>
    	<td align="center" class="line"><cfif thisGame.homeTeam.TE.line neq ''>#thisGame.homeTeam.TE.line#<cfelse>OPPONENT:<br>#thisGame.homeTeam.TE.opp#</cfif></td>
    	<td class="total end">#numberformat(thisGame.homeTeam.TE.total,'0.00')#</td>
    </tr>
	<tr>
    	<td class="total">#numberformat(thisGame.awayTeam.K.total,'0.00')#</td>
    	<td align="center" class="line"><cfif thisGame.awayTeam.K.line neq ''>#thisGame.awayTeam.K.line#<cfelse>OPPONENT:<br>#thisGame.awayTeam.K.opp#</cfif></td>
        <td class="name">#thisGame.awayTeam.K.first# #thisGame.awayTeam.K.last#, #thisGame.awayTeam.K.nflteam#</td>
        <!--- <td class="image"><img src="#thisGame.awayTeam.K.image#" /></td> --->
        <td class="pos">K</td>
        <!--- <td class="image"><img src="#thisGame.homeTeam.K.image#" /></td> --->
        <td class="name">#thisGame.homeTeam.K.first# #thisGame.homeTeam.K.last#, #thisGame.homeTeam.K.nflteam#</td>
    	<td align="center" class="line"><cfif thisGame.homeTeam.K.line neq ''>#thisGame.homeTeam.K.line#<cfelse>OPPONENT:<br>#thisGame.homeTeam.K.opp#</cfif></td>
    	<td class="total end">#numberformat(thisGame.homeTeam.K.total,'0.00')#</td>
    </tr>
	<tr>
    	<td class="total">#numberformat(thisGame.awayTeam.D.total,'0.00')#</td>
    	<td align="center" class="line"><cfif thisGame.awayTeam.D.line neq ''>#thisGame.awayTeam.D.line#<cfelse>OPPONENT:<br>#thisGame.awayTeam.D.opp#</cfif></td>
        <td class="name">#thisGame.awayTeam.D.first# #thisGame.awayTeam.D.last#, #thisGame.awayTeam.D.nflteam#</td>
        <!--- <td class="image"><img src="#thisGame.awayTeam.D.image#" /></td> --->
        <td class="pos">D</td>
        <!--- <td class="image"><img src="#thisGame.homeTeam.D.image#" /></td> --->
        <td class="name">#thisGame.homeTeam.D.first# #thisGame.homeTeam.D.last#, #thisGame.homeTeam.D.nflteam#</td>
    	<td align="center" class="line"><cfif thisGame.homeTeam.D.line neq ''>#thisGame.homeTeam.D.line#<cfelse>OPPONENT:<br>#thisGame.homeTeam.D.opp#</cfif></td>
    	<td class="total end">#numberformat(thisGame.homeTeam.D.total,'0.00')#</td>
    </tr>
    <tr>
    	<td class="total">#numberformat(thisGame.awayTeam.total,'0.00')#</td>
    	<td colspan=<cfif isMobile>3<cfelse>5</cfif> class="pos">TOTAL</td>
    	<td class="total end">#numberformat(thisGame.homeTeam.total,'0.00')#</td>
    </tr>
</table>
</cfoutput>
