<%//@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ page import = "ezc.ezparam.*" %>
<%@include file="../../../Includes/Lib/AddButtonDir.jsp"%>
<%@include file="../../../Includes/JSPs/Rfq/iVendorSelection.jsp"%>
<%@page import="ezc.ezutil.*,java.util.*,java.util.Iterator,java.math.*,ezc.ezcommon.*"%>

<Html>
<Head>
<base target="_self">
<Title>Vendor Selection-- Powered By The Hackett Group</Title>
<Script>
	var tabHeadWidth=92
	var tabHeight="25%"
	if(screen.width==800)
	{
		tabHeight="57%";
	}
</Script>
 <Script src="../../Library/JavaScript/ezTabScroll.js"></Script>
 <Script>
 function selectedVendor()
{
	var RFQVal	= "";
		
	var itemSize = "<%=itemSize%>";
	for(j=0;j<itemSize;j++)
	{
		var matNo ="";
		
		if(itemSize==1)
			RFQItems = document.myForm.selRFQItemNo.value
		else
			RFQItems = document.myForm.selRFQItemNo[j].value
		

		var radioObj = eval("document.myForm.vSelection_"+RFQItems);
		
		var count=0;
		
		if(isNaN(radioObj.length))
		{
			resonsFName = (radioObj.value).split('¥')[0]+(radioObj.value).split('¥')[1];
			if(radioObj.checked==false)
			{
				alert("Select Vendor for Item -->"+parseFloat(RFQItems));
				return false;
			}
			else
			{
				if(eval("document.myForm.Resons"+resonsFName).value=="")
				{
					alert("Select reason for Item -->"+parseFloat(RFQItems)+" and Vendor -->"+(eval("document.myForm.VenName"+radioObj.value).value));
					return false;
				}
			}
		}else{
			for(i=0;i<radioObj.length;i++)
			{
				resonsFName = (radioObj[i].value).split('¥')[0]+(radioObj[i].value).split('¥')[1];
				if(radioObj[i].checked==true)
				{
					if(eval("document.myForm.Resons"+resonsFName).value=="")
					{
						alert("Select reason for Item -->"+parseFloat(RFQItems)+" and Vendor -->"+(eval("document.myForm.VenName"+radioObj[i].value).value));
						return false;
					}
					count = count+1;
				}
			}	
			if(count==0)
			{
				alert("Select Vendor for Item --"+parseFloat(RFQItems));
				return false;
			}
		}
		
							
	}
		
	var confStstatus=confirm("Do you want to submit");
	if (confStstatus)
	{
		document.getElementById("ButtonsDiv").innerHTML="<Table border=0 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 ><Tr><Th>Please wait .Your Request is being Processed ...</Th></Tr></Table>"
		document.myForm.action="ezSaveVenSelection.jsp";
		document.myForm.submit();
		document.myForm.target = "_self";
	}
}
function CloseWindow()
{
	window.returnValue="Cancel";
	window.close();
}
</Script>	
</Head>
<Body onLoad="scrollInit()" onResize="scrollInit()" scroll=auto>
<Form name="myForm" method="POST">
<Input type="hidden" name="cRFQNo" value="<%=qcfNo%>">
<%
java.util.ArrayList RFQNums = new java.util.ArrayList();
Hashtable vendHT = (Hashtable)session.getValue("VENDORHT");
if(noOfQcfRFQItems>0)
{
	String disabled="";
	String readonly="";
	if("VIEW".equals(flag.trim()))
	{
		disabled="disabled";
		readonly="readonly";
	}	
%>
<Div align=center border=1 style="position:absolute;top:5%;width:100%;height:75%;overflow:auto;">    

<%
	//for(int l=0;l<itemSize;l++)
	//{ 	
		java.util.Vector itemMatNo = new java.util.Vector();

		for(int i=0;i<noOfQcfRFQItems;i++)
		{
			String rfqsStr = (String)qcfRfqItemsList.get(i);
			
			String qcfRFQNo = rfqsStr.split("¥")[0];
			String itemNo = rfqsStr.split("¥")[1];
			String matNo = rfqsStr.split("¥")[2];
			
			
			String matNoInt = "";
			
			if(!itemMatNo.contains(itemNo+matNo))
				itemMatNo.add(itemNo+matNo);
			else
				continue;
				

			try
			{
				matNoInt = Integer.parseInt(matNo)+"";
			}catch(Exception e){matNoInt=matNo;}


	%>
			<br>
			<Table width="90%" align="center" border=0 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=1 >
				<Tr>
					<Th align="center"><font color='#2E8B57'>Material  :  <%=matNoInt%></font>&nbsp;&nbsp;&nbsp;&nbsp;<font color='#8B0000'><b>RFQ Item No. : <%=itemNo%></b></font></Th>
					<Input type="hidden" name="matNo" value="<%=matNo%>">
					<Input type="hidden" name="selRFQItemNo" value="<%=itemNo%>">
				</Tr>  
			</Table>
			<Table id="tabHead" width="90%" align=center class=tableClass border=0 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=1 >
				<Tr>
					<Th width="7%" align="center">Select</Th>
					<Th width="10%"align="center">Vendor</Th>
					<Th width="30%"align="center">Vendor Name</Th>
					<Th width="10%" align="center">Value</Th>
					<Th width="20%" align="center">Reason</Th>
					<Th width="23%" align="center">Remarks</Th>

				</Tr>
			</Table>
	<%
			for(int j=0;j<retRfqRanks.getRowCount();j++)
			{
				String checked="";
				String matListNo= retRfqRanks.getFieldValueString(j,"MATERIAL");
				String rfqItem_D = retRfqRanks.getFieldValueString(j,"RFQ_ITEM");
				if(matNo.equals(matListNo) && itemNo.equals(rfqItem_D))
				{
					String rfqNum_D = retRfqRanks.getFieldValueString(j,"RFQ_NUM");
					String compCode_D = retRfqRanks.getFieldValueString(j,"CO_CODE");
					String rfqValue_D = retRfqRanks.getFieldValueString(j,"RFQ_VALUE");
					String rank_D = retRfqRanks.getFieldValueString(j,"RANK");
					String vCode_D = retRfqRanks.getFieldValueString(j,"VENDOR_CODE");
					String vName_D = (String)vendHT.get(vCode_D);

					BigDecimal bigDecVal = null;
					try
					{
						bigDecVal	= new BigDecimal(rfqValue_D);
						rfqValue_D	= bigDecVal.setScale(2,BigDecimal.ROUND_HALF_UP).toString();
					}catch(Exception e){ezc.ezcommon.EzLog4j.log(":::::::Error occured while converting bigDecimal to String::::::::","I");}


					if(!RFQNums.contains(rfqNum_D))
					{
						RFQNums.add(rfqNum_D);
	%>
					<Input type="hidden" name="RFQs" value="<%=rfqNum_D%>">
	<%
					}
					int index = -1;
					String tempKey = "",Sel="";
					String dbReas  = "",dbQuotComment="",dbIsRej="";
					try
					{
						tempKey=Integer.parseInt(rfqNum_D)+""+Integer.parseInt(rfqItem_D);
					}catch(Exception e){tempKey=rfqNum_D+rfqItem_D;}
					if(retRFQDetails!=null)
					{

						index = retRFQDetails.getRowId("KEY",tempKey);
						if(index>=0)
						{

							dbReas		= retRFQDetails.getFieldValueString(index,"ERD_REASONS");

							dbIsRej		= retRFQDetails.getFieldValueString(index,"ERD_REJ_INDICATOR");
							dbQuotComment	= retRFQDetails.getFieldValueString(index,"ERD_QUOT_CMMT_TEXT");
							if(dbQuotComment==null || dbQuotComment.equals("null"))dbQuotComment="";
							if(dbReas==null || dbReas.equals("null"))dbReas="";
						}

					}


					 if("N".equals(dbIsRej))	
						checked = "checked"; 
						
					if("SEL".equals(flag.trim()))	rank_D = "L"+rank_D;

	%>
					<Input type="hidden" name="RFQNos" value="<%=rfqNum_D%>">
					<Input type="hidden" name="RFQItems" value="<%=rfqItem_D%>">
					<Table width="90%" align=center border=0 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=1 >
					<Tr>
						<Input type="hidden" name="rank<%=rfqNum_D+rfqItem_D%>" value="<%=rank_D%>">
						<Input type="hidden" name="value<%=rfqNum_D+rfqItem_D%>" value="<%=rfqValue_D%>">
						<Td width="7%" align="center"><Input type="radio" value="<%=rfqNum_D+"¥"+rfqItem_D%>" <%=checked%> name="vSelection_<%=rfqItem_D%>" <%=disabled%>>&nbsp;<%=rank_D%></Td>
						<Td width="10%" align="center"><%=vCode_D%></Td>
						<Td width="30%" align="left"><Input type=text class=tx value="<%=vName_D%>" name="VenName<%=rfqNum_D+"¥"+rfqItem_D%>" size=50 readonly style="width:100%;"></Td>
						<Td width="10%" align="center"><%=rfqValue_D%></Td>
						<Td width="20%" align="center">

							<Select class="inpubox" style="width:100%" name="Resons<%=rfqNum_D+rfqItem_D%>" id="reasons" <%=disabled%>>
							<Option value="">Select Reason</Option>
	<%
							int reasonsCount=retRfqReasons.getRowCount();
								if(reasonsCount>0)
								{
									for(int k=0;k<reasonsCount;k++)
									{

										String rKey 	= retRfqReasons.getFieldValueString(k,"REASONS_KEY");
										String rValue 	= retRfqReasons.getFieldValueString(k,"REASONS_VALUE");
										out.println("rKey*******"+rKey);

										if(rKey==null || "null".equals(rKey.trim()) || "".equals(rKey.trim()))rKey="";
										if(rValue==null || "null".equals(rValue.trim()) || "".equals(rValue.trim()))rValue="";									

										if(rKey.equals(dbReas))Sel="Selected";

										if(!"".equals(rKey) && !"".equals(rValue))
										{
	%>										
										<Option value="<%=rKey%>" <%=Sel%>><%=rKey%>--><%=rValue%></Option>
	<%
										}
										Sel="";

									}
								}
	%>
							</Select>
							</Td>

<%
						if("SEL".equals(flag.trim()))
						{
%>
						<Td width="23%" align="center">
						<Input type="text" name="comments<%=rfqNum_D+rfqItem_D%>" style="width:100%" maxlength="120" id="comments" value="<%=dbQuotComment%>" <%=readonly%>>
						</Td>
<%
						}else{
%>
						<Td width="23%" align="left"><%=dbQuotComment%></Td>
<%
						}
%>						
					</Tr> 

					</Table>
	<%
				}
			}
		}
	//}
%>

</div>	
<%
}
%>
<br>    
<Div id="ButtonsDiv" align=center style="position:absolute;visibility:visible;top:90%;width:100%;">    

<%
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();
	if("VIEW".equals(flag.trim()))
	{
		buttonName.add("Ok");
		buttonMethod.add("CloseWindow()");	
	}
	else
	{
		buttonName.add("Submit");
		buttonMethod.add("selectedVendor()");

		buttonName.add("Cancel");
		buttonMethod.add("CloseWindow()");
	}
	out.println(getButtonStr(buttonName,buttonMethod));
%>
</Div>

</Form>
</Body>
</Html>