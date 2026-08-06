 
       <div id='loadingmessage' style='position:absolute;bottom:250px;left:500px;display:none'>
       		  <img src='../Invoice/gcloading.gif'/>
       	</div>
       <script type="text/javascript">
       document.getElementById("loadingmessage").style.display="block";       
	</script>
  
  
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*,java.util.*" %>
<%//@ include file="iVendorDetails.jsp" %>           
<%@ include file="../../Library/Globals/errorPagePath.jsp"%>                 
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>     
<%@ include file="../../../Includes/JSPs/Labels/iSBUWelcome_Labels.jsp"%>   
<%@ page import ="ezc.ezparam.*,java.util.*,ezc.ezutil.*,ezc.ezvendorapp.params.*,ezc.ezpurchase.params.*,ezc.messaging.params.*,ezc.ezpreprocurement.params.*,java.text.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="AppManager" class="ezc.ezvendorapp.client.EzVendorAppManager" scope="session" />
<jsp:useBean id="miscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"></jsp:useBean>
<%@ include file="ezGetUserAuthDefaults.jsp"%>            
  
<%	  
	if(request.getParameter("vendFromBuyerView")==null && "2".equals(userType))
		response.sendRedirect("ezBuyerWelcome.jsp");
	if("4".equals(userType))
		response.sendRedirect("ezWelcomeTempUser.jsp");		

	if(request.getParameter("vendFromBuyerView")!=null) 
		session.putValue("SOLDTO",request.getParameter("vendFromBuyerView"));
	if(request.getParameter("vendFromBuyerView")!=null) 
		session.putValue("Vendor",request.getParameter("vendNameFromBuyerView"));	
		//out.println("::::::"+session.getValue("Vendor"));

	if("2".equals(userType))
	{
		session.putValue("PORTAL_TYPE","VENDOR");
		portaType   = (String)session.getValue("PORTAL_TYPE");
	}	
%>  
<%@ include file="ezGetVendSAPDetails.jsp"%>
<%
	String namee=NAME1+" "+NAME2;
	//out.println(":::::::::::"+abc.toLowerCase());
	namee=namee.toLowerCase();
	String eemail=SMTP_ADDR;
	eemail=eemail.toLowerCase();
%>
<% 
	 if(!"".equals(SPERQ))
	{
		//out.println("SPERQ:::"+SPERQ);
		response.sendRedirect("../../../../../ezBlockedUser.jsp");
		return;
	}
%>  
<%@ include file="ezWelcomePageCounts.jsp"%>        
<%@ include file="ezHeader.jsp"%> 
<%@ include file="../Confirmations/ezGetConfAlerts.jsp"%> 

<%
		
	int retListCnt=0; 	  
	String user	 = (String)Session.getUserId();	 
	String vc	 = LIFNR;
	String mob	 = TELF2;	
	ReturnObjFromRetrieve	vendConformationRetObj = null;
	int vendConformationRetObjCnt	= 0;
	String venConfirmedOn	= "";	
	String query	= "SELECT * FROM EZC_VENDOR_CONFIRMATION WHERE EVC_VENDOR='"+user+"' and NOW() <= (EVC_CONFIRMED_ON + INTERVAL 6 MINUTE) ORDER BY EVC_CONFIRMED_ON DESC";	
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(true);
	EziMiscParams miscParams = new EziMiscParams();
	miscParams.setQuery(query);
	mainParams.setObject(miscParams);	
	Session.prepareParams(mainParams);
	try
	{
		vendConformationRetObj = (ReturnObjFromRetrieve)miscManager.ezSelect(mainParams);
	}
	catch(Exception e){}
	if(vendConformationRetObj!=null)
	{
		vendConformationRetObjCnt	= vendConformationRetObj.getRowCount();
	}
