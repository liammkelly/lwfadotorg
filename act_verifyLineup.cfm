<cfparam name="playerList" default="">
<cfsilent>
<cfset aPyrs = arraynew(1)>
<cfset lPyrs = ''>
<cfloop list="#playerList#" index="c" delimiters="status=">
	<cfif len(c) gt 2>
		<cfset lPyrs=listAppend(lPyrs,replace(c,'&',''))>
	</cfif>
</cfloop>
</cfsilent>
<cfif listLen(lPyrs) neq 8>
	You have submitted a lineup with<cfif listLen(lPyrs) lt 8> only</cfif> <cfoutput>#listLen(lPyrs)#</cfoutput> players.<cfabort>
<cfelse>
	<cfquery name="qLineup" datasource="lwfa">
		select pos from players where playerID IN (#lPyrs#) order by view
	</cfquery>
	<cfif valueList(qLineup.pos) neq "QB,RB,RB,WR,WR,TE,K,D" AND valueList(qLineup.pos) neq "QB,RB,WR,WR,WR,TE,K,D" AND valueList(qLineup.pos) neq "QB,RB,WR,WR,TE,TE,K,D">
		<cfoutput>#playerList#</cfoutput><br />You have submitted an illegally-configured lineup.<cfabort>
	</cfif>
</cfif>
<cfquery name="qUpd" datasource="lwfa">
	UPDATE players
	SET		active = 'N'
	WHERE	teamID = #updTeamID#
</cfquery>
<cfquery name="qUpd" datasource="lwfa">
	UPDATE players
	SET		active = 'Y'
	WHERE	teamID = #updTeamID# AND playerID in (#lPyrs#)
</cfquery>