<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ page import="ezc.ezutil.*,java.util.*,java.text.*" %>
<%@include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@include file="../../../Includes/Jsps/Request/iAuctionHistoryByAuctionId.jsp" %>
<html>
<head>
<script>
	var tabHeadWidth=95
	var tabHeight="30%"
	
</script>
<Script>
function showItems(obj)
{

	openImg = new Image();
	openImg.src = "../../Images/Others/tree-select.gif";

	closeImg = new Image();
	closeImg.src = "../../Images/Others/tree-closed.gif";

	var spanObj = document.getElementById("span"+obj)
	imgobj	=document.getElementById("IMG"+obj);
	if(spanObj.style.visibility=="hidden")
	{
		spanObj.style.visibility="visible"
		spanObj.style.display=""
		imgobj.src = openImg.src;
	}
	else
	{
		spanObj.style.visibility="hidden"
		spanObj.style.display="none"
		imgobj.src = closeImg.src;
	}
}
function funShow(opt)
{
	//if(opt == 1)
	//{
		//document.getElementById("div1").style.visibility="visible"
		//document.getElementById("div2").style.visibility="hidden"
		//document.getElementById("buttons1").style.visibility="visible"
		//document.getElementById("buttons2").style.visibility="hidden"
		//document.getElementById("history").style.visibility="visible"
		//document.getElementById("rank").style.visibility="hidden"
	//}
	if(opt == 2)
	{
		//document.getElementById("div1").style.visibility="hidden"
		document.getElementById("div2").style.visibility="visible"
		//document.getElementById("buttons1").style.visibility="hidden"
		//document.getElementById("buttons2").style.visibility="visible"
		//document.getElementById("history").style.visibility="hidden"
		document.getElementById("rank").style.visibility="visible"
	}
}
function ezBackCall()
	{
				history.go(-1);
				return false;
	}
function mySelect()
{

	if(document.myForm.auctionId.selectedIndex==0)
	{
		alert("Please Select Auction")
		document.myForm.auctionId.focus()
	}
	else
	{	
		document.myForm.action	= "ezAuctionHistoryByAuctionId.jsp"
		document.myForm.submit();
	}
}
function displayPrice(supplierId,auctionCounter,currency)
{
	
	var browser=navigator.appName;	

	if(browser=="Microsoft Internet Explorer")
	var retValue = window.showModalDialog("ezViewPrices.jsp?supplierId="+supplierId+"&currency="+currency+"&auctionCounter="+auctionCounter+"&auctionId="+'<%=auctionId%>'+"&target=price",window.self,"center=yes;dialogHeight=25;dialogWidth=40;help=no;resizable=no;titlebar=no;status=no;minimize:yes")	
	else 
	{
	var retValue = window.showModalDialog("ezViewPrices.jsp?supplierId="+supplierId+"&currency="+currency+"&auctionCounter="+auctionCounter+"&auctionId="+'<%=auctionId%>'+"&target=price",window.self,"center=yes;dialogHeight=350;dialogWidth=600;help=no;resizable=no;titlebar=no;status=no;minimize:yes")	
	}

}
function funSelect()
{
	for(var i=0;i<document.myForm.auctionId.length;i++)
	{
		if(document.myForm.auctionId.options[i].value=='<%=auctionId%>')
		{
			document.myForm.auctionId.selectedIndex = i
		}
	   }
}
</script>