%>
<%
	Date todaysDate = new Date();		
	Format formatterer = new SimpleDateFormat("yyyy-MM-dd"); 
	String dateStr = formatterer.format(todaysDate);
	//out.println(dateStr+"SPERQ:::"+dateStr);
	
	ReturnObjFromRetrieve retNews	=  null;
	int    NewsCnt	=  0;
	ezc.ezparam.EzcParams mainParams_n	= new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams_n		= new EziMiscParams();
	miscParams_n.setQuery("select * from EZC_NEWS >='"+dateStr+"'");
	mainParams_n.setLocalStore("Y");
	mainParams_n.setObject(miscParams_n);
	Session.prepareParams(mainParams_n);
	try
	{		
		retNews=(ReturnObjFromRetrieve)miscManager.ezSelect(mainParams_n);
	}
	catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Employee List in iGetEmpListForMgr.jsp:::::"+e,"I");}
	if(retNews!=null)
		NewsCnt=retNews.getRowCount();
		String news 	= retNews.getFieldValueString(0,"EZN_TEXT");
		//out.println(news+"SPERQ:::"+NewsCnt);
%>
<%!
	public String checkNull(String value)
	{
		if(value==null || "null".equals(value.trim()))value="";
		value=value.trim();		
		return value; 
	}	   
%> 
<%//@ include file="../../../Includes/JSPs/Purorder/iPOSyncFromSAP.jsp"%>  
<%//@ include file="../../../Includes/JSPs/Rfq/iRFQSync.jsp" %>     
<%//@ include file="../../../Includes/JSPs/Misc/iSBUWelcome.jsp" %>
<%@ include file="ezGetVendBalance.jsp" %>
<script>
	function funRedirect()  
	{
		alert("1");
		document.myForm.action="ezBlockedUser.jsp";
		document.myForm.submit();
	} 
</script>
<Head>     
<style>
	.form-control 
	{ 
		background-color: #101317;        
	} 
	body
	{
		color: #000000;
		// font-weight: bold;
	}
	a
	{
		color: #000000;
	} 
	.info-box-number 
	{     
		font-weight: bold; 
		font-size: 15px;
	}
	.info-box-text 
	{   
		font-weight: bold;
		font-size: 13px;
	}
	.box.box-success
	{
		border-top-color: lightseagreen ;
	}
	.box-header
	{
		background-color: whitesmoke;
	}
	.table>tbody>tr>td, .table>tbody>tr>th, .table>tfoot>tr>td, .table>tfoot>tr>th, .table>thead>tr>td, .table>thead>tr>th 
	{
		font-family: Verdana, Geneva, sans-serif;
		text-transform: capitalize;
		font-size: small;
	}
	h1, h2, h3, h4, h5, h6, .h1, .h2, .h3, .h4, .h5, .h6 
	{
		font-family: Verdana, Geneva, sans-serif;
	}
	body {    
		font-family: Verdana, Geneva, sans-serif;   
		overflow-x: hidden;
		overflow-y: auto;
	}  
	.small-box p {
	    font-size: 13px;
	}
