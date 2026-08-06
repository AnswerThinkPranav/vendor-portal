<%//@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Labels/iListSbuPlantAddresses_Lables.jsp"%>
<% String fileName = "ezListSbuPlantAddresses.jsp"; %>
<%@ include file="../../../Includes/JSPs/Misc/iSbuPlantAddress.jsp"%>
<%@ include file="../../../Includes/Lib/ezCountries.jsp" %>
<head>

	<%@ include file="../../../Includes/Lib/AddButtonDir.jsp"%> 



	<script>
	var ruSureDelPlnt_L = '<%=ruSureDelPlnt_L%>';
	function ShowAddress()
	{
		var usertype='<%=session.getValue("UserType")%>'
		
		var len=document.myForm.addcode.length;
		for(var i=1;i<len;i++)
		{
			var indexObj = document.getElementById("index"+i)
			if(indexObj != null)
				indexObj.style.visibility="hidden";
			if(usertype!=3)
			{
				document.getElementById("ButtonDiv1"+i).style.visibility="hidden";
			}
		}
		var ind=document.myForm.addcode.selectedIndex;

		if(ind!=0)
		{

			var indexObj = document.getElementById("index"+ind)
			if(indexObj != null)
				indexObj.style.visibility="visible";
			if(usertype!=3)
			{
				document.getElementById("ButtonDiv1"+ind).style.visibility="visible";
				document.getElementById("ButtonDiv").style.visibility="hidden";
			}
		}
		else
		{
			        if(document.getElementById("ButtonDiv")!=null)
				document.getElementById("ButtonDiv").style.visibility="visible";
		}

	}
	
	function funEdit(index)
	{
		document.myForm.index.value=index;
		document.myForm.action="ezEditSbuPlantAddress.jsp"
		document.myForm.submit();
	}
	
	function funAdd(index)
	{
		document.myForm.index.value=index;
		document.myForm.action="ezAddSbuPlantAddress.jsp"
		document.myForm.submit();
	}
	function funDelete(index)
	{
		if(confirm(ruSureDelPlnt_L))
		{
			document.myForm.index.value=index;
			document.myForm.action="ezDeleteSbuPlantAddress.jsp"
			document.myForm.submit();
		}	
	}

	function funOnload()
	{
		var index='<%=redirectindex%>'
		var code='<%=redirectcode%>'
		var count='<%=count%>'
		if(count!='0')
		{
			if(index!='null')
			{

				document.getElementById("index"+index).style.visibility="visible";
				document.getElementById("ButtonDiv1"+index).style.visibility="visible";
				document.getElementById("ButtonDiv").style.visibility="hidden";
			}
			else
			{

				var usertype='<%=session.getValue("UserType")%>'
				if(usertype!=3)
					document.getElementById("ButtonDiv").style.visibility="visible";
			}
		}
	}
	function showMsgDiv()
	{
		var msgDivObj = document.getElementById("showMsg");
		try{
		
			
		if(document.myForm.addcode.selectedIndex>0)
			msgDivObj.style.visibility = "hidden";
		else
			msgDivObj.style.visibility = "visible";
		}catch(e){
			
		}	
	}
	
	</script>
	
</head>
<body scroll="no"  onLoad="funOnload();showMsgDiv()">
<form method="post" name="myForm">
<%
	String display_header = plntAdd_L;
	
%>
<%@ include file="ezDisplayHeader.jsp"%>

