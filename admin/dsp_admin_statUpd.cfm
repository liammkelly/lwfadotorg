<cfquery name="toUpdate" datasource="lwfa">
	select nflteam 
	from playerdata 
	where weekno=#application.currwk# and nflteam not in (select nflteam from playerstats where lastupdweek=#application.currwk# group by nflteam)
	group by nflteam
	order by nflteam
</cfquery>
<cfset teams2update=valuelist(toUpdate.nflteam)>
<cfoutput>To be updated: #teams2update#</cfoutput><P>
<img src="/2004/images/nflteams.gif" usemap="#teams" border="0">
<map name="teams">
<cfif dayofweek(now()) eq 3 OR teams2update contains "BUF"><area alt="Bills" shape="rect" href="/2007/scoring/confirm_stats.cfm?selUpdateTm=BUF" coords="45,5,72,30"></cfif>
<cfif dayofweek(now()) eq 3 OR teams2update contains "MIA"><area alt="Dolphins" shape="rect" href="/2007/scoring/confirm_stats.cfm?selUpdateTm=MIA" coords="83,5,102,30"></cfif>
<cfif dayofweek(now()) eq 3 OR teams2update contains "NE"><area alt="Patriots" shape="rect" href="/2007/scoring/confirm_stats.cfm?selUpdateTm=NE" coords="109,5,138,30"></cfif>
<cfif dayofweek(now()) eq 3 OR teams2update contains "NYJ"><area alt="Jets" shape="rect" href="/2007/scoring/confirm_stats.cfm?selUpdateTm=NYJ" coords="150,5,177,30"></cfif>
<cfif dayofweek(now()) eq 3 OR teams2update contains "BAL"><area alt="Ravens" shape="rect" href="/2007/scoring/confirm_stats.cfm?selUpdateTm=BAL" coords="198,5,226,30"></cfif>
<cfif dayofweek(now()) eq 3 OR teams2update contains "CIN"><area alt="Bengals" shape="rect" href="/2007/scoring/confirm_stats.cfm?selUpdateTm=CIN" coords="240,5,264,30"></cfif>
<cfif dayofweek(now()) eq 3 OR teams2update contains "CLE"><area alt="Browns" shape="rect" href="/2007/scoring/confirm_stats.cfm?selUpdateTm=CLE" coords="274,5,298,30"></cfif>
<cfif dayofweek(now()) eq 3 OR teams2update contains "PIT"><area alt="Steelers" shape="rect" href="/2007/scoring/confirm_stats.cfm?selUpdateTm=PIT" coords="309,5,331,30"></cfif>
<cfif dayofweek(now()) eq 3 OR teams2update contains "HOU"><area alt="Texans" shape="rect" href="/2007/scoring/confirm_stats.cfm?selUpdateTm=HOU" coords="355,5,379,30"></cfif>
<cfif dayofweek(now()) eq 3 OR teams2update contains "IND"><area alt="Colts" shape="rect" href="/2007/scoring/confirm_stats.cfm?selUpdateTm=IND" coords="388,5,408,30"></cfif>
<cfif dayofweek(now()) eq 3 OR teams2update contains "JAC"><area alt="Jaguars" shape="rect" href="/2007/scoring/confirm_stats.cfm?selUpdateTm=JAC" coords="419,5,444,30"></cfif>
<cfif dayofweek(now()) eq 3 OR teams2update contains "TEN"><area alt="Titans" shape="rect" href="/2007/scoring/confirm_stats.cfm?selUpdateTm=TEN" coords="453,5,481,30"></cfif>
<cfif dayofweek(now()) eq 3 OR teams2update contains "DEN"><area alt="Broncos" shape="rect" href="/2007/scoring/confirm_stats.cfm?selUpdateTm=DEN" coords="501,5,532,30"></cfif>
<cfif dayofweek(now()) eq 3 OR teams2update contains "KC"><area alt="Chiefs" shape="rect" href="/2007/scoring/confirm_stats.cfm?selUpdateTm=KC" coords="539,5,569,30"></cfif>
<cfif dayofweek(now()) eq 3 OR teams2update contains "OAK"><area alt="Raiders" shape="rect" href="/2007/scoring/confirm_stats.cfm?selUpdateTm=OAK" coords="578,5,601,30"></cfif>
<cfif dayofweek(now()) eq 3 OR teams2update contains "SD"><area alt="Chargers" shape="rect" href="/2007/scoring/confirm_stats.cfm?selUpdateTm=SD" coords="609,5,634,30"></cfif>
<cfif dayofweek(now()) eq 3 OR teams2update contains "DAL"><area alt="Cowboys" shape="rect" href="/2007/scoring/confirm_stats.cfm?selUpdateTm=DAL" coords="46,35,71,60"></cfif>
<cfif dayofweek(now()) eq 3 OR teams2update contains "NYG"><area alt="Giants" shape="rect" href="/2007/scoring/confirm_stats.cfm?selUpdateTm=NYG" coords="81,35,105,60"></cfif>
<cfif dayofweek(now()) eq 3 OR teams2update contains "PHI"><area alt="Eagles" shape="rect" href="/2007/scoring/confirm_stats.cfm?selUpdateTm=PHI" coords="115,35,144,60"></cfif>
<cfif dayofweek(now()) eq 3 OR teams2update contains "WAS"><area alt="Redskins" shape="rect" href="/2007/scoring/confirm_stats.cfm?selUpdateTm=WAS" coords="152,35,177,60"></cfif>
<cfif dayofweek(now()) eq 3 OR teams2update contains "CHI"><area alt="Bears" shape="rect" href="/2007/scoring/confirm_stats.cfm?selUpdateTm=CHI" coords="199,35,226,60"></cfif>
<cfif dayofweek(now()) eq 3 OR teams2update contains "DET"><area alt="Lions" shape="rect" href="/2007/scoring/confirm_stats.cfm?selUpdateTm=DET" coords="237,35,265,60"></cfif>
<cfif dayofweek(now()) eq 3 OR teams2update contains "GB"><area alt="Packers" shape="rect" href="/2007/scoring/confirm_stats.cfm?selUpdateTm=GB" coords="275,35,302,60"></cfif>
<cfif dayofweek(now()) eq 3 OR teams2update contains "MIN"><area alt="Vikings" shape="rect" href="/2007/scoring/confirm_stats.cfm?selUpdateTm=MIN" coords="313,35,334,60"></cfif>
<cfif dayofweek(now()) eq 3 OR teams2update contains "ATL"><area alt="Falcons" shape="rect" href="/2007/scoring/confirm_stats.cfm?selUpdateTm=ATL" coords="355,35,375,60"></cfif>
<cfif dayofweek(now()) eq 3 OR teams2update contains "CAR"><area alt="Panthers" shape="rect" href="/2007/scoring/confirm_stats.cfm?selUpdateTm=CAR" coords="384,35,413,60"></cfif>
<cfif dayofweek(now()) eq 3 OR teams2update contains "NO"><area alt="Saints" shape="rect" href="/2007/scoring/confirm_stats.cfm?selUpdateTm=NO" coords="425,35,445,60"></cfif>
<cfif dayofweek(now()) eq 3 OR teams2update contains "TB"><area alt="Buccaneers" shape="rect" href="/2007/scoring/confirm_stats.cfm?selUpdateTm=TB" coords="456,35,482,60"></cfif>
<cfif dayofweek(now()) eq 3 OR teams2update contains "ARI"><area alt="Cardinals" shape="rect" href="/2007/scoring/confirm_stats.cfm?selUpdateTm=ARI" coords="505,35,532,60"></cfif>
<cfif dayofweek(now()) eq 3 OR teams2update contains "STL"><area alt="Rams" shape="rect" href="/2007/scoring/confirm_stats.cfm?selUpdateTm=STL" coords="538,35,568,60"></cfif>
<cfif dayofweek(now()) eq 3 OR teams2update contains "SF"><area alt="49ers" shape="rect" href="/2007/scoring/confirm_stats.cfm?selUpdateTm=SF" coords="577,35,606,60"></cfif>
<cfif dayofweek(now()) eq 3 OR teams2update contains "SEA"><area alt="Seahawks" shape="rect" href="/2007/scoring/confirm_stats.cfm?selUpdateTm=SEA" coords="613,35,638,60"></cfif>
</MAP>

