<cfquery name="qOldStat" datasource="lwfa">
	select 		cast(pd.#updStat# AS CHAR) "#updStat#"
	FROM		playerdata pd join players p on p.playerID=pd.playerID
	WHERE		p.first = '#trim(listGetAt(updPlayer,2))#' AND
					p.last = '#trim(listGetAt(updPlayer,1))#' AND
					pd.weekNo = #updWeek#
</cfquery>
<cfoutput>#evaluate('qOldStat.'&updStat)#</cfoutput>