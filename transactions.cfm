<cfquery name='qTrans' datasource="lwfa">
	select 	t.name "team",c.claimID "itemID",
				concat(p.pos," ",p.first," ",p.last) "one",NULL as fromTeam,
				concat(p2.pos," ",p2.first," ",p2.last) "two",
				c.deactivate,
				c.dt,
				"claim" as transType
				
	from		claims c 
					join teams t on c.teamID=t.teamID
					left join players p on p.playerID=c.clmid
					left join players p2 on p2.playerID=c.dmpid
					
	where	c.statusID = 3
				
	UNION

	select te.name "team",t.tradeID "itemID",
	group_concat(DISTINCT concat(p.pos,' ',p.first,' ',p.last)) "one",
	te2.name "fromTeam",group_concat(DISTINCT concat(p2.pos,' ',p2.first,' ',p2.last)) "two",0 as deactivate,t.last_updated_date "dt","trade" as transType

	from v_trade_teams v
		join teams te on v.team1=te.teamID
		join teams te2 on v.team2=te2.teamID
		left join trades t on v.tradeID=t.tradeID AND te.teamID=t.teamID
		left join trades t2 on v.tradeID=t2.tradeID AND te2.teamID=t2.teamID
		join players p on p.playerID=t.playerID
		join players p2 on p2.playerID=t2.playerID

	where	t.statusID = 3
				
	group by v.tradeID

	order by dt desc 
</cfquery>

<style>
	.move {
		height:20px;	
	}
	.move TD IMG {
		display:none;
		cursor:pointer;
		padding-right:10px;
	}
	.move:hover TD IMG {
		display:inline;
	}
</style>

<table id="transTbl" cellpadding="0" cellspacing="0">
	<tr class="headrow">
		<th style="width:100px;">Date</th>
		<th style="width:100px;">Team</th>
		<th>Transaction</th>
		<th width=30>&nbsp;</th>
	</tr>
	<cfoutput query="qTrans">
	<cfif dt eq ""><cfset thisDate = createdate(2012,9,9)><cfelse><cfset thisDate = dt></cfif>
	<tr class="move <cfif currentrow mod 2 eq 0>even<cfelse>odd</cfif>">
		<td>#dateformat(thisDate,'mmmm d')#</td>
		<td>#team#</td>
		<cfif transType eq "claim">
			<td><cfif one neq ''>claimed #one#<cfif  two neq ''>,</cfif> </cfif><cfif two neq ''><cfif deactivate eq 1>deactivated<cfelse>waived</cfif> #two#</cfif></td>
			<td><img src="images/icon_post.png" class="add" onclick="postComment('claim',#qTrans.itemID#,'#qTrans.team#\'s claim of #qTrans.one#')"></td>
		<cfelse>	
			<td>traded #one# to #fromTeam# for #two#</td>
			<td><img src="images/icon_post.png" class="add" style="cursor:pointer;" onclick="postComment('trade',#qTrans.itemID#,'the #team#/#fromteam# trade')"></td>
		</cfif>
	</tr>
	</cfoutput>
</table>