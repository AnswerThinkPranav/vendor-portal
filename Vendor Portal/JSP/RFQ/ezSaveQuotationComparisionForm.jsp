<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>   
<%@ include file="../Misc/ezCommonMethods.jsp"%>
<%@ include file="../Misc/ezHeader.jsp"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ page import ="ezc.ezparam.*,java.util.*,java.text.*,java.nio.file.*" %> 
<%@ page import="ezc.ezshipment.params.*" %>
<%@ page import="ezc.ezpurchase.params.*" %>
<%@ page import="ezc.ezshipment.client.*" %>
<jsp:useBean id="Manager" class="ezc.ezpreprocurement.client.EzPreProcurementManager" />
<%@ include file="../../../Includes/JSPs/Misc/iDocComments.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCommonMethods.jsp"%> 
<%@ include file="../../../Includes/JSPs/Inbox/iGetUploadTempDir.jsp" %>
<%
	//WORKFLOW CONFIGURATIONCHECK
	
 	String plant  		= request.getParameter("plant");
	String compCode 	= request.getParameter("compCode");
	String category 	= request.getParameter("category");
	String noDataStatement = "";
	String display_header  = "Confirmation";
	//out.print("category::"+category);
	/*if("4500".equals(compCode))
	{
		category = "RM_PM";
	}*/
	if(!"NA".equals(category))
	{
		EzcParams ezparams=new EzcParams(true);
		EzShipmentManager shManager=new EzShipmentManager();
		String comments = request.getParameter("comment");
		String qcfNo = request.getParameter("qcfNo");
		String chkVal = checkNull(request.getParameter("chkVal"));
		String rank = request.getParameter("rank");
		String docVal = checkNull(request.getParameter("botDocVal"+qcfNo));
		//String reason = request.getParameter("reason"); 
		int chkLen=0;
		if(!"".equals(chkVal))
		{
		chkLen=chkVal.split(",").length;
		}
		ezc.ezcommon.EzLog4j.log("chkVal>>>>>"+chkVal+">>rank>"+rank+"<<chkLen>>"+chkLen,"I");

		String rfqItems[]	= request.getParameterValues("rfqItem");	
		int rfqItemsCnt = 0;

		if(rfqItems!=null)
			rfqItemsCnt = rfqItems.length;

		ezc.ezcommon.EzLog4j.log("rfqItemsCnt=====**"+rfqItemsCnt,"I");	


		String retMsg = "Quotation Approved in Portal";

		//String qtyRec		="";
		String outputSts = "E";

		/***********Added to update status to S if Selected***********/
		ezc.ezcommon.EzLog4j.log("****==before Update RFQ Details=====**","I");
		ezc.ezparam.EzcParams updateRFQParams	= new ezc.ezparam.EzcParams(false);
		ezc.ezpreprocurement.params.EziRFQHeaderTable updateezirfqheadertable	= new ezc.ezpreprocurement.params.EziRFQHeaderTable();
		ezc.ezpreprocurement.params.EziRFQHeaderTableRow updateezirfqheadertablerow   = new ezc.ezpreprocurement.params.EziRFQHeaderTableRow();

		ezc.ezpreprocurement.params.EziRFQItemQtyTable      updateezirfqqtystable = new ezc.ezpreprocurement.params.EziRFQItemQtyTable();
		ezc.ezpreprocurement.params.EziRFQItemQtyTableRow   updateezirfqqtystablerow =  new ezc.ezpreprocurement.params.EziRFQItemQtyTableRow();			


		for(int i=0;i<chkLen;i++)
		{
			String rfqNO=chkVal.split(",")[i].split("#")[0];
			//String reason=chkVal.split(",")[i].split("#")[1];
			String recTotVal = checkNull(request.getParameter("botTotVal"+rfqNO));

			updateezirfqheadertablerow   = new ezc.ezpreprocurement.params.EziRFQHeaderTableRow();
			updateezirfqheadertablerow.setRFQNo(rfqNO); 
			//updateezirfqheadertablerow.setStatus("S',ERH_RANK='"+rank+"',ERH_REASON='"+reason); 
			updateezirfqheadertablerow.setStatus("S',ERH_RANK='"+rank+"',ERH_FINAL_VALUE='"+docVal+"',ERH_REC_VALUE='"+recTotVal); 
			updateezirfqheadertablerow.setModifiedBy(Session.getUserId()); 
			updateezirfqheadertable.appendRow(updateezirfqheadertablerow);


			for(int j=0;j<rfqItemsCnt;j++)
			{
				String rfqItem = ((j+1)*10)+"";
				ezc.ezcommon.EzLog4j.log("rfqItem=====**"+rfqItem,"I");
				String qtyRec	= checkNull(request.getParameter("rfqQty"+rfqNO+((j+1)*10)));
				ezc.ezcommon.EzLog4j.log("LineItem=====**"+j,"I");
				ezc.ezcommon.EzLog4j.log("qtyRec=====**"+qtyRec,"I");

				updateezirfqqtystablerow =  new ezc.ezpreprocurement.params.EziRFQItemQtyTableRow();		
				updateezirfqqtystablerow.setRemarks("test',ERD_PO_QTY='"+qtyRec);
				updateezirfqqtystablerow.setRFQNo(rfqNO);
				updateezirfqqtystablerow.setItmNo(rfqItem);
				updateezirfqqtystable.appendRow(updateezirfqqtystablerow);	

			}		

			try
			{		
				updateRFQParams.setObject(updateezirfqheadertable);
				updateRFQParams.setObject(updateezirfqqtystable);
				updateRFQParams.setLocalStore("Y");
				Session.prepareParams(updateRFQParams);
				ezc.ezcommon.EzLog4j.log("****==before Update RFQ Details=====**","I");
				Manager.ezUpdateRFQ(updateRFQParams);
				ezc.ezcommon.EzLog4j.log("****==After Update RFQ Details=====**","I");
			}
			catch(Exception e)	
			{

			}
			outputSts = "S";
		}


		//FILE UPLOAD for QCS
		String objNo="";
		String documentType="";
		String[] lineAttachString=null;	

		lineAttachString = request.getParameterValues("fileItem");
		ezc.ezcommon.EzLog4j.log("qcfNo>>>>>"+qcfNo,"I");  
		ezc.ezcommon.EzLog4j.log("lineAttachString>>>>>"+lineAttachString,"I"); 

		if(lineAttachString != null)
		{ 
			objNo 		= qcfNo;
			documentType 	= "QCF"; 

				ezc.ezparam.EzcParams mainParams2 = new ezc.ezparam.EzcParams(false); 				
				ezc.misctransactions.client.EzMiscTransactionsManager miscMgr2 = new ezc.misctransactions.client.EzMiscTransactionsManager();
				ezc.misctransactions.params.EzMiscTable miscTable2 = new ezc.misctransactions.params.EzMiscTable();
				//for(int x=0;x<selectedPRsCnt;x++)
				//{
					String fileItemIndex = "H";
					String fileItem[]	= request.getParameterValues("fileItem"); 
					int fileLength = 0;
					if(fileItem != null)
						fileLength = fileItem.length;
						ezc.ezcommon.EzLog4j.log("**fileLength>>"+fileLength,"I");

					if(fileLength > 0)
					{
						String subDirPath = "QCF"+"\\"+qcfNo+"\\"+fileItemIndex+"\\";
						String dirPath  = serverUpPath+subDirPath;
						String sessionId = session.getId()+"";
						Path path = Paths.get(dirPath);
						Files.createDirectories(path);
						for(int j=0;j<fileItem.length;j++)
						{
							try
							{
								String fileName = fileItem[j];	
								ezc.ezcommon.EzLog4j.log("**fileName>>"+fileName,"I");
								File notifSourceFile = new File(inboxPath+sessionId+"\\"+fileItemIndex+"\\"+fileName);
								File notifDestFile = new File(dirPath+fileName);
								fileItem[j]=fileName.replace('\'','`');
								ezc.ezcommon.EzLog4j.log("**AAAfileName>>"+fileName,"I");
								FileInputStream inStream = new FileInputStream(notifSourceFile);
								FileOutputStream outStream = new FileOutputStream(notifDestFile);
								byte[] buffer = new byte[1024];
								int length;
								//copy the file content in bytes 
								while ((length = inStream.read(buffer)) > 0)
								{
									outStream.write(buffer, 0, length);
								}
								inStream.close();
								outStream.close();
								notifSourceFile.delete();		
								ezc.misctransactions.params.EzMiscTableRow miscTableRow2 = new ezc.misctransactions.params.EzMiscTableRow();
								miscTableRow2.setQuery("INSERT INTO EZC_UPLOAD_DOCUMENT(EUD_DOC_NO,EUD_ITEM_NO,EUD_DOC_TYPE,EUD_FILE_NAME,EUD_SERVER_FILE_NAME,EUD_UPLOADED_ON,EUD_UPLOADED_BY) VALUES('"+qcfNo+"','"+fileItemIndex+"','QCF','"+fileItem[j]+"','"+(subDirPath+fileItem[j])+"',NOW(),'"+(String)Session.getUserId()+"')");
								miscTable2.appendRow(miscTableRow2);
							}catch(Exception e)
							{

							}
						}
					}
				//}
				mainParams2.setLocalStore("Y");
				mainParams2.setObject(miscTable2);
				Session.prepareParams(mainParams2);
				try
				{
				miscMgr2.ezSaveMiscTransactions(mainParams2);

				}
				catch(Exception e)
				{
				} 				

				
		}	
		
		if("S".equals(outputSts))
		{
%>	
			<%@ include file="ezSaveQCFWF.jsp"%> 

<%	
		}


	}
	else
	{
		noDataStatement = "No Workflow exists for the selected defaults.<br>Please Contact System Administrator";
			
			
	}

%>
<html>
<head>
<style>
.table>tbody>tr>td, .table>tbody>tr>th, .table>tfoot>tr>td, .table>tfoot>tr>th, .table>thead>tr>td, .table>thead>tr>th {

    line-height: inherit !important;
}
th
{	
    color: white;
    background: #325786;
	
}
</style>
<body scroll=no>
<%@ include file="../Misc/ezSubHeader.jsp"%>		
<div class="box" style="padding: 13px;">
<div class="row">
<div class="col-xs-12 table-responsive">	    

<div class="alert alert-success">
<%=noDataStatement%>
</div>

	<button type="button" class="btn btn-primary" onclick="checkList()">Ok</button>  &nbsp;	

</div>
</div>
</div>
</body>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%>

</html>
<script>
	function checkList()
	{
		location.href="../Misc/ezBuyerWelcome.jsp";
	}
</script>
		   