<%
 	if(count==0)
	{
		String noDataStatement = clkAddPlntAdd_L;
%>
		<%@ include file="../Misc/ezDisplayNoData.jsp" %>
		<br>
		<Div id="ButtonDiv" align=center style="position:absolute;top:90%;visibility:visible;width:100%">
		<center>
		<%
			buttonName = new java.util.ArrayList();
			buttonMethod = new java.util.ArrayList();
			
			buttonName.add("Back");
			buttonMethod.add("navigateBack(\"../Misc/ezSBUWelcome.jsp\")");
			
			
			buttonName.add("Add");
			buttonMethod.add("funAdd()");
							
			out.println(getButtonStr(buttonName,buttonMethod));	
		%>
		</center>
		</Div>
<%
	}
	else
	{
%>
<br> 
<TABLE align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 height=80% width=95%>
<TR>
<TD  style="background-color:#ffffff" > 
<TABLE align=center border=0 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 height=70% width=100%>
<TR>
	<TD style="background-color:#ffffff" width="40%" align=center valign=middle>
		<br><br><br>
		<img src="../../Images/Others/corpplant.gif" border=0>
	</TD>
	<TD style="background-color:#ffffff" width="60%" align=left valign=middle>
	<br>
		<Div id='inputDiv' style='position:relative;align:center;top:1%;width:100%;height:15%; left:1%'>
		<Table width="90%" border="0" cellspacing="0" cellpadding="0" align=center valign=center>
		<Tr>
			<Td height="5" style="background-color:'F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"></Td>
			<Td height="5" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"><img width="1" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"></Td>
			<Td height="5" style="background-color:'F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"></Td>
		</Tr>
		<Tr >
			<Td width="5" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"><img width="5" height="1" src="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"></Td>
			<Td style="background-color:'F3F3F3'" valign=middle>	
				<TABLE width="60%" align=center border=0 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
				<tr>
					<Td width="30%" style="background-color:'F3F3F3'"><B><%=selPlant_L%></B></Td>
					<td width="70%" style="background-color:'F3F3F3'">
					<div id="ListBoxDiv1">
					<select align="center"  style="width:80%" onChange="ShowAddress();showMsgDiv()" name="addcode" class="control">
					<option value="">--Select--</option>
<%

	   for(int i=0;i<count;i++)
	   {
	   		if(redirectcode!=null)
	   		{
	   			if(redirectcode.equals(ret.getFieldValueString(i,"CODE")))
	   			{
	   				out.println(redirectcode);
%>
					<option selected><%=ret.getFieldValueString(i,"CODE")%>---><%=ret.getFieldValueString(i,"CATEGORY")%></option>
<%				}
				else
				{
%>
					<option><%=ret.getFieldValueString(i,"CODE")%>---><%=ret.getFieldValueString(i,"CATEGORY")%></option>
<%
				}
			}
			else
			{
%>
					<option><%=ret.getFieldValueString(i,"CODE")%>---><%=ret.getFieldValueString(i,"NAME")%></option>
<%
			}
      }
%>
	</select>
	</div>
	</td>
	</tr>
	</table>
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
		<Div id="showMsg" name="showMsg" align=center style="position:absolute;top:55%;width:100%; left:40%">
		<Table align=center border=0 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0 >
			<Tr>
				<Td style="background-color:#ffffff;font-size: 12px;font-weight: bold;color:#3e8eb3" ><%=plzSelplAbv_L%></Td>
			</Tr>
		</Table>
		</Div>	  
<%
	for(int i=0;i<count;i++)
	{
%>
 
		<div id="index<%=(i+1)%>" name="index<%=(i+1)%>" style="position:absolute;visibility:hidden; left:33%">
		<br>
		<TABLE width="170%" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0 >
		<tr>
			<th width="32%" align="left"><%=name_L%></th>
			<%
				String Name = ret.getFieldValueString(i,"NAME");
				if("null".equals(Name.trim()))
					Name = "";
			%>
			<td width="80%" colspan=3><%=Name%>&nbsp;</td>
		</Tr>
		<Tr>
			<th width="32%" align="left">ADDRESS</th>
			<%
				String Addr = ret.getFieldValueString(i,"ADDRESS");
				if("null".equals(Addr.trim()))
					Addr = "";
			%>
			<td width="80%" colspan=3><%=Addr%>&nbsp;</td>
			
		</tr>
		<tr>

			<th width="32%" align="left">Ecc No</th>
			<%
				String eccnumber = ret.getFieldValueString(i,"ECCNUMBER");
				if("null".equals(eccnumber.trim()))
					eccnumber = "";
			%>
			<td width="20%"><%=eccnumber%>&nbsp;</td>

			<th width="32%" align="left">Tin No</th>
			<%
				String tinno = ret.getFieldValueString(i,"TINNO");
				if("null".equals(tinno.trim()))
					tinno = "";
			%>
			<td width="20%"><%=tinno%>&nbsp;</td>
		</tr>
		<tr>
			
			<th width="32%" align="left">Zip Code</th>
			<%
				String cst = ret.getFieldValueString(i,"CST");
				if("null".equals(cst.trim()))
					cst = "";
			%>
			<td width="20%"><%=cst%>&nbsp;</td> 

			<th width="32%" align="left">Location</th>
			<%
				String location = ret.getFieldValueString(i,"LOCATION");
				if("null".equals(location.trim()))
					location = "";
			%>
			<td width="20%"><%=location%>&nbsp;</td>
			
		</tr>
		<tr>
			<th width="32%" align="left"><%=phone_L%></th>
			<%
				String phone = ret.getFieldValueString(i,"PHONE");
				if("null".equals(phone.trim()))
					phone = "";
			%>
			<td width="20%" ><%=phone%>&nbsp;</td>
			
			<th width="32%" align="left">Fax</th>
			<%
				String Fax = ret.getFieldValueString(i,"FAX");
				if("null".equals(Fax.trim()))
					Fax = "";
			%>
			<td width="20%" ><%=Fax%>&nbsp;</td>
		</tr>
		
		
				
		<tr>
					
			<th width="32%" align="left">Excise Registration No</th>
			<%
				String exciseRegNo = ret.getFieldValueString(i,"EXCISEREGNO");
				if("null".equals(exciseRegNo.trim()))
					exciseRegNo = "";
			%>
			<td width="20%"><%=exciseRegNo%>&nbsp;</td> 

			<th width="32%" align="left">Excise Range</th>
			<%
				String exciseRange = ret.getFieldValueString(i,"EXCISERANGE");
				if("null".equals(exciseRange.trim()))
					exciseRange = "";
			%>
			<td width="20%"><%=exciseRange%>&nbsp;</td>
					
		</tr>
		
		
		
		<tr>
							
			<th width="32%" align="left">Excise Division</th>
			<%
				String exciseDivision = ret.getFieldValueString(i,"EXCISEDIVISION");
				if("null".equals(exciseDivision.trim()))
					exciseDivision = "";
			%>
			<td width="20%"><%=exciseDivision%>&nbsp;</td> 

			<th width="32%" align="left">Excise Commissionerate</th>
			<%
				String exciseComm = ret.getFieldValueString(i,"EXCISECOMM");
				if("null".equals(exciseComm.trim()))
					exciseComm = "";
			%>
			<td width="20%"><%=exciseComm%>&nbsp;</td>
							
		</tr>
		
		<tr>
							
			<th width="32%" align="left">CST Number</th>
			<%
				String cstNum = ret.getFieldValueString(i,"CSTNUM");
				if("null".equals(cstNum.trim()))
					cstNum = "";
			%>
			<td width="20%"><%=cstNum%>&nbsp;</td> 

			<th width="32%" align="left">LST Number</th>
			<%
				String lstNum = ret.getFieldValueString(i,"LSTNUM");
				if("null".equals(lstNum.trim()))
					lstNum = "";
			%>
			<td width="20%"><%=lstNum%>&nbsp;</td>
							
		</tr>
		
		
		<tr>
									
			<th width="32%" align="left">Permanent Account Number</th>
			<%
				String permanentAccNum = ret.getFieldValueString(i,"PERMANENTACCNUM");
				if("null".equals(permanentAccNum.trim()))
					permanentAccNum = "";
			%>
			<td width="20%"><%=permanentAccNum%>&nbsp;</td> 

			<th width="32%" align="left">Service Tax Registration Number</th>
			<%
				String serviceTaxRegNum = ret.getFieldValueString(i,"SERVICETAXREGNUM");
				if("null".equals(serviceTaxRegNum.trim()))
					serviceTaxRegNum = "";
			%>
			<td width="20%"><%=serviceTaxRegNum%>&nbsp;</td>
									
		</tr>
		
		
		</table>
		</div>
<%	if(session.getValue("UserType").equals("2"))
	{
%>

<Div id="ButtonDiv" align=center style="position:absolute;top:93%;visibility:hidden;left:20%;width:100%">
<Table align="center">
<tr align="center">
<td class=blankcell align="center">
<%
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();
	
	buttonName.add("Back");
	buttonMethod.add("navigateBack(\"../Misc/ezSBUWelcome.jsp\")");
	buttonName.add("Add");
	buttonMethod.add("funAdd(\"null\")");
	
	out.println(getButtonStr(buttonName,buttonMethod));	
%>
</Td>
</Tr>
</Table>
</div>

<Div id="ButtonDiv1<%=i+1%>" name="ButtonDiv1<%=i+1%>" align=center style="position:absolute;top:93%;visibility:hidden;left:20%;width:100%">
<Table align="center">
<tr align="center">
<td class=blankcell align="left">
<%
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();
	
	buttonName.add("Add");
	buttonMethod.add("funAdd(\""+(i+1)+"\")");

	buttonName.add("Edit");
	buttonMethod.add("funEdit(\""+(i+1)+"\")");

	//buttonName.add("Delete");
	//buttonMethod.add("funDelete(\""+(i+1)+"\")");
	

	
	 out.println(getButtonStr(buttonName,buttonMethod));	
%>
</Td>
</Tr>
</Table>
</div>

	
<%
	}

%>

		<input type="hidden" name="name<%=i+1%>" value="<%=ret.getFieldValueString(i,"NAME")%>" >
		<input type="hidden" name="category<%=i+1%>" value="<%=ret.getFieldValueString(i,"CATEGORY")%>" >
		<input type="hidden" name="address<%=i+1%>" value="<%=ret.getFieldValueString(i,"ADDRESS")%>">
		<input type="hidden" name="eccnumber<%=i+1%>" value="<%=ret.getFieldValueString(i,"ECCNUMBER")%>" >
		<input type="hidden" name="tinno<%=i+1%>" value="<%=ret.getFieldValueString(i,"TINNO")%>" >
		<input type="hidden" name="cst<%=i+1%>" value="<%=ret.getFieldValueString(i,"CST")%>" >
		<input type="hidden" name="phone<%=i+1%>" value="<%=ret.getFieldValueString(i,"PHONE")%>" >
		<input type="hidden" name="location<%=i+1%>" value="<%=ret.getFieldValueString(i,"LOCATION")%>" >
		<input type="hidden" name="code<%=i+1%>" value="<%=ret.getFieldValueString(i,"CODE")%>" >
		<input type="hidden" name="fax<%=i+1%>" value="<%=ret.getFieldValueString(i,"FAX")%>" >
		
		<input type="hidden" name="exciseRegNo<%=i+1%>" value="<%=ret.getFieldValueString(i,"EXCISEREGNO")%>" >
		<input type="hidden" name="exciseRange<%=i+1%>" value="<%=ret.getFieldValueString(i,"EXCISERANGE")%>" >
		<input type="hidden" name="exciseDivision<%=i+1%>" value="<%=ret.getFieldValueString(i,"EXCISEDIVISION")%>" >
		<input type="hidden" name="exciseComm<%=i+1%>" value="<%=ret.getFieldValueString(i,"EXCISECOMM")%>" >
		<input type="hidden" name="cstNum<%=i+1%>" value="<%=ret.getFieldValueString(i,"CSTNUM")%>" >
		<input type="hidden" name="lstNum<%=i+1%>" value="<%=ret.getFieldValueString(i,"LSTNUM")%>" >
		<input type="hidden" name="permanentAccNum<%=i+1%>" value="<%=ret.getFieldValueString(i,"PERMANENTACCNUM")%>" >
		<input type="hidden" name="serviceTaxRegNum<%=i+1%>" value="<%=ret.getFieldValueString(i,"SERVICETAXREGNUM")%>" >


<%
	}

%>
	</td>
	</tr>
</table>
	
	</td>
	</tr>
</table>

<%
	}
%>
<input type="hidden" name="index" value="">
<Div id="MenuSol">
</Div>	
</form>
</body>
</html>
