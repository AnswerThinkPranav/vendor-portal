<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />   
<jsp:useBean id="UManager" class="ezc.client.EzUserAdminManager" scope="session" />
<%@ page import = "ezc.ezcommon.*" %>
<%@ page import = "ezc.ezparam.*" %>
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<%@ page import ="java.util.*,ezc.ezbasicutil.*" %>
<%@ page import="javax.xml.ws.soap.SOAPFaultException"%>
<%@ page import ="javax.xml.ws.BindingProvider,java.util.*,ezc.wsdl.util.*" %>
<%@ page import="ezc.wsdl.RFQ.Materials.*" %>
<%@ include file="../../../Includes/JSPs/Misc/iRFCReadCommon.jsp"%> 
<%
	String selplant=request.getParameter("selPlant");
	String myIndex=request.getParameter("myIndex");
	//out.println(selplant+"selplant");
	String searchType=request.getParameter("searchType");
	String matDescription = request.getParameter("matDesc");
	String material = request.getParameter("matCode");
	//String maxRows = request.getParameter("maxRows");
	//String SAP = request.getParameter("SAP");
	
	/*
	out.println("selPlant=="+selplant);
	out.println("myIndex=="+myIndex);
	out.println("searchType=="+searchType);
	out.println("matDescription=="+matDescription);
	out.println("material=="+material);
	ezc.ezcommon.EzLog4j.log("searchType>>>>>>> "+searchType,"I");
	ezc.ezcommon.EzLog4j.log("matDescription>>>>>>> "+matDescription,"I");	
	
	String condStr="";
	if("DESC".equals(searchType))
	{
		condStr = "EMD_DESC LIKE '%"+matDescription+"%'";
	}
	else
	{
		condStr = "EMD_MAT_NO LIKE '%"+material+"%'";	
	}
		
	
	ezc.ezparam.ReturnObjFromRetrieve plantObj	  =	null;
	ezc.ezparam.ReturnObjFromRetrieve matObj	  =	null;
	ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate();
	
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false);
		
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	
	//String qry="select * from EZC_MAT_PLANTS,EZC_MAT_DESC WHERE EMP_MAT_NO =EMD_MAT_NO  AND EMP_PLANT  ='"+selplant+"'";
	//String qry="SELECT EMP_MAT_NO MATNO,EMD_DESC MATDESC,EMGD_UOM MATUOM FROM EZC_MAT_PLANTS,EZC_MAT_DESC,EZC_MAT_GEN_DATA WHERE EMP_MAT_NO =EMD_MAT_NO  AND EMP_MAT_NO=EMGD_MAT_NO AND EMP_MAT_NO LIKE '%145%' AND EMP_PLANT ='"+selplant+"'";
	String qry="SELECT EMP_MAT_NO MATNO,EMD_DESC MATDESC,EMGD_UOM MATUOM FROM EZC_MAT_PLANTS,EZC_MAT_DESC,EZC_MAT_GEN_DATA WHERE EMP_MAT_NO =EMD_MAT_NO  AND EMP_MAT_NO=EMGD_MAT_NO AND "+ condStr +" AND EMP_PLANT ='"+selplant+"'";
	//out.println(qry);
	miscTableRow.setQuery(qry);
	miscTable.appendRow(miscTableRow);
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscTable);
	Session.prepareParams(mainParams);	
	try
	{
		matObj=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
 
	}
	catch(Exception e)
	{
			//out.println("Exception in getting Item Category List:::::"+e);
	} */
	
	//WSDL
	
	
	GetMaterialListSyncOutService patchService= new GetMaterialListSyncOutService();
	GetMaterialListSyncOut patchPort=patchService.getHTTPPort();

	ezc.ezcommon.EzLog4j.log("patchService in BAPI_MATERIAL_GETLIST>>>>>>> "+patchService,"I");
	ezc.ezcommon.EzLog4j.log("patchPort in BAPI_MATERIAL_GETLIST>>>>>>> "+patchPort,"I");

	BindingProvider prov = (BindingProvider)patchPort;
	ResourceBundle site1=null;
	String PIUSER = "",PIPASSWORD="";
	try
	{
		site1= ResourceBundle.getBundle("Site");
		PIUSER = site1.getString("PI_USER");
		PIPASSWORD = site1.getString("PI_PASSWORD");
	}
	catch(Exception e)
	{ 
	    log("Got Exception while getting PI Details "+e);	
	}
	prov.getRequestContext().put(BindingProvider.USERNAME_PROPERTY,PIUSER);
	prov.getRequestContext().put(BindingProvider.PASSWORD_PROPERTY,PIPASSWORD);
	
	BAPI_MATERIAL_GETLIST sapPreProc = new BAPI_MATERIAL_GETLIST();
	
	BAPI_MATERIAL_GETLIST.MATNRSELECTION 			matSelTable	= new BAPI_MATERIAL_GETLIST.MATNRSELECTION();
	BAPI_MATERIAL_GETLIST.MATERIALSHORTDESCSEL 		matDescTable  	= new BAPI_MATERIAL_GETLIST.MATERIALSHORTDESCSEL();
	BAPI_MATERIAL_GETLIST.MANUFACTURERPARTNUMB 		partnerTable  	= new BAPI_MATERIAL_GETLIST.MANUFACTURERPARTNUMB();
	BAPI_MATERIAL_GETLIST.PLANTSELECTION 			plantSelTable 	= new BAPI_MATERIAL_GETLIST.PLANTSELECTION();
	BAPI_MATERIAL_GETLIST.STORAGELOCATIONSELECT 		storLocTable  	= new BAPI_MATERIAL_GETLIST.STORAGELOCATIONSELECT();
	BAPI_MATERIAL_GETLIST.SALESORGANISATIONSELECTION	sOrgTable 	= new BAPI_MATERIAL_GETLIST.SALESORGANISATIONSELECTION();
	BAPI_MATERIAL_GETLIST.DISTRIBUTIONCHANNELSELECTION 	dcSelTable    	= new BAPI_MATERIAL_GETLIST.DISTRIBUTIONCHANNELSELECTION();
	BAPI_MATERIAL_GETLIST.MATNRLIST 			matObjTable 	= new BAPI_MATERIAL_GETLIST.MATNRLIST();
	BAPI_MATERIAL_GETLIST.RETURN 				retObjTable	= new BAPI_MATERIAL_GETLIST.RETURN();
	
	if("CODE".equals(searchType))
	{	
	
		List<BAPIMATRAM> matList = matSelTable.getItem();
		BAPIMATRAM matItem = new BAPIMATRAM();
		matItem.setSIGN("I");
		matItem.setOPTION("CP");
		matItem.setMATNR_LOW("*"+material+"*");
		matList.add(matItem);	
	}
	else
	{
		List<BAPIMATRAS> matDescList = matDescTable.getItem();
		BAPIMATRAS matDescItem = new BAPIMATRAS();
		matDescItem.setSIGN("I");
		matDescItem.setOPTION("CP");
		matDescItem.setDESCR_LOW("*"+matDescription+"*");
		matDescList.add(matDescItem);	
	
	}
	
	List<BAPIMATRAW> plantList= plantSelTable.getItem();
	BAPIMATRAW plantItem = new BAPIMATRAW();
	plantItem.setSIGN("I");
	plantItem.setOPTION("EQ");
	plantItem.setPLANT_LOW(selplant);
	plantList.add(plantItem);	
	
	
	sapPreProc.setMATNRSELECTION(matSelTable);
	sapPreProc.setMATERIALSHORTDESCSEL(matDescTable);
	sapPreProc.setMANUFACTURERPARTNUMB(partnerTable);
	sapPreProc.setPLANTSELECTION(plantSelTable);
	sapPreProc.setSTORAGELOCATIONSELECT(storLocTable);
	sapPreProc.setSALESORGANISATIONSELECTION(sOrgTable);
	sapPreProc.setDISTRIBUTIONCHANNELSELECTION(dcSelTable);
	sapPreProc.setMATNRLIST(matObjTable);
	sapPreProc.setRETURN(retObjTable);
	
	String msgOut="";
	BAPI_MATERIAL_GETLISTResponse compResponse=null;
	try
	{
		ezc.ezcommon.EzLog4j.log("before MATSEARCH:::::::::::::::","I");
		compResponse=patchPort.getMaterialListSyncOut(sapPreProc);
		ezc.ezcommon.EzLog4j.log("after MATSEARCH:::::::::::::::","I");
	}
	catch(SOAPFaultException e)
	{
		out.print("SOAPFaultException in  BAPI_MATERIAL_GETLIST::"+e);
		ezc.ezcommon.EzLog4j.log("after:::::::::::::::"+e,"I");
	}
	catch(Exception e)
	{
		out.println("SOAP Exception in  BAPI_MATERIAL_GETLIST"+e);
	}
	
	int matCnt =0;
	ArrayList items =null;
	if(compResponse!=null)
	{	
	
		List<BAPIMATLST> matNrList = null; 
		
		if(compResponse.getMATNRLIST()!=null)
			matNrList=compResponse.getMATNRLIST().getItem();
		
		if(matNrList!=null)
		{
			items = new ArrayList(matNrList);		
			matCnt = items.size();	
		}
		ezc.ezcommon.EzLog4j.log("matCnt:::::::::::::::"+matCnt,"I");
	}
	
	ezc.ezparam.ReturnObjFromRetrieve matObj= null;
	if(matCnt > 0)
	{
		matObj= new ReturnObjFromRetrieve(new String[]{"MATNO","MATDESC","UOM"});
		
	try 
	{		
		for(int k=0;k<matCnt;k++)
		{
			BAPIMATLST sapMatList = (BAPIMATLST)items.get(k);
			matObj.setFieldValue("MATNO", sapMatList.getMATERIAL());
			matObj.setFieldValue("MATDESC", sapMatList.getMATL_DESC());
			
			//TO Fetch Vendor Payment Terms and Inco Terms
			String [] outputFeilds =new String[]{"MEINH"};
			String [] queryValues =new String[]{"MATNR EQ '"+sapMatList.getMATERIAL()+"'"}; 

			ReturnObjFromRetrieve retUom= readRFCTable("MARM",outputFeilds,queryValues);
			ezc.ezcommon.EzLog4j.log("::retPaymentTerm:::"+retUom.toEzcString()+"::::::::","I");
			ezc.ezcommon.EzLog4j.log("::VendPaymentTerm:::"+retUom.getFieldValueString(0,"MEINH")+"::::::::","I");			
			
			
			matObj.setFieldValue("UOM", retUom.getFieldValueString(0,"MEINH"));
			matObj.addRow();
		
		}
	}
	catch (Exception e) {}
		
	}
