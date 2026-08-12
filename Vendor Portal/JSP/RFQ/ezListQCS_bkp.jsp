<%@ page import = "ezc.ezutil.FormatDate"%>
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/Jsps/Misc/iblockcontrol.jsp" %>
<%@ include file="../../../Includes/JSPs/Rfq/iListQcfs.jsp"%>
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager"></jsp:useBean>
<jsp:useBean id="sysManager" class="ezc.client.EzSystemConfigManager" scope="session"></jsp:useBean>
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<%
	boolean dbConnExists = true;

	ezc.ezparam.EzcParams mainParams_db = new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams_db = new EziMiscParams();

	miscParams_db.setQuery("SELECT EUG_ID FROM EZC_USER_GROUPS");
	mainParams_db.setLocalStore("Y");
	mainParams_db.setObject(miscParams_db);
	Session.prepareParams(mainParams_db);
	try
	{
		ReturnObjFromRetrieve retObj = (ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams_db);
		
		if(retObj==null || (retObj!=null && retObj.getRowCount()==0))
			dbConnExists = false;
	}

	catch(Exception e){dbConnExists = false;}	
	

	if(!dbConnExists)
	{

		EzcSysConfigParams sparams = new EzcSysConfigParams();
		EzcSysConfigNKParams snkparams = new EzcSysConfigNKParams();
		snkparams.setLanguage("EN");
		snkparams.setGroupId("555");
		sparams.setObject(snkparams);
		Session.prepareParams(sparams);
		ReturnObjFromRetrieve ret = null;
		

		try{
			ret = (ReturnObjFromRetrieve)sysManager.delFromConnectionPool(sparams);
			// Create Connection Pool
			ret = (ReturnObjFromRetrieve)sysManager.addToConnectionPool(sparams);
			if ( ret.isError() ) {
				// Error in Adding Connection Pool
				String[] errMsgs = ret.getErrorMessages();
			}
		}
		catch(Exception e){ezc.ezcommon.EzLog4j.log("Error in Deleting and Creating Connection Pool.","I");}	
		
		
		ezc.ezmail.EzcMailParams mailParams_db=new ezc.ezmail.EzcMailParams();	
		mailParams_db.setGroupId("Ezc");
		mailParams_db.setTo("kirankumarm@drreddys.com");
		mailParams_db.setCC("jboddu@answerthink.com");
		mailParams_db.setMsgText("DB Connection Dropped in Vikreta PRD");
		mailParams_db.setSubject("DB Connection Dropped in Vikreta PRD");
		mailParams_db.setSendAttachments(false);
		mailParams_db.setContentType("text/html");
		ezc.ezmail.EzMail myMail=new ezc.ezmail.EzMail();
		boolean value=myMail.ezSend(mailParams_db,Session);

		ezc.ezcommon.EzLog4j.log("SENDING EXT MAILS ENDS-STATUS>>"+value,"I");
	}
%>
<%
	ezc.ezutil.FormatDate fD=new ezc.ezutil.FormatDate();
	int myRetCount = myRet.getRowCount();
	
	 mainParams=new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams = new EziMiscParams();
	

	
%>
<html>
<head>
<%@include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<script src="../../Library/JavaScript/ezConvertDates.js"></Script>
<Script>
	var tabHeadWidth=95
	var tabHeight="70%"
	if(screen.width==800)
	{
		tabHeight="57%";
	}
	var dateFormat = "<%=mmordd[0]%>";
	

