<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp"%>
<%@ page import= "java.sql.*,java.io.*" %>
<%@ page import = "ezc.ezparam.*,ezc.ezutil.*,java.util.*" %>
<%@ page import = "ezc.ezparam.ReturnObjFromRetrieve" %>
<%@ page import="ezc.ezpurchase.params.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%

	String rfqNum=request.getParameter("RFQNo");
	String updateFlag =request.getParameter("Update");	
	
	if(updateFlag==null || "null".equals(updateFlag) || "".equals(updateFlag)) updateFlag="N";
	
%>	
<Html>
<Head>
<Script>
	function getDefaultsFromTo()
	{
		var updateFlag = '<%=updateFlag%>';
		toDate = new Date();
		today = toDate.getDate();
		thismonth = toDate.getMonth()+1;
		thisyear = toDate.getYear();
		if(today < 10)
			today = "0"+today;
		if(thismonth < 10)
			thismonth = "0" + thismonth;
		if(updateFlag=="N")	
		document.myForm.toDate.value = thismonth+"/"+today+"/"+thisyear;
	}
	
	function funSubmit()
	{
		var y = confirm("Are you sure to extend the QCF");

		if(y)
		{
		document.myForm.Update.value="Y";
		document.myForm.submit();

			 //window.showModalDialog("../RFQ/ezRFQValidityUpdate.jsp?rfqNum=<%=rfqNum%>&toDate="+document.myForm.toDate.value,"myWin","dialogWidth:600px; dialogHeight:218px; center:yes ;scroll:no;Resizable:no");
			 
		}	
	}
	function funOK()
	{	


		opener.document.myForm.action="ezListGenRFQs.jsp";
		opener.document.myForm.submit();
		window.close();
			
	}
</Script>
</Head>
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<Body onLoad='getDefaultsFromTo();'>
<Form name="myForm">
<input type="hidden" name="type" value="ToBeQuote">

<input type=hidden name="Update" value="N"> 
<input type="hidden" name="RFQNo" value="<%=rfqNum%>">