%>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge"> 
    <title>Ceat</title>
    <!-- Tell the browser to be responsive to screen width -->
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    
    <meta http-equiv="cache-control" content="max-age=0" />
    <meta http-equiv="cache-control" content="no-cache" />
    <meta http-equiv="expires" content="0" />
    <meta http-equiv="expires" content="Tue, 01 Jan 1990 12:00:00 GMT" />

    <!-- Bootstrap 3.3.5 -->
    <link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/datepicker.css">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
    <!-- Ionicons -->
    <link rel="stylesheet" href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css">
    <!-- Theme style --> 
    <link rel="stylesheet" href="../../../../EzCommon/Library/dist/css/AdminLTE.min.css">
    <!-- AdminLTE Skins. We have chosen the skin-blue for this starter
          page. However, you can choose any other skin. Make sure you
          apply the skin class to the body tag so the changes take effect.
    -->
    <link rel="stylesheet" href="../../../../EzCommon/Library/dist/css/skins/skin-blue.min.css">
    <!-- Select2 -->
    <link rel="stylesheet" href="../../../../EzCommon/Library/plugins/select2/select2.min.css">
    <link rel="stylesheet" href="../../../../EzCommon/Library/plugins/pace/pacetopline.css">
    <!--datatables css-->
	<link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.responsive.min.css">
	<link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.tableTools.css">	
	<link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/jQuery-Validation/css/validationEngine.jquery.css">
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
    <style>
	.tx 
	{
		    border:0px;
	}
	th
	{
		    background-color: #3c8dbc;
		    color:white;
	}
	button
	{
		margin-left:2px;
	}