</Script>
<script>
var newWindow
</script>
 <script src="../../Library/JavaScript/Rfq/ezListQCS.js"></Script>
 <Script src="../../Library/JavaScript/ezTabScroll.js"></Script>
 <Script>
 function showTrail()
 {
 	var radLen = document.myForm.collectiveRFQNo.length
 	var colno = 0
 	if(!isNaN(radLen))
 	{
		for(i=0;i<radLen;i++)
		{
			if(document.myForm.collectiveRFQNo[i].checked)
			{
				colno = document.myForm.collectiveRFQNo[i].value
				break;
			}
		}
 	}
 	else
 	{
 		colno = document.myForm.collectiveRFQNo.value	
 	}
 	document.myForm.wf_trail_list.value = colno
 	hideButton();
 	document.myForm.action = "../Misc/ezWFAuditTrailList.jsp"
 	document.myForm.submit()
}
/* FOR DATE SELECTION AND TO LOAD DEFAULT DATES */
	
	function getDefaultsFromTo(){
<%
		if(searchPO!=null)
		{
%>
			document.myForm.searchPO.value = "<%=searchPO%>";
<%
		}
		if(fromDate!= null && toDate != null){
%>
			
			document.myForm.ToDate.value = "<%=toDate%>";
			document.myForm.FromDate.value = "<%=fromDate%>";
<%
		}
		else{
%>
			
			
			toDate = new Date();
			today = toDate.getDate();
			thismonth = toDate.getMonth()+1;
			thisyear = toDate.getYear();
			
			fromDate =  new Date();
			fromDate.setDate((toDate.getDate()-120));
			prevdate =  fromDate.getDate();
			prevmonth = fromDate.getMonth()+1;
			prevyear =  fromDate.getYear();
			
			if(!document.all){
				thisyear = thisyear+1900;
				prevyear = prevyear+1900;
			}
			if(today < 10)
				today = "0"+today;
			if(prevdate < 10)
				prevdate = "0"+prevdate;	
				
			if(thismonth < 10)
				thismonth = "0" + thismonth;
			if(prevmonth < 10)
				prevmonth = "0" + prevmonth;	
				
			document.myForm.ToDate.value = ConvertDateFormat(today+'.'+thismonth+'.'+thisyear,'<%=Integer.parseInt((String)session.getValue("DATEFORMAT"))%>','<%=(String)session.getValue("DATESEPERATOR")%>');
			document.myForm.FromDate.value = ConvertDateFormat(prevdate+'.'+prevmonth+'.'+prevyear,'<%=Integer.parseInt((String)session.getValue("DATEFORMAT"))%>','<%=(String)session.getValue("DATESEPERATOR")%>');
	
<%
		
		}
		
%>
	}
	function ezSubmit(){

		
		document.myForm.action = "ezListQCS.jsp";
		document.myForm.submit();
	}


function funBack()
{
	document.location.href="../Misc/ezSBUWelcome.jsp";
}

</Script>
</head>
<body onLoad="getDefaultsFromTo();scrollInit()" onResize="scrollInit()" scroll=no>
<form name="myForm">
<input type ="hidden" name="status" value ="<%=status%>">
<input type ="hidden" name="reasons" value ="">
<input type=hidden name=wf_trail_list >
<input type=hidden name=wf_trail_type value='QCF_RELEASE'>
<%
	String display_header = "Collective RFQs List";
	String clickString = "onclick='ezSubmit()'";
	if("A".equals(request.getParameter("Type")))
		display_header = "QCF List";
	if("CR".equals(request.getParameter("status")))
		display_header = "QCF List";		
  	if("E".equals(type))
		display_header = "Expired QCF List";   

	