<CFIF isDefined("selUpdateTm")>
<hr noshade size=1>
<FORM ACTION="<CFOUTPUT>#cgi.script_name#</CFOUTPUT>" METHOD=POST>
<STYLE>
	td {
	font:10px Arial;
	text-align:center;
	}
	input {
	font:10px Arial;	
	}
</STYLE>
<cfquery name="getU" datasource="lwfa">
select playerid from playerdata where nflteam='#selUpdateTm#' and weekno=#application.currwk#
</cfquery>
<cfif getU.recordcount eq 0>
<input type="Checkbox" name="manualStats" value="1" CHECKED> Adding stats manually
<cfquery name="UpdateTeam" datasource="lwfa">
	select 		p.first,p.last,p.nflteam,p.active,p.pos,p.playerid,
					'0' as passyds,'0' as passTD,'0' as passINT,'0' as pass2PC,'0' as rushYds,'0' as rushTD,'0' as rush2PC,'0' as recYds,'0' as recTD,'0' as rec2PC,'0' as fumble,'0' as sack,
					'0' as ff,'0' as defint,'0' as intTD,'0' as frTD,'0' as fr,'0' as kryds,'0' as pryds,'0' as krtd,'0' as prtd,'0' as sFG,'0' as fg,'0' as lfg,'0' as xp,'0' as tackle,'0' as asstack,'0' as defintyds,
					t.name "team"
	from 		players p join teams t on p.teamID=t.teamID 
	where 		p.nflteam='#selUpdateTm#'
	order by 	p.view
