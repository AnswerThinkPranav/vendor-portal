<%//@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Labels/iGetInfo_Labels.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iGetInfo.jsp"%>
<html> 
<head>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp"%>
<script>
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
	{
		var submitForm = false;
		var phone = document.myForm.telephone1.value;
		var length = document.myForm.telephone1.value.length
		var email = document.myForm.email.value;
		var emailLength = document.myForm.email.value.length
		//alert(email);
		
		
		funEmail(email);
		
		if(length==0)
		{
			alert("Please Enter Phone Number");
			document.myForm.telephone1.focus()
			return false;	
		}
		/*else if(!funNumber(phone))
		{
			alert("Phone Number should contain only numbers");
			document.myForm.telephone1.focus()
			return false;	
		}*/
		
		if(emailLength==0)
		{
			alert("Please Enter Email");
			document.myForm.email.focus()
			return false;								
		}
		else if(!funEmail(email))
		{
			
			alert("Please Provide Valid Email Id");
			document.myForm.email.focus()
			return false;
		}
			
			document.myForm.action="ezUpdateErpInfo.jsp";
			document.myForm.submit();
		
		
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
		<input type="hidden" value="<%=companyName%>" name="payCompany" >
		
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
					<td width="60%" height="3"><%=companyName%></td>
				</tr>
				<tr>
					<th width="40%" align="left"><%=addr_L%></th>
					<td width="60%"><%=address1%>&nbsp;
						<!--<input type="text" class=InputBox  name="PayAddress1" value="<%=address1%>" size="40" maxlength="30">-->
					</td>
				</tr>
				<tr>
					<th width="40%" align="left"><font size="3">&nbsp;</font></th>
					<td width="60%"><%=address2%>&nbsp;
						<!--<input type="text" class=InputBox  name="PayAddress2" value = "<%=address2%>" size="40" maxlength="30">-->
					</td>
				</tr>
				<tr>
					<th width="40%" align="left"><%=city_L%></th>
					<td width="60%"><%=city%>&nbsp;
						<!--<input type="text" class=InputBox  maxlength="25" name="PayCity" size="40" value = "<%=city%>">-->
					</td>
				</tr>
				<tr>
					<th width="40%" align="left"><%=zip_L%></th>
					<td width="60%"><%=zipCode%>&nbsp;
						<!--<input type=text class=InputBox name=PayZip size=15 maxlength=10 value=<%=zipCode%>>-->
					</td>
				</tr>
				<tr>
					<th width="40%" align="left" ><%=country_L%></th>
					<td width="60%"><%=country%>&nbsp;
						<!--<input type="text" class=InputBox  name="PayCountry" size="3" value = "<%=country%>" maxlength="3">-->
					</td>
				</tr>
				
				<tr>
					<th width="40%" align="left" >Telephone</th>
					<td width="60%">
						<input type="text" class="<%=clas%>"  name="telephone1" size="20" value = "<%=telephone1%>" maxlength="20" <%=readonly%>>&nbsp;
					</td>
				</tr>
				<tr>
					<th width="40%" align="left" >Mobile phone</th>
					<td width="60%">
						<input type="text" class="<%=clas%>"  name="telephone2" size="20" value = "<%=telephone2%>" maxlength="20" <%=readonly%>>&nbsp;
					</td>
				</tr>
				<tr>
					<th width="40%" align="left" >Email</th>
					<td width="60%">
						<input type="text" class="<%=clas%>"  name="email" size="30" value = "<%=email%>" maxlength="30" <%=readonly%>>&nbsp;
					</td>
				</tr>
				<tr>
					<th width="40%" align="left" >Contact Person</th>
					<td width="60%">
						<input type="text" class="<%=clas%>"  name="contactPerson" size="40" value = "<%=remark%>" maxlength="40" <%=readonly%>>&nbsp;
					</td>
				</tr>
				</TABLE>
			</TD>
		</TR>
		</TABLE>
		<br>
		<div align="center">
<%
			buttonName = new java.util.ArrayList();
			buttonMethod = new java.util.ArrayList();

			buttonName.add("Back");
			buttonMethod.add("navigateBack(\"../Misc/ezSBUWelcome.jsp\")");
			//if("3".equals(userType))
			//{			
				buttonName.add("Change Address");
				buttonMethod.add("updateErp()");
			//}

			//buttonName.add("Clear");
			//buttonMethod.add("document.forms[0].reset()");

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