%>	
	<%@ include file="../Misc/ezDisplayHeader.jsp"%>
	<%
		if( (fromDate== null && toDate == null) || ("null".equals(toDate) && "null".equals(fromDate)) || ("null".equals(searchPO) && "null".equals(searchPO)) ){
		
			fromDate = "";
			toDate = "";
			
		}
	
	%>
	
	
	<Div id='inputDateDiv' style='position:relative;align:center;top:0%;width:100%;'>
	<Table width="65%" border="0" cellspacing="0" cellpadding="0" align=center valign=center>
	<Tr>
		<Td height="5" style="background-color:'F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"></Td>
		<Td height="5" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"><img width="1" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"></Td>
		<Td height="5" style="background-color:'F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"></Td>
	</Tr>
	<Tr>
		<Td width="5" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"><img width="5" height="1" src="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"></Td>
		<Td style="background-color:'F3F3F3'" valign=middle>
			<Table border="0" align="center" valign=middle width="100%" cellpadding=0 cellspacing=0 class=welcomecell>
			<Tr>
				<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='30%' valign=center>
					From Date&nbsp;&nbsp;<input type=text class=inputbox value="<%=fromDate%>" name="FromDate" id="FromDate"  readonly size=15 maxlength="10">&nbsp;<%=getDateImage("FromDate")%>
				</Td>
				<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='28%' align=right valign=center>
					To Date&nbsp;&nbsp;<input type=text class=inputbox value="<%=toDate%>" name="ToDate" id="ToDate" readonly size=15 maxlength="10">&nbsp;<%=getDateImage("ToDate")%>
				</Td>
				<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='30%' align=right valign=center>
					Search QCF &nbsp;&nbsp;<input type=text class=inputbox value="<%=searchPO%>" name="searchPO"   size=15 maxlength="10">&nbsp;
				</Td>
				<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;align:center' width='35%' align=right>
					<Img src="../../../../EzCommon/Images/Body/left_arrow.gif" style="cursor:hand" border="none" <%=clickString%> onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true">
				</Td>
			</Tr>
			
			</Table>
		</Td>
		<Td width="5" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e3.gif"><img width="5" height="1" src="Cb_e3.gif" ></Td>
	</Tr>
	<Tr>
		<Td width="5" style="background-color:'F3F3F3'" height="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c3.gif"><img width="5" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c3.gif"></Td>
		<Td height="5" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e4.gif"><img width="1" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_e4.gif"></Td>
		<Td width="5" style="background-color:'F3F3F3'" height="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c4.gif"><img width="5" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c4.gif"></Td>
	</Tr>
	</Table>
	</Div>
	<BR>

