<%//@ include file="../../Library/Globals/errorPagePath.jsp"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/JSPs/Labels/iViewAttachmentFile_Labels.jsp"%>
<%@ page import="java.util.*" %>
<%@ include file="../../../Includes/JSPs/Materials/iGetUploadTempDir.jsp" %>
 <jsp:useBean id="VendTransactionsManager" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="session" />
 <%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
 <%
 	String vendCode = (String)session.getValue("SOLDTO");
 	String uploadNo = request.getParameter("uploadNo");
 	
 	if(vendCode!=null)
 		vendCode = vendCode.trim();
 
 ezc.ezparam.ReturnObjFromRetrieve uploadedDocsList=null;
 try
 {
 	ezc.ezparam.EzcParams addMainParams = new ezc.ezparam.EzcParams(false);
 	ezc.vendortransactions.params.EzVendorParams vendorParams = new ezc.vendortransactions.params.EzVendorParams();
 	ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
 	
 	keyParams.setKey("GET_UPLOADED_DOCS");
 	addMainParams.setLocalStore("Y");
 	
 	
 	vendorParams.setVendor(vendCode.trim());
 	vendorParams.setType("CAPA");
 	vendorParams.setSyskey("999111' AND EUD_UPLOAD_NO='"+uploadNo);
 	
 	
 	addMainParams.setObject(keyParams);	
 	addMainParams.setObject(vendorParams);
 	Session.prepareParams(addMainParams);
 
 	uploadedDocsList=(ReturnObjFromRetrieve)VendTransactionsManager.ezGetVendorTransactions(addMainParams);

 }
 catch(Exception e)
 {
 	//out.println(":::EEEE:::"+e);
 }
 
 
%>	 

<html>
<head>
	<title>Attachments</title>
	<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
	<script>
	function funDone()
	{
		window.close();
	}
	</script>

<script>
function funOpenFile()
{
  window.open("../Misc/ezViewFile.jsp?filename=<%=uploadFilePathDir+uploadedDocsList.getFieldValueString(0,"SERVERFILENAME").replaceAll("\\\\","/")%>","newWin","titlebar=yes")
}

</script>

</head>
<body >
<form name="myForm">

	<table width="90%" align=center border=0>
	<tr><td><%=attFiles_L%></td></tr>
	<tr><td class="blankcell"><hr></td></tr>
	<tr><td class="blankcell"><%=clkViewSav_L%></td></tr>
	</table>

	<br>
	<table width="90%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
	<tr>
		<th  align="left">View Uploaded Document</th>
	</tr>
		<tr>
			<td align="left">
				<a href='javascript:funOpenFile()'><%=uploadedDocsList.getFieldValueString(0,"CLIENTFILENAME")%></a>
			</Td>
		</tr>

	</table><br>

	

<div id="ButtonDiv" align="center" style="postion:absolute;top:90%">
<center>
<%
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();

	buttonName.add("Done");
	buttonMethod.add("funDone()");

	out.println(getButtonStr(buttonName,buttonMethod));
%>
</center>
</div>

</form>
<Div id="MenuSol"></Div>
</body>
</html>
 