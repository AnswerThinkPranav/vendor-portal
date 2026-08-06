<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Labels/iGetInfo_Labels.jsp"%>
<%@ include file="../Misc/ezVendorCompanyCodes.jsp" %> 
<%@ include file="../../../Includes/JSPs/Misc/iGetInfo.jsp"%>
<%@ include file="../Misc/ezStateCodesAndNames.jsp" %> 
<%@ include file="../../../Includes/JSPs/Misc/iGetStatus.jsp"%>


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
hTable.put("MN", "Manipur");  
hTable.put("MG", "Meghalaya");
hTable.put("MZ", "Mizoram");
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
	
	String mySoldtoCode = "0000000000"+SoldtoCode.trim();
	mySoldtoCode = mySoldtoCode.substring(mySoldtoCode.length()-10,mySoldtoCode.length()); 
%>



<html> 
<head>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp"%>
<script>  
	function funChangeAddr()
	{	var eml=document.myForm.email.value;
		var atpos=eml.indexOf("@");
                var dotpos=eml.lastIndexOf(".");

		if(document.myForm.houseNo.value=='')
		{
			alert("Please Enter House No. ");
			document.myForm.houseNo.focus();
			return;
		}
		if(document.myForm.address.value=='')
		{
			alert("Please Enter Address ");
			document.myForm.address.focus();
			return;
		}
		if(document.myForm.city.value=='')
		{
			alert("Please Enter city ");
			document.myForm.city.focus();
			return;
		}
		if(document.myForm.district.value=='')
		{
			alert("Please Enter District");
			document.myForm.district.focus();
			return;
		}
		
		if(document.myForm.pinCode.value=='')
		{
			alert("Please Enter Pin Code ");
			document.myForm.pinCode.focus();
			return;
		}
		if(document.myForm.pinCode.value.length!=6)
		{
			alert("Please Enter Valid Pin Code ");
			document.myForm.pinCode.focus();
			return;
		}
		if(document.myForm.contact.value=='')
		{
			alert("Please Enter Contact Number ");
			document.myForm.pinCode.focus();
			return;
		}
		/*if(document.myForm.contact.value.length!=10)
		{
			alert("Please Enter Contact Number ");
			document.myForm.pinCode.focus();
			return;
		}*/
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
	
	function funSubmit()
	{	var eml=document.myForm.email.value;
		var atpos=eml.indexOf("@");
                var dotpos=eml.lastIndexOf(".");
	
		if(document.myForm.houseNo.value=='')
		{
			alert("Please Enter House No. ");
			document.myForm.houseNo.focus();
			return;
		}
		if(document.myForm.address.value=='')
		{
			alert("Please Enter Address ");
			document.myForm.address.focus();
			return;
		}
		if(document.myForm.city.value=='')
		{
			alert("Please Enter city ");
			document.myForm.city.focus();
			return;
		}
		
		if(document.myForm.district.value=='')
		{
			alert("Please Enter District");
			document.myForm.district.focus();
			return;
		}
		
		if(document.myForm.pinCode.value=='')
		{
			alert("Please Enter Pin Code ");
			document.myForm.pinCode.focus();
			return;
		}
		if(document.myForm.pinCode.value.length!=6)
		{
			alert("Please Enter Valid Pin Code ");
			document.myForm.pinCode.focus();
			return;
		}
		if(document.myForm.contact.value=='')
		{
			alert("Please Enter Contact Number ");
			document.myForm.contact.focus();
			return;
		}
		/*if(document.myForm.contact.value.length!=10)
		{
			alert("Please Enter Valid Contact Number ");
			document.myForm.contact.focus();
			return;
		}*/
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
			
	attachmentsCnt= 0;
	for (var i = 0; i < document.myForm.attachs.options.length; i++) { 
	     document.myForm.attachs.options[i].selected = true; 
	     
	     if(document.myForm.attachs.options[i].value!='')
	     	attachmentsCnt++;
	     
        } 
        
        if(attachmentsCnt==0)
        {
        	alert("Please upload required document.");
        	return;
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
function funAttach()
{
	
	window.open('../Inbox/ezAttachFile.jsp','popuppage','left=510,top=180,width=400,height=360,statusbar=no');
	
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
		
	if(showAddressInfo)   
	{
	
%>
	<form method="post" name="myForm">
	<input type="hidden" value="<%=companyName%>" name="payCompany" >
	<input type="hidden" value="<%=compcode%>" name="compcode" >

	<TABLE align=center style="BORDER-RIGHT: #4374a6 1px solid; BORDER-TOP: #4374a6 1px solid; BORDER-LEFT: #4374a6 1px solid; BORDER-BOTTOM: #4374a6 1px solid" cellSpacing=0 cellPadding=0 width="75%"  height=60% border=0>
	<TR>
		<TD class="pagestyle" width="40%" align=center valign=middle>
			<img src="../../Images/Others/chgadd.jpg">

		</TD>
		<TD class="pagestyle" width="60%" align=left valign=middle>
			<TABLE width="90%" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=0 cellSpacing=0 >
			<tr>
				<th height=30 width="40%" align="left"><%=company_L%></th>
				<td height=30 width="60%" height="3"><%=companyName%>
				<input type="hidden" class="tx" name="companyName"  size='30' value="<%=companyName%>" readonly ></td>
			</tr>
			<tr>
				<th height=30 width="40%" align="left">House No.</th>
				<td height=30 width="60%" height="3">
				<input type="text" class=InputBox name="houseNo"  size='30' value="<%=houseNo%>"></td>
			</tr>

			<tr>
				<th width="40%" align="left"><%=addr_L%></th>
				<td width="60%">
				<TextArea rows='3' cols='40' name='address'><%=address%></TextArea>

				</td>
			</tr>				
			<tr>
				<th height=30 width="40%" align="left"><%=city_L%></th>
				<td height=30 width="60%">
				<input type="text" class=InputBox name="city" size='30' value="<%=city%>">		
				</td>
			</tr>

			<tr>
				<th height=30 width="40%" align="left">District</th>
				<td height=30 width="60%" height="3">
				<input type="text" class=InputBox name="district"  size='30' value="<%=district%>"></td>
			</tr>

			<tr>
				<th height=30 width="40%" align="left"><%=zip_L%></th>
				<td height=30 width="60%">
				<input type="text" name="pinCode" class=InputBox maxLength='6' size='30' onKeyPress="return num_val()" value="<%=zipCode%>">	
				</td>
			</tr>
			<tr>
				<th height=30 width="40%" align="left" >Telephone</th>
				<td height=30 width="60%">
					<input type="text" class=InputBox  maxLength='10' size='30' onKeyPress="return num_val()" name="contact" size="20" value = "<%=telephone1%>" maxlength="20">&nbsp;
				</td>
			</tr>
			<tr>

			</tr>				
			<tr>
				<th height=30 width="40%" align="left" >Email</th>
				<td height=30 width="60%">
				<input type="text" class=InputBox name="email" size="30" value='<%=email%>' maxlength="30" >&nbsp;
				</td>
			</tr>

			<tr>
				<th height=30 width="40%" align="left" >State</th>
				<td height=30 width="60%"><%=statesHT.get(vendState)%>&nbsp;
				<input type="hidden" name="vendState" value="<%=vendState%>" size='30'>	
				</td>
			</tr>
			<tr>
				<th height=30 width="40%" align="left" ><%=country_L%></th>
				<td height=30 width="60%"><%=country%>&nbsp;
					<input type="hidden" name="country" value="<%=country%>" size='30'>	
				</td>
			</tr>

			<Tr>
				<Th  align="center" width="40%">Attachment</Th>
				<Td  align="center" width="60%">
				<a href="JavaScript:funAttach()" title="Click Here To Attach A File"><img src="../../Images/attach_icon.png" alt="Click Here To Add Attachments" height="20" border="0" width="20"></a>&nbsp;&nbsp;&nbsp;&nbsp;
				<Select name='attachs' id="attachs" multiple=1 style="width:75%"></Select>&nbsp;&nbsp;&nbsp;&nbsp;
				<a href="JavaScript:funRemove()" title="Click Here To Remove Attached File"><img src="../../Images/remove_icon.png" alt="Click Here To Delete Attachments" height="20" border="0"  width="20"></a>
				</td>
			</Tr>


			</TABLE>
		</TD>
	</TR>
	</TABLE>
	<br>
	<div align="center">
	

<%
		buttonName = new java.util.ArrayList();
		buttonMethod = new java.util.ArrayList();

		if(count==0)
		{
			buttonName.add("Save Address");
			buttonMethod.add("funSubmit()");
%>
			<p><font color='red' size=2><B>If you want to change the address to other state then you need to follow the vendor registration process......</font></B></p>
			<p><font color='red' size=2><B>Note : </B></font<p><font color='BROWN' size=2><B>Please upload required supporting documents of Address Change.</B></p>

<%				
		}
		if(count>0)
		{
%>
			<p><font color='red' size=2><B>Your Address Change request is under process.</font></B></p>
<%
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
