<CFQUERY name="UserAuth" datasource="lwfa">
    SELECT 	u.un,u.pw,u.teamID,u.userID,t.divID,t.name "team",t.nickname,u.admin
    FROM	users u join teams t on u.teamID=t.teamID
    WHERE	u.un='#trim(uname)#' AND u.pw='#trim(pword)#'
</CFQUERY>
<CFIF UserAuth.recordcount gt 0>
    <CFCOOKIE name="lwfaadmin" expires="NEVER" value="#UserAuth.admin#">
    <CFCOOKIE name="lwfauser" expires="NEVER" value="#UserAuth.un#">
    <CFCOOKIE name="lwfapass" expires="NEVER" value="#UserAuth.pw#">
    <CFCOOKIE name="lwfateam" expires="NEVER" value="#UserAuth.team#">
    <CFCOOKIE name="userID" expires="NEVER" value="#UserAuth.userID#">
    <CFCOOKIE name="teamID" expires="NEVER" value="#UserAuth.teamID#">
    <CFCOOKIE name="divID" expires="NEVER" value="#UserAuth.divID#">
	<cfoutput>
		<center>
			<!--- <a href="/2012/teampage.cfm"><img border=0 alt="#cookie.lwfateam#" align="middle" width="48" height="40" src="/2012/images/helmets/#left(ucase(rereplace(cookie.lwfateam,'[^A-Za-z\.]','','ALL')),3)#.gif" style="margin:5px;"></A>&nbsp;&nbsp;&nbsp; ---><!--- <a href="/2012/teampage.cfm" style="font:bold 24px arial;color:silver;text-decoration:none;">#ucase(cookie.lwfateam)#</a><br /><A href="/2012/signoff.cfm" class="smallLink">[ Sign Out ]</A><cfif cookie.lwfauser eq "lkelly" OR cookie.lwfauser eq "cdisilva">&nbsp;&nbsp;&nbsp;<A href="/2012/admin/" class="smallLink">[ ADMIN ]</A></cfif> --->
				<a href="/2012/teampage.cfm" style="font:bold 24px arial;color:##FFF;text-decoration:none;line-height:22px;padding:10px 0;">#ucase(cookie.lwfateam)#</a><br />
				<A href="/2012/signoff.cfm" class="smallLink">[ LOG OUT ]</A>
		</center>
	</cfoutput>
<cfelse>
	<h4>login failed</h4>
	<cfinclude template="login.cfm">
</cfif>