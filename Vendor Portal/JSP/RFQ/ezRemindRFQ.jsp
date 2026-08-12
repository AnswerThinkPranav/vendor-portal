<%@ page import ="java.util.*"%>
<%@ page import = "ezc.ezutil.FormatDate"%> 
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>   
<%@ include file="../Misc/ezHeader.jsp"%>  
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ include file="../Misc/ezDefaultDate.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCommonMethods.jsp"%> 
<%@include file="../../../Includes/JSPs/Rfq/iViewRFQDetails.jsp"%>
<%!
 	private String checkNull(String str)
 	{
 		if("null".equals(str) ||str==null)
 			str="";
 		else
 			str = str.replaceAll("'","`");
 		
 		return str;
 	}
 	private String checkNull_Num(String str)
	 {
		if("null".equals(str) ||str==null || "".equals(str))  
			str="0";
		
		return str;
 	}
%>
<%
	String eMailData1 = "", msgQuoteMailSub = "",toEmailStr = "",ccEmailStr = "";
	String type=request.getParameter("type");
	String rfqType=request.getParameter("rfqType");
	String rfqNumber=request.getParameter("PurchaseOrder");
	String contNO=getUserContact(Session,(String)Session.getUserId());
	ezc.ezutil.FormatDate formatDate = new ezc.ezutil.FormatDate();
	
	toEmailStr = getVendorMail(Session,rfqVendor);
	ccEmailStr = getUserMail(Session,(String)Session.getUserId());
	ezc.ezcommon.EzLog4j.log("toEmailStr in Quote Reminder>>>"+toEmailStr,"I"); 
	ezc.ezcommon.EzLog4j.log("ccEmailStr in Quote Reminder>>>"+ccEmailStr,"I");	
	
	ezc.ezcommon.EzLog4j.log("Count in Reminder>>>"+Count,"I");
	ezc.ezcommon.EzLog4j.log("type>>>"+type,"I");
	
	//REMINDER MAIL
	Hashtable<String,String> plantHT = getPlants(Session); 	
	
	ResourceBundle site=null;
	site= ResourceBundle.getBundle("Site");
	String link = site.getString("PORTAL_URL");		
	
	String spaceCon 	="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
	String bgColor = "bgcolor=\"#FFFFFF\"";
	String thBGColor = "style=\"background-color: #015488;color: #FFFFFF;font-family: arial,sans-serif;font-size: 12px\""; 
	String tdBGColor = "style=\"background-color: #EDF1F4;\"";		

	String eMailData="";
	eMailData +=  "<Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0><Tr>";
	eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Line</B></Th>";
	eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Plant</B></Th>";
	eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Ref.PR</B></Th>";
	eMailData +=  "<Th width= \"20%\" "+thBGColor+"><B>Material</B></Th>";
	eMailData +=  "<Th width= \"30%\" "+thBGColor+"><B>Description</B></Th>";
	eMailData +=  "<Th width= \"5%\" "+thBGColor+"><B>Qty</B></Th>";
	eMailData +=  "<Th width= \"5%\" "+thBGColor+"><B>UOM</B></Th>";
	eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Delivery Date</B></Th>";
	eMailData +=  "<Th width= \"10%\" "+thBGColor+"><B>Quotation End Date</B></Th>";
	eMailData +=  "</Tr>";	
	
	String rfqLineItem= "";
	String rfqPlant="";
	String rfqPr="";
	String rfqMat="";
	String rfqMatDesc="";	
	String rfqItemQty="";
	String rfqUom="";	
	String rfqDelDt="";
	String rfqEndDt="";
	
	for(int i=0;i<Count;i++)
   	{
   		String refPrStr= dtlXML.getFieldValueString(i,"ERD_EXT1");
		String myQty = dtlXML.getFieldValueString(i,"ERD_QUANTITY");
		String tmpDelDt = formatDate.getStringFromDate((java.util.Date)dtlXML.getFieldValue(i,"ERH_VALID_UPTO"),(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
		String tmpEndDt = formatDate.getStringFromDate((java.util.Date)dtlXML.getFieldValue(0,"ERD_DELIVERY_DATE"),(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
		try
		{
			myQty = (Double.parseDouble(myQty))+"";
			myQty  = new java.math.BigDecimal(myQty).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
		}
		catch(Exception e){}	      	

		rfqLineItem	= checkNull(dtlXML.getFieldValueString(i, "ERD_LINE_NO"));  
		rfqPlant	= checkNull(dtlXML.getFieldValueString(i,"ERD_PLANT"));
		rfqPr		= refPrStr;
		try
		{
			rfqMat		= checkNull(Long.parseLong(dtlXML.getFieldValueString(i,"ERD_MATERIAL"))+"");
		}catch(Exception e)
		{
			rfqMat ="NA";
		}
		rfqMatDesc	= checkNull(dtlXML.getFieldValueString(i,"ERD_MATERIAL_DESC"));	
		rfqItemQty	= checkNull(myQty);
		rfqUom  	= checkNull(dtlXML.getFieldValueString(i,"ERD_UOM"));
		rfqDelDt	= tmpDelDt;
		rfqEndDt	= tmpEndDt;

		eMailData +=  "<Tr "+bgColor+"><Td width= \"10%\" "+tdBGColor+"  align='center'>"+rfqLineItem+"</Td>"; 
		eMailData +=  "<Td width= \"10%\" "+tdBGColor+" align='center'>"+plantHT.get(rfqPlant)+"</Td>";		
		eMailData +=  "<Td width= \"10%\" "+tdBGColor+"  align='center'>"+rfqPr+"</Td>";
		eMailData +=  "<Td width= \"20%\" "+tdBGColor+"  align='center'>"+rfqMat+"</Td>";
		eMailData +=  "<Td width= \"30%\" "+tdBGColor+"  align='center'>"+rfqMatDesc+"</Td>";
		eMailData +=  "<Td width= \"5%\" "+tdBGColor+"  align='center'>"+rfqItemQty+"</Td>";
		eMailData +=  "<Td width= \"5%\" "+tdBGColor+"  align='center'>"+rfqUom+"</Td>";
		eMailData +=  "<Td width= \"10%\" "+tdBGColor+"  align='center'>"+rfqDelDt+"</Td>";
		eMailData +=  "<Td width= \"10%\" "+tdBGColor+"  align='center'>"+rfqEndDt+"</Td>"; 
		eMailData +=  "</Tr>";
	}
	eMailData +=  "</Table><Br>";				
		
	if("Req".equals(type))
	{
		eMailData1 = "Dear Sir/Madam,<Br><Br>This is a reminder to re-quote the RFQ :"+rfqNumber+"  from Jubilant Ltd.<Br>"; 
		eMailData1 += "Please re-quote the RFQ:"+rfqNumber+"  against the below details.<BR><BR>";
	}	
	else if("List".equals(type))
	{
		eMailData1 = "Dear Sir/Madam,<Br><Br>This is a reminder to quote the RFQ :"+rfqNumber+"  from Jubilant Ltd.<Br>"; 
		eMailData1 += "Please quote the RFQ:"+rfqNumber+"  against the below details.<BR><BR>";
	}	
	eMailData1 += eMailData;
	eMailData1 += "<BR><BR>"+"Quotations received via Email or any other media will not be considered for this RFQ<Br>";
	eMailData1 += "<b><a href ="+link	+">Click Here</a>  to login into Vendor Portal\n</b><br><br>";
	//eMailData1 += "<br>Regards, \n<br><b>" + v_fullName + "[" +Session.getUserId()+"].</b><br>"+contNO+".<br><br>";

	if("Req".equals(type))
		msgQuoteMailSub = "Reminder for Re-Quote against RFQ:"+rfqNumber;
	else if("List".equals(type))	
		msgQuoteMailSub = "Quote Reminder against RFQ:"+rfqNumber;

	ezc.ezcommon.EzLog4j.log("msgQuoteMailSub in RE-QUOTE11>>>"+msgQuoteMailSub,"I");

	//sendMail(Session,"hchowdary@answerthink.com","hchowdary@answerthink.com","",eMailData1,msgQuoteMailSub); 
	sendMail(Session,toEmailStr,ccEmailStr,"",eMailData1,msgQuoteMailSub); 

		
	
%>