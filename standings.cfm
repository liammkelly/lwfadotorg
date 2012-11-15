<cfset standStruct = structnew()>
<cfset standStruct['Madden'] = 'Ditka'>
<cfset standStruct['Ditka'] = 'Madden'>
<cfset standStruct['McMahon'] = 'Butkus'>
<cfset standStruct['Butkus'] = 'McMahon'>

<cfset structDelete(session,'qStandings')>
<cfif NOT structKeyExists(session,'qStandings')>
	<cfset application.cfc.data.loadStandings()>
</cfif>

<cfset qLocalStandings = session.qStandings>

<cfset lastDivision = ''>
<cfoutput>
	<div class="conference">#qLocalStandings.conference# Conference</div>
	<table border=0 cellpadding="0" cellspacing="0" class="standingsTbl" style="width:480px;">
	<cfloop query="qLocalStandings">
		<cfif division neq lastDivision>
		<cfset lastDivision = division>
		<cfif currentrow neq 1>
			</tr>
		</table>
		<cfif qLocalStandings.conference[currentrow] neq qLocalStandings.conference[currentrow-1]>
			<div class="conference">#qLocalStandings.conference[currentrow]# Conference</div>
		</cfif>
		<table border=0 cellpadding="0" cellspacing="0" class="standingsTbl" style="width:480px;margin-top:20px;">
		</cfif>
		<tr class="divisionHeader">
			<td>#division#</td>  
			<td>Record</td>  
			<td>Win%</td>  
			<td>GB</td>  
			<td>Div</td>  
			<td>Conf</td>  
			<td>Home</td>  
			<td>Road</td>  
			<td>PF</td>  
			<td>PA</td>  
			<td>Strk</td>  
			<td>Waiver</td>  
		</tr>		
		</cfif>
		<tr>
			<td class="teamName"><div  style="width:150px;"><a href="teampage.cfm?teamID=#teamID#">#name#</a></div></td>  
			<td style="text-align:center;margin:4px 14px;">#win#-#loss#<cfif tie gt 0>-#tie#</cfif></td>  
			<td>#numberformat(winpct,'.000')#</td>  
			<td>#gb#</td>  
			<td>#qLocalStandings[ 'win'&left(division,3) ][currentrow]#-#qLocalStandings[ 'loss'&left(division,3) ][currentrow]#<cfif qLocalStandings[ 'tie'&left(division,3) ][currentrow] gt 0>-#qLocalStandings[ 'tie'&left(division,3) ][currentrow]#</cfif></td>  
			<td>#qLocalStandings[ 'win'&left(division,3) ][currentrow]+qLocalStandings[ 'win'&left(standStruct[division],3) ][currentrow]#-#qLocalStandings[ 'loss'&left(division,3) ][currentrow]+qLocalStandings[ 'loss'&left(standStruct[division],3) ][currentrow]#<cfif qLocalStandings[ 'tie'&left(division,3) ][currentrow]+qLocalStandings[ 'tie'&left(standStruct[division],3) ][currentrow] gt 0>-#qLocalStandings[ 'tie'&left(division,3) ][currentrow]+qLocalStandings[ 'tie'&left(standStruct[division],3) ][currentrow]#</cfif></td>  
			<td>#homew#-#homel#<cfif homet gt 0>-#homet#</cfif></td>  
			<td>#roadw#-#roadl#<cfif roadt gt 0>-#roadt#</cfif></td>  
			<td><div style="font-size:10px;width:45px;">#pf#</div></td>  
			<td><div style="font-size:10px;width:45px;">#pa#</div></td>  
			<td>#streak#</td>  
			<td style="background-color:silver;font-weight:bold;"><cfif claimsrank gt 0>#claimsrank#<cfelse>-</cfif></td>  
		</tr>		
	</cfloop>
	</table>
</cfoutput>
