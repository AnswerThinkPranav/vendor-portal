<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/JSPs/Misc/iLoginBanner.jsp" %>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@ include file="../Misc/ezVendorCompanyCodes.jsp" %>
<Html>
<%
String flag=request.getParameter("Flag");
%>
<Head>
<Script>
function funGO()
{
	var flag='<%=flag%>';
	var url;
	
	if(flag=='TU')
	{
		url="ezVendorAddChangeList.jsp";
	}
	else
	{
		url="ezVendorAddChangeActedList.jsp";
	}
	document.myForm.action = url;
	document.myForm.submit();
}		
</Script>
</Head>
<Body>
<Form name='myForm'>
<%	
	String display_header = "Vendor Address Change Requests";
%>
	<%@ include file="../Misc/ezDisplayHeader.jsp" %>
	<Br><br>
	
<Table width=40% align=center border=1  borderColorDark=#ffffff borderColorLight=#006666 cellPadding=0 cellSpacing=0>
	<Tr>
<%
		if(compCodeArr != null && compCodeArr.length > 1)
		{
			selCompFlg =true;
%>
			<Tr>
			<Th  align="left" width="10%">Company Code</Th>
			<Td  align="left" width="5%">
				<select name="selCompCode" onChange="funSelCompCode()" style="width:100%">
<%
				String selectedFlg = "";
				if(selCompCode==null || "null".equals(selCompCode) || "".equals(selCompCode) )
					selCompCode = compCodeArr[0]; 
				for(int k=0;k<compCodeArr.length;k++)
				{
					if(compCodeArr[k].equals(selCompCode))
						selectedFlg="selected";
%>
						<option value="<%=compCodeArr[k]%>" <%=selectedFlg%> ><%=compCodeDesc.get(compCodeArr[k])%></option>
<%
					selectedFlg=""; 
				}
%>
				</select>			
			</Td>
			</TR>
			
			
		<TR>
		<Th align="left" width="10%">Vendor</Th>
		<%
				String showDisplayFrame = "N";
				String USERDEFPURGRP =(String)session.getValue("USERDEFPURGRP");
				
				if(USERDEFPURGRP==null|| "null".equals(USERDEFPURGRP) ||"".equals(USERDEFPURGRP.trim()))
				USERDEFPURGRP="";
				if (catareaRows > 0)
				{
					String purGroupArea = "",purGroupCode = "";
					String purGroupDesc = "",domainType   = "";
					String companyCode  = "";
					String selectLabel  = "";
					String bannerLabel = "";
					/*if("3".equals(userType))
						bannerLabel = "Company Code";
					else*/
						bannerLabel = "Purchase Group";
					
					String selected = "";
					int selPAIndex = 0;
					int selVNIndex = 0;
					String colSpan = "";
					String selWidth= "";
					String colAlign= "";
					String colSpace= "";
					int soldtoRows = 0;
					if(retsoldto!=null)
						soldtoRows = retsoldto.getRowCount();
					if("3".equals(userType) || soldtoRows == 0)
					{
						colSpan = "colspan=3";
						selWidth= "width:30%";
						colAlign= "align=right"; 
						colSpace= "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
					}	
					else		
					{
						colSpan = "";
						selWidth= "width:55%";
						colAlign= "align=left"; 
						colSpace= "";
					}
		%>	
					
					
					
					</Font><%=colSpace%>
					</Td>
		
		<%
					boolean noVendor = false;
					String retVendorCode = "";
					String retVendorName = "";
					String selVendorCode = "";
					String selVendorName = "";
		
					if(!"3".equals(userType))
					{
						if(retsoldto!=null)
						{
							if(soldtoRows > 0)
							{
							
								retsoldto.sort(new String[]{"ECA_NAME"},true);
		%>					
								<Td  colspan='3'>
								
		<%
								if(soldtoRows == 1)
								{
									selVendorCode = retsoldto.getFieldValueString(0,"EC_ERP_CUST_NO").trim();
									selVendorName = retsoldto.getFieldValueString(0,"ECA_NAME").trim();
		%>
									<input type=hidden name='Vndr' value='<%=selVendorCode%>'>
									<input type=text class='tx' value='<%=selVendorCode+" --> "+selVendorName%>'>
		<%
								}
								else
								{
		%>
								
									<Select name="Vndr" onChange="changeVendor('N')" >
									<option value="">----------------Select Vendor--------------</option>
		<%					
									for(int i=0;i<soldtoRows;i++)
									{
										retVendorCode = retsoldto.getFieldValueString(i,"EC_ERP_CUST_NO").trim();
										retVendorName = retsoldto.getFieldValueString(i,"ECA_NAME").trim();
										if((vendorCode.trim()).equals(retVendorCode.trim()))
										{
											selected = "selected";
											selVNIndex = i;
											selVendorCode = retVendorCode;
											selVendorName = retVendorName;
										}	
										else
											selected = "";
											
										String vendorCodeString = "";	
										try
										{
											vendorCodeString = Integer.parseInt(retVendorCode)+"";
										}catch(Exception e){vendorCodeString = retVendorCode;}
		%>
										<option  value="<%=retVendorCode%>"><%=vendorCodeString+"->"+retVendorName%></option>
		<%
									}
									if(selVNIndex == 0)
									{
										selVendorCode = retsoldto.getFieldValueString(0,"EC_ERP_CUST_NO").trim();
										selVendorName = retsoldto.getFieldValueString(0,"ECA_NAME").trim();
									}
									noVendor = false;
		%>
									</Select>
									
									
		<%
								}
		%>
								</Td>
								<input type=hidden name="VENDOR_CODE" value="<%=selVendorCode%>">
								<input type=hidden name="VENDOR_NAME" value="<%=selVendorName%>">	
								<input type="hidden" name="selVNIndex" value="<%=selVNIndex%>">
		<%
								showDisplayFrame = "Y";
							}
							else
							{
								noVendor = true;
							}
						}
						else
						{
							noVendor = true;
							showDisplayFrame = "N";
						}
						if(noVendor)
						{
		%>
							<script>
								document.getElementById("home_mail").style.visibility="hidden"
								top.display.location.href='ezBlank.jsp?statement=Vendors not synchronized';
							</script>
		<%
							showDisplayFrame = "N";
						}
					}
					else
					{
						showDisplayFrame = "Y";
					}
		%>
					<input type="hidden" name="selPAIndex" value="<%=selPAIndex%>">
		<%
				}
				else
				{
		%>
					<script>
						document.getElementById("home_mail").style.visibility="hidden"
						top.display.location.href='ezBlank.jsp?statement=Purchase Groups not defined...Please contact Administrator';
					</script>
		<%
					showDisplayFrame = "N";
				}
%>			
			</Tr>
<%
	}
	else
	{
%>
		<input type="hidden" name="selCompCode" value="<%=selCompCode%>">
<%
	}
%>
	</Tr>
	</Table>
	<Div id="ButtonDiv" style="position:absolute;top:90%;width:100%;visibility:visible">
	<center>
	<%
		buttonName = new java.util.ArrayList();
		buttonMethod = new java.util.ArrayList();
		
		buttonName.add("GO");
		buttonMethod.add("funGO()");
		out.println(getButtonStr(buttonName,buttonMethod));
		
	%>	
			
		</Div>	

<Div id="MenuSol"></Div> 
</Form>
</Body>
</Html>