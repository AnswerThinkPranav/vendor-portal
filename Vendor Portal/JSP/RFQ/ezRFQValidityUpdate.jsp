<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp"%>
<%@ page import= "java.sql.*,java.io.*" %>
<%@ page import = "ezc.ezparam.*,ezc.ezutil.*,java.util.*" %>
<%@ page import = "ezc.ezparam.ReturnObjFromRetrieve" %>
<%@ page import="ezc.ezpurchase.params.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />

<%
	ezc.ezpreprocurement.client.EzPreProcurementManager ezrfqmanager 	= new ezc.ezpreprocurement.client.EzPreProcurementManager();
	ezc.ezpreprocurement.params.EziRFQHeaderTable ezirfqheadertable 	= new ezc.ezpreprocurement.params.EziRFQHeaderTable();
	ezc.ezpreprocurement.params.EziRFQHeaderTableRow ezirfqheadertablerow   = new ezc.ezpreprocurement.params.EziRFQHeaderTableRow();
	EzcParams ezparams=new EzcParams(true);

	String rfqNum	= request.getParameter("rfqNum");
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
		Session.prepareParams(ezparams);

		ReturnObjFromRetrieve ret=(ReturnObjFromRetrieve)ezrfqmanager.ezSaveQuote(ezparams);

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
<Html>
<Head>
<Script>
	function funOK()
	{	
	

		document.myForm.action="ezListGenRFQs.jsp";
		document.myForm.submit();
		window.close();
		
	}
	
</Script>
</Head> 
<Body>
<Form name="myForm">
<input type="hidden" name="type" value="ToBeQuote">

	<Div style="position:absolute;top:40%;width:100%">
		<Center>
			<Font size="3" >
	
				<b><%=msg%></b>
		
			</Font>
		</Center>
	</Div>
	<Div id='ButtonDiv' align="center" style="position:absolute;left:0%;width:100%;top:90% ">
		<Center>
<%
			buttonName = new java.util.ArrayList();
			buttonMethod = new java.util.ArrayList();
			buttonName.add("Ok");
			buttonMethod.add("funOK()");
			out.println(getButtonStr(buttonName,buttonMethod));
%>	
    		</Center>
	</Div>
</Form>
</Body>
</Html>
