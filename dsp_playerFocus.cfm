<cfparam name="playerID" default="">

<cfquery name="qPlayerFocus" datasource="lwfa">
	SELECT		p.first,p.last,p.pos,p.nfltm,
					t.name,
					s.*
					
	FROM		players p 
						JOIN teams t USING (teamID)
						JOIN playerstats s USING (playerID)
						
	WHERE		p.playerID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#playerID#" />
</cfquery>

<cfoutput query="qPlayerFocus">
<div>
	<img src=>
</div>
</cfoutput>