<cfparam name="q" default="youWillNeverFindThisString">
<cfset currentPath = getCurrentTemplatePath()>
<cfset currentDirectory = getDirectoryFromPath(currentPath)>

<cfquery name="data" datasource="lwfa">
    SELECT		concat(p.last,', ',p.first) as name,p.playerID,p.teamID,
				t.name "teamName"
    FROM 		players	p
					left join teams t USING (teamID) 
  	WHERE 		p.current=1
				<cfloop list='#q#' index="searchterm">
				AND ( UCase(first) LIKE Ucase('%#q#%') OR UCase(last) LIKE Ucase('%#q#%') )
				</cfloop>
	ORDER BY 	last,first
</cfquery>

<cfoutput query="data">
#name#|#playerID#|<cfif fileExists("#currentDirectory#images\players\#playerID#.jpg")>#playerID#<cfelse>unknown</cfif>.jpg|#teamID#<cfif teamName neq ''>|#left(rereplace(ucase(teamName),'[^A-Z]','','ALL'),3)#</cfif><br />
</cfoutput>
