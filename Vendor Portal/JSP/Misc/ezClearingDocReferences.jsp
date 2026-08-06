<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<%@page import="com.sap.mw.jco.*,ezc.sapconnection.EzSAPHandler"%>
<%

	String clearDoc = request.getParameter("clearingDoc");
	String compCode = request.getParameter("compCode");
	String vendCode = request.getParameter("vendCode");
	
	
	/*out.println("clearDoc"+clearDoc);
	out.println("compCode"+compCode);
	out.println("vendCode"+vendCode);*/
	
	String [] myCols={"REFERENCE","DOCTYPE","AMOUNT","DOCDATE","POSTINGDATE"};
	
	ReturnObjFromRetrieve refDocRet = new ReturnObjFromRetrieve(myCols);
	
	String r3SysSID = "245~999";
	JCO.Function function = null;
	JCO.Client client = null;
	java.util.Vector vectDocList = new java.util.Vector();
	
	
	try
	{

		client = EzSAPHandler.getSAPConnection(r3SysSID);
		function = EzSAPHandler.getFunction("Z_EZ_RFC_READ_TABLE",r3SysSID);

		JCO.ParameterList clearingDocParamIn    = function.getImportParameterList();
		JCO.ParameterList clearingDocParamTable = function.getTableParameterList();

		JCO.Table clearingDocFields  = clearingDocParamTable.getTable("FIELDS");

		clearingDocParamIn.setValue("BSAK","QUERY_TABLE");
		clearingDocParamIn.setValue("#","DELIMITER");

		clearingDocFields.appendRow();
		clearingDocFields.setValue("XBLNR","FIELDNAME");
		clearingDocFields.appendRow();
		clearingDocFields.setValue("DMBTR","FIELDNAME");
		clearingDocFields.appendRow();
		clearingDocFields.setValue("BLART","FIELDNAME");
		clearingDocFields.appendRow();
		clearingDocFields.setValue("BUDAT","FIELDNAME");
		clearingDocFields.appendRow();
		clearingDocFields.setValue("BLDAT","FIELDNAME");


		JCO.Table options  = clearingDocParamTable.getTable("OPTIONS");

		options.appendRow();
		options.setValue("BUKRS = '"+compCode+"' AND LIFNR = '"+vendCode+"' AND AUGBL = '"+clearDoc+"'","TEXT");

		try
		{
			client.execute(function);
		}catch(Exception e){
			ezc.ezcommon.EzLog4j.log("Exception while executing RFC call RFC_READ_TABLE"+e,"I");
		}	

		JCO.Table clearingDocFieldsOut 	= function.getTableParameterList().getTable("DATA");
		int clearingDocFieldsOutCount 	= clearingDocFieldsOut.getNumRows();

		
		if(clearingDocFieldsOutCount>0)
		{
			
			do
			{
				
				String clearingDocKeyValStr = (String)clearingDocFieldsOut.getValue("WA");
								
				String reference	= clearingDocKeyValStr.split("#")[0];
				String amount 		= clearingDocKeyValStr.split("#")[1];
				String docType 		= clearingDocKeyValStr.split("#")[2];
				String docDate 		= clearingDocKeyValStr.split("#")[3];
				String postingDate	= clearingDocKeyValStr.split("#")[4];
				
				if(!("".equals(docType) || docType=="" || "null".equals(docType) || docType==null))
					docType = docType.trim();
				
				if("RE".equals(docType))
				{
					
					refDocRet.setFieldValue("REFERENCE",reference);	
					refDocRet.setFieldValue("DOCTYPE",docType);	
					refDocRet.setFieldValue("AMOUNT",amount);	
					refDocRet.setFieldValue("DOCDATE",docDate);	
					refDocRet.setFieldValue("POSTINGDATE",postingDate);
					refDocRet.addRow();
				}
			}
			while(clearingDocFieldsOut.nextRow());
		}

	}catch(Exception e){ezc.ezcommon.EzLog4j.log("Exception while getting data codes from SAP ::::"+e,"I");}
	finally
	{
		if (client!=null)
		{
			ezc.ezcommon.EzLog4j.log("R E L E A S I N G   C L I E N T .... ","I");
			JCO.releaseClient(client);
			client = null;
			function=null;
		}
	}
	int refDocRetCount = 0;
	if(refDocRet!=null)
		refDocRetCount = refDocRet.getRowCount();
 		
 		
%>
<Html>
<head> 
	<title>References for Clearing Document</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<Script>
var tabHeadWidth=96
var tabHeight="50%"
</Script>
<script src="../../Library/JavaScript/ezTabScroll.js"></Script>
<body bgcolor="#FFFFF7"  onLoad="scrollInit()" onResize="scrollInit()" scroll=no>	
<%	
if(refDocRetCount>0)	
{
%>
<center>
	
	<br><br><br>
	<div id="theads" >
	<Table id="tabHead" width="96%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
	
	<tr align="center">
		<th width=10% >Clearing Doc</th>
		<th width=10%>Reference</th>
		<th width=10%>Amount</th>
	</tr>
	
	</TABLE>
	</DIV>
	
	
	<div id="InnerBox1Div" STYLE='overflow:auto;Position:Absolute;width:96%;Left=2%;height:50%' align="center">
	<table id="InnerBox1Tab" width="100%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
	
<%
		for(int i=0;i<refDocRetCount;i++)
		{
		
			String docDateStr = refDocRet.getFieldValueString(i,"DOCDATE");
			String postDateStr = refDocRet.getFieldValueString(i,"POSTINGDATE");
			
			if(!("".equals(docDateStr) || docDateStr=="" || "null".equals(docDateStr) || docDateStr==null))
				docDateStr = docDateStr.substring(6,8)+"/"+docDateStr.substring(4,6)+"/"+docDateStr.substring(0,4);
			
			if(!("".equals(postDateStr) || postDateStr=="" || "null".equals(postDateStr) || postDateStr==null))
				postDateStr = postDateStr.substring(6,8)+"/"+postDateStr.substring(4,6)+"/"+postDateStr.substring(0,4);
			
%>		<Tr>
			<td width=10% align=center><%=clearDoc%></td>
			<td width=10% align=center><%=refDocRet.getFieldValue(i,"REFERENCE")%></td>
			<td width=10% align=right><%=refDocRet.getFieldValue(i,"AMOUNT")%>&nbsp;</td>
		</Tr>
<%
		}
%>		
	
	</table>
	</div>
</center>
<%
}
else
{
%>
	<center>
	<DIV  style="overflow:auto;position:absolute;top:40%;left:20%;width:60%">
		<table  width="100%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
			<tr>
			<td align=center><B>No References for Clearing Document: <%=clearDoc%></B></td>
			</tr>	
		</table>
	</DIV>
	</center>
<%
}
%>
	<center>
	<Div id="ButtonDiv" style="position:absolute;top:80%;visibility:visible">
	
<%
			
			buttonName = new java.util.ArrayList();
			buttonMethod = new java.util.ArrayList();
			
			buttonName.add("OK");
			buttonMethod.add("window.close()");
			
			out.println(getButtonStr(buttonName,buttonMethod));
%>
	
	</Div>
	</center>


</body>
</Html>