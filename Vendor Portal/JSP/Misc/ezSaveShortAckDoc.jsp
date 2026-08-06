<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
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
	
	String matDocType	="A";//hardcoded
	String purOrg 		=checkNull((String)Session.getUserPreference("PURORG"));
	String purGrp		=checkNull((String)Session.getUserPreference("PURGROUP")); 
	String vendorNo 	=checkNull((String)Session.getUserId());	
	String doc		=checkNull(request.getParameter("doc"));
	String poNum		=checkNull(request.getParameter("poNum"));
	String poItemNum	=checkNull(request.getParameter("poItemNum"));
	String comments		=checkNull(request.getParameter("comments"));
	String ind		=checkNull(request.getParameter("ind"));
	String postDate		=checkNull(request.getParameter("postDate"));
	boolean status=false;
	java.text.DateFormat userDateFormat = new java.text.SimpleDateFormat("MM/dd/yyyy");  
	java.text.DateFormat dateFormatNeeded = new java.text.SimpleDateFormat("dd/MM/yyyy");   
	java.util.Date date1 = userDateFormat.parse(postDate);  
	ezc.ezcommon.EzLog4j.log("::Save Shortage Acknowledges::postDate::"+date1,"I");
	String ackDate=dateFormatNeeded.format(date1);
	int retSaveObjCnt=0;
	ezc.ezparam.ReturnObjFromRetrieve retShortAckObj=null,retSaveVenDet=null;
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false);
	ezc.vendortransactions.params.EzShortagesAckParams ezShortAckParams = new ezc.vendortransactions.params.EzShortagesAckParams();
	ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyShortParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
	keyShortParams.setKey("SAVE_SHORTAGES_ACK_INFO");
	mainParams.setLocalStore("Y");

	ezShortAckParams.setVendor(checkNull(vendorNo));
	ezShortAckParams.setMatDoc(doc);
	ezShortAckParams.setMatDocDate(ackDate);
	ezShortAckParams.setMatDocType(checkNull(matDocType));
	ezShortAckParams.setPoNo(poNum.trim());
	ezShortAckParams.setPoItemNo(poItemNum.trim());
	ezShortAckParams.setPurOrg(purOrg.trim());
	ezShortAckParams.setPurGrp(purGrp.trim());
	ezShortAckParams.setAckBy(vendorNo);
	ezShortAckParams.setComments(comments);
	ezShortAckParams.setExt1("ACK");
	ezShortAckParams.setExt2("");
	ezShortAckParams.setExt3("");
		
	mainParams.setObject(keyShortParams);
	mainParams.setObject(ezShortAckParams);
	Session.prepareParams(mainParams);
	
	try{
		ezc.ezcommon.EzLog4j.log("::Before ezSaveVendorTransactions::::","I");
		venTranManager.ezSaveVendorTransactions(mainParams);
		ezc.ezcommon.EzLog4j.log("::After ezSaveVendorTransactions::::","I");
	}catch(Exception e){
	ezc.ezcommon.EzLog4j.log("::Exception::::"+e,"I");}
	
	
	 /***********For Getting status of Material Document***********************/
	ezc.ezparam.ReturnObjFromRetrieve retVendTransObj=null;
	int retCount=0;
	ezc.ezparam.EzcParams mainParams_stat = new ezc.ezparam.EzcParams(false);
	int retVendTransCnt=0;
	ezc.vendortransactions.params.EzDebitCreditNotesParams ezShortAckParams_stat = new ezc.vendortransactions.params.EzDebitCreditNotesParams();
	ezc.vendortransactions.params.EzVendorTransactionsKeyParams keyShortParams_stat = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
	keyShortParams_stat.setKey("GET_SHORTAGES_ACK_INFO");
	mainParams_stat.setLocalStore("Y");

	ezShortAckParams_stat.setVendor(vendorNo+"')AND ESA_MAT_DOC='"+doc+"' AND ESA_PO_ITEM_NO IN ('"+poItemNum+"");


	mainParams_stat.setObject(keyShortParams_stat);
	mainParams_stat.setObject(ezShortAckParams_stat);
	Session.prepareParams(mainParams_stat);

	try{
		ezc.ezcommon.EzLog4j.log("::Before ezGetVendorTransactions::::","I");
		retVendTransObj=(ezc.ezparam.ReturnObjFromRetrieve)venTranManager.ezGetVendorTransactions(mainParams_stat);

		ezc.ezcommon.EzLog4j.log("::After ezGetVendorTransactions::::"+retVendTransObj.toEzcString(),"I");

	}catch(Exception e){ezc.ezcommon.EzLog4j.log("::Exception::::"+e,"I");}

	if(retVendTransObj!=null || !"null".equals(retVendTransObj))
	retCount=retVendTransObj.getRowCount();
		
	/***********For Getting status of Material Document***********************/
	/*****************Mail to buyer*****************/
	String msgText	  ="Material Document:"+doc+"has been acknowledged by the vendor"+vendorNo+".<br>";	
	String msgSubject ="Material document :"+doc+" acknowledged by the vendor"+vendorNo;
	String ccMailIds= "";
	String stmtIdKey="GET_INT_USER_EMAIL";
	/************Mail Triggering*********************/
%>
<%@ include file="../Misc/ezSendMail.jsp"%>
<Html>
<Head>
<Title>Powered By EzCommerceInc.</Title>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp"%>
<Script src="../../Library/JavaScript/ezTabScroll.js"></Script>
<Script>

function funClose()
{
	opener.document.getElementById("Entry_"+<%=ind%>).innerHTML="Acknowledged";
	window.close();
}
function funUnload()
{
	if(<%=retCount%> >0)
	 {
		opener.document.getElementById("Entry_"+<%=ind%>).innerHTML="Acknowledged";
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
		dispMessage="Material Document:<font color=red>"+doc+"</font>for Item :<font color=red>"+poItemNum+"</font>acknowledged";
		dispMessage+="<br>Mail has been sent to the respective buyer(s)";
	}
	else
	{
	      dispMessage="Problem while Acknowledging ";
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
	 	
	 		buttonName.add("Close");
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