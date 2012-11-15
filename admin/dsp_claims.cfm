<cfquery name="qWaiver" datasource="lwfa">
	select 	t.name "team",
				concat(p.pos," ",p.first," ",p.last) "claimed",
				concat(p2.pos," ",p2.first," ",p2.last) "waived",
				s.name "status",
				c.deactivate,c.dt,c.claimID
	from		claims c 
					join teams t on c.teamID=t.teamID
					join status s on s.statusID=c.statusID
					join players p on p.playerID=c.clmid
					join players p2 on p2.playerID=c.dmpid
		order by 	c.dt desc
</cfquery>

	<script language="javascript" type="text/javascript" src="/scripts/jquery-1.2.6.min.js"></script>
	<script language="javascript" type="text/javascript" src="/scripts/jQueryUI/ui.tablesorter.js"></script>
	<script language="javascript" type="text/javascript" src="/scripts/jQueryUI/ui.tablesorter.pager.js"></script>
	<link rel="stylesheet" type="text/css" href="/scripts/jQueryUI/css/ui.tablesorter_blue.css" />
	<script language="javascript">
		function thickboxDone() {
			 tb_remove();
			//$('div#alertBox').fadeIn('normal').animate({opacity: 1.0}, 1000).fadeOut('fast');
		}
		$().ready( function() {
			$('table#claimsTbl').tablesorter({widthFixed: true, widgets: ['zebra']}).tablesorterPager({container: $("#pager"),size:10});
		})
	</script>
	
	<style>
	#claimsTbl {
		padding:0;
	}
	#claimsTbl A {
		color:black;
	}
	#topControls {
		float:left;
		clear:none;
	}
	#topControls DIV {
		margin-right:40px;
	}
	#pager, #playersType {
		float:left;
		clear:none;
		color:#E7DD93;
	}
	#claimsTbl TH {
		background-color:#F2A644;
		border:0;
	}
	#criteria{width:250px;float:right;margin-right:2px;}
	#currentPos{color:black;cursor:pointer;width:100px;background-color:#E7DD93;border:1px solid black;border-width:1px;text-align:center;font-weight:bold;}
	#posSelect{display:none;position:absolute;width:100px;border:1px solid black;border-width:1px;}
	.sectionTab{cursor:pointer;padding:2px;width:100%;background:#dddddd;color:black;}
	</style>

	<div id="topControls">
		<div id="pager" class="pager">
		<form o>
			<img src="/scripts/jQueryUI/images/first.png" class="first"/>
			<img src="/scripts/jQueryUI/images/prev.png" class="prev"/>
			Page <input type="text" class="pagedisplay" style="width:40px;text-align:center;" />
			<img src="/scripts/jQueryUI/images/next.png" class="next"/>
			<img src="/scripts/jQueryUI/images/last.png" class="last"/>
			<select class="pagesize">
				<option selected="selected"  value="10">10</option>
				<option value="20">20</option>
				<option value="30">30</option>
				<option  value="40">40</option>
			</select>
		</form>
		</div>
		
		<table border=0 cellpadding="0" cellspacing="0" id="claimsTbl" class="tablesorter">
			<thead>
			<tr>
				<th>Claim ID</th>
				<th>Team</th>
				<th>Added</th>
				<th>Dropped</th>
				<th>DL?</th>
				<th>Status</th>
				<th>Date</th>
				<th></th>
			</tr>
			</thead>
			<tbody>
			<cfoutput query="qWaiver">
			<tr>
				<td>#claimID#</td>
				<td>#team#</td>
				<td>#claimed#</td>
				<td>#waived#</td>
				<td>#deactivate#</td>
				<td>#status#</td>
				<td>#dateformat(dt,'m/d/yy')#</td>
				<td><cfif status eq 'approved'><A href="act_reverseClaim.cfm?claimID=#claimID#&KeepThis=true&TB_iframe=true&height=300&width=300" class="thickbox"><img border=0 src="../images/delete3.gif"></A><cfelseif status eq 'denied'><A href="act_runClaim.cfm?claimID=#claimID#&KeepThis=true&TB_iframe=true&height=300&width=300" class="thickbox"><img border=0 src="../images/check.gif"></A><cfelse>---</cfif></td>
			</tr>
			</cfoutput>
			</tbody>
		</table>