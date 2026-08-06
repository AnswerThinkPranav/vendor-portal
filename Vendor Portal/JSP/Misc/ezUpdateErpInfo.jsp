
<%@ include file="../../../Vendor2/Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Labels/iUpdateErpInfo_Labels.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iUpdateErpInfo.jsp"%>
<html>
<head>       
	<%@include file="../../../Includes/Lib/AddButtonDir.jsp" %>
</head>
<body scroll=no>
<%
	String display_header  = addrUpdateInfo_L;
	String noDataStatement ="";
%>	
	<%@ include file="../Misc/ezDisplayHeader.jsp"%>
	
<%
	if(!isError)
	{
		
		
		 noDataStatement = "Changes have been made succesfully";

	}	
	else
	{
		 noDataStatement = errorMessage;

	}
%>
<%@ include file="../Misc/ezDisplayNoData.jsp"%>
 
<Div id="ButtonDiv" align=center style="position:absolute;top:65%;visibility:visible;width:100%">
<center>
<%
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();

	buttonName.add("Ok");
	buttonMethod.add("navigateBack(\"ezGetInfo.jsp\")");

	 out.println(getButtonStr(buttonName,buttonMethod));
%>
</center>
</Div>
<Div id="MenuSol"></Div>
</body>
</html>