<%//@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="venTranManager" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="page"></jsp:useBean>
<%!
 	private String checkNull(String str)
 	{
 		if("null".equals(str) ||str==null)
 		str="";
 		return str;
 	}
 %>
 <%
	
	String compCode		=checkNull((String)Session.getUserPreference("COMPCODE"));
	String vendorNo 	=checkNull((String)Session.getUserId());	
	String doc 		=checkNull(request.getParameter("doc"));
	String ind      	=checkNull(request.getParameter("ind"));
	String postDate		=checkNull(request.getParameter("postDate"));
	String comments		=checkNull(request.getParameter("comments"));
	String creditNote	=checkNull(request.getParameter("creditNote"));
	String docDate		=checkNull(request.getParameter("docDate"));
	String grossAmt		= checkNull(request.getParameter("grossAmt"));
	ezc.ezutil.FormatDate formatDate = new ezc.ezutil.FormatDate();
	java.text.DateFormat formatter = new java.text.SimpleDateFormat("mm/dd/yyyy");
	
	String fdate=formatDate.getStringFromDate(new java.util.Date());
 
	java.text.DateFormat userDateFormat = new java.text.SimpleDateFormat("MM/dd/yyyy");   
	java.text.DateFormat dateFormatNeeded = new java.text.SimpleDateFormat("dd/MM/yyyy");   
	java.util.Date date = userDateFormat.parse(fdate);   
	java.util.Date date1 = userDateFormat.parse(docDate);  
	String creditDate = dateFormatNeeded.format(date); 
	String debitDate=dateFormatNeeded.format(date1);
	
	boolean status=false;
	ezc.ezcommon.EzLog4j.log("::creditDate::"+creditDate+">>>debitDate>>>"+debitDate,"I");
	int retSaveObjCnt=0;
	ezc.ezparam.ReturnObjFromRetrieve retShortAckObj=null,retSaveVenDet=null;
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false);
	ezc.vendortransactions.params.EzDebitCreditNotesParams ezDebitCreditNoteParams = new ezc.vendortransactions.params.EzDebitCreditNotesParams();
	ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyDCParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
	keyDCParams.setKey("SAVE_DEBIT_CREDIT_NOTES");
	mainParams.setLocalStore("Y");

	ezDebitCreditNoteParams.setVendor(checkNull(vendorNo));
	ezDebitCreditNoteParams.setCompCode(compCode.trim());
	ezDebitCreditNoteParams.setDebitNote(doc);
	ezDebitCreditNoteParams.setDebitNoteDate(debitDate);
	ezDebitCreditNoteParams.setCreditNote(creditNote);
	ezDebitCreditNoteParams.setCreditNoteDate(creditDate);
	ezDebitCreditNoteParams.setUpdatedBy(vendorNo);
	ezDebitCreditNoteParams.setComments(comments);
	ezDebitCreditNoteParams.setExt1("");
	ezDebitCreditNoteParams.setExt2("");
	ezDebitCreditNoteParams.setExt3("");
		
	mainParams.setObject(keyDCParams);
	mainParams.setObject(ezDebitCreditNoteParams);
	Session.prepareParams(mainParams);
	
	try{
		ezc.ezcommon.EzLog4j.log("::Before ezSaveVendorTransactions::::","I");
		venTranManager.ezSaveVendorTransactions(mainParams);
		ezc.ezcommon.EzLog4j.log("::After ezSaveVendorTransactions::::","I");
	}catch(Exception e){
	ezc.ezcommon.EzLog4j.log("::Exception::::"+e,"I");}
	
	
	 /***********For Getting status of Credit Note***********************/
	ezc.ezparam.ReturnObjFromRetrieve retVendTransObj=null;
	int retCount=0;
	ezc.ezparam.EzcParams mainParams_stat = new ezc.ezparam.EzcParams(false);
	int retVendTransCnt=0;
	ezc.vendortransactions.params.EzDebitCreditNotesParams ezDebitCreditNoteParams_stat = new ezc.vendortransactions.params.EzDebitCreditNotesParams();
	ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyShortParams_stat = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
	keyShortParams_stat.setKey("GET_DEBIT_CREDIT_NOTES");
	mainParams_stat.setLocalStore("Y");

	ezDebitCreditNoteParams_stat.setVendor(vendorNo+"')AND EDCN_DEBIT_NOTE='"+doc+"' AND EDCN_CREDIT_NOTE IN ('"+creditNote+"");


	mainParams_stat.setObject(keyShortParams_stat);
	mainParams_stat.setObject(ezDebitCreditNoteParams_stat);
	Session.prepareParams(mainParams_stat);

	try{
		ezc.ezcommon.EzLog4j.log("::Before ezGetVendorTransactions::::","I");
		retVendTransObj=(ezc.ezparam.ReturnObjFromRetrieve)venTranManager.ezGetVendorTransactions(mainParams_stat);

		ezc.ezcommon.EzLog4j.log("::After ezGetVendorTransactions::::"+retVendTransObj.toEzcString(),"I");

	}catch(Exception e){ezc.ezcommon.EzLog4j.log("::Exception::::"+e,"I");}

	if(retVendTransObj!=null || !"null".equals(retVendTransObj))
	retCount=retVendTransObj.getRowCount();
		
	/***********For Getting status of Credit Note**********************
	String msgText="";
	String msgSubject="";
	String ccMailIds= "";
	
	
	String stmtIdKey="GET_INT_USER_EMAIL";
	msgText+="Credit Note :"+creditNote+"&nbsp;maintained for Debit Note:"+doc;
	msgText+="<br>Click the <a href=http://115.113.5.184/  target=_blank>link </a> to process<BR>";
	msgSubject+="Credit Note confirmation for Debit Note ["+doc+"]";
	
		
	***********Mail Triggering*********************/
