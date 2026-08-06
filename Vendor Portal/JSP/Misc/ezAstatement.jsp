<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>  
<%@ include file="../Misc/ezHeader.jsp"%> 
<%@ include file="../Misc/ezVendorCompanyCodes.jsp" %> 
<%@ page import="java.util.*" %>
<%@ include file="../../../Includes/JSPs/Labels/iAstatement_Labels.jsp"%>
<%@ page import="ezc.ezparam.*" %>       
    
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ include file="../../../Includes/JSPs/Misc/iMultiVendorDetails.jsp" %>
<%@ include file="../../../Includes/JSPs/Misc/iEzDateConvertion.jsp" %>
<link rel="stylesheet" href="../Misc/library/fancybox2/jquery.fancybox.css" type="text/css" media="screen" />
<%@ include file="../Misc/ezGetVendorCodesAndNames.jsp"%> 

<%

	Hashtable paymentMthDescHT = new Hashtable();
	paymentMthDescHT.put("0","Demand Drafts-KBL - 1601");
	paymentMthDescHT.put("1","Demand Drafts-KBL - 2311");
	paymentMthDescHT.put("2","Demand Draft-KBL-2197");
	paymentMthDescHT.put("3","Demand Drafts-KBL - 2532");
	paymentMthDescHT.put("4","Demand Drafts-KBL - 2533");
	paymentMthDescHT.put("5","Demand Drafts-SBI C/a");
	paymentMthDescHT.put("A","Cheque-for KBL -1601");
	paymentMthDescHT.put("B","Cheque-for KBL -2311");
	paymentMthDescHT.put("C","Cheque");
	paymentMthDescHT.put("D","Demand Drafts");
	paymentMthDescHT.put("E","Cash Payment");
	paymentMthDescHT.put("F","Cheue-for-KBL-2197");
	paymentMthDescHT.put("G","Cheque-for KBL -2532");
	paymentMthDescHT.put("H","Cheque-for KBL -2533");
	paymentMthDescHT.put("I","Cheque-for SBI C/a");
	paymentMthDescHT.put("K","RTGS Payment");
	paymentMthDescHT.put("T","Bank Transfer");
	paymentMthDescHT.put("W","BOE - India");
	
	

	ezc.ezutil.FormatDate formatDate = new ezc.ezutil.FormatDate();
	String ShowData = request.getParameter("ShowData");
	if(ShowData == null)
		ShowData = "N";
	else
		ShowData = "Y";
	ShowData = "Y";	
	ezc.ezbasicutil.EzCurrencyFormat myFormat= new ezc.ezbasicutil.EzCurrencyFormat();
	myFormat.setLocale((java.util.Locale)session.getValue("LOCALE"));
	myFormat.setNeedSybmol(((Boolean)session.getValue("SREQUIRED")).booleanValue());
	myFormat.isPre(((Boolean)session.getValue("CPOSITION")).booleanValue());
	myFormat.setSymbol((String)session.getValue("CURRENCY"));
	String base 	= request.getParameter("FromForm");
	String fd 	= request.getParameter("FromDate");
	String td 	= request.getParameter("ToDate");
	
	if(fd== null && td == null)
	{
		Date toDateObj=new Date();
		String toDay="",toMonth="",toYear="";
		String fromDay="",fromMonth="",fromYear="";

		toDay=""+toDateObj.getDate();
		if(toDateObj.getDate()<10)
			toDay="0"+toDateObj.getDate();

		toMonth=""+(toDateObj.getMonth()+1);
		if((toDateObj.getMonth()+1)<10)
			toMonth="0"+(toDateObj.getMonth()+1);

		toYear=""+(toDateObj.getYear()+1900);

		td = toDay+"/"+toMonth+"/"+toYear;

		Date fromDateObj=new Date(toDateObj.getYear(),toDateObj.getMonth(),toDateObj.getDate()-120);

		fromDay=""+fromDateObj.getDate();
		if(fromDateObj.getDate()<10)
			fromDay="0"+fromDateObj.getDate();

		fromMonth=""+(fromDateObj.getMonth()+1);	
		if((fromDateObj.getMonth()+1)<10)
			fromMonth="0"+(fromDateObj.getMonth()+1);

		fromYear=""+(fromDateObj.getYear()+1900);

		fd = fromDay+"/"+fromMonth+"/"+fromYear;

	}	
			
	
	
	int dataCount = 0;
	ezc.ezparam.EzInvoice SeqInv = new ezc.ezparam.EzInvoice();
	
	Date balDate = null;
	
	Date fromDateObj = null;
	Date toDateObj = null;
	double invBal = 0;
	if(fd != null && td != null)
	{
		//fd = dateConvertion(fd,(String)session.getValue("DATEFORMAT"));
		//td = dateConvertion(td,(String)session.getValue("DATEFORMAT"));
		
		GregorianCalendar gc=new GregorianCalendar(Integer.parseInt(fd.substring(6,10)),Integer.parseInt(fd.substring(3,5))-1,Integer.parseInt(fd.substring(0,2)));
		fromDateObj = gc.getTime();
		gc.add(Calendar.DATE,-1);
		balDate = gc.getTime();

		gc=new GregorianCalendar(Integer.parseInt(td.substring(6,10)),Integer.parseInt(td.substring(3,5))-1,Integer.parseInt(td.substring(0,2)));
		toDateObj = gc.getTime();
		
		
		if("2".equals(userType))
		{
			if("ACSTMT".equals(request.getParameter("menuItem")) && request.getParameter("buyerSelVendor")==null)
			{
				if(vendorsRetObjCnt>0)
					soldTo = vendorsRetObj.getFieldValueString(0,"EC_ERP_CUST_NO");
			}
			else
				soldTo = request.getParameter("buyerSelVendor");	
		}
		

		//---------TO GET LIST OF ALL INVOICES OF INVFLAG 'D'
		
		ezc.client.EzVendorInvManager VendInvManager = new ezc.client.EzVendorInvManager();


		ezc.ezparam.EzcVendorParams newParams = new ezc.ezparam.EzcVendorParams();
		ezc.ezparam.EzVendorParams ioparams = new ezc.ezparam.EzVendorParams();
		ezc.ezvendor.params.EziVendorInvoiceInputParams eviip = new ezc.ezvendor.params.EziVendorInvoiceInputParams();

		ioparams.setBussPartnerNo(soldTo);

		eviip.setInvoiceFlag("B");
		ioparams.setToDate(toDateObj);		//fromDateObj
		ioparams.setFromDate(fromDateObj);
		ioparams.setCompCode(selCompCode);//company code added for mtr

		//out.println(ioparams.getFromDate()+":::::::::"+ioparams.getToDate());

		newParams.createContainer();
		newParams.setObject(ioparams);
		newParams.setObject(eviip);
		Session.prepareParams(newParams);
		SeqInv = (ezc.ezparam.EzInvoice)VendInvManager.getListOfInvoicesAndDocuments(newParams);

		//out.println("SeqInvSeqInvSeqInv		"+SeqInv.toEzcString());
		
		//SeqInv.sort(new String[]{"POSTINGDATE"},true);
		
		
		ezc.ezparam.EzVendorParams ioparams1 = new ezc.ezparam.EzVendorParams();
		ezc.ezparam.EzcVendorParams newParams1 = new ezc.ezparam.EzcVendorParams();
		ezc.ezvendor.params.EziVendorInvoiceInputParams eviip1 = new ezc.ezvendor.params.EziVendorInvoiceInputParams();


		ioparams1.setVendor(soldTo);
		ioparams1.setToDate(balDate);//fromDateObj);
		ioparams1.setFromDate(balDate);//fromDateObj);
		ioparams1.setCompCode(selCompCode);//company code added for mtr
		eviip1.setInvoiceFlag("B");
		newParams1.createContainer();
		newParams1.setObject(ioparams1);
		Session.prepareParams(newParams1);

		ezc.ezvendor.client.EzVendorManager VendManager = new ezc.ezvendor.client.EzVendorManager();
		ezc.ezparam.EzSupplBalance supplbal = (ezc.ezparam.EzSupplBalance)VendManager.getVendorBalance(newParams1);
		

		for(int i=0;i<supplbal.getRowCount();i++)
		{
			if (!"O".equalsIgnoreCase(supplbal.getFieldValueString(i,"SPGLIND")))
			{
				try
				{
					invBal +=Double.parseDouble(supplbal.getFieldValueString(i,"LCBAL"));
				}
				catch(Exception e)
				{
					invBal += 0;
				}
			}
		}
		//out.println(":::::::supplbal::::::::::"+supplbal.toEzcString());
		invBal *=-1;
		dataCount = SeqInv.getRowCount();
	}	
