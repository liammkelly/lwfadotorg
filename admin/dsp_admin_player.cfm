<cfparam name="playerName" default="">
<cfparam name="playerID" default="">

<script language="javascript"  type="text/javascript" src="/scripts/jquery-1.4.2.min.js"></script>
<link type="text/css" rel="stylesheet" href="/scripts/jQueryUI/css/jquery.autocomplete.css">
<script language="javascript" src="/scripts/jQueryUI/jquery.autocomplete.js"></script>

<cfif structKeyExists(form,'playerID')>

<cfif structKeyExists(form,'orig_playerID') AND form.orig_playerID gt 0>
	<cfquery datasource="lwfa">
		UPDATE 	players 
		SET			first=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fname#">,
						last=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.lname#">,
						pos=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pos#">,
						nflteam=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nflteam#">,
						teamID=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.lwfateam#">,
						inj=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.injured#">,
						active=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.active#">
		WHERE		playerID =<cfqueryparam cfsqltype="cf_sql_integer" value="#form.playerID#">
	</cfquery>
<cfelse>
	<cfswitch expression="#form.pos#">
		<cfcase value="QB"><cfset view = 'A'></cfcase>
		<cfcase value="RB"><cfset view = 'B'></cfcase>
		<cfcase value="WR"><cfset view = 'C'></cfcase>
		<cfcase value="TE"><cfset view = 'D'></cfcase>
		<cfcase value="K"><cfset view = 'E'></cfcase>
		<cfcase value="D"><cfset view = 'F'></cfcase>
	</cfswitch>
	<cftry>
	<cfquery datasource="lwfa" result="result">
		INSERT INTO 
			players (
			first,last,pos,nflteam,teamID,inj,active,playerID,view
			) 
			values (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fname#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.lname#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pos#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nflteam#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.lwfateam#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.injured#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.active#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.playerID#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#view#">
			)				
	</cfquery>
	<cfcatch type="any"><cfdump var="#cfcatch#"><cfabort></cfcatch>
	</cftry>
	<cfdump var="#result#">
</cfif>