</style> 
</head>
 <!-- Content Wrapper. Contains page content --> 
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">      
      <h4>       
	Dashboard 
	</h4>  
    </section>
    <!-- Main content -->   
    <section class="content"> 
      <Body>    
       <form method="post"  name="myForm">
      <!-- Small boxes (Stat box) -->     
      <div class="row">
	<div class="col-lg-3 col-xs-6">
	<!-- small box -->
		<div class="info-box">
			<div class="inner">       
				<div class="small-box bg-aqua">
					<h4 style="height: 60px;padding-top: 30px;font-size: 18px;">&nbsp;&nbsp;<%=toBeAckPOsCount%></h4>
					<p>
						&nbsp;PO's To Be Acknowledged<br>&nbsp;
					</p>
					<div class="icon">
						<i class="fa  fa-file-text-o" style="font-size: 70px;margin-top: 15px"></i>
					</div>            
					<a href="../Purorder/ezListAcknowledgedPOs.jsp?FROM=MENU&type=NotAcknowledged&selVendor=null" class="small-box-footer">
						More info 
						<i class="fa fa-arrow-circle-right"></i>
					</a>		 
				</div>
			</div>		
		</div>      
	</div> 
        <!-- ./col -->
	<div class="col-lg-3 col-xs-6">
	<!-- small box -->
		<div class="info-box">
			<div class="inner">
				<div class="small-box bg-green">
					<h4 style="height: 60px;padding-top: 30px;font-size: 18px;">&nbsp;&nbsp;<%=toBeQuotedRFQsCnt%></h4>
					<p>
						&nbsp;New RFQ(s)&nbsp;&nbsp;<br>&nbsp;
					</p>
					<div class="icon">
						<i class="fa  fa-newspaper-o" style="font-size: 70px;margin-top: 15px"></i>
					</div>                     
					<a href="../RFQ/ezListRFQs.jsp?type=ToQuote" class="small-box-footer">			
						More info 
						<i class="fa fa-arrow-circle-right"></i>
					</a>   					 
				</div>
			</div>
		</div>
	</div>
      
	<div class="col-lg-3 col-xs-6">   
	<!-- small box -->
		<div class="info-box">           	 
			<div class="inner"> 
				<div class="small-box bg-yellow">
					<h4 style="height: 60px;padding-top: 30px;font-size: 18px;">&nbsp;&nbsp;<%=shipmentsCnt%></h4>
					<p>
						&nbsp;To Be Approved Shipments<br>&nbsp;
					</p>
					<div class="icon">
						<i class="fa  fa-truck" style="font-size: 70px;margin-top: 15px"></i>
					</div> 
					<a href="../Shipment/ezGetVendorShipments.jsp?status=Y" class="small-box-footer">	            	
						More info 
						<i class="fa fa-arrow-circle-right"></i>
					</a>	            			 
				</div> 
			</div>     
		</div> 
	</div> 
	  
        <!-- ./col -->
	<div class="col-lg-3 col-xs-6">   
	<!-- small box -->
		<div class="info-box">	        
			<div class="inner">            
				<div class="small-box bg-red">
					<h4 style="height: 60px;padding-top: 30px;font-size: 18px;">&nbsp;&#8377;&nbsp;<%//=amtCurrency%><%=amtOutAmount%></h4>
					<p>
						&nbsp;Outstanding<br>&nbsp;
					</p>
					<div class="icon">
						<i class="fa  fa-balance-scale" style="font-size: 70px;margin-top: 15px"></i>
					</div>   
					<a href="../Purorder/ezListOPENInvoices.jsp?InvStat=O" class="small-box-footer">            	
						More info 
						<i class="fa fa-arrow-circle-right"></i>
					</a>           			 
				</div>
			</div>
		</div>
	</div>
</div>
      <!-- /.row -->

		<!-- Main row -->
		<div class="row">
		<!-- Left col -->
		<section class="col-lg-6 connectedSortable">
		<!-- Chat box -->
			<div class="box box-success">
				<div class="box-header  with-border" >
					<h5 class="box-title"><B>&nbsp;&nbsp NEWS</B></h5>
				</div>
					<div class="box-body chat" id="chat-box">
					<p class="message">	 <marquee scrollamount="2" direction="up" loop="true">
					<center> <font color="#FF6600" size=2"><strong> WELCOME <br>
					TO <br>
					COROMANDEL<br>
					VENDOR PORTAL<br>
					<%=checkNull(news)%>
					</strong></font></center>
				</marquee></p>
					
					</div>
					</div>

					<div class="box box-success">
						<div class="box-header  with-border" >
							<h5 class="box-title"><B>&nbsp;&nbsp ALERTS</B></h5>
						</div>

						<div class="box-body chat" id="chat-box">
						<%
						if("3".equals(userType))
						{
							if(getConfirmationAlertsRetObjCnt>0)
							{
								for(int i=0 ;i<getConfirmationAlertsRetObjCnt;i++)
								{
									String dispText = "Confirm Your A/C statement period from ";
									String confId 	= getConfirmationAlertsRetObj.getFieldValueString(i,"EASCH_ID");
									String remarks 	= getConfirmationAlertsRetObj.getFieldValueString(i,"EASCH_REMARKS");
									String fromDateAlert	= getDateForDateObj((java.util.Date)getConfirmationAlertsRetObj.getFieldValue(i,"EASCH_FROM"));
									String toDateAlert 	= getDateForDateObj((java.util.Date)getConfirmationAlertsRetObj.getFieldValue(i,"EASCH_TO"));

									dispText 	= dispText+fromDateAlert+" to "+toDateAlert;
							%>
									<p class="message">
									<img src="arrow.gif" alt="More Info">
									<a href="../Confirmations/ezGetAccStmtToConfirm.jsp?confId=<%=confId%>&fromDateAlert=<%=fromDateAlert%>&toDateAlert=<%=toDateAlert%>"><%=dispText%></a>
									</p>
							<%
								}
							%>
								<div>
								<p class="message">
								<img src="arrow.gif" alt="More Info">
								<a href="ezVendorDetails.jsp">Click here to update GSTIN</a>
								</p>
								</div>
								<div>
								<p class="message">
								<img src="arrow.gif" alt="More Info">
								<a id="complexConfirm" href="javascript:funMobileEmail();">Click to update Mobile and Email</a>
								</p>
								</div>
							<%
							}
							if(vendConformationRetObjCnt==0)
							{
							%>
								<div id="venConf">
								<p class="message">
								<img src="arrow.gif" alt="More Info">
								<a id="complexConfirm" href="javascript:funConfirmVendProfile();">Confirm Is your profile correctly capturing your details?</a>
								</p>
								</div>
							<%
							}								
						}
						%>
						</div>
			</div>
		</section>
		<!-- /.Left col -->
 
		<!-- right col (We are only adding the ID to make the widgets sortable)-->
		<section class="col-lg-6 connectedSortable">
