<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@page import="java.util.*,ezc.ezparam.*"%>
<%@ include file="../Misc/ezCommonMethods.jsp"%>
<%@ page import ="ezc.ezpreprocurement.params.*,ezc.ezparam.*,java.util.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<jsp:useBean id="rfqManager" class="ezc.ezpreprocurement.client.EzPreProcurementManager" />
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" />
<%@ page import="ezc.ezmisc.params.*,java.text.*" %>
<%
String dispMessage="Problem occured while submitting QCF",dispMsgType="E",divWidth="90%";
String docId = checkNull(request.getParameter("docId"));
String itemCntStr = checkNull(request.getParameter("itemCnt"));
int itemCnt=0;
try{
itemCnt=Integer.parseInt(itemCntStr);
}catch(Exception e){}


boolean errorOccured=false;

String overallRank[] 	= request.getParameterValues("overallRank");
String participatedVendors[] 	= request.getParameterValues("participatedVendors");
int overallRankLen = 0;
int participatedVendorsLen = 0;

if(participatedVendors!=null)
participatedVendorsLen=participatedVendors.length;
//if(selectedVen!=null)
//selectedVenLen=selectedVen.length;

Hashtable selectedVendorsHT = new Hashtable();
ArrayList overallRankAL= new ArrayList();
for(int i=0;i<overallRankLen;i++)
{
	overallRankAL.add(overallRank[i]);
}
ezc.ezcommon.EzLog4j.log("::::::overallRankAL:::::::"+overallRankAL,"I");
/*for(int i=0;i<selectedVenLen;i++)
{
	String selVendorStr = selectedVen[i].split("#")[0];
	String selMaterialStr = selectedVen[i].split("#")[1];
	if(selectedVendorsHT.containsKey(selVendorStr))
	{
		String selMaterialStrTemp = (String)selectedVendorsHT.get(selVendorStr);
		selMaterialStrTemp	 =  selMaterialStrTemp+"#"+selMaterialStr;

		selectedVendorsHT.remove(selVendorStr);
		selectedVendorsHT.put(selVendorStr,selMaterialStrTemp);	
	}else
	selectedVendorsHT.put(selVendorStr,selMaterialStr);
}*/

String v_fname	=	(String)session.getValue("FIRST_NAME");
String v_mname	=	(String)session.getValue("MIDDLE_INITIAL");
String v_lname	=	(String)session.getValue("LAST_NAME"); 

