<%@ page import="ezc.ezparam.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ include file="../../../Includes/JSPs/Inbox/iGetUploadTempDir.jsp"%>
<%@ page import = "java.io.*"%>
<%
	boolean successFlg = true;	
	String upDocId = request.getParameter("upDocId");
	String upDocType = request.getParameter("upDocType");
	String upItemNo = request.getParameter("upItemNo");
	String fileName = request.getParameter("fileName");

	String pathName = upDocType+"\\"+upDocId+"\\"+upItemNo+"\\"+fileName;
	String fileReqName         = serverUpPath+""+pathName;
	ezc.ezcommon.EzLog4j.log("fileReqName:::"+fileReqName,"I");
	try
	{
		File csFilesDir = new File(fileReqName);        
		csFilesDir.delete();  
	}
	catch(Exception e)
	{
		successFlg = false;	
	}	
	if(successFlg)
   	{
	
		ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
		ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
		ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
		ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		miscTableRow.setQuery("DELETE FROM EZC_UPLOAD_DOCUMENT WHERE EUD_DOC_NO='"+upDocId+"' AND EUD_ITEM_NO='"+upItemNo+"' AND EUD_DOC_TYPE='"+upDocType+"' AND EUD_FILE_NAME='"+fileName+"'");
		miscTable.appendRow(miscTableRow);
		mainParams.setLocalStore("Y");
		mainParams.setObject(miscTable);
		Session.prepareParams(mainParams);
		try
		{
			miscMgr.ezSaveMiscTransactions(mainParams);

		}
		catch(Exception e)
		{
		}
		
	}
	out.print(successFlg);
%>

