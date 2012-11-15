<!--- let the commish run this page whenever he wants --->
<cfif structKeyExists(cookie,'lwfauser') AND cookie.lwfauser eq 'lkelly'>
	<cfif NOT structKeyExists(form,'runClaimsManually')>
		<form action="proc_claims.cfm" method="post">
			<input type="Checkbox" name="runClaimsManually" value=1> Run claims process manually<br />
			<input type="submit" value="go">
		</form>
		<cfabort>
	</cfif>
<cfelse>
	<!--- quit if it's before week 1 --->
	<cfif month(now()) eq 9 AND day(now()) lt 11>
		<cfabort>
	<!--- quit if this is a Monday --->
	<cfelseif dayofweek(now()) eq 2>
		<cfabort>
	<!--- quit if this is a Sunday and it is not 12PM --->
	<cfelseif dayofweek(now()) eq 1 AND hour(now()) neq 11>
		<cfabort>	
	<!--- quit if this is NOT a Sunday and it is 12PM --->
	<cfelseif dayofweek(now()) neq 1 AND hour(now()) eq 10>
		<cfif day(now()) eq 25 AND month(now()) eq 11>
			<!--- allow Thanksgiving claims --->
		<cfelse>
			<cfabort>	
		</cfif>
	<!--- quit if the season has ended --->
	<cfelseif month(now()) eq 12 AND day(now()) gt 27>
		<cfabort>
	<cfelseif minute(now()) gt 0>
		<cfabort>
	</cfif>
</cfif>

<!--- if the playoffs have begun, restrict claims to playoff teams --->
<cfif month(now()) eq 12 AND day(now()) gt 5>
	<cfquery name="qPlayoffTeams" datasource="lwfa">
		select distinct hometeamID "tmID" from schedule where week > 13 AND hometeamID IS NOT NULL
		UNION
		select distinct awayteamID "tmID" from schedule where week > 13	 AND awayteamID IS NOT NULL		
	</cfquery>
	<cfset variables.playoffTeams = valuelist(qPlayoffTeams.tmID)>
</cfif>
		
