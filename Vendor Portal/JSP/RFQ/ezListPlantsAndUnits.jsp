
<%--*************************************************************************************

       /* Copyright Notice ===================================================
	* This file contains proprietary information of The Hackett Group Ind Ltd.
	* Copying or reproduction without prior written approval is prohibited.
	* Copyright (c) 2005-2006 =====================================*/
		Author: Ramesh.S
		Team:   EzcSuite
		Date:   12/09/2005
*****************************************************************************************--%>
<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@ include file="../../../Includes/Jsps/Rfq/iListPlantsAndUnits.jsp" %>

<html>
<head>
<Script>
	var tabHeadWidth=70
	var tabHeight="50%"
</Script>
<Script>
var ind = '<%=selIndex%>';
function submitPlantAndUnit()
{
	var chk1Len = document.myForm.chk1.length
	var chk2Len = document.myForm.chk2.length
	opener.window.document.myForm.plant.value = "";
		
	var indx1 =0;		
	if(!isNaN(chk1Len))
	{
		for(var i=0;i<chk1Len;i++)
		{
			if(document.myForm.chk1[i].checked)
			{
				indx1=i;
				opener.window.document.myForm.plant[ind].value = document.myForm.chk1[indx1].value;
				break;
			}	
		}
		//opener.window.document.myForm.plant.value = document.myForm.chk1[indx1].value;
	}
	else
	{
		opener.window.document.myForm.plant[ind].value = document.myForm.chk1.value;
	}
	//opener.window.document.myForm.plant.readOnly = true;

	
	var indx2 =0;		

	if(!isNaN(chk2Len))
	{
		for(var i=0;i<chk2Len;i++)
		{
			if(document.myForm.chk2[i].checked)
			{
				indx2=i;
				break;
			}	
		}
		opener.window.document.myForm.uom[ind].value = document.myForm.chk2[indx2].value;
	}
	else
	{
		opener.window.document.myForm.uom[ind].value = document.myForm.chk2.value;
	}
	//opener.window.document.myForm.uom.readOnly = true;		
	window.close();
}
</Script>

<Script src="../../Library/JavaScript/Misc/ezTabScroll.js"></Script>
</head>
<body scroll="no" onLoad='scrollInit(10)' onResize='scrollInit(10)'>
<form name="myForm" method="post">

<%
	if(plantsCount==0)
	{
%>
		<br><br>
		<Div id="theads" style="position:absolute;top:10%;visibility:visible;width:100%";left:2%">
			<Table id="tabHead" width="70%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
			<Tr align="center" valign="middle">
				<Th width="100%">There are no Plants to display</Th>	 	
			 </Tr>
			</Table>
		</Div>
<%
	}
	else
	{
%>
		<br><br>
		<Div>
		<Table id="tabHead" border=1 align='center' borderColorDark="#ffffff" borderColorLight="#000000" cellPadding=2 cellSpacing=0  width="70%">
			<tr align="center" valign="middle">
				<th width="50%">Plants for Material</th>
			</tr>
		</table>
		</Div>
		<Div id="theads">
			<Table id="tabHead" width="70%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
			<Tr align="center" valign="middle">
				<Th width="10%">&nbsp;</Th>
				<Th width="45%">Plant</Th>	 	
			 </Tr>
			</Table>
		</Div>

		<Div id="InnerBox1Div" style="overflow:auto;position:absolute;width:70%;height:60%;left:2%">
		<Table id="InnerBox1Tab" width="100%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
<%
		for(int i=0;i<plantsCount;i++)
		{
%>
			<Tr>
				<Td width="10%"><Input type=radio name=chk1 value="<%=Plants.getFieldValueString(i,"PLANTS")%>"></Td>
				<Td width="45%"><%=Plants.getFieldValueString(i,"PLANTS")%></Td>
			</Tr>
<%
		}
%>
		</Table>
		</Div>
<%
	}
%>	
<%
	if(uomCount==0)
	{
%>
		<Div id="theads1" style="position:absolute;top:50%;visibility:visible;width:100%";left:2%">
			<Table id="tabHead" width="70%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
			<Tr align="center" valign="middle">
				<Th width="100%">There are no units for this Material</Th>	 	
			 </Tr>
			</Table>
		</Div>
<%	}
	String uomValue="";
	if(Uoms!= null)
		uomValue = Uoms.getFieldValueString(0,"UOMS");
%>
	<input type=hidden name=chk2 value="<%=uomValue%>">
	
	
	<Div id="buttonDiv" align=center style="position:absolute;top:89%;visibility:visible;width:100%">
		<Table>
			<Tr>
				<Td class=blankcell>				
					<span id="EzButtonsSpan" >
<%				
				buttonName = new java.util.ArrayList();
				buttonMethod = new java.util.ArrayList();
				if(uomCount==0 || plantsCount==0)
				{
					buttonName.add("Back");
					buttonMethod.add("history.go(-1)");
				}
				else
				{
					buttonName.add("OK");
					buttonMethod.add("submitPlantAndUnit()");
				}
				out.println(getButtonStr(buttonName,buttonMethod));				
%>
					</span>
					<span id="EzButtonsMsgSpan" style="display:none">
						<Table align=center>
							<Tr>
								<Td class="labelcell">Your request is being processed... Please wait</Td>
							</Tr>
						</Table>
					</span>
				</Td>
			</Tr>
		</Table>
	</Div>	
</form>
<Div id="MenuSol"></Div>
</body>
</Html>