<%
if("N".equals(updateFlag))
{
%>
	<Div style="position:absolute; top:15%; left:20%"  >
		<Table  align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0 width="75%">
			<Tr>		
				<Th colSpan=4>Select Date for Extension</Th>
			</Tr>
			<Tr>
				<Th width="20%">RFQ Num</Th>
				<Td width="30%">&nbsp;&nbsp;&nbsp;<%=rfqNum%></Td>
				<Td width="30%"><nobr><input type=text class = "InputBox" name="toDate" size=11 value="" readonly onfocus=this.blur()>
					<%=getDateImageFromToday("toDate")%> 
				</nobr></Td>
				
			</Tr>	
		</Table>
	</Div>
	
	<Div id='ButtonDiv' align="center" style="position:absolute;left:0%;width:100%;top:80%">
			<Center>
	<%
				buttonName = new java.util.ArrayList();
				buttonMethod = new java.util.ArrayList();
				buttonName.add("Update");
				buttonMethod.add("funSubmit()");		
				buttonName.add("Cancel");
				buttonMethod.add("window.close()");
				out.println(getButtonStr(buttonName,buttonMethod));
	%>	
	    		</Center>
	</Div>
<%
}else{
	ezc.ezpreprocurement.client.EzPreProcurementManager ezrfqmanager 	= new ezc.ezpreprocurement.client.EzPreProcurementManager();
	ezc.ezpreprocurement.params.EziRFQHeaderTable ezirfqheadertable 	= new ezc.ezpreprocurement.params.EziRFQHeaderTable();
	ezc.ezpreprocurement.params.EziRFQHeaderTableRow ezirfqheadertablerow   = new ezc.ezpreprocurement.params.EziRFQHeaderTableRow();	
	ezc.ezpreprocurement.params.EziRFQItemServiceTable  serTable	= new ezc.ezpreprocurement.params.EziRFQItemServiceTable();
	ezc.ezpreprocurement.params.EziPOItemTable 	itemTable = new ezc.ezpreprocurement.params.EziPOItemTable();	
	ezc.ezpreprocurement.params.EziPOCondTable condTable	= new ezc.ezpreprocurement.params.EziPOCondTable();
	ezc.ezpurchase.params.EzBapieslltxTable  txtTable 	= new ezc.ezpurchase.params.EzBapieslltxTable();


	EzcParams ezparams=new EzcParams(true);

	String toDate	= request.getParameter("toDate");

	ezc.ezcommon.EzLog4j.log("rfqNum>>>"+rfqNum,"D");
	ezc.ezcommon.EzLog4j.log("toDate>>>"+toDate,"D");

	String errFlg = "Y";
	String msg = "Probelm occured while extending RFQ validity date.";

	if(rfqNum!=null && !"".equals(rfqNum) && toDate!=null)
	{

		java.util.Date QuoteExpDate = new java.util.Date(); 
		QuoteExpDate.setDate(Integer.parseInt(toDate.substring(3,5)));
		QuoteExpDate.setMonth(Integer.parseInt(toDate.substring(0,2))-1);
		QuoteExpDate.setYear(Integer.parseInt(toDate.substring(6,10))-1900);

		ezirfqheadertablerow.setRFQNo(rfqNum); 
		ezirfqheadertablerow.setDocType("A");
		ezirfqheadertablerow.setQuotationendDate(QuoteExpDate);

		ezirfqheadertable.appendRow(ezirfqheadertablerow);

		ezparams.setObject(ezirfqheadertable);
		ezparams.setObject(itemTable);
		ezparams.setObject(serTable);
		ezparams.setObject(txtTable);
			
		ezparams.setObject(condTable);
		Session.prepareParams(ezparams);

		ReturnObjFromRetrieve ret= null;
		
		try{
			ret=(ReturnObjFromRetrieve)ezrfqmanager.ezSaveQuote(ezparams);
			errFlg = "N";
		}
		catch(Exception e)
		{
			ezc.ezcommon.EzLog4j.log("exception>>>>>>>"+e,"D");
			msg = "Probelm occured while extending RFQ validity date in SAP.";
		}

		ezc.ezcommon.EzLog4j.log("ret>>>"+ret.toEzcString(),"D");


		for ( int i=0;i<ret.getRowCount();i++)
		{
			String Msg = ret.getFieldValueString(i,"MSG");
			String Type = ret.getFieldValueString(i,"TYPE");
			String Code = ret.getFieldValueString(i,"CODE");
			String MsgNo = ret.getFieldValueString(i,"MSGNO");

			System.out.println(Type);
			System.out.println(Msg);
			ezc.ezcommon.EzLog4j.log("Msg>>>"+Msg+"Type>>>"+Type,"D");
			if ("E".equalsIgnoreCase(Type.trim()))
			{
				errFlg = "Y";
				msg = "Probelm occured while extending RFQ validity date in SAP.";
			}
		}



		Connection connection = null;
		Statement stmt = null;
		
		

		if(!"Y".equals(errFlg))	
		{

			try
			{
				java.util.ResourceBundle siteProps_A = java.util.ResourceBundle.getBundle("Site");
				String SiteNo_A = siteProps_A.getString("DBGRP");
				Class.forName(siteProps_A.getString("Driver_"+SiteNo_A));
				connection = DriverManager.getConnection(siteProps_A.getString("ConnectString_"+SiteNo_A),siteProps_A.getString("UserId_"+SiteNo_A),siteProps_A.getString("Password_"+SiteNo_A));
				stmt = connection.createStatement();
				String updateQuery ="UPDATE EZC_RFQ_HEADER SET ERH_VALID_UPTO=TO_DATE('"+toDate+"','mm/dd/yyyy') WHERE ERH_RFQ_NO='"+rfqNum+"'";
				stmt.executeUpdate(updateQuery);
				connection.commit();
				ezc.ezcommon.EzLog4j.log("updateQuery>>>"+updateQuery,"D");

				msg = "Validity of the given RFQ has been Extended Succesfully.";
			}
			catch(Exception e)
			{
				System.out.println(e);
			}
			finally
			{
				stmt.close();
				connection.close();
			}
		}	
	}	
		
%>
<Div>
	<Div style="position:center;top:40%;width:100%">
		<Center>
			<Font size="3" >
	
				<b><%=msg%></b>
		
			</Font>
		</Center>
	</Div>
	<Div id='ButtonDiv' align="center" style="position:absolute;left:0%;width:100%;top:50% ">
		<Center>
<%
			buttonName = new java.util.ArrayList();
			buttonMethod = new java.util.ArrayList();
			buttonName.add("Ok");
			buttonMethod.add("funOK()");
			out.println(getButtonStr(buttonName,buttonMethod));
%>	
    		</Center>
	</Div></Div>
<%
}
%>
	
</Form>      
</Body> 
</Html>
