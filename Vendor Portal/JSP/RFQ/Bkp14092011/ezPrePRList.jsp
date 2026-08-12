<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ page import="javax.xml.parsers.*,org.w3c.dom.*,ezc.ezparam.ReturnObjFromRetrieve" %>
<%@ include file="../../../Includes/JSPs/Misc/iSbuPlantAddress.jsp"%>
<%@ include file="../../../Includes/Lib/Countries.jsp" %>
<%@include file="../../../Includes/Lib/AddButtonDir.jsp"%>
<%@page import="ezc.ezutil.*,java.util.*"%>
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>

<Html>
<Head>
<Title>Selection Criteria for PR List -- Powered By The Hackett Group</Title>
<Script>
	var today ="<%= FormatDate.getStringFromDate(new Date(),"/",FormatDate.MMDDYYYY) %>";
	var tabHeadWidth=80
 	var tabHeight="40%"
</Script>

<Script src="../../Library/JavaScript/Misc/ezTabScroll.js"></Script>
<Script src="../../Library/JavaScript/Rfq/ezPrePRList.js"></Script>
<Script src="../../Library/JavaScript/ezTrim.js"></Script>
<SCRIPT src="../../Library/JavaScript/checkFormFields.js"></SCRIPT>

</Head>
<%
	String Status = request.getParameter("Status");
	String display_header = "";
	
	if("R".equals(Status))
		display_header = "Selection Criteria for Released PRs";
	else
		display_header = "Selection Criteria for Unreleased PRs";
	
%> 

<body bgcolor="#FFFFF7" onLoad="scrollInit();document.myForm.matNo.focus()" onResize="scrollInit()"  scroll=no>
<Form name="myForm" method="POST">
<Input type="hidden" name="Status" value="<%=Status%>">
<%@ include file="../Misc/ezDisplayHeader.jsp"%>
<br><br>
<Table width="65%" align="center" border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
	<Tr>
		<Th width="20%" align="left">Material Number</Th>
		<Td width="40%">
			<input type="text"   class="InputBox" style="width:100%"  name="matNo" maxlength="20" size="20">
		</Td>
		<Td width="34%">
			<input type="text" class="InputBox"  style="width:100%" name="matDescScrh"  size="15" value="Enter Search String Here." onFocus="setEmpty()" onKeyPress="KeySubmit()">
		</Td>	
		<Td width="6%" valign=middle align=center rowspan=2>	
			<img src="../../Images/Others/find.gif" style="cursor:hand" height="18" alt="Find" onClick="javascript:searchForMaterial()">
		</Td>
	</Tr>  
	 <tr>
		    <th width="20%" align="left">Material Desc.</th>
		    <td width="40%">
			<input type="text" class="InputBox"  style="width:100%"  name="matDesc" maxlength="20" size="25" value="" readonly>
		    </Td>
		     <th width="34%"><input type="radio" name="SearchMat"  value="MatNo" checked>Material No.<input type="radio" name="SearchMat"  value="MatDesc">Material Desc.</th>
	   </tr> 	
	<Tr>
		<Th width="20%" align="left">Plant</Th>
		<Td width="80%" colspan=3>
			<select name="selplant" id="ListBoxDiv1" style="width:50%">
				<option value="">-- Select Plant --</option>
<%
				for(int i=0;i<ret.getRowCount();i++)
				{
%>
					<option value="<%=ret.getFieldValueString(i,"CODE")%>"><%=ret.getFieldValueString(i,"CODE")%></option>
<%	   		
				}
%>  	   		
			</select>

		</Td>
	</Tr>  
	<Tr>
		<Th width="20%" align="left">From Date</Th>
		<Td width="80%" colspan=3>
		<input type="text" class=InputBox  style="width:50%;valign:top" id="fromDate" name="fromDate"  value="" size=12 readonly onfocus=this.blur()>
					<%=getDateImage("fromDate")%>
		</Td>			
		
	</Tr>
	<Tr>
		<Th width="20%" align="left">To Date</Th>
		<Td width="80%" colspan=3>
		<input type="text" class=InputBox  style="width:50%;valign:top" name="toDate" id="toDate" value="" size=12 readonly onfocus=this.blur()>
							<%=getDateImage("toDate")%>
		</Td>
		
	</Tr>
<%
	if("R".equals(Status))
	{
%>
		<Tr>
			<Th width="20%" align="left">PR Number</Th>
			<Td width="80%" colspan=3>
				<input type="text"   class="InputBox"  name="purReqNum" maxlength="20" size="20">
			</Td>

		</Tr>
<%
	}
%>
</Table>
<br><br>    
<Div id='ButtonDiv' align="center" style="position:absolute;left:0%;width:100%;top:90%">
<Span id="EzButtonsSpan" >

<%
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();

	buttonName.add("Get PRs");
	buttonMethod.add("getPRs()");

	buttonName.add("Clear");
	buttonMethod.add("reset()");

	out.println(getButtonStr(buttonName,buttonMethod));
%>
</Span>

	<Span id="EzButtonsMsgSpan" style="display:none">
		<Table align=center>
			<Tr>
				<Td >Your request is being processed... Please wait</Td>
			</Tr>
		</Table>
	</Span>


</Div>
<Script>
	var frDate = "<%=request.getParameter("fromDate")%>";
	if(frDate!=null && frDate!="null" && frDate!="")
		document.myForm.fromDate.value=frDate; 
	var tDate = "<%=request.getParameter("toDate")%>";
		if(tDate!=null && tDate!="null" && tDate!="")
		document.myForm.toDate.value=tDate;
	var selplant = "<%=request.getParameter("selplant")%>";
		if(selplant!=null && selplant!="null" && selplant!="")
		document.myForm.selplant.value=selplant; 
	var matDesc = "<%=request.getParameter("matDesc")%>";
		if(matDesc!=null && matDesc!="null" && matDesc!="")
		document.myForm.matDesc.value=matDesc; 
	var matNo = "<%=request.getParameter("matNo")%>";
		if(matNo!=null && matNo!="null" && matNo!="")
		document.myForm.matNo.value=matNo; 	
	

</Script>
</Form>
<Div id="MenuSol"></Div>
</Body>
</Html>