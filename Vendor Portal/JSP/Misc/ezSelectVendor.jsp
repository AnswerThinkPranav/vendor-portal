  <link rel="stylesheet" type="text/css" href="../../Library/jquery/jquery-ui-1.12.1.custom/jquery-ui.css">
  <%
  	String menuItem = request.getParameter("menuItem");
  	String v_BuyerSelVendor = request.getParameter("buyerSelVendor");
  	//out.println(":::v_BuyerSelVendor::::"+v_BuyerSelVendor);
  	if("INV".equals(menuItem) && v_BuyerSelVendor==null)
  	{
  		if(vendorsRetObjCnt>0)
  			v_BuyerSelVendor = vendorsRetObj.getFieldValueString(0,"EC_ERP_CUST_NO");
  			
  	}	
  		
  %>
  <Br>
  	<Table border="1" align="center" valign=middle width="50%" cellpadding=0 cellspacing=0 class=welcomecell>
  	<Tr> 		
   <%
   	if("2".equals(userType))
   	{
   		//out.println(vendorsRetObj.toEzcString());
  %>		
  		<Th <%=trBGColor%>>
  			&nbsp;&nbsp;&nbsp;&nbsp;Vendor&nbsp;&nbsp;
  		</Th>
  		<Td>
  			<Select name="buyerSelVendor">
  <%
  		if("RFQ".equals(menuItem) || "ASN".equals(menuItem) || "PO".equals(menuItem))
  		{
  %>
  			<Option value="ALL">--ALL--</Option>
  			<!--<Option value="Select Vendor">---Please Select Vendor---</Option>-->
  <%
  		}else{
  			if(vendorsRetObjCnt>0)
  				session.putValue("SEL_VEND_NAME",vendorsRetObj.getFieldValueString(0,"ECA_NAME"));
  		}
  		String ven_Selected = "";
  		if("RFQ".equals(menuItem) || "ASN".equals(menuItem) || "PO".equals(menuItem))
  		{
			for(int ve=0;ve<vendorsRetObjCnt;ve++)
			{
				ven_Selected = "";
				if(vendorsRetObj.getFieldValueString(ve,"EC_ERP_CUST_NO").equals(v_BuyerSelVendor))
				{
					ven_Selected = "selected";
					session.putValue("SEL_VEND_NAME",vendorsRetObj.getFieldValueString(ve,"ECA_NAME"));
				}	
  %>			
  				<Option value="<%=vendorsRetObj.getFieldValueString(ve,"EC_ERP_CUST_NO").trim()%>" <%=ven_Selected%>><%=vendorsRetObj.getFieldValueString(ve,"ECA_NAME")+"["+vendorsRetObj.getFieldValueString(ve,"EC_ERP_CUST_NO")+"]"%></Option>
  <%
  			}
  		}
  		if("INV".equals(menuItem))
  		{
  			for(int ven=0;ven<vendorsRetObjCnt;ven++)
  			{
  				String venCode=vendorsRetObj.getFieldValueString(ven,"EC_ERP_CUST_NO");
  				venCode=venCode.substring(4,venCode.length());
  				ven_Selected = "";
  				if(vendorsRetObj.getFieldValueString(ven,"EC_ERP_CUST_NO").equals(v_BuyerSelVendor))
				{
					ven_Selected = "selected";
					session.putValue("SEL_VEND_NAME",vendorsRetObj.getFieldValueString(ven,"ECA_NAME"));
  				}
  %>
  				<Option value="<%=vendorsRetObj.getFieldValueString(ven,"EC_ERP_CUST_NO").trim()%>" <%=ven_Selected%>><%=venCode+"["+vendorsRetObj.getFieldValueString(ven,"ECA_NAME")+"]"%></Option>
 <%
  			}
  		}
  		if("RFQ".equals(menuItem))
  		{
  			for(int tu=0;tu<tempVendorsRetObjCnt;tu++)
  			{
  				ven_Selected = "";
  				if(tempVendorsRetObj.getFieldValueString(tu,"EU_ID").equals(v_BuyerSelVendor))
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