%>
<%//@ include file="../Misc/ezSendMail.jsp"%>

<%@ include file="../Misc/ezGetRoleEMails.jsp" %>
<%
	String msgSubject 	=  "Credit Note confirmation for the Debit Note:"+doc+" by Vendor :"+(String)session.getValue("Vendor");
	String msgText 		=  "Credit Note Confirmation for Debit Note ["+doc+"]";
	String toEMailIds 	= (String)eMailIdHT.get("FN");

	if(toEMailIds==null || "null".equals(toEMailIds))
		toEMailIds = "";


	ezc.ezcommon.EzLog4j.log("Credit Note Confirmation -- TOASNEMAILIDS>>>>>>>"+toEMailIds,"I");

%>
<%@ include file="../Misc/ezSendExternalMail.jsp" %>

<Html>
<Head>
<Title>Powered By EzCommerceInc.</Title>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp"%>
<Script src="../../Library/JavaScript/ezTabScroll.js"></Script>
<Script>

function funClose()
{
	
	//alert(opener.document.getElementById("Entry_"+<%=ind%>));
	opener.document.getElementById("Entry_"+<%=ind%>).innerHTML="View Credit Note";
	window.close();
}
function funUnload()
{
	if(<%=retCount%> >0)
	 {
		opener.document.getElementById("Entry_"+<%=ind%>).innerHTML="View Credit Note";
	}	
}
</Script>
</Head>

<Body leftborder=0 topborder=0 rightborder=0 onLoad='scrollInit()' onContextMenu="return false" onUnLoad='funUnload()' onresize='scrollInit()' scroll="no">
<Form name=myForm method=post>

<br><br>
<br><br>
<%
	String dispMessage="";
	if(retCount>0)
	 {
		dispMessage="Credit Note Saved";
	}
	else
	{
	      dispMessage="Problem while Saving details";
	}
%>	

	<DIV align="center" style="position:absolute;width:100%;top:30%">
		 <Table align="center" border=1 style="width:50%" borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=0>
		 	<Tr>
		 		<Th width="30%" nowrap><%=dispMessage%></Th>
		 	</Tr>
		 </Table>
	 </Div>	
<%
	if(retCount>0)
	 {
%>	 
	 <DIV id="ButtonsDiv" align="center" style="position:absolute;width:100%;top:60%;">
	 	 <%	
	 		buttonName = new java.util.ArrayList();
	 		buttonMethod = new java.util.ArrayList();
	 	
	 		buttonName.add("Ok");
	 		buttonMethod.add("funClose()");
	 		out.println(getButtonStr(buttonName,buttonMethod));
	 	 
	 	 %>
	 </Div>
<%

	}
%>

</Form>
<Div id="MenuSol"></Div>
</Body>
</Html>