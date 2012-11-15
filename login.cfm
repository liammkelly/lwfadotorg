<cfif structKeyExists(cookie,'lwfateam')>
	<cfoutput>
		<div id="loginDiv">
			<!--- <a href="/2012/teampage.cfm"><img border=0 alt="#cookie.lwfateam#" align="middle" width="48" height="40" src="/2012/images/helmets/#left(ucase(rereplace(cookie.lwfateam,'[^A-Za-z\.]','','ALL')),3)#.gif" style="margin:5px;"></A>&nbsp;&nbsp;&nbsp; --->
				<a href="/2012/teampage.cfm" style="font:bold 24px arial;color:##FFF;text-decoration:none;line-height:22px;">#ucase(cookie.lwfateam)#</a><br />
				<A href="/2012/signoff.cfm" class="smallLink">[ LOG OUT ]</A>
				<cfif cookie.lwfauser eq "lkelly" OR cookie.lwfauser eq "chiavega">
					&nbsp;&nbsp;&nbsp;<A href="/2012/admin/" class="smallLink">[ ADMIN ]</A>
				<cfelse>	
					&nbsp;&nbsp;&nbsp;<a id="reminderLink" class="thickbox smallLink" href="act_updateInfo.cfm?KeepThis=true&TB_iframe=true&height=330&width=350">[ ADMIN ]</a>
				</cfif>
		</div>
	</cfoutput>
<cfelse>
	<cfoutput>
	   <table cellpadding="0" cellspacing="0" border=0 id="loginTbl"> 
		<tr>
			<td class="fieldName">Username:</td>
			<td><input type="text" name="uname" id="uname" style="background-color:##CCCCCC;width:90px;font-size:11px;"></td>
			<td rowspan=2 valign="middle"><input type="button" value="Go" id="loginButton"></td>
	   	</tr>
		<tr>
			<td class="fieldName">Password:</td>
			<td><input type="password" name="pword" id="pword" style="background-color:##CCCCCC;width:90px;font-size:11px;"></td>
	   	</tr>
		<tr>
			<td colspan=3 align=right>
				<a id="reminderLink" class="thickbox" style="font:bold 11px verdana;color:##2a6024;" href="act_reminder.cfm?KeepThis=true&TB_iframe=true&height=100&width=250">password reminder</a><br />
			</td>
		</tr>
	</table>
	</cfoutput>
</cfif>