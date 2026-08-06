<%//@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/Lib/AddMenuDir.jsp" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager"></jsp:useBean>
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %> 
<%		
	String userRole = (String)session.getValue("USERROLE");
	String purchaseOrg   = ((String)Session.getUserPreference("PURORG"));
	
	if(userRole!=null)
		userRole = userRole.trim();
%>
<html> 
<head>
<base target="display">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" >
<style type="text/css">
	a:active { text-decoration: none}
	a:active {color: #00355d} 
	a:visited {color: #00355d}
	a:hover {color: #00355d}
	a:link {text-decoration: none;color: #00355d}
	table {
		font-family: verdana,arial,sans-serif;
		font-size: 10px;
		font-style: normal;
		font-weight: bold;
		}
	th {
		font-family: verdana,arial,sans-serif;
		font-size: 10px;
		font-style: normal;
		font-weight: bold;
		color: #FFFFFF
		}
	td {
		font-family: verdana,arial,sans-serif;
		font-size: 10px;
		font-style: normal;
		font-weight: bold;
		color: #FFFFFF
		}
</style>
<%@ include file="../../../Includes/JSPs/Misc/iEzVendIntMenuScript.jsp" %>
<script>
	EZ_FontColor          = "#ffffff";
	EZ_FontColorOver      = "#ffffff";
	EZ_BGColor            = "#ED1C24";//1086cf
	EZ_BGColorOver        = "#ED1C24";//1086cf
	EZ_SeparatorColor     =	"<%= session.getValue("menuSeperatorColor")%>"
	EZ_SeparatorColor1    = "<%= session.getValue("menuSeperatorColor1")%>"
	EZ_NoOfMenusToBuild=51

</script>


<script src="../../Library/JavaScript/EZ_VEND_MENU_SCRIPT.js">
</script>
<script>
var EzHideAll=0
	function ezMouseOver1(mDivId,left)
	{
		var welcomeMenu = null
		if(parent.display != null)
			welcomeMenu = parent.display.document.getElementById("MenuSol");
		if(welcomeMenu != null)
		{
			if(EzHideAll!=0)
				clearTimeout(EzHideAll)
			parent.frames.display.scroll(0,0)
			if(EzPrevOver1 != mDivId)
				ezHideAll()
			EzPrevOver1=mDivId;
			ezShowMenu(mDivId,left+"%",0,-1)
		}	
	}
	function ezMouseOver2(mDivId)
	{
		mainDiv=document.getElementById(mDivId);
		ezHideAll();
	}
	function ezMouseOut1(mDivId)
	{
		EzHideAll=setTimeout("ezHideAll()",3500);
	}

	function backToNoError()
	{
		return true
	}
</script>
</head>
<body  topmargin = "0" leftmargin = "0"   style="width:900px" valign=TOP class=menubgcolor>
<form name="msnForm" method="post">
<%@ include file="../../../Includes/JSPs/Misc/iEzVendIntMenu.jsp" %> 
<input type="hidden" name="pageUrl">
</form>
<Div id="MenuSol"></Div>

</body>
</html>