if(v_fname==null||"null".equals(v_fname))v_fname="";
if(v_mname==null||"null".equals(v_mname))v_mname="";
if(v_lname==null||"null".equals(v_lname))v_lname="";

	EzcParams 		ezparams	= new EzcParams(true);
	EziRFQHeaderTable	rfqHeaderTable	= new EziRFQHeaderTable();
	EziRFQDetailsTable  	rfqDetailsTable	= new EziRFQDetailsTable();
	EzRFQConditionsTable 	rfqCondTable 	= new EzRFQConditionsTable();
	EziRFQHeaderTableRow rfqHeaderRow = new EziRFQHeaderTableRow();
	EziRFQDetailsTableRow 	rfqDetailsRow 	= new EziRFQDetailsTableRow();	
	EzRFQConditionsTableRow rfqCondTableRow = null;
	
	rfqHeaderRow.setModifiedBy(Session.getUserId());
	//rfqHeaderRow.setStatus("C");
	rfqHeaderRow.setStatus("R");
	rfqHeaderRow.setCollectiveRFQNo(docId);
	rfqHeaderTable.appendRow(rfqHeaderRow);
	
	
	ArrayList sendToAL= new ArrayList();
	Hashtable vendorMaterialStatusHT =new Hashtable();
	Hashtable rejVendorHT =new Hashtable();	

	for(int i=0;i<participatedVendorsLen;i++)
	{
		rfqDetailsRow 	= new EziRFQDetailsTableRow();	
		
		String participatedVendorStr = participatedVendors[i].split("#")[0];
		String requestedMaterialStr  = participatedVendors[i].split("#")[3];
		String requestedMaterialDescStr  = participatedVendors[i].split("#")[1];
		String RFQStr 		     = participatedVendors[i].split("#")[2];
		String selectedStatus="Not Selected",selVendor="";
		String rankDtlsStr 		= checkNull(request.getParameter("rank"+requestedMaterialStr));
		
		if(!"".equals(rankDtlsStr))
		selVendor=rankDtlsStr.split("#")[0];
		
		if(selectedVendorsHT.containsKey(selVendor))
		{
			String selMaterialStrTemp = (String)selectedVendorsHT.get(selVendor);
			selMaterialStrTemp	 =  selMaterialStrTemp+"#"+requestedMaterialStr;

			selectedVendorsHT.remove(selVendor);
			selectedVendorsHT.put(selVendor,selMaterialStrTemp);	
		}else
		selectedVendorsHT.put(selVendor,requestedMaterialStr);		
		
		if(overallRankAL.contains(participatedVendorStr))
		rfqDetailsRow.setExt1("Y");
		else
		rfqDetailsRow.setExt1("N");
		
		if(selVendor.equals(participatedVendorStr))
		{			
			rfqDetailsRow.setQuoteStatus("Y");
			selectedStatus="Selected";
		}else{
		rfqDetailsRow.setQuoteStatus("N");
		selectedStatus="Not Selected";
		
		if(rejVendorHT.containsKey(participatedVendorStr))
		{
			String requestedMaterialDescStrTemp = (String)rejVendorHT.get(participatedVendorStr);
			requestedMaterialDescStrTemp	 =  requestedMaterialDescStrTemp+"#"+requestedMaterialDescStr;

			rejVendorHT.remove(participatedVendorStr);
			rejVendorHT.put(participatedVendorStr,requestedMaterialDescStrTemp);	
		}else
			rejVendorHT.put(participatedVendorStr,requestedMaterialDescStr);
		
		
		}
		
		if(vendorMaterialStatusHT.containsKey(participatedVendorStr))
		{
			String requestedMaterialDescStrTemp = (String)vendorMaterialStatusHT.get(participatedVendorStr);
			requestedMaterialDescStrTemp	 =  requestedMaterialDescStrTemp+"#"+requestedMaterialDescStr+"-"+selectedStatus;

			vendorMaterialStatusHT.remove(participatedVendorStr);
			vendorMaterialStatusHT.put(participatedVendorStr,requestedMaterialDescStrTemp);	
		}else
			vendorMaterialStatusHT.put(participatedVendorStr,requestedMaterialDescStr+"-"+selectedStatus);
		
		rfqDetailsRow.setMaterial(requestedMaterialStr);
		rfqDetailsRow.setRFQNo(RFQStr);
		rfqDetailsTable.appendRow(rfqDetailsRow);

		if(!sendToAL.contains(participatedVendorStr+"#"+RFQStr))
		sendToAL.add(participatedVendorStr+"#"+RFQStr);
			
		
		
		
	}
		ezparams.setLocalStore("Y");
		ezparams.setObject(rfqHeaderTable);
		ezparams.setObject(rfqDetailsTable);
		ezparams.setObject(rfqCondTable);
		Session.prepareParams(ezparams);
		
		try{
			rfqManager.ezUpdateRFQ(ezparams);
		}
		catch(Exception e){
		errorOccured=true;
			ezc.ezcommon.EzLog4j.log("Error while updating QCF Details :::::::::"+e,"E");
		}
		ezc.ezcommon.EzLog4j.log("::::::vendorMaterialStatusHT:::::::"+vendorMaterialStatusHT,"I");
		ezc.ezcommon.EzLog4j.log("::::::selectedVendorsHT:::::::"+selectedVendorsHT,"I");
		ezc.ezcommon.EzLog4j.log("::::::rejVendorHT:::::::"+rejVendorHT,"I");
		
		if(!errorOccured)
		{
		for(int l=0;l<sendToAL.size();l++)
		{
			String vendorStr= ((String)sendToAL.get(l)).split("#")[0];
			String RFQStr= ((String)sendToAL.get(l)).split("#")[1];
			
			try{
			RFQStr=Integer.parseInt(RFQStr)+"";
			}catch(Exception e){}
			
			String sendToUser=vendorStr;
			boolean allMaterialsSelected=false;
			boolean allMaterialsRejected=false;
			
			try{
				String selMaterialsCntStr = (String)selectedVendorsHT.get(vendorStr);
				String selMaterialsCntArr[] = selMaterialsCntStr.split("#");
				int selMaterialsCnt=selMaterialsCntArr.length;
				if(selMaterialsCnt==itemCnt)allMaterialsSelected=true;
			}catch(Exception e){}	
			try{
				String rejMaterialsCntStr = (String)rejVendorHT.get(vendorStr);
				String rejMaterialsCntArr[] = rejMaterialsCntStr.split("#");
				int rejMaterialsCnt=rejMaterialsCntArr.length;
				if(rejMaterialsCnt==itemCnt)allMaterialsRejected=true;
			}catch(Exception e){}
			
			ezc.ezcommon.EzLog4j.log("::RFQStr:::"+RFQStr+":::allMaterialsSelected:::"+allMaterialsSelected+":::allMaterialsRejected:::"+allMaterialsRejected,"I");
			String materialStr = "";
			try{
				materialStr = checkNull((String)vendorMaterialStatusHT.get(sendToUser));
			}catch(Exception e){}
			
			String msgSubject = "Quotation satus for RFQ :"+RFQStr;
			
			String msgText = "Dear Sir/Madam<br><br>";
			if(allMaterialsRejected)
			msgText = msgText+"<br>Betterluck next time!!";
			if(allMaterialsSelected)
			msgText = msgText+"<br>Congratulations!!";
			
			msgText = msgText+"<br>Please find the below Quotation satus for RFQ :"+RFQStr+" <br> <table border=1 style='width:80%'><tr><th style='background-color: #f39c12'>Material</th><th style='background-color: #f39c12'>Status</th><tr>";
			if(materialStr.indexOf("#")>=0)
			{
				String materialArr[] = materialStr.split("#");
				for(int j=0;j<materialArr.length;j++)
				{
				msgText=msgText+"<tr><td>"+materialArr[j].split("-")[0]+"</td><td>"+materialArr[j].split("-")[1]+"</td></tr>";
				}
			}else{
				msgText=msgText+"<tr><td>"+materialStr.split("-")[0]+"</td><td>"+materialStr.split("-")[1]+"</td></tr>";
			}
				msgText=msgText+"</table><br>";
			
			
			
			msgText += "<br>Regards,<br>"+v_fname+v_mname+v_lname;
%>
			<%@ include file="../Purorder/ezSendMail.jsp" %>
<%
		}
		dispMessage="Quotation status has been submitted";
		dispMsgType="S";
		}
