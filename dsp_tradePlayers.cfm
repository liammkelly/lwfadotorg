<cfparam name="url.list" default="0">
<cfquery name="qImages" datasource="lwfa">
	select first,last,playerID,nflteam,pos from players where playerID in (#url.list#) 
</cfquery>

<cfoutput>
<cfloop query="qImages">
	<div id="playerDiv">
		<img src="images/players/#playerID#.jpg" height=60 width=50><br />
		#last#, #nflteam# 
	</div>
</cfloop>
</cfoutput>