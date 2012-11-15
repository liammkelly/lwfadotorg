<CFQUERY NAME="AddStand" datasource="lwfa">

	UPDATE	standings 

	SET	win = '#win#', 

		loss = '#loss#', 

		tie = '#tie#', 

		winpct = '#winpct#', 

		gb = '#gb#', 

		winbut = '#winbut#', 

		lossbut = '#lossbut#', 

		tiebut = '#tiebut#', 

		winmad = '#winmad#', 

		lossmad = '#lossmad#', 

		tiemad = '#tiemad#', 

		winmcm = '#winmcm#', 

		lossmcm = '#lossmcm#', 

		tiemcm = '#tiemcm#', 

		windit = '#windit#', 

		lossdit = '#lossdit#', 

		tiedit = '#tiedit#', 

		homew = '#homew#', 

		homel = '#homel#', 

		homet = '#homet#', 

		roadw = '#roadw#', 

		roadl = '#roadl#', 

		roadt = '#roadt#', 

		pf = '#pf#', 

		pa = '#pa#', 

		streak = '#streak#'

	WHERE teamID = #updteam#

</CFQUERY>



<HTML>

<BODY BGCOLOR="white">

Updated.

<P>

</body>

</html>

