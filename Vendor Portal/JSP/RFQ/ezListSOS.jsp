<%
	
	if(myRetCount==0)
	{
		
%>

	<br><br><br><br><br>
	<TABLE width=80% align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0 >
	<tr>
	<Th>No Vendors exist for the selected Material</th>
	</tr>
	</table>
<%
	}
	else
	{

%>
<DIV id="theads" >
<TABLE id="tabHead" width="90%" align=center  border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
        <tr>
		<th align="center" width="5%">&nbsp;</th>
		<th align="center" width="15%">Vendor</th>
		<th align="center" width="50%">Vendor Name</th> 
		<th align="center" width="20%">Info Record</th>
		<th align="center" width="10%">PO Unit</th>
        </tr>
</table>
</div>

<DIV id="InnerBox1Div" style="overflow:auto;position:absolute;width:90%;height:60%;left:5%">
<TABLE  id="InnerBox1Tab" width="100%" align=center  border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
<%
	String agreement = "";
	String vendor="",agmtItem="",concatString="",vendName="";
	String vendorDis="",vendCity="";
	//if(qty!=null)
	//	qty = qty.substring(0,(qty.length()-1));
	java.util.Vector vendorVector = new java.util.Vector();
	
	
	
	myRet.sort(new String[]{"VENDOR"},true);
 	for(int i=0;i<myRetCount;i++)
	{
		agreement = myRet.getFieldValueString(i,"AGREEMENT");
		vendor=myRet.getFieldValueString(i,"VENDOR");
		
		try
		{
			vendCity=venodorsCityHT.get(vendor.trim())+"";;
		}
		catch(Exception e)
		{
			vendCity="";
		}
		if(vendCity==null || "null".equals(vendCity.trim()))
			vendCity = "";
		
		try
		{
			
			vendorDis=Long.parseLong(myRet.getFieldValueString(i,"VENDOR"))+"";
		}
		catch(Exception e)
		{
			vendorDis=myRet.getFieldValueString(i,"VENDOR");
		}
		
		try
		{
			agmtItem=""+Long.parseLong(myRet.getFieldValueString(i,"AGMT_ITEM"));
		}
		catch(Exception e)
		{
			agmtItem=myRet.getFieldValueString(i,"AGMT_ITEM");
		}
		
		vendName = (String)venodorsHT.get(vendor);
		if(vendName==null || "null".equals(vendName) || "".equals(vendName))
			vendName = "Vendor not created in the portal";
		
		if(!vendorVector.contains(vendorDis))
		{
			noOfVndrsDisplayed++;
			vendorVector.addElement(vendorDis);
			concatString = myRet.getFieldValueString(i,"VENDOR")+"#"+vendName+"#"+"A";
%>
			<tr>
				<input type="hidden" name="venDet1" value="<%=myRet.getFieldValueString(i,"VENDOR")%>#<%=(String)venodorsHT.get(vendor)%>">
				<input type="hidden" name="selVen" value="<%=myRet.getFieldValueString(i,"VENDOR")%>">
				<input type="hidden" name="Ven_<%=myRet.getFieldValueString(i,"VENDOR")%>" value="<%=i%>">
				<td align="center" width="5%"><input type="checkbox" name="chk1" value="<%=concatString%>" onClick="selVendList(this,'<%=myRet.getFieldValueString(i,"VENDOR")%>')"></td>
				<td align="center" width="15%"><a href = "javascript:funShowVndrDetails('<%=(String)session.getValue("SYSKEY")%>','<%=vendor%>')"><%=vendorDis%>&nbsp;</a></td>
				<td align="left" width="50%"><%=vendName%></td>
				<td align="center" width="20%"><%=myRet.getFieldValueString(i,"INFO_REC")%>&nbsp;</td>
        			<td align="center" width="10%"><%=myRet.getFieldValueString(i,"PO_UNIT")%>&nbsp;</td>
        		
			</tr>
<%
		}
	}
%>
</table>
</div>
<% 	} 
%>
<DIV id="chkHidden" style="overflow:auto;position:absolute;top:70%;width:90%;height:30%;left:5%">
</Div>
<Div id="MenuSol"></Div>
