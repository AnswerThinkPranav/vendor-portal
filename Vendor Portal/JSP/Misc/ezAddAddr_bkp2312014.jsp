<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Labels/iGetInfo_Labels.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iGetInfo.jsp"%>


<%@ page import ="java.util.*"%>
<%
Vector vendorCodes = new Vector();
String SoldtoCode = (String)session.getValue("SOLDTO"); 
Hashtable<String,String> hTable=new Hashtable<String,String>();
hTable.put("AP", "Andhra Pradesh");
hTable.put("ARP", "Arunachal Pradesh");
hTable.put("AS", "Assam");
hTable.put("BH", "Bihar");
hTable.put("CH", "Chhattisgarh");
hTable.put("GOA", "Goa");
hTable.put("GJ", "Gujarat");
hTable.put("HY", "Haryana          ");
hTable.put("HP", "Himachal Pradesh");
hTable.put("JK", "Jammu and Kashmir");
hTable.put("JH", "Jharkhand");
hTable.put("KA", "Karnataka");
hTable.put("KL", "Kerala");
hTable.put("MP", "Madhya Pradesh");
hTable.put("MH", "Maharashtra");
hTable.put("MN", "Manipur       ");
hTable.put("MG", "Meghalaya");
hTable.put("MZ", "Mizoram       ");
hTable.put("NG", "Nagaland");
hTable.put("OR", "Orissa");
hTable.put("PN", "Punjab");
hTable.put("RJ", "Rajasthan");
hTable.put("SK", "Sikkim");
hTable.put("TN", "Tamil Nadu");
hTable.put("TI", "Tripura");
hTable.put("UP", "Uttar Pradesh");
hTable.put("UT", "Uttarakhand");
hTable.put("WB", "West Bengal");

	
	vendorCodes.addElement(SoldtoCode);
		
%>
	<%@ include file="../RFQ/ezGetVenMailIds.jsp" %>
	
<%
	
	String mySoldtoCode = "0000000000"+SoldtoCode.trim();
	mySoldtoCode = mySoldtoCode.substring(mySoldtoCode.length()-10,mySoldtoCode.length()); 
%>



