<!--- ******************************************************
METHODS																		
		DeleteFromList 					
******************************************************* --->		
<cfcomponent displayname="List" hint="">


<!--- ******************************************************
Function DeleteFromList(List,SubString,Delimiter)           
		This function will delete a value in list based on		
		substring regardless of whether or not it is in the	
		list.   																
		(Does a compare, not a find, so it removes any list 	
			item that CONTAINS the substring passed in)        
******************************************************* --->
<cffunction name="DeleteFromList">
   <cfargument name="MyList" 		type="string" required="true">
   <cfargument name="SubString" 	type="string" required="true">
   <cfargument name="Delimiter" 	type="string" required="false" default=",">
	
   <cfset Var NewList = "">
      <cfloop list="#MyList#" delimiters="#Delimiter#" index="LI">
         <cfif LI DOES NOT Contain SubString>
            <cfset NewList = ListAppend(NewList,LI,Delimiter)>
         </cfif>
      </cfloop>
   <cfreturn NewList>
</cffunction>
<!--- *****  *****--->

<!--- ******************************************************
Function DeleteDuplicates(List,Delimiter)							
		This function will remove 										
		duplicate items from a list.									
******************************************************* --->
<cffunction name="DeleteDuplicates" returntype="String">
	<cfargument name="List" 		type="String" required="True">
	<cfargument name="Delimiter" 	type="String" required="False" default=",">
	<cfset VAR ReturnValue = "">
	<cfloop List="#Arguments.List#" delimiters="#Arguments.Delimiter#" index="LI">
		<cfif NOT ListFind(ReturnValue,LI,Arguments.Delimiter)>
			<cfset ReturnValue = ListAppend(ReturnValue,LI,Arguments.Delimiter)>
		</cfif>
	</cfloop>
	<cfreturn ReturnValue>
</cffunction>

<!--- ******************************************************
Function DeleteDuplicatesNoCase(List,Delimiter)					
		This function will remove 										
		duplicate items from a list.									
******************************************************* --->
<cffunction name="DeleteDuplicatesNoCase" returntype="String">
	<cfargument name="List" 		type="String" required="True">
	<cfargument name="Delimiter" 	type="String" required="False" default=",">
	<cfset VAR ReturnValue = "">
	<cfloop List="#Arguments.List#" delimiters="#Arguments.Delimiter#" index="LI">
		<cfif NOT ListFindNoCase(ReturnValue,LI,Arguments.Delimiter)>
			<cfset ReturnValue = ListAppend(ReturnValue,LI,Arguments.Delimiter)>
		</cfif>
	</cfloop>
	<cfreturn ReturnValue>
</cffunction>


<Cffunction name="ListCompare" returntype="Boolean">
	<cfargument name="SourceList" 	type="string" required="true">
	<cfargument name="TestList" 	type="string" required="true">
	<cfargument name="Match" 		type="string" required="true" default="One" hint="One / All">	
	<cfargument name="Delimiter" 	type="string" required="true" default=",">

	<cfset VAR AllGood = 0>
	<cfset VAR AllBad = 0>
	<cfset VAR AllMix = 0>
	<cfset VAR MatchGood = 0>
	<cfset VAR MatchBad = 0>
	
	<cfloop list="#Arguments.TestList#" index="TLI" delimiters="#Arguments.Delimiter#">
		<cfif ListFind(Arguments.SourceList, TLI, arguments.delimiter)>
			<cfset MatchGood = 1>
		<cfelse>
			<cfset MatchBad = 1>
		</cfif>	
	</cfloop>

	<cfif MatchGood AND MatchBad>
		<cfset AllMix = 1>
	<cfelseif MatchGood AND NOT MatchBad>	
		<cfset AllGood = 1>
	<cfelseif NOT MatchGood AND MatchBad>
		<cfset AllBad = 1>
	<cfelse>
		<cfset AllBad = 1>
	</cfif>
	
	<cfif Arguments.Match eq "One" AND (AllMix OR AllGood)>
		<cfreturn true>
	<cfelseif Arguments.Match eq "All" AND AllGood>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>	
	
	</cffunction>
</cfcomponent>