<!--- get teams making claims in order --->
<cfquery name="qWaiverPos" datasource="lwfa">
	select 		teamID
	from			standings
	where 		claimsrank > 0
	<cfif structKeyExists(variables,'playoffTeams')>
	AND teamID IN (#variables.playoffTeams#)
	</cfif>
	order by 	claimsrank
</cfquery> 
<cfset waiverOrderList=valuelist(qWaiverPos.teamID)>
<cfset newWaiverOrderList=valuelist(qWaiverPos.teamID)>

<!--- send confirmation email --->
<cfset LOCAL.mailAttr = application.mailAttributes>
<cfset LOCAL.mailAttr.from="claims@lwfa.org">
<cfset LOCAL.mailAttr.to="liammkelly@gmail.com">
<cfset LOCAL.mailAttr.subject="Claims ran!">

<!--- <cftry>
	<cfmail attributecollection="#LOCAL.mailAttr#">
		Claims ran at #now()#
	</cfmail>
	<cfcatch></cfcatch>
</cftry> --->

<!--- playoff order --->
<!--- 
<cfset waiverOrderList="Lompoc,Sin City,Ho-Ho-Kus,Chicago,Gilead,Beverly Hills">
Loop through list.  
If team has pending claim, process and add team to end of priority list.  
If not, remove from priority list 
--->
	
<cfloop condition="listlen(waiverOrderList) gt 0">
	<cfset thisClaimTm=listgetat(waiverOrderList,1)>
	<cfquery name="qClaim" datasource="lwfa">
		select		*
		from		claims
		where 		teamID=#thisClaimTm# and statusID=1
		order by 	priority,dt 
		limit 		1
	</cfquery>
	<cfif qClaim.recordcount gt 0>
		<cfset thisClaimed=qClaim.clmid>
		<cfset thisDumped=qClaim.dmpid>
		<cfset thisClaimTm=qClaim.teamID>
		<cfset thisClaim=qClaim.claimID>
		<cfset thisDeactivate=qClaim.deactivate>
		<cfoutput>
		thisClaimed=#thisClaimed#<br />
		thisDumped=#thisDumped#<br />
		thisClaimTm=#thisClaimTm#<br />
		thisClaim=#thisClaim#<br />
		thisDeactivate=#thisDeactivate#<p />
		</cfoutput>
		<!---  
		<cfquery name="qFACheck" datasource="lwfa">
			select * from players where nflid=#thisClaimed# and team='None'
		</cfquery>
		<cfif qFACheck.recordcount gt 0>
		--->
			<cfif thisDumped eq "">
				<!--- if no player to be cut, check for empty roster spot --->
				<cfquery name="qSelPlayer" datasource="lwfa">
					select 	*
					from 	players
					where	inj='N' and teamID=#thisClaimTm#
				</cfquery>
				<cfif qSelPlayer.recordcount lt 16>
					<!--- if active player count lt 16, there is an open roster spot, so approve --->
					<cfquery name="qAddPlayer" datasource="lwfa">
						update 	players
						set 		teamID=#thisClaimTm#,active='N'
						where	playerID=#thisClaimed#
					</cfquery>				
					<!--- set this claim to 'approved' --->
					<cfquery name="qApproveClaims" datasource="lwfa">
						update	claims
						set		statusID=3,date_processed=now()
						where 	claimID=#thisClaim#
					</cfquery>
					<!--- set other claims for the same player to 'denied' --->
					<cfquery name="qKillSameClaims" datasource="lwfa">
						update	claims
						set		statusID=2,date_processed=now()
						where 	clmid=#thisClaimed# and statusID=1
					</cfquery>
				<cfelse>
					<!--- if no empty spot, clear all claims by this team without a player to be dropped --->
					<cfquery name="qClear" datasource="lwfa">
						update claims
						set		statusID=2,date_processed=now()
						where	claimID = #thisClaim# OR (teamID = #thisClaimTm# AND dmpid IS NULL)
					</cfquery>
				</cfif>
			<cfelse>
				<!--- if there is a player to be cut, check if they're actually going on the DL --->
				<cfif thisDeactivate eq "0">
					<!--- if not, cut them --->
					<cfquery name="qDumpPlayer" datasource="lwfa">
						update 	players
						set 		teamID=0,active='N'
						where	playerID=#thisDumped#
					</cfquery>
					<cfquery name="qKillTradeTeams" datasource="lwfa">	
						select distinct tradeID from trades where playerID = #thisDumped#	 AND statusID = 1	
					</cfquery>
					<cfif qKillTradeTeams.recordcount>
						<cfquery name="qKillTrades" datasource="lwfa">
							UPDATE trades SET statusID = 6 WHERE tradeID IN (#valuelist(qKillTradeTeams.tradeID)#)
						</cfquery>
					</cfif>
				<cfelse>
					<!--- if so, deactivate that player --->
					<cfquery name="qDeactPlayer" datasource="lwfa">
						update 	players
						set 		inj='Y',active='N'
						where	playerID=#thisDumped#
					</cfquery>
				</cfif>
				<!--- add the claimed player --->
				<cfquery name="qAddPlayer" datasource="lwfa">
					update 	players
					set 		teamID=#thisClaimTm#,active='N'
					where	playerID=#thisClaimed#
				</cfquery>
				<!--- set this claim to 'approved' --->
				<cfquery name="qApproveClaims" datasource="lwfa">
					update	claims
					set		statusID=3,date_processed=now()
					where 	claimID=#thisClaim# and statusID=1
				</cfquery>
				<!--- set other claims for the same player to 'denied' --->
				<cfquery name="qKillSameClaims" datasource="lwfa">
					update	claims
					set		statusID=2,date_processed=now()
					where 	clmid=#thisClaimed# and statusID=1
				</cfquery>
			</cfif>
			<cfif thisDumped neq ''>
				<!--- set other claims for the same player to 'denied' --->
				<cfquery name="qKillSameClaims2" datasource="lwfa">
					update	claims
					set		statusID=2,date_processed=now()
					where 	dmpid=#thisDumped# and statusID=1 and claimID <> #thisClaim#
				</cfquery>
			</cfif>
			<!--- update the waiver order --->
			<cfset waiverOrderList=listDeleteAt(waiverOrderList,1)>
			<cfset waiverOrderList=listAppend(waiverOrderList,thisClaimTm)>
		<!---  
		<cfelse>
			<cfquery name="qKillBogusClaims" datasource="lwfa">
				update	claims
				set		status='denied'
				where 	id=#thisClaim#
			</cfquery>
		</cfif>
		--->
		<cfquery datasource="lwfa">
			UPDATE 	standings
			SET		claimsrank = claimsrank - 1
		</cfquery>
		<cfquery datasource="lwfa">
			UPDATE 	standings
			SET		claimsrank = 16
			WHERE 	teamID = #thisClaimTm#
		</cfquery>
	<cfelse>
		<cfset waiverOrderList=listrest(waiverOrderList)>
	</cfif>
</cfloop>

<cfquery name="qOrderedTeams" datasource="lwfa">
	select teamID from standings order by claimsrank
</cfquery>
<cfloop query="qOrderedTeams">
	<cfquery datasource="lwfa">
		UPDATE 	standings
		SET		claimsrank = #currentrow#
		WHERE 	teamID = #teamID#
	</cfquery>
</cfloop>