<html> 
<head>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp"%>
<script>
	function funChangeAddr()
	{

		document.myForm.action="ezAddressChange.jsp";
		document.myForm.submit();
	}
	function funNumber(sValue)
	{
	
		var nValue=parseInt(sValue);
		nValue=nValue+"";
		if ((sValue != nValue) || nValue < 0)
		{
			return false;
		}
		return true;
	}
	
	function updateErp()
	{	var eml=document.myForm.email.value;
		var atpos=eml.indexOf("@");
                var dotpos=eml.lastIndexOf(".");
	
		if(document.myForm.companyName.value=='')
		{
			alert("Please Enter Company Name");
			document.myForm.companyName.focus();
			return;
		}
		if(document.myForm.address1.value=='')
		{
			alert("Please Enter Address ");
			document.myForm.address1.focus();
			return;
		}
		if(document.myForm.city.value=='')
		{
			alert("Please Enter city ");
			document.myForm.city.focus();
			return;
		}
		if(document.myForm.state.value=='')
		{
			alert("Please Select state ");
			document.myForm.state.focus();
			return;
		}
		if(document.myForm.pinCode.value=='')
		{
			alert("Please Enter Pin Code ");
			document.myForm.pinCode.focus();
			return;
		}
		if(document.myForm.contact.value=='')
		{
			alert("Please Enter Contact Number ");
			document.myForm.pinCode.focus();
			return;
		}
		if(document.myForm.email.value=='')
		{
			alert("Please Enter Email ");
			document.myForm.email.focus();
			return;
		}
		 if (atpos<1 || dotpos<atpos+2 || dotpos+2>=eml.length)
		  {
			alert("Not a valid e-mail address");
			document.myForm.email.focus();
		       return false;
                  }
			
	document.myForm.action="ezSaveAdd.jsp";
	document.myForm.submit();
		
		
	}
	 function num_val()
	  {
		var v=window.event.keyCode;
		if(v>=48 && v<=57)
		    return true;
		else
		    return false;
            }
	function funPopUp()
	{
		
		document.myForm.target = "PopUp";
		document.myForm.action= "ezVendorMailPopUp.jsp";
		newWindow=window.open("","PopUp","width=400,height=400,top=90,left=200,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
		document.myForm.onsubmit = newWindow;
		document.myForm.submit();
		document.myForm.target = "_self";
	}
	function funEmail(sValue)
	{	var s=""
		invalidChars = "' /:,;"
		if (sValue == "")
		{
			//alert("You must provide your Email address.")
			return false;
		}
	
		for (i = 0; i< invalidChars.length; i++)
		{
			badChar = invalidChars.charAt(i)
			if (sValue.indexOf(badChar,0) != -1)
			{
				msgString = "You can't use following characters " + invalidChars +" in your Email address."
				return false;
			}
		}
		atPos = sValue.indexOf("@",1)
		if (atPos == -1)
		{
			msgString = "You need to provide your Email UserId. i.e  your email should be in this format info@EzCommerceInc.com ."
			return false;
		}
		if (sValue.indexOf("@",atPos+1) != -1)
		{
	       		msgString ="The Email address you have provided does not have @ symbol. Please enter valid Email address."
			return false;
		}
	
		periodPos = sValue.lastIndexOf(".")
		if (periodPos == -1)
		{
			msgString ="The Email address you have provided does not have .com or .net etc. Please provide a valid Email address."
			return false;
		}
		if (! ( (periodPos+3 == sValue.length) || (periodPos+4  == sValue.length) ))
		{
			msgString ="The Email address you have provided does not have .com or .net etc. Please provide a valid Email address."
			return false;
		}
		return true;
}
</script>
<style>
	td.pagestyle
	{
		color: #660000;
		font-family: verdana, arial;
		font-size: 10px;
		background-color: #ffffff
	}
</style>
</head>
<body scroll=no>
<%
	String display_header = cAddr_L;
%>	
<%@ include file="ezDisplayHeader.jsp"%>
<br> 
<%

	String userType=(String)session.getValue("UserType");
	//out.println("userType:::"+userType);
	String clas="tx";
	String readonly="readonly";
	//if("3".equals(userType))
	//{
		clas="InputBox";
		readonly="";
	//}
		
	if(showAddressInfo) 
	{
	
%>
	
	<form method="post" name="myForm">
	<%@ include file="../../../Includes/JSPs/Misc/iGetStatus.jsp"%>
		<input type="hidden" value="<%=companyName%>" name="payCompany" >
		
		<input type="hidden" name="venMailAndSeqNumber" value="<%=venMailAndSeqNum.get(mySoldtoCode)%>">
		
		<TABLE align=center style="BORDER-RIGHT: #4374a6 1px solid; BORDER-TOP: #4374a6 1px solid; BORDER-LEFT: #4374a6 1px solid; BORDER-BOTTOM: #4374a6 1px solid" cellSpacing=0 cellPadding=0 width="75%"  height=60% border=0>
		<TR>
			<TD class="pagestyle" width="40%" align=center valign=middle>
				<img src="../../Images/Others/chgadd.jpg">

			</TD>
			<TD class="pagestyle" width="60%" align=left valign=middle>
				<TABLE width="90%" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=0 cellSpacing=0 >
				<tr >
					<th align="center" colspan=2><%//=plzChkAddr_L%> Address Information</th>
				</tr>
				<tr>
					<th width="40%" align="left"><%=company_L%></th>
					<td width="60%" height="3">
					<input type="text" name="companyName"  size='20' value="<%=companyName%>"></td>
				</tr>
				
				<tr>
					<th width="40%" align="left"><%=addr_L%></th>
					<td width="60%">
					<input type="text" name="address1" value="<%=address1%>">	
					</td>
				</tr>
<%
				if(!"".equals(address2))
				{
	%>			
				<tr>
					<th width="40%" align="left"><font size="3">&nbsp;</font></th>
					<td width="60%"><%=address2%>&nbsp;
					<input type="hidden" name="address2" value="<%=address2%>">	
					</td>
				</tr>
<%

				}
%>				
				<tr>
					<th width="40%" align="left"><%=city_L%></th>
					<td width="60%">
					<input type="text" name="city" value="<%=city%>">		
					</td>
				</tr>
				<Tr>
				
				<th width="15%" align="left">State</th>
				
			<Td>
<%
			if(count==0)
			{
%>			
			<select name="state" id="state" style="width:98%">
			

			<option value=""> --> Select State <--   </option>

			<%

			ArrayList al = new ArrayList(hTable.keySet());

			Collections.sort(al);

			for (Iterator i = al.iterator(); i.hasNext();)

			{

			String key=i.next()+"";

			String value = (String)hTable.get(key);

			out.println("<option value="+key+">"+value+"</option>");

			}

			%>        

			</select>
<%
			}
			if(count>0 && "CLOSED".equals(status))
			{
			String value = (String)hTable.get(state);
			if(value==null || "null".equals(value))	value="";
%>			
			<%=value%>
			
<%
			}
%>			
			</Td>

				</Tr>
				<tr>
					<th width="40%" align="left"><%=zip_L%></th>
					<td width="60%">
					<input type="text" name="pinCode" onKeyPress="return num_val()" value="<%=zipCode%>">	
						<!--<input type=text class=InputBox  name=PayZip size=15 maxlength=10 value=<%=zipCode%>>-->
					</td>
				</tr>
				<tr>
					<th width="40%" align="left" ><%=country_L%></th>
					<td width="60%"><%=country%>&nbsp;
					<input type="hidden" name="country" value="<%=country%>">	
						<!--<input type="text" class=InputBox  name="PayCountry" size="3" value = "<%=country%>" maxlength="3">-->
					</td>
				</tr>
				
				<tr>
					<th width="40%" align="left" >Telephone</th>
					<td width="60%">
					
						<input type="text" class="<%=clas%>"  onKeyPress="return num_val()" name="contact" size="20" value = "<%=telephone1%>" maxlength="20" <%=readonly%>>&nbsp;
					</td>
				</tr>
				<tr>
					
				</tr>
<%
			if(email==null||"null".equals(email))
				email="";
%>				
				<tr>
					<th width="40%" align="left" >Email</th>
					<td width="60%">
					<input type="text" class="<%=clas%>"  name="email" size="30"  maxlength="30" >&nbsp;
						
					</td>
				</tr>
				
				</TABLE>
			</TD>
		</TR>
		</TABLE>
		<br>
		<div align="center">
	
<input type="hidden" name="refNum" value="<%=refNum%>">

<%
			buttonName = new java.util.ArrayList();
			buttonMethod = new java.util.ArrayList();

			buttonName.add("Back");
			buttonMethod.add("navigateBack(\"../Misc/ezSBUWelcome.jsp\")");
						
			if(count==0)
			{
				buttonName.add("Save Address");
				buttonMethod.add("updateErp()");
			}
			if(count>0 && "SUBMITTED".equals(status))
			{
%>

<p><font color='red'>Your request is submitted to buyer.It is under process</font></p>
<%
			}
			if(count>0 && "CLOSED".equals(status))
			{
%>
<p><font color='red'>You want to change the address to other state then you need to follow the vendor registration process......</font></p>
<%
				buttonName.add("Change Address");
				buttonMethod.add("funChangeAddr()");
			
			}
	
			out.println(getButtonStr(buttonName,buttonMethod));	
%>    
		</div>

		<input type="hidden" name="defOrderToCustNum" value="<%=shpECANum%>">
		<input type="hidden" name="defPayToCustNum" value="<%=payECANum%>">
		</form>
<%
	} 
	else 
	{
		noDataStatement = noAddrUpdate_L+"";
%>
		<%@ include file="../Misc/ezDisplayNoData.jsp" %>
<%
	}
%>
<Div id="MenuSol"></Div>	
</body>
</html>
