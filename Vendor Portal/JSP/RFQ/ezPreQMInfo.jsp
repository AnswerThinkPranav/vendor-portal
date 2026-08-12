<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ page import="javax.xml.parsers.*,org.w3c.dom.*,ezc.ezparam.ReturnObjFromRetrieve" %>
<%@ include file="../../../Includes/JSPs/Misc/iSbuPlantAddress.jsp"%>
<%@ include file="../../../Includes/Lib/Countries.jsp" %>
<%@include file="../../../Includes/Lib/AddButtonDir.jsp"%>
<%@page import="ezc.ezutil.*,java.util.*"%>
<%@ include file="../../../Includes/Jsps/Misc/iShowCal.jsp"%>

<Html>
<Head>
<Title>Display Q-Info Record</Title>
<Script>
	var today ="<%= FormatDate.getStringFromDate(new Date(),"/",FormatDate.MMDDYYYY) %>";
	var tabHeadWidth=70
 	var tabHeight="50%"
</Script>
<Script src="../../Library/JavaScript/Misc/ezTabScroll.js"></Script>
<Script src="../../Library/JavaScript/Rfq/ezPrePRList.js"></Script>
<Script src="../../Library/JavaScript/ezTrim.js"></Script>
<SCRIPT src="../../Library/JavaScript/checkFormFields.js"></SCRIPT>
<Script>
	function OpenVendorSearchWin()
	{
		var vndrName = funTrim(document.myForm.vendor.value);
		if(vndrName=="Search Vendor" || vndrName=="")
		{
			alert("Please Enter Vendor Code or Vendor Name to search for");
			document.myForm.vendor.focus();
			return false;
		}

		var retValue = window.showModalDialog("../Misc/ezVendorSearchPopUp.jsp?CatalogArea=<%=(String)session.getValue("SYSKEY")%>&VENDCODE="+document.myForm.vendor.value,window.self,"center=yes;dialogHeight=28;dialogWidth=30;help=no;titlebar=no;status=no;minimize:yes")	

		if(retValue!=null)
		{
			var args = retValue.split("¥")
			document.myForm.vendor.value = args[0];
			/*
			document.myForm.SoldTo.value = args[0]
			document.myForm.SoldToName.value = args[1]
			changeVendor('Y')
			*/
		}
	}
	function showQMInfo()
	{
		var material = document.myForm.matNo.value
		var plant = document.myForm.plant.options[document.myForm.plant.selectedIndex].value
		var vendor = document.myForm.vendor.value;
		if(material=="" || plant=="" || vendor == "")
		{
			alert("Please provide all the details (Material Code / Plant / Vendor)")
			return;
		}	
		var actMaterial = material;
		//actMaterial = actMaterial.substring(actMaterial.length-18,actMaterial.length);
		var retValue = window.showModalDialog("ezQMInfo.jsp?material="+actMaterial+"&plant="+plant+"&vendor="+vendor,window.self,"center=yes;dialogHeight=35;dialogWidth=45;help=no;titlebar=no;status=no;minimize:yes")		
	}
	
</script>
</Head>
<%
	String Status = request.getParameter("Status");
	String display_header = "Display Q-Info Record";
%>

<body bgcolor="#FFFFF7" onLoad="scrollInit();document.myForm.matNo.focus()" onResize="scrollInit()"  scroll=no>
<Form name="myForm" method="POST">
<Input type="hidden" name="Status" value="<%=Status%>">
<%@ include file="../Misc/ezDisplayHeader.jsp"%>
<Div align="left" style='position:absolute;top:5%;margin-left: auto;margin-right: auto;margin-top: 5em;padding: 15px;border: 1px solid #cccccc;width: 70%;left:15%;background: #F1F3F5;height:50%'> 
<Table width="90%" align="center" border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
	<Tr>
		<Th width="20%" align="left">Material Number</Th>
		<Td width="40%">
			<input type="text"   class="InputBox" style="width:100%"  name="matNo" maxlength="20" size="20">
		</Td>
		<Th width="34%" rowspan=2 align=left>
			<input type="text" class="InputBox"  style="width:100%" name="matDescScrh"  size="15" value="Enter Search String Here." onFocus="setEmpty()" onKeyPress="KeySubmit()"><BR>
			<input type="radio" name="SearchMat"  value="MatNo" checked>Material No.<BR>
			<input type="radio" name="SearchMat"  value="MatDesc">Material Desc.			
			<!--<img src="../../Images/Others/find.gif" style="cursor:hand" height="18" alt="Find" onClick="javascript:searchForMaterial()">-->
		</Th>	
		<Td width="6%" valign=middle align=center rowspan=2>	
			<img src="../../Images/Others/find.gif" style="cursor:hand" height="18" alt="Find" onClick="javascript:searchForMaterial()"><BR>
			
		</Td>
	</Tr>  
	 <tr>
		    <th width="20%" align="left">Material Desc.</th>
		    <td width="40%">
			<input type="text" class="InputBox"  style="width:100%"  name="matDesc" maxlength="20" size="25" value="" readonly>
		    </Td>
		    <!--
		    	<th width="34%" align=left><input type="radio" name="SearchMat"  value="MatNo" checked>Material No.<BR><input type="radio" name="SearchMat"  value="MatDesc">Material Desc.</th>
		    -->	
	   </tr> 	
	<Tr>
		<Th width="20%" align="left">Plant</Th>
		<Td width="80%" colspan=3>
			<select name="plant" id="ListBoxDiv1" style="width:50%">
				<option value="">-- Select Plant --</option>
<%
				for(int i=0;i<count;i++)
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
	         <Th width="20%" align="left">Vendor</Th>
	         <Td width="80%" colspan=3 >
	                <input type="text" size=44 name="vendor" class="InputBox" onKeyPress="KeySubmit()">
	               <!-- <img src="../../Images/Common/left_arrow.gif" style="cursor:hand" onClick="OpenVendorSearchWin()">-->
	                 <img src="../../Images/Common/arrowright.png" style="cursor:hand" onClick="OpenVendorSearchWin()">
	         </Td>
</Table>
</Div>   
<Div id='ButtonDiv' align="center" style="position:absolute;left:0%;width:100%;top:63%">
<Span id="EzButtonsSpan" >

<%

		buttonName = new java.util.ArrayList();
		buttonMethod = new java.util.ArrayList();
		buttonName.add("Display Q-Info");
		buttonMethod.add("showQMInfo()");
		out.println(getButtonStr(buttonName,buttonMethod));
	
%>
                        
</Span>



	<Span id="EzButtonsMsgSpan" style="display:none">
		<Table align=center>
			<Tr>
				<Th>Your request is being processed... Please wait</Th>
			</Tr>
		</Table>
	</Span>


</Div>
</Form>
<Div id="MenuSol"></Div>
</Body>
</Html>