<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ page import="ezc.vendorprofile.params.*,ezc.ezparam.*,ezc.ezworkflow.params.*,java.util.*" %>		
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="vendorprofile" class="ezc.vendorprofile.client.EzVendorProfileManager" scope="session"></jsp:useBean>
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" />
<%@ page import="ezc.ezmisc.params.*,java.text.*" %>
<jsp:useBean id="EzWorkFlowManager" class="ezc.ezworkflow.client.EzWorkFlowManager" scope="session" />
<%@ include file="ezGetUserAuthDefaults.jsp"%>    
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<jsp:useBean id="ezVendTransactions" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="session" />
<link rel="stylesheet" type="text/css" href="../../Library/jquery/jquery-ui-1.12.1.custom/jquery-ui.css">
<link rel="stylesheet" href="../Misc/library/fancybox2/jquery.fancybox.css" type="text/css" media="screen" />
<%! 
public String checkNull(String value)   
{
	if(value==null || "null".equals(value.trim()))value="";
	value=value.trim();
	
	return value; 
}
%>
<%
	ReturnObjFromRetrieve retAllSyskeys = null;
	String allSyskeys	= "";
	EzcParams mainParams	 = new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams = new EziMiscParams();
	/*miscParams.setQuery("select * from ezc_buss_partner_areas where EBPA_USER_ID='"+(String)Session.getUserId()+"'");
	mainParams.setObject(miscParams);
	mainParams.setLocalStore("Y");
	Session.prepareParams(mainParams);
	try
	{
		retAllSyskeys = (ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);
	}
	catch(Exception e)
	{
		ezc.ezcommon.EzLog4j.log("::::Error occuered while getting details::::"+e,"I");
	}
	if(retAllSyskeys!=null && retAllSyskeys.getRowCount()>0)
	{
		for(int i=0;i<retAllSyskeys.getRowCount();i++)
		{
			if("".equals(allSyskeys))allSyskeys=checkNull(retAllSyskeys.getFieldValueString(i,"EBPA_SYS_KEY"));
			else allSyskeys=allSyskeys+"','"+checkNull(retAllSyskeys.getFieldValueString(i,"EBPA_SYS_KEY"));
		}
	}*/
	allSyskeys=userSyskeysStr;
	int dateRange = 90;
	String fromDate                = checkNull(request.getParameter("FromDate"));
	String toDate                  = checkNull(request.getParameter("ToDate"));
	
	String selVendor                  = checkNull(request.getParameter("vendor"));
	//out.println(selVendor+":::::::");
	if("".equals(selVendor))selVendor="ALL";
%>

	<%@ include file="../Misc/ezGetDefaultFromToDates.jsp"%>