</cfquery>
</cfif>
<TABLE border=1>
<TR>
	<TD><B>Player</B></TD>
	<TD><B>Pos</B></TD>
	<TD colspan=16><B>Score Total</B></TD>
</TR>
<CFOUTPUT QUERY="UpdateTeam">
<CFIF pos eq "K">
<TR>
	<TD><cfif active eq 'Y'><b></cfif>#left(first,1)#. #last#<cfif active eq 'Y'></b></cfif>
	<INPUT type="hidden" name="first" value="#first#">
	<INPUT type="hidden" name="last" value="#last#">
	<INPUT type="hidden" name="nflteam" value="#nflteam#">
	<INPUT type="hidden" name="active" value="#active#">
	<INPUT type="hidden" name="team" value="#team#">
	<INPUT type="hidden" name="pos" value="#pos#">
	<INPUT type="hidden" name="PlayerID" value="#PlayerID#">
	<INPUT type="hidden" name="passYds" value="#passyds#">
	<INPUT type="hidden" name="passTD" value="#passtd#"> 	
	<INPUT type="hidden" name="passINT"  value="#passint#"> 
	<INPUT type="hidden" name="pass2PC" value="#pass2pc#">
	<INPUT type="hidden" name="rushYds"  value="#rushyds#"> 
	<INPUT type="hidden" name="rushTD"  value="#rushtd#"> 	
	<INPUT type="hidden" name="rush2PC"  value="#rush2pc#">
	<INPUT type="hidden" name="recYds"  value="#recyds#"> 
	<INPUT type="hidden" name="recTD"  value="#rectd#"> 	
	<INPUT type="hidden" name="rec2PC" value="#rec2pc#">
	<INPUT type="hidden" name="fumbloss"  value="#fumble#">
	<INPUT type="hidden" name="sack"  value="#sack#">
	<INPUT type="hidden" name="forcedfum" value="#ff#">
	<INPUT type="hidden" name="int"  value="#defint#">
	<INPUT type="hidden" name="defintyds"  value="#defintyds#">
	<INPUT type="hidden" name="intTD"  value="#intTD#">
	<INPUT type="hidden" name="frTD"  value="#frTD#">
	<INPUT type="hidden" name="fumbrec"  value="#fr#">
	<INPUT type="hidden" name="krYds" value="#kryds#">
	<INPUT type="hidden" name="krTD"  value="#krtd#">
	<INPUT type="hidden" name="prYds" value="#pryds#">
	<INPUT type="hidden" name="prTD" value="#prtd#"> 
	</TD>
	<TD>#pos#</TD>
	<TD bgcolor="FC93A9"><INPUT type="text" name="shortFG" size="3" value="#sfg#"><BR>SFG</TD>
	<TD bgcolor="FC93A9"><INPUT type="text" name="regFG" size="3" value="#fg#"><BR>FG</TD>
	<TD bgcolor="FC93A9"><INPUT type="text" name="longFG" size="3" value="#lfg#"><BR>LFG</TD>
	<TD bgcolor="FC93A9"><INPUT type="text" name="xp" size="3" value="#xp#"><BR>XP</TD>
	<TD bgcolor="f0f000"><INPUT type="text" name="tack" size="1" value="#tackle#"><BR>SoloTck</TD>
	<TD bgcolor="f0f000"><INPUT type="text" name="asstack" size="1" value="#asstack#"><BR>AssTck</TD>
	<TD colspan=11></TD>