</style>	
  </head>

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
<!-- Content Header (Page header) --> 
<section class="content-header">

   <h1>
      Select Material 
 </h1>

</section>
<!-- Main content -->  
<section class="invoice">
<form name="myForm" method="post">
<input type="hidden" name="purchReq" value="">
<input type="hidden" name="saveSubStatus">

<%
	String toDayDate="";
	/*if("MM".equals(mmordd[0]))
	{
		toDayDate=fd.getStringFromDate(new java.util.Date(),".",ezc.ezutil.FormatDate.MMDDYYYY);
	}	
	else
	{
		toDayDate=fd.getStringFromDate(new java.util.Date(),".",ezc.ezutil.FormatDate.DDMMYYYY);
	}*/	

%>
<input type =hidden name="toDayDate" value="<%=toDayDate%>">
<input type =hidden name="toDayDateOriginal" value="<%=toDayDate%>">
<input type =hidden name="selPlant" value=''>
      <div class="row">
	<div class="col-xs-12 table-responsive">
	
<%
  
	if(matCnt == 0)
	{
%>
		<div class="callout callout-danger">
		
		                <p>There are no Materials to List.</p>
              	</div>
		<div style="margin-top:2%;margin-bottom:2%">
			<button type="button" class="btn btn-primary pull-right" onclick="window.parent.closeIframe()"><i class="fa fa-remove"></i>&nbsp;Close</button>
			<button type="button" class="btn btn-primary pull-right" onclick="javascript:history.go(-1)"><i class="fa fa-arrow-left"></i>&nbsp;Go Back</button>
		</div>
		
		
		
		
		
<%
		//return;
	}
	else
	{
%>	
	<table id="ezRCItemTab" class="table table-bordered">
	<thead>
	<Tr>
		<Th align="center">&nbsp;</Th>
		<Th align='center'>Material</Th>
		<Th align='center'>Material Desc</Th> 
		<Th align='center'>UOM</Th> 
		
		
		
	</Tr> 
	</thead>
	<tbody>
<%

	for(int m=0;m<matObj.getRowCount();m++)
	{
		String tempMat="";
		String dispMat= matObj.getFieldValueString(m,"MATNO");
		try
		{
			tempMat = Long.parseLong(dispMat)+"";
		}
		catch(Exception e)
		{
			tempMat = dispMat;	
		}
		String tempDesc=matObj.getFieldValueString(m,"MATDESC");
		tempDesc = tempDesc.replaceAll("'","`");
		tempDesc = tempDesc.replaceAll("\"", "`");
		tempDesc = tempDesc.replaceAll("$", "");
		tempDesc = tempDesc.replaceAll("&", "&amp;");
		tempDesc = tempDesc.replaceAll("<", "&lt;");
		tempDesc = tempDesc.trim();				
%>
	<Tr>
		
		<Td>
		<input type=radio name=radioVal value="<%=tempMat%>§§<%=tempDesc%>§§<%=matObj.getFieldValueString(m,"UOM")%>">
		</Td>
		
		<Td  align="center">
			<input type="hidden"  name="matNumber" id="matNumber"  maxlength="18" value="<%=tempMat%>">
			<%=tempMat%>
		</Td>
		
		<Td align="center">
			<input type="hidden"  name="matDesc" id="matDesc"  maxlength="18" value="<%=matObj.getFieldValueString(m,"MATDESC")%>">
			<%=matObj.getFieldValueString(m,"MATDESC")%>
		</Td>
		
		<Td align="center">
			<input type="hidden"  name="uom" id="uom"  maxlength="18" value="<%=matObj.getFieldValueString(m,"UOM")%>">
			<%=matObj.getFieldValueString(m,"UOM")%>		
		</Td>
		
		
	</Tr>
<%
	  
	}
%>
	</tbody>
	</table>
	 
	<div class="row no-print">
		<div class="col-xs-12">
			<button type="button" class="btn btn-primary pull-right" onclick="funOk()" style="margin-right: 5px;">OK</button>
			<button type="button" name="delbut" id="delbut"  class="btn btn-primary pull-right" onclick="closeWin()" style="margin-right: 5px;"> Back</button>

		</div>
	</div>
<%
	}
