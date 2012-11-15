<cfcomponent output="false">
	
	<cffunction name="clearVote" access="remote" returnformat="plain">
		<cfargument name="questionID" required="true"/>

		<cfquery name="qProposal" datasource="#application.dsn#">
			DELETE
			FROM		voting_answer
			WHERE		teamID = #cookie.teamID# AND
						questionID = #arguments.questionID#
		</cfquery>
				
	</cffunction>

	<cffunction name="getAnswers" access="remote" returnformat="plain">
		<cfargument name="questionID" required="true"/>

		<cfset lOptions = "A,B,C,D,E,F,G">

		<cfquery name="qAnswers" datasource="#application.dsn#">
			SELECT 		q.answerID,q.text,if(q.answerID=v.answerID,1,0) "isSelected"
			FROM		question_answer q
							LEFT JOIN (
								select questionID,answerID 
								from voting_answer 
								where teamID=#cookie.teamID#
							) v USING (questionID)
			WHERE		questionID = #arguments.questionID# 
		</cfquery>
		
		<cfset sAnswers = []>
		<cfloop query="qAnswers">
			<cfset sAnswers[ currentrow ] = {}>
			<cfset sAnswers[ currentrow ][ 'answerID' ] = answerID>
			<cfset sAnswers[ currentrow ][ 'answerText' ] = listGetAt(lOptions,currentrow) & ". " & text>
			<cfset sAnswers[ currentrow ][ 'isSelected' ] = isSelected>
		</cfloop>

		<cfreturn sAnswers>
	</cffunction>
	
	<cffunction name="getQuestionDetails" access="remote" returnformat="plain">
		<cfargument name="questionID" required="true">
		
		<cfquery name="qDetails" datasource="#application.dsn#">
			SELECT		count(*) "answers",q.*
			FROM		question q
							JOIN question_answer a using (questionID)
			WHERE		q.questionID = #arguments.questionID#
			GROUP BY 	q.questionID
		</cfquery>

		<cfset lColumns = qDetails.columnlist>
		<cfset sData = {}>
		<cfloop list="#lColumns#" index="col">
			<cfset sData[ col ] = qDetails[col]>
		</cfloop>
		
		<cfreturn application.cfc.json.encode( sData )>	
	</cffunction>
	
	<cffunction name="getQuestionResult" access="remote" returnformat="plain">
		<cfargument name="questionID" required="true"/>

		<cfset lOptions = "A,B,C,D,E,F,G">

		<cfquery name="qChart" datasource="#application.dsn#">		
			SELECT 		q.answerID,q.text,
						q2.text "question",q2.chartType,
						(select count(1) from voting_answer where answerID=q.answerID) "votes"
			FROM		question_answer q 
							join question q2 using (questionID)
			WHERE		q.questionID=#arguments.questionID#
			GROUP BY	q.answerID,q.text
		</cfquery>
		
		<cfset sData = {data=[]}>
		<cfloop query="qChart">
			<cfset sData['data'][ currentrow ] = {}>
			<cfset sData['data'][ currentrow ]['answerID'] = answerID>
			<cfset sData['data'][ currentrow ]['votes'] = votes>
			<cfset sData['data'][ currentrow ]['question'] = question>
			<cfset sData['data'][ currentrow ]['text'] = text>
			<cfset sData['data'][ currentrow ]['chartType'] = chartType>
			<cfset sData['data'][ currentrow ]['option'] = listGetAt(lOptions,currentrow)>
		</cfloop>

		<cfreturn application.cfc.json.encode( sData )>
	</cffunction>

	<cffunction name="getQuestions" access="remote" returnformat="plain">
		<cfargument name="isAward" 			default='0'/>
		<cfargument name="isTree" 			default='1'/>
		<cfargument name="questionID" 		default='0'/>
		
		<cfquery name="qQuestions" datasource="#application.dsn#">
			SELECT 		*
			FROM		question
			WHERE		isAward = #arguments.isAward#
			<cfif arguments.questionID>
				AND questionID = #arguments.questionID#
			</cfif>
		</cfquery>
		
		<cfquery name="qUserAnswers" datasource="#application.dsn#">
			SELECT 		questionID
			FROM		voting_answer
			WHERE		teamID = #cookie.teamID#	
		</cfquery>
		<cfset lUserAnswers = valuelist(qUserAnswers.questionID)>
		
		<cfset sQuestions = {}>
		<cfset sQuestions[ 'success' ] = 'true'>
		<cfset sQuestions[ 'questions' ] = []>
		
		<cfloop query="qQuestions">
			<cfset sQuestions[ 'questions' ][ currentrow ] = {}>
			<cfset sQuestions[ 'questions' ][ currentrow ][ 'leaf' ] = true>
			<cfset sQuestions[ 'questions' ][ currentrow ][ 'id' ] = qQuestions.questionID>
			<cfset sQuestions[ 'questions' ][ currentrow ][ 'text' ] = summary>
			<cfif listFind(lUserAnswers,qQuestions.questionID)>
				<cfset sQuestions[ 'questions' ][ currentrow ][ 'iconCls' ] = 'answered'>
			<cfelse>
				<cfset sQuestions[ 'questions' ][ currentrow ][ 'iconCls' ] = 'unanswered'>
			</cfif>
			<cfset sQuestions[ 'questions' ][ currentrow ][ 'chartType' ] = chartType>
			<cfset sQuestions[ 'questions' ][ currentrow ][ 'question' ] = text>
			<cfif arguments.isTree eq 0>
				<cfset sQuestions[ 'questions' ][ currentrow ][ 'answers' ] = getAnswers(questionID)>
			</cfif>
		</cfloop>
		
		<cfif arguments.isTree>
			<cfset json = application.cfc.json.encode(sQuestions[ 'questions' ])>
		<cfelse>
			<cfset json = application.cfc.json.encode( sQuestions )>
			<cfset json = replace(json,"'true'","true")>
		</cfif>
		
		<cfreturn json>		
	</cffunction>

	<cffunction name="getVoterStatus" access="remote" returnformat="plain">
		<cfargument name="isAward" 		default='0'/>
	
		<cfquery name="qChart" datasource="#application.dsn#">
			SELECT 		count(v.questionID) "ct",t.teamID,t.name
			FROM		teams t 
							left join voting_answer v using (teamID)
			WHERE		(
							v.questionID IN 
							(
								SELECT 	distinct questionID
								FROM	question
								WHERE	isAward = #arguments.isAward#
							) 
							OR 
							v.questionID IS NULL
						)
			GROUP BY 	t.teamID
			ORDER BY	t.name desc
		</cfquery>
		<cfquery name="qQuestionCount" datasource="#application.dsn#">
			SELECT 		distinct questionID
			FROM		question
			WHERE		isAward = #arguments.isAward#
		</cfquery>
		<cfset questionCt = qQuestionCount.recordcount>
	
		<cfset sData = {data=[]}>
		<cfloop query="qChart">
			<cfset sData['data'][ currentrow ] = {}>
			<cfset sData['data'][ currentrow ]['team'] = name>
			<cfset sData['data'][ currentrow ]['votes'] = ct>
			<cfset sData['data'][ currentrow ]['votePercent'] = numberformat((ct/questionCt)*100,'9')>
		</cfloop>

		<cfreturn application.cfc.json.encode( sData )>	
	</cffunction>

	<cffunction name="saveAnswer" access="remote" returnformat="plain">
		<cfargument name="questionID" 		required="true"/>
		<cfargument name="answerID" 		required="true"/>
	
		<cfquery datasource="#application.dsn#">
			INSERT INTO 
				voting_answer
					(
						questionID
						, answerID
						, teamID
						, updateDate
					) 
				values 
					(
						#arguments.questionID#
						, #arguments.answerID#
						, #cookie.teamID#
						, now()
					)
			ON DUPLICATE KEY 
				UPDATE answerID = #arguments.answerID#
		</cfquery>

	</cffunction>

</cfcomponent>