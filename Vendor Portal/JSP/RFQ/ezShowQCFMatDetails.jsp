<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager"></jsp:useBean>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<%
String QCFNo = request.getParameter("QCFNo");
String display_header = "QCF: <font color='red'>"+QCFNo+"</font> materials";  
%>
<%@ include file="../Misc/ezDisplayHeader.jsp"%>
<%
	ReturnObjFromRetrieve matRetObj=null;
	int matRetObjCnt = 0;
	ezc.ezparam.EzcParams mainParams=new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams = new EziMiscParams();	
	miscParams.setQuery("SELECT distinct(ERD_LINE_NO),ERD_MATERIAL,ERD_MATERIAL_DESC FROM EZC_RFQ_HEADER,EZC_RFQ_DETAILS WHERE ERH_RFQ_NO = ERD_RFQ_NO  AND ERH_COLLETIVE_RFQ_NO IN ('"+QCFNo+"')");
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscParams);
	Session.prepareParams(mainParams);
	try
	{
		matRetObj = (ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);
		if(matRetObj!=null && matRetObj.getRowCount()>0)matRetObjCnt=matRetObj.getRowCount();
		
	}
		
	catch(Exception e){ out.println(e);}	
%>
<html>
<head>
<%@include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<Script>
	var tabHeadWidth=95
	var tabHeight="70%"

</Script>
<Script src="../../Library/JavaScript/ezTabScroll.js"></Script>
<body onLoad="scrollInit()" onResize="scrollInit()" scroll=no>
<form name="myForm">
<%
if(matRetObjCnt>0)
{
%>
	<Div id="theads">
	<Table id="tabHead" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0  width="96%">
		<Tr align="center" valign="middle">

			<th width="20%">Material</th>
			<th width="80%">Material Desc</th>

		</Tr>
	</Table>
	</Div>
	<Div id="InnerBox1Div" style="overflow:auto;position:absolute;width:100%;height:75%;">
	<Table id="InnerBox1Tab" width="100%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
<%
	for(int i=0;i<matRetObjCnt;i++)
	{
		String matNum  = matRetObj.getFieldValueString(i,"ERD_MATERIAL");
		String matDesc = matRetObj.getFieldValueString(i,"ERD_MATERIAL_DESC");
%>
		<tr>
			<td width="20%"><%=Integer.parseInt(matNum)%></td>
			<td width="80%"><%=matDesc%></td>
		</tr>
<%
	}
%>
	</Table>
	</Div>
<%
}
%>
	<div id="ButtonDiv" align=center style="position:absolute;top:90%;visibility:visible;width:100%">
		    
<%		    
		buttonName = new java.util.ArrayList();
		buttonMethod = new java.util.ArrayList();
		buttonName.add("Close");
		buttonMethod.add("window.close()");
		out.println(getButtonStr(buttonName,buttonMethod));
%>	
	</Div>
</form>
<Div id="MenuSol"></Div>
</body>
</html>