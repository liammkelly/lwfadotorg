<cfquery name="qPendingDeal" datasource="lwfa">
	select 		distinct t.tradeID,t.teamID,t2.teamID "targetTeamID",tm.name "targetTeam",tm2.name "offerTeam"
	from			trades t join trades t2 on t.tradeID=t2.tradeID join teams tm on tm.teamID=t2.teamID join teams tm2 on tm2.teamID=t.teamID
	where		t.offerTeam=1 AND 
					t2.offerTeam=0 AND 
					t.teamID <> t2.teamID AND
					t.statusID = 5
	order by 	t.last_updated_date desc
</cfquery>


	<cfif qPendingDeal.recordcount>
	<cfoutput>
	Pending trade between 
	<b>#qPendingDeal.offerTeam#</b> and <b>#qPendingDeal.targetTeam#</b>
	<A href="/2012/dsp_offer.cfm?tradeID=#qPendingDeal.tradeID#&latestTrade=1&team1=#qPendingDeal.offerTeam#&team2=#qPendingDeal.targetTeam#&width=600&height=300&KeepThis=true&TB_iframe=true&inlineId=myOnPageContent" class="thickbox">detail</A>
	<A href="act_approve_trade.cfm?tradeID=#qPendingDeal.tradeID#">approve</A>
	<A href="act_veto_trade.cfm?tradeID=#qPendingDeal.tradeID#">deny</A>
	</cfoutput>
	</cfif>

	
