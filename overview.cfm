<cfsilent>
<cfquery name="qAllOStats" datasource="lwfa">
	select 	t.name "team",sum(passyds) as pyd,sum(passint) as pint,sum(passtd) as ptd,sum(rushyds) as ryd,sum(rushtd) as rtd,sum(recyds) as rcyd,sum(rectd) as rctd,sum(fumble) as fum,((sum(passyds)/20)+(sum(passTD)*4)+((sum(passint)+sum(fumble))*(-2))+((sum(rushyds)+sum(recyds))/10)+((sum(rushTD)+sum(recTD))*6)) as tot
	from	playerdata join teams t on playerdata.teamID=t.teamID
	where 	active='y' and playerdata.teamID > 0
	group by t.name
	order by 10 desc
</cfquery>
<cfquery name="qAllDStats" datasource="lwfa">
	select 	t.name "team",sum(tackle) as tackles,sum(asstack) as asstacks,sum(sack) as sacks,sum(defint) as defints,sum(defintyds) as defintydz,sum(ff) as ffs,sum(fr) as frs,sum(inttd) as td1,sum(frtd) as td2,(sum(inttd)+sum(frtd)) as defTD,(sum(tackle)+(sum(asstack)/2)+((sum(sack)+sum(defint)+sum(fr)+sum(ff))*3)+(sum(defintyds)/20)+((sum(inttd)+sum(frtd))*6)) as tot
	from	playerdata join teams t on playerdata.teamID=t.teamID
	where 	active='y' and playerdata.teamID > 0
	group by t.name
	order by 12 desc
</cfquery>
<cfquery name="qAllSTStats" datasource="lwfa">
	select 	t.name "team",
			sum(sfg) as sfgs,
			sum(fg) as fgs,
			sum(lfg) as lfgs,
			sum(xp) as xps,
			sum(kryds) as krydz,
			sum(krtd) as krtds,
			sum(pryds) as prydz,
			sum(prtd) as prtds,
			(sum(krtd)+sum(prtd)) as STTD,
((sum(sfg)*2)+(sum(fg)*3)+(sum(lfg)*4)+sum(xp)+(sum(kryds)/20)+(sum(pryds)/10)+((sum(krTD)+sum(prTD))*6)) as tot
	from	playerdata join teams t on playerdata.teamID=t.teamID
	where 	active='y' and playerdata.teamID > 0
	group by t.name
	order by 11 desc
</cfquery>
</cfsilent>
<style>
	h3 {
		font-family:arial;
	}
 	.overviewTbl {
		font:11px arial;
		width:580px;
		margin-bottom:20px;
	}
	.overviewTbl TD {
		text-align:center;
		border:1px solid black;
		border-width:0 1px 1px 0;
	}
	.overviewTbl TH {
		border:1px solid black;
		border-width:1px 1px 1px 0;
		padding:1px 3px;
		background-color:black;
		color:white;
		margin:0;
	}		
	.overviewTbl .leftCell {
		border-width:0 1px 1px 1px;
		padding:2px 7px;
		font:bold 13px arial;
	}
	#statsArea {
		width:580px;
		margin-left:70px;
	}
	/*
	DIV#statsArea UL {
		margin-left:230px;
	}
	*/
	.ui-tabs-nav a, .ui-tabs-nav a span {
		background:transparent url(../images/tabx.gif) no-repeat scroll 0 0;
	}
</style>

<script language="javascript" type="text/javascript">
	$().ready( function() {
		$('div#statsArea').tabs({ selected: 0 });
	})
</script>

<P><h3 align=center>Team Stats Comparison</h3>
<div id="statsArea">
<ul>
	<li><A href="#offenseTbl" style="background-image:none;">Offense</A></li>
	<li><A href="#defenseTbl" style="background-image:none;">Defense</A></li>
	<li><A href="#specialTeamsTbl" style="background-image:none;">Special Teams</A></li>
</ul>
<center>
<table class="overviewTbl" cellspacing=0 cellpadding=0 border=0 id="offenseTbl">
	<!--- <caption>OFFENSE</caption> --->
	<tr>
		<th style="border-width:1px;width:180px;">Team</th>
		<th>Total Pass</th>
		<th>Pass TD</th>
		<th>Pass INT</th>
		<th>Total Rush</th>
		<th>Rush TD</th>
		<th>Total Rec</th>
		<th>Rec TD</th>
		<th>Fumble</th>
		<th>FP</th>
	</tr>
	<cfoutput query="qAllOStats">
	<tr>
		<td class="leftCell">#team#</td>
		<td>#pyd#</td>
		<td>#ptd#</td>
		<td>#pint#</td>
		<td>#ryd#</td>
		<td>#rtd#</td>
		<td>#rcyd#</td>
		<td>#rctd#</td>
		<td>#fum#</td>		
		<td style="font-weight:bold;padding:2px 5px;width:60px;">#numberformat(tot,'0.00')#</td>		
	</tr>
	</cfoutput>
</table>
<table class="overviewTbl" cellspacing=0 cellpadding=0 border=0 id="defenseTbl">
	<!--- <caption>DEFENSE</caption> --->
	<tr>
		<th style="border-width:1px;width:180px;">Team</th>
		<th>Tackles</th>
		<th>Sacks</th>
		<th>INT</th>
		<th>INT Yds</th>
		<th>FF</th>
		<th>FR</th>
		<th>Def TD</th>
		<th>FP</th>
	</tr>
	<cfoutput query="qAllDStats">
	<tr>
		<td class="leftCell">#team#</td>
		<td>#tackles# / #asstacks#</td>
		<td>#sacks#</td>
		<td>#defints#</td>
		<td>#defintydz#</td>
		<td>#ffs#</td>
		<td>#frs#</td>
		<td>#deftd#</td>
		<td style="font-weight:bold;padding:2px 5px;width:60px;">#numberformat(tot,'0.00')#</td>		
	</tr>
	</cfoutput>
</table>
<P>
<table class="overviewTbl" cellspacing=0 cellpadding=0 border=0 id="specialTeamsTbl">
	<!--- <caption>SPECIAL TEAMS</caption> --->
	<tr>
		<th style="border-width:1px;width:180px;">Team</th>
		<th>SFG</th>
		<th>FG</th>
		<th>LFG</th>
		<th>XP</th>
		<th>KR Yds</th>
		<th>PR Yds</th>
		<th>Return TD</th>
		<th>FP</th>
	</tr>
	<cfoutput query="qAllSTStats">
	<tr>
		<td class="leftCell">#team#</td>
		<td>#sfgs#</td>
		<td>#fgs#</td>
		<td>#lfgs#</td>
		<td>#xps#</td>
		<td>#krydz#</td>
		<td>#prydz#</td>
		<td>#sttd#</td>
		<td style="font-weight:bold;padding:2px 5px;width:60px;">#numberformat(tot,'0.00')#</td>		
	</tr>
	</cfoutput>
</table>
</center>
</div>