%>
<script src="../../Library/JavaScript/ezTabScroll.js"></Script>
<script src="../../Library/JavaScript/ezConvertDates.js"></Script>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>

<script>

	var plzSelFDate_A = '<%=plzSelFDate_A%>';
	var plzSelTDate_A = '<%=plzSelTDate_A%>';
	var fDateLessTDate_A = '<%=fDateLessTDate_A%>';
	function chkDates()
	{
		var fd = document.ACStatementForm.FromDate.value;
		var td = document.ACStatementForm.ToDate.value;

		if(fd=="")
		{
			alert(plzSelFDate_A);
			return false;
		}
		
		if(td=="")
		{
			alert(plzSelTDate_A);
			return false;
		}	
		
		fd = ConvertDate(fd,'<%=Integer.parseInt((String)session.getValue("DATEFORMAT"))%>')
		td = ConvertDate(td,'<%=Integer.parseInt((String)session.getValue("DATEFORMAT"))%>')

		fd1 = new Date();
		td1 = new Date();
		a = fd.split("/");
		var a1 = parseInt(a[1],10)-1
		fd1 = new Date(a[2],a1,a[0])
		b = td.split("/");
		var b1 = parseInt(b[1],10)-1
		td1 = new Date(b[2],b1,b[0])

		if(fd1 > td1)
		{
			alert(fDateLessTDate_A);
			document.ACStatementForm.FromDate.focus();
			return false;
		}
		return true;
	}

	function getDefaultsFromTo()
	{
<%
		if(fd != null && td != null)
		{
%>
			document.ACStatementForm.ToDate.value = "<%=td%>"
			document.ACStatementForm.FromDate.value = "<%=fd%>"
<%
		}
		else
		{
%>
			toDateObj = new Date();
			today 		= toDateObj.getDate();
			thismonth 	= toDateObj.getMonth()+1;
			thisyear 	= toDateObj.getYear();
			if(!document.all)
			{
				thisyear = thisyear+1900;
			}
			if(today < 10)
				today = "0"+today;
			if(thismonth < 10)
				thismonth = "0" + thismonth;

			document.ACStatementForm.ToDate.value = ConvertDateFormat(today+'.'+thismonth+'.'+thisyear,'<%=Integer.parseInt((String)session.getValue("DATEFORMAT"))%>','<%=(String)session.getValue("DATESEPERATOR")%>');
			if(thismonth < 4)
				document.ACStatementForm.FromDate.value = ConvertDateFormat('01.04.'+(thisyear-1),'<%=Integer.parseInt((String)session.getValue("DATEFORMAT"))%>','<%=(String)session.getValue("DATESEPERATOR")%>');
			else
				document.ACStatementForm.FromDate.value = ConvertDateFormat('01.04.'+(thisyear),'<%=Integer.parseInt((String)session.getValue("DATEFORMAT"))%>','<%=(String)session.getValue("DATESEPERATOR")%>');
<%
		}
%>
	} 

	function ezSubmit()
	{
		y=chkDates();
		if(y)
		{
			var flg = false;
			/*if(document.ACStatementForm.FromDate!=null)
			{
				var frm = document.ACStatementForm.FromDate.value.split("/");
				var frmDate = new Date(frm[2],frm[0]-1,frm[1],0,0,0)

				var rsDate = new Date(2007,02,31,12,59,59)
				if(frmDate > rsDate)
					flg = true;

			}
 
			*/
			
				$('#pleaseWaitDialog').modal('show');
				document.forms[0].method="post"
				document.forms[0].ShowData.value='Y';
				document.forms[0].submit();
			
		}
	}
	function funclearDocsRefence(clearingDoc,compCode,vendCode)   
	{
		var retValue = window.showModalDialog("ezClearingDocReferences.jsp?clearingDoc="+clearingDoc+"&compCode="+compCode+"&vendCode="+vendCode,window.self,"center=yes;dialogHeight=25;dialogWidth=40;help=no;titlebar=no;status=no;minimize:yes")	
	}
	</script>  
 <style>
 .btn-primary {
     background-color: #fff;
     color: black;
     border-color: #606263;
}
.btn-primary:hover{color:black;background-color:#efe9e9;}
.btn
{
	font-size: 11px;
}
.row {
    margin-right: 1px;
    margin-left: 1px;
}
</style>

<form  method="post" name="ACStatementForm"  action="ezAstatement.jsp">
<input type="hidden" name="InvStat" value="D">
<input type="hidden" name="FromForm" value="ACStatement">
<input type="hidden" name="ShowData">
<% 
	String display_header = "Self Service > "+stAccEntBooks_L;  
	String clickString = "onclick='ezSubmit()'";
	String fromDate = fd;
	String toDate 	= td;
	
%>
	<%@ include file="../Misc/ezSubHeader.jsp"%> 		
	<%@ include file="../Misc/ezSelectDate.jsp"%>
<%
	//out.println("::::::::SeqInv:::::::::"+SeqInv.toEzcString());

	if("Y".equals(ShowData)) 
	{
		if(dataCount == 0)
		{
			String noDataStatement = noTransPeriod_L;
			
			if("2".equals(userType))
				noDataStatement += " For "+session.getValue("SEL_VEND_NAME"); 
%>
			<%@ include file="../Misc/ezDisplayNoData.jsp" %> 
			<Div id="ButtonDiv" style="position:absolute;top:90%;width:100%;visibility:hidden">
			<Center>
			<%
				buttonName = new java.util.ArrayList();
				buttonMethod = new java.util.ArrayList();
			
				buttonName.add("Back");
				buttonMethod.add("navigateBack(\"../Misc/ezSBUWelcome.jsp\")");
			
				out.println(getButtonStr(buttonName,buttonMethod));
			%>
			</Center>
			</Div>
<%
		}
		else
		{
%>
			<div class="row" style="padding: 13px;">			
			<button type="button" class="btn btn-primary" onclick="funDownload()" style="height: 26px; padding-top: 3px; padding-bottom: 3px;margin-bottom: 20px;">Download as PDF</button>
			
			
			<table width="100%" border=1>
			<Tr>
				<td width="70%">&nbsp;</th>
				<th <%=trBGColor%> width="15%" height='25'>Opening Balance</th>
				<td width="15%" align=right><%=myFormat.getCurrencyString(invBal)%></td>
			</Tr>
			</table>
			
			<table class="table table-striped table-bordered nowrap" cellspacing="0" width="100%" style="margin-bottom: 0px;">
			<thead>
			<Tr <%=trBGColor%> >
				<!--<th width="8%" rowspan="2">Clearing Doc No.</th>-->
				<th width="15%" rowspan="2" style="padding-bottom: 25px;">Posting Date</th>
				<th width="15%" rowspan="2" style="padding-bottom: 25px;"><%=particulars_L%></th>
				<th width="15%" rowspan="2" style="padding-bottom: 25px;">Bill Reference </th>
				<!--<th width="15%" rowspan="2">Cheque No/ DD No/RTGS</th>-->
				<th width="35%" colspan="2" style="padding-bottom: 25px;"><%=transAmount_L%></th>
				<th width="20%" rowspan="2" style="padding-bottom: 25px;"><%=bal_L%></th>
			</Tr>
			<Tr <%=trBGColor%>>
				<th width="17%" ><%=debit_L%></th>
				<th width="18%" ><%=credit_L%></th>
			</Tr>
			</thead>
			</table>
			
			<div class="slimScrollDiv" style="position: relative; overflow: hidden; width: auto; height: 400px;">
			<div class="box-body chat" id="chat-box" style="overflow: auto; width: auto; height: 400px;padding-right: 0px;">
			<table class="table table-striped table-bordered nowrap" cellspacing="0" width="100%">
			<tbody>	
<%			
			String invDt = null;
			Date dt1 = null;
			int items = 0;
			String fontColor = null;
			String tdBGColor = null;
			String tdClass = null;
			String acType = null;
			double totAmount = 0;
			double balance = 0;
			double invAmt = 0;
			//String str[]={"INVOICEDATE"};
			//boolean b=SeqInv.sort(str,true);
			String clearDocLink = "";

			String dbcrIndicator = new String();
			String color="";
			for(int i=0;i<dataCount;i++)
			{
				color="";
				clearDocLink = "";
				if(i%2==0) {color = "style='background-color:#d0d0d0'";}
				dt1= (Date)SeqInv.getFieldValue(i,"POSTINGDATE"); // ADDED BY MUKESH
				
				String paymentMethodDesc = "";//(String)paymentMthDescHT.get(SeqInv.getFieldValueString(i,"PMNT_METHOD"));
				
				String assignmentNo = "";//SeqInv.getFieldValueString(i,"ASSIGNMENT_NO");
				
				String chqNumber = SeqInv.getFieldValueString(i,"CHEQUENUMBER");
				
				/*if("K".equals(SeqInv.getFieldValueString(i,"PMNT_METHOD")))
					chqNumber = paymentMethodDesc;
				else if(chqNumber==null || "null".equals(chqNumber) || "".equals(chqNumber))
					chqNumber = assignmentNo;
				*/	
				
					
				if("RE".equals(SeqInv.getFieldValueString(i,"DOCTYPE"))) //MTR
					chqNumber = "";
				
				invDt = formatDate.getStringFromDate(dt1,(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));

				if((fromDateObj.compareTo(dt1) <= 0) && (toDateObj.compareTo(dt1) >=0))
				{
					items += 1;
					try{
						invAmt = Double.parseDouble(SeqInv.getFieldValueString(i,"AMOUNT"));
					}catch(Exception numFmtEx)
					{
						invAmt = 0;
					}
					totAmount += invAmt;
					if(SeqInv.getFieldValueString(i,"DBCRINDICATOR").equals("H"))
					{
						fontColor = "black";
						acType = "Credit";
						tdClass = "credit";
						balance = invBal + invAmt;
						dbcrIndicator = "";
						
						chqNumber = ""; //MTR
					}
					else
					{
						fontColor = "red";
						acType = "Debit";
						tdClass = "debit";
						balance = invBal - invAmt;
						dbcrIndicator = "-";
					}
					if (SeqInv.getFieldValueString(i,"DOCTYPE").equals("KZ"))
					{
						acType="Payment";
					}
					if (SeqInv.getFieldValueString(i,"DOCTYPE").equals("RE"))
					{
						acType="Invoice";
					}
					if (SeqInv.getFieldValueString(i,"DOCTYPE").equals("AB")) 
					{
						acType="A/c Adjustments";
					}
					if (SeqInv.getFieldValueString(i,"DOCTYPE").equals("OV"))
					{
						acType="Carry Forward";
					}
					
					String clearDoc = SeqInv.getFieldValueString(i,"GRNUMBER");
					String compCode = SeqInv.getFieldValueString(i,"COMPCODE");
					String vendCode = SeqInv.getFieldValueString(i,"SUPPLIER");					
					
					if (SeqInv.getFieldValueString(i,"DOCTYPE").equals("ZP")) 
					{
						//clearDocLink = "<a href=\"JavaScript:funclearDocsRefence('"+clearDoc+"','"+compCode+"','"+vendCode+"')\">"+clearDoc+"</a>";
						clearDocLink = clearDoc;
					}
					
					else
						clearDocLink = clearDoc;
%>						
					<tr>
						<!--<td width="8%" <%=color%> align="center" style="color:black" <%=color%>><%=clearDocLink%>&nbsp;</td>-->
						<td width="15%" <%=color%> align="center" style="color:black" <%=color%>><%=invDt%></td>
						<td width="15%" <%=color%>><%=acType%>&nbsp;</td>
						<td width="15%" <%=color%>><%=SeqInv.getFieldValueString(i,"REFDOC")%>&nbsp;</td>
						<!--<td width="15%" <%=color%>><%=chqNumber%></td>-->
<%
						if (dbcrIndicator.equals("-")) 
						{	
%>	
							<td width='17%' align='right' <%=color%> class='<%=tdClass%>'><%=myFormat.getCurrencyString(SeqInv.getFieldValueString(i,"AMOUNT"))%>&nbsp;</td>
<%	
						}
%>
						<td align="right" width="18%" <%=color%> class="<%=tdClass%>">&nbsp;</td>
<%
						if (dbcrIndicator.equals("")) 
						{
							out.println("<td width=\"20%\" "+color+" align=\"right\">"+" "+myFormat.getCurrencyString(SeqInv.getFieldValueString(i,"AMOUNT"))+"&nbsp;</td>");
						}
						if(balance<0)
						{
%>						
							<td width="20%" align="right" <%=color%> style="color:red">
								<%=myFormat.getCurrencyString(balance)%>&nbsp;
<%
						}
						else
						{
%>		
							<td width="20%" align="right" <%=color%>>
<%		
							out.println(myFormat.getCurrencyString(balance));
						}
%>
						&nbsp;
						</td>
						</font>
					</tr>
<%		
					invBal = balance;
				}
			}
%>			</tbody>
			
			</table></div></div></Div>
			
			</div>
<%
		}
%>

<%
	}
%> 
</form>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%>
<%@ include file="../Misc/ezDataTableScript.jsp"%>
<script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.js"></script>
<script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.pack.js"></script>
<script src="../../Library/jquery/jquery-validation-1.16.0/dist/jquery.validate.min.js"></script>
<script src="../../../../EzCommon/Library/jquery-ui-1.10.4/js/jquery-ui-1.10.4.custom.js"></script>

<script>
function funDownload()
{var FomDate="";
var tooDate="";

	var url = "ezAstatementPDF.jsp?FomDate="+FromDate.value+"&tooDate="+ToDate.value;		
	document.ACStatementForm.action=url;
	document.ACStatementForm.submit();
}
$(document).ready(function() {
		
       $("#FromDate").datepicker({ 
              	dateFormat: 'dd/mm/yy', 
             	changeMonth: true,
          	changeYear: true
       });
        $("#ToDate").datepicker({ 
                     	dateFormat: 'dd/mm/yy', 
                     	changeMonth: true,
          		changeYear: true
       });
 });
  
</script>
