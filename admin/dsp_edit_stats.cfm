<cfif structKeyExists(form,'updStat')>
	<cfquery name="qStats" datasource="lwfa">
		SELECT		pd.playerID
		FROM		playerdata pd join players p on p.playerID=pd.playerID
		WHERE		p.first = '#trim(listGetAt(updPlayer,2))#' AND
						p.last = '#trim(listGetAt(updPlayer,1))#' AND
						pd.weekNo = #updWeek#
	</cfquery>

	<cfif qStats.recordcount>
		<cfquery name="uStats" datasource="lwfa">
			UPDATE 	playerdata
			SET			#form.updStat#=#form.newValue#
			WHERE		playerID=#qStats.playerID# AND
							weekNo = #updWeek#
		</cfquery>
		<cfset thisPlayerID = qStats.playerID>
	<cfelse>
		<cfquery name="qPlayer" datasource="lwfa">
			SELECT 	playerID,nflteam,active
			FROM		players 
			WHERE		first = '#trim(listGetAt(updPlayer,2))#' AND
							last = '#trim(listGetAt(updPlayer,1))#'
		</cfquery>
		<cfquery name="uStats" datasource="lwfa" result="result">
			INSERT INTO 	playerdata (#form.updStat#,playerID,weekNo,nflteam,active)
			VALUES (#form.newValue#,#qPlayer.playerID#,#updWeek#, '#qPlayer.nflteam#','#qPlayer.active#')
		</cfquery>
		<cfset thisPlayerID = qPlayer.playerID>
	</cfif>

	<cftry>
	<cfquery name="uStats" datasource="lwfa">
		UPDATE 	playerdata pd join players p on p.playerID=pd.playerID
		SET			pd.#form.updStat#=#form.newValue#
		WHERE		pd.playerID = #thisPlayerID# AND
						pd.weekNo = #updWeek#
	</cfquery>
	<cfcatch type="any"><h2>there was a problem</h2><cfdump var="#cfcatch#"><cfabort></cfcatch>
	</cftry>

	<cfquery name="qPlayerWeek" datasource="lwfa">
		select 		pd.* 
		from 		playerdata pd 
		WHERE		pd.playerID = #thisPlayerID# AND
						pd.weekNo = #updWeek#
	</cfquery>

	<CF_STAT_COMPILE_NEW
		passyds=#qPlayerWeek.passyds#
		passTD=#qPlayerWeek.passTD#
		passINT=#qPlayerWeek.passINT#
		rushTD=#qPlayerWeek.rushTD#
		rushyds=#qPlayerWeek.rushyds#
		recyds=#qPlayerWeek.recyds#
		recTD=#qPlayerWeek.recTD#
		totalfum=#qPlayerWeek.fumble#
		tackles=#qPlayerWeek.tackle#
		sacks=#qPlayerWeek.sack#
		defint=#qPlayerWeek.defint#
		inttd=#qPlayerWeek.inttd#
		fumrec=#qPlayerWeek.fr#
		fumtd=#qPlayerWeek.frtd#
		forced=#qPlayerWeek.ff#
		lfgoal=#qPlayerWeek.lfg#
		sfgoal=#qPlayerWeek.sfg#
		fgoal=#qPlayerWeek.fg#
		xpts=#qPlayerWeek.xp#
		kryds=#qPlayerWeek.kryds#
		krtd=#qPlayerWeek.krtd#
		pryds=#qPlayerWeek.pryds#
		prtd=#qPlayerWeek.prtd#
		pass2pc=#qPlayerWeek.pass2pc#
		rec2pc=#qPlayerWeek.rec2pc#
		rush2pc=#qPlayerWeek.rush2pc# 
		defintyds=#qPlayerWeek.defintyds# 
		asstack=#qPlayerWeek.asstack# 
		>
	<cfset LOCAL.scoreline=scoreline>
	<cfset LOCAL.scoredetail=scoredetail>

	<cfquery name="uStats" datasource="lwfa">
		UPDATE 	playerdata pd 
		SET			pd.total = #LOCAL.scoreline#,pd.line = '#LOCAL.scoredetail#'
		WHERE		pd.playerID=#thisPlayerID# AND
						pd.weekNo = #updWeek#
	</cfquery>	

	<h3><cfoutput>#updPlayer#</cfoutput> updated.</h3>
</cfif>

<script language="javascript"  type="text/javascript" src="/scripts/jquery-1.4.2.min.js"></script>
<link type="text/css" rel="stylesheet" href="/scripts/jQueryUI/css/jquery.autocomplete.css">
<script language="javascript" src="/scripts/jQueryUI/jquery.autocomplete.js"></script>
<script type="text/javascript" language="javascript">
	$().ready( function() {
		$('input#updPlayer').autocomplete(
			'/2012/act_searchPlayers.cfm?showheader=false', { 
				minChars:4,
				width:150,
				matchContains:1,
				maxItemsToShow:10
			});
		$('select#updStat').blur( function() {
			var updPlayer = $('input#updPlayer').val();
			var updWeek = $('select#updWeek').val();
			var updStat = $('select#updStat').val();
			$.get('act_getOldStat.cfm?showheader=false',{updPlayer:updPlayer,updWeek:updWeek,updStat:updStat}, function(data) {
				$('td#oldValue').html(data).css('backgroundColor','yellow');
			});
		})
	})
</script>
<style>
	TD#oldValue {
		font:bold 14px verdana;
	}
</style>

<cfoutput>
<FORM METHOD="post" ACTION="#cgi.script_name#" onSubmit="return confirm($('input##updPlayer').val()+': '+$('input##newValue').val()+'  '+$('select##updStat').val()+'\n\nAre you sure?')">
<table>
	<tr>
		<td>
		<input type="text" size="24" name="updPlayer" id="updPlayer">
		</td>
		<td>
		Week
		<select name="updWeek" id="updWeek">
			<cfloop from=1 to="#application.currwk#" index="r">
			<option value="#r#"<cfif application.currwk eq r> SELECTED</cfif>>#r#</option>
			</cfloop>
		</select>
		</td>
		<td>
		<select name="updStat" id="updStat">
			<option></option>
			<cfloop list="passyds,passtd,passint,rushyds,rushtd,recyds,rectd,fumble,sfg,fg,lfg,xp,tackle,sack,defint,ff,fr,frtd,inttd,kryds,krtd,pryds,prtd,pass2pc,rush2pc,rec2pc,asstack,defintyds" index="s">
			<option value="#s#">#s#</option>
			</cfloop>
		</select>
		<input type="text" name="newValue" id="newValue" size=9>
		</td>
	</tr>
	<tr>
		<td colspan=3><input type="submit"></td>
		<td id="oldValue"></td>
	</tr>
</table>
</FORM>
</cfoutput>

