<cfparam name="dropID" default=0>
<cfparam name="activateID" default=0>

<cfif structKeyExists(url,'dropID[]')>
	<cfset dropID = url[ 'dropID'&urldecode('%5B%5D')]>
</cfif>

<cfset sleep(1000)>
<cfquery name="iDrop" datasource="lwfa">
	insert into claims (clmid,dmpid,teamID,statusID,dt) VALUES (NULL,#dropID#,#cookie.teamID#,3,#now()#)
</cfquery>
<cfquery name="iDrop" datasource="lwfa">
	update players set teamID=0 where playerID=#dropID#
</cfquery>
<cfif isNumeric(activateID)>
	<cfquery name="iDrop" datasource="lwfa">
		update players set inj='N' where playerID=#activateID#
	</cfquery>
</cfif>