<%
	if(myRetCount == 0)
	{
		
		
%>
		<br><br><br><br>
		<Table width="50%" border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 align="center">
		<Tr align="center">
			<th>No Collective RFQs Exist.</th>
		</Tr>
		</Table>
		<Div id="ButtonDiv" align=center style="position:absolute;top:91%;visibility:visible;width:100%">
<%
			buttonName = new java.util.ArrayList();
			buttonMethod = new java.util.ArrayList();
			buttonName.add("Back");
			buttonMethod.add("funBack()");
			out.println(getButtonStr(buttonName,buttonMethod));
%>
		</Div>

<%	}
	else
	{
	
		
		int keyCode = fD.MMDDYYYY;
		String dateSep = (String)session.getValue("DATESEPERATOR");
		
		ezc.ezparam.ReturnObjFromRetrieve globalRet = null;
		
		Vector grtypes = new Vector();
		grtypes.addElement("date");
		grtypes.addElement("date");
		grtypes.addElement("date");
		EzGlobal.setColTypes(grtypes);
		
		if(keyCode==3)
			EzGlobal.setDateFormat("MM"+dateSep+"dd"+dateSep+"yyyy hh:mm");
		else if (keyCode==4)	
			EzGlobal.setDateFormat("dd"+dateSep+"MM"+dateSep+"yyyy hh:mm");

		Vector grColNames = new Vector();
		grColNames.addElement("RFQ_DATE");
		grColNames.addElement("VALID_UPTO");
		grColNames.addElement("WFDATE");
		EzGlobal.setColNames(grColNames);
		
		globalRet = EzGlobal.getGlobal(myRet);
	
%>
	<Div id="theads">
  	<Table id="tabHead" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0  width="95%">
	    	<Tr align="center" valign="middle">
	    	        
			<th width="12%">QCF</th>
			<th width="15%">Material Desc</th>
			<th width="15%">RFQ Date</th>
			<th width="15%">RFQ Valid Upto</th>
			<th width="15%">Vendors</th>
			<th width="15%">Quoted</th>
			<th width="12%">Not&nbsp;Quoted</th>
			

			
	    	</Tr>
 	</Table>
 	</Div>
	<Div id="InnerBox1Div" style="overflow:auto;position:absolute;width:100%;height:75%;">
	<Table id="InnerBox1Tab" width="100%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
<%	
	Vector collRFQ = new Vector();
	String qcfCat="";
	String qcfNO="";
	String matDesc="";
	String qcfDesc="";
	Hashtable matHash = new Hashtable();
 	
 	
	ReturnObjFromRetrieve plantRetObj=null;

	for(int i=0;i<myRetCount;i++)
	{
		if(i==0)
			qcfCat="'"+myRet.getFieldValueString(i,"COLLETIVE_RFQ_NO")+"'";
		else	
			qcfCat+=",'"+myRet.getFieldValueString(i,"COLLETIVE_RFQ_NO")+"'";

	}
	//out.println(qcfCat);
	miscParams.setQuery("SELECT DISTINCT ERH_COLLETIVE_RFQ_NO,ERD_MATERIAL,ERD_MATERIAL_DESC FROM EZC_RFQ_HEADER,EZC_RFQ_DETAILS WHERE ERH_RFQ_NO = ERD_RFQ_NO  AND ERH_COLLETIVE_RFQ_NO IN ("+qcfCat+") ORDER BY ERH_COLLETIVE_RFQ_NO");
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscParams);
	Session.prepareParams(mainParams);
	try
	{
		plantRetObj = (ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);
		if(plantRetObj!=null && plantRetObj.getRowCount()>0)
		{
			for(int i=0;i<plantRetObj.getRowCount();i++)
			{
				qcfNO=plantRetObj.getFieldValueString(i,"ERH_COLLETIVE_RFQ_NO");
				matDesc=plantRetObj.getFieldValueString(i,"ERD_MATERIAL_DESC");

				if(matHash.containsKey(qcfNO))
				{
					qcfDesc=(String)matHash.get(qcfNO);
					qcfDesc=qcfDesc+"/"+matDesc;
					matHash.put(qcfNO,qcfDesc);
				}
				else
				{
					matHash.put(qcfNO,matDesc);					
				}
			}	
		}
	}
		
	catch(Exception e){ out.println(e);}		
	

	for(int i=0;i<myRetCount;i++)
	{
		java.util.Date rfqDate 	= (java.util.Date)myRet.getFieldValue(i,"RFQ_DATE");
		java.util.Date validUpto= (java.util.Date)myRet.getFieldValue(i,"VALID_UPTO");
		int totQuoted		= Integer.parseInt(myRet.getFieldValueString(i,"TOT_QUOTED"));
		int totRFQs		= Integer.parseInt(myRet.getFieldValueString(i,"TOT_RFQ"));
		
		if(!participant.equals(myRet.getFieldValueString(i,"NEXTPARTICIPANT")) && participant.equals(myRet.getFieldValueString(i,"DELPARTICIPANT")))
			isDelParticipant = myRet.getFieldValueString(i,"NEXTPARTICIPANT");
		else
			isDelParticipant = "NO";	
		String tempNum=myRet.getFieldValueString(i,"COLLETIVE_RFQ_NO");
		if(collRFQ.contains(tempNum))
			continue;
		else
			collRFQ.add(tempNum);
			
			
%>   
		<tr>
			
<%			if(totQuoted > 0)
			{
				//if(totQuoted<4)
				{   
				    if("A".equals(type))
				    {
%>					
					<td width="12%"><a href = 'ezExecReport.jsp?reportName=ZMPSR00_PRICE_COMPARISON&system=999&sysDesc=DRL SAP R/3 SYSTEM -> 999&repNo=399&qcfNo=<%=myRet.getFieldValueString(i,"COLLETIVE_RFQ_NO")%>&Type=<%=type%>&isdelegate=<%=isDelParticipant%>' onClick="hideButton()"><%=myRet.getFieldValueString(i,"COLLETIVE_RFQ_NO")%></a></td>
					
<%				        
				    } 
				    else 
				    {
%>
					
					<td width="12%"><a href = 'ezExecReport.jsp?PAGE=NEW&status=<%=status%>&reportName=ZMPSR00_PRICE_COMPARISON&system=999&sysDesc=DRL SAP R/3 SYSTEM -> 999&repNo=399&qcfNo=<%=myRet.getFieldValueString(i,"COLLETIVE_RFQ_NO")%>&Type=<%=type%>&isdelegate=<%=isDelParticipant%>' onClick="hideButton()"><%=myRet.getFieldValueString(i,"COLLETIVE_RFQ_NO")%></a></td>
					
					
<%				    }	
				}
				//else
				//{
%>					<!--<td width="15%"><a href = 'ezListRFQByCollectiveRFQ.jsp?collectiveRFQNo=<%=myRet.getFieldValueString(i,"COLLETIVE_RFQ_NO")%>&Type=<%=type%>&isdelegate=<%=isDelParticipant%>'><%=myRet.getFieldValueString(i,"COLLETIVE_RFQ_NO")%></a></td>-->
<%				//}
%>				
<%			}
			else
			{
%>			
				<td width="12%"><%=myRet.getFieldValueString(i,"COLLETIVE_RFQ_NO")%></td>
				
<%
			}
%>			
			<td width="15%" align="center">&nbsp;<%=matHash.get(myRet.getFieldValueString(i,"COLLETIVE_RFQ_NO"))%></td>
			<td width="15%" align="center"><%=globalRet.getFieldValue(i,"RFQ_DATE")%></td>
			<td width="15%" align="center"><%=fD.getStringFromDate(validUpto,(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")))%></td>
			
			
			<td width="15%" align="center"><a href="javascript:showVendors('<%=myRet.getFieldValueString(i,"COLLETIVE_RFQ_NO")%>','A')"><%=myRet.getFieldValueString(i,"TOT_RFQ")%></a></td>
		    <%
		    	if("0".equals(myRet.getFieldValueString(i,"TOT_QUOTED")))
		    	{
		    %>
		 		<td width="15%" align="center"><%=myRet.getFieldValueString(i,"TOT_QUOTED")%></td>   
		    <%
		    	} else {
		    %>
				<td width="15%" align="center"><a href="javascript:showVendors('<%=myRet.getFieldValueString(i,"COLLETIVE_RFQ_NO")%>','Y')"><%=myRet.getFieldValueString(i,"TOT_QUOTED")%></a></td>
		    <%
		    	}
		    	if("0".equals(myRet.getFieldValueString(i,"TOT_NOT_QUOTED")))
		    	{
		    %>
		    		<td width="13%" align="center"><%=myRet.getFieldValueString(i,"TOT_NOT_QUOTED")%></td>
		    <%
		    	} else {
		    %>
		    
				<td width="13%" align="center"><a href="javascript:showVendors('<%=myRet.getFieldValueString(i,"COLLETIVE_RFQ_NO")%>','N')"><%=myRet.getFieldValueString(i,"TOT_NOT_QUOTED")%></a></td>
		    <%
		    	}
		    %>	
		    
	      	</tr>
<%
	}
%>
	</table>
	</div>

	<div id="ButtonDiv" align=center style="position:absolute;top:91%;visibility:visible;width:100%">
 	<Span id="EzButtonsSpan" >
		    
<%		    
		buttonName = new java.util.ArrayList();
		buttonMethod = new java.util.ArrayList();
		buttonName.add("Back");
		buttonMethod.add("funBack()");
		
          
 	String chkUserRole = (String)session.getValue("USERROLE");
 	if("MG".equals(chkUserRole) || "SM".equals(chkUserRole))
 	{
 
 	buttonName.add("Close");
	buttonMethod.add("CloseQCF()");
	
 	}

 	if(!"CR".equals(status))
 	{
 
 	buttonName.add("Audit");
	buttonMethod.add("showTrail()");	
	
 	}
 	   out.println(getButtonStr(buttonName,buttonMethod));

 %>	
 	</Span>
 
 	<Span id="EzButtonsMsgSpan" style="display:none">
 		<Table align=center>
 			<Tr>
 				<Td >Your request is being processed... Please wait</Td>
 			</Tr>
 		</Table>
	</Span>
</Div>
<%   }  %>



</form>
<Div id="MenuSol"></Div>
</body>
</html>