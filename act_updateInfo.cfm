<CFIF isDefined('cookie.lwfauser') AND isDefined('cookie.lwfapass')> 
	<CFQUERY name="verifyUser" datasource="lwfa">
		SELECT * FROM users WHERE un='#cookie.lwfauser#' and pw='#cookie.lwfapass#'
	</CFQUERY>
	<CFIF verifyUser.recordcount eq 0>
		<CFLOCATION url="/2010/index.cfm">
	</CFIF>
<CFELSE>
	<CFLOCATION url="/2010/index.cfm">
</CFIF>

<DIV id="utilSect">
<CFIF isDefined('newPassword')>
	<CFIF newPassword neq ''>
		<CFIF newPassword neq newPasswordConf>
			New password and password confirmation don't match.  Try again.<CFABORT>
		</CFIF>
		<CFIF oldPassword neq oldPasswordConf>
			Old password is incorrect.  Try again.<CFABORT>
		</CFIF>
		<CFQUERY name="updUNEM" datasource="lwfa">
			UPDATE 	users 
			SET		pw='#newPassword#'
			WHERE	un='#cookie.lwfauser#'
		</CFQUERY>
		<CFCOOKIE name="lwfapass" expires="NEVER" value="#newPassword#" domain=".LWFA.org">
	</cfif>
	<CFQUERY name="updUNEM" datasource="lwfa">
		UPDATE 	users 
		SET			notify=#form.notify#,email='#newemail#'
		WHERE		un='#cookie.lwfauser#'
	</CFQUERY>
	<script>parent.tb_remove()</script>
<CFELSE>
	<CFQUERY name="getUNEM" datasource="lwfa">
		SELECT	pw,un,email,notify
		FROM	users
		WHERE	un='#cookie.lwfauser#'
	</CFQUERY>
	<STYLE>
		.titleRow {
			background-color:000066;
		}
		.titleRow TD {
			color:white;
			font:bold 14px Verdana;
		}
		.infoRow {
			font:12px Verdana;			
		}
	</STYLE>
	<CFIF getUNEM.recordcount>
		<CFOUTPUT>
		<FORM method="post" name="updateempw" action="#cgi.script_name#">
		<TABLE class="statsDisplay">
			<TR>
				<TD colspan=2 style="font:bold 14px Verdana">Update #cookie.lwfateam# User Info</TD>
			</TR>
			<!--- 
			<TR class="titleRow">
				<TD>Username:</TD><TD>#getUNEM.un#</TD>
			</TR>
			--->
			<TR class="titleRow">
				<TD colspan=2>Change your password</TD>
			</TR>
			<TR class="infoRow">
				<TD>Current password:</TD><TD><INPUT class="utilField" type="password" size="15" value="" name="oldPassword"></TD>
			</TR>
			<TR class="infoRow">
				<TD>New password:</TD><TD><INPUT class="utilField" type="password" size="15" value="" name="newPassword"></TD>
			</TR>
			<TR class="infoRow">
				<TD>Confirm new password:</TD><TD><INPUT class="utilField" type="password" size="15" value="" name="newPasswordConf"></TD>
			</TR>
			<TR class="titleRow">
				<TD colspan=2>Change your email</TD>
			</TR>
 			<TR class="infoRow">
				<TD>Current email:</TD><TD>#getUNEM.email#</TD>
			</TR>
			<TR class="infoRow">
				<TD>New email:</TD><TD><INPUT class="utilField" type="text" size="40" value="#getUNEM.email#" name="newEmail"></TD>
			</TR>
			<TR class="titleRow">
				<TD colspan=2>Update preferences</TD>
			</TR>
			<TR class="infoRow">
				<TD>Notifications:</TD><TD><INPUT name="notify" type="radio" value=1<cfif getUNEM.notify eq 1> CHECKED</cfif>> Yes <INPUT name="notify" type="radio" value=0<cfif getUNEM.notify eq 0> CHECKED</cfif>> No</TD>
			</TR>
		</TABLE>
		<input type="hidden" name="oldPasswordConf" value="#getUNEM.pw#">
		<P align="center"><INPUT type="submit" class="utilButton" value="Make changes"></P>
		</FORM>
		</CFOUTPUT>
	<CFELSE>
		<CFLOCATION url="/2007/index.cfm">
	</CFIF>
</CFIF>
</DIV>

