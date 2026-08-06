<link rel="stylesheet" type="text/css" href="../../Library/jquery/jquery-ui-1.12.1.custom/jquery-ui.css">
<%
	String menuItem = request.getParameter("menuItem");
	String tabWidth = "60%";
	
	if("2".equals(userType))
		tabWidth = "95%";
		{
%>
<Br>
	<Table border="1" align="center" valign=middle width="<%=tabWidth%>" cellpadding=0 cellspacing=0 class=welcomecell style="font-size: 12px;">
	<Tr>
		<Th <%=trBGColorH%>>
			&nbsp;From 
		</Th>
		<Td>
			<!--<input type=text class=inputbox value="<%=fromDate%>"  id="FromDate" name="FromDate"  readonly size=15 maxlength="10">&nbsp;-->
			 <input class="form-control input-sm" type="text" value="<%=fromDate%>"  name="FromDate" id="FromDate"  >
		</Td>
		<Td>
			 <label for="FromDate" class="input-group-addon btn"> <img src='../../../../EzCommon/JavaScript/Calendar/Themes/icons/calendar9.gif' style='cursor:hand' id='butt"+field+"' border='none' valign='center'></label>  
			
 		</Td>
		<Th <%=trBGColorH%>>
			&nbsp;To &nbsp;
		</Th>
		<Td>
			<!--<input type=text class=inputbox value="<%=toDate%>" name="ToDate"  id="ToDate"  readonly size=15 maxlength="10">&nbsp;-->
			<input class="form-control input-sm" type="text" value="<%=toDate%>"  name="ToDate" id="ToDate"  >
		</Td>			
		<Td>
		  	<label for="ToDate" class="input-group-addon btn"> <img src='../../../../EzCommon/JavaScript/Calendar/Themes/icons/calendar9.gif' style='cursor:hand' id='butt"+field+"' border='none' valign='center'></label>  
 		</Td>
 		
 <%
 	}if("2".equals(userType))
 	{
 		//out.println(vendorsRetObj.toEzcString());
%>		
		<Th <%=trBGColorH%>>
			&nbsp;&nbsp;&nbsp;&nbsp;Vendor&nbsp;&nbsp;
		</Th>
		<Td>
			<Select name="buyerSelVendor">
<%
		if("RFQ".equals(menuItem) || "ASN".equals(menuItem) || "STR".equals(menuItem) || "PO".equals(menuItem) || "INV".equals(menuItem))
		{
%>
			<Option value="ALL">--ALL--</Option>
<%
		}else{
  			if(vendorsRetObjCnt>0)
  				session.putValue("SEL_VEND_NAME",vendorsRetObj.getFieldValueString(0,"ECA_NAME"));
  		}
		String ven_Selected = "";
		for(int ve=0;ve<vendorsRetObjCnt;ve++)
		{
			ven_Selected = "";
			if(vendorsRetObj.getFieldValueString(ve,"EC_ERP_CUST_NO").equals(request.getParameter("buyerSelVendor")))
			{
				ven_Selected = "selected";
				session.putValue("SEL_VEND_NAME",vendorsRetObj.getFieldValueString(ve,"ECA_NAME"));
			}	
%>			
			<Option value="<%=vendorsRetObj.getFieldValueString(ve,"EC_ERP_CUST_NO").trim()%>" <%=ven_Selected%>><%=vendorsRetObj.getFieldValueString(ve,"ECA_NAME")+"["+vendorsRetObj.getFieldValueString(ve,"EC_ERP_CUST_NO")+"]"%></Option>
<%
		}
		if("RFQ".equals(menuItem))
		{
			for(int tu=0;tu<tempVendorsRetObjCnt;tu++)
			{
				ven_Selected = "";
				if(tempVendorsRetObj.getFieldValueString(tu,"EU_ID").equals(request.getParameter("buyerSelVendor")))
				{
					ven_Selected = "selected";
					session.putValue("SEL_VEND_NAME",tempVendorsRetObj.getFieldValueString(tu,"EU_FIRST_NAME"));	
  				}
%>			
				<Option value="<%=tempVendorsRetObj.getFieldValueString(tu,"EU_ID").trim()%>" <%=ven_Selected%>><%=tempVendorsRetObj.getFieldValueString(tu,"EU_FIRST_NAME")+"["+tempVendorsRetObj.getFieldValueString(tu,"EU_ID")+"]"%></Option>
<%
			}
		}
%>
			</Select>
		</Td>	
<%
	}
%>
		
 		
		<Td  <%=clickString%> onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true" style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;align:center' width='5%' align=right>
			<Img src="../../../../EzCommon/Images/Body/arrowright.png" style="cursor:hand" border="none" <%=clickString%> onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true">&nbsp;
		</Td>
	</Tr>

	</Table>
<Br>
