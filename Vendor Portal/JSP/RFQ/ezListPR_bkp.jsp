<%@page import="java.util.*"%>
<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/Jsps/Misc/iblockcontrol.jsp" %>

<%
	String divHgt = "70";
%>
<html>
<head>
	<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
	<%@ include file="../../../Includes/Jsps/Rfq/iListPR.jsp" %>
	<Script src="../../Library/JavaScript/Trim.js"></Script>
	<Script>
		var tabHeadWidth = 90;
		var tabHeight="60%";
		if(screen.width==800)
		{
			tabHeight="52%";
		}
		
		function funBack()
		{
			
			document.myForm.action="ezPrePRList.jsp";	
			document.myForm.submit();
		}
		
		function funSearch()
		{
			var PRNumInSearch = funTrim(document.myForm.PRnumber.value);

			var tabObj        = document.getElementById("InnerBox1Tab")
			var rowItems      = tabObj.getElementsByTagName("tr");


			for (i = 0; i < rowItems.length; i++) 
			{
				if(rowItems[i].id == PRNumInSearch)
				{
					var cells	=rowItems[i].getElementsByTagName("td")
					rowItems[i].scrollIntoView(false);
					for(j = 1; j < cells.length; j++)
					{
						rowItems[i].cells[j].style.backgroundColor='green';
						rowItems[i].cells[j].style.color='white';
					}
					break;
				}            
			}
	
		}

		
	</Script>
	<Script src="../../Library/JavaScript/Rfq/ezListPR.js"></Script>
	<Script src="../../Library/JavaScript/ezTabScroll.js"></Script>
</head>
<body onLoad="scrollInit()" onResize="scrollInit()" scroll=no> 
<form name="myForm" method="post">
<input type=hidden name="purchaseHidden">
<input type ="hidden" name="reasons" value ="">
<input type="hidden" name="finalDelDate" value="">
<%
	
	String display_header = "List Of Purchase Requisitions";
	if(Status.equals("R"))
		display_header = "List Of Released Purchase Requisitions";
	else if(Status.equals("U"))
		display_header = "List Of Unreleased Purchase Requisitions";
