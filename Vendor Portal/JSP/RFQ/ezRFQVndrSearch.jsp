<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />

<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" />

<%
	//String searchStr=request.getParameter("SearchStr");
	String searchStr=request.getParameter("venSearch");
	
	if(searchStr==null || "null".equals(searchStr))
		searchStr="";
	searchStr=searchStr.trim();
	String syskey = (String)session.getValue("SYSKEY");

%>
<html>
<head>
<Script>
	var tabHeadWidth=90
	var tabHeight="35%"
</Script>
<script>
function submitIt1()
{
	document.myForm.submit();
}
function funOk()
{
	
     var len = document.myForm.chk.length
     var venVal;
     if(!isNaN(len))
     {
	     for (var i=0; i < len; i++)
	     {
		if (document.myForm.chk[i].checked)
		   {
			 venVal = document.myForm.chk[i].value;
		   }
	     }
     } 
     else
     {
     	venVal=document.myForm.chk.value;
     }
     window.close()
     parent.opener.document.myForm.venSearch.value=venVal
     parent.opener.document.myForm.submit()
     

     
     
}

</script>
<Script src="../../Library/JavaScript/Trim.js"></Script>
<%@include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<Script src="../../Library/JavaScript/ezTabScroll.js"></Script>
</head>
<body topmargin=0 rightmargin=0 leftmargin=0  scroll=no >
<form name="myForm" method="post">
<br><br>
<!--
<Div id='inputDiv' style='position:relative;align:center;top:2%;width:100%;height:15%'>
<Table width="70%" border="0" cellspacing="0" cellpadding="0" align=center valign=center>
	<Tr>
		<Td height="5" style="background-color:'F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"></Td>
		<Td height="5" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"><img width="1" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"></Td>
		<Td height="5" style="background-color:'F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"></Td>
	</Tr>
	<Tr >
		<Td width="5" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"><img width="5" height="1" src="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"></Td>
		<Td style="background-color:'F3F3F3'" valign=middle>
			<Table border="0" align="center" valign=middle width="100%" cellpadding=1 cellspacing=1 class=welcomecell>
			<Tr>
				<Th width="40%">Search by vendor name</th>
				<Td width="50%"><input type="text" size="50" class="inputbox" name="SearchStr" value="<%=searchStr%>"></Td>
				<!--<Td style='background:#F3F3F3;width:10%' align=center>
					<Img src="../../../../EzCommon/Images/Body/left_arrow.gif" style="cursor:hand" border="none" onClick="submitIt1()" >
				</Td>-->
				<Td onClick="submitIt1()" style='background:#F3F3F3;width:5%' align=center>
					<Img src="../../../../EzCommon/Images/Body/arrowright.png" style="cursor:hand" border="none" onClick="submitIt1()" >
				</Td>
			</Tr> 
			</Table>
		</Td>
		<Td width="5" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e3.gif"><img width="5" height="1" src="Cb_e3.gif"></Td>
	</Tr>
	<Tr>
		<Td width="5" style="background-color:'F3F3F3'" height="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c3.gif"><img width="5" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c3.gif"></Td>
		<Td height="5" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e4.gif"><img width="1" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_e4.gif"></Td>
		<Td width="5" style="background-color:'F3F3F3'" height="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c4.gif"><img width="5" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c4.gif"></Td>
	</Tr>
</Table>
</Div>	
-->

<%
if(!"".equals(searchStr))
{
	ReturnObjFromRetrieve retObj=null;
	int retObjCnt=0;
	

	ezc.ezparam.EzcParams mainParams=new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams = new EziMiscParams();

	miscParams.setQuery("SELECT DISTINCT(EC_ERP_CUST_NO),ECA_NAME FROM EZC_CUSTOMER A, EZC_CUSTOMER_ADDR B WHERE EC_NO=ECA_NO AND EC_PARTNER_FUNCTION IN ('VN') AND EC_SYS_KEY='"+syskey+"' AND UPPER(ECA_NAME) like'%"+searchStr.toUpperCase()+"%'");
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscParams);
	Session.prepareParams(mainParams);
	retObj = (ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);

	if(retObj!=null)
		retObjCnt=retObj.getRowCount();
if(retObj!=null && retObjCnt>0)	
{
%>
	<Div id="theads" >
	<Table id="tabHead" width="90%" align=center  border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
		<tr>
		<th align="center" width="5%">&nbsp;</th>
		<th align="center" width="25%">Vendor</th>
		<th align="center" width="70%">Name</th>
		</tr>
	</Table>
	</Div>

	<Div id="InnerBox1Div" style="overflow:auto;position:absolute;width:90%;height:60%;left:5%">
	<Table  id="InnerBox1Tab" width="100%" align=center  border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
<%
	for(int i=0;i<retObjCnt;i++)
	{
		String vendorNo=retObj.getFieldValueString(i,"EC_ERP_CUST_NO");
		String vendorName=retObj.getFieldValueString(i,"ECA_NAME");
%>
		<tr>
			<td align="center" width="5%"><input type="radio" name="chk" value="<%=vendorNo%> " ></td>
			<td align="left" width="25%"><%=vendorNo%></td>
        		<td align="left" width="70%"><%=vendorName%></td>
		</tr>
<%
	}
%>	
	</table>
	</div>
	<div id="buttons" style="position:absolute;top:85%;width:100%;visibility:visible" align="center">
<%		
		
   		buttonName = new java.util.ArrayList();
    		buttonMethod = new java.util.ArrayList();
    		
    		buttonName.add("Ok");
    		buttonMethod.add("funOk()");
		
    		
		buttonName.add("Close");
		buttonMethod.add("window.close()");
		out.println(getButtonStr(buttonName,buttonMethod));	

    
%> 		
	</div>
<%		
} 

else
{
%>	
	<br><br><br><br><br>
	<Table width=50% align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0>
		<Tr>
			<Th>No Vendors exist</th>
		</Tr>
	</Table>
	<div id="buttons" style="position:absolute;top:85%;width:100%;visibility:visible" align="center">
<%
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();
	buttonName.add("Close");
	buttonMethod.add("window.close()");
	out.println(getButtonStr(buttonName,buttonMethod));
    
%>
	</div>	
		
<%
}
}
else{
%>
	<br><br><br><br><br>
	<Table width=50% align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0>
		<Tr>
			<Th>Please Enter Vendor Name</th>
		</Tr>
	</Table>
	<div id="buttons" style="position:absolute;top:85%;width:100%;visibility:visible" align="center">
<%
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();
	buttonName.add("Close");
	buttonMethod.add("window.close()");
	out.println(getButtonStr(buttonName,buttonMethod));
    
%>
	</div>	
		
<%
}
%>
</form>
<Div id="MenuSol"></Div>
</body>
</html>	
	
	