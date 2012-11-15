<CFQUERY NAME="LookStands" datasource="lwfa">
	SELECT	s.*,t.name "team"
	FROM	standings s join teams t on s.teamID=t.teamID
	WHERE	s.teamID=#updteam#
</CFQUERY>

<HTML>
<BODY BGCOLOR="white">
<TABLE>
<FORM METHOD="post" ACTION="manual_standings3.cfm">
<TR>
<TD>
<CFOUTPUT QUERY="LookStands">
	
	<TABLE>
	<TR>
	<TD><FONT FACE="arial" SIZE="-1"><B>TEAM:</b></font></td>
	<TD><B><FONT SIZE="+2" COLOR="RED">#Team#</font></td>
	</tr>
	<!--- <TR>
	<TD><FONT FACE="arial" SIZE="-1"><B>Division:</b></font></td>
	<TD><B><FONT SIZE="+1" COLOR="blue">#div#</font></td>
	</tr> --->
	<TR>
	<TD><FONT FACE="arial" SIZE="-1"><B>Wins:</b></font></td>
	<TD><INPUT TYPE="text" NAME="win" VALUE="#win#"></td>
	</tr>
	<TR>
	<TD><FONT FACE="arial" SIZE="-1"><B>Losses:</b></font></td>
	<TD><INPUT TYPE="text" NAME="loss" VALUE="#loss#"></td>
	</tr>
	<TR>
	<TD><FONT FACE="arial" SIZE="-1"><B>Ties:</b></font></td>
	<TD><INPUT TYPE="text" NAME="tie" VALUE="#tie#"></td>
	</tr>
	<TR>
	<TD><FONT FACE="arial" SIZE="-1"><B>Winning %:</b></font></td>
	<TD><INPUT TYPE="text" NAME="winpct" VALUE="#winpct#"></td>
	</tr>
	<TR>
	<TD><FONT FACE="arial" SIZE="-1"><B>GB:</b></font></td>
	<TD><INPUT TYPE="text" NAME="gb" VALUE="#gb#"></td>
	</tr>
	<TR>
	<TD><FONT FACE="arial" SIZE="-1"><B>W vs. Butkus:</b></font></td>
	<TD><INPUT TYPE="text" NAME="winbut" VALUE="#winbut#"></td>
	</tr>
	<TR>
	<TD><FONT FACE="arial" SIZE="-1"><B>L vs. Butkus:</b></font></td>
	<TD><INPUT TYPE="text" NAME="lossbut" VALUE="#lossbut#"></td>
	</tr>
	<TR>
	<TD><FONT FACE="arial" SIZE="-1"><B>T vs. Butkus:</b></font></td>
	<TD><INPUT TYPE="text" NAME="tiebut" VALUE="#tiebut#"></td>
	</tr>
	<TR>
	<TD><FONT FACE="arial" SIZE="-1"><B>W vs. McMahon:</b></font></td>
	<TD><INPUT TYPE="text" NAME="winmcm" VALUE="#winmcm#"></td>
	</tr>
	<TR>
	<TD><FONT FACE="arial" SIZE="-1"><B>L vs. McMahon:</b></font></td>
	<TD><INPUT TYPE="text" NAME="lossmcm" VALUE="#lossmcm#"></td>
	</tr>
	<TR>
	<TD><FONT FACE="arial" SIZE="-1"><B>T vs. McMahon:</b></font></td>
	<TD><INPUT TYPE="text" NAME="tiemcm" VALUE="#tiemcm#"></td>
	</tr>
	<TR>
	<TD><FONT FACE="arial" SIZE="-1"><B>W vs. Madden:</b></font></td>
	<TD><INPUT TYPE="text" NAME="winmad" VALUE="#winmad#"></td>
	</tr>
	<TR>
	<TD><FONT FACE="arial" SIZE="-1"><B>L vs. Madden:</b></font></td>
	<TD><INPUT TYPE="text" NAME="lossmad" VALUE="#lossmad#"></td>
	</tr>
	<TR>
	<TD><FONT FACE="arial" SIZE="-1"><B>T vs. Madden:</b></font></td>
	<TD><INPUT TYPE="text" NAME="tiemad" VALUE="#tiemad#"></td>
	</tr>
	<TR>
	<TD><FONT FACE="arial" SIZE="-1"><B>W vs. Ditka:</b></font></td>
	<TD><INPUT TYPE="text" NAME="windit" VALUE="#windit#"></td>	
	</tr>
	<TR>
	<TD><FONT FACE="arial" SIZE="-1"><B>L vs. Ditka:</b></font></td>
	<TD><INPUT TYPE="text" NAME="lossdit" VALUE="#lossdit#"></td>
	</tr>
	<TR>
	<TD><FONT FACE="arial" SIZE="-1"><B>T vs. Ditka:</b></font></td>
	<TD><INPUT TYPE="text" NAME="tiedit" VALUE="#tiedit#"></td>
	</tr>
	</table>
