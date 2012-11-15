<!--- UPDATE WEEK --->
<cfquery name="qAdvanceWeek" datasource="lwfa">
	UPDATE	weeks	
	SET			currwk = currwk + 1
</cfquery>

<cfquery name="kData" datasource="lwfa">
	delete
	from		liveData
</cfquery> 
	
<cfinclude template="../tasks/proc_waiver_order.cfm">