%>
<html>
<head>

 <!-- Bootstrap 3.3.5 -->
    <link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/datepicker.css">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/font-awesome.min.css">
    <!-- Ionicons -->
    <link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/ionicons.min.css">
    
    <!-- Theme style --> 
    <link rel="stylesheet" href="../../../../EzCommon/Library/dist/css/AdminLTE.min.css">
    <!-- AdminLTE Skins. We have chosen the skin-blue for this starter
          page. However, you can choose any other skin. Make sure you
          apply the skin class to the body tag so the changes take effect.
    -->
    <link rel="stylesheet" href="../../../../EzCommon/Library/dist/css/skins/skin-yellow.min.css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>

</head>
<body>
<form name="myForm">
	
<Div class="content-wrapper">
          <!-- Content Header (Page header) -->
          <section class="content-header">
            <h4>
              Quotation Comparision Form: <%=docId%>
            </h4>
          </section>
  
          <!-- Main content -->  
          <section class="content"> 
	
<%@ include file="../Misc/ezStatusMsgDisplay.jsp" %>	
<div class="row">

	<center><div class="span3 offset5" id="UploadDiv1">
		<a href="javascript:funOk()" class="btn btn-info" >Ok</a>		
	</div></center>	
</div>	
 </section><!-- /.content -->
      </Div><!-- /.content-wrapper -->  
      
      </form>
<script>
function funOk()
{
window.parent.funGo();
}
</script>      
      </body>
      
</Html>  
