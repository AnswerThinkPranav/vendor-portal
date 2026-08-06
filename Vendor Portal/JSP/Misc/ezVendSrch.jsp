<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" />
<%
	String searchStr=request.getParameter("SearchStr");
	String searchType=request.getParameter("SearchType");
	
	if(searchStr==null || "null".equals(searchStr))
		searchStr =	"";
	
	
	String qryStr="";
	if(searchStr!=null && !"null".equals(searchStr) && !"".equals(searchStr) && "VC".equals(searchType))
	{
		//String tempStr = "0000000000"+searchStr;
		//tempStr=tempStr.substring((tempStr.length())-10,tempStr.length());
		qryStr = "EC_ERP_CUST_NO LIKE '%"+searchStr+"%' AND ";
		
	}
	
	if(searchStr!=null && !"null".equals(searchStr) && !"".equals(searchStr) && "VN".equals(searchType))
	{
		searchStr = searchStr.replaceAll("'","`");
	
		qryStr = "UPPER(ECA_NAME) LIKE'%"+searchStr.toUpperCase()+"%' AND";
	}	
	
	String syskey = (String)session.getValue("SYSKEY");
	
	if(syskey==null || "null".equals(syskey))
		syskey="";
		
		
	String parentSelVendors[] = request.getParameterValues("chk1");
	
	
	java.util.Vector parentSelVendorVect = new java.util.Vector();
	
	if(parentSelVendors!=null)
	{
		for(int v=0;v<parentSelVendors.length;v++)
		{
			parentSelVendorVect.addElement(parentSelVendors[v].split("#")[0]);
		}
	}
	
	//out.println(parentSelVendorVect);
	
%>
<html>
<head>
<Script>
	var tabHeadWidth=90
	var tabHeight="35%"
</Script>
<script>
function funSearchVendor()
{
	var searchStr = document.myForm.SearchStr.value;
	var searchType = '';
	
	if(document.myForm.SearchType[0].checked)
		searchType = document.myForm.SearchType[0].value;
	
	if(searchStr=='')
	{
		alert("Please enter Search String.")
		document.myForm.SearchStr.focus();
		return;
	}
	
	if(searchType=='VN' && searchStr!="" && searchStr.length<4)
	{
		alert("Please enter atleast four characters to search the vendor")
		document.myForm.SearchStr.focus();
		return;
	}
	
	
	document.myForm.submit();
		
}

function funOk()
{	
	var radioButtons=document.myForm.chk;
	
	if(radioButtons.length > 1)
	{
		 for (var x = 0; x < radioButtons.length; x ++) {
		       if (radioButtons[x].checked) {
			temp=radioButtons[x].value;
		       }
      	}
      	}
      	else
      	{
      		temp=radioButtons.value;
      	}
	var sel=window.opener.document.myForm.Vndr;    
	var temp1="";
	for(i=0;i<sel.length;i++)
	{ 
	temp = temp.replace(/^[\s]+/,'').replace(/[\s]+$/,'').replace(/[\s]{2,}/,' ');
		if(sel[i].value.split("#")[0] == temp)
		{
			//sel[i].selected=true;
			temp1=sel[i].value;
			//alert(temp1);
			break;
			
		}
	}
	window.opener.document.myForm.callPreWelcomePage.value="S";
	var vendorDetails 	=	temp1;	
	var vendorData		= 	vendorDetails.split("#")	
	window.opener.document.myForm.VENDOR_CODE.value = vendorData[0]
	window.opener.document.myForm.VENDOR_NAME.value = vendorData[1]
	window.opener.document.myForm.target="banner"
	window.opener.document.myForm.action="ezLoginBanner.jsp";
	window.opener.document.myForm.submit();
	window.close();
}

</script>
<Script src="../../Library/JavaScript/Trim.js"></Script>
<%@include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<Script src="../../Library/JavaScript/ezTabScroll.js"></Script>
</head>
<body topmargin=0 rightmargin=0 leftmargin=0  scroll=no >
<form name="myForm" method="post">
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
			<Table>
				<Tr>
					<Th width="50%" align=center>
						<input type="radio" name="SearchType"  value="VN" checked>Vendor Name  
						<input type="radio" name="SearchType"  value="VC">Vendor Code<Br>
						<input type="text" size="50" class="inputbox" name="SearchStr" value="<%=searchStr%>">
						<img src="../../Images/Others/find.gif" style="cursor:hand" height="18" alt="Find" onClick="javascript:funSearchVendor()">
					</Th>
				<Tr>
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

