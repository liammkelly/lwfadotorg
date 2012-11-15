<cfif structKeyExists(form,'action')>

	<CFSET scoredetail="">
	<CFIF passyds neq 0><CFSET scoredetail=scoredetail&passyds&" pass yds, "></CFIF>
	<CFIF passTD neq 0><CFSET scoredetail=scoredetail&passTD&" pass TD, "></CFIF>
	<CFIF passint neq 0><CFSET scoredetail=scoredetail&passint&" INT, "></CFIF>
	<CFIF rushyds neq 0><CFSET scoredetail=scoredetail&rushyds&" rush yds, "></CFIF>
	<CFIF rushTD neq 0><CFSET scoredetail=scoredetail&rushTD&" rush TD, "></CFIF>
	<CFIF recyds neq 0><CFSET scoredetail=scoredetail&recyds&" rec yds, "></CFIF>
	<CFIF recTD neq 0><CFSET scoredetail=scoredetail&recTD&" rec TD, "></CFIF>
	<CFIF fumble neq 0><CFSET scoredetail=scoredetail&fumble&" FL, "></CFIF>
	<CFIF sack neq 0><CFSET scoredetail=scoredetail&sack&" sck, "></CFIF>
	<CFIF defint neq 0><CFSET scoredetail=scoredetail&defint&" INT, "></CFIF>
	<CFIF defintyds neq 0><CFSET scoredetail=scoredetail&defintyds&" INT yds, "></CFIF>
	<CFIF inttd neq 0><CFSET scoredetail=scoredetail&inttd&" INT for TD, "></CFIF>
	<CFIF fr neq 0><CFSET scoredetail=scoredetail&fr&" FR, "></CFIF>
	<CFIF frtd neq 0><CFSET scoredetail=scoredetail&frtd&" FR for TD, "></CFIF>
	<CFIF ff neq 0><CFSET scoredetail=scoredetail&ff&" FF, "></CFIF>
	<CFIF lfg neq 0><CFSET scoredetail=scoredetail&lfg&" LFG, "></CFIF>
	<CFIF sfg neq 0><CFSET scoredetail=scoredetail&sfg&" SFG, "></CFIF>
	<CFIF fg neq 0><CFSET scoredetail=scoredetail&fg&" FG, "></CFIF>
	<CFIF xp neq 0><CFSET scoredetail=scoredetail&xp&" XP, "></CFIF>
	<CFIF kryds neq 0><CFSET scoredetail=scoredetail&kryds&" KR yds, "></CFIF>
	<CFIF krtd neq 0><CFSET scoredetail=scoredetail&krtd&" KR TD, "></CFIF>
	<CFIF pryds neq 0><CFSET scoredetail=scoredetail&pryds&" PR yds, "></CFIF>
	<CFIF prtd neq 0><CFSET scoredetail=scoredetail&prtd&" PR TD, "></CFIF>
	<CFIF pass2pc neq 0><CFSET scoredetail=scoredetail&pass2pc&" pass 2PC, "></CFIF>
	<CFIF rush2pc neq 0><CFSET scoredetail=scoredetail&rush2pc&" rush 2PC, "></CFIF>
	<CFIF rec2pc neq 0><CFSET scoredetail=scoredetail&rec2pc&" rec 2PC, "></CFIF>
	<CFIF tackle neq 0><CFSET scoredetail=scoredetail&tackle&"/"&asstack&" tckl, "></CFIF>
	<CFIF len(scoredetail) gt 0>
		<CFSET scoredetail=left(trim(scoredetail),len(scoredetail)-2)>
	<CFELSE>
		<CFSET scoredetail="No stats">
	</CFIF>
	<!--- END: build the scoredetail --->
	
	<!--- BEGIN: build the score total --->
	<CFSET ones=tackle+pass2pc+xp+(asstack/2)>
	<CFSET twos=(ff+rec2pc+rush2pc+sfg)*2>
	<CFSET threes=(fg+fr+sack+defint)*3>
	<CFSET fours=(lfg)*4>
	<CFSET sixes=(passtd+rushtd+inttd+rectd+frtd+krtd+prtd)*6>
	<CFSET bigyardage=(rushyds+recyds+pryds)/10>
	<CFSET smallyardage=(passyds+kryds+defintyds)/20>
	<CFSET negatives=(passint+fumble)*(-2)>
	<CFSET scoreline=numberformat(evaluate(ones+twos+threes+fours+sixes+bigyardage+smallyardage+negatives),"0.00")>
	<!--- END: build the score total --->
	
	<CFQUERY name="uPlayerWeek" datasource="lwfa"> 
		INSERT INTO 
		playerdata 
		(
		passyds,
		tackle,
		passTD,
		sack,
		passINT,
		ff,
		rushyds,
		fr,
		rushTD,
		defint,
		recyds,
		frtd,
		recTD,
		inttd,
		pryds,
		sfg,
		prtd,
		fg,
		kryds,
		lfg,
		krtd,
		xp,
		pass2pc,
		rush2pc,
		fumble,
		rec2pc,
		asstack,
		defintyds,
		line,
		total,
		weekno,
		playerID,
		teamID,
		nflteam,
		active,
		updated
		)
		VALUES
		(
		#passyds#,
		#tackle#,
		#passTD#,
		#sack#,
		#passint#,
		#ff#,
		#rushyds#,
		#fr#,
		#rushTD#,
		#defint#,
		#recyds#,
		#frtd#,
		#recTD#,
		#inttd#,
		#pryds#,
		#sfg#,
		#prtd#,
		#fg#,
		#kryds#,
		#lfg#,
		#krtd#,
		#xp#,
		#pass2pc#,
		#rush2pc#,
		#fumble#,
		#rec2pc#,
		#asstack#,
		#defintyds#,
		'#scoredetail#',
		#scoreline#,
		#updweek#,
		#playerid#,
		#teamID#,
		'#NFLteam#',
		'#active#',
		'Y'
		)
		ON DUPLICATE KEY UPDATE passyds=#passyds#, passtd=#passtd#, passint=#passint#, rushyds=#rushyds#, rushtd=#rushtd#, recyds=#recyds#, rectd=#rectd#, fumble=#fumble#, sfg=#sfg#, fg=#fg#, lfg=#lfg#, xp=#xp#, tackle=#tackle#, sack=#sack#, defint=#defint#, ff=#ff#, fr=#fr#, frtd=#frtd#, inttd=#inttd#, kryds=#kryds#, krtd=#krtd#, pryds=#pryds#, prtd=#prtd#, pass2pc=#pass2pc#, rush2pc=#rush2pc#, rec2pc=#rec2pc#, asstack=#asstack#, defintyds=#defintyds#,line='#scoredetail#',total=	#scoreline# 
	</CFQUERY>
	<h2>Updated!</h2>
	
