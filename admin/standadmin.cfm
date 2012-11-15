<cftry>		
	<CFQUERY name="qAllteams" datasource="lwfa">
		SELECT  	teamID "updTeam"
		FROM 		standings
	</cfquery>
	
	<cfloop query="qAllteams">
		<CFQUERY name="old" datasource="lwfa">
			SELECT  	s.*,t.divID "divisionID"
			FROM  		standings s join teams t USING(teamID)
			WHERE  	s.teamID=#updTeam#
		</cfquery>
		<cfset myDiv = old.divisionID>
		<cfset crwk = application.currwk> 
		<cfquery name="getaway" datasource="lwfa">
			SELECT  	*
			FROM  		schedule
			WHERE  	awayTeamID=#updTeam# AND week=#crwk#
		</cfquery> 
		<cfquery name="gethome" datasource="lwfa">
			SELECT  	*
			FROM  		schedule
			WHERE  	homeTeamID=#updTeam# AND week=#crwk#
		</cfquery> 
		<cfif gethome.recordcount EQ 0>
			<cfset loc='away'>
			<cfset pfor=getaway.awayscore>
			<cfset pvs=getaway.homescore>
		<cfelse>
			<cfset loc='home'>
			<cfset pfor=gethome.homescore>
			<cfset pvs=gethome.awayscore>
		</cfif> 
		
		<cfif loc EQ 'home'>
			<cfif gethome.homescore GT gethome.awayscore>
				<cfset result='win'>
			<cfelseif gethome.homescore LT gethome.awayscore>
				<cfset result='loss'>
			<cfelse>
				<cfset result='tie'>
			</cfif> 
			<cfquery name="getopp" datasource="lwfa">
				SELECT  	awayTeamID
				FROM  		schedule
				WHERE  	homeTeamID=#updTeam# AND week=#crwk#
			</cfquery>
			<cfset opp = getopp.awayTeamID>
	
		<cfelse>
	
			<cfif getaway.homescore LT getaway.awayscore>
				<cfset result='win'>
			<cfelseif getaway.homescore GT getaway.awayscore>
				<cfset result='loss'>
			<cfelse>
				<cfset result='tie'>
			</cfif> 
			<cfquery name="getopp" datasource="lwfa">
				SELECT  	homeTeamID
				FROM  		schedule
				WHERE  	awayTeamID=#updTeam# and week=#crwk#
			</cfquery>
			<cfset opp = getopp.homeTeamID>
		</cfif> 
		<cfquery name="getoppdiv" datasource="lwfa">
			SELECT  	left(d.division,3) "div"
			FROM  		teams t join divisions d on t.divID=d.divID
			WHERE  	t.teamID=#opp#
		</cfquery>
		<cfset oppdiv = getoppdiv.div>
	
		<!--- DIVISIONS KEY ---><!---  
			1 = MADDEN
			2 = DITKA
			3 = MCMAHON
			4 = BUTKUS
		---><!--- ----------------- --->
	
		<cfif trim(ucase(loc)) eq "AWAY"><cfset loc="road"></cfif>
		<cfset sqlLine = "#result#=#result#+1, #result##oppdiv#=#result##oppdiv#+1, #loc##left(result,1)#=#loc##left(result,1)#+1,pf=pf+#pfor#,pa=pa+#pvs#">	
	
		<cfquery name="updwhd" datasource="lwfa">
			UPDATE 	standings
			SET 			#sqlLine#
			WHERE 		teamID=#updTeam#
		</cfquery>	
	
		<cfquery name="getME" datasource="lwfa" maxrows=1>
		SELECT  	win, loss, tie, streak
		FROM  		standings
		WHERE  	teamID=#updTeam#
		</cfquery> 
		<cfset mywin = getME.win>
		<cfset myloss = getME.loss>
	
		<cfset newwpct = NumberFormat((mywin / (mywin+myloss)),'.000')>
		<cfset streakone = rereplace(getME.streak,'[0-9]{1,2}','')>
		<cfset streaktwo = rereplace(getME.streak,'[A-Z]','')>
		<CFIF result EQ 'win'>
			<CFIF streakone EQ 'W'>
				<cfset streakpart = streaktwo + 1>
				<cfset newstrk = 'W#streakpart#'>
			<CFELSE>
				<cfset newstrk = 'W1'>
			</cfif>
		<cfelse>
			<CFIF streakone EQ 'L'>
				<cfset streakpart = (Evaluate(streaktwo + 1))>
				<cfset newstrk = 'L#streakpart#'>
			<CFELSE>
				<cfset newstrk = 'L1'>
			</CFIF>
		</CFIF>
	
		<cfquery name="updother" datasource="lwfa">
		UPDATE 	standings
		SET 			winpct=#newwpct#, streak='#newstrk#' 
		WHERE 		teamID=#updTeam#
		</cfquery>
	
	</cfloop>
	
	<CFQUERY name="qAllteams" datasource="lwfa">
		SELECT  		s.teamID "updTeam",s.win,s.loss, t.divID
		FROM 			standings s join teams t using(teamID)
		ORDER BY 		s.winpct DESC
	</cfquery>
	
	<cfset strGB = structnew()>
	<cfloop query="qAllteams">
		<cfif structKeyExists(strGB,divID)>
			<cfset newgb = ((strGB[divID]['win'] - win)+(loss - strGB[divID]['loss']))/2>	
			<cfif newgb eq 0>
				<cfset newgb = "-">
			</cfif>
		<cfelse>
			<cfset strGB[divID] = structnew()>
			<cfset strGB[divID]['win'] = win>
			<cfset strGB[divID]['loss'] = loss>		
			<cfset newgb = "-">
		</cfif>
		<cfquery name="updother" datasource="lwfa">
			UPDATE standings
			SET gb='#newgb#'
			WHERE teamID=#updTeam#
		</cfquery>
	</cfloop>
<cfcatch><cfdump var="#cfcatch#"></cfcatch>
</cftry>