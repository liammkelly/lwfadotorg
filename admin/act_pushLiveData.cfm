<!--- UPDATE WEEK --->
<cfquery name="qAdvanceWeek" datasource="lwfa">
	INSERT INTO playerdata
	SELECT 		p.playerID,#application.currwk#,d.total,d.line,p.active,'' as team,p.nflteam,
				d.passyds,d.passtd,d.passint,d.rushyds,d.rushtd,d.recyds,d.rectd,d.fumble,d.sfg,d.fg,d.lfg,d.xp,d.tackle,d.sack,d.defint,d.ff,d.fr,d.frtd,d.inttd,d.kryds,d.krtd,d.pryds,d.prtd,d.pass2pc,d.rush2pc,d.rec2pc,'' as updated,d.asstack,d.defintyds,p.teamID
	FROM		livedata d join players p using (playerID)
	ON DUPLICATE KEY UPDATE team=''
</cfquery> 

<cfquery name="qProposal" datasource="lwfa">
	INSERT INTO stat_import_log (weekNo,playerID) 
	SELECT #application.currwk#,playerID from livedata
	ON DUPLICATE KEY UPDATE weekNo=weekNo
</cfquery>