</TR>
<CFELSEIF pos eq "D">
<TR>
	<TD><cfif active eq 'Y'><b></cfif>#left(first,1)#. #last#<cfif active eq 'Y'></b></cfif>
	<INPUT type="hidden" name="first" value="#first#">
	<INPUT type="hidden" name="last" value="#last#">
	<INPUT type="hidden" name="nflteam" value="#nflteam#">
	<INPUT type="hidden" name="active" value="#active#">
	<INPUT type="hidden" name="team" value="#team#">
	<INPUT type="hidden" name="pos" value="#pos#">
	<INPUT type="hidden" name="PlayerID" value="#PlayerID#">
	<INPUT type="hidden" name="passYds" value="#passyds#">
	<INPUT type="hidden" name="passTD" value="#passtd#"> 	
	<INPUT type="hidden" name="passINT"  value="#passint#"> 
	<INPUT type="hidden" name="pass2PC" value="#pass2pc#">
	<INPUT type="hidden" name="rushYds"  value="#rushyds#"> 
	<INPUT type="hidden" name="rushTD"  value="#rushtd#"> 	
	<INPUT type="hidden" name="rush2PC"  value="#rush2pc#">
	<INPUT type="hidden" name="recYds"  value="#recyds#"> 
	<INPUT type="hidden" name="recTD"  value="#rectd#"> 	
	<INPUT type="hidden" name="rec2PC" value="#rec2pc#">
	<INPUT type="hidden" name="fumbloss"  value="#fumble#">
	<INPUT type="hidden" name="shortFG" value="#sfg#">
	<INPUT type="hidden" name="regFG" value="#fg#">
	<INPUT type="hidden" name="longFG" value="#lfg#">
	<INPUT type="hidden" name="xp" value="#xp#">
	</TD>
	<TD>#pos#</TD>
	<TD bgcolor="f0f000"><INPUT type="text" name="tack" size="1" value="#tackle#"><BR>SoloTck</TD>
	<TD bgcolor="f0f000"><INPUT type="text" name="asstack" size="1" value="#asstack#"><BR>AssTck</TD>
	<TD bgcolor="f0f000"><INPUT type="text" name="sack" size="1" value="#sack#"><BR>Sack</TD>
	<TD bgcolor="f0f000"><INPUT type="text" name="int" size="1" value="#defint#"><BR>INT</TD>
	<TD bgcolor="f0f000"><INPUT type="text" name="defintyds" size="1" value="#defintyds#"><BR>INT Yd</TD>
	<TD bgcolor="f0f000"><INPUT type="text" name="intTD" size="1" value="#intTD#"><BR>TD</TD>
	<TD bgcolor="f0f000"><INPUT type="text" name="fumbrec" size="1" value="#fr#"><BR>FR</TD>
	<TD bgcolor="f0f000"><INPUT type="text" name="frTD" size="1" value="#frTD#"><BR>TD</TD>
	<TD bgcolor="f0f000"><INPUT type="text" name="forcedfum" size="1" value="#ff#"><BR>FF</TD>
	<TD bgcolor="FFFFCC"><INPUT type="text" name="krYds" size="2" value="#kryds#"><BR>KR</TD>
	<TD bgcolor="FFFFCC"><INPUT type="text" name="krTD" size="1" value="#krtd#"><BR>TD</TD>
	<TD bgcolor="FFFFCC"><INPUT type="text" name="prYds" size="2" value="#pryds#"><BR>PR</TD>
	<TD bgcolor="FFFFCC"><INPUT type="text" name="prTD" size="1" value="#prtd#"><BR>TD</TD>
	<TD colspan=6></TD>