<%
	
	
	String status = checkNull(request.getParameter("Status"));
	String WFStatus = checkNull(request.getParameter("WFStatus"));
	String type = checkNull(request.getParameter("type"));
	if("".equals(type))type="2";
	
	
	/*mainParams	= new ezc.ezparam.EzcParams(false);
	miscParams 		= new EziMiscParams();

try{
		miscParams.setQuery("SELECT * FROM EZC_WF_WORKGROUP_USERS WHERE EWWU_USER ='"+Session.getUserId()+"'");

		mainParams.setObject(miscParams);
		mainParams.setLocalStore("Y");
		Session.prepareParams(mainParams);
		ReturnObjFromRetrieve userWorkGroupsRetObj = (ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);

		if(userWorkGroupsRetObj!=null)
		{
		userWfGroupsStr="";
		for(int i=0;i<userWorkGroupsRetObj.getRowCount();i++)
		{
			String DBUserGroup = checkNull(userWorkGroupsRetObj.getFieldValueString(i,"EWWU_GROUP"));

			if("".equals(userWfGroupsStr))
			userWfGroupsStr=DBUserGroup;
			else
			userWfGroupsStr=userWfGroupsStr+"','"+DBUserGroup;
		}
		}
	}catch(Exception e){System.out.println(e);}
	*/
	String wfCheckName 	= 	"'"+Session.getUserId()+"','"+userWfGroupsStr+"','"+userRole+"'";	
	
	ezc.ezcommon.EzLog4j.log("::::wfCheckName::::"+wfCheckName,"I");
	String usersList="",docStr="";
	ArrayList userIdAL=new ArrayList();
	ReturnObjFromRetrieve UserNamesRetObj=null;
	ReturnObjFromRetrieve docHeaderListRetObj =null;
	int userNameCount=0;
	int docHeaderListRetObjCnt=0;


		if("MDM".equals(userRole))
		{
			mainParams = new ezc.ezparam.EzcParams(false);
			EziWFDocHistoryParams wfparams= new EziWFDocHistoryParams();
			wfparams.setAuthKey("'VENDOR_PROFILE'");
			wfparams.setStatus("'"+WFStatus+"'");
			mainParams.setObject(wfparams);
			Session.prepareParams(mainParams);
			try{
				docHeaderListRetObj = (ezc.ezparam.ReturnObjFromRetrieve)EzWorkFlowManager.getWFDocList(mainParams);

				docHeaderListRetObjCnt=docHeaderListRetObj.getRowCount();
			}catch(Exception e){}
		}else{
			mainParams = new ezc.ezparam.EzcParams(false);
			EziWFDocHistoryParams wfparams= new EziWFDocHistoryParams();
			wfparams.setAuthKey("'VENDOR_PROFILE'");
			
			if("OPEN".equals(status))
			{
			wfparams.setStatus("'SUBMITTED'");
			wfparams.setParticipant(wfCheckName);
			}
			if("CLOSED".equals(status))
			{
			wfparams.setStatus("'APPROVED','POSTEDTOSAP'");
			wfparams.setSysKey("'"+allSyskeys+"'");
			}
			
			mainParams.setObject(wfparams);
			Session.prepareParams(mainParams);
			try{
				docHeaderListRetObj = (ezc.ezparam.ReturnObjFromRetrieve)EzWorkFlowManager.getWFDocList(mainParams);
				//out.println("docHeaderListRetObj"+docHeaderListRetObj.toEzcString());

				docHeaderListRetObjCnt=docHeaderListRetObj.getRowCount();
			}catch(Exception e){}
		}
		for(int i=0;i<docHeaderListRetObjCnt;i++)
		{
			if("".equals(docStr))
			docStr=checkNull(docHeaderListRetObj.getFieldValueString(i,"EWDHH_DOC_ID"));
			else
			docStr=docStr+"','"+checkNull(docHeaderListRetObj.getFieldValueString(i,"EWDHH_DOC_ID"));
		}
	
	
	if("REJECTED".equals(status)){
		mainParams = new ezc.ezparam.EzcParams(false);
		EziWFDocHistoryParams wfparams= new EziWFDocHistoryParams();
		wfparams.setAuthKey("'VENDOR_PROFILE'");
		wfparams.setStatus("'REJECTED'");
		mainParams.setObject(wfparams);
		Session.prepareParams(mainParams);
		try{
			docHeaderListRetObj = (ezc.ezparam.ReturnObjFromRetrieve)EzWorkFlowManager.getWFDocList(mainParams);
			//out.println("docHeaderListRetObj"+docHeaderListRetObj.toEzcString());

			docHeaderListRetObjCnt=docHeaderListRetObj.getRowCount();
			for(int i=0;i<docHeaderListRetObjCnt;i++)
			{
			String modifiedByStr= docHeaderListRetObj.getFieldValueString(i,"EWDHH_MODIFIED_BY");
			
			if(!userIdAL.contains(modifiedByStr))								
			userIdAL.add(modifiedByStr);
			}
		}catch(Exception e){}
	} 
	mainParams = new ezc.ezparam.EzcParams(true);
	ezc.vendorprofile.params.EziVendorGeneralDataParams generalParams= new ezc.vendorprofile.params.EziVendorGeneralDataParams();
	ezc.vendorprofile.params.EziVendorProfileKeyParams keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();
	EziVendorKeyParamsTable keyTableParams = new EziVendorKeyParamsTable();
		
	keyParams.setKey("GetGeneralData");
	keyTableParams.appendRow(keyParams);
	mainParams.setLocalStore("Y");

	if("POSTED".equals(status)||"CLOSED".equals(status))
	generalParams.setStatus("CLOSED') AND EVGD_VEND_TYPE NOT IN('NOSAP");
	else if("OPEN".equals(status))
	generalParams.setStatus("OPEN') AND EVGD_VEND_TYPE NOT IN('NOSAP");
	else
	generalParams.setStatus(status+"','CLOSED') AND EVGD_VEND_TYPE NOT IN('NOSAP");
	
	if("OPEN".equals(status) || "CLOSED".equals(status) || "POSTED".equals(status))
	generalParams.setDocId(docStr);
	
	if("REJECTED".equals(status)||"CLOSED".equals(status))
	{String v_VendUserType = (String)session.getValue("UserType");
		if("3".equals(v_VendUserType)){
		String selVendorTemp="0000000000"+(String)Session.getUserId();
			selVendorTemp=selVendorTemp.substring(((String)Session.getUserId()).length(),selVendorTemp.length());
		generalParams.setVendor((String)Session.getUserId()+"','"+selVendorTemp);
		}
	}
	
	if(!"ALL".equals(selVendor) && "CLOSED".equals(status))
	{
	
	String selVendorTemp="0000000000"+selVendor;
	selVendorTemp=selVendorTemp.substring(selVendor.length(),selVendorTemp.length());
	generalParams.setVendor(selVendor+"','"+selVendorTemp);
	}
	
	mainParams.setObject(keyTableParams);	
	
	mainParams.setObject(generalParams);
	Session.prepareParams(mainParams);
	
	ReturnObjFromRetrieve vendorDtlsObj =null;
	int vendorDtlsObjCnt=0;
	try{
	 vendorDtlsObj=(ReturnObjFromRetrieve)vendorprofile.ezGetDetails(mainParams);
	 vendorDtlsObj=((ReturnObjFromRetrieve)vendorDtlsObj.getObject("GetGeneralData"));
	 if(vendorDtlsObj!=null)
	 {
	 vendorDtlsObjCnt=vendorDtlsObj.getRowCount();
			//boolean vendorDtls=vendorDtlsObj.sort(new String[]{"EVGD_DOC_ID"},false);
	}
	for(int i=0;i<vendorDtlsObjCnt;i++)
	{
		String userid="";
		String vendorStr= vendorDtlsObj.getFieldValueString(i,"EVGD_VENDOR");
	
		try{
		vendorStr=Integer.parseInt(vendorStr)+"";
		}catch(Exception e){vendorStr= vendorDtlsObj.getFieldValueString(i,"EVGD_VENDOR");}

			if(!userIdAL.contains(vendorStr))								
				userIdAL.add(vendorStr);
	}

	for(int i=0;i<userIdAL.size();i++)
	{
		if("".equals(usersList))
			usersList=(String)userIdAL.get(i);
		else
			usersList=usersList+"','"+(String)userIdAL.get(i);
				
	}
	
	mainParams	= new ezc.ezparam.EzcParams(false);
	miscParams 		= new EziMiscParams();


	miscParams.setQuery("SELECT EU_ID,EU_FIRST_NAME,EU_LAST_NAME FROM EZC_USERS WHERE EU_ID IN ('"+usersList+"')");

	mainParams.setObject(miscParams);
	mainParams.setLocalStore("Y");
	Session.prepareParams(mainParams);
	UserNamesRetObj = (ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);

	if(UserNamesRetObj!=null)
	userNameCount = UserNamesRetObj.getRowCount();
	}catch(Exception e){System.out.println(e);}
