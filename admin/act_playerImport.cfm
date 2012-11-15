<CFPARAM name="searchPos" default="">

<cfif searchPos eq ''>

	<ul>
		<li><A href="act_playerImport.cfm?searchPos=QB">QB</A></li>
		<li><A href="act_playerImport.cfm?searchPos=RB">RB</A></li>
		<li><A href="act_playerImport.cfm?searchPos=WR">WR</A></li>
		<li><A href="act_playerImport.cfm?searchPos=TE">TE</A></li>
		<li><A href="act_playerImport.cfm?searchPos=DE">DE</A></li>
		<li><A href="act_playerImport.cfm?searchPos=DT">DT</A></li>
		<li><A href="act_playerImport.cfm?searchPos=NT">NT</A></li>
		<li><A href="act_playerImport.cfm?searchPos=LB">LB</A></li>
		<li><A href="act_playerImport.cfm?searchPos=S">S</A></li>
		<li><A href="act_playerImport.cfm?searchPos=CB">CB</A></li>
		<li><A href="act_playerImport.cfm?searchPos=K">K</A></li>
	</ul>

<cfelse>

	<CFIF searchPos eq "FB">
		<CFSET variables.pos="RB">
	<CFELSEIF searchPos eq "LB" OR searchPos eq "DT" OR searchPos eq "DE" OR searchPos eq "DB" OR searchPos eq "MLB" OR searchPos eq "NT" OR searchPos eq "S" OR searchPos eq "CB" OR searchPos eq "OLB" OR searchPos eq "ILB" OR searchPos eq "DL">
		<CFSET variables.pos="D">
	<CFELSE>
		<CFSET variables.pos=searchPos>
	</CFIF>

	<cfquery name="qProposal" datasource="#application.dsn#">
		UPDATE players SET current=0 WHERE pos='#variables.pos#'
	</cfquery>

	<cfhttp
	  url="http://sports.yahoo.com/nfl/players?type=position&c=NFL&pos=#searchPos#"
	  resolveurl=1
	  throwOnError="Yes"
	>
	<CFSET foundcount=0>
	<CFSET added=0>
	<CFSET fixed=0>
	<CFSET pageCont=cfhttp.filecontent>	
	<!---<cffile action="READ" file="c:\cfusionmx7\wwwroot\2007\scoring\#searchPos#.txt" variable="pageCont">--->
	<cfset pageCont=rereplacenocase(pageCont,'[[:cntrl:]]','','ALL')>
	<!--- <cfoutput>#pageCont#</cfoutput><cfabort> --->
	<cfoutput>
	count=#len(pageCont)#<br>
	<CFIF pageCont contains "/nfl/players/">
		<cfset startr=find("Players by Position:",pageCont,1)>
		<CFSET nextPlr=find("/nfl/players/",pageCont,startr)+13>		
	 	<CFLOOP condition="nextPlr gt 13">
			<CFSET nextPlrEnd=find("/tr",pageCont,nextPlr)-1>
			<CFSET plrString=mid(pageCont,nextPlr,(nextPlrEnd-nextPlr))>
			<CFSET plrString=replacenocase(plrString,'">',',','ALL')>
			<CFSET plrString=rereplacenocase(plrString,'<(/)?[a-z]{1,2}[^>]>',',','ALL')>
			<CFSET plrString=rereplacenocase(plrString,'<a[^>]>','','ALL')>
			<CFSET plrString=replacenocase(plrString,' ',',','ALL')>
			<CFSET plrString=rereplacenocase(plrString,'<(/)?a(>)?','','ALL')>
			<CFSET plrString=replacenocase(plrString,'http://sports.yahoo.com:80','','ALL')>
			<CFSET plrString=replacenocase(plrString,'href="/nfl/teams/','','ALL')>
			<CFSET plrString=replace(plrString,' #searchPos#',',#searchPos#','ALL')>
			<!--- BEGIN: Handle positional exceptions --->
			<!---  
			<CFIF listlen(plrString) lt 5>
				<CFSET plrString=replace(plrString,' OLB',',OLB','ALL')>
			</CFIF>
			<CFIF listlen(plrString) lt 5>
				<CFSET plrString=replace(plrString,' FB',',FB','ALL')>
			</CFIF>
			<CFIF listlen(plrString) lt 5>
				<CFSET plrString=replace(plrString,' ILB',',ILB','ALL')>
			</CFIF>
			<CFIF listlen(plrString) lt 5>
				<CFSET plrString=replace(plrString,' CB',',CB','ALL')>
			</CFIF>
			<CFIF listlen(plrString) lt 5>
				<CFSET plrString=replace(plrString,' SAF',',SAF','ALL')>
			</CFIF>
			<CFIF listlen(plrString) lt 5>
				<CFSET plrString=replace(plrString,' DL',',DL','ALL')>
			</CFIF>
			<CFIF listlen(plrString) lt 5>
				<CFSET plrString=replace(plrString,' MLB',',MLB','ALL')>
			</CFIF>
			--->
			<!--- END: Handle positional exceptions --->
	 		<CFIF listlen(plrString) lt 5>#plrString#<cfexit method="EXITTEMPLATE"></CFIF>
			<CFSCRIPT>
				cID=trim(listGetAt(plrString,1));
				clname=trim(listGetAt(plrString,3));
				cfname=trim(listGetAt(plrString,2));
				cpos=trim(listGetAt(plrString,4));
				cteam=ucase(left(trim(listGetAt(plrString,5)),3));
			</CFSCRIPT>
			<cfif listfind("QB,RB,WR,TE,K,CB,DE,LB,DT,CB,S,NT",cpos) eq 0>
				<cfset clname=clname&" "&cpos>
				<cfset cpos=trim(listGetAt(plrString,5))>
				<cfset cteam=ucase(left(trim(listGetAt(plrString,6)),3))>
			</cfif>
			<!--- <cfoutput>#plrString#</cfoutput><cfabort> --->
			<CFIF cpos eq "FB"><CFSET cpos="RB"></CFIF>
			<CFIF cpos eq "LB" OR cpos eq "DT" OR cpos eq "DE" OR cpos eq "DB" OR cpos eq "MLB" OR cpos eq "NT" OR cpos eq "S" OR cpos eq "CB" OR cpos eq "OLB" OR cpos eq "ILB" OR cpos eq "DL"><CFSET cpos="D"></CFIF>
			<CFSWITCH expression="#trim(cteam)#">
				<CFCASE value="TAM">
					<CFSET cteam="TB">
				</CFCASE>
				<CFCASE value="ARZ">
					<CFSET cteam="ARI">
				</CFCASE>
				<CFCASE value="KAN">
					<CFSET cteam="KC">
				</CFCASE>
				<CFCASE value="GNB">
					<CFSET cteam="GB">
				</CFCASE>
				<CFCASE value="NOR">
					<CFSET cteam="NO">
				</CFCASE>
				<CFCASE value="NWE">
					<CFSET cteam="NE">
				</CFCASE>
				<CFCASE value="SDG">
					<CFSET cteam="SD">
				</CFCASE>
					<CFCASE value="SFO">
					<CFSET cteam="SF">
				</CFCASE>
				<CFCASE value="NEW">
					<CFIF plrString contains "Saints">
						<CFSET cteam="NO">
					<CFELSEIF plrString contains "Giants">
						<CFSET cteam="NYG">
					<CFELSEIF plrString contains "Patriots">
						<CFSET cteam="NE">
					<CFELSEIF plrString contains "Jets">
						<CFSET cteam="NYJ">					
					</CFIF>
				</CFCASE>
			</CFSWITCH>
			<CFSET pageCont=removechars(pageCont,1,nextPlr)>
			<!--- #cpos# #left(cfname,1)#. #clname#, #cteam# (###cID#)<P> --->
			<CFSET nextPlr=find("/nfl/players/",pageCont)+13>
			<CFSET foundcount=foundcount+1>
			<CFQUERY name="updatePosList" datasource="lwfa">
				select *
				from players
				where last='#trim(clname)#' AND first='#trim(cfname)#' AND pos='#trim(cpos)#' 
			</CFQUERY>
			<CFIF updatePosList.recordcount gt 0>
				<CFIF updatePosList.nflteam neq cteam>
					<CFQUERY name="fixRecord" datasource="lwfa">
						update 	players
						set 	nflteam='#cteam#',current=1
						where 	playerid=#cID#	
					</CFQUERY>
					<CFSET fixed=fixed+1>#fixed# fixed. (#cfname# #clname#)<br>
				<CFELSE>
					<cfquery name="qProposal" datasource="#application.dsn#">
						update 	players
						set 	current=1
						where 	playerID=#cID#			
					</cfquery>
					No update needed.<br>
				</CFIF>
			<CFELSE>
				<cfswitch expression="#cpos#">
					<cfcase value="QB">
						<cfset cview="A">
					</cfcase>
					<cfcase value="RB">
						<cfset cview="B">
					</cfcase>
					<cfcase value="WR">
						<cfset cview="C">
					</cfcase>
					<cfcase value="TE">
						<cfset cview="D">
					</cfcase>
					<cfcase value="K">
						<cfset cview="E">
					</cfcase>
					<cfcase value="D">
						<cfset cview="F">
					</cfcase>
				</cfswitch>
				<CFQUERY name="addRecord" datasource="lwfa">
					insert into 
						players
							(
								playerid
								, last
								, first
								, pos
								, teamID
								, nflteam
								, inj
								, active
								, view
							)
						values
							(
								#cID#
								, '#clname#'
								, '#cfname#'
								, '#cpos#'
								, 0
								, '#cteam#'
								, 'N'
								, 'N'
								, '#cview#'
							)
					on duplicate key update 
							nflteam='#cteam#',pos='#cpos#',inj='N',active='N',view='#cview#'
				</CFQUERY>
				<CFQUERY name="nodupes" datasource="lwfa">
					select *
					from playerstats
					where playerid=#cID#
				</CFQUERY>
				<cfif nodupes.recordcount eq 0>
					<CFQUERY name="addSeasonRecord" datasource="lwfa">
						insert into playerstats(
						playerid
						)
						values(
						#cID#
						)
					</CFQUERY>
				</cfif>
				<CFSET added=added+1>#added# added. (#cfname# #clname# - #cpos#)<br>
			</CFIF>
		</CFLOOP>
	</CFIF>
	</cfoutput>

</cfif>