%>		
</div>
<!-- /.col -->
</div>
<!-- /.row -->
</form>
</section>

<!-- /.content -->
</div><!-- /.content-wrapper --> 





<Script src="../../Library/JavaScript/ezTrim.js"></Script>
 <script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>
    <script src="../../../../EzCommon/Library/plugins/jQueryUI/jquery-ui.min.js"></script>
    <script src="../../../../EzCommon/Library/plugins/select2/select2.full.min.js"></script>
     
    <!-- Bootstrap 3.3.5 -->
    <script src="../../../../EzCommon/Library/bootstrap/js/bootstrap.min.js"></script>
    <!-- AdminLTE App --> 
    <script src="../../../../EzCommon/Library/js/datepicker.js"></script>
    <script src="../../../../EzCommon/Library/js/alert_confirm.js"></script>
    <script src="../../../../EzCommon/Library/dist/js/app.min.js"></script>
	<script src="../../../../EzCommon/Library/dataTables/ZeroClipboard.js"></script>
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/jquery.dataTables.min.js"></script>
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/dataTables.bootstrap.min.js"></script>
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/dataTables.responsive.min.js"></script>
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/dataTables.tableTools.js"></script>	
	<script src="../../../../EzCommon/Library/plugins/pace/pace.min.js"></script>
    <!-- Optionally, you can add Slimscroll and FastClick plugins.
         Both of these plugins are recommended to enhance the
         user experience. Slimscroll is required when using the
         fixed layout. -->  
         <script src="../../../../EzCommon/Library/jQuery-Validation/js/jquery.validationEngine.js" type="text/javascript" charset="utf-8"></script>
         <script src="../../../../EzCommon/Library/jQuery-Validation/js/jquery.validationEngine-en.js" type="text/javascript" charset="utf-8"></script>
