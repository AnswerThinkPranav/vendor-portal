<jsp:useBean id="EzUploadManager" class="ezc.ezupload.client.EzUploadManager" scope="session" />
<%
	try{

		ezc.ezparam.EzcParams addMainParams = new ezc.ezparam.EzcParams(false);
		ezc.ezupload.params.EziUploadDocsParams addParams= new ezc.ezupload.params.EziUploadDocsParams();

		ezc.ezupload.params.EziUploadDocFilesTable tabParams= new ezc.ezupload.params.EziUploadDocFilesTable();
		ezc.ezupload.params.EziUploadDocFilesTableRow rowParams= null;

		java.util.Date dateToDB = new java.util.Date();	
		ezc.ezutil.FormatDate formatDateDB = new ezc.ezutil.FormatDate();
		ezc.ezcommon.EzLog4j.log(":::In SAVE upload111:::","I");
		String dateToDBStr = formatDateDB.getStringFromDate(dateToDB,"/",ezc.ezutil.FormatDate.DDMMYYYY);
		//ezc.ezcommon.EzLog4j.log(":::In SAVE filepath:::"+filepath,"I");
		addParams.setSysKey(currSysKey);
		addParams.setObjectType(uploadKey);
		addParams.setObjectNo(documentNo);
		addParams.setStatus("");
		addParams.setCreatedOn(dateToDBStr);
		addParams.setCreatedBy(Session.getUserId());
		addParams.setUploadDirectory(uploadTempDir);
		addMainParams.setObject(addParams);
		ezc.ezcommon.EzLog4j.log(":::In SAVE upload2222::","I");
		rowParams= new ezc.ezupload.params.EziUploadDocFilesTableRow();
		rowParams.setType(uploadKey);                                                   
		rowParams.setClientFileName(fileName);
		tabParams.appendRow(rowParams);

		addMainParams.setObject(tabParams);
		Session.prepareParams(addMainParams);
		EzUploadManager.uploadDoc(addMainParams);
		ezc.ezcommon.EzLog4j.log(":::In SAVE filepath:::"+uploadTempDir,"I");
	}
	catch(Exception e)
	{
	      //out.println(":::EEEE:::"+e);
	      ezc.ezcommon.EzLog4j.log("Error in uploading>>>>::::::"+e,"I");
	}
	
%>