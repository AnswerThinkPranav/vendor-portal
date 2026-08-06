<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ page import="java.util.*" %>
<%@ include file="../../../Includes/JSPs/Labels/iAstatement_Labels.jsp"%>


<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ include file="../../../Includes/JSPs/Misc/iMultiVendorDetails.jsp" %>

<%@ include file="../../../Includes/JSPs/Misc/iEzDateConvertion.jsp" %>

<%
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
	String companyCode 	= request.getParameter("companyCode");
	String quater 	= request.getParameter("quater");
	String noOfQtrs 	= request.getParameter("noOfQtrs");
	out.println("quater=="+quater);
	out.println("noOfQtrs=="+noOfQtrs);
	
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
		out.println("td===="+td);

		Date fromDateObj=new Date(toDateObj.getYear(),toDateObj.getMonth(),toDateObj.getDate()-120);

		fromDay=""+fromDateObj.getDate();
		if(fromDateObj.getDate()<10)
			fromDay="0"+fromDateObj.getDate();

		fromMonth=""+(fromDateObj.getMonth()+1);	
		if((fromDateObj.getMonth()+1)<10)
			fromMonth="0"+(fromDateObj.getMonth()+1);

		fromYear=""+(fromDateObj.getYear()+1900);

		fd = fromDay+"/"+fromMonth+"/"+fromYear;
		out.println("fd===="+fd);

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
		
		
		
		

		//---------TO GET LIST OF ALL INVOICES OF INVFLAG 'D'
		
		String soldTo = (String)session.getValue("SOLDTO");

		ezc.client.EzVendorInvManager VendInvManager = new ezc.client.EzVendorInvManager();


		ezc.ezparam.EzcVendorParams newParams = new ezc.ezparam.EzcVendorParams();
		ezc.ezparam.EzVendorParams ioparams = new ezc.ezparam.EzVendorParams();
		ezc.ezvendor.params.EziVendorInvoiceInputParams eviip = new ezc.ezvendor.params.EziVendorInvoiceInputParams();

		ioparams.setBussPartnerNo(soldTo);

		eviip.setInvoiceFlag("B");
		ioparams.setToDate(toDateObj);		//fromDateObj
		ioparams.setFromDate(fromDateObj);

		//out.println(ioparams.getFromDate()+":::::::::"+ioparams.getToDate());

		newParams.createContainer();
		newParams.setObject(ioparams);
		newParams.setObject(eviip);
		Session.prepareParams(newParams);
		SeqInv = (ezc.ezparam.EzInvoice)VendInvManager.getListOfInvoicesAndDocuments(newParams);

		//out.println("SeqInvSeqInvSeqInv		"+SeqInv.toEzcString());
		
		
		
		if("1300".equals(multiVendPurOrg) && multiVendor !=null && !"null".equals(multiVendor) && !"".equals(multiVendor))
		{
			VendInvManager = new ezc.client.EzVendorInvManager();
			newParams = new ezc.ezparam.EzcVendorParams();
	
	
			ioparams.setBussPartnerNo(multiVendor);
	
			newParams.createContainer();
			newParams.setObject(ioparams);
			newParams.setObject(eviip);
			Session.prepareParams(newParams);
			
			ezc.ezparam.EzInvoice tempSeqInv = (ezc.ezparam.EzInvoice)VendInvManager.getListOfInvoicesAndDocuments(newParams);
			ezc.ezcommon.EzLog4j.log("In Between:::::::::::Goutham::::::::::"+tempSeqInv.getRowCount(),"I");
			
			//out.println("tempSeqInv		"+tempSeqInv.getRowCount());

			if(SeqInv!=null)
			{
				SeqInv.append(tempSeqInv);		
			}else if((SeqInv == null || (SeqInv!=null && SeqInv.getRowCount()==0)) && tempSeqInv.getRowCount()>0)
				SeqInv = tempSeqInv;
			

			ezc.ezcommon.EzLog4j.log("After:::::::::::Goutham::::::::::"+SeqInv.getRowCount(),"I");
		}
		
		//out.println("SeqInvSeqInvSeqInv		"+SeqInv.toEzcString());
		
		
		ezc.ezparam.EzVendorParams ioparams1 = new ezc.ezparam.EzVendorParams();
		ezc.ezparam.EzcVendorParams newParams1 = new ezc.ezparam.EzcVendorParams();
		ezc.ezvendor.params.EziVendorInvoiceInputParams eviip1 = new ezc.ezvendor.params.EziVendorInvoiceInputParams();


		ioparams1.setVendor(soldTo);

		ioparams1.setToDate(balDate);//fromDateObj);
		ioparams1.setFromDate(balDate);//fromDateObj);

		eviip1.setInvoiceFlag("B");
		newParams1.createContainer();
		newParams1.setObject(ioparams1);
		Session.prepareParams(newParams1);

		ezc.ezvendor.client.EzVendorManager VendManager = new ezc.ezvendor.client.EzVendorManager();
		ezc.ezparam.EzSupplBalance supplbal = (ezc.ezparam.EzSupplBalance)VendManager.getVendorBalance(newParams1);
		
		
		if("1300".equals(multiVendPurOrg) && multiVendor !=null && !"null".equals(multiVendor) && !"".equals(multiVendor))
		{
			VendManager = new ezc.ezvendor.client.EzVendorManager();
			newParams1 = new ezc.ezparam.EzcVendorParams();


			ioparams1.setVendor(multiVendPurOrg);

			newParams1.createContainer();
			newParams1.setObject(ioparams1);
			Session.prepareParams(newParams1);

			ezc.ezparam.EzSupplBalance tempSupplbal =  (ezc.ezparam.EzSupplBalance)VendManager.getVendorBalance(newParams1);
			//ezc.ezcommon.EzLog4j.log("In Between::::::tempSupplbal:::::Goutham::::::::::"+tempSupplbal.getRowCount(),"I");

			if(supplbal!=null)
			{
				supplbal.append(tempSupplbal);		
			}

			//ezc.ezcommon.EzLog4j.log("After::::::tempSupplbal:::::Goutham::::::::::"+tempSupplbal.getRowCount(),"I");
		}
		

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
		invBal *=-1;
		dataCount = SeqInv.getRowCount();
	}	
%>
<html>
<head>
<Script>
	var tabHeadWidth=96
	var tabHeight="50%"
</Script>
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
				document.forms[0].method="post"
				document.forms[0].ShowData.value='Y';
				document.forms[0].submit();
			
		}
	}
	function funclearDocsRefence(clearingDoc,compCode,vendCode)
	{
		var retValue = window.showModalDialog("ezClearingDocReferences.jsp?clearingDoc="+clearingDoc+"&compCode="+compCode+"&vendCode="+vendCode,window.self,"center=yes;dialogHeight=25;dialogWidth=40;help=no;titlebar=no;status=no;minimize:yes")	
	}
	function funConfirm()
	{
		 var comments=document.ACStatementForm.comments;
		 if(comments.value=='')
		 {
			alert('please do enter comments');
			comments.focus();
			return;
		 }
		 else
		 {
			document.ACStatementForm.action='ezSaveQtrAcstatement.jsp';
			document.ACStatementForm.submit();
		 }	
	}
	</script>
</head>


<body onLoad = "getDefaultsFromTo();scrollInit()" onResize="scrollInit()" scroll=no>
<form  method="post" name="ACStatementForm">
<input type="hidden" name="InvStat" value="D">
<input type="hidden" name="quater" value="<%=quater%>">
<input type="hidden" name="companyCode" value="<%=companyCode%>">
<input type="hidden" name="FromForm" value="ACStatement">
<input type="hidden" name="ShowData">
<% 
	String display_header = stAccEntBooks_L; 
	String clickString = "onclick='ezSubmit()'";
	String fromDate = "";
	String toDate 	= "";
	
%>
	<%@ include file="../Misc/ezDisplayHeader.jsp" %>
	
	<%@ include file="../Misc/ezSelectDate.jsp"%>
<%
	if("Y".equals(ShowData))
	{
		if(dataCount == 0)
		{
			String noDataStatement = noTransPeriod_L;
%>
			<%@ include file="../Misc/ezDisplayNoData.jsp" %>
			<Div id="ButtonDiv" style="position:absolute;top:90%;width:100%;visibility:visible">
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
			<BR>
			<div id="theads">
			<Table id="tabHead" width="96%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
			<Tr>
				<th width="8%" rowspan="2">Clearing Doc No.</th>
				<th width="8%" rowspan="2"><%=transDate_L%></th>
				<th width="9%" rowspan="2"><%=particulars_L%></th>
				<th width="8%" rowspan="2">Bill Reference </th>
				<th width="15%" rowspan="2">Cheque / DD No</th>
				<th colspan="2"><%=transAmount_L%></th>
				<th width="16%" rowspan="2"><%=bal_L%></th>
			</Tr>
			<Tr>
				<th width="16%" ><%=debit_L%></th>
				<th width="16%" ><%=credit_L%></th>
			</Tr>
			</table>
			</div>

			<div id="InnerBox1Div" STYLE='overflow:auto;Position:Absolute;width:96%;Left=2%;height:50%' align="center">
			<table id="InnerBox1Tab" width="100%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
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
			String str[]={"INVOICEDATE"};
			boolean b=SeqInv.sort(str,true);
			String clearDocLink = "";

			String dbcrIndicator = new String();
			String color="";
			for(int i=0;i<dataCount;i++)
			{
				color="";
				clearDocLink = "";
				if(i%2==0) {color = "style='background-color:#c9e0ff'";}
				dt1= (Date)SeqInv.getFieldValue(i,"POSTINGDATE"); // ADDED BY MUKESH
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
						clearDocLink = "<a href=\"JavaScript:funclearDocsRefence('"+clearDoc+"','"+compCode+"','"+vendCode+"')\">"+clearDoc+"</a>";
					}
					
					else
						clearDocLink = clearDoc;
%>						
					<tr>
						<td width="8%" align="center" style="color:black" <%=color%>><%=clearDocLink%>&nbsp;</td>
						<td width="8%" align="center" style="color:black" <%=color%>><%=invDt%></td>
						<td width="9%" <%=color%>><%=acType%>&nbsp;</td>
						<td width="8%" <%=color%>><%=SeqInv.getFieldValueString(i,"REFDOC")%>&nbsp;</td>
						<td width="15%" <%=color%>><%=SeqInv.getFieldValueString(i,"CHEQUENUMBER")%>&nbsp;</td>
<%
						if (dbcrIndicator.equals("-")) 
						{	
%>	
							<td width='16%' align='right' <%=color%> class='<%=tdClass%>'><%=myFormat.getCurrencyString(SeqInv.getFieldValueString(i,"AMOUNT"))%>&nbsp;</td>
<%	
						}
%>
						<td align="right" width="16%" <%=color%> class="<%=tdClass%>">&nbsp;</td>
<%
						if (dbcrIndicator.equals("")) 
						{
							out.println("<td width=\"16%\" "+color+" align=\"right\">"+" "+myFormat.getCurrencyString(SeqInv.getFieldValueString(i,"AMOUNT"))+"&nbsp;</td>");
						}
						if(balance<0)
						{
%>						
							<td width="16%" align="right" <%=color%> style="color:red">
								<%=myFormat.getCurrencyString(balance)%>&nbsp;
<%
						}
						else
						{
%>		
							<td width="16%" align="right" <%=color%>>
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
%>			
			</table>
			</div>
<%
		}
%>
	<br><br><br>	
	<Table>
	<Tr>
	<TH>
	Comments</Th>
	<td><textarea name='comments' rows='5' cols='150'></textarea></Td>
	</Tr>
	</Table>
		<Div id="ButtonDiv" style="position:absolute;top:90%;width:100%;visibility:visible">
		<Center>
		<%
			buttonName = new java.util.ArrayList();
			buttonMethod = new java.util.ArrayList();
			
			buttonName.add("Confirm");
			buttonMethod.add("funConfirm()");
		
			buttonName.add("Back");
			buttonMethod.add("navigateBack(\"../Misc/ezSBUWelcome.jsp\")");
		
			out.println(getButtonStr(buttonName,buttonMethod));
		%>
		</Center>
		</Div>
<%
	}
%>
</form>
<Div id="MenuSol"></Div>
</body>
</html>