<cfelseif isNumeric(playerID) OR playerName neq ''>

	<cfsilent>
		<!--- <cfset playerID=0> --->
		<cfif playerName neq ''>
			<cfquery name="qPlayerID" datasource="lwfa">
				select playerID from players where last='#trim(listGetAt(playerName,1))#'	AND first='#trim(listGetAt(playerName,2))#'
			</cfquery>
			<cfset playerID = qPlayerID.playerID>
		</cfif>
	
		<cfquery name="qNFLTeams" datasource="lwfa">
			select distinct nflteam from teamnames order by nflteam
		</cfquery>
		<cfquery name="qPosList" datasource="lwfa">
			select distinct pos,view from players order by view
		</cfquery>
		<cfquery name="qTeams" datasource="lwfa">
			select * from teams order by name
		</cfquery>
	
		<cfif playerID gt 0>
			<cfquery name="SearchPlayers" datasource="lwfa">
				select * from players where playerID=#playerID#
			</cfquery>
			<cfset variables.playerID = SearchPlayers.playerID>
			<cfset variables.first = SearchPlayers.first>
			<cfset variables.last = SearchPlayers.last>
			<cfset variables.nflteam = SearchPlayers.nflteam>
			<cfset variables.pos = SearchPlayers.pos>
			<cfset variables.teamID = SearchPlayers.teamID>
			<cfset variables.inj = SearchPlayers.inj>
			<cfset variables.active = SearchPlayers.active>
		<cfelse>
			<cfset variables.playerID = 0>
			<cfset variables.first = ''>
			<cfset variables.last = ''>
			<cfset variables.nflteam = ''>
			<cfset variables.pos = ''>
			<cfset variables.teamID = 0>
			<cfset variables.inj = ''>
			<cfset variables.active = ''>
		</cfif>
	</cfsilent>	
	<script language="javascript"  type="text/javascript" src="/scripts/jquery-1.2.3.pack.js"></script>
	<script type="text/javascript" language="javascript">
		$().ready( function() {
			$('select#selWeekNo').change( function() {
				$('iframe#selWeekForm').attr('src','dsp_admin_player_stats.cfm?weekNo='+$(this).val()+'&playerID='+$('input#playerID').val());
			})
		})
	</script>
	<CFOUTPUT>
	<TABLE>
	<FORM METHOD="post" ACTION="#cgi.script_name#">
	<TR>
		<TD>Yahoo ID:</TD>
		<TD colspan=3><INPUT TYPE="text" NAME="playerID" ID="playerID" VALUE="#variables.playerID#" size=5><INPUT TYPE="hidden" NAME="orig_playerID" VALUE="#variables.playerID#" ></TD>
	</TR>
	<TR>
		<TD>First:</td><td><INPUT TYPE="text" NAME="fname" VALUE="#variables.first#" size=10></TD>
		<TD>Position:</TD>
		<TD>
			<SELECT name="pos">
			<cfloop query="qPosList">
			<OPTION value="#qPosList.pos#"<CFIF qPosList.pos eq variables.pos> SELECTED</CFIF>>#qPosList.pos#</OPTION>
			</cfloop>
			</SELECT>
		</TD>
	</TR>
	<TR>
		<TD>Last:</td><td><INPUT TYPE="text" NAME="lname" VALUE="#variables.last#" size=10></TD>
		<TD>NFL Team:
		</td><td>	<SELECT name="nflteam">
			<OPTION value="FA">FA</OPTION>
			<CFloop query="qNFLTeams">
			<OPTION value="#ucase(qNFLTeams.nflteam)#"<CFIF variables.nflteam eq qNFLTeams.nflteam> SELECTED</CFIF>>#ucase(qNFLTeams.nflteam)#</OPTION>
			</cfloop>
			</SELECT>
		</TD>
	</TR>
	<TR>
		<TD>LWFA Team:</TD>
		<TD colspan=3>
			<SELECT name="lwfateam">
			<OPTION value="0">None</OPTION>
			<cfloop query="qTeams">
			<OPTION value="#qTeams.teamID#"<CFIF variables.teamID eq qTeams.teamID> SELECTED</CFIF>>#qTeams.name#</OPTION>
			</cfloop>
			</SELECT>
		</TD>
	</TR>
	<TR>
		<TD>Injury Status:</TD>
		<TD>
			<SELECT name="injured">
			<OPTION<CFIF variables.Inj EQ 'N'> SELECTED</CFIF>>N
			<OPTION<CFIF variables.Inj EQ 'Y'> SELECTED</CFIF>>Y
			</SELECT>
		</TD>
		<TD colspan=2>Active:
			<SELECT name="active">
			<OPTION<CFIF variables.active EQ 'N'> SELECTED</CFIF>>N
			<OPTION<CFIF variables.active EQ 'Y'> SELECTED</CFIF>>Y
			</SELECT>
		</TD>
	</TR>
	<TR>
		<TD colspan=2><INPUT TYPE="submit" VALUE="Submit"></TD>
	</TR>
	</FORM>
	</TABLE>
	<select name="selWeekNo" id="selWeekNo">
		<option>select</option>
		<cfloop from=1 to=#application.currwk# index="d">
		<option value="#d#">#d#</option>
		</cfloop>
	</select><br />
	<iframe name="selWeekForm" id="selWeekForm" frameborder="0" height="400" width="400"></iframe>
	</cfoutput>

	
<cfelse>

	<script language="javascript"  type="text/javascript" src="/scripts/jquery-1.2.3.pack.js"></script>
	<link type="text/css" rel="stylesheet" href="/scripts/jQueryUI/css/jquery.autocomplete.css">
	<script language="javascript" src="/scripts/jQueryUI/jquery.autocomplete.js"></script>
	<script type="text/javascript" language="javascript">
		function selectItem(row) {
			var player = $('input#updPlayer').val();
			window.location = 'dsp_admin_player.cfm?playerName='+player;
		}
		$().ready( function() {
			$('input#updPlayer').autocomplete(
				'/2012/act_searchPlayers.cfm?showheader=false', { 
					minChars:4,
					width:150,
					matchContains:1,
					maxItemsToShow:25,
					onItemSelect:selectItem
				});
			})
	</script>

	<FORM METHOD="post" ACTION="#cgi.script_name#">
	<input type="text" size="24" name="updPlayer" id="updPlayer">
	</FORM>

</cfif>