</TR>
<CFELSE>
<TR>
	<TD><cfif active eq 'Y'><b></cfif>#left(first,1)#. #last#<cfif active eq 'Y'></b></cfif>
	<INPUT type="hidden" name="intTD"  value="#intTD#">
	<INPUT type="hidden" name="frTD"  value="#frTD#">
	<INPUT type="hidden" name="defintyds"  value="#defintyds#">
	<INPUT type="hidden" name="first" value="#first#">
	<INPUT type="hidden" name="last" value="#last#">
	<INPUT type="hidden" name="nflteam" value="#nflteam#">
	<INPUT type="hidden" name="active" value="#active#">
	<INPUT type="hidden" name="team" value="#team#">
	<INPUT type="hidden" name="pos" value="#pos#">
	<INPUT type="hidden" name="PlayerID" value="#PlayerID#">
	<INPUT type="hidden" name="sack"  value="#sack#">
	<INPUT type="hidden" name="forcedfum" value="#ff#">
	<INPUT type="hidden" name="int"  value="#defint#">
	<INPUT type="hidden" name="defintyds"  value="#defintyds#">
	<INPUT type="hidden" name="fumbrec"  value="#fr#">
	<INPUT type="hidden" name="shortFG" value="#sfg#">
	<INPUT type="hidden" name="regFG" value="#fg#">
	<INPUT type="hidden" name="longFG" value="#lfg#">
	<INPUT type="hidden" name="xp" value="#xp#">
	</TD>
	<TD>#pos#</TD>
	<TD bgcolor="FEDCBA"><INPUT type="text" name="passYds" size="3" value="#passYds#"><BR>Pass</TD>
	<TD bgcolor="FEDCBA"><INPUT type="text" name="passTD" size="1" value="#passTD#"><BR>TD</TD>	
	<TD bgcolor="FEDCBA"><INPUT type="text" name="passINT" size="1" value="#passINT#"><BR>INT</TD>
	<TD bgcolor="FEDCBA"><INPUT type="text" name="pass2PC" size="1" value="#pass2PC#"><BR>2PC</TD>	
	<TD bgcolor="pink"><INPUT type="text" name="rushYds" size="3" value="#rushYds#"><BR>Rush</TD>
	<TD bgcolor="pink"><INPUT type="text" name="rushTD" size="1" value="#rushTD#"><BR>TD</TD>	
	<TD bgcolor="pink"><INPUT type="text" name="rush2PC" size="1" value="#rush2PC#"><BR>2PC</TD>
	<TD bgcolor="ABCDEF"><INPUT type="text" name="recYds" size="3" value="#recYds#"><BR>Rec</TD>
	<TD bgcolor="ABCDEF"><INPUT type="text" name="recTD" size="1" value="#recTD#"><BR>TD</TD>	
	<TD bgcolor="ABCDEF"><INPUT type="text" name="rec2PC" size="1" value="#rec2PC#"><BR>2PC</TD>
	<TD bgcolor="FFFFCC"><INPUT type="text" name="krYds" size="2" value="#krYds#"><BR>KR</TD>
	<TD bgcolor="FFFFCC"><INPUT type="text" name="krTD" size="1" value="#krTD#"><BR>TD</TD>
	<TD bgcolor="FFFFCC"><INPUT type="text" name="prYds" size="2" value="#prYds#"><BR>PR</TD>
	<TD bgcolor="FFFFCC"><INPUT type="text" name="prTD" size="1" value="#prTD#"><BR>TD</TD>
	<TD bgcolor="f0f000"><INPUT type="text" name="fumbloss" size="1" value="#fumble#"><BR>FL</TD>
	<TD bgcolor="f0f000"><INPUT type="text" name="tack" size="1" value="#tackle#"><BR>SoloTck</TD>
	<TD bgcolor="f0f000"><INPUT type="text" name="asstack" size="1" value="#asstack#"><BR>AssTck</TD>
</TR>
</CFIF>
</CFOUTPUT>
</TABLE>
<!--- <INPUT TYPE="hidden" NAME="updteam" value="<CFOUTPUT>#updteam#</CFOUTPUT>"> --->
<!--- <INPUT TYPE="hidden" NAME="CurrentNumber" VALUE="<CFOUTPUT>#Evaluate(CurrentNumber+1)#</CFOUTPUT>"> --->
<!--- <INPUT TYPE="hidden" NAME="listno" VALUE="<CFOUTPUT>#Evaluate(CurrentNumber+1)#</CFOUTPUT>"> --->
<cfoutput>
<INPUT type="Hidden" name="fuseaction" value="#nextfuseaction#">
<INPUT TYPE="hidden" NAME="updteam" value="#selUpdateTm#">
</cfoutput>
<INPUT TYPE=submit VALUE="Record stats">
</FORM>
</CFIF>