%>


<html>
 <head>
 <link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.bootstrap.min.css">
 <link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.responsive.min.css">
 <link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.tableTools.css">

<%@ include file="ezHeader.jsp"%> 
</head>
<script type="text/javascript">

function funGo()
{
document.myForm.submit();
}

function funClick(docId,vendor,docSysKey,docCurStep,vendType,docIdStr)
{

	document.myForm.selDocId.value=docId;
	document.myForm.selDocIdStr.value=docIdStr;
	document.myForm.selVendor.value=vendor;
	document.myForm.docSysKey.value=docSysKey;
	document.myForm.docCurStep.value=docCurStep;
	document.myForm.vendType.value=vendType;
	
	if(vendType=="NEW")
	document.myForm.action="ezDisplayNewVendorDtls.jsp";
	else
	document.myForm.action="ezDisplayVendorProfileDtls.jsp";
	document.myForm.submit();
}
</script>
<body>
<style type="text/css">     
    select {
        width:300px;
    }
.table>tbody>tr>td
{
    	font-size: 12px;
}
.table-bordered>thead>tr>th
{
    	font-size: 12px;
}
</style>
<form name="myForm" method="post"  > 
<input type="hidden" name="vendType">
<input type="hidden" name="selDocId">
<input type="hidden" name="selDocIdStr">
<input type="hidden" name="selVendor">
<input type="hidden" name="docSysKey">
<input type="hidden" name="docCurStep">
<input type="hidden" name="status" value="<%=status%>">


<%	
	String display_header ="";
	if("OPEN".equals(status))
		display_header = "Vendor Profile Requests > Open";
	else if("REJECTED".equals(status))
		display_header = "Self Service > Rejected/Approved Requests";
	else
	{
		if("POSTEDTOSAP".equals(WFStatus))
		display_header = "SAP Posted Requests";
		else
		display_header = "Vendor Profile Requests > Approved Requests";
	}
%>
	 <%@ include file="../Misc/ezSubHeader.jsp"%>         

<%
if("CLOSED".equals(status))
{

	String v_VendUserType = (String)session.getValue("UserType");
	String vendUserSoldTo = (String)session.getValue("SOLDTO");

	java.util.Hashtable vendorsHT = new java.util.Hashtable(); 
	java.util.Vector vendorsVector= new java.util.Vector(); 
	int vendorsRetObjCnt = 0;
	ezc.ezparam.ReturnObjFromRetrieve vendorsRetObj = null;

	ezc.ezparam.EzcParams addMainParams = new ezc.ezparam.EzcParams(false);
	ezc.vendortransactions.params.EzVendorTransactionsKeyParams v_KeyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
	ezc.vendortransactions.params.EzVendorParams  vendParams= new ezc.vendortransactions.params.EzVendorParams();

	try
	{
		v_KeyParams.setKey("GET_VENDORS");
		addMainParams.setLocalStore("Y");
		
		if("2".equals(v_VendUserType))
			vendParams.setSyskey(allSyskeys);
		else
			vendParams.setSyskey(allSyskeys+"') AND LTRIM(RTRIM(EC_ERP_CUST_NO)) = ('"+vendUserSoldTo.trim());
			
		vendParams.setGroup("");

		addMainParams.setObject(v_KeyParams);	
		addMainParams.setObject(vendParams);
		Session.prepareParams(addMainParams);

		vendorsRetObj=(ezc.ezparam.ReturnObjFromRetrieve)ezVendTransactions.ezGetVendorTransactions(addMainParams);

		if(vendorsRetObj!=null && vendorsRetObj.getRowCount()>0)
		{
			vendorsRetObjCnt = vendorsRetObj.getRowCount();

			for(int vc=0;vc<vendorsRetObjCnt;vc++)
			{
				vendorsHT.put(vendorsRetObj.getFieldValueString(vc,"EC_ERP_CUST_NO").trim(), vendorsRetObj.getFieldValueString(vc,"ECA_NAME"));
				vendorsVector.addElement(vendorsRetObj.getFieldValueString(vc,"EC_ERP_CUST_NO").trim());
			}

		}	
	}
	catch(Exception e){
		//out.println(":::EEEE:::"+e);
	}

	//out.println("::::::vendorsHT:::::::"+vendorsHT);
%>	<Br>
	<Table border="1" align="center" valign=middle width="60%" cellpadding=0 cellspacing=0 class=welcomecell>
	<Tr>
		<Th style="width:20%;font-size: 12px;" <%=trBGColorH%>>
			From Date&nbsp;&nbsp;
		</Th>
		<Td>
			<!--<input type=text class=inputbox value="<%=fromDate%>"  style="width:70%" id="FromDate" name="FromDate"  readonly size=15 maxlength="10">&nbsp;<%=getDateImage("FromDate")%>-->
			<input class="form-control input-sm" type="text" value="<%=fromDate%>" name="FromDate" id="FromDate"  >
		</Td>
		<Td>
			 <label for="FromDate" class="input-group-addon btn"> <img src='../../../../EzCommon/JavaScript/Calendar/Themes/icons/calendar7.gif' style='cursor:hand' id='butt"+field+"' border='none' valign='center'></label>  				
 		</Td>
		<Th  style="width:20%;font-size: 12px;" <%=trBGColorH%>>
			&nbsp;&nbsp;&nbsp;&nbsp;To Date&nbsp;&nbsp;
		</Th>
		<Td>
			<!--<input type=text class=inputbox value="<%=toDate%>" name="ToDate" style="width:70%" id="ToDate"  readonly size=15 maxlength="10">&nbsp;<%=getDateImage("ToDate")%>-->
			<input class="form-control input-sm" type="text" value="<%=toDate%>" name="ToDate" id="ToDate" >
		</Td>
		<Td>
			<label for="ToDate" class="input-group-addon btn"> <img src='../../../../EzCommon/JavaScript/Calendar/Themes/icons/calendar7.gif' style='cursor:hand' id='butt"+field+"' border='none' valign='center'></label>  
 		</Td>
		<!--<Th <%=trBGColorH%>>
			&nbsp;&nbsp;&nbsp;&nbsp;Vendor&nbsp;&nbsp;
		</Th>
		<td >
		<select name="vendor" id="vendor" width="100%">
		<option value="ALL">ALL</option>
		<%
		if(vendorsHT!=null && vendorsHT.size()>0)
		{
			Enumeration enumeration = vendorsHT.keys();

			while (enumeration.hasMoreElements()) 
			{ 					
				String attachFilekey=   (String)enumeration.nextElement();
				String attachFileValue = checkNull((String)vendorsHT.get(attachFilekey));
		%>

			<option value="<%=Integer.parseInt(attachFilekey)%>"><%=attachFileValue+" ["+Integer.parseInt(attachFilekey)+"]"%></option>
		<%
			}
		}
		%>
		</select>
		</td>-->                
		<input type="hidden" name="vendor" value="ALL">
		<!--<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;align:center' width='10%' align=right>
			<Img src="../../../../EzCommon/Images/Body/left_arrow.gif" style="cursor:hand;width:30%" border="none" onClick="funGo()" onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true">
		</Td>-->
		<Td onClick="funGo()" onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true" style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;align:center' width='5%' align=right>
			<Img src="../../../../EzCommon/Images/Body/arrowright.png" style="cursor:hand" border="none" onClick="funGo()" onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true">&nbsp;
		</Td>
		
	</Tr>

	</Table>
<Br>	
<%
}
	if(vendorDtlsObjCnt>0)
	{
%>
		<table id="example" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
		<thead>
		  <tr <%=trBGColor%>>
			<th align="center">Request Doc</th>
			<%
			if("OPEN".equals(status) || "CLOSED".equals(status) || "POSTED".equals(status))
			{
			%>
			<th align="center">Vendor Type</th>
			<%
			}
			
			if("2".equals(type))
			{
			%>
			<th align="center">Vendor </th>
			<%
			}else{
			%>
			<th align="center">Rejected By </th>
			<%
			}
			%>
			
			<th align="center">Acted On</th> 
			<%
			if("CLOSED".equals(status) || "POSTED".equals(status) )
			{
			%>
			<th align="center">SAP Vendor Code</th>
			<%
			}else{
			%>
			<th align="center">Status</th> 
			<%
			}
			%>
		 </tr>
		 </thead>
		 <tbody>
<%
		String color = "";
		for(int i=0;i<vendorDtlsObjCnt;i++)
		{
			int currindex=-1;
			color = "";
			//if(i%2==0) {color = altRowColor;} 

				String docId = checkNull(vendorDtlsObj.getFieldValueString(i,"EVGD_DOC_ID"));
				String vendType =checkNull(vendorDtlsObj.getFieldValueString(i,"EVGD_VEND_TYPE"));
				String purchOrg =checkNull(vendorDtlsObj.getFieldValueString(i,"EVGD_ADDR_NR"));
				String sapVendorCode =checkNull(vendorDtlsObj.getFieldValueString(i,"EVGD_SAP_VENDOR"));
				String vendTypeStr="",docIdStr=docId;
				if(!"".equals(purchOrg))docIdStr=purchOrg+docId;
				if("SAP".equals(vendType)) vendTypeStr = "SAP Vendor";
				else vendTypeStr = "New Vendor";
				 
				try{
				sapVendorCode=Integer.parseInt(sapVendorCode)+"";
				}catch(Exception e){}
				
				if(docHeaderListRetObj!=null)
				currindex	= docHeaderListRetObj.getRowId("EWDHH_DOC_ID",docId);
				String vendor = vendorDtlsObj.getFieldValueString(i,"EVGD_VENDOR");
				String modifiedOn = vendorDtlsObj.getFieldValueString(i,"EVGD_MODIFIED_ON");
				String stat = vendorDtlsObj.getFieldValueString(i,"EVGD_STATUS");
				String vendorName="",docSysKey="",docCurStep="",modifiedBy="";

				if(currindex>=0)
				{
					docSysKey = docHeaderListRetObj.getFieldValueString(currindex,"EWDHH_SYSKEY");
					docCurStep = docHeaderListRetObj.getFieldValueString(currindex,"EWDHH_CURRENT_STEP");
					modifiedBy = docHeaderListRetObj.getFieldValueString(currindex,"EWDHH_MODIFIED_BY");
				}
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				SimpleDateFormat formatter1 = new SimpleDateFormat("yyyyMMdd");
				Date date = formatter.parse(modifiedOn);
				formatter = new SimpleDateFormat("dd/MM/yyyy");
				String modifiedOnDate = formatter.format(date);
				String mainModifiedOnDate = formatter1.format(date);

				try{
				vendor=Integer.parseInt(vendor)+"";
				}
				catch(Exception e){vendor = vendorDtlsObj.getFieldValueString(i,"EVGD_VENDOR");}
						
%>				
				<tr >
				<td align="center" <%=color%>><a style='text-decoration:underline' href="javaScript:funClick('<%=docId%>','<%=vendorDtlsObj.getFieldValueString(i,"EVGD_VENDOR")%>','<%=docSysKey%>','<%=docCurStep%>','<%=vendType%>','<%=docIdStr%>')"><%=docIdStr%></a>&nbsp;</td>
				<%
				if("OPEN".equals(status) || "CLOSED".equals(status) || "POSTED".equals(status))
				{
				%>
				<td align="center" <%=color%>><%=vendTypeStr%></td>
				<%
				}
				%>
				
				<td align="center" <%=color%>>
<%
				int index=-1;

				if(UserNamesRetObj!=null)
				{
					if("2".equals(type))
					index=UserNamesRetObj.getRowId("EU_ID",vendor);
					else
					{
					index=UserNamesRetObj.getRowId("EU_ID",modifiedBy);
					vendor=modifiedBy;
					}
					
					vendorName=checkNull(UserNamesRetObj.getFieldValueString(index,"EU_FIRST_NAME"))+" "+checkNull(UserNamesRetObj.getFieldValueString(index,"EU_LAST_NAME"));

				}


%>				<%=vendorName%>	(<%=vendor%>)					

				&nbsp;</td>
				
				<td align="center" <%=color%>><span style="display:none"><%=mainModifiedOnDate%></span><%=modifiedOnDate%>&nbsp;</td>
				<%
				if("CLOSED".equals(status) || "POSTED".equals(status))
				{
				%>
				<td align="center" <%=color%>><%=sapVendorCode%>&nbsp;</td>
				<%
				}else{
				if("CLOSED".equals(stat))
				stat="APPROVED";
				%>
				
				<td align="center" <%=color%>><%=stat%>&nbsp;</td>
				<%
				}
				%>
				</tr>

<%
				
			}
%>
			 
			 </tbody>
			 </table>
			 <p>&nbsp;&nbsp;Please click on request doc to view request.</p>
		</div>
		<%
		}else{
		%>
		<div class="box-body" style="display: block;">
		<div class="col-md-12" >
			<div class="form-group">
			<label>No Requests To Show. </label> 
			</div>
		</div>	
		</div>
		<%
		}
		%>
	
	</div>
	</section><!-- /.content -->

       </div><!-- /.content-wrapper -->	
<script>	
if(document.myForm.vendor!=undefined || document.myForm.vendor!=null)
document.myForm.vendor.value="<%=selVendor%>";
</script>	
</form>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%>
<%@ include file="../Misc/ezDataTableScript.jsp"%>
<script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.js"></script>
<script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.pack.js"></script>
<script src="../../Library/jquery/jquery-validation-1.16.0/dist/jquery.validate.min.js"></script>
<script src="../../../../EzCommon/Library/jquery-ui-1.10.4/js/jquery-ui-1.10.4.custom.js"></script>
<script>
$(document).ready(function() {
		
       $("#FromDate").datepicker({ 
              	dateFormat: 'dd/mm/yy', 
              	changeMonth: true,
          	changeYear: true
       });
        $("#ToDate").datepicker({ 
                     	dateFormat: 'dd/mm/yy', 
                     	changeMonth: true,
          		changeYear: true
       });
 });
  
</script>
<link rel="stylesheet" href="../../../../EzCommon/Library/plugins/jQuery/confirm.css" type="text/css" media="screen" />  
<script src="../../../../EzCommon/Library/plugins/jQuery/confirm.min.js"></script>
<link rel="stylesheet" href="../../../../EzCommon/Library/plugins/jQuery/confirm.css" type="text/css" media="screen" />  
<script src="../../../../EzCommon/Library/plugins/jQuery/confirm.min.js"></script>
   