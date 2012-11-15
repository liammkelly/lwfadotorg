<cfquery name="qTradeSpecs" datasource="lwfa">
	update		trades 
	set			statusID=7
	where 		tradeID=#tradeID# 
</cfquery>