<%
if(!"".equals(searchStr))
{
	ReturnObjFromRetrieve retObj=null;
	int retObjCnt=0;
	
	if(!"".equals(qryStr))
	{
		ezc.ezparam.EzcParams mainParams=new ezc.ezparam.EzcParams(false);
		EziMiscParams miscParams = new EziMiscParams();

		//miscParams.setQuery("SELECT DISTINCT(EC_ERP_CUST_NO),ECA_NAME FROM EZC_CUSTOMER A, EZC_CUSTOMER_ADDR B WHERE EC_NO=ECA_NO AND EC_PARTNER_FUNCTION IN ('VN') AND EC_SYS_KEY='"+syskey+"' AND UPPER(ECA_NAME) like'%"+searchStr.toUpperCase()+"%'");

		//miscParams.setQuery("SELECT DISTINCT(EC_ERP_CUST_NO),ECA_NAME FROM EZC_CUSTOMER A, EZC_CUSTOMER_ADDR B WHERE EC_NO=ECA_NO AND EC_PARTNER_FUNCTION IN ('VN')"+qryStr+"  AND EC_ERP_CUST_NO  IN(SELECT EUD_VALUE FROM EZC_USER_DEFAULTS WHERE EUD_KEY='SOLDTOPARTY' AND EUD_SYS_KEY='"+syskey+"')");
		
		miscParams.setQuery("SELECT DISTINCT(EC_ERP_CUST_NO),ECA_NAME FROM EZC_CUSTOMER, EZC_CUSTOMER_ADDR,EZC_USER_DEFAULTS WHERE "+qryStr+" EC_SYS_KEY='"+syskey+"' AND EC_PARTNER_FUNCTION IN ('VN') AND EC_NO=ECA_NO AND EC_ERP_CUST_NO = EUD_VALUE AND EUD_KEY='SOLDTOPARTY' AND EC_SYS_KEY = EUD_SYS_KEY");
		
		//out.println(miscParams.getQuery());
		mainParams.setLocalStore("Y");
		mainParams.setObject(miscParams);
		Session.prepareParams(mainParams);
		retObj = (ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);
	}	

	if(retObj!=null)
		retObjCnt=retObj.getRowCount();
if(retObj!=null && retObjCnt>0)	
{
%>
	<br><br><Div id="theads" >
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
		String disableChkBox = "";	
		String vendorNo=retObj.getFieldValueString(i,"EC_ERP_CUST_NO");
		String vendorName=retObj.getFieldValueString(i,"ECA_NAME");
		
		if(parentSelVendorVect.contains(vendorNo))
			disableChkBox = "disabled";
%>
		<tr>
			<td align="center" width="5%"><input type="radio" name="chk" value="<%=vendorNo%>"></td>
			<td align="left" width="25%"><%=vendorNo%></td>
        		<td align="left" width="70%"><%=vendorName%></td>
		</tr>
<%
	}
%>	
	</table>
	</div>
	<div id="buttons" style="position:absolute;top:90%;width:100%;visibility:visible" align="center">
<%		
		
   		buttonName = new java.util.ArrayList();
    		buttonMethod = new java.util.ArrayList();
    		
    		buttonName.add("Ok");
    		buttonMethod.add("funOk()");
		
    		
		//buttonName.add("Close");
		//buttonMethod.add("window.close()");
		out.println(getButtonStr(buttonName,buttonMethod));	

    
%> 		
	</div>
<%		
} 

else
{
%>	
	<br><br><br><br><br>
	<Table width=70% align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0>
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
	<Table width=70% align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0>
		<Tr>
			<Th>Please Enter Vendor Name or Vendor Code</th>
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
	if(parentSelVendors!=null)
	{
		for(int v=0;v<parentSelVendors.length;v++)
		{
%>
			<input type='hidden' name = 'chk1' value = '<%=parentSelVendors[v].split("#")[0]%>'>
<%
		}
	}
%>



</form>
<script>
<%
	if(searchType!=null)
	{
		if("VN".equals(searchType))
		{
%>
			document.myForm.SearchType[0].checked = true;
<%
		}
		if("VC".equals(searchType))
		{
%>
			document.myForm.SearchType[1].checked = true;
<%
		}
	}	
%>
</script>

<Div id="MenuSol"></Div>
</body>
</html>	
	
	