<cfelse>

	<cfquery name="qPlayerData" datasource="lwfa">
		SELECT 	*
		FROM		playerdata
		WHERE		playerID = #playerID# AND
						weekNo = #weekNo#
	</cfquery>
	<cfif qPlayerData.recordcount eq 0>
		<cfset LOCAL.passyds = 0>
		<cfset LOCAL.passtd = 0>
		<cfset LOCAL.passint = 0>
		<cfset LOCAL.rushyds = 0>
		<cfset LOCAL.rushtd = 0>
		<cfset LOCAL.fumble = 0>
		<cfset LOCAL.recyds = 0>
		<cfset LOCAL.rectd = 0>
		<cfset LOCAL.sfg = 0>
		<cfset LOCAL.fg = 0>
		<cfset LOCAL.lfg = 0>
		<cfset LOCAL.xp = 0>
		<cfset LOCAL.ff = 0>
		<cfset LOCAL.defint = 0>
		<cfset LOCAL.defintyds = 0>
		<cfset LOCAL.inttd = 0>
		<cfset LOCAL.tackle = 0>
		<cfset LOCAL.asstack = 0>
		<cfset LOCAL.sack = 0>
		<cfset LOCAL.fr = 0>
		<cfset LOCAL.frtd = 0>
		<cfset LOCAL.kryds = 0>
		<cfset LOCAL.krtd = 0>
		<cfset LOCAL.pryds = 0>
		<cfset LOCAL.prtd = 0>
		<cfset LOCAL.pass2PC = 0>
		<cfset LOCAL.rush2PC = 0>
		<cfset LOCAL.rec2PC = 0>
	<cfelse>
		<cfset LOCAL = qPlayerData>
	</cfif>
	<cfquery name="qPlayerInfo" datasource="lwfa">
		select 	nflteam,active,teamID
		from		players
		where	playerID=#playerID#
	</cfquery>
	<cfset LOCAL.nflteam = qPlayerInfo.nflteam>
	<cfset LOCAL.active = qPlayerInfo.active>
	<cfset LOCAL.teamID = qPlayerInfo.teamID>
	
	<form action="<cfoutput>#cgi.script_name#</cfoutput>" method="post">
	<cfoutput>
		<table cellpadding="0" cellspacing="0" border=0>	
			<tr>
				<td>Pass Yds: </td><td><input type="text" size="2" name="passyds" value="#LOCAL.passyds#"></td>
				<td>TD: </td><td><input type="text" size="2" name="passtd" value="#LOCAL.passtd#"></td>
				<td>INT: </td><td colspan=3><input type="text" size="2" name="passint" value="#LOCAL.passint#"></td>
			</tr>
			<tr>
				<td>Rush Yds: </td><td><input type="text" size="2" name="rushyds" value="#LOCAL.rushyds#"></td>
				<td>TD: </td><td><input type="text" size="2" name="rushtd" value="#LOCAL.rushtd#"></td>
				<td>fumble: </td><td colspan=3><input type="text" size="2" name="fumble" value="#LOCAL.fumble#"></td>
			</tr>
			<tr>
				<td>Rec Yds: </td><td><input type="text" size="2" name="recyds" value="#LOCAL.recyds#"></td>
				<td>TD: </td><td colspan=5><input type="text" size="2" name="rectd" value="#LOCAL.rectd#"></td>		
			</tr>
			<tr>
				<td>sfg: </td><td><input type="text" size="2" name="sfg" value="#LOCAL.sfg#"></td>
				<td>fg: </td><td><input type="text" size="2" name="fg" value="#LOCAL.fg#"></td>
				<td>lfg: </td><td><input type="text" size="2" name="lfg" value="#LOCAL.lfg#"></td>
				<td>xp: </td><td><input type="text" size="2" name="xp" value="#LOCAL.xp#">		</td>
			</tr>
			<tr>
				<td>FF: </td><td><input type="text" size="2" name="ff" value="#LOCAL.ff#"></td>
				<td>DefInt: </td><td><input type="text" size="2" name="defint" value="#LOCAL.defint#"></td>
				<td>Yds: </td><td><input type="text" size="2" name="defintyds" value="#LOCAL.defintyds#">		</td>	
				<td>inttd: </td><td><input type="text" size="2" name="inttd" value="#LOCAL.inttd#"></td>
			</tr>
			<tr>
				<td>tackle: </td><td><input type="text" size="1" name="tackle" value="#LOCAL.tackle#"><input type="text" size="1" name="asstack" value="#LOCAL.asstack#"></td>
				<td>sack: </td><td><input type="text" size="2" name="sack" value="#LOCAL.sack#"></td>
				<td>fr: </td><td><input type="text" size="2" name="fr" value="#LOCAL.fr#"></td>
				<td>frtd: </td><td><input type="text" size="2" name="frtd" value="#LOCAL.frtd#"></td>		
			</tr>
			<tr>
				<td>kryds: </td><td><input type="text" size="2" name="kryds" value="#LOCAL.kryds#"></td>
				<td>krtd: </td><td><input type="text" size="2" name="krtd" value="#LOCAL.krtd#"></td>
				<td>pryds: </td><td><input type="text" size="2" name="pryds" value="#LOCAL.pryds#"></td>
				<td>prtd: </td><td><input type="text" size="2" name="prtd" value="#LOCAL.prtd#"></td>
			</tr>
			<tr>
				<td>pass2pc: </td><td><input type="text" size="2" name="pass2pc" value="#LOCAL.pass2pc#"></td>
				<td>rush2pc: </td><td><input type="text" size="2" name="rush2pc" value="#LOCAL.rush2pc#"></td>
				<td>rec2pc: </td><td colspan=3><input type="text" size="2" name="rec2pc" value="#LOCAL.rec2pc#"></td>
			</tr>
		</table>
	<input type="hidden" name="action" value="1">
	<input type="hidden" name="playerID" value="#playerID#">
	<input type="hidden" name="teamID" value="#LOCAL.teamID#">
	<input type="hidden" name="active" value="#LOCAL.active#">
	<input type="hidden" name="nflteam" value="#LOCAL.nflteam#">
	<input type="hidden" name="updweek" value="#weekNo#">
	<input type="submit" name="submit" value="Update">
	</cfoutput>
	</form>

</cfif>