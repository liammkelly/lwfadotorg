<cfparam name="dataBlock" default="">

<!--- <cfset newPlayerData = dataBlock>
<cfset newPlayerData = rereplacenocase(newPlayerData,'[^0-9]+([0-9]{2,5})\.jpg.+','\1','ALL')>
<cfoutput>#newPlayerData#</cfoutput> --->

<cfset playerID = listGetAt(dataBlock,1,".")>


<cfquery name="qPlayer" datasource="lwfa">
	select concat(last,", ",first) as fullname from players where playerID=#playerID#
</cfquery>
<cfoutput>#qPlayer.fullname#</cfoutput>