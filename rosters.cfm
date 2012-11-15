<cfparam name="url.teamID" default="6">
<cfparam name="url.tradeTeamID" default="23">

<link rel="stylesheet" type="text/css" href="css/rosters.css">

<cfset qTeam = application.cfc.data.getRosters()>

<cfif NOT structKeyExists(qTeam,'byeweek')>
	<cfset structDelete( application.cfc, 'data' )>
	<cfset application.cfc.data = CreateObject('component','cfc.data')>
</cfif>

<!--- EXPORT TO PDF SECTION --->
<cfif structKeyExists(url,'printable')>
<cfset filename = "lwfa_rosters.pdf">

<cfset thisPath = ExpandPath("*.*")>
<cfset thisDirectory = GetDirectoryFromPath(thisPath)>
<cfdocument filename="#thisDirectory#\files\#filename#" format="PDF" pagetype="letter" orientation="portrait" permissions="allowprinting,allowcopy" backgroundvisible="no" overwrite="yes" fontembed="yes" encryption="128-bit">
<cfset strRosters = structnew()>
<cfoutput query="qTeam">
	<cfset strRosters[ qTeam.team[currentrow] ] = structnew()>
	<cfloop list="QB,RB,WR,TE,K,D" index="t">
		<cfset strRosters[ qTeam.team[currentrow] ][ t ] = arraynew(1)>
	</cfloop>
	<cfif currentrow eq 1 OR qTeam.team[currentrow] neq qTeam.team[currentrow-1]>
		<cfset sOwner = application.cfc.data.getOwner(qTeam.teamID)>
		<div id="teamNameSect">
			#qTeam.team[currentrow]# #qTeam.nickname[currentrow]# 
			<A href="mailto:#sOwner.email#">#sOwner.fullname#</A>
		</div>
		<table border=0 cellpadding="0" cellspacing="0" style="border:1px solid black;border-width:1px 0 0 1px;">
	</cfif>
	<cfif qTeam.pos[currentrow] neq qTeam.pos[currentrow-1]>
	<cfset counter=0>
		<tr>
			<td class="posSect" style="background-color:black;border:1px solid black;border-width:0 1px 1px 0;"><b style="font:12px arial;color:white;">#pos#</b></td>
		<cfset counter+=1>
	</cfif>
	<cfset arrayAppend(strRosters[ qTeam.team[currentrow] ][ qTeam.pos[currentrow] ],left(first,1)&". "&last)>
	<td style="font:10px arial;border:1px solid black;border-width:0 1px 1px 0;width:70px;">#left(first,1)# #last#</td>
	<cfset counter+=1>
	<cfif qTeam.pos[currentrow] neq qTeam.pos[currentrow+1]>
		<cfset blanks=9-counter>
		<cfloop from=1 to="#blanks#" index=u><td>&nbsp;</td></cfloop>
		</tr>
	</cfif>
	<cfif qTeam.team[currentrow] neq qTeam.team[currentrow+1]>
		</table><br>
	</cfif>
</cfoutput>
</cfdocument>
<CFHEADER NAME="content-disposition" VALUE="attachment; filename=#filename#">
<cfcontent type="application/pdf" file="d:\home\tallkellys.com\wwwroot\2012\files\#filename#" deletefile="yes">
<cfabort>
</cfif>


<!--- DISPLAY IN BROWSER SECTION --->
<div style="margin-left:600px;">
<A href="rosters.cfm?printable=1" style="color:white;font-weight:bold;"><img src="/2012/images/pdf.gif" border=0 /> Printable</A>
</div>
<div id="rosterArea">
<cfset strRosters = structnew()>
<cfprocessingdirective suppresswhitespace="true">
<cfoutput query="qTeam">
	<cfset strRosters[ qTeam.team[currentrow] ] = structnew()>
	<cfloop list="QB,RB,WR,TE,K,D" index="t">
		<cfset strRosters[ qTeam.team[currentrow] ][ t ] = arraynew(1)>
	</cfloop>
	<cfif currentrow eq 1 OR qTeam.team[currentrow] neq qTeam.team[currentrow-1]>
		<cfset sOwner = application.cfc.data.getOwner(qTeam.teamID)>
		<div id="teamNameSect">
			<A href="teampage.cfm?teamID=#qTeam.teamID#">#qTeam.team[currentrow]# #qTeam.nickname[currentrow]#</a>
			<span class="biglink"> - <A href="mailto:#sOwner.email#">#sOwner.fullname#</A></span>
		</div>
		<table id="teamTbl" cellpadding="0" cellspacing="0">
	</cfif>
	<cfif qTeam.pos[currentrow] neq qTeam.pos[currentrow-1]>
	<cfset counter=0>
		<tr>
			<td class="posSect">#pos#</td>
		<cfset counter+=1>
	</cfif>
	<cfset arrayAppend(strRosters[ qTeam.team[currentrow] ][ qTeam.pos[currentrow] ],left(first,1)&". "&last)>
	<td class="playercell"><a href="playerpage.cfm?playerID=#playerID#" style="display:block;">#left(first,1)# #last# (#byeweek#)</a></td>
	<cfset counter+=1>
	<cfif qTeam.pos[currentrow] neq qTeam.pos[currentrow+1]>
		<cfset blanks=8-counter>
		<cfloop from=1 to="#blanks#" index=u><td>&nbsp;</td></cfloop>
		</tr>
	</cfif>
	<cfif qTeam.team[currentrow] neq qTeam.team[currentrow+1]>
		</table>
	</cfif>
</cfoutput>
</cfprocessingdirective>
</div>