</td>
<TD>
	<TABLE>
	<TR>
	<TD><FONT FACE="arial" SIZE="-1"><B>Home Wins:</b></font></td>
	<TD><INPUT TYPE="text" NAME="homew" VALUE="#homew#"></td>
	</tr>
	<TR>
	<TD><FONT FACE="arial" SIZE="-1"><B>Home Losses:</b></font></td>
	<TD><INPUT TYPE="text" NAME="homel" VALUE="#homel#"></td>
	</tr>
	<TR>
	<TD><FONT FACE="arial" SIZE="-1"><B>Home Ties:</b></font></td>
	<TD><INPUT TYPE="text" NAME="homet" VALUE="#homet#"></td>
	</tr>
	<TR>
	<TD><FONT FACE="arial" SIZE="-1"><B>Road Wins:</b></font></td>
	<TD><INPUT TYPE="text" NAME="roadw" VALUE="#roadw#"></td>
	</tr>
	<TR>
	<TD><FONT FACE="arial" SIZE="-1"><B>Road Losses:</b></font></td>
	<TD><INPUT TYPE="text" NAME="roadl" VALUE="#roadl#"></td>
	</tr>
	<TR>
	<TD><FONT FACE="arial" SIZE="-1"><B>Road Ties:</b></font></td>
	<TD><INPUT TYPE="text" NAME="roadt" VALUE="#roadt#"></td>
	</tr>
	<TR>
	<TD><FONT FACE="arial" SIZE="-1"><B>Total PF:</b></font></td>
	<TD><INPUT TYPE="text" NAME="pf" VALUE="#pf#"></td>
	</tr>
	<TR>
	<TD><FONT FACE="arial" SIZE="-1"><B>Total PA:</b></font></td>
	<TD><INPUT TYPE="text" NAME="pa" VALUE="#pa#"></td>
	</tr>
	<TR>
	<TD><FONT FACE="arial" SIZE="-1"><B>Streak:</b></font></td>
	<TD><INPUT TYPE="text" NAME="streak" VALUE="#streak#"></td>
	</tr>
	<!--- <TR>
	<TD><FONT FACE="arial" SIZE="-1"><B>Home Field Advantage:</b></font></td>
	<TD><INPUT TYPE="text" NAME="hf" VALUE="#hf#"></td>
	</tr>
	<TR>
	<TD><FONT FACE="arial" SIZE="-1"><B>Current Week:</b></font></td>
	<TD><INPUT TYPE="text" NAME="cw" VALUE="#application.currwk#"></td>
	</tr> --->
	<TR>
	<TD>
	<INPUT TYPE="hidden" NAME="updteam" VALUE="#TeamID#">
	<INPUT TYPE="submit" VALUE="Add">
	</td>
	</tr>
	</table>

</CFOUTPUT>
</td>
</tr>
</form>
</table>
</body>
</html>



