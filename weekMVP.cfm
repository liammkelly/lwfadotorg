<link href="css/mvp.css" type="text/css" rel="stylesheet" />

<cfset sMVP = []>
<cfloop from=1 to="#application.prevwk#" index="wk">
	<cfset sMVP[ wk ] = deserializeJson( application.cfc.data.getWeekMVP(wk) )>
</cfloop>

<div id="starsDiv">
	<h3>2012 Week MVPs</h3><br />
	<div id="mvpArea">
	<cfoutput>
	<cfloop from=1 to="#application.prevwk#" index="wk">
	<div id="week#sMVP[ wk ]['weekNo']#star" class="starWeek <cfif wk mod 2 eq 0>even<cfelse>odd</cfif>">
		<div class="weekNo">#wk#</div>
		<cfif fileExists(expandPath('images/players/#sMVP[ wk ]['playerID']#.jpg'))>
			<img src="images/players/#sMVP[ wk ]['playerID']#.jpg" width=50 height=60>
		<cfelse>
			<img src="images/players/unknown.jpg" width=50 height=60>
		</cfif>
		<div class="mvpDiv">
			<div class="points">#numberformat( sMVP[ wk ]['total'], '00.00')#</div>
			<div class="namearea">
				<div class="first">#sMVP[ wk ]['first']#</div> 
				<div class="last">#sMVP[ wk ]['last']#</div>
				<div class="lwfateam">#sMVP[ wk ]['abbv']#</div>
			</div>
			<div class="scorearea">
				<div class="line">#sMVP[ wk ]['line']#</div>
			</div>
		</div>
	</div>
	</cfloop>
	</cfoutput>
</div>