<script>
$(function() {
$('#nav')
    .stop()
    .animate({'marginRight':'-100px'},1000, function() { $(this).addClass('closed'); });

  function toggleDivs() {
    var $inner = $("#nav");
    var $img = $(".nav-btn img", $inner);

    if ($inner.hasClass('closed')) {
      $inner.animate({ right: "100px" }); 
      $img.attr('alt', 'close');
    } else {
      $inner.animate({ right: 0 });
      $img.attr('alt', 'open');
    }

    $inner.toggleClass('closed');
  }
$(".nav-btn").bind("click", function(){
    toggleDivs();
});

});
function funPlant(selplant)
{

document.myForm.action="ezMatSearchOptions.jsp";
document.myForm.submit();

}
function closeWin()   // Tested Code
{
//alert("kk");
  window.parent.$('#woModal').modal('hide');

}
function funOk()
{
var myIndex='<%=myIndex%>';
	var radioButtons = document.myForm.radioVal;
	
	var temp;	
	if(radioButtons.length > 1)
	{
		for (var x = 0; x < radioButtons.length; x ++) 
		{
			if (radioButtons[x].checked) 
			{
				temp = radioButtons[x].value;
			}
		}
	}
	else
	{
		if (radioButtons.checked) 
			temp=radioButtons.value;
	}

//alert(temp);
window.parent.document.getElementById("matNumber"+myIndex).value=temp.split("§§")[0];
window.parent.document.getElementById("matDesc"+myIndex).value=temp.split("§§")[1].replace("$","");
window.parent.document.getElementById("rfqUOM"+myIndex).value=temp.split("§§")[2];

//alert(plantList);
	//window.parent.document.myForm.plant.disabled='true';
window.parent.$('#woModal').modal('hide');	
}


</script>
<script type="text/javascript" class="init">
   $(document).ready( function () {
       $('#ezRCItemTab').dataTable( {
   	"dom": 'T<"clear">lfrtip',
   	
   	pageLength : 3,
    	lengthMenu: [[3, 6, 9, -1], [3, 6, 9, 'All']],   	
   	
   	"oTableTools": {
   	
   	    "sSwfPath": "../../../../EzCommon/Library/dataTables/swf/copy_csv_xls_pdf.swf", 
   	    "aButtons": [
   	    
   				{
   					"sExtends":    "xls",
   					 "sPdfOrientation": "landscape",
   					"sButtonText": "Download as Excel",
   					"sTitle": "report", // Excel file name 
   					 "sToolTip": "Save as Excel"
   
   				},
   				{
   					"sExtends":    "pdf",
   					 "sPdfOrientation": "landscape",
   					"sButtonText": "Download as PDF",
   					"sTitle": "report",
   					 "sToolTip": "Save as PDF"
   
   				}
   		
   
   			]
   	}
   	
       } );
   } );
   
   	
</script>