%>
<%@ include file="../Misc/ezDisplayHeader.jsp"%>
<%
	if(myRetCount==0)
	{
%>
	<br><br><br><br><br>
	<Table width=50% align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
		<Tr>
			<Th>No Purchase Requisitions exist to List</th>
		</Tr>
	</Table>
	
	<Div id="back" align=center style="position:absolute;top:91%;visibility:visible;width:100%">
<%
	
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList(); 

	buttonName.add("Back");
	buttonMethod.add("funBack()");
	out.println(getButtonStr(buttonName,buttonMethod));	
    
%>

</Div>
<%
	}
	else
	{
%>
<br>
<Table width="70%" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0 >
	<Tr>
		<Th width="60%">Search PR By PR Number from below Released PRs List</th>
		<Td width="30%"><input type="text" size="30" class="inputbox" name="PRnumber" value=""></Td>
		<Td style='background:#F3F3F3;width:10%' align=center>
			<Img src="../../../../EzCommon/Images/Body/left_arrow.gif" style="cursor:hand" border="none" onClick="funSearch()" >
		</Td>
	</Tr>
</table>	
<br>
<Div id="theads">
<Table id="tabHead" width="90%" align=center  border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
      <tr>
<%
  	if(Status.equals("R"))
	{
%>
      
        	<th align="center" width="4%">&nbsp;</th>
<%
	}
%>
        <th align="center" width="9%">PR No</th>
        <th align="center" width="12%">Created Date</th>
        <th align="center" width="12%">Released Date</th>
        <th align="center" width="12%">Delivery Date</th>
        <th align="center" width="7%">Line No</th>
        <th align="center" width="8%">Material</th>
        <th align="center" width="17%">Description</th>
        <th align="center" width="5%">Plant</th>
        <th align="center" width="10%">Quantity</th>
        <th align="center" width="4%">UOM</th> 
      </tr>
</Table>
</Div>

<Div id="InnerBox1Div" style="overflow:auto;position:absolute;width:90%;left:2%">
<Table  id="InnerBox1Tab" width="100%" align=center  border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
<%
	//out.println(myRet.toEzcString());
	boolean showStr = false;
	ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate();
	String  reqno="",item="",material="",myMatDesc=""; 
	for(int i=0;i<myRetCount;i++)
	{
		try
		{
			reqno=""+Long.parseLong(myRet.getFieldValueString(i,"REQNO"));
		}
		catch(Exception e)
		{
			reqno=myRet.getFieldValueString(i,"REQNO");
		}
		try
		{
			item=""+Long.parseLong(myRet.getFieldValueString(i,"ITEM"));
		} 
		catch(Exception e)
		{	
			item=myRet.getFieldValueString(i,"ITEM");
		}
		try
		{
			material=""+Long.parseLong(myRet.getFieldValueString(i,"MATERIAL"));
		}
		catch(Exception e)
		{
			material=myRet.getFieldValueString(i,"MATERIAL");
		}
		
		
%>
		<Tr id="<%=reqno%>">
<%
			String styleTemp="",prColor="";
			String serPRColor="";
		  	if(Status.equals("R"))
			{
				String searchKey=myRet.getFieldValueString(i,"REQNO")+"¥"+myRet.getFieldValueString(i,"ITEM");
				//out.println(myRet.toEzcString());
				if(prTreeSet.contains(searchKey))
				{
					showStr = true;
					prColor = "style='background-color:pink'";
				}
			
			
				myMatDesc = myRet.getFieldValueString(i,"DESCRIPTION");
				myMatDesc=myMatDesc.replace('\'','`');
				myMatDesc=myMatDesc.replace('\"','`');
				
				String matCodeAlter=myRet.getFieldValueString(i,"ITEM_CAT");
				
				if(matCodeAlter!=null&&"9".equals(matCodeAlter.trim())){
					matCodeAlter="SERVICE";
					serPRColor="style='background-color: #99CCCC'";
					
				}else{
					matCodeAlter=myRet.getFieldValueString(i,"MATERIAL");
				}
				
				
%>
				<td align="center" <%=serPRColor%> width="3%">&nbsp;<input type="checkbox" name="purchReq" value='<%=matCodeAlter+"$$"+myRet.getFieldValueString(i,"PLANT")+"$$"+fd.getStringFromDate((Date)myRet.getFieldValue(i,"DELIV_DATE"),(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")))+"$$"+myRet.getFieldValueString(i,"QUANTITY")+"$$"+myRet.getFieldValueString(i,"UNIT")+"$$"+myMatDesc+"$$"+myRet.getFieldValueString(i,"REQNO")+"$$"+myRet.getFieldValueString(i,"ITEM")+"$$"+myRet.getFieldValueString(i,"VAL_TYPE")%>'></td>
				
<%
			}
%>

			
   			<input type="hidden" name="hiddpurchReq" value='<%=reqno%>'>	
			<td align="center" <%=serPRColor%> width="9%" <%=prColor%>><%=reqno%>&nbsp;</td>
			
			<td align="center" <%=serPRColor%> width="12%" <%=prColor%>><%=fd.getStringFromDate((Date)myRet.getFieldValue(i,"REQDATE"),(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")))%>&nbsp;</td>
			<td align="center" <%=serPRColor%> width="12%" <%=prColor%>><%=fd.getStringFromDate((Date)myRet.getFieldValue(i,"REL_DATE"),(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")))%>&nbsp;</td>
			<td align="center" <%=serPRColor%> width="12%" <%=prColor%>><%=fd.getStringFromDate((Date)myRet.getFieldValue(i,"DELIV_DATE"),(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")))%>&nbsp;</td>
			<td align="center" <%=serPRColor%> width="7%" <%=prColor%>><%=item%>&nbsp;</td>
			<td align="left"   <%=serPRColor%> width="8%" <%=prColor%>><%=material%>&nbsp;</td>
			<td align="left"   <%=serPRColor%> width="17%" <%=prColor%> ><input type=text size=25 value="<%=myRet.getFieldValueString(i,"DESCRIPTION")%>&nbsp;" title="<%=myRet.getFieldValueString(i,"DESCRIPTION")%>" class="tx" <%=prColor%>  readonly></td>
			<td align="center" <%=serPRColor%> width="5%" <%=prColor%>><%=myRet.getFieldValueString(i,"PLANT")%>&nbsp;</td>
			<td align="right"  <%=serPRColor%> width="10%" <%=prColor%>><%=myRet.getFieldValueString(i,"QUANTITY")%>&nbsp;</td>
        		<td align="center" <%=serPRColor%> width="4%" <%=prColor%>><%=myRet.getFieldValueString(i,"UNIT")%>&nbsp;</td>
		</Tr>
<%
	}
%>
</Table>
</Div>
<Div id="back" align=center style="position:absolute;top:87%;visibility:visible;width:100%">
<%
	if(showStr)
	{
%>
		<Table>
			<Tr>
				<Td class=blankcell>
				<img src="../../../../EzCommon/Images/Common/colorImg.JPG" height="15px" width="20px"></img>
						<b>RFQ is created against PR<b>
				</Td>
			</Tr>
		</Table>
<%
	}
%>

		<span id="EzButtonsSpan" >
			
<%
		  	if(Status.equals("R"))
			{
			
			
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();

	buttonName.add("Back");
	buttonMethod.add("funBack()");
	buttonName.add("Get Sources");
	buttonMethod.add("vendorList()");
	buttonName.add("Close");
	buttonMethod.add("ClosePR()");
	out.println(getButtonStr(buttonName,buttonMethod));		
	
	}
	else
	{

	buttonName.add("Back");
	buttonMethod.add("funBack()");
	out.println(getButtonStr(buttonName,buttonMethod));
	
	}
%>
	</span>
		<span id="EzButtonsMsgSpan" style="display:none">
		<Table align=center>
			<Tr>
				<Td >Your request is being processed... Please wait</Td>
			</Tr>
		</Table>
		</span>
		
</Div>
<% 
}


	
%>
	
<input type=hidden name="backChk" value="PRS">	
<input type="hidden" name="Status" value="<%=Status%>">
<input type="hidden" name="matNo" value="<%=matNo%>">
<input type="hidden" name="matDesc" value="<%=request.getParameter("matDesc")%>">
<input type="hidden" name="selplant" value="<%=plant%>">
<input type="hidden" name="fromDate" value="<%=fromDate%>">
<input type="hidden" name="toDate" value="<%=toDate%>">
<input type="hidden" name="matStr" value="">
<input type="hidden" name="selItemCount" value="">
<input type="hidden" name="selpurchReq" value="">
<Script>
	var selreqno = "<%=request.getParameter("selpurchReq")%>";
	var selreqArr;
	if(selreqno!=null && selreqno!="null" && selreqno!="")
	{
		selreqArr = selreqno.split("#");		
		var selreqlen = document.myForm.hiddpurchReq.length
		if(isNaN(selreqlen))
		{
			if(funTrim(selreqArr[1])==funTrim(document.myForm.hiddpurchReq.value))
				document.myForm.purchReq.checked=true;
		}
		else
		{
			for(i=0;i<selreqlen;i++)
			{
				for(j=0;j<selreqArr.length;j++)
				{
					if(funTrim(selreqArr[j])==funTrim(document.myForm.hiddpurchReq[i].value))
						document.myForm.purchReq[i].checked=true;
				}	
			}
		}
	}
</Script>
</Form> 
<Div id="MenuSol"></Div> 
</body> 
</html>