<Script src="../../Library/JavaScript/ezTabScroll.js"></Script>
</head>
<body  scroll=no <%=bodyLoadString%>  onResize="scrollInit()">
<%@ include file="../Misc/ezDisplayHeader.jsp" %>
<form name="myForm">
<%
if(retCount>0)
{
%>			
	<Div id='inputDiv' style='position:relative;align:center;top:1%;width:100%;height:15%'>
	<Table width="35%" border="0" cellspacing="0" cellpadding="0" align=center valign=center>
	<Tr>
		<Td height="5" style="background-color:'F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"></Td>
		<Td height="5" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"><img width="1" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"></Td>
		<Td height="5" style="background-color:'F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"></Td>
	</Tr>
	<Tr >
		<Td width="5" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"><img width="5" height="1" src="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"></Td>
		<Td style="background-color:'F3F3F3'" valign=middle>
		<Table border="0" align="center" valign=middle width="100%" cellpadding=1 cellspacing=1 class=welcomecell>
		<Tr>
		<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold' width='50%' align=center>
			Select Auction&nbsp;:&nbsp;
		</Td>
		<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold' width='50%' align=left>
		<select name="auctionId" onChange="mySelect()" id = "listBoxDiv" style="width:70%;border: 1px solid">
			<option value="¥">--Select--</option>
<%
			String auctId = "";
			String selected = "";
			for(int i=0;i<retCount;i++)
			{
				auctId = ret.getFieldValueString(i,"AUCTION_ID").trim();
				if(auctId.equals(auctionId) || auctId==auctionId)
					selected = "selected";
				else
					selected = "";
%>
					<option value="<%=auctId%>" <%=selected%>><%=ret.getFieldValueString(i,"AUCTION_NAME")%></option>
<%					
			}
%>
		</select>
		</Td>
		</TR>
		</Table>
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

<%
	
	if(auctionId!=null && !auctionId.equals("¥"))
	{	
	   	if(retAuctionHistory.getRowCount()>0)
	   	{	
			
			

		String supplierName = "",supplierdata = "",lowSupplier="";
		if(retAuctionHistory.getRowCount()>0 && auctionItems.getRowCount()>0)
		{
	%>	

			<Div id="theads">
			<Table id="tabHead" width="95%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0>
			<tr>
				<th  width = "10%">&nbsp;</th>
				<th  width = "10%">PR No.</th>
				<th  width = "10%">PR Item</th>
				<th  width = "60%">Material</th>
				<th  width = "10%">UOM</th>
			</tr>
			</table>
			</Div>
			<Div id="InnerBox1Div" style="overflow:auto;position:absolute;width:95%;height:75%;">
			<Table id="InnerBox1Tab" width="100%" align=center borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 border=1>
	<%
			//out.println("supplierCodesupplierCode	"+supplierCode);
			//out.println("auctionItems>>	"+auctionItems.toEzcString());
			//out.println("retAuctionHistory		"+retAuctionHistory.toEzcString());
			int supCount = 0;
			for(int j=0;j<auctionItems.getRowCount();j++)
			{

				String drlPRNumAu = "",drlPRItemAu="";
				
				if(auctionItems.getFieldValueString(j,"EXT1")!=null && !"null".equals(auctionItems.getFieldValueString(j,"EXT1").trim()))
					drlPRNumAu = auctionItems.getFieldValueString(j,"EXT1");
					
				if(auctionItems.getFieldValueString(j,"EXT2")!=null && !"null".equals(auctionItems.getFieldValueString(j,"EXT2").trim()))
					drlPRItemAu = auctionItems.getFieldValueString(j,"EXT2");
					
				String matNum = auctionItems.getFieldValueString(j,"ITEM_CODE").trim();
	%>
				<table align=center  width="100%" border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0 >
				<tr>
					<td width="10%" align=center><a href="javascript:showItems('<%=matNum%>')"><img border=0 id="IMG<%=matNum%>"  src="../../Images/Others/tree-closed.gif"></a></td>
					<td width="10%" align='center'>&nbsp;<%=drlPRNumAu%></td>				
					<td width="10%" align='center'>&nbsp;<%=drlPRItemAu%></td>
					<td width="60%"><%=matNum%>&nbsp;</td>
					<td width="10%"><%=matUOMTable.get(matNum)%>&nbsp;</td>
				</tr>
				</table>
				<span id="span<%=matNum%>"  style="visibility:hidden;display:none">
				<table align=center width="100%" border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0 >

				<tr>
					<th  width = "35%">Supplier Name</th>
					<th  width = "20%">Bid Time</th>
					<th  width = "10%">Quantity</th>
					<th  width = "15%">Price</th>
					<th  width = "15%">Value</th>
					<th  width = "5%">Rank</th>
				</tr>

	<%							
				supplierName = "";supplierdata = "";lowSupplier="";
				//java.math.BigDecimal matPrice = null;
				Enumeration suppIds  = bidSummary.keys();
				int i = 0;
				String suId  ="",timeStamp ="",bidValue = "",sid = "";
				String[] supKey = new String[4];
				String[] matKeys = new String[2];
				while(suppIds.hasMoreElements())
				{
					String tempVal = "",matStr="",matPrice="",matRank="",matValue="";

					suId 		 = (String)suppIds.nextElement();
					supplierdata 	 = (String)bidSummary.get(suId);
					try
					{
						supKey = supplierdata.split("##");
						supplierName   =  supKey[0];
						timeStamp      =  supKey[1];
						bidValue       =  supKey[2];
						sid            =  supKey[3];
						lowSupplier= suId;


						if(supplierName==null || "null".equals(supplierName.trim()))
							supplierName = suId;

						matStr 	 = (String)finalMatValueTable.get(sid+matNum);					

						if(matStr!=null)
						{	
							try
							{
								matKeys = matStr.split("#");
								matValue = new java.math.BigDecimal(matKeys[0])+"";
								matRank  = matKeys[1];
								matPrice = ((new java.math.BigDecimal(matKeys[0])).divide(new java.math.BigDecimal(auctionItems.getFieldValueString(j,"QUANTITY")),java.math.BigDecimal.ROUND_HALF_UP)).setScale(2, java.math.BigDecimal.ROUND_HALF_UP)+"";
							}catch(Exception e){}
						}


					}
					catch(Exception e2)
					{
						out.println(e2);
						ezc.ezcommon.EzLog4j.log("Exception Ocuured Getting Lowest Bid","I");
					}	

	%>	
						<tr>

						<td width="35%">&nbsp;<%=supplierName%></td>
						<td width="20%">&nbsp;<%=timeStamp%></td>
						<td width="10%">&nbsp;<%=auctionItems.getFieldValueString(j,"QUANTITY")%></td>
	<%				
						if("3".equals(userType))
						{

							if(supplierIndex.equals(sid.trim()))
							{

	%>	
							<td width="15%" align=right>&nbsp;<input type=text class='tx' name='text_p_<%=matNum%>_<%=sid%>' value='<%=matPrice%>' style="text-align:right" readonly></td>
							<td width="15%" align=right>&nbsp;<input type=text class='tx' name='text_v_<%=matNum%>_<%=sid%>' value='<%=matValue%>' style="text-align:right" readonly></td>
							<td width="5%" align=right>&nbsp;<input type=text class='tx' name='text_r_<%=matNum%>_<%=sid%>' value='<%=matRank%>' style="text-align:right" readonly></td>

	<%

							}
							else
							{

	%>					
							<td width="15%" align=right>&nbsp;<input type=hidden class='tx' name='text_p_<%=matNum%>_<%=sid%>' value='<%=matPrice%>' style="text-align:right" readonly></td>
							<td width="15%" align=right>&nbsp;<input type=hidden class='tx' name='text_v_<%=matNum%>_<%=sid%>' value='<%=matValue%>' style="text-align:right" readonly></td>
							<td width="5%" align=right>&nbsp;<input type=text class='tx' name='text_r_<%=matNum%>_<%=sid%>' value='<%=matRank%>' style="text-align:right" readonly></td>


	<%
							}
						}
						else
						{
	%>			
							<td width="15%" align=right>&nbsp;<input type=text class='tx' name='text_p_<%=matNum%>_<%=sid%>' value='<%=matPrice%>' style="text-align:right" readonly></td>
							<td width="15%" align=right>&nbsp;<input type=text class='tx' name='text_v_<%=matNum%>_<%=sid%>' value='<%=matValue%>' style="text-align:right" readonly></td>
							<td width="5%" align=right>&nbsp;<input type=text class='tx' name='text_r_<%=matNum%>_<%=sid%>' value='<%=matRank%>' style="text-align:right" readonly></td>

	<%	
						}
	%>			

						</tr>

	<%
				supCount++;
				i++;

			}

			if(supCount == 0)
			{
	%>	
				<script>
					document.getElementById("IMG<%=matNum%>").style.visibility='hidden'
				</script>
	<%
			}
	%>
			</span>
			</table>
	<%
		}
	%>
		</TD></TR>
		</Table>
		</Div>
	<%			
		}	

		}
		else
		{
			noDataStatement="No Biddings available for this Auction";
%>
			<%@ include file="../Misc/ezDisplayNoData.jsp" %>
<%
		}
	}
}
else
{

		
		noDataStatement="There are no auctions to list to view History";
		
%>
	<%@ include file="../Misc/ezDisplayNoData.jsp" %>
	<div id="buttonDiv" align=center style="position:absolute;width:92%;top:90%;left:5%">
	
<%
	buttonName = new ArrayList();
	buttonMethod = new ArrayList();

	buttonName.add("Back");
	buttonMethod.add("ezBackCall()");

	out.println(getButtonStr(buttonName,buttonMethod));
%>
	</div>
<%
}
%>
<Div id="MenuSol"></Div>
</form>
</body>
</html>
