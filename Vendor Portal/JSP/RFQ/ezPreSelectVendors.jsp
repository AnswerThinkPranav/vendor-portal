<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ page import="javax.xml.parsers.*,org.w3c.dom.*,ezc.ezparam.ReturnObjFromRetrieve" %>
<%@page import="java.util.*"%>
<%@ include file="../../../Includes/JSPs/Misc/iSbuPlantAddress.jsp"%>
<%@ include file="../../../Includes/Lib/Countries.jsp" %>
<%
	String purchReq	= request.getParameter("purchReq");
	String matNo="",plant="NA",reqDate="",qty = "",uom="",matDesc="";
	java.util.StringTokenizer token = null;
	if(purchReq!=null && !"null".equals(purchReq))
	{
		token = new java.util.StringTokenizer(purchReq,"$$");
		try
		{
			matNo	= token.nextToken();
			plant	= token.nextToken();
			reqDate	= token.nextToken(); 
			qty 	= token.nextToken();
			uom 	= token.nextToken(); 
			matDesc = token.nextToken();
		}
		catch(Exception e)
		{
			System.out.println("Exception Occured in ezPreSelectVendor.jsp:"+e);
		}
	}	
	//out.println("reqDate"+reqDate+" purchReq"+purchReq);
%>

<html>
<head>
<title>Enter Material For Select Vendors -- Powered By EzCommerce India</title>
<head>
<%@include file="../../../Includes/Lib/AddButtonDir.jsp"%>
<%@page import="ezc.ezutil.*,java.util.*"%>
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<Script src="../../Library/JavaScript/ezTrim.js"></Script>
<SCRIPT src="../../Library/JavaScript/checkFormFields.js"></SCRIPT>
<script>
	var today ="<%= FormatDate.getStringFromDate(new Date(),"/",FormatDate.MMDDYYYY) %>";
	var tabHeadWidth=80
 	var tabHeight="40%"
</script>
<Script src="../../Library/JavaScript/Misc/ezTabScroll.js"></Script>
<script src="../../Library/JavaScript/Rfq/ezPreSelectVendors.js"></Script>
<script>
function funBackVals()
{
	  document.myForm.matNo.value 		=     '<%=matNo%>' ;	  	
<%
	  String  selMsg = "--Select Plant--";
%>
	  if('<%=plant%>'!=null)
		  document.myForm.plant.value	=     '<%=plant%>';	
	  else
	          document.myForm.plant.value	=     '<%=selMsg%>';	
	  
	  
	  document.myForm.deliveryDate.value	=     '<%=reqDate%>' ; 	
	  document.myForm.qty.value		=     '<%=qty%>'	  ;	
	  document.myForm.uom.value		=     '<%=uom%>'	;  	
	  document.myForm.matDesc.value		=     '<%=matDesc%>' ;  	
}
</script>

</head>


<%
	String display_header = "Material Details";
%>

<body bgcolor="#FFFFF7" onLoad="scrollInit();funBackVals()" onResize="scrollInit()"  scroll=no>
<form name="myForm">
    
    <%@ include file="../Misc/ezDisplayHeader.jsp"%>

    <br><br>
<Div align="left" style='position:absolute;top:3%;margin-left: auto;margin-right: auto;margin-top: 5em;padding: 15px;border: 1px solid #cccccc;width: 80%;left:10%;background: #F1F3F5;height:40%'>     
<table width="90%" align="center" border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
<Tr>
	<Th width="20%" align="left">Material Number</Th>
	<Td width="40%">
		<input type="text" class="InputBox"  style="width:100%"  name="matNo" size="40" value="<%=matNo%>" readonly>
	</Td>
	<Td width="34%">
		<input type="text" class=InputBox   name="matDescScrh" style="width:100%"  value="Enter Search String Here." size="15" onFocus="setEmpty()" onKeyPress="KeySubmit()">
	</Td>	
	<Td width="6%" valign=middle align=center rowspan=2>	
		<img src="../../Images/Others/find.gif" style="cursor:hand" height="18" alt="Find" onClick="javascript:searchForMaterial()">
	</Td>
</Tr>  
<tr>
	<th width="20%" align="left">Material Desc.</th>
	<td width="40%">
		<input type="text" class="InputBox"  style="width:100%"  name="matDesc" size="40" value="<%=matDesc%>" readonly>
	</Td>
	<th width="34%">
		<input type="radio" name="SearchMat"  value="MatNo" checked>Material No.
		<input type="radio" name="SearchMat"  value="MatDesc">Material Desc.
		<!--<input type="radio" name="SearchMat"  value="MatNo" checked>Adopt-->
	</th>
</tr>  	    
	    <tr>
	    	    <th width="20%" align="left">Quantity</th>
	    	    <td width="80%" colspan=3><input type="text" class=InputBox  style="width:50%" name="qty" maxlength="9" size="10" value="<%=qty%>"></td>
	    </tr> 
	    <tr>
		    <th width="20%" align="left">UOM</th>
		    <td width="80%" colspan=3><input type="text" class=InputBox  name="uom" style="width:50%"  maxlength="10" size="10" value="<%=uom%>"></td>
	    </tr> 
	    <tr>
	    	    <th width="20%" align="left">Plant</th>
	   	    <Td width="80%" colspan=3 >
	   		<select name="plant" id="ListBoxDiv1" style="width:50%">
	   		<option value="NA">-Select Plant-</option>
<%	   		for(int i=0;i<count;i++)
	   		{
%>				<option value="<%=ret.getFieldValueString(i,"CODE")%>"><%=ret.getFieldValueString(i,"CODE")%></option>
<%	   		}
%>  	   		</select>
</Td>
		   <%-- <td width="50%"><input type="text" class=InputBox  name="plant" maxlength="15" size="15" value="<%=plant%>"></td>--%>
	    </tr>  
	    <tr>
		    <th width="20%" align="left">Delivery Date</th>
		    <td width="80%" colspan=3><input type="text" class=InputBox  style="width:50%;valign:top" name="deliveryDate" id="deliveryDate" value="" size=12 readonly onfocus=this.blur()>
							<%=getDateImage("deliveryDate")%>
		    </td>
	    </tr>

    </table>
    <input type="hidden" name="purchReq" value="">
    <input type="hidden" name="flag" value="Y">
    <input type=hidden name="purchaseHidden">
    <input type=hidden name="backChk" value="MAT">
    <input type =hidden name="documentType" value="AUCTION">


<br><br>    

<span id="EzButtonsSpan" >
<center>

<%
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();
	buttonName.add("GetSources");
	buttonMethod.add("vendorList()");
	buttonName.add("Clear");
	buttonMethod.add("reset()");
	out.println(getButtonStr(buttonName,buttonMethod));
	
%>

</center>
</span>
<span id="EzButtonsMsgSpan" style="display:none">
		<Table align=center>
			<Tr>
				<Th >Your request is being processed... Please wait</Th>
			</Tr>
		</Table>
		</span>
    </Div>
<input type="hidden" name="selItemCount" value="1">
<input type="hidden" name="createAuct" value="Y">
<input type="hidden" name="matStr" value="">
</form>
<Div id="MenuSol"></Div>
</body>
</html>