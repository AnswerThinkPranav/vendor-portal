<jsp:useBean id="EzUploadManager" class="ezc.ezupload.client.EzUploadManager" scope="session" />
<%@ include file="../../../Includes/JSPs/Materials/iGetUploadTempDir.jsp" %>

<%
	try{

		ezc.ezparam.EzcParams addMainParams = new ezc.ezparam.EzcParams(false);
		ezc.ezupload.params.EziUploadDocsParams addParams= new ezc.ezupload.params.EziUploadDocsParams();

		ezc.ezupload.params.EziUploadDocFilesTable tabParams= new ezc.ezupload.params.EziUploadDocFilesTable();
		ezc.ezupload.params.EziUploadDocFilesTableRow rowParams= null;

		java.util.Date dateToDB = new java.util.Date();	
		ezc.ezutil.FormatDate formatDateDB = new ezc.ezutil.FormatDate();
		String dateToDBStr = formatDateDB.getStringFromDate(dateToDB,"/",ezc.ezutil.FormatDate.DDMMYYYY);

		addParams.setSysKey(currSysKey.trim());
		addParams.setObjectType(uploadKey.trim());
		addParams.setObjectNo(documentNo.trim());
		addParams.setStatus("");
		addParams.setCreatedOn(dateToDBStr);
		addParams.setCreatedBy(Session.getUserId());
		addParams.setUploadDirectory(uploadTempDir+session.getId());
		addMainParams.setObject(addParams);

		rowParams= new ezc.ezupload.params.EziUploadDocFilesTableRow();
		rowParams.setType(uploadKey);                                                   
		rowParams.setClientFileName(fileName);
		tabParams.appendRow(rowParams);
		ezc.ezcommon.EzLog4j.log("currSysKey>>>>::::::"+currSysKey,"I");
		ezc.ezcommon.EzLog4j.log("uploadKey>>>>::::::"+uploadKey,"I");
		ezc.ezcommon.EzLog4j.log("documentNo>>>>::::::"+documentNo,"I");
		ezc.ezcommon.EzLog4j.log("fileName>>>>::::::"+fileName,"I");
		
		addMainParams.setObject(tabParams);
		Session.prepareParams(addMainParams);
		EzUploadManager.uploadDoc(addMainParams);
	}
	catch(Exception e)
	{
	      //out.println(":::EEEE:::"+e);
	      ezc.ezcommon.EzLog4j.log("Error in uploading>>>>::::::"+e,"I");
	}
%>