<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<%@include file="../../../Includes/JSPs/Rfq/iDeleteRFQ.jsp"%>
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager"></jsp:useBean>
	

 <%
 	String poNO=request.getParameter("PurchaseOrder");
 	String sysKey=(String)session.getValue("SYSKEY");
 	String userId=(String)Session.getUserId();
 	boolean execute=false;
 	Date date = new Date();
 	
 	ezc.ezparam.EzcParams mainParams=new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams = new EziMiscParams();
	
 	if(retTab.getRowCount()>0 && isDeleteInSAP)
 	{
		miscParams.setQuery("UPDATE EZC_RFQ_HEADER SET ERH_STATUS='D' WHERE ERH_RFQ_NO='"+poNO+"' AND ERH_SYS_KEY IN ('"+sysKey+"')");
		mainParams.setLocalStore("Y");
		mainParams.setObject(miscParams);
		Session.prepareParams(mainParams);

		try
		{
			ezMiscManager.ezUpdate(mainParams);
			execute=true;
		}
		catch(Exception e)
		{
			ezc.ezcommon.EzLog4j.log("Exception occurred while deleting the RFQ>>>"+e,"D");
			execute=false;
		}
		if(execute)
		{
			miscParams.setQuery("INSERT INTO EZC_WF_AUDIT_TRAIL VALUES ('1','"+poNO+"','DELETED','"+userId+"','','','','RFQ deleted by "+userId+" on "+date+" ',SYSDATE)");
			mainParams.setLocalStore("Y");
			mainParams.setObject(miscParams);
			Session.prepareParams(mainParams);

			try
			{
				ezMiscManager.ezAdd(mainParams);


			}
			catch(Exception e)
			{
				ezc.ezcommon.EzLog4j.log("Exception occurred while deleting the RFQ>>>"+e,"D");

			}	


		}
	}	

%> 
<html>
<head>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<script>
function goBack()
{
	document.myForm.action="../Misc/ezSBUWelcome.jsp";
	document.myForm.submit();
}
</script>
</head>
<body bgcolor="#FFFFF7" onContextMenu="return false;">
<form  name="myForm" method="post">
<Div id='inputDiv' style='position:relative;align:center;top:20%;width:100%;'>
	<Table width="45%" border="0" cellspacing="0" cellpadding="0" align=center valign=center>
	<Tr>
		<Td height="5" style="background-color:'#F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"></Td>
		<Td height="5" style="background-color:'#F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"><img width="1" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"></Td>
		<Td height="5" style="background-color:'#F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"></Td>
	</Tr>
	<Tr>
		<Td width="5" style="background-color:'#F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"><img width="5" height="1" src="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"></Td>
		<Td style="background-color:'#F3F3F3'" valign=middle>
			<Table border="0" align="center" valign=middle width="100%" class=welcomecell>
				<Tr>
					<Td align="center">
					<font size="2px"><b><%=msg%></b></font>
					</Td>
				</Tr>
			</Table>
		</Td>
		<Td width="5" style="background-color:'#F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e3.gif"><img width="5" height="1" src="Cb_e3.gif"></Td>
	</Tr>
	<Tr>
		<Td width="5" style="background-color:'#F3F3F3'" height="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c3.gif"><img width="5" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c3.gif"></Td>
		<Td height="5" style="background-color:'#F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e4.gif"><img width="1" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_e4.gif"></Td>
		<Td width="5" style="background-color:'#F3F3F3'" height="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c4.gif"><img width="5" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c4.gif"></Td>
	</Tr>
	</Table>
</Div>	
<div id="ButtonDiv" style="position:absolute;top:90%;width:100%;visibility:visible">
<center>
<%
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();

		
	buttonName.add("Ok");
	buttonMethod.add("goBack()");
	
	out.println(getButtonStr(buttonName,buttonMethod));

%>
</center>
</div>
</form>
<Div id="MenuSol"></Div>
</body>
</html>