<%
 		Vector orgList_V = new Vector();
		if(orgListRetObj!=null)
		{
			session.putValue("orgListRetObj",orgListRetObj);
			for(int k=0;k<orgListRetObj.getRowCount();k++)
			{				
				EKORG = checkNull(orgListRetObj.getFieldValueString(k,"PURORG"));
				WEBRE = checkNull(orgListRetObj.getFieldValueString(k,"GRBASED"));
				LEBRE = checkNull(orgListRetObj.getFieldValueString(k,"SERBASED"));
				WAERS = checkNull(orgListRetObj.getFieldValueString(k,"CURRRENCY"));
				//out.println("EKORG<>"+EKORG+"<>"+WEBRE+"<>"+LEBRE+"<>"+WAERS);
				orgList_V.add(EKORG);
			}	
				//out.println("EKORG<>"+orgListRetObj.getRowCount());
		}
		
		ReturnObjFromRetrieve retState_main	=  null;
		int    StateCnt_main	=  0;
		ezc.ezparam.EzcParams mainParams_main	= new ezc.ezparam.EzcParams(false);
		EziMiscParams miscParams_main		= new EziMiscParams();
		miscParams_main.setQuery("select * from EZC_MASTER_KEY_VALUES where EMKV_MASTER_TYPE='STATES'");
		mainParams_main.setLocalStore("Y");
		mainParams_main.setObject(miscParams_main);
		Session.prepareParams(mainParams_main);
		try
		{		
			retState_main=(ReturnObjFromRetrieve)miscManager.ezSelect(mainParams_main);
		}
		catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Employee List in iGetEmpListForMgr.jsp:::::"+e,"I");}
		if(retState_main!=null)
			StateCnt_main=retState_main.getRowCount();

%>
		<div class="box box-success">
			<div class="box-header  with-border" >
				<h5 class="box-title"><B>&nbsp;&nbsp PROFILE</B></h5>&nbsp;
				<i class="fa fa-edit" ></i>
				<!--<a href="javascript:onclick=funEDIT();" class="small-box-footer" data-toggle="tooltip" data-placement="bottom" title="" style="margin-right: 5px;" data-original-title="Edit"> 
					<i class="fa fa-edit" ></i>
				</a>-->
			</div>
			
			    
<Div class="row">  
	<Div class=" col-lg-12 " style=" padding-right: 40px; padding-left: 40px; padding-top: 20px;"> 
		<Div class="box box-info collapsed-box box-success">
			<Div class="box-header ">
				<h5  style="height: 6px">&nbsp;&nbsp;&nbsp;&nbsp<B>ADDRESS</B>&nbsp;&nbsp;</h5>
				
				<Div class="box-tools pull-right">
					<button type="button" class="btn btn-box-tool" data-widget="collapse"></button>                
				</Div>
			</Div>
			<Div class="box-body" style="display: block;">   
				<Div class="table-responsive">
				<Table class="table no-margin">
				<TBody>
				<Tr>
					<Td width="30%">&nbsp;Name</Td>
					<Td width="80%"><%=checkNull(namee)%></Td>
				</Tr>
				<Tr>
					<Td width="30%">&nbsp;Address</Td>
					<Td><%=checkNull(NAME3)%></Td>
				</Tr>
				<Tr>
					<Td width="30%">&nbsp;City</Td>
					<Td width="80%"><%=checkNull(ORT01)%> </Td>
				</Tr>
				<Tr>
					<Td>&nbsp;State</Td>
					<Td>
<%

						String statevalue_main="";					  
						for (int i=0;i<StateCnt_main;i++) 
						{
						String statekey_main = checkNull(retState_main.getFieldValueString(i,"EMKV_VALUE"));

						if(statekey_main.equals(REGIO))
						{
						statevalue_main = retState_main.getFieldValueString(i,"EMKV_VALUE1");
						statevalue_main = statevalue_main.trim();
						break;
						}

						}
%>														  
					<%=checkNull(statevalue_main)%>	- <%=checkNull(REGIO)%>
					</Td>
				</Tr>
				<Tr>
					<Td>&nbsp;LandLine</Td>
					<Td><%=checkNull(TELF1)%></Td>
				</Tr>
				<Tr>
					<Td>&nbsp;Mobile</Td>
					<Td><%=checkNull(TELF2)%></Td>
				</Tr>
				<Tr>
					<Td>&nbsp;Email</Td>
					<Td style="text-transform: lowercase;"><%=checkNull(eemail)%></Td>
				</Tr>
				</TBody>               
				</Table>
				</Div>
			<!-- /.table-responsive -->
			</Div>       
		</Div>
		</Div>
	</Div>	
<%
	if(bankListRetObj!=null)
	{
		for(int k=0;k<bankListRetObj.getRowCount();k++)
		//for(int k=0;k<1;k++)
		{
			String keyStr = checkNull(bankListRetObj.getFieldValueString(k,"KEY"));
			BANKN = checkNull(bankListRetObj.getFieldValueString(k,"ACCOUNT_CODE"));
			
			int index = bankAddrRetObj.getRowId("KEY",keyStr);
			
			if(index>=0)
			{
				BANKL = checkNull(bankAddrRetObj.getFieldValueString(index,"KEY"));
				BANKS = checkNull(bankAddrRetObj.getFieldValueString(index,"COUNTRY"));
				BANKA = checkNull(bankAddrRetObj.getFieldValueString(index,"BANK_NAME"));
				PROVZ = checkNull(bankAddrRetObj.getFieldValueString(index,"REGION"));
				STRASBank = checkNull(bankAddrRetObj.getFieldValueString(index,"STREET"));
				ORT01Bank = checkNull(bankAddrRetObj.getFieldValueString(index,"CITY"));
				BRNCH = checkNull(bankAddrRetObj.getFieldValueString(index,"BRANCH"));
				BKREF = checkNull(bankAddrRetObj.getFieldValueString(index,"IFSC"));
				WAERS = checkNull(bankAddrRetObj.getFieldValueString(index,"CURRENCY"));

			}
%>
<input type="hidden" name="bankKey" value="<%=keyStr%>">
<input type="hidden" name="bankIndex" value="<%=k+1%>"> 
<input type="hidden" name="bankCountry" id="bankCountry" value="<%=BANKS%>" />
<input type="hidden" name="bankName" id="bankName" value="<%=BANKA%>" />
<input type="hidden" name="bankRegion" id="bankRegion" value="<%=PROVZ%>" />
<input type="hidden" name="bankStreet" id="bankStreet" value="<%=STRASBank%>" />
<input type="hidden" name="bankCity" id="bankCity" value="<%=ORT01Bank%>" />
<input type="hidden" name="bankBranch" id="bankBranch" value="<%=BRNCH%>" />
<input type="hidden" name="bankIFSCCode" id="bankIFSCCode" value="<%=BKREF%>" />
<input type="hidden" name="bankACCode" id="bankACCode" value="<%=BANKN%>" />
<input type="hidden" name="bankCurrency" id="bankCurrency" value="<%=WAERS%>" />

	<Div class="row">
	<Div class=" col-lg-12 " style=" padding-right: 40px; padding-left: 40px; padding-top: 20px;"> 
		<Div class="box box-info collapsed-box box-success">
			<Div class="box-header ">
				<h5 style="height: 6px">&nbsp;&nbsp;&nbsp;&nbsp<B>BANK</B></h5>
				<Div class="box-tools pull-right">
					<button type="button" class="btn btn-box-tool" data-widget="collapse"></button>                
				</Div>
			</Div>
			<Div class="box-body" style="display: block;">
				<Div class="table-responsive">
				<Table class="table no-margin">
				<TBody>
				<Tr>
					<Td width="30%">&nbsp;AC Code</Td>
					<Td width="80%"><%=checkNull(BANKN)%></Td>
				</Tr>
				<Tr>
					<Td width="30%">&nbsp;Bank Name</Td>
					<Td width="80%"><%=checkNull(BANKA)%></Td>
				</Tr>
				<Tr>
					<Td width="30%">&nbsp;IFSC Code</Td>
					<Td width="80%"><%=checkNull(BKREF)%></Td>
				</Tr>
				<Tr>
					<Td width="30%">&nbsp;State</Td>
					<Td width="80%"><%=checkNull(PROVZ)%></Td>
				</Tr>
				<Tr>
					<Td width="30%">&nbsp;City</Td>
					<Td width="80%"><%=checkNull(ORT01Bank)%></Td>
				</Tr>
				</TBody>               
				</Table>
				</Div>
			<!-- /.table-responsive -->
			</Div>       
		</Div>
		</Div>
		</Div>
		
<%
}
}
%>
<Div class="row">
	<Div class=" col-lg-12 " style=" padding-right: 40px; padding-left: 40px; padding-top: 20px;"> 
		<Div class="box box-info collapsed-box box-success">
			<Div class="box-header ">
				<h5 style="height: 6px">&nbsp;&nbsp;&nbsp;&nbsp<B>STATUTORY</B></h5>
				<Div class="box-tools pull-right">
					<button type="button" class="btn btn-box-tool" data-widget="collapse"></button>                
				</Div>
			</Div>
			<Div class="box-body" style="display: block;">
				<Div class="table-responsive"> 
				<Table class="table no-margin">
				<TBody>					
				<Tr>
					<Td width="30%">&nbsp;PAN</Td>
					<Td width="80%"><%=checkNull(J_1IPANNO)%></Td>
				</Tr>								     
				<Tr>
					<Td width="30%">&nbsp;GSTIN</Td>
					<Td width="80%"><%=checkNull(GSTIN)%>&nbsp;</Td>
				</Tr>     
				<Tr>
					<Td width="30%">&nbsp;Classification</Td>
					<Td width="80%"><%=checkNull(CLASSIF_DESC)+"--"+checkNull(CLASSIF)%>&nbsp;</Td>
				</Tr>     
				</TBody>               
				</Table>
				</Div>
			<!-- /.table-responsive -->
			</Div>       
		</Div>
		</Div>
		</Div>
		<div class="tab-content no-padding">
		<!-- Morris chart - Sales -->
		<div class="chart tab-pane active" id="revenue-chart" style="position: relative; height: 20px;"></div>
		</div>
		</div>
		</div>

<input type="hidden" name="vendCode" id="vendCode" value="<%=LIFNR%>" />
<input type="hidden" name="compCode" id="compCode" value="<%=BUKRS%>" />
<input type="hidden" name="serBased" id="serBased" value="<%=LEBRE%>" />
<input type="hidden" name="procGrp" id="procGrp" value="<%=DLGRP%>" />
<input type="hidden" name="venName" id="venName" value="<%=NAME1+NAME2%>" />
<input type="hidden" name="grBased" id="grBased" value="<%=WEBRE%>" />
<input type="hidden" name="name1" id="name1" value="<%=NAME1%>" />
<input type="hidden" name="name2" id="name2" value="<%=NAME2%>" />
<input type="hidden" name="addr1" id="addr1" value="<%=NAME3%>" />
<input type="hidden" name="addr2" id="addr2" value="<%=NAME4%>" />
<input type="hidden" name="street" id="street" value="<%=STRAS%>" />
<input type="hidden" name="city" id="city" value="<%=ORT01%>" />
<input type="hidden" name="state" id="state" value="<%=REGIO%>" />
<input type="hidden" name="country" id="country" value="<%=LAND1%>" />
<input type="hidden" name="district" id="district" value="<%=ORT02%>" />
<input type="hidden" name="pin" id="pin" value="<%=PSTLZ%>" />
<input type="hidden" name="landline" id="landline" value="<%=TELF1%>" />
<input type="hidden" name="mobile" id="mobile" value="<%=TELF2%>" />
<input type="hidden" name="fax" id="fax" value="<%=TELFX%>" />
<input type="hidden" name="email" id="email" value="<%=SMTP_ADDR%>" />
<input type="hidden" name="contPers1" id="contPers1" value="<%=NAMEV%>" />
<input type="hidden" name="contPers2" id="contPers2" value="<%=NAME1ConInfo%>" />
<input type="hidden" name="vat" id="vat" value="<%=STCEG%>" />
<input type="hidden" name="cst" id="cst" value="<%=J_1ICSTNO%>" />
<input type="hidden" name="pan" id="pan" value="<%=J_1IPANNO%>" />
<input type="hidden" name="servTax" id="servTax" value="<%=J_1ISERN%>" />
<input type="hidden" name="eccNo" id="eccNo" value="<%=J_1IEXCD%>" />
<input type="hidden" name="excRegNo" id="excRegNo" value="<%=J_1IEXRN%>" />
<input type="hidden" name="rangeSel" id="rangeSel" value="<%=J_1IEXRG%>" />
<input type="hidden" name="exDiv" id="exDiv" value="<%=J_1IEXDI%>" />
<input type="hidden" name="commi" id="commi" value="<%=J_1IEXCO%>" />
<input type="hidden" name="minIndi" id="minIndi" value="<%=MINDK%>" />
<input type="hidden" name="gst" id="gst" value="<%=checkNull(GSTIN)%>" />
<input type="hidden" name="classification" id="classification" value="<%=checkNull(CLASSIF)%>" />
<input type="hidden" name="cc" id="cc" value="<%=checkNull(CompCodee)%>" />

<input type="hidden" name="pTerms" id="pTerms" value="<%=ZTERMComp%>" />
<input type="hidden" name="paymMethod" id="paymMethod" value="<%=ZWELS%>" />
<input type="hidden" name="creatDate" id="creatDate" value="<%=CERDT%>" />
<input type="hidden" name="houseBank" id="houseBank" value="<%=HBKID%>" />
<input type="hidden" name="schemaGroup" id="schemaGroup" value="<%=KALSK%>" />
<input type="hidden" name="titleSel" id="titleSel" value="<%=ANRED%>"/>		
</form>    
</body>
		</section>
		<!-- right col -->
		</div>
		<!-- /.row (main row) -->
		</section>
		<!-- /.content -->
  </div>
  <!-- /.content-wrapper -->		

<%//@ include file="../Admin/ezNews.jsp"%>
	
<script>
 document.getElementById("loadingmessage").style.display="none";       
function funMobileEmail()
{
	$.confirm({
		title: 'Enter Email and Mobile',
		content: '<table class="table"><tr><th>Email Id:</th><td><input type="text" name="emaill" id="emaill"  placeholder="Email Id"  autofocus></td></tr><tr><th>Mobile:</th><td><input type="text" name="mobilee" id="mobilee"  placeholder="Mobile Number"></td></tr></table>',
		buttons: {
			DONE:{
				btnClass: 'btn-success',		
				action:function () {
					var emaill=document.getElementById("emaill").value;
					var mobilee=document.getElementById("mobilee").value;								
					if(emaill=="")
					{
						alert("Please enter email Id.");
						document.getElementById("emaill").focus();
						return false;					
					}
					var x=document.getElementById("emaill").value;
					var atpos=x.indexOf("@");
					var dotpos=x.lastIndexOf(".");
					if (atpos<1 || dotpos<atpos+2 || dotpos+2>=x.length)
					{
						alert("Not a valid e-mail address");
						return false;
					}
					if(mobilee=="")
					{
						alert("Please enter mobile number.");
						document.getElementById("mobilee").focus();
						return false;
					}
					
					if (document.getElementById("mobilee").value.length>10 ||document.getElementById("mobilee").value.length<10)
					{
						alert("enter 10 digit mobile number");
						return false;
					}
					//document.myForm.emaill.value=emaill;
					//document.myForm.mobilee.value=mobilee;
					document.myForm.action="ezMailPhoneUpdate.jsp?emaill="+emaill+"&mobilee="+mobilee;
					document.myForm.submit();
				}
			},
			CANCEL: {
			   btnClass: 'btn-danger',
			   action:function () {

			   }
			}
		}
	});
	
}
function funConfirmVendProfile()
{
	$.confirm({
	    title: 'Confirm!',
	    content: 'Is your profile correctly capturing your details? If No, please update your profile?',
	    buttons: {
		YES:{
		btnClass: 'btn-success',
		action:function () {
		funAction("YES");
	       //     $.alert('Confirmed!');
		}
		},
		NO: {
		   btnClass: 'btn-danger',
		   action:function () {
		   funAction("NO");
		   //    $.alert('caNCEL!');
		   }
		}

	    }
	});
}	
function funAction(flag)
{
	// alert("hi");
	       var xmlhttp;
	        if (window.XMLHttpRequest)
	          {// code for IE7+, Firefox, Chrome, Opera, Safari
	          xmlhttp=new XMLHttpRequest();
	          }
	        else
	          {// code for IE6, IE5
	          xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	          }
	        xmlhttp.onreadystatechange=function()
	          {
	           if (xmlhttp.readyState==4 && xmlhttp.status==200)
	           {
	          	document.getElementById("venConf").style.display="none";
	          }
	          }
	    xmlhttp.open("GET","ezConfirmVendProfile.jsp?flag="+flag);
	    xmlhttp.send();     	
} 	
</script>
<script>
function funEDIT()
{
	var Url="ezOTPGeneration.jsp?vendor=<%=LIFNR%>&mobile=<%=TELF2%>";
		$.fancybox.open({

		href : Url,
		type : 'iframe',
		padding : 5,
		width:'35%',
		height:'250px',
		autoSize : false, 
		closeBtn : true,
		helpers     : { 
				overlay : {closeClick: false}
		 }
	});

	//var titleSel= document.myForm.titleSel.value;
	//document.myForm.action="ezVendorDetailsEdit.jsp";
	//document.myForm.submit();
		
}	
function funSubmit()
{
	document.myForm.action="ezVendorDetailsEdit.jsp";
	document.myForm.submit();
}
</script>
        </section><!-- /.content -->
      </Div><!-- /.content-wrapper -->  
<%@ include file="ezFooter.jsp"%>           
      
<link rel="stylesheet" href="library/fancybox2/jquery.fancybox.css" type="text/css" media="screen" />  
<script type="text/javascript" src="library/fancybox2/jquery.fancybox.js"></script>
<script type="text/javascript" src="library/fancybox2/jquery.fancybox.pack.js"></script>
<link rel="stylesheet" href="../../../../EzCommon/Library/plugins/jQuery/confirm.css" type="text/css" media="screen" />  
<script src="../../../../EzCommon/Library/plugins/jQuery/confirm.min.js"></script>
    