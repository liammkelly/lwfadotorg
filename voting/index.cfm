<cfif NOT structKeyExists(cookie,'teamID')>
	<cflocation url="/2012/index.cfm">
</cfif>

<link rel="stylesheet" type="text/css" href="http://extjs.cachefly.net/ext-4.0.2/resources/css/ext-all.css" />
<!--- <link rel="stylesheet" type="text/css" href="/scripts/ext-4.0.2a/resources/css/ext-all.css" /> --->
<style>
	.answered { background-image:url(/2012/images/circle-filled.gif) }
	.unanswered { background-image:url(/2012/images/circle-empty.png) }
	.users { background-image:url(/2012/images/user_edit.png) }
	.unvote { background-image:url(/2012/images/cancel.png) }
</style>
<script type="text/javascript" src="http://extjs.cachefly.net/ext-4.0.2/bootstrap.js"></script>
<!--- <script type="text/javascript" src="/scripts/ext-4.0.2a/bootstrap.js"></script> --->
<script type="text/javascript" src="Application.js"></script>
<script>
	Ext.onReady( function() {
		Ext.Loader.enabled = true;
	})
</script>

<div id="votingArea"></div>