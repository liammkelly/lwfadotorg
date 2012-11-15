<cfquery name="qTeams" datasource="lwfa">
	select 		distinct teamID,name
	from			teams
	order by 	name
</cfquery>
<cfquery name="qSked" datasource="lwfa">
	select * from schedule
</cfquery>

<cfset strTeamGrid = structnew()>
<cfloop query="qTeams">
	<cfset currTm = teamID>
	<cfset strTeamGrid[ currTm ] = structnew()>
	<cfloop query="qTeams">
		<cfset strTeamGrid[ currTm ][ qTeams.teamID ] = "">
	</cfloop>
</cfloop>
<cfloop query="qSked">
	<cfif homescore gt awayscore>
		<cfset strTeamGrid[ homeTeamID ][ awayTeamID ]=listAppend(strTeamGrid[ homeTeamID ][ awayTeamID ], "<A href='box.cfm?gameID=#gameID#&width=600&height=400' class='thickbox'>W</A>")>
		<cfset strTeamGrid[ awayTeamID ][ homeTeamID ]=listAppend(strTeamGrid[ awayTeamID ][ homeTeamID ], "<A href='box.cfm?gameID=#gameID#&width=600&height=400' class='thickbox'>L</A>")>
	<cfelseif homescore lt awayscore>
		<cfset strTeamGrid[ homeTeamID ][ awayTeamID ]=listAppend(strTeamGrid[ homeTeamID ][ awayTeamID ], "<A href='box.cfm?gameID=#gameID#&width=600&height=400' class='thickbox'>L</A>")>
		<cfset strTeamGrid[ awayTeamID ][ homeTeamID ]=listAppend(strTeamGrid[ awayTeamID ][ homeTeamID ], "<A href='box.cfm?gameID=#gameID#&width=600&height=400' class='thickbox'>W</A>")>
	</cfif>
</cfloop>


<style>
	A {
		color:black;
	}
	#gridTbl {
		background-color:white;
		border:1px solid black;
		border-width:1px 0 0 1px;
		font:12px verdana;
		float:left;
	}
	#gridTbl TH,#gridTbl TD {
		border:1px solid black;
		border-width:0 1px 1px 0;
	}
	#gridTbl TH {
		color:white;
		background-color:black;
	}
	#gridTbl TD {
		text-align:center;
		font:bold 14px verdana;
	}
	#gridTbl TH, #gridTbl TD.nameCol {
		padding: 3px;
		font:12px verdana;
	}
	#gridTbl TD.sameTeamCol {
		background-color:black;
	}
	DIV#backDiv {
		float:left;
		margin-left:300px;
	}
	DIV#backDiv A {
		color:#006;
	}
</style>
<h3 style="margin:0;float:left;clear:none;">2012 Schedule Grid</h3><div id="backDiv"><a href="javascript:;" onclick="history.back(2);">< < < back</a></div>
<table cellpadding="0" cellspacing="0" border=0 id="gridTbl">
	<tr>
		<th></th>
		<cfoutput query="qTeams">
		<th>#ucase(left(replace(name,"-","","ALL"),3))#</th>
		</cfoutput>
	</tr>
<cfoutput query="qTeams">
	<cfset thisTm = teamID>
	<tr>
		<td class="nameCol"><A href="teampage.cfm?teamID=#teamID#">#name#</A></td>
		<cfloop query="qTeams">
			<cfif thisTm eq qTeams.teamID>
				<td class="sameTeamCol">&nbsp;</td>
			<cfelse>
				<td>#strTeamGrid[ thisTm ][ qTeams.teamID ]#</td>
			</cfif>
		</cfloop>
	</tr>
</cfoutput>
</table>