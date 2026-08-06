<%@ page import="ezc.vendorprofile.params.*,ezc.ezparam.*,ezc.ezworkflow.params.*,java.util.*" %>		
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="vendorprofile" class="ezc.vendorprofile.client.EzVendorProfileManager" scope="session"></jsp:useBean>
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" />
<%@ page import="ezc.ezmisc.params.*,java.text.*" %>
<jsp:useBean id="EzWorkFlowManager" class="ezc.ezworkflow.client.EzWorkFlowManager" scope="session" />
<%@ include file="ezGetUserAuthDefaults.jsp"%>    

<%!
public String checkNull(String value)
{
	if(value==null || "null".equals(value.trim()))value="";
	value=value.trim();
	
	return value;
}
%>
<%
	String status = request.getParameter("Status");
	
	
	String wfCheckName 	= 	"'"+Session.getUserId()+"','"+userWfGroupsStr+"','"+userRole+"'";	
	
	ezc.ezcommon.EzLog4j.log("::::wfCheckName::::"+wfCheckName,"I");
	String usersList="",docStr="";
	ArrayList userIdAL=new ArrayList();
	ReturnObjFromRetrieve UserNamesRetObj=null;
	ReturnObjFromRetrieve docHeaderListRetObj =null;
	int userNameCount=0;
	int docHeaderListRetObjCnt=0;

	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(true);
	ezc.vendorprofile.params.EziVendorGeneralDataParams generalParams= new ezc.vendorprofile.params.EziVendorGeneralDataParams();
	ezc.vendorprofile.params.EziVendorProfileKeyParams keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();
	EziVendorKeyParamsTable keyTableParams = new EziVendorKeyParamsTable();
	
	if("OPEN".equals(status))
	{
		if("MDM".equals(userRole))
		{
			mainParams = new ezc.ezparam.EzcParams(false);
			EziWFDocHistoryParams wfparams= new EziWFDocHistoryParams();
			wfparams.setAuthKey("'VENDOR_PROFILE'");
			wfparams.setStatus("'APPROVED'");
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
			wfparams.setParticipant(wfCheckName);
			wfparams.setStatus("'SUBMITTED'");
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
	}
	
	keyParams.setKey("GetGeneralData");
	keyTableParams.appendRow(keyParams);
	mainParams.setLocalStore("Y");

	generalParams.setStatus(status);
	if("OPEN".equals(status))
	generalParams.setDocId(docStr);
	
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
	EziMiscParams miscParams 		= new EziMiscParams();


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
function funClick(docId,vendor,docSysKey,docCurStep)
{

	document.myForm.selDocId.value=docId;
	document.myForm.selVendor.value=vendor;
	document.myForm.docSysKey.value=docSysKey;
	document.myForm.docCurStep.value=docCurStep;
	
	
	document.myForm.action="ezDisplayVendorProfileDtls.jsp";
	document.myForm.submit();
}
</script>
<body>

<form name="myForm" method="post"  > 
<input type="hidden" name="selDocId">
<input type="hidden" name="selVendor">
<input type="hidden" name="docSysKey">
<input type="hidden" name="docCurStep">
<input type="hidden" name="status" value="<%=status%>">

<%	
	String display_header ="";
	if("OPEN".equals(status))
		display_header = "List Of To Act Requests";
	else
		display_header = "Closed Requests";
%>
	 <%@ include file="../Misc/ezSubHeader.jsp"%>         

<%
	if(vendorDtlsObjCnt>0)
	{
%>
		<table id="example" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
		<thead>
		  <tr <%=trBGColor%>>
			<th align="center">Request Doc</th>
			<th align="center">Vendor </th>
			<th align="center">Modified On</th> 
		 </tr>
		 </thead>
		 <tbody>
<%
		String color = "";
		for(int i=0;i<vendorDtlsObjCnt;i++)
		{
			int currindex=-1;
			color = "";
			if(i%2==0) {color = altRowColor;} 

				String docId = vendorDtlsObj.getFieldValueString(i,"EVGD_DOC_ID");
				currindex	= docHeaderListRetObj.getRowId("EWDHH_DOC_ID",docId);
				String vendor = vendorDtlsObj.getFieldValueString(i,"EVGD_VENDOR");
				String modifiedOn = vendorDtlsObj.getFieldValueString(i,"EVGD_MODIFIED_ON");
				String vendorName="",docSysKey="",docCurStep="";

				if(currindex>=0)
				{
					docSysKey = docHeaderListRetObj.getFieldValueString(currindex,"EWDHH_SYSKEY");
					docCurStep = docHeaderListRetObj.getFieldValueString(currindex,"EWDHH_CURRENT_STEP");
				}
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date date = formatter.parse(modifiedOn);
				formatter = new SimpleDateFormat("dd/MM/yyyy");
				String modifiedOnDate = formatter.format(date);

				try{
				vendor=Integer.parseInt(vendor)+"";
				}
				catch(Exception e){vendor = vendorDtlsObj.getFieldValueString(i,"EVGD_VENDOR");}
						
%>				
				<tr >
				<td align="center" <%=color%>><a style='text-decoration:underline' href="javaScript:funClick('<%=docId%>','<%=vendor%>','<%=docSysKey%>','<%=docCurStep%>')"><%=docId%></a>&nbsp;</td>
				<td align="center" <%=color%>>
<%
				int index=-1;

				if(UserNamesRetObj!=null)
				{

					index=UserNamesRetObj.getRowId("EU_ID",vendor);
					vendorName=checkNull(UserNamesRetObj.getFieldValueString(index,"EU_FIRST_NAME"))+" "+checkNull(UserNamesRetObj.getFieldValueString(index,"EU_LAST_NAME"));

				}


%>				<%=vendorName%>	(<%=vendor%>)					

				&nbsp;</td>
				<td align="center" <%=color%>><%=modifiedOnDate%>&nbsp;</td>
				</tr>

<%
				
			}
%>
			 
			 </tbody>
			 </table>
		</div>
		<%
		}else{
		%>
		<div class="box-body" style="display: block;">
		<div class="col-md-12" >
			<div class="form-group">
			<label>No Requests To Act. </label> 
			</div>
		</div>	
		</div>
		<%
		}
		%>
	
	</div>
	</section><!-- /.content -->

       </div><!-- /.content-wrapper -->	
	
</form>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%>
<%@ include file="../Misc/ezDataTableScript.jsp"%>
   