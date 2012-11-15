<cfif structKeyExists(form,'delplayer')>

	<cfquery name="delOldPlayers" datasource="lwfa">
		delete from players where playerID IN (#form.delplayer#)
	</cfquery>

<cfelse>

	<cfquery name="qImports" result="foo" datasource="lwfa">
		select		playerID,first,last,nflteam ,pos
		from 		players
		where		playerID NOT IN (select distinct playerid from active_player_log) 
		order by 	nflteam,view,last
	</cfquery>
	
	<cfoutput>
	<form action="#cgi.script_name#" method="post">
	<cfloop query="qImports">
		<input type="checkbox" name="delplayer" value="#playerID#" CHECKED> #pos# #first# #last#, #nflteam#<br />
	</cfloop>
	<input type="submit">
	</form>
	</cfoutput>

</cfif>

<cfabort>
<cfset aRanks = []>
<cfset aRanks[1] = 21>
<cfset aRanks[2] = 7>
<cfset aRanks[3] = 13>
<cfset aRanks[4] = 4>
<cfset aRanks[5] = 6>
<cfset aRanks[6] = 9>
<cfset aRanks[7] = 16>
<cfset aRanks[8] = 1>
<cfset aRanks[9] = 14>
<cfset aRanks[10] = 23>
<cfset aRanks[11] = 10>
<cfset aRanks[12] = 11>
<cfset aRanks[13] = 25>
<cfset aRanks[14] = 24>
<cfset aRanks[15] = 3>
<cfset aRanks[16] = 8>

<cfloop from=1 to=16 index="idx">
	<cfquery datasource="lwfa">
		UPDATE 	standings
		SET		claimsrank=#idx#
		WHERE 	teamID=#aRanks[idx]#
	</cfquery>
</cfloop>

<cfabort>

<cfquery name="qSked" datasource="lwfa">
	select * from sked_raw where 1=a
</cfquery>
<cfdump var="#qSked#" expand="false">

<cfset currwk = 0>
<cfset currdate = ''>
<cfset getDate = 0>

<cfset sTime = structnew()>
<cfset sTime[ '0.854' ] = createTime(20,30,0)>
<cfset sTime[ '0.542' ] = createTime(13,0,0)>
<cfset sTime[ '0.677' ] = createTime(16,15,0)>
<cfset sTime[ '0.847' ] = createTime(20,20,0)>
<cfset sTime[ '0.792' ] = createTime(19,0,0)>
<cfset sTime[ '0.927' ] = createTime(22,15,0)>
<cfset sTime[ '0.67' ] = createTime(16,5,0)>
<cfset sTime[ '0.521' ] = createTime(12,30,0)>
<cfset sTime[ '0.812' ] = createTime(19,30,0)>

<cftry>
<cfset newSked = querynew('weekno,gamedate,nfltm,opp,gametime,tv','integer,date,varchar,varchar,time,varchar')>
<cfloop query="qSked">
	<cfif left(qSked.team,4) eq "Week">
		<cfset currwk = mid(qSked.team,6,len(qSked.team))>
		<cfif currwk gt 16><cfbreak></cfif>
	<cfelseif qSked.stadium eq "stadium" OR (qSked.stadium eq "" AND qSked.team neq "" AND qSked.team DOES NOT CONTAIN "bye")>
		<cfset thisDate = listToArray(qSked.team,", ")>
		<cfif thisDate[2] eq "Sep">
			<cfset currdate = createDate(2012,9,thisDate[3])>		
		<cfelseif thisDate[2] eq "Oct">
			<cfset currdate = createDate(2012,10,thisDate[3])>		
		<cfelseif thisDate[2] eq "Nov">
			<cfset currdate = createDate(2012,11,thisDate[3])>		
		<cfelseif thisDate[2] eq "Dec">
			<cfset currdate = createDate(2012,12,thisDate[3])>		
		</cfif>
		<cfset getDate = 0>
	<cfelseif qSked.tv neq ''>
		<cfset queryAddRow(newSked)>
		<cfset querySetCell(newSked,'weekno',currwk)>
		<cfset querySetCell(newSked,'gamedate',currdate)>
		<cfset querySetCell(newSked,'nfltm',listGetAt(qSked.team,2," @ "))>
		<cfset querySetCell(newSked,'opp',listGetAt(qSked.team,1," @ "))>
		<cfset querySetCell(newSked,'gametime',sTime[qSked.gametime])>
		<cfset querySetCell(newSked,'tv',tv)>
		<cfset queryAddRow(newSked)>
		<cfset querySetCell(newSked,'weekno',currwk)>
		<cfset querySetCell(newSked,'gamedate',currdate)>
		<cfset querySetCell(newSked,'nfltm',listGetAt(qSked.team,1," @ "))>
		<cfset querySetCell(newSked,'opp',"@" & listGetAt(qSked.team,2," @ "))>
		<cfset querySetCell(newSked,'gametime',sTime[qSked.gametime])>
		<cfset querySetCell(newSked,'tv',tv)>
	</cfif>
</cfloop>
	<cfcatch>
		<h2><cfoutput>#qSked.currentrow#</cfoutput></h2>
		<cfdump var="#cfcatch#"><cfabort>
	</cfcatch>
</cftry>


<cfloop query="newSked">
	<cfset newnfltm = replacelist(nfltm,"TBB,SFO,NOS,GBP,SDC,KCC","TB,SF,NO,GB,SD,KC")>
	<cfset newopp = replacelist(opp,"TBB,SFO,NOS,GBP,SDC,KCC,@TBB,@SFO,@NOS,@GBP,@SDC,@KCC","TB,SF,NO,GB,SD,KC,@TB,@SF,@NO,@GB,@SD,@KC")>
	<cfquery datasource="lwfa">
		INSERT INTO nflschedule (weekNo,gamedate,date,nfltm,opp,gametime,tv)
		VALUES (#weekno#,#gamedate#,#gamedate#,'#newnfltm#','#newopp#',#gametime#,'#tv#')
	</cfquery>
</cfloop>