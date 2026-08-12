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
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"/>
<%
	String matNo[] 		= request.getParameterValues("matNo");
	String matDesc[]	= request.getParameterValues("matDesc");
	String uom[] 	  	= request.getParameterValues("uom");
	String plant[]    	= request.getParameterValues("plant");
	String matQty[]   	= request.getParameterValues("matqty");
	String delvDate		= "";
	String purGrp  	   	= (String)Session.getUserPreference("PURGROUP");
	
	//out.println("matNomatNomatNomatNo>>"+matNo.length);
	
	ezc.ezparam.ReturnObjFromRetrieve myRetTemp = new ezc.ezparam.ReturnObjFromRetrieve(new String[]{"Material","Plant","NetQty","UOM","DeliveryDate","PurGrp"});
	java.util.Vector plantVect= new java.util.Vector();
	
	String retMessage ="";
	String delMat = "",tempMat="",budPriceVal ="";
	int vectSize = 0;
	int myRetTempCount = 0;
	
	try{
		//String strTemp[] 	= request.getParameterValues("chk1");
		//String delMat = "",tempMat="",budPriceVal ="";
		//ezc.ezparam.ReturnObjFromRetrieve myRetTemp = new ezc.ezparam.ReturnObjFromRetrieve(new String[]{"Material","Plant","NetQty","UOM","DeliveryDate","BudgetPrice","Currency","ValutionType","PurGrp"});
		//boolean budPriceFlag= false;
		for(int i=0;i<matNo.length;i++)
		{
			//ezc.ezbasicutil.EzStringTokenizer EzToken = new ezc.ezbasicutil.EzStringTokenizer(strTemp[i],"$$");
			//java.util.Vector Tokens = EzToken.getTokens();	
			//tempMat = (String)Tokens.elementAt(0);
			tempMat  = matNo[i];
			delvDate = request.getParameter("delvdate"+i);
			if(tempMat!=null && tempMat!=null && !"".equals(tempMat)){
				myRetTemp.setFieldValue("Material",tempMat);
				myRetTemp.setFieldValue("Plant",plant[i]);
				myRetTemp.setFieldValue("NetQty",matQty[i]);
				myRetTemp.setFieldValue("UOM",uom[i]);
				myRetTemp.setFieldValue("DeliveryDate",delvDate);
				//myRetTemp.setFieldValue("DeliveryDate","02/20/2007");
				myRetTemp.setFieldValue("PurGrp",purGrp);

				if(!plantVect.contains(plant[i]))
					plantVect.add(plant[i]);

				myRetTemp.addRow();
			}
		}
		myRetTemp.toEzcString();
		vectSize = plantVect.size();
		for(int k=0;k<vectSize;k++)
		{
			ezc.ezparam.ReturnObjFromRetrieve myRet = null;
			ezc.ezpreprocurement.client.EzPreProcurementManager ezpreprocurementmanager=new ezc.ezpreprocurement.client.EzPreProcurementManager();
			
			ezc.ezparam.EzcParams mainParams=new ezc.ezparam.EzcParams(true);
			ezc.ezpreprocurement.params.EziPRTable  	prTable		= new ezc.ezpreprocurement.params.EziPRTable();
			ezc.ezpreprocurement.params.EziPRTableRow  	prTableRow	= null;
			
			String plantStr =  (String)plantVect.get(k);
			myRetTempCount = myRetTemp.getRowCount();
			System.out.println("CHKKKKmyRetTempCount>"+myRetTempCount);
			
			for(int l=0;l<myRetTempCount;l++){
				if(plantStr.equals(myRetTemp.getFieldValueString(l,"Plant"))){
					prTableRow     =  new ezc.ezpreprocurement.params.EziPRTableRow();
					prTableRow.setItemNo((l+1)+"");
					prTableRow.setDocType("NB");
					prTableRow.setMaterial(myRetTemp.getFieldValueString(l,"Material"));		//"000000000050000101";
					prTableRow.setPlant(plantStr);							//"3010";
					prTableRow.setQuantity(myRetTemp.getFieldValueString(l,"NetQty"));		//"100";
					prTableRow.setUOM(myRetTemp.getFieldValueString(l,"UOM"));			//"KG";
					prTableRow.setDelivDate(myRetTemp.getFieldValueString(l,"DeliveryDate"));	//"30.09.2005";
					prTableRow.setPurGroup(myRetTemp.getFieldValueString(l,"PurGrp"));	
					
					prTable.appendRow(prTableRow);
				}
			}	
			mainParams.setObject(prTable);
			Session.prepareParams(mainParams);
			try
			{
				System.out.println("PR CREATION CALL STARTS TO CHECK");
				myRet=(ezc.ezparam.ReturnObjFromRetrieve)ezpreprocurementmanager.ezCreatePR(mainParams);
				System.out.println("PR CREATION CALL ENDS TO CHECK");
			}
			catch(Exception e)
			{
				System.out.println("Exception Occured in ezCreatePR.jsp"+e.getMessage());
			}
			int myRetCount = 0;
			try{
				if(myRet!=null){
					myRetCount = myRet.getRowCount();
					if(myRetCount>0){
						if(myRetCount>0 && !"E".equals(myRet.getFieldValueString("TYPE")))
							//retMessage += (k+1)+" .Purchase Requisition Created Successfully with No : <a href=javascript:openFile('"+myRet.getFieldValueString("PR_NUM")+"') window.status=''>"+myRet.getFieldValueString("PR_NUM")+"</a> for Plant <font color='#FFCC00' >"+ plantStr+" </font><br>";		
							retMessage += (k+1)+".&nbsp; Purchase Requisition Created Successfully with No :&nbsp;&nbsp;"+myRet.getFieldValueString("PR_NUM")+" for Plant "+ plantStr+" </font><br>";		
						else
							retMessage += (k+1)+".&nbsp;<font color='EE3325'>Error:</font>&nbsp;&nbsp;"+myRet.getFieldValueString("MESSAGE")+" for Plant "+plantStr+"<br>";					
					}		
				}		
			}catch(Exception e){}		
		}
	}catch(Exception e){ System.out.println("Error occured in PR Execution block.."+e);}
	
	if("".equals(retMessage)){
		retMessage="<b><table><tr><td><nobr><font bgcolor='#FFFFFF' color='red'> Purchase Requisition Not Created In SAP. Please check SAP Connection or Contact Administrator</font></b></nobr></td></tr></table>";
	}
%>
<html>
<head>
<title>Message</title>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<Script>
	function goToWelcome()
	{
		document.myForm.action="ezCreatePR.jsp";
		document.myForm.submit();
	}	
	function DisableRightButton(){	
	}
	function openFile(prno)
	{
		var url="ezListPR.jsp?prNumber="+prno;
		var sapWindow=window.open(url,"newwin","width=800,height=500,left=20,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");			
	}
</Script>	
</head>
<body onContextMenu="DisableRightButton(); return false" bgcolor="#FFFFF7" scroll="no">
<form name="myForm" method="post">
<%
	String display_header = "";
%> 
<%//@ include file="../Misc/ezDisplayHeader.jsp"%> <br>
<br><br><br><br>
<Div id='linkDiv' style='position:absolute;align:center;top:30%;width:100%;height:40%'>
	<Table width="60%" border="0" cellspacing="0" cellpadding="0" align=center valign=center>
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
					<Td colspan=2 style='background:#F3F3F3;font-size=11px;font-weight:bold' width='100%' align=center>
					<%=retMessage%>			
					</Td>
				</Tr>
				
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
	<Div id="image" align="center" style='Position:Absolute;visibility:visible;Left:10%;WIDTH:80%;height:70%;Top:85%'>
	<Table align="center">
		<tr align="center">
	<td class=blankcell align="center">
	
	<%
		buttonName = new java.util.ArrayList();
		buttonMethod = new java.util.ArrayList();
		
		buttonName.add("OK");
		buttonMethod.add("goToWelcome()");
		out.println(getButtonStr(buttonName,buttonMethod));
	%>
	</Td>
	</Tr>
</Table>
</Div>		
<Div id="MenuSol"></Div>
</form>
</body>
</html>