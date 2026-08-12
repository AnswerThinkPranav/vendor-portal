<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/JSPs/Misc/iEzDateConvertion.jsp" %>
<%@ page import="java.util.*,java.math.BigDecimal,java.math.RoundingMode" %> 
<%@ page import = "ezc.ezparam.*,ezc.ezutil.FormatDate.*" %>
<%@ page import="ezc.ezmisc.params.*" %> 
<%@ page import="ezc.sapconnection.*"%>
<%@ page import="com.sap.conn.jco.JCoDestination"%> 
<%@ page import="com.sap.conn.jco.JCoFunction"%>    
<%@ page import="com.sap.conn.jco.JCoParameterList"%>
<%@ page import="com.sap.conn.jco.JCoStructure"%> 
<%@ page import="com.sap.conn.jco.JCoTable"%>
<%@ page import ="ezc.ezparam.*" %>
<%@ page import ="java.util.*,java.text.*" %> 
<%@ page import = "ezc.ezcommon.*" %>
<%@ page import = "ezc.ezshipment.client.*" %> 
<%@ page import = "ezc.ezutil.FormatDate"%>  
<%@ page import = "ezc.ezshipment.params.*,ezc.ezvendorapp.params.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<jsp:useBean id="AppManager" class="ezc.ezvendorapp.client.EzVendorAppManager" />
<jsp:useBean id="PoManager"  class="ezc.client.EzPurchaseManager" scope="page" /> 
<jsp:useBean id="PcManager"  class ="ezc.client.EzPurContractManager" scope="page" />
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager"></jsp:useBean>
<%@ page import="ezc.ezmisc.params.*" %>
<%@ include file="../../../Includes/JSPs/Labels/iAddShipmentDetails_Labels.jsp"%>  
<%@ include file="ezShipConditions.jsp" %>  
<%@ include file="../Misc/ezCommonMethods.jsp" %>          
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>      
<%@ include file="../Misc/ezHeader.jsp"%>        
<%@ include file="../../../Includes/JSPs/Shipment/iModeOfTransport.jsp" %> 
<%@ include file="../../../Includes/Lib/ezGetDateFormat.jsp" %>
<%@ include file="../../../Includes/JSPs/Shipment/iAddMultiShipDetails.jsp" %>  
<%!
	boolean isMatNumRepeated(List<Object[]> objList, String matNum) {
							        for (Object[] obj : objList) {
							            if (obj[1].equals(matNum)) {
							                return true;
							            }
							        }
							        return false;
    						}
%>
<%
	session.putValue("IBD_CREATE","");  
	session.putValue("IBD_POST","");  
	String file_name="";
	List<Object[]> objList=new ArrayList<Object[]>();
	List<Object[]> objListCI=new ArrayList<Object[]>();
	String [] headerCols1=new String[]{"PO_NO","LINE_NO","RMO_NO","RANGE_NAME","SAP_MAT_DESCRIPTION"," MATERIAL_GROUP","HS_CODE"," MATERIAL","ENG_DESCRIPTION","MAN_DESCRIPTION","COLOR_ENG","COLOR_MAN","UOM","PO_ORDER_QTY","SUBMITTED_QUANTITY","BD_CONFIRMED_QUANTITY","Balance_Qty","SHIP_QTY","QTY_OF_PACKAGE","QTY_PER_PACKAGE_UNIT","TOTAL_QTY","VOLUME_CBM","TOTAL_NET_WEIGHT_KGS","TOTAL_GROSS_WEIGHT_KGS","CONTAINER_NO","SEAL_NO"};
	String [] headerCols2=new String[]{"PO NO","MATERIAL", "MAT DESCRIPTION","COLOR(ENG)", "UOM","HSN/SAC",    "INVOICED QTY", "UNIT PRICE IN USD", "TOTAL VALUE IN USD"};
	
	/*Get conf details of the selected POs start***********/
	ezc.ezparam.ReturnObjFromRetrieve retConfRetObj = null;
	int retConfRetObjCnt=0;
	retConfRetObj=ezMiscSelect(Session,"SELECT EPCH_SAP_PO_NO,EPCI_MAT_CODE,EPCI_MATGRP,EPCI_RMONO,EPCI_RANGE FROM EZC_PRPO_CONF_ITEMS,EZC_PRPO_CONF_HEADER WHERE EPCI_DOC_ID=EPCH_DOC_ID AND EPCI_DOC_ID IN (SELECT EPCH_DOC_ID FROM EZC_PRPO_CONF_HEADER WHERE EPCH_SAP_PO_NO IN ("+ponum+"))");
	if(retConfRetObj!=null)
		retConfRetObjCnt=retConfRetObj.getRowCount(); 
	java.util.Hashtable<String,String> confRMOGRP = new java.util.Hashtable<String,String>();
	for(int i=0;i<retConfRetObjCnt;i++)
	{
		confRMOGRP.put(retConfRetObj.getFieldValueString(i,"EPCH_SAP_PO_NO")+"##"+retConfRetObj.getFieldValueString(i,"EPCI_MAT_CODE"),retConfRetObj.getFieldValueString(i,"EPCI_RMONO")+"##"+retConfRetObj.getFieldValueString(i,"EPCI_MATGRP")+"##"+retConfRetObj.getFieldValueString(i,"EPCI_RANGE"));
	}	
	//out.println(":confRMOGRP:"+confRMOGRP);
	/*Get conf details of the selected POs end***********/
	
	ReturnObjFromRetrieve retMasKeyVal=ezMiscSelect(Session,"SELECT * FROM EZC_MASTER_KEY_VALUES WHERE EMKV_MASTER_TYPE in ('ASN_IMP_DOC')");
	String mapType="";
	int retMasKeyValCnt = 0; 
	if(retMasKeyVal != null)
		retMasKeyValCnt = retMasKeyVal.getRowCount();
	
 	String purOrg   = ((String)Session.getUserPreference("PURORG"));
 	ezc.ezbasicutil.EzCurrencyFormat myFormat= new ezc.ezbasicutil.EzCurrencyFormat();
	myFormat.setLocale((java.util.Locale)session.getValue("LOCALE"));
	myFormat.setNeedSybmol(((Boolean)session.getValue("SREQUIRED")).booleanValue());
	myFormat.isPre(((Boolean)session.getValue("CPOSITION")).booleanValue());
	myFormat.setSymbol((String)session.getValue("CURRENCY"));
	
	
	ReturnObjFromRetrieve qtyRetObj=null;
	int qtyRetObjCnt=0;
	String portalIvQty = "";
	String portalIvValue="";
	/*
	ezc.ezparam.EzcParams mainParams_c	= new ezc.ezparam.EzcParams(false); 
	EziMiscParams miscParams_c		= new EziMiscParams();
	miscParams_c.setQuery("SELECT EZSL_MAT_DESC,sum(EZSL_QTY_SHIPPED) QTY,sum(EZSL_PRICE) PRICE FROM  EZC_SHIPMENT_HEADER,EZC_SHIPMENT_LINES WHERE  EZSH_SH_ID=EZSL_SH_ID and EZSH_PO_NUM='"+ponum+"' AND EzsH_SMARTDOC_STATUS NOT IN('99999','5') and EZSH_STATUS='I' GROUP BY EZSH_PO_NUM,EZSL_LINE_NR,EZSL_MAT_DESC");
	mainParams_c.setLocalStore("Y");
	mainParams_c.setObject(miscParams_c);
	Session.prepareParams(mainParams_c);
	try
	{
		qtyRetObj=(ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams_c);
		if(qtyRetObj!=null)
		{
			qtyRetObjCnt=qtyRetObj.getRowCount();
			//portalIvQty=checkNullNum(qtyRetObj.fieldValueString(0,"QTY"));
		}

	}
	catch(Exception e)
	{
		ezc.ezcommon.EzLog4j.log(":::::::::::QTY:::::Exception::::::"+e,"E");
	}*/
	//out.println("dtlXML=="+dtlXML.toEzcString());
	ezc.ezcommon.EzLog4j.log(":::::::::::check1111","I");
%>
 
 <html>
 <head>
 
  <link rel="stylesheet" href="../Misc/library/fancybox2/jquery.fancybox.css" type="text/css" media="screen" />
  
 
	<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
	<script src="../../Library/JavaScript/ezTrim.js"></script>
	<script src="../../Library/JavaScript/ezConvertDates.js"></Script> 
	<script src="xlsx.core.min.js"></Script>
	<script src="tableexport.min.js"></Script>
	<script src="https://unpkg.com/tableexport/dist/tableexport.min.js"></script>
	<script type="text/javascript" charset="utf-8" src="jquery.js"></script>
	 <Script src="jquery.autocomplete.js"></Script>
<link type="text/css" rel="stylesheet" href="styleAuto.css">
<link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/jQuery-Validation/css/validationEngine.jquery.css">
<link rel="stylesheet" href="../../../../EzCommon/Library/plugins/select2/select2.min.css">
<style>
   .table>tbody>tr>td, .table>tbody>tr>th, .table>tfoot>tr>td, .table>tfoot>tr>th, .table>thead>tr>td, .table>thead>tr>th {
   
   line-height: inherit !important;
   }
   th
   {	
       color: white;
       background: #325786;
   	
   }

   /*a {
        color: #337ab7 !important;
        text-decoration: none !important;
	}*/

    .datepicker{ z-index:99999 !important; }

    .tx {
    	      border:0px;
	}
	
    #tabs {
	text-align: center;
    }
    #tabs ul {
	display: inline-block;
	margin: 0;
	padding: 0;
	webkit-box-sizing: unset; 
	    -moz-box-sizing: unset;
    box-sizing: unset;
	
    }
    
    
    #tabs li {
	float: left;
	padding: 5px 10px;
    }
    .Clearboth
    {
        clear: both;
    }
     
    .divright
    {
    float:right;
    }
     
    .divleft
    {
    float:left;
    }
    .tableHeader{
    	background-color: #3c8dbc;
    	text-align: center !important;
    }
    .dow{
    	width: 16px;
    }
    th
    {
    	text-align: left;
    	font-family: -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif,"Apple Color Emoji","Segoe UI Emoji","Segoe UI Symbol";
        font-weight: 500;
        font-size:13;
	color: #212529;
	line-height: 2.4 !important;

    }
   input[type="text"]
   {
       font-size:14px;
   }
    #tabContents
    {
    	    
	    text-align: left;

    	
    }
    .select2-container--default .select2-selection--single {
         border: 1px solid #d2d6de ;
         border-radius: 0px;
     }
     .select2-container
     {
     	width: 100% !important;
     }
     .select2-container--default .select2-selection--single .select2-selection__rendered {
         line-height: 24px;
	}
    
    .content-wrapper, .right-side, .main-footer {
    	margin-left: 0px !important; 
    }
    
    .funkyradio div {
      //clear: both;
      overflow: hidden;
    }
    
    .funkyradio label {
      width: 100%;
      border-radius: 3px;
      border: 1px solid #D1D3D4;
      font-weight: normal;
    }
    
    .funkyradio input[type="radio"]:empty,
    .funkyradio input[type="checkbox"]:empty {
      display: none;
    }
    
    .funkyradio input[type="radio"]:empty ~ label,
    .funkyradio input[type="checkbox"]:empty ~ label {
      position: relative;
      line-height: 2.0em;
      text-indent: 3.25em;
      margin-top: 2em;
      cursor: pointer;
      -webkit-user-select: none;
         -moz-user-select: none;
          -ms-user-select: none;
              user-select: none;
    }
    
    .funkyradio input[type="radio"]:empty ~ label:before,
    .funkyradio input[type="checkbox"]:empty ~ label:before {
      position: absolute;
      display: block;
      top: 0;
      bottom: 0;
      left: 0;
      content: '';
      width: 2.5em;
      background: #D1D3D4;
      border-radius: 3px 0 0 3px;
    }
    
    .funkyradio input[type="radio"]:hover:not(:checked) ~ label,
    .funkyradio input[type="checkbox"]:hover:not(:checked) ~ label {
      color: #888;
    }
    
    .funkyradio input[type="radio"]:hover:not(:checked) ~ label:before,
    .funkyradio input[type="checkbox"]:hover:not(:checked) ~ label:before {
      content: '\2714';
      text-indent: .9em;
      color: #C2C2C2;
    }
    
    .funkyradio input[type="radio"]:checked ~ label,
    .funkyradio input[type="checkbox"]:checked ~ label {
      color: #777;
    }
    
    .funkyradio input[type="radio"]:checked ~ label:before,
    .funkyradio input[type="checkbox"]:checked ~ label:before {
      content: '\2714';
      text-indent: .9em;
      color: #333;
      background-color: #ccc;
    }
    
    .funkyradio input[type="radio"]:focus ~ label:before,
    .funkyradio input[type="checkbox"]:focus ~ label:before {
      box-shadow: 0 0 0 3px #999;
    }
    
    .funkyradio-default input[type="radio"]:checked ~ label:before,
    .funkyradio-default input[type="checkbox"]:checked ~ label:before {
      color: #333;
      background-color: #ccc;
    }
    
    .funkyradio-primary input[type="radio"]:checked ~ label:before,
    .funkyradio-primary input[type="checkbox"]:checked ~ label:before {
      color: #fff;
      background-color: #337ab7;
    }
    
    .funkyradio-success input[type="radio"]:checked ~ label:before,
    .funkyradio-success input[type="checkbox"]:checked ~ label:before {
      color: #fff;
      background-color: #5cb85c;
    }
    
    .funkyradio-danger input[type="radio"]:checked ~ label:before,
    .funkyradio-danger input[type="checkbox"]:checked ~ label:before {
      color: #fff;
      background-color: #d9534f;
    }
    
    .funkyradio-warning input[type="radio"]:checked ~ label:before,
    .funkyradio-warning input[type="checkbox"]:checked ~ label:before {
      color: #fff;
      background-color: #f0ad4e;
    }
    
    .funkyradio-info input[type="radio"]:checked ~ label:before,
    .funkyradio-info input[type="checkbox"]:checked ~ label:before {
      color: #fff;
      background-color: #5bc0de;
    }
    .btn.btn-default span.glyphicon {    			
    	opacity: 0;				
    }
    .btn.btn-success.active span.glyphicon {				
    	opacity: 1;				
}

.switch input { 
  opacity: 0;
  width: 0;
  height: 0;
}

.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #ccc;
  -webkit-transition: .4s;
  transition: .4s;
}

.slider:before {
  position: absolute;
  content: "";
  height: 26px;
  width: 26px;
  left: 4px;
  bottom: 4px;
  background-color: white;
  -webkit-transition: .4s;
  transition: .4s;
}

input:checked + .slider {
  background-color: #2196F3;
}

input:focus + .slider {
  box-shadow: 0 0 1px #2196F3;
}

input:checked + .slider:before {
  -webkit-transform: translateX(26px);
  -ms-transform: translateX(26px);
  transform: translateX(26px);
}

/* Rounded sliders */
.slider.round {
  border-radius: 34px;
}

.slider.round:before {
  border-radius: 50%;
}

.toggle_radio{
  position: relative;
  background: #497dd0;
  margin: 4px auto;
  overflow: hidden;
  padding: 0 !important;
  -webkit-border-radius: 50px;
  -moz-border-radius: 50px;
  border-radius: 50px;
  position: relative;
  height: 26px;
  width: 215px;
}
.toggle_radio > * {
  float: left;
}
.toggle_radio input[type=radio]{
  display: none;
  /*position: fixed;*/
}
.toggle_radio label{
  font: 90%/1.618 "Source Sans Pro";
  color: #fff;
  z-index: 0;
  display: block;
  width: 100px;
  height: 20px;
  margin: 3px 3px;
  -webkit-border-radius: 50px;
  -moz-border-radius: 50px;
  border-radius: 50px;
  cursor: pointer;
  z-index: 1;
  background: #497dd0;
  text-align: center;
  /*margin: 0 2px;*/
  /*background: blue;*/ /*make it blue*/
}
.toggle_option_slider{
  /*display: none;*/
  /*background: red;*/
  width: 100px;
  height: 20px;
  position: absolute;
  top: 3px;
  -webkit-border-radius: 50px;
  -moz-border-radius: 50px;
  border-radius: 50px;
  -webkit-transition: all .4s ease;
  -moz-transition: all .4s ease;
  -o-transition: all .4s ease;
  -ms-transition: all .4s ease;
  transition: all .4s ease;
}
.toggle_radio4{
  position: relative;
  background: #497dd0;
  margin: 4px auto;
  overflow: hidden;
  padding: 0 !important;
  -webkit-border-radius: 50px;
  -moz-border-radius: 50px;
  border-radius: 50px;
  position: relative;
  height: 26px;
  width: 425px;
}
.toggle_radio4 > * {
  float: left;
}
.toggle_radio4 input[type=radio]{
  display: none;
  /*position: fixed;*/
}
.toggle_radio4 label{
  font: 90%/1.618 "Source Sans Pro";
  color: #fff;
  z-index: 0;
  display: block;
  width: 100px;
  height: 20px;
  margin: 3px 3px;
  -webkit-border-radius: 50px;
  -moz-border-radius: 50px;
  border-radius: 50px;
  cursor: pointer;
  z-index: 1;
  background: #497dd0;
  text-align: center;
  /*margin: 0 2px;*/
  /*background: blue;*/ /*make it blue*/
}
.toggle_option_slider4{
  /*display: none;*/
  /*background: red;*/
  width: 100px;
  height: 20px;
  position: absolute;
  top: 3px;
  -webkit-border-radius: 50px;
  -moz-border-radius: 50px;
  border-radius: 50px;
  -webkit-transition: all .4s ease;
  -moz-transition: all .4s ease;
  -o-transition: all .4s ease;
  -ms-transition: all .4s ease;
  transition: all .4s ease;
}

#propYes:checked ~ .toggle_option_slider{
  background: rgba(255,255,255,.3);
  left: 3px;
}
#partCompYes:checked ~ .toggle_option_slider{
  background: rgba(255,255,255,.3);
  left: 109px;
}
  #pvtCompYes:checked ~ .toggle_option_slider{
  background: rgba(255,255,255,.3);
  left: 215px;
}
#pubCompYes:checked ~ .toggle_option_slider{
  background: rgba(255,255,255,.3);
  left: 320px;
 } 
#ServYes:checked ~ .toggle_option_slider
{
 background: rgba(255,255,255,.3);
  left: 3px;
}
#ManfYes:checked ~ .toggle_option_slider
{
background: rgba(255,255,255,.3);
  left: 109px;
}

#whNo:checked ~ .toggle_option_slider{
  background: rgba(255,255,255,.3);
  left: 109px;
}

}
.table>tbody>tr>td, .table>tbody>tr>th, .table>tfoot>tr>td, .table>tfoot>tr>th, .table>thead>tr>td, .table>thead>tr>th {

line-height: inherit !important;
}
th
{	
    color: white;
    background: #325786;
	
}
.modal-dialog {
  width: 100%;
  height: 100%;
  margin: 0;
  padding: 0;
}

.modal-content {
  height: auto;
  min-height: 100%;
  border-radius: 0;
}
iframe
{
  width: 100% !important;
  height: 100% !important;	
}
   </style>

	<script>
		var refdGtSdt_L = '<%=refdGtSdt_L%>' 
		var invdGteSdt_L = '<%=invdGteSdt_L%>'
		var sdtGteOdt_L = '<%=sdtGteOdt_L%>'
		var arrdtGteSdt_L = '<%=arrdtGteSdt_L%>'
		var arrdtGteTdt_L = '<%=arrdtGteTdt_L%>'
		var refdLteSdt_L = '<%=refdLteSdt_L%>'
		var plzVldQty_L = '<%=plzVldQty_L%>'
		var plzQtyZero_L = '<%=plzQtyZero_L%>'
		var plzEnRdcno_L = '<%=plzEnRdcno_L%>'
		var plzEnRdcdt_L = '<%=plzEnRdcdt_L%>' 
		var plzEnInvNo_L = '<%=plzEnInvNo_L%>'
		var plzEnInvdt_L = '<%=plzEnInvdt_L%>' 
		var plzEnLrno_L = '<%=plzEnLrno_L%>'
		var plzShDate_L = '<%=plzShDate_L%>'
		var plzEnCrrn_L = '<%=plzEnCrrn_L%>'
		var plzExparrDt_L = '<%=plzExparrDt_L%>'
		var plzEnShdet_L = '<%=plzEnShdet_L%>'
		var plzEnShOneDet_L = '<%=plzEnShOneDet_L%>'
		var plzShLine_L = '<%=plzShLine_L%>'
		var plzAtlOneSh_L = '<%=plzAtlOneSh_L%>'
		var plsActDel_L = '<%=plsActDel_L%>'
		var thisDelBatch_L = '<%=thisDelBatch_L%>'

	</script>
	<script src="../../Library/JavaScript/ezShipValidations.js"></script>
 <Script>    
 
 if(typeof String.prototype.trim !== 'function') {
    String.prototype.trim = function() {
      return this.replace(/^\s+|\s+$/g, ''); 
    }
}
 
 var tabHeadWidth=90
 var tabHeight="40%"
 </Script>
 <script src="../../Library/JavaScript/ezTabScroll.js"></Script>

 <%
		ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate();

		Date dd=new Date();
		String ss=fd.getStringFromDate(dd,(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
		String orderDate=fd.getStringFromDate((java.util.Date)dtlXML.getFieldValue(0,"ORDERDATE"),(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
		int checkForButtons = 0;  //Added by sudhir on 5.04.2003

 %>
 <script src="../../Library/JavaScript/ezTrim.js"></script>
	<script>
	dateFormat='<%=Integer.parseInt((String)session.getValue("DATEFORMAT"))%>';
	var totalbatches;
	function confirmDetails()
	{
		var msgAlert ="Below are the details filled by you,  click on Ok to continue or Cancel if you need to change the details.\n";
		msgAlert+="\n";
		/*msgAlert+="Mode of Transport :"+document.myForm.modeOfTransport.value;
		msgAlert+=" | Invoice Date : "+document.myForm.DCDate.value+"\n";
		msgAlert+="Invoice Number :"+document.myForm.InvoiceNo.value;
		msgAlert+="| Shipment Date : "+document.myForm.ShipDate.value+"\n";
		msgAlert+="AWB/ B/L / LR Number / Hand Delivery : "+document.myForm.LR.value+"\n";
		msgAlert+="Expected Arrival Date At Give Port/VIP : "+document.myForm.ExpectedArivalTime.value+"\n";
		msgAlert+="Transporter Name : "+document.myForm.CarrierName.value;
		msgAlert+="| LR.Date : "+document.myForm.modeOfTransport.value+"\n";
		msgAlert+="No. of Packages : "+document.myForm.noOfPacks.value;
		msgAlert+="Total Weight : "+document.myForm.totalWeight.value+"\n";
		msgAlert+="Truck Number: "+document.myForm.vehicleNo.value+" \n";
		*/
		
		
		msgAlert+="Mode of Transport   : "+document.myForm.modeOfTransport.value +"        Invoice Date    :\t"+document.myForm.DCDate.value+"\n";
		msgAlert+="Invoice Number   :\t"+document.myForm.InvoiceNo.value +"           Shipment Date    :\t"+document.myForm.ShipDate.value+"\n";
		msgAlert+="B/L / LR Number   :\t"+document.myForm.LR.value +"        Expected Arrival Date At Give Port/VIP    :\t"+document.myForm.ExpectedArivalTime.value+"\n";
		msgAlert+="Transporter Name :\t"+document.myForm.CarrierName.value +"        LR.Date    :\t"+document.myForm.LRDate.value+"\n";
		//msgAlert+="No. of Packages  :\t"+document.myForm.noOfPacks.value +"        Total Weight :\t"+document.myForm.totalWeight.value+"\n\n\n";
		//msgAlert+="Truck Number   :\t"+document.myForm.vehicleNo.value+"\n\n\n";
		
		
		
		var matNumber = document.myForm.matNum;
		var matLen = matNumber.length;
		//alert(msgAlert+""+matLen)
		
		msgAlert+="Line\tMaterial\t\tDescription\t\t  Qty\n"
		msgAlert+="====\t========\t===========\t\t===\n";
		
		
		if(isNaN(matLen))
		{
			/*msgAlert+="Line  "+document.myForm.Line.value;
			msgAlert+="Material   "+document.myForm.matNum.value;
			msgAlert+="Description  "+document.myForm.Description.value;
			msgAlert+="Qty"+document.myForm.EnterQty.value+"\n";	
			*/
			
			msgAlert+=document.myForm.Line.value+"\t"+document.myForm.matNum.value+"\t\t"+document.myForm.Description.value+"\t"+document.myForm.EnterQty.value+"\n";
		}
		else{
			for(var i=0;i<matLen;i++)
			{
				var EnterQty = document.myForm.EnterQty[i].value
				if(EnterQty == "" || EnterQty == "0")
					continue;
				/*msgAlert+="Line : "+document.myForm.Line[i].value+"\n";
				msgAlert+="Material : "+document.myForm.matNum[i].value+"\n";
				msgAlert+="Description : "+document.myForm.Description[i].value+"\n";
				msgAlert+="Entered Qty : "+EnterQty+"\n";*/
				
				msgAlert+=document.myForm.Line[i].value+"\t"+document.myForm.matNum[i].value+"\t"+document.myForm.Description[i].value+"\t"+EnterQty+"\n";
				
				
				
			}
		}
		return confirm(msgAlert);

	}
	//Calling when click on Submit Button
	function doSendMailConfirm(obj){
		
		var flg2=false;
		var flg3=false;
		var totqty=0;
		var overDelvTolPerc = "0";
		
		if(document.myForm.EnterQty!=null)
		{
			var itemLen = document.myForm.EnterQty.length;
			if(isNaN(itemLen))
			{
				overDelvTolPerc = document.myForm.overDelvTolPerc.value;
				alert(":overDelvTolPerc:"+overDelvTolPerc);
				deliveredQty = document.myForm.deliveredQty.value;
				tempToleranceValue = document.myForm.tempToleranceValue.value;
				totPOItemQty = document.myForm.totPOItemQty.value;
				argQtd=document.myForm.QuanToBeShip.value;
				enteredQty = funTrim(document.myForm.EnterQty.value);

				if(enteredQty=="" || enteredQty=="0")
				{
					alert("Please Enter Shipment Details")
					return false;
				}else{

					totqty=parseFloat(enteredQty,10);		
					qtd = (parseFloat(totPOItemQty,10)+parseFloat(tempToleranceValue,10))-deliveredQty;
					if(totqty>parseFloat(qtd))
					{
						alert("Entered Quantity ("+totqty+") is greater than To Be Delivered Qty "+argQtd +" + "+overDelvTolPerc+"%  on PO Qty = "+ (parseFloat(argQtd,10)+(parseFloat(totPOItemQty,10)*(overDelvTolPerc/100))));
						return false;
					}

				}


				document.myForm.batches.value="NA§NA§NA§"+document.myForm.EnterQty.value+"§NA";
				document.myForm.Quantity.value=totqty;
				document.myForm.schdflag.value="Y";

			}else{
				var bool=false;
				for(j=0;j<itemLen;j++)
				{
					enteredQty = funTrim(document.myForm.EnterQty[j].value);
					if(enteredQty!="" && enteredQty!="0")
					{
						bool=true;
						break;
					}
				}
				if(bool==false)
				{
					alert("Please Enter Shipment Details for atleast one Product ");
					return false;
				}else{
					alert("::itemLen::"+itemLen);
					for(i=0;i<itemLen;i++)
					{
						alert(":hi:");
						overDelvTolPerc = document.myForm.overDelvTolPerc[i].value;
						alert(i+":overDelvTolPerc:"+overDelvTolPerc);
					 	deliveredQty = document.myForm.deliveredQty[i].value;
						tempToleranceValue = document.myForm.tempToleranceValue[i].value;
						totPOItemQty = document.myForm.totPOItemQty[i].value;
						argQtd=document.myForm.QuanToBeShip[i].value;
						enteredQty = funTrim(document.myForm.EnterQty[i].value);

						if(enteredQty!="0" && enteredQty!="")
						{
							totqty=parseFloat(enteredQty,10);		
							qtd = (parseFloat(totPOItemQty,10)+parseFloat(tempToleranceValue,10))-deliveredQty;
							if(parseFloat(totqty)>parseFloat(qtd))
							{
								alert("Product "+document.myForm.MaterialNr[i].value+" of the entered Quantity ("+totqty+") is greater than To Be Delivered Qty "+argQtd +" + "+overDelvTolPerc+"%  on PO Qty = "+ (parseFloat(argQtd,10)+(parseFloat(totPOItemQty,10)*(overDelvTolPerc/100))));
								return false;
							}
							document.myForm.batches[i].value="NA§NA§NA§"+document.myForm.EnterQty[i].value+"§NA";
							document.myForm.Quantity[i].value=totqty;
							document.myForm.schdflag.value="Y";
						}	
					}
				}	
			}			
		}
		/*
		flg1=validateFields();
		if(flg1)
		{
			var ss=ConvertDate('<%=ss%>','<%=Integer.parseInt((String)session.getValue("DATEFORMAT"))%>')
			var orderDate=ConvertDate('<%=orderDate%>','<%=Integer.parseInt((String)session.getValue("DATEFORMAT"))%>')

			flg3=funDateCheck(ss,orderDate)
		}


		if (flg1 && flg3)
			flg2= funBatchCheck();
<%
	if(vendFrtCondList.contains(frtCond))
	{
%>
	if(document.myForm.taxFeight.value != "" && document.myForm.nonTaxFeight.value != "")
	{
		alert("Please enter either taxable freight value or non taxable freight value");
		return ;
	}
<%
	}
%>		
	if(document.myForm.attachDocFiles.value == "")
	{
		alert("Please upload invoice. Click on Upload Docs button to upload invoice");
		//return ;
	}*/
		
		//if (flg1&&flg2)  
		{
			if(confirm("Are you sure you want to submit shipment?"))
			{
				$("#subBtn").hide();
				//document.getElementById("msgDiv").style.visibility="visible"
				if(document.myForm.shipflag.value=="")
				{
					document.myForm.shipflag.value="N";
				}
				//if(totTaxAndValue) 

				document.myForm.status.value="Y";
				document.myForm.sendMail.value="Yes";
				document.myForm.action="ezAddSaveMultiShipDetails.jsp";
				//setMessageVisible(); 
				document.myForm.submit();
			}
		}
	}
	function submitShipment()
	{
		if(confirm("Are you sure you want to submit shipment?"))
		{
			document.myForm.status.value="Y";
			document.myForm.sendMail.value="Yes";
			document.myForm.action="ezAddSaveMultiShipDetails.jsp";
			//setMessageVisible(); 
			document.myForm.submit();
		}
	}

	var shipattach;
	function openUploadWindow()
	{
		var filestring=document.myForm.shipupload.value
		shipattach=window.open("ezAttachmentFile.jsp?filestring="+filestring,"UserWindow1","width=450,height=400,left=150,top=100,resizable=no,scrollbars=yes,toolbar=no,menubar=no");
	}
	function funSearch()
	{
		document.myForm.action="ezAddShipmentDetails.jsp";
		document.myForm.submit();
	}
	
	/*function funCopyDate()
	{
		if(document.myForm.ShipDate.value!='')
		{
			document.myForm.ExpectedArivalTime.value = document.myForm.ShipDate.value;
			document.myForm.LRDate.value = document.myForm.ShipDate.value;
		}
	}*/
	
	function GetXmlHttpObject()
	{
		if(window.XMLHttpRequest)
		{
			return new XMLHttpRequest();
		}
		if(window.ActiveXObject)
		{
			return new ActiveXObject("Microsoft.XMLHTTP");
		}
		return null;
	}

	var xmlhttp;
	function checkInvoice()
	{	
		/*
		var invoiceNo 	= document.myForm.InvoiceNo.value;
		var vendorCode	= "<%=vendor%>";	

		xmlhttp = GetXmlHttpObject();
		if(xmlhttp==null)
		{
			alert ("Your browser does not support Ajax HTTP");
			return;
		}
		var url="ezCheckInvoice.jsp?invoiceNo="+invoiceNo+"&vendorCode="+vendorCode+"&date="+new Date();
		if(xmlhttp!=null)
		{
			xmlhttp.onreadystatechange=Process;
			xmlhttp.open("GET",url,true);
			xmlhttp.send(null);
		}
		*/
	}
	function Process()
	{
		if(xmlhttp.readyState==4)
		{
			var resText = xmlhttp.responseText;
			var resultText	= resText.split("##");
			var retResultCnt= resultText[1];

			if(parseFloat(retResultCnt)>0)
			{
				alert("Invoice Number is already given.");
				document.myForm.InvoiceNo.value="";
				document.myForm.InvoiceNo.focus();
				return;
			}
		}
	}
	function calculateValue(index,TotalQty,totalIVQty) 
	{
		var len = document.myForm.EnterQty.length;
		totnetValVar = 0;
		totTaxValueVar = 0;
		var toBeDeliveredQty=parseFloat(TotalQty)-parseFloat(totalIVQty);
		if(isNaN(len))
		{
		
			qtyEntered  = document.myForm.EnterQty.value;
			netAmountVar= document.myForm.netAmountOne.value;
			itemTaxValVar= document.myForm.itemTaxVal.value;
			if(qtyEntered>toBeDeliveredQty)
			{
				alert("Entered Quantity is greater than actual PO quantity");
				document.myForm.EnterQty.value="";
				document.myForm.EnterQty.focus();
				return;
			}
			else
			{
				if(qtyEntered!=0 || qtyEntered!="")
				{

					varTotNetVal = qtyEntered*netAmountVar;
					varTotNetVal = varTotNetVal.toFixed(2);
					document.myForm.netValue.value = varTotNetVal;
					document.myForm.toaNetValue.value = document.myForm.netValue.value;
					//document.myForm.taxAndVal.value = (parseFloat((itemTaxValVar/100)*varTotNetVal)+parseFloat(varTotNetVal)).toFixed(2);
					//document.myForm.taxAndVal.value = (parseFloat((itemTaxValVar/100)*varTotNetVal)).toFixed(2);
					document.myForm.taxAndVal.value = parseFloat(itemTaxValVar*qtyEntered).toFixed(2);
					document.myForm.toaTaxValue.value = parseFloat(document.myForm.taxAndVal.value).toFixed(2);;

					document.myForm.totTaxAndValue.value = (parseFloat(document.myForm.toaNetValue.value) + parseFloat(document.myForm.toaTaxValue.value)).toFixed(2);
					document.myForm.totalTaxANDVal.value = (parseFloat(document.myForm.toaNetValue.value) + parseFloat(document.myForm.toaTaxValue.value)).toFixed(2);
				}
			}
			
		}
		else
		{
			qtyEntered  = document.myForm.EnterQty[index].value;
			netAmountVar= document.myForm.netAmountOne[index].value;
			itemTaxValVar   = document.myForm.itemTaxVal[index].value;
			if(qtyEntered!=0 || qtyEntered!="")
			{
				netValVar = (qtyEntered*netAmountVar).toFixed(2);
				document.myForm.netValue[index].value = netValVar; 
				
				//document.myForm.taxAndVal[index].value = (parseFloat((itemTaxValVar/100)*netValVar)+parseFloat(netValVar)).toFixed(2);
				//document.myForm.taxAndVal[index].value = (parseFloat((itemTaxValVar/100)*netValVar)).toFixed(2);
				document.myForm.taxAndVal[index].value = parseFloat(itemTaxValVar*qtyEntered).toFixed(2);
				
				
			}
			
			for(i=0;i<len;i++)
			{
				qtyEntered  = document.myForm.EnterQty[i].value;
				
				if(qtyEntered>toBeDeliveredQty)
				{
					alert("Entered Quantity is greater than actual PO quantity");
					document.myForm.EnterQty[i].value="";
					document.myForm.EnterQty[i].focus();
					return;
				}
				
				netValVar = document.myForm.netValue[i].value;
				totnetValVar = totnetValVar+parseFloat(netValVar);
				
				taxAndValVar = document.myForm.taxAndVal[i].value;
				totTaxValueVar = totTaxValueVar+parseFloat(taxAndValVar);
				
				
				
			}
			//totnetValVar = totnetValVar.toFixed(2);
			document.myForm.toaNetValue.value = totnetValVar.toFixed(2);
			document.myForm.toaTaxValue.value = totTaxValueVar.toFixed(2);
			
			document.myForm.totTaxAndValue.value = (parseFloat(document.myForm.toaNetValue.value) + parseFloat(document.myForm.toaTaxValue.value)).toFixed(2);
			document.myForm.totalTaxANDVal.value = (parseFloat(document.myForm.toaNetValue.value) + parseFloat(document.myForm.toaTaxValue.value)).toFixed(2);
			//alert(":::"+document.myForm.totTaxAndValue.value);
		}
	} 
	function funCalValues(index,TotalQty,totalIVQty,overTolerance)
	{
		var checkLen=document.myForm.EnterQty.length;
		var qtyEntered;
		var tempQtyEntered;
		var totValue;
		var taxValVar;
		var netAmountVar;
		var itemTaxValVar;
		var itemMiscValVar;
		var toBeDeliveredQty;
		var itemFrtValVar;
		var frtCond=document.myForm.frtCond.value;
		
		
		
		if(parseFloat(overTolerance)>0)
		{
			toBeDeliveredQty = (parseFloat(TotalQty)-parseFloat(totalIVQty))+(parseFloat(TotalQty)*parseFloat(overTolerance)/100);
			
		}
		else
		{
		toBeDeliveredQty=(parseFloat(TotalQty)-parseFloat(totalIVQty));
		}
		
		//**check quantity
		
		try {
		if(isNaN(checkLen))
		{
			tempQtyEntered=document.myForm.EnterQty.value;
			if(tempQtyEntered>toBeDeliveredQty)
			{
				alert("Entered Quantity is greater than actual PO quantity/(PO quantity+Tolerance Limit)");
				document.myForm.EnterQty.value="";
				document.myForm.EnterQty.focus();
				return;
			}
		}
		else
		{
			tempQtyEntered=document.myForm.EnterQty[index].value;
			if(tempQtyEntered>toBeDeliveredQty)
			{
				alert("Entered Quantity is greater than actual PO quantity/(PO quantity+Tolerance Limit)");
				document.myForm.EnterQty[index].value="";
				document.myForm.EnterQty[index].focus();
				return;
			}

		}
		}
		catch(err) {
		}
		
		//** check quantity
		
		
		
		//alert("::::toBeDeliveredQty::::::"+toBeDeliveredQty);
		if(isNaN(checkLen))
		{
			qtyEntered=document.myForm.EnterQty.value;
			/*
			if(qtyEntered>toBeDeliveredQty)
			{
				alert("Entered Quantity is greater than actual PO quantity/(PO quantity+Tolerance Limit)");
				document.myForm.EnterQty.value="";
				document.myForm.EnterQty.focus();
				return;
			}
			else*/
			{
				if(qtyEntered!=0 || qtyEntered!='')
				{
					try{
					totValue = parseFloat(document.myForm.EnterQty.value)*parseFloat(document.myForm.netAmountOne.value);
					if(isNaN(totValue))totValue="0";
					totValue=totValue.toFixed(2);
					}catch(error){totValue="0";}
					document.myForm.netValue.value=totValue;
					itemTaxValVar= document.myForm.itemTaxVal.value;
					document.myForm.taxAndVal.value = parseFloat(itemTaxValVar*qtyEntered).toFixed(2);
					document.myForm.taxAndVal12.value=parseFloat(itemTaxValVar*qtyEntered).toFixed(2);
					if(frtCond != "" && frtCond != null)
					{
						itemFrtValVar= document.myForm.frtCondPerQty.value;
						document.myForm.frtCondVal.value=parseFloat(itemFrtValVar*qtyEntered).toFixed(2);
					}
<%
	for(int condCnt=0;condCnt<poMiscCondArr.length;condCnt++)
	{
%>
					itemMiscValVar= document.myForm.miscCondPerQty_<%=poMiscCondArr[condCnt]%>.value;
					document.myForm.miscCondVal_<%=poMiscCondArr[condCnt]%>.value=parseFloat(itemMiscValVar*qtyEntered).toFixed(2);
<%
	}
%>
				}
				
			}
			if(qtyEntered.trim()=="")
			{
				document.myForm.EnterQty.value="";
				document.myForm.EnterQty.focus();
				document.myForm.netValue.value="";
				document.myForm.taxAndVal.value="";
<%
	for(int condCnt=0;condCnt<poMiscCondArr.length;condCnt++)
	{
%>
					document.myForm.miscCondVal_<%=poMiscCondArr[condCnt]%>.value="";
<%
	}
%>
			}
			if( qtyEntered.trim()!="" && (isNaN(qtyEntered) || (qtyEntered)<=0))
			{
				alert("Please enter Quantity greater than zero");
				document.myForm.EnterQty.value="";
				document.myForm.EnterQty.focus();
				document.myForm.netValue.value="";
				document.myForm.taxAndVal.value="";
			}
			
		}
		else
		{ 
			for(var i=0;i<checkLen;i++)
			{
				qtyEntered=document.myForm.EnterQty[i].value;
				/*
				if(qtyEntered>toBeDeliveredQty)
				{
					alert("Entered Quantity is greater than actual PO quantity/(PO quantity+Tolerance Limit)");
					document.myForm.EnterQty[index].value="";
					document.myForm.EnterQty[index].focus();
					return;
				}
				else
				*/
				{
					if(qtyEntered!=0 || qtyEntered!='')
					{
						try{
						totValue = parseFloat(document.myForm.EnterQty[i].value)*parseFloat(document.myForm.netAmountOne[i].value);
						if(isNaN(totValue))totValue="0";
						totValue=totValue.toFixed(2);
						}catch(error){totValue="0";}
						document.myForm.netValue[i].value=totValue;
						itemTaxValVar= document.myForm.itemTaxVal[i].value;
						document.myForm.taxAndVal[i].value = parseFloat(itemTaxValVar*qtyEntered).toFixed(2);
						document.myForm.taxAndVal12[i].value=parseFloat(itemTaxValVar*qtyEntered).toFixed(2);
						if(frtCond != "" && frtCond != null)
						{
							itemFrtValVar= document.myForm.frtCondPerQty[i].value;
							document.myForm.frtCondVal[i].value=parseFloat(itemFrtValVar*qtyEntered).toFixed(2);
						}
<%
	
	for(int condCnt=0;condCnt<poMiscCondArr.length;condCnt++)
	{
%>
					itemMiscValVar= document.myForm.miscCondPerQty_<%=poMiscCondArr[condCnt]%>[i].value;
					document.myForm.miscCondVal_<%=poMiscCondArr[condCnt]%>[i].value=parseFloat(itemMiscValVar*qtyEntered).toFixed(2);
<%
	}
%>
					}
				}
				if(qtyEntered.trim()=="")
				{
					document.myForm.EnterQty[i].value="";
					document.myForm.EnterQty[i].focus();
					document.myForm.netValue[i].value="";
					document.myForm.taxAndVal[i].value="";
<%
	for(int condCnt=0;condCnt<poMiscCondArr.length;condCnt++)
	{
%>
					document.myForm.miscCondVal_<%=poMiscCondArr[condCnt]%>[i].value="";
<%
	}
%>
				}
				if( qtyEntered.trim()!="" && (isNaN(qtyEntered) || (qtyEntered)<=0))
				{
					alert("Please enter Quantity greater than zero"); 
					document.myForm.EnterQty[i].value="";
					document.myForm.EnterQty[i].focus();
					document.myForm.netValue[i].value="";
					document.myForm.taxAndVal[i].value="";
				}
			}
		}
		var totNetValSum=0;
		var toTaxValSum=0; 
		var totTaxAndValSum=0;
		var toOthValSum=0;
		var tcsVal = 0;
		
		if(isNaN(checkLen))
		{
			try{
			totValue=parseFloat(document.myForm.netValue.value);
			//alert("::::totValue:::"+document.myForm.netValue.value);
			if(isNaN(totValue))totValue="0";
			totValue=totValue.toFixed(2);
			}catch(error){totValue="0";}
			try{
			taxValVar=parseFloat(document.myForm.taxAndVal.value);
			if(isNaN(taxValVar))taxValVar="0";
			taxValVar=taxValVar.toFixed(2);
			}catch(error){taxValVar="0";}

<%
	for(int condCnt=0;condCnt<poMiscCondArr.length;condCnt++)
	{
%>
					try{
						itemMiscValVar=parseFloat(document.myForm.miscCondVal_<%=poMiscCondArr[condCnt]%>.value);
						if(isNaN(itemMiscValVar))itemMiscValVar="0";
						itemMiscValVar=itemMiscValVar.toFixed(2);
					}catch(error){itemMiscValVar="0";}
					toOthValSum=parseFloat(toOthValSum)+parseFloat(itemMiscValVar);
<%
	}
%>

			totNetValSum=parseFloat(totNetValSum)+parseFloat(totValue);
			toTaxValSum=parseFloat(toTaxValSum)+parseFloat(taxValVar);
			totTaxAndValSum=parseFloat(totNetValSum)+parseFloat(toTaxValSum)+parseFloat(toOthValSum);
			
		}
		else
		{
			for(var i=0;i<checkLen;i++)
			{
				try{
				totValue=parseFloat(document.myForm.netValue[i].value);
				if(isNaN(totValue))totValue="0";
				totValue=totValue.toFixed(2);
				}catch(error){totValue="0";}
				try{
				taxValVar=parseFloat(document.myForm.taxAndVal[i].value);
				if(isNaN(taxValVar))taxValVar="0";
				taxValVar=taxValVar.toFixed(2);
				}catch(error){taxValVar="0";}
<%
	for(int condCnt=0;condCnt<poMiscCondArr.length;condCnt++)
	{
%>
				try{
					itemMiscValVar=parseFloat(document.myForm.miscCondVal_<%=poMiscCondArr[condCnt]%>[i].value);
					if(isNaN(itemMiscValVar))itemMiscValVar="0";
					itemMiscValVar=itemMiscValVar.toFixed(2);
				}catch(error){itemMiscValVar="0";}
				toOthValSum=parseFloat(toOthValSum)+parseFloat(itemMiscValVar);
<%
	}
	
%>
			
				
				totNetValSum=parseFloat(totNetValSum)+parseFloat(totValue);
				toTaxValSum=parseFloat(toTaxValSum)+parseFloat(taxValVar);
				totTaxAndValSum=parseFloat(totNetValSum)+parseFloat(toTaxValSum)+parseFloat(toOthValSum);
			}
		}
		//alert(":::netValue:::"+document.myForm.netValue.value);
		
		if(typeof document.myForm.taxFeight !== "undefined")
		{
			var taxFeight = document.myForm.taxFeight.value;
			var nonTaxFeight = document.myForm.nonTaxFeight.value;
			try{
				if(taxFeight != "")
				{
					totNetValSum = totNetValSum+parseFloat(taxFeight);
					toTaxValSum  = toTaxValSum+(parseFloat(taxFeight)*0.18);
					totTaxAndValSum = totTaxAndValSum+parseFloat(taxFeight)+(parseFloat(taxFeight)*0.18);
				}
			}catch(error){}
			try{
				if(nonTaxFeight != "")
				{
					totNetValSum = totNetValSum+parseFloat(nonTaxFeight);
					totTaxAndValSum = totTaxAndValSum+parseFloat(nonTaxFeight);
				}
			}catch(error){}
 

		} 
		if (document.getElementById('tcsFlg').checked) 
		{
			if(totTaxAndValSum > 0)
			{
				tcsVal = parseFloat(totTaxAndValSum)*0.001;
				totTaxAndValSum = totTaxAndValSum+tcsVal;
			}
			else
			{
				tcsVal	= 0;
			}
			
  		}
  		else
  		{
  			tcsVal	= 0;
  		}
		document.myForm.toaOthValue.value=toOthValSum.toFixed(2);
		document.myForm.toaNetValue.value=totNetValSum.toFixed(2);
		document.myForm.toaTaxValue.value=toTaxValSum.toFixed(2);
		document.myForm.totTaxAndValue.value=totTaxAndValSum.toFixed(2);
		document.myForm.totalTaxANDVal.value=totTaxAndValSum.toFixed(2);
		document.myForm.tcsValue.value=tcsVal.toFixed(2);
	}
	function funUpload()
		{
			
			var Url="../Shipment/ezAttachFileNew.jsp";
				$.fancybox.open({
				href : Url,
				type : 'iframe',
				padding : 5,
				width:'50%',
				height:'470px',
				autoSize : false,
				closeBtn : true,
				helpers     : {  
						overlay : {closeClick: false}
				 }
			});
	}
  
	</script> 
	<style>
	.box-primary
	{
		padding-bottom: 45px !important; 
	}
	</style>
 </head>   
 
 <body onLoad="scrollInit()" onResize="scrollInit()"  scroll=no> 
 <form name="myForm" id="myForm" method="post"> 

 <input type='hidden' name='orderBase' value='<%=orderBase%>'>
 <input type='hidden' name='vendor' value='<%=soldTo%>'>
 <input type='hidden' name='poPurGrp' value='<%=dtlHeader.getFieldValueString(0,"PUR_GRP")%>'>
 <input type='hidden' name='poPlant' value='<%=dtlXML.getFieldValueString(0,"PLANT")%>'>
 <input type='hidden' name='purOrdDocType' value='<%=dtlHeader.getFieldValueString(0,"DOC_TYPE")%>'>
 <input type='hidden' name='itemDetails' value=''>
 <input type='hidden' name='poSysKey' value='<%=poSysKey%>'>
 <input type='hidden' name='poVendor' value='<%=soldTo%>'>
 
 <input type="hidden" name="attachFlag" value ="N" >
 <input type="hidden" name="attachDocDesc" value ="" >	 
 <input type="hidden" name="attachFileTime" value ="" >	  
 <input type="hidden" name="attachDocFiles" value ="" >
 <input type="hidden" name="selPlant" value="">
 <input type="hidden" name="invoiceValue" value="">
 <input type="hidden" name="status" value="">
 <input type="hidden" name="alreadySaved" value="N">
<input type="hidden" name="downloadFalg" value="PDF">    
    

 <%//@ include file="ezGetTaxCondValue.jsp" %>
   
 <%	
 	
 	String plant1	= "";  
 	session.removeValue("ASN_MESSAGE");
	String fromPage = request.getParameter("FROM");
	String PlantCodes="";
	Hashtable vectMat = new Hashtable();  
	Vector plantVect  = new Vector();
	int SALineCount = 0;
	int poLineCount = 0;
	ezc.ezcommon.EzLog4j.log(":::::::::::check22222:::"+ponum,"I");
	
	if(rowCount >= 0)
	{
		String display_header = "";
		
		if("po".equals(orderBase))
			display_header = "Add Shipment Details for PO : "+ponum;
		else	
			display_header = "Add Shipment Details for SA : "+ponum;


		String selected = ""; 
		
		ezc.ezcommon.EzLog4j.log(":::::::::::check33333:::"+rowCount,"I");
%>
		<%@ include file="../Misc/ezSubHeader.jsp"%> 
		<link rel="stylesheet" type="text/css" href="../../Library/jquery/jquery-ui-1.12.1.custom/jquery-ui.css">
		<input type=hidden name="showData" value='<%=showData%>'>
		<input type="hidden" name="ponum" value='<%=ponum%>'>
 <%	
 		
		
		/*
			Hashtable<String,String> htHsnDet = new Hashtable<String,String>();
			try
			{
				String [] outputFeilds =new String[]{"EBELP","J_1BNBM"};
				String [] queryValues =new String[]{"EBELN EQ '"+ponum+"'"};
				ReturnObjFromRetrieve retHSNDet = readRFCTable((String)session.getValue("SITE"),"EKPO",outputFeilds,queryValues);
				int retHSNDetCnt = retHSNDet.getRowCount();
				for(int i=0;i<retHSNDetCnt;i++)
				{
					htHsnDet.put(retHSNDet.getFieldValueString(i,"EBELP"),retHSNDet.getFieldValueString(i,"J_1BNBM"));
				}
		}catch(Exception e){}
		*/
 
		String modeCode = ""; 
		String modeDesc = "";
			modeCode = "";
		modeDesc = "";
		java.util.Enumeration modeEnum = modeHash.keys();
		int modeCount = modeHash.size();
		
		
		java.util.Enumeration weightUnitEnum = weightUnitHT.keys();
		int weightUnitCount = weightUnitHT.size();
		
 %>		
		<input type="hidden" name="base" value="<%=base%>">
		<input type="hidden" value="<%=poNum%>" name="baseValue">
		<input type="hidden" value="<%= OrderValue %>" name="OrderValue">
		<input type="hidden" value="<%= orderCurrency%>" name="orderCurrency">
		<input type="hidden" value="<%=getDateForDateObj(ordDate)%>" name="OrderDate">  
		<input type="hidden"  name="status">
		<input type="hidden" name="Type" value="<%=Type%>" >
		<input type="hidden" name="PONumber" value="<%=order%>">
		<input type="hidden" name="PODate" value="<%=getDateForDateObj(ordDate)%>">
		<input type="hidden" name="shipupload" value="">
		<input type="hidden" name="schdflag" value="" >
		<input type="hidden" name="shipflag" value=""> 
		 

<%
		
		for(int condCnt=0;condCnt<poMiscCondArr.length;condCnt++)
		{
%>
		<input type="hidden" name="condTypes" value="<%=poMiscCondArr[condCnt]%>">
<%
		}
		
	String v_thColor = trBGColor;
%>
<section class="content"> 

	<div class="row">
	<!-- left column -->
	<div class="col-md-12 col-xs-12">
<!-- general form elements -->
	<div class="box box-primary">
	<div class="box-body table-responsive no-padding">
	<div class="box-body">
	
		<div id="tabs">
		<div class="Footer">
		    <div class="divleft">
			
			<button id="btnMoveLeftTab" type="button" class="btn btn-primary btn-sm" value="Previous Tab" >	 Previous
			</button>
		    </div>
		    <div class="divright">
			
			<button id="btnMoveRightTab" type="button" value="Next"  class="btn btn-primary btn-sm">  Next
			</button>
		    </div>
		</div>
		  <ul>
			    <li><a href="#tabs-1">ITEMS</a></li>
			    <li><a href="#tabs-2">HEADER</a></li>
			    <li><a href="#tabs-3">DOCUMENTS</a></li> 
		  </ul>

	
		
		<div id="tabs-1" >
		  <input type="hidden" name="tabVal2" id="tabVal2" value="" >
<%
		//out.println(":::dtlXML:::::"+dtlXML.getRowCount());
		//out.println(":::openIBDItemsHT::::"+openIBDItemsHT);
		if(dtlXML.getRowCount() != 0) 
		{
			String overDelvTol=""; 
			String unLimited  ="";
			String cumGrQty = "";
			String delCompleted = "",deleteInd=""; 

			String material	= request.getParameter("material");
			String selPlant	= request.getParameter("plant");
	
			if("po".equals(orderBase))    
			{ 
				
%>
				<%//@ include file="../../../Includes/JSPs/Shipment/iGetPODelSched.jsp" %>
<%	
				//out.println(":::::::::"+dtlXML.toEzcString());
				
				//out.println(":::::::::"+historyTable);

				int cnt=0;
				BigDecimal itemPrice_bd;
				for(int i=0;i<dtlXML.getRowCount();i++)
				{     
					ezc.ezcommon.EzLog4j.log("lineNumNew::"+lineNum,"I");
					String tempPONo = dtlXML.getFieldValueString(i, "ORDER");
					lineNum 	= dtlXML.getFieldValueString(i, "POSITION");
					matNum 		= dtlXML.getFieldValueString(i, "ITEM");
					matDesc 	= dtlXML.getFieldValueString(i, "ITEMDESCRIPTION");
					qty 		= dtlXML.getFieldValueString(i, "ORDEREDQUANTITY");
					uom		= dtlXML.getFieldValueString(i, "UOMPURCHASE");
					price		= dtlXML.getFieldValueString(i, "PRICE");
					netAmount 	= dtlXML.getFieldValueString(i, "AMOUNT");
					eDDate 		= (Date)dtlXML.getFieldValue(i, "PLANNEDDELIVERYDATE");
					plant		= dtlXML.getFieldValueString(i, "PLANT");
					confKey 	= dtlXML.getFieldValueString(i, "CONFIRMATION_KEY");
					overDelvTol 	= "0";//dtlXML.getFieldValueString(i, "OVERDELTOL");
					unLimited 	= dtlXML.getFieldValueString(i, "UNLIMITED");
					delCompleted	= dtlXML.getFieldValueString(i, "DLV_COMPLTED");
					deleteInd	= dtlXML.getFieldValueString(i, "DELETE_IND");
					String netPOPrice = dtlXML.getFieldValueString(i, "NET_PRICE");
					
					String overdelTol	= dtlXML.getFieldValueString(i, "OVERDELTOL");
					//out.println("::::overdelTol:::"+overdelTol);
					
					
					if("X".equals(delCompleted)) //|| !openIBDItemsHT.containsKey(lineNum))  -- Need to Check this
						continue;
					if("L".equals(deleteInd)) //|| !openIBDItemsHT.containsKey(lineNum))  -- Need to Check this
						continue;
					//if("".equals(confKey) || "null".equals(confKey) || confKey==null)
						//continue;	
					matNum 	= matNum.trim();
					matDesc = matDesc.trim();
					try{
						matNum = Long.parseLong(matNum)+"";
					}catch(Exception numFmtEx){
						matNum = matNum;
					}
					
					if(qtyRetObjCnt>0)
					{ 
						try{
							int index = qtyRetObj.getRowId("EZSL_MAT_DESC",matDesc.trim());

							if(index>=0)
							{
								portalIvQty=qtyRetObj.getFieldValueString(index,"QTY");
								portalIvValue=qtyRetObj.getFieldValueString(index,"PRICE");
							}
							//out.println(index+":::::::index:::"+portalIvQty);
							//out.println(index+":::::::index:::"+portalIvValue);
						}catch(Exception e){}
					}
					
					
					
					
					if(!("".equals(qty) || qty == null || qty=="")) 
						qty = qty.trim();
					else 
						qty = "0";
						
					double netAmtD = 0;
					if(netAmount!=null || !"".equals(netAmount)) 
						netAmtD = Double.parseDouble(netAmount)/1000;
					netAmount = netAmtD+"";	
					
					String taxValStr = "";
					try{
						taxValStr = (Float)itemTaxHash.get(tempPONo+"#"+lineNum)+"";
					}catch(Exception e){
						ezc.ezcommon.EzLog4j.log("Exception with taxValStr::"+e,"I");
					}
					String lineNoHash = "";
					String netPriceFromHash="";
					
					try 
					{
						lineNoHash = "0"+lineNum; 
						netPriceFromHash = (String)perQtyPriceHash.get(tempPONo+"#"+lineNoHash);
						try{
							itemPrice_bd = new BigDecimal(netPriceFromHash);
							netPriceFromHash = itemPrice_bd.setScale(2, RoundingMode.HALF_UP).toString();
						}catch(Exception e1){}	
					}
					catch(Exception e){
					ezc.ezcommon.EzLog4j.log("Exception in getting per qty price:"+e,"I");
					}
						
					String itemOpenIBDQtyStr = (String)openIBDItemsHT.get(tempPONo+"##"+lineNum);
					//itemOpenIBDQtyStr="10";
					double itemOpenIBDQtyNum = 0;
					
					ezc.ezcommon.EzLog4j.log("itemOpenIBDQtyStr>>"+itemOpenIBDQtyStr,"I");
					
					
					try{
						itemOpenIBDQtyNum = Double.parseDouble(itemOpenIBDQtyStr);
					}catch(Exception e){}	
 
					double TotQty = 0;		// Total PO Item Qty
					try{
						TotQty = Double.parseDouble(qty);
					}catch(Exception e){}
					
					ezc.ezcommon.EzLog4j.log(TotQty+"::::itemOpenIBDQtyNum>>"+itemOpenIBDQtyNum,"I");
					double tempTotQty = 0;
					/* 
					
					double tempToleranceValue = 0;

					if(unLimited!=null)
						unLimited = unLimited.trim();	
					if("".equals(unLimited))
					{				
						try{
							tempToleranceValue = TotQty*(Double.parseDouble(overDelvTol)/100);
							tempTotQty = TotQty;
						}catch(Exception e){}				
					}
					*/
					double sapGRQty = 0;		// Already Delivered Qty from PO History
					double dbIBDQty = 0;
					double IVQty = 0;

					//if(historyTable.containsKey(Integer.parseInt(lineNum)))
					/*
					if(historyTable.containsKey(lineNum))
					{
						String ibdQty = (String)historyTable.get(lineNum);
						String ivQty = (String)historyTable.get("#"+lineNum);
						try{
							dbIBDQty = Double.parseDouble(ibdQty);
						}catch(Exception e){}
						try{
							IVQty = Double.parseDouble(ivQty);
						}catch(Exception e){}
						//out.println("::::ivQty:::"+ivQty);
						//out.println("::::ibdQty:::"+ibdQty); 
						
					}
					try
					{
						IVQty = IVQty+Double.parseDouble(portalIvQty);
						//out.println(":::::IVQty:::::"+IVQty);
					}catch(Exception e){}
					*/
					/*
					if(itemDlvQtyHash.containsKey(lineNum))
					{
						String grQty = (String)itemDlvQtyHash.get(lineNum);
						try{
							sapGRQty = Double.parseDouble(grQty);
						}catch(Exception e){}
					}
					ezc.ezcommon.EzLog4j.log("BEFORE>>>>>>>>TotQty>>"+TotQty+">>sapGRQty>>"+sapGRQty+">>dbIBDQty>>"+dbIBDQty,"I");
					*/
					double BeDelQty = itemOpenIBDQtyNum;
					try{
						IVQty = TotQty - itemOpenIBDQtyNum;
						/************************************
						"ToBe Del Qty" equals to difference of "Total Item Qty" and sum of Item SAP GR Qty and Item total portal DB ASN's qty. 
						************************************/	
						//BeDelQty = TotQty - (sapGRQty+dbIBDQty) ;
						//BeDelQty = TotQty - (IVQty);
					}catch(Exception e){}
					
					ezc.ezcommon.EzLog4j.log("BEFORE>>>>>>>>BeDelQty>>"+BeDelQty,"I");

					try{
						/************************************
						If Portal calculated "ToBe Del Qty" is Greater than Difference of Total PO Item Qty and Item SAP GR Qty.
						************************************/
						//if(BeDelQty > (TotQty-sapGRQty))  
							//BeDelQty = TotQty-sapGRQty;
						/************************************
						If Portal calculated "ToBe Del Qty" is Greater than Item Open Qty in SAP.
						************************************/	
						//if(BeDelQty > itemOpenIBDQtyNum)	-- Need to Check this
						//	BeDelQty = itemOpenIBDQtyNum;	
					}catch(Exception e){}
					
					ezc.ezcommon.EzLog4j.log("BEFORE1111111111>>>>>>>>BeDelQty>>"+BeDelQty,"I");

					ezc.ezcommon.EzLog4j.log(lineNum+">>>>>>>>>BeDelQty>>>>>>>"+BeDelQty,"I"); 
					 
					if(BeDelQty<=0)
						continue;

					if(BeDelQty <= 0)
					{
						BeDelQty = 0;
						checkForButtons++;
					}

					String finalqty		= ""+BeDelQty;
					String ToBeDelQty 	= getNumberFormat(BeDelQty+"",2);
					String TotalQty 	= getNumberFormat(TotQty+"",2);
					String totalIVQty	= getNumberFormat(IVQty+"",2);
					String overTolerance 	= getNumberFormat(overdelTol+"",2);
					count			= count+1;	
					String modifiedDesc 	= matDesc; 
					modifiedDesc		= modifiedDesc.replaceAll("\'","`");
					modifiedDesc		= modifiedDesc.replaceAll("\"","``");
					poLineCount++;
					
					ezc.ezcommon.EzLog4j.log("AFTER>>>>>>>>TotQty>>"+TotQty+">>sapGRQty>>"+sapGRQty+">>dbIBDQty>>"+dbIBDQty,"I");
					ezc.ezcommon.EzLog4j.log(">>>>>>>>>poLineCount>>>>>>>"+poLineCount,"I");
			
					if(poLineCount==1)
					{
%>

						<Br>
<div class="row">
	<div class="col-xs-12">
		<div class="box">
			<div class="box-body table-responsive no-padding">
				<div class="box-tools pull-right">
					<label for="file-upload" id="uploadExcel"  class="btn btn-warning"><span class="fa fa-file-excel-o"></span> Upload Excel</label>
					<input id="file-upload" type="file"  name="file" style="display:none;" onchange="funShowFile()"/>
					
					
					<button type="button" id="uploadSelExcel" class="btn btn-warning" onclick="funUpload()" style="display:none;background-color:#E75400;border-color: #E75400;color:#fff;"><span class="glyphicon glyphicon-open-file"></span> Upload File </button>  &nbsp;
					<button type="button" class="btn btn-warning" onclick="funDownloadExcel()"><span class="fa fa-file-excel-o"></span> Download Excel</button>  &nbsp;
				</div>
						<table  class="table table-bordered " id="example1">
						<Tr>
							<th>PO_NO	</th>
							<th>LINE_NO	</th>
							<th>RMO NO	</th>
							<th>RANGE NAME	</th>
							<th>SAP MAT DESCRIPTION	</th>
							<th>MATERIAL GROUP	</th>
							<th>HS_CODE	</th>
							<th>MATERIAL	</th>
							<th>ENG DESCRIPTION	</th>
							<th>MAN DESCRIPTION	</th>
							<th>COLOR(ENG)	</th>
							<th>COLOR(MAN)	</th>
							<th>UOM	</th>
							<th>PO ORDER QTY	</th>
							<th>SUBMITTED_<br>QUANTITY	</th>
							<th>BD CONFIRMED_<br>QUANTITY	</th>
							<th>Balance Qty	</th>
							<th>SHIP_QTY(INVOICE QTY/CI Qty)</th>	
							<th>QTY_OF_PACKAGE	</th>
							<th>QTY_PER_PACKAGE_UNIT	</th>
							<th>Total QTY</th>
							<th>VOLUME_CBM	</th>
							<th>TOTAL_NET_WEIGHT_KGS</th>
							<th>TOTAL_GROSS_WEIGHT_KGS	</th>
							<Th style="display:none">PO Price</th>
							<Th style="display:none">Value</th>
							<Th style="display:none">Taxes</Th>
							<th>CONTAINER_NO</th>
							<th>SEAL_NO</th>

<%
		for(int condCnt=0;condCnt<poMiscCondArr.length;condCnt++) 
		{
%>
							<th><%=miscCondHT.get(poMiscCondArr[condCnt])%> </th>
<%
		}
%>							
							<!--<Th width="7%">Tot.(Tax+Val)</Th>-->
							<!--<Th width="7%">COA</th>-->
						</Tr>
<%
					}
%>
					<input type="hidden" name="itemPONo" value="<%=tempPONo%>">
					<input type="hidden" name="poGrp" value="<%=dtlXML.getFieldValueString(i, "PUR_GROUP")%>">
					<input type="hidden" name="MaterialNr" value="<%=matNum%>">
					<input type="hidden" name="UOM" value="<%=uom%>">
					<input type="hidden" name="QuanToBeShip" value="<%=finalqty%>">
					<input type="hidden" name="displayQty" value="<%=tempTotQty%>">
					<input type="hidden" name="Plant" value="<%=plant%>">
					<input type="hidden" name="confKey" value="<%=confKey%>">
					<input type="hidden" name="netAmount" value="<%=netPriceFromHash%>">
					<input type="hidden" name="Quantity" style="text-align:right">
					<input type="hidden" name="coaLong" >
					<input type="hidden" name="coaData" >
					<input type="hidden" name="matType" value="<%=dtlXML.getFieldValueString(i, "MAT_TYPE")%>">

					<input type="hidden" name="sapSchdQty" value="<%=TotQty%>">
					<input type="hidden" name="sapGRQty" value="<%=sapGRQty%>">
					<input type="hidden" name="dbIBDQty" value="<%=dbIBDQty%>">

					<input type="hidden" name="overDelvTolPerc" value="<%=overDelvTol%>"> 
					<input type="hidden" name="deliveredQty" value="<%=getNumberFormat(dbIBDQty+"",2)%>">
					<input type="hidden" name="tempToleranceValue" value="<%//=getNumberFormat(tempToleranceValue+"",2)%>">
					<input type="hidden" name="totPOItemQty" value="<%=getNumberFormat(tempTotQty+"",2)%>">

					<Tr>
					<%
						String s1 = confRMOGRP.get(tempPONo+"##"+matNum);
						String rmoNo = "",matGrp="",rangeName="";
						if(s1==null) 
						{
							rmoNo = "NA";
							matGrp = "NA";
							rangeName = "NA";
						}
						else
						{
							rmoNo = s1.split("##")[0];
							matGrp = s1.split("##")[1];
							rangeName = s1.split("##")[2];
						}
						
						String tempdesc=poItemMatDesc.get(tempPONo+"#"+lineNum);
						if(tempdesc==null) tempdesc = "NA$$NA$$NA";
						//out.println("tempdesc>>>"+tempdesc);     
						String[] parts = tempdesc.split("\\$\\$");						

						String tempEngDesc = parts.length > 0 ? parts[0] : "";
						String tempmatDesc = parts.length > 1 ? parts[1] : "";
						String tempManDesc = parts.length > 2 ? parts[2] : "";
						//out.println("tempEngDesc>>>"+tempEngDesc+"<<tempmatDesc>>>"+tempmatDesc+"<<tempManDesc>>>"+tempManDesc);
						ezc.ezcommon.EzLog4j.log("tempEngDesc>>>"+tempEngDesc+"<<tempmatDesc>>>"+tempmatDesc+"<<tempManDesc>>>"+tempManDesc,"I");
						String tempColor=poItemColorDesc.get(tempPONo+"#"+lineNum);
						if(tempColor==null) tempColor = "NA$$NA";

						String[] partsCol = tempColor.split("\\$\\$");
						String engCol = partsCol.length > 0 ? partsCol[0] : "";
						String manCol = partsCol.length > 1 ? partsCol[1] : "";
						String hsn_Code=checkNull(htHsnDet.get(matNum));
							
					%>
						<Td align="center"><%=tempPONo%>
						<Td align="center"><%=lineNum%><input type="hidden" name="Line" value="<%=lineNum%>"></Td>
						<td><%=rmoNo%></td>
						<td><%=rangeName%></td>
						<Td  align="center"><%=tempmatDesc%></Td>
						<td><%=matGrp%></td>
						<Td align="center" > 
							<input type="text" class="quantity-input" size="8" maxlength="8" name="hsnCode" value="<%=checkNull(htHsnDet.get(matNum))%>" onkeypress="return allowOnlyNumeric(this,event)">
							<input type="hidden" name="taxCode" value="<%=checkNull(htTaxCode.get(lineNum))%>">
						</td> 
						<Td align="center"><%=matNum%>
						<input type="hidden" name="matNum" value="<%=matNum%>">
						</Td>

						<Td  align="center"><%=tempEngDesc%><input type="hidden" name="Description" value="<%=matDesc%>"></Td>
						<Td  align="center"><%=tempManDesc%></Td>
						<Td  align="center"><%=engCol%></Td>
						<Td  align="center"><%=manCol%></Td>
						<input type="hidden" name="modifiedDesc" value="<%=modifiedDesc%>">
						<Td align="center"><%= uom %></Td>
						<Td  align="center"><%=TotalQty%><input type="hidden" name="totPOQty" value="<%=TotalQty%>"></Td> 
						<!--<Td width="10%" align="center"><%=getNumberFormat(dbIBDQty+"",2)%></Td> -->
						<!--<Td width="10%" align="center" id="ToBeDelQtyId_<%=i%>"><%=ToBeDelQty%></Td>-->
						<Td  align="center" id="submittedQtyId_<%=i%>"><%=totalIVQty%><input type="hidden" name="IVQty" value="<%=totalIVQty%>"></Td></Td>
						<Td  align="center"><%=htConfQty.containsKey(tempPONo+"#"+lineNum)?htConfQty.get(tempPONo+"#"+lineNum):"0"%></td>
						<Td width="10%" align="center" id="ToBeDelQtyId_<%=i%>"><%=ToBeDelQty%></Td>

<%
						//if(BeDelQty!=0)	 	      
						//{			      
%> 
							<Td><input type="text" size="5" class="quantity-input" id="EnterQty<%=tempPONo+"_"+lineNum%>" name="EnterQty" value="" onChange = "funCalValues('<%=cnt%>','<%=TotalQty%>','<%=totalIVQty%>','<%=overTolerance%>')"><input type="hidden" name="delivQty" value=""></Td>
<%
						//} 
						//else
						//{     
%>	  
							<!--<Td width="7%" align="center"><input type="hidden" name="EnterQty" value="0"></Td>-->
<%
						//}
%>  	
						<Td><input type="text"  class="commonTextField" id="packageQty<%=tempPONo+"_"+lineNum%>" name="packageQty" value="" size="5"><input type="hidden" name="delivQty" value=""></Td>
						<Td><input type="text"  class="commonTextField" id="qtyPackUnit<%=tempPONo+"_"+lineNum%>" name="qtyPackUnit" value="" size="5"><input type="hidden" name="delivQty" value=""></Td>
						<Td><input type="text"  class="commonTextField" id="total_Qty<%=tempPONo+"_"+lineNum%>" name="total_Qty<%=tempPONo+"_"+lineNum%>" value="" size="5" ><input type="hidden" id="calculated_total_Qty<%=tempPONo+"_"+lineNum%>" name="calculated_total_Qty<%=tempPONo+"_"+lineNum%>" value=""></Td>
						<Td><input type="text"  class="commonTextField" id="volCBM<%=tempPONo+"_"+lineNum%>" name="volCBM" value="" size="5" ><input type="hidden" name="delivQty" value=""></Td>
						<Td><input type="text"  class="commonTextField" id="netWght<%=tempPONo+"_"+lineNum%>" name="netWght" value="" size="5" ><input type="hidden" name="delivQty" value=""></Td>
						<Td><input type="text"  class="commonTextField" id="grossWght<%=tempPONo+"_"+lineNum%>" name="grossWght" value="" size="5" ><input type="hidden" name="delivQty" value=""></Td>
						
						<Td style="display:none" align="center"><input type="hidden"  name="netAmountOne" value="<%=netPriceFromHash%>"><%=netPriceFromHash%></td>
						<Td style="display:none" align="center"><input type="text" class="tx"  name="netValue" value=""></td>

						<td  align="center" style="display:none"><input type="hidden" name="batches" >
						<input type="hidden" class="tx"  name="itemTaxVal" value="<%=taxValStr%>"  readonly>
						<td style="display:none"><input type="text" class="tx"  name="taxAndVal" value=""> 
						<input type="hidden" name="taxAndVal12" value=""></td>  
						<Td><input type="text"  class="commonTextField" id="container<%=tempPONo+"_"+lineNum%>" name="container" value="" size="5" ><input type="hidden" name="delivQty" value=""></Td>
						<Td><input type="text"  class="commonTextField" id="sealNo<%=tempPONo+"_"+lineNum%>" name="sealNo" value="" size="5" ><input type="hidden" name="delivQty" value=""></Td>
						
<%
	if(frtCond != null && !"null".equals(frtCond) && !"".equals(frtCond)) 
	{
			BigDecimal frtConVal = new BigDecimal("0.00");
			BigDecimal frtCondPerQty = new BigDecimal("0.00");
			
			try
			{
				//out.print("::::GGGGGG::::::"+tempPONo+"#"+lineNum+"#"+frtCond);
				frtConVal = (BigDecimal)poFreightCond.get(tempPONo+"#0"+lineNum+"#"+frtCond);
				frtCondPerQty = frtConVal.divide(new BigDecimal(TotalQty), 2, RoundingMode.HALF_UP);
			}
			catch(Exception e){}

%>
			<input type="hidden" name="frtCondPerQty" value="<%=frtCondPerQty%>"> 
			<input type="hidden" size="3" name="frtCondVal" value="0"> 
		
<%
	}

%>						
						
						</Td>
<% 
		//out.print("frtCond:::"+frtCond);
		for(int condCnt=0;condCnt<poMiscCondArr.length;condCnt++)
		{
			String tempConType = poMiscCondArr[condCnt];
			BigDecimal miscConVal = (BigDecimal)poMiscCond.get(tempPONo+"#"+"0"+lineNum+"#"+tempConType);
			BigDecimal miscCondPerQty = miscConVal.divide(new BigDecimal(TotalQty), 2, RoundingMode.HALF_UP);

%>
						<td align="center">
							<input type="hidden" name="miscCondPerQty_<%=tempConType%>" value="<%=miscCondPerQty%>">
							<input type="text" readonly size="5" name="miscCondVal_<%=tempConType%>" value="0"> 
						</td>
<% 
		}
%>
						

<%
						cnt=cnt+1;
%>

					</Tr>
<%
				try
				{
					//objList.add(new Object[]{tempPONo,lineNum,matNum,poItemMatDesc.get(tempPONo+"#"+lineNum).replaceAll("<hr>","/"),poItemColorDesc.get(tempPONo+"#"+lineNum).replaceAll("<hr>","/"),uom,TotalQty,totalIVQty,htConfQty.containsKey(tempPONo+"#"+lineNum)?htConfQty.get(tempPONo+"#"+lineNum):"0",""});	
					//objList.add(new Object[]{matGrp,rmoNo,tempPONo,lineNum,matNum,tempEngDesc,tempmatDesc,tempManDesc,engCol,manCol,uom,TotalQty,totalIVQty,ToBeDelQty,htConfQty.containsKey(tempPONo+"#"+lineNum)?htConfQty.get(tempPONo+"#"+lineNum):"0","","","","","",""});	
					objList.add(new Object[]{tempPONo,lineNum,rmoNo,rangeName,tempmatDesc,matGrp,checkNull(htHsnDet.get(matNum)),matNum,tempEngDesc,tempManDesc,engCol,manCol,uom,TotalQty,totalIVQty,htConfQty.containsKey(tempPONo+"#"+lineNum)?htConfQty.get(tempPONo+"#"+lineNum):"0",ToBeDelQty,"","","","","","","","",""});
					//objListCI.add(new Object[]{tempPONo,matNum,tempmatDesc,engCol,uom,hsn_Code,temppriceCIHT.get(matNum),"",""});   						 
					
				}catch(Exception e){}
				
				}
				
%>
				</Table>
				
</div>

</div>

</div>
</div>
<%@ include file="../Shipment/ezAddImpShipDetailsHidTable.jsp" %>
<%
				if(poLineCount>0)
				{
%>
					<Br>
					<table  class="table table-bordered nowrap" style="display:none">
					<tr>
						<th >Total Net Value</th>
						<td ><input type=text class=tx name=toaNetValue value="" style="width: 164px;margin-right: 10px;" disabled></td>
					</tr>
					<tr>	
						<th >Total Taxes</th>
						<td><input type=text class=tx name=toaTaxValue value="" style="width: 164px;margin-right: 10px;" disabled></td>
					</tr>
					<tr>	
						<th >Total Other Charges</th>
						<td><input type=text class=tx name=toaOthValue value="" style="width: 164px;margin-right: 10px;" disabled></td>
					</tr>
					<tr style="<%=tcsPOFlg?"display:none":""%>">	
						<th >TCS</th>
						<td><input type="text" class="tx" name="tcsValue"  value="" style="width: 164px;margin-right: 10px;" readonly></td>
					</tr>
					<tr>	
						<th >Total </th>
						<td ><input type=text class=tx name=totTaxAndValue value="" style="width: 164px;margin-right: 10px;" disabled><input type="hidden" name="totalTaxANDVal" value=""</td>
					</tr>
					</table>				
<%
				}
				if(poLineCount==0)
				{
%>
					<Br><Br><Br><Center>
					<table  class="table table-bordered nowrap">
					<Tr><Td align = center>No Open Line(s) Items Present</Td></Tr>
					</Table></Center>
<%				
				}
			}
		}
		else
		{
			String noDataStatement = nopurorder_L; 
 %>
			<%@ include file="../Misc/ezDisplayNoData.jsp" %>
			<Br>	<Br>
			<Center>
				<button type="button" class="btn btn-primary" onclick="navigateBack('../Misc/ezSBUWelcome.jsp')">Back</button>  	
			</Center>
<%
		}
%>		
		<input type="hidden" name="count" value="<%=count%>">
		<input type=hidden name=sendMail value="No">
</div>


<div id="tabs-2">
	<input type="hidden" name="tabVal1" id="tabVal1" value="" >
	<button type="button" class="btn btn-warning" onclick="funFilledDownloadExcel()"><span class="fa fa-file-excel-o"></span> Download Packing List</button>  &nbsp;
	<button type="button" class="btn btn-warning" onclick="funCIDownload()"><span class="fa fa-file-excel-o"></span> Download Commercial Invoice</button>  &nbsp;
	<button type="button" class="btn btn-warning" onclick="funMasterDownloadExcel()"><span class="fa fa-file-excel-o"></span> Download Master List</button>  &nbsp;
		<table  class="table table-bordered nowrap" id="example2">
		<Tr align="center" >
		<Th  ><%=modOfTrans_L%> * </th>
		<Td >
			<Select class="form-control validate[required]"  name="modeOfTransport" id="ListBoxDiv1">
				<option value=''><%=select_L%></option>
<%					
				for(int i=0;i<modeCount;i++)
				{
					modeCode = (String)modeEnum.nextElement();
					modeDesc = (String)modeHash.get(modeCode);

					if((dcno.trim()).equals((modeCode.trim())))
						selected = "selected";
					else
						selected = "";
%>
						<option value='<%=modeCode%>' <%=selected%> ><%=modeCode%><%=modeDesc%></option>
<%
				}
				if("".equals(dcdate) || "null".equals(dcdate) || dcdate==null )
					dcdate = getDateForDateObj(new Date());

				if("".equals(shipdate) || "null".equals(shipdate) || shipdate==null )
				{
					try{
					if(shipDates.get(ponum)!=null) 
						shipdate = formatDate.getStringFromDate((Date)shipDates.get(ponum),(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT"))) ;
					else
						shipdate = "";
					}catch(Exception e){shipdate = "";}	
				}	
%>					
			</Select>
			</Td>
			<Th  >ASN Creation Date</th>
			
			<Td  align=left>   <%=dcdate%>
			<!--<div class="input-group date">
			<div class="input-group-addon">
			<i class="fa fa-calendar"></i>
			</div>
				<input type="text" class="form-control validate[required]"  data-errormessage-value-missing="Please Enter Delivery Note Date" id="DCDate" name="DCDate"  value="<%//=dcdate%>" size=12 readonly onfocus=this.blur()>
			 </div>	 -->
			 </Td>
			
			</Tr>
			<Tr>
				<Th  >Invoice Number *</th>
				<Td ><input type="text" class="form-control validate[required]"  data-errormessage-value-missing="Please Enter InvoiceNo" name="InvoiceNo" id="InvoiceNo"  onchange="javascript:checkInvoice()" value="<%=invno%>" size="31" tabindex="2" maxlength="20"></Td>
				<Th  ><%=invdate_L%> *</th>
				<Td  valign=center>
				<div class="input-group date">
				<div class="input-group-addon">
				<i class="fa fa-calendar"></i>
				</div>
				<input type="text" class="form-control validate[required]"  data-errormessage-value-missing="Please Enter Invoice Date" id="InvoiceDate"  name="InvoiceDate"  value="<%=shipdate%>" size=12 readonly onfocus=this.blur()>
				</div>
				</Td>
			</Tr>
			<Tr>
				<Th  >B/L or LR Number</th>
				<Td ><input type="text" class="form-control validate[required]"   name="LR" id="LR" value="" size="31"tabindex="3" maxlength="30"></Td>
				<Th  ><%=shipdate_L%> *</th>
				<Td  valign=center>
				<div class="input-group date">
				<div class="input-group-addon">
				<i class="fa fa-calendar"></i>
				</div>
				<input type="text" class="form-control validate[required]" id="ShipDate"  name="ShipDate"  value="<%=shipdate%>" size=12 readonly onfocus=this.blur() >
			 	</div>
				</Td>
			</Tr>
			<Tr>
				<th  >Shipping Line</th>				
				<td id="carrierNm">
				<Select class="form-control validate[required]"  data-errormessage-value-missing="Please Enter Shipping Line" name="CarrierName" id="CarrierName" value="<%=checkNull(cname)%>" tabindex="3" maxlength="20"   >
					<option value="">--Select Shipping lines--</option>
<option value="APL">APL</option>

							<option value="BLPL SINGAPORE">BLPL SINGAPORE</option>

							<option value="COSCO INDIA PVT LTD.">COSCO INDIA PVT LTD.</option>

							<option value="ECONSHIP">ECONSHIP</option>

							<option value="ELAN">ELAN</option>

							<option value="EM KAY LINE">EM KAY LINE</option>

							<option value="EMIRATES SHIPPING PVT LTD.">EMIRATES SHIPPING PVT LTD.</option>

							<option value="EVERGREEN LINES">EVERGREEN LINES</option>

							<option value="GIA NGUYEN LOGISTIC">GIA NGUYEN LOGISTIC</option>

							<option value="GOLD STAR LINE">GOLD STAR LINE</option>

							<option value="HYUNDAI MERCHANT">HYUNDAI MERCHANT</option>

							<option value="INTERASIA">INTERASIA</option>

							<option value="KCA LINES">KCA LINES</option>

							<option value="KMTC INDIA PVT LTD.">KMTC INDIA PVT LTD.</option>

							<option value="LITCO CONTAINER">LITCO CONTAINER</option>

							<option value="MAERSK INDIA PVT LTD">MAERSK INDIA PVT LTD</option>

							<option value="MSC INDIA PVT LTD.">MSC INDIA PVT LTD.</option>

							<option value="NEW GOLDEN">NEW GOLDEN</option>

							<option value="ONE">ONE</option>

							<option value="ORIENT OVERSEAS">ORIENT OVERSEAS</option>

							<option value="PIL">PIL</option>

							<option value="RCL AGENCIES PVT LTD">RCL AGENCIES PVT LTD</option>

							<option value="SAMUDERA SHIPPING">SAMUDERA SHIPPING</option>

							<option value="SEAPOL">SEAPOL</option>

							<option value="SKY SHIPPING">SKY SHIPPING</option>

							<option value="STAR SHIPPING">STAR SHIPPING</option>

							<option value="TI2 SHIPPING">TI2 SHIPPING</option>

							<option value="TLPL SHIPPING INDIA PVT LTD.">TLPL SHIPPING INDIA PVT LTD.</option>

							<option value="VASI SHIPPING">VASI SHIPPING</option>

							<option value="WAN HAI LINES">WAN HAI LINES</option>

							<option value="YANG MING LINES">YANG MING LINES</option>

							<option value="ZIM INTEGRATED">ZIM INTEGRATED</option>

							<option value="HAPAG LLOYD">HAPAG LLOYD</option>

							<option value="OTHERS">OTHERS</option>

							<option value="Nhavasheva Sea Port">Nhavasheva Sea Port</option>

							<option value="Mumbai Air Cargo">Mumbai Air Cargo</option>

							<option value="Chennai Sea port">Chennai Sea port</option>

							<option value="Chennai Air Cargo">Chennai Air Cargo</option>

							<option value="Mundra Sea Port">Mundra Sea Port</option>
				</select>
				</td>
				<Th  >Expected Arrival Date <br>At Give Port/VIP * </Th>
				<Td valign=center>
				<div class="input-group date">
				<div class="input-group-addon">
				<i class="fa fa-calendar"></i>
				</div>
				<input type="text" class="form-control validate[required]"  value="<%=expTime%>" id="ExpectedArivalTime"  name="ExpectedArivalTime"  size=12 readonly onfocus=this.blur()>
			 	</div>
				</Td>
			</Tr>
<tr>
				<th  >Port of Loading</th>
				<td>
					<div class="input-group">
						  <input  type="text"   name="portOfLoading" id="portOfLoading" value="">
					</div>
				</td>

				<th  >Freight Forwarder</th>
				
				<Td>
				
				<div class="input-group">
					<input  type="text"  name="shipComp" id="shipComp" value=""> 
				</div>				
				
				</Td>
			</tr>
			<tr>
				<th  >Port of Discharge</th>
				<td>
				<Select  name="portOfDischarge" id="portOfDischarge" value="" tabindex="3" maxlength="20" >
					<option value="">--Select Port Of Discharge--</option>
					<option id='Port of Jiujiang'>Port of Jiujiang</option>
					<option id='Port of Fuzhou'>Port of Fuzhou</option>
					<option id='Port of Quanzhou'>Port of Quanzhou</option>
					<option id='Port of Xiamen'>Port of Xiamen</option>
					<option id='Port of Guangzhou'>Port of Guangzhou</option>
					<option id='Port of Shenzhen'>Port of Shenzhen</option>
					<option id='Port of Shantou'>Port of Shantou</option>
					<option id='Port of Zhanjiang'>Port of Zhanjiang</option>
					<option id='Shunde Port'>Shunde Port</option>
					<option id='Rongqi Port'>Rongqi Port</option>
					<option id='Gaolan Port'>Gaolan Port</option>
					<option id='Haikou New Port'>Haikou New Port</option>
					<option id='Haikou Port New Seaport'>Haikou Port New Seaport</option>
					<option id='Haikou Xiuying Port'>Haikou Xiuying Port</option>
					<option id='Macun Port'>Macun Port</option>
					<option id='Port of Yangpu'>Port of Yangpu</option>
					<option id='South Port'>South Port</option>
					<option id='Hebei'>Hebei</option>
					<option id='Caofeidian'>Caofeidian</option>
					<option id='Qinhuangdao Port'>Qinhuangdao Port</option>
					<option id='Hong Kong'>Hong Kong</option>
					<option id='Container Terminal 9'>Container Terminal 9</option>
					<option id='Crooked Harbour'>Crooked Harbour</option>
					<option id='Double Haven'>Double Haven</option>
					<option id='Gin Drinkers Bay'>Gin Drinkers Bay</option>
					<option id='Hongkong International Terminals Ltd.'>Hongkong International Terminals Ltd.</option>
					<option id='Hebe Haven'>Hebe Haven</option>
					<option id='Holt's Wharf'>Holt's Wharf</option>
					<option id='Inner Port Shelter'>Inner Port Shelter</option>
					<option id='Kwai Tsing Container Terminals'>Kwai Tsing Container Terminals</option>
					<option id='Long Harbour (Hong Kong)'>Long Harbour (Hong Kong)</option>
					<option id='Modern Terminals Limited'>Modern Terminals Limited</option>
					<option id='Mun Tsai Tong'>Mun Tsai Tong</option>
					<option id='Port of Hong Kong'>Port of Hong Kong</option>
					<option id='River Trade Terminal'>River Trade Terminal</option>
					<option id='Rocky Harbour (Hong Kong)'>Rocky Harbour (Hong Kong)</option>
					<option id='Port Shelter'>Port Shelter</option>
					<option id='Starling Inlet'>Starling Inlet</option>
					<option id='Tai Tam Harbour'>Tai Tam Harbour</option>
					<option id='Three Fathoms Cove'>Three Fathoms Cove</option>
					<option id='Tolo Harbour'>Tolo Harbour</option>
					<option id='Tsing Yi Tong'>Tsing Yi Tong</option>
					<option id='Victoria Harbour'>Victoria Harbour</option>
					<option id='Victoria Harbour'>Victoria Harbour</option>
					<option id='Port of Suzhou'>Port of Suzhou</option>
					<option id='Changshu Xinghua Port'>Changshu Xinghua Port</option>
					<option id='Port of Dalian'>Port of Dalian</option>
					<option id='Port of Jinzhou'>Port of Jinzhou</option>
					<option id='Port of Yingkou'>Port of Yingkou</option>
					<option id='Kai Ho Port'>Kai Ho Port</option>
					<option id='Macau Container Port'>Macau Container Port</option>
					<option id='Port of Weihai'>Port of Weihai</option>
					<option id='Port of Yantai'>Port of Yantai</option>
					<option id='Qingdao Port'>Qingdao Port</option>
					<option id='Qingdao Qianwan Container Terminal'>Qingdao Qianwan Container Terminal</option>
					<option id='Port of Shanghai'>Port of Shanghai</option>
					<option id='Yangshan Port'>Yangshan Port</option>
					<option id='Tianjin'>Tianjin</option>
					<option id='Port of Tianjin'>Port of Tianjin</option>
					<option id='Zhejiang'>Zhejiang</option>
				</select>	 				
				</td>				
				
				<th  >Shipper Name</th>
				<td>
					<input class="form-control " type="text" data-errormessage-value-missing="Please Enter Shipper Name"  name="shipperName" id="shipperName">
				</td>
				
				
			</tr>
<tr>
				<th  >Shipper EMail and Address</th>
				<td >
					<input class="form-control " type="text" data-errormessage-value-missing="Please Enter Shipper EMail"  name="shipperMailId" id="shipperMailId">
					<input class="form-control " type="text" data-errormessage-value-missing="Please Enter Shipper Address"  name="shipperAddress" id="shipperAddress">
				</td>
				<th  >Cargo Readiness Date</th>
				<td id="cargoReadDate"  valign=center>
					<div class="input-group"> 
						  <input class="form-control " type="text" data-errormessage-value-missing="Please Select Cargo Readiness Date"  name="cargoReadinessDate" id="cargoReadinessDate">
					</div>		  		
		  		</td>
			</tr>
			<tr>
				<th  >No Of Containers</th>
				<td>
					<input class="form-control " type="text" data-errormessage-value-missing="Please Enter No Of Containers"  name="noofContainers" id="noofContainers">
				</td>
				<th  >Container Type</th>
				<td>
					<input class="form-control " type="text" data-errormessage-value-missing="Please Enter Container Type"  name="containerType" id="containerType">
				</td>
			</tr>
			<tr>
				<th  >Courier Tracking No</th>
				<td>
					<div class="input-group">
 						<input class="form-control " data-errormessage-value-missing="Please Enter Courier Tracking No" type="text"  name="corTrackNo" id="corTrackNo">						  
					</div>
				</td>
				<th  >Courier Tracking Company</th>
				<Td>
				<div class="input-group">

					<input class="form-control " data-errormessage-value-missing="Please Enter Courier Tracking Company" type="text"  name="corTrackComp" id="corTrackComp" value="">
				</div>
				</Td>
			</tr>
<tr>

						<th  >Insurance Amount</Th>
						<Td valign=center>
							<div class="input-group">
								<input type="text" class="form-control "  data-errormessage-value-missing="Please Enter Insurance Amount"  name="insurAmnt" id="insurAmnt" value="" tabindex="3">
							</div>
						</Td>
					
					<th  >Country of Origin</th>
				<td > 

					<Select class="form-control validate[required]"  data-errormessage-value-missing="Please Enter Country of Origin" name="countryOrgin" id="countryOrgin"  tabindex="3" maxlength="20" >
						<option value="">--Select Country--</option>

							<option value="Afghanistan" >Afghanistan</option>

							<option value="Albania" >Albania</option>

							<option value="Algeria" >Algeria</option>

							<option value="American Samoa" >American Samoa</option>

							<option value="Andorra" >Andorra</option>

							<option value="Angola" >Angola</option>

							<option value="Anguilla" >Anguilla</option>

							<option value="Antarctica" >Antarctica</option>

							<option value="Antigua And Barbuda" >Antigua And Barbuda</option>

							<option value="Argentina" >Argentina</option>

							<option value="Armenia" >Armenia</option>

							<option value="Aruba" >Aruba</option>

							<option value="Australia" >Australia</option>

							<option value="Austria" >Austria</option>

							<option value="Azerbaijan" >Azerbaijan</option>

							<option value="Bahamas" >Bahamas</option>

							<option value="Bahrain" >Bahrain</option>

							<option value="Bangladesh" >Bangladesh</option>

							<option value="Barbados" >Barbados</option>

							<option value="Belarus" >Belarus</option>

							<option value="Belgium" >Belgium</option>

							<option value="Belize" >Belize</option>

							<option value="Benin" >Benin</option>

							<option value="Bermuda" >Bermuda</option>

							<option value="Bhutan" >Bhutan</option>

							<option value="Bolivia" >Bolivia</option>

							<option value="Bosnia And Herzegowina" >Bosnia And Herzegowina</option>

							<option value="Botswana" >Botswana</option>

							<option value="Bouvet Island" >Bouvet Island</option>

							<option value="Brazil" >Brazil</option>

							<option value="British Indian Ocean Territory" >British Indian Ocean Territory</option>

							<option value="Brunei Darussalam" >Brunei Darussalam</option>

							<option value="Bulgaria" >Bulgaria</option>

							<option value="Burkina Faso" >Burkina Faso</option>

							<option value="Burundi" >Burundi</option>

							<option value="Cambodia" >Cambodia</option>

							<option value="Cameroon" >Cameroon</option>

							<option value="Canada" >Canada</option>

							<option value="Cape Verde" >Cape Verde</option>

							<option value="Cayman Islands" >Cayman Islands</option>

							<option value="Central African Republic" >Central African Republic</option>

							<option value="Chad" >Chad</option>

							<option value="Chile" >Chile</option>

							<option value="China" >China</option>

							<option value="Christmas Island" >Christmas Island</option>

							<option value="Cocos (Keeling) Islands" >Cocos (Keeling) Islands</option>

							<option value="Colombia" >Colombia</option>

							<option value="Comoros" >Comoros</option>

							<option value="Congo" >Congo</option>

							<option value="Cook Islands" >Cook Islands</option>

							<option value="Costa Rica" >Costa Rica</option>

							<option value="Cote DIvoire" >Cote DIvoire</option>

							<option value="Croatia (Local Name: Hrvatska)" >Croatia (Local Name: Hrvatska)</option>

							<option value="Cuba" >Cuba</option>

							<option value="Cyprus" >Cyprus</option>

							<option value="Czech Republic" >Czech Republic</option>

							<option value="Denmark" >Denmark</option>

							<option value="Djibouti" >Djibouti</option>

							<option value="Dominica" >Dominica</option>

							<option value="Dominican Republic" >Dominican Republic</option>

							<option value="East Timor" >East Timor</option>

							<option value="Ecuador" >Ecuador</option>

							<option value="Egypt" >Egypt</option>

							<option value="El Salvador" >El Salvador</option>

							<option value="Equatorial Guinea" >Equatorial Guinea</option>

							<option value="Eritrea" >Eritrea</option>

							<option value="Estonia" >Estonia</option>

							<option value="Ethiopia" >Ethiopia</option>

							<option value="Falkland Islands (Malvinas)" >Falkland Islands (Malvinas)</option>

							<option value="Faroe Islands" >Faroe Islands</option>

							<option value="Fiji" >Fiji</option>

							<option value="Finland" >Finland</option>

							<option value="France" >France</option>

							<option value="French Guiana" >French Guiana</option>

							<option value="French Polynesia" >French Polynesia</option>

							<option value="French Southern Territories" >French Southern Territories</option>

							<option value="Gabon" >Gabon</option>

							<option value="Gambia" >Gambia</option>

							<option value="Georgia" >Georgia</option>

							<option value="Germany" >Germany</option>

							<option value="Ghana" >Ghana</option>

							<option value="Gibraltar" >Gibraltar</option>

							<option value="Greece" >Greece</option>

							<option value="Greenland" >Greenland</option>

							<option value="Grenada" >Grenada</option>

							<option value="Guadeloupe" >Guadeloupe</option>

							<option value="Guam" >Guam</option>

							<option value="Guatemala" >Guatemala</option>

							<option value="Guinea" >Guinea</option>

							<option value="Guinea-Bissau" >Guinea-Bissau</option>

							<option value="Guyana" >Guyana</option>

							<option value="Haiti" >Haiti</option>

							<option value="Heard And Mc Donald Islands" >Heard And Mc Donald Islands</option>

							<option value="Holy See (Vatican City State)" >Holy See (Vatican City State)</option>

							<option value="Honduras" >Honduras</option>

							<option value="Hong Kong" >Hong Kong</option>

							<option value="Hungary" >Hungary</option>

							<option value="IcelAnd" >IcelAnd</option>

							<option value="India" >India</option>

							<option value="Indonesia" selected>Indonesia</option>

							<option value="Iran (Islamic Republic Of)" >Iran (Islamic Republic Of)</option>

							<option value="Iraq" >Iraq</option>

							<option value="Ireland" >Ireland</option>

							<option value="Israel" >Israel</option>

							<option value="Italy" >Italy</option>

							<option value="Jamaica" >Jamaica</option>

							<option value="Japan" >Japan</option>

							<option value="Jordan" >Jordan</option>

							<option value="Kazakhstan" >Kazakhstan</option>

							<option value="Kenya" >Kenya</option>

							<option value="Kiribati" >Kiribati</option>

							<option value="Korea, Dem PeopleS Republic" >Korea, Dem PeopleS Republic</option>

							<option value="Korea, Republic Of" >Korea, Republic Of</option>

							<option value="Kuwait" >Kuwait</option>

							<option value="Kyrgyzstan" >Kyrgyzstan</option>

							<option value="Lao PeopleS Dem Republic" >Lao PeopleS Dem Republic</option>

							<option value="Latvia" >Latvia</option>

							<option value="Lebanon" >Lebanon</option>

							<option value="Lesotho" >Lesotho</option>

							<option value="Liberia" >Liberia</option>

							<option value="Libyan Arab Jamahiriya" >Libyan Arab Jamahiriya</option>

							<option value="Liechtenstein" >Liechtenstein</option>

							<option value="Lithuania" >Lithuania</option>

							<option value="Luxembourg" >Luxembourg</option>

							<option value="Macau" >Macau</option>

							<option value="Macedonia" >Macedonia</option>

							<option value="Madagascar" >Madagascar</option>

							<option value="Malawi" >Malawi</option>

							<option value="Malaysia" >Malaysia</option>

							<option value="Maldives" >Maldives</option>

							<option value="Mali" >Mali</option>

							<option value="Malta" >Malta</option>

							<option value="Marshall Islands" >Marshall Islands</option>

							<option value="Martinique" >Martinique</option>

							<option value="Mauritania" >Mauritania</option>

							<option value="Mauritius" >Mauritius</option>

							<option value="Mayotte" >Mayotte</option>

							<option value="Mexico" >Mexico</option>

							<option value="Micronesia, Federated States" >Micronesia, Federated States</option>

							<option value="Moldova, Republic Of" >Moldova, Republic Of</option>

							<option value="Monaco" >Monaco</option>

							<option value="Mongolia" >Mongolia</option>

							<option value="Montserrat" >Montserrat</option>

							<option value="Morocco" >Morocco</option>

							<option value="Mozambique" >Mozambique</option>

							<option value="Myanmar" >Myanmar</option>

							<option value="Namibia" >Namibia</option>

							<option value="Nauru" >Nauru</option>

							<option value="Nepal" >Nepal</option>

							<option value="Netherlands" >Netherlands</option>

							<option value="Netherlands Ant Illes" >Netherlands Ant Illes</option>

							<option value="New Caledonia" >New Caledonia</option>

							<option value="New Zealand" >New Zealand</option>

							<option value="Nicaragua" >Nicaragua</option>

							<option value="Niger" >Niger</option>

							<option value="Nigeria" >Nigeria</option>

							<option value="Niue" >Niue</option>

							<option value="Norfolk Island" >Norfolk Island</option>

							<option value="Northern Mariana Islands" >Northern Mariana Islands</option>

							<option value="Norway" >Norway</option>

							<option value="Oman" >Oman</option>

							<option value="Pakistan" >Pakistan</option>

							<option value="Palau" >Palau</option>

							<option value="Panama" >Panama</option>

							<option value="Papua New Guinea" >Papua New Guinea</option>

							<option value="Paraguay" >Paraguay</option>

							<option value="Peru" >Peru</option>

							<option value="Philippines" >Philippines</option>

							<option value="Pitcairn" >Pitcairn</option>

							<option value="Poland" >Poland</option>

							<option value="Portugal" >Portugal</option>

							<option value="Puerto Rico" >Puerto Rico</option>

							<option value="Qatar" >Qatar</option>

							<option value="Reunion" >Reunion</option>

							<option value="Romania" >Romania</option>

							<option value="Russian Federation" >Russian Federation</option>

							<option value="Rwanda" >Rwanda</option>

							<option value="Saint K Itts And Nevis" >Saint K Itts And Nevis</option>

							<option value="Saint Lucia" >Saint Lucia</option>

							<option value="Saint Vincent, The Grenadines" >Saint Vincent, The Grenadines</option>

							<option value="Samoa" >Samoa</option>

							<option value="San Marino" >San Marino</option>

							<option value="Sao Tome And Principe" >Sao Tome And Principe</option>

							<option value="Saudi Arabia" >Saudi Arabia</option>

							<option value="Senegal" >Senegal</option>

							<option value="Seychelles" >Seychelles</option>

							<option value="Sierra Leone" >Sierra Leone</option>

							<option value="Singapore" >Singapore</option>

							<option value="Slovakia (Slovak Republic)" >Slovakia (Slovak Republic)</option>

							<option value="Slovenia" >Slovenia</option>

							<option value="Solomon Islands" >Solomon Islands</option>

							<option value="Somalia" >Somalia</option>

							<option value="South Africa" >South Africa</option>

							<option value="South Georgia , S Sandwich Is." >South Georgia , S Sandwich Is.</option>

							<option value="Spain" >Spain</option>

							<option value="Sri Lanka" >Sri Lanka</option>

							<option value="St. Helena" >St. Helena</option>

							<option value="St. Pierre And Miquelon" >St. Pierre And Miquelon</option>

							<option value="Sudan" >Sudan</option>

							<option value="Suriname" >Suriname</option>

							<option value="Svalbard, Jan Mayen Islands" >Svalbard, Jan Mayen Islands</option>

							<option value="Sw Aziland" >Sw Aziland</option>

							<option value="Sweden" >Sweden</option>

							<option value="Switzerland" >Switzerland</option>

							<option value="Syrian Arab Republic" >Syrian Arab Republic</option>

							<option value="Taiwan" >Taiwan</option>

							<option value="Tajikistan" >Tajikistan</option>

							<option value="Tanzania, United Republic Of" >Tanzania, United Republic Of</option>

							<option value="Thailand" >Thailand</option>

							<option value="Togo" >Togo</option>

							<option value="Tokelau" >Tokelau</option>

							<option value="Tonga" >Tonga</option>

							<option value="Trinidad And Tobago" >Trinidad And Tobago</option>

							<option value="Tunisia" >Tunisia</option>

							<option value="Turkey" >Turkey</option>

							<option value="Turkmenistan" >Turkmenistan</option>

							<option value="Turks And Caicos Islands" >Turks And Caicos Islands</option>

							<option value="Tuvalu" >Tuvalu</option>

							<option value="Uganda" >Uganda</option>

							<option value="Ukraine" >Ukraine</option>

							<option value="United Arab Emirates" >United Arab Emirates</option>

							<option value="United Kingdom" >United Kingdom</option>

							<option value="United States" >United States</option>

							<option value="United States Minor Is." >United States Minor Is.</option>

							<option value="Uruguay" >Uruguay</option>

							<option value="Uzbekistan" >Uzbekistan</option>

							<option value="Vanuatu" >Vanuatu</option>

							<option value="Venezuela" >Venezuela</option>

							<option value="Viet Nam" >Viet Nam</option>

							<option value="Virgin Islands (British)" >Virgin Islands (British)</option>

							<option value="Virgin Islands (U.S.)" >Virgin Islands (U.S.)</option>

							<option value="Wallis And Futuna Islands" >Wallis And Futuna Islands</option>

							<option value="Western Sahara" >Western Sahara</option>

							<option value="Yemen" >Yemen</option>

							<option value="Yugoslavia" >Yugoslavia</option>

							<option value="Zaire" >Zaire</option>

							<option value="Zambia" >Zambia</option>

							<option value="Zimbabwe" >Zimbabwe</option>

					</select>					
				</td>
				</tr>
				<tr>
					<th  >DCA</th>
					<td>
						<div class="input-group">
							<input type="text" class="form-control "  data-errormessage-value-missing="Please Select DCA"  name="dca" id="dca" value="" tabindex="3" maxlength="40">
						</div>
					</td>
					<th  >CHA</th>
					<td> 
						<div class="input-group">
							<select class="form-control "  data-errormessage-value-missing="Please Select CHA"   name="cha">
											<option Value="" selected>--select--</option>
											<option Value="OMFREIGHT" >Om Freight</option>

											<option Value="SKYSHIP" >Sky Shipping</option>

											<option Value="SUMANGALAM" >Sumangalam</option>

							
							</seclect>
						</div>
					</td>
				</tr> 
				<tr>
				<th  >Job Reference No</Th>
				<Td valign=center> 
					<div class="input-group">
					  <input class="form-control input-sm" type="text"  name="jobRefNo" id="jobRefNo" value="" >

					<br><br>
					<!--<button type="button" id="chaAckBtn" onclick="postAckCHA()" class="btn btn-primary">Acknowledge</button>					-->

					</div>
				</Td>
				<Th  >Invoice Value *</Th>
				<Td  >
					<input type=text  class="form-control validate[required]" name="vendInvoiceVal" size="31" value="">
					<input type=hidden  name="contactNo" value="">
					<input type=hidden  name="vehicleNo" value=""> 
					<input type=hidden  name="frtCond" value="<%=frtCond%>">
				</td>  			  
			</Tr>
		</Table>
		</div>
 <div id="tabs-3">
		  <input type="hidden" name="tabVal3" id="tabVal3" value="" >
				    <table class="table table-bordered dt-responsive nowrap">
				   <tr> 									   	  
					
<%
				    	
				    	if(retMasKeyValCnt>0)
				    	{
				    		for(int d=0; d<retMasKeyValCnt; d++)
				    		{
				    			
				    			mapType = retMasKeyVal.getFieldValueString(d,"EMKV_MASTER_TYPE");
				    			if("ASN_IMP_DOC".equals(mapType))
				    			{
								String docListChk="",masKey="",masVal="";
								masKey = retMasKeyVal.getFieldValueString(d,"EMKV_KEY");
								masVal = retMasKeyVal.getFieldValueString(d,"EMKV_VALUE");
								if(!"101".equals(masKey)&&!"104".equals(masKey)&&!"111".equals(masKey))continue;
								//if(d%3 == 0)
									//out.print("</tr><tr>");
%>
									<td>
										<input type="checkbox"  data-errormessage-value-missing="Please Select atleast one Document" name="docChkList" id="docChkList_<%=d%>" value="<%=masKey%>" <%=docListChk%>>&nbsp;&nbsp;<%=masVal%>
									</td>

							
						
<%
				    			}
				    		}
				    		
				    	}
%>
				   	</tr> 
				    	</table>			 
			     

			<div class="row">
				    <div class="col-md-12 col-xs-12">
				      <!-- general form elements -->
				      <div class="box box-default">
	
	
					 <div class="box-body table-responsive no-padding">
					    <div class="box-body">
					       <table id="uploadTable" class="table  table-bordered dt-responsive nowrap" >	
						<tr>
							<th>File Name</th>
							<th></th>
						</tr>
						<tr id="noDataStatUpload">
							<td>No files attached</td>
						</tr>						
						</table>
	
					</div>
				      </div>
				    </div>
				    <!-- Your Page Content Here -->
				  </div>
			</div><!--row-->
		
		<center>
			<button type="button" class="btn btn-primary" onclick="history.go(-1)">Back</button>  	
<%
		if(checkForButtons<dtlXML.getRowCount())
		{
			if(poLineCount!=0 || SALineCount!=0)
			{
%>
				<button type="button" id="subBtn" class="btn btn-primary" onclick="doSendMailConfirm('Y')">Submit</button>  	
				<button type="button" class="btn btn-primary" onclick="document.myForm.reset()">Reset</button>  
				<button type="button" class="btn btn-primary" style="background: #325786;color: white;border-radius: 3px;-webkit-box-shadow: none;box-shadow: none;border: 1px solid transparent;margin-bottom: 0;font-size: 14px;font-weight: 400;" id="uploadDialogBtn">Upload Attachments</button>
				<!--<button type="button" class="btn btn-primary" id="uploaddocs" onclick="funUpload()">Upload Docs</button>-->
				
<%				
			}
		}	
%>
		</center>
<%
	}
	else
	{
		String noDataStatement = nopoExAddsh_L;;
%>
		<%@ include file="../Misc/ezDisplayNoData.jsp" %>
		<%@ include file="../Misc/ezDisplayNoData.jsp" %>
		<Br>	<Br>
		<Center>
			<button type="button" class="btn btn-primary" onclick="navigateBack('../Misc/ezSBUWelcome.jsp')">Back</button>  	
		</Center>
<%
	} 
	session.putValue("DETAILS",objList);
	session.putValue("HEADER",headerCols1);
	session.putValue("FILE","shipment");
	
	session.putValue("CI_DETAILS",objListCI);
	session.putValue("CI_HEADER",headerCols2);
	session.putValue("CI_FILE","Commercial Invoice");
	
	
	
%>
 </div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</form>
</section>
<div id="uploadMod" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog">
      <form id="uploadForm" action="../Inbox/ezUploadFileTemp.jsp" method="post" enctype="multipart/form-data">
      <div class="modal-content">
      <div class="modal-header">
	      <button type="button" class="close" data-dismiss="modal" aria-label="Close">
		<span aria-hidden="true">×</span></button>
	      <h4 class="modal-title">Attachments</h4>
	</div>
	 <div class="modal-body">	    
	         <fieldset>
			<input type="hidden" id="upDocType" name="upDocType" value="">
			<input type="hidden" id="upDocId" name="upDocId" value="">
			<input type="hidden" id="upItemNo" name="upItemNo" value="">
			<!--<input type="file" id="file" name="file"/>-->
			<td><input type="file" id="file" name="files[]" multiple/></td>
				<!--<input type="submit" id="uploadbutton" value="upload" />-->
			<div id="loadingInd" style="display:none;margin-left: 25%;">
				<i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i>
				<span class="sr-only">Loading...</span>
			</div>
	         </fieldset>
   		
	 </div>
	 <div class="modal-footer">
	 	<button type="submit" id="uploadbutton" class="btn btn-primary">Upload</button>
	 </div>
      </div>
     </form>
   </div>  
</div> 	 



<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.17.5/xlsx.min.js"></script>  

       
<script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>
<script src="../../Library/jquery/jquery-validation-1.16.0/dist/jquery.validate.min.js"></script>
<script src="../../Library/jquery/jquery-validation-1.16.0/dist/additional-methods.min.js"></script>
<script src="../../Library/jquery/jquery-ui-1.12.1.custom/jquery-ui.js"></script>
<script src="../../../../EzCommon/Library/jquery-ui-1.10.4/js/jquery-ui-1.10.4.custom.js"></script>
</Html>

   <!-- jQuery 2.1.4 -->
    <!--<script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>-->
    <script src="../../../../EzCommon/Library/jquery.form.js"></script> 
    <script src="../../../../EzCommon/Library/plugins/jQueryUI/jquery-ui.min.js"></script>
    <script src="../../../../EzCommon/Library/plugins/select2/select2.full.min.js"></script>
     
    <!-- Bootstrap 3.3.5 -->
    <script src="../../../../EzCommon/Library/bootstrap/js/bootstrap.min.js"></script>
    <!-- AdminLTE App --> 
    <!--<script src="../../../../EzCommon/Library/js/datepicker.js"></script>-->
    
    <script src="../../../../EzCommon/Library/plugins/datepicker/bootstrap-datepicker.js"></script>
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
	<script src="../../../../EzCommon/Library/jquery-ui-1.10.4/js/jquery-ui-1.10.4.custom.js"></script>

<script>
function funDownload()
{
	var url = "ezAstatementPDF.jsp";		
	document.ACStatementForm.action=url;
	document.ACStatementForm.submit();
}
$(document).ready(function() {
		
       $("#DCDate").datepicker({ 
              	dateFormat: 'dd/mm/yy', 
             	changeMonth: true, 
          	changeYear: true 
       }); 
        $("#ShipDate").datepicker({ 
                     	dateFormat: 'dd/mm/yy', 
                     	changeMonth: true,  
          		changeYear: true
       });
       $("#InvoiceDate").datepicker({ 
		dateFormat: 'dd/mm/yy', 
		changeMonth: true,  
		changeYear: true
       });
	 $("#ExpectedArivalTime").datepicker({ 
                     	dateFormat: 'dd/mm/yy', 
                     	changeMonth: true,
          		changeYear: true
       });
      
 });
function funDownloadExcel()
{
	document.myForm.action="../Prdplan/ezDownloadExcel.jsp";
	document.myForm.submit();
}

function funFilledDownloadExcel() {
	var hiddenTable = document.getElementById('hiddenTable');
	hiddenTable.style.display = 'block';
  	var filteredData = [];
	var shipperAddress = document.getElementById("shipperAddress").value;
	var countryOrgin = document.getElementById("countryOrgin").value;
	var countryOfFinalDestination = '';
	var modeOfTransport = document.getElementById("ListBoxDiv1").value;
	var portOfLoading = document.getElementById("portOfLoading").value;
	var portOfDischarge = document.getElementById("portOfDischarge").value;
	var finalDestinationOfGoods = '';
	var termOfDelivery = '';
	var termOfPayment = '';
	var InvoiceNo = document.getElementById("InvoiceNo").value;
	var InvoiceDate = document.getElementById("InvoiceDate").value;
	var lrData = document.getElementById("LR").value;

	//alert(shipperAddress+"<<countryOrgin>>"+countryOrgin+":::"+modeOfTransport+":::"+InvoiceNo)

	// Add the data to the filteredData array in the specified format.
	filteredData.push(["SHIPPER ADDRESS:", shipperAddress,"","","InvoiceNo :", InvoiceNo]);
	filteredData.push(["COUNTRY OF ORIGIN OF GOODS :", countryOrgin,"","","BILL OF LADING NO. :", lrData]);
	filteredData.push(["COUNTRY OF FINAL DESTINATION :", countryOfFinalDestination,"","","InvoiceDate :", InvoiceDate]);
	filteredData.push(["SHIPMENT MODE :", modeOfTransport]);
	filteredData.push(["PORT OF LOADING :", portOfLoading]);
	filteredData.push(["PORT OF DISCHARGE :", portOfDischarge]);
	filteredData.push(["FINAL DESTINATION OF GOODS :", finalDestinationOfGoods]);
	filteredData.push(["TERM OF DELIVERY :", termOfDelivery]);
	filteredData.push(["TERM OF PAYMENT :", termOfPayment]); 


	filteredData.push([]);
	filteredData.push([]);
	filteredData.push(["","","","","","","","","PACKING","LIST"]);
	filteredData.push([]);
	filteredData.push([]);

	var table = document.getElementById("example3");
		 if (table) {
		 var rows = table.getElementsByTagName("tr");
		 var sumTempTotQty = 0;
		    var sumVolBOM = 0;
		    var sumTotNetWt = 0;
   		 var sumTotGrWt = 0;
   		 for (var i = 1; i < rows.length; i++) 
   		 {
		 	var cells = rows[i].getElementsByTagName("td");
		 	var rmoNum	= cells[2].innerText;
			var tempTotQty 	= parseFloat(cells[20].innerText); 
			var volBOM 	= cells[21].innerText;
			var totNetWt 	= cells[22].innerText;
			var totGrWt 	= cells[23].innerText;
			sumTempTotQty += tempTotQty;
			sumVolBOM += parseFloat(volBOM);
			sumTotNetWt += parseFloat(totNetWt);
			sumTotGrWt += parseFloat(totGrWt);
		}
		     /*var headers = [];
		     $(table).find("th").each(function() {
		         if ($(this).css("display") !== "none") {
		             headers.push($(this).text());
		         }
		     });*/
		     var headers = ["PO_NO","LINE_NO","RMO NO","RANGE NAME","SAP MAT DESCRIPTION"," MATERIAL GROUP","HS CODE"," MATERIAL","ENG DESCRIPTION","MAN DESCRIPTION","COLOR(ENG)","COLOR(MAN)","UOM","PO ORDER QTY","SUBMITTED_QUANTITY","BD CONFIRMED_QUANTITY","Balance Qty","SHIP_QTY","QTY_OF_PACKAGE","QTY_PER_PACKAGE_UNIT","TOTAL_QTY","VOLUME_CBM","TOTAL_NET_WEIGHT_KGS","TOTAL_GROSS_WEIGHT_KGS","CONTAINER_NO","SEAL_NO"]; 
		     filteredData.push(headers);
		  $(table).find("tbody tr").each(function() {
				         var rowData = [];
				         $(this).find("td").each(function(index) {
				             if ($(this).css("display") !== "none") {
				                     var cellValue = $(this).text().trim();
				                     rowData.push(cellValue);
				                 }
				 
				             
				         });
				 
				         if (rowData[17] !== '' && rowData[17] !== '0') {
				             filteredData.push(rowData);
				         }
				     });
		filteredData.push([]);
		filteredData.push([]);
		filteredData.push(["RMO DETAILS :",rmoNum]); 
		filteredData.push([]);
		filteredData.push([]);
		filteredData.push([]);
		filteredData.push(["","","VESSEL DETAIL :"]);
		filteredData.push(["","","VESSEL/VOY.NO "]);
		filteredData.push([]);
		filteredData.push(["","","ETD:"]);
		filteredData.push(["","","ETA: "]);
		filteredData.push([]);
		filteredData.push(["TOTAL :",sumTempTotQty,"","CNTR/SEAL NO :"]); 
		filteredData.push(["GROSS WEIGHT :",sumTotGrWt]); 
		filteredData.push(["NET WEIGHT :",sumTotNetWt]); 
		filteredData.push(["VOLUME :",sumVolBOM]);
		   
		    filteredData.sort(function(a, b) {
		   	    if (a[5] < b[5]) return -1;
		   	    if (a[5] > b[5]) return 1;
		   	    return 0;
		});
		   if (filteredData.length > 1) {
		         var maxColumns = filteredData.reduce(function (max, row) {
		             return Math.max(max, row.length);
		         }, 0);
		 
		         for (var i = 0; i < filteredData.length; i++) {
		             while (filteredData[i].length < maxColumns) {
		                 filteredData[i].push('');
		             }
		         }
		 
		         var worksheet = XLSX.utils.aoa_to_sheet(filteredData);
		         var workbook = XLSX.utils.book_new();
		         XLSX.utils.book_append_sheet(workbook, worksheet, "Sheet 1");
		         XLSX.writeFile(workbook, "Packing List.xlsx");
		     } else {
		         alert("No rows found with entered quantity.");
		     }
		 } else {
		     alert("Table not found.");
		 }
		 hiddenTable.style.display = 'none';

}
function funMasterDownloadExcel() {
	var hiddenTable = document.getElementById('hiddenTable');
	hiddenTable.style.display = 'block';
	var filteredData = [];
	//Saving header details
	var shipperAddress = document.getElementById("shipperAddress").value;
	var countryOrgin = document.getElementById("countryOrgin").value;
	var countryOfFinalDestination = '';
	var modeOfTransport = document.getElementById("ListBoxDiv1").value;
	var portOfLoading = document.getElementById("portOfLoading").value;
	var portOfDischarge = document.getElementById("portOfDischarge").value;
	var finalDestinationOfGoods = '';
	var termOfDelivery = '';
	var termOfPayment = '';
	var InvoiceNo = document.getElementById("InvoiceNo").value;
	var InvoiceDate = document.getElementById("InvoiceDate").value;
	var lrData = document.getElementById("LR").value;
	
	//alert(shipperAddress+"<<countryOrgin>>"+countryOrgin+":::"+modeOfTransport+":::"+InvoiceNo)
		
	// Add the data to the filteredData array in the specified format.
	filteredData.push(["SHIPPER ADDRESS:", shipperAddress,"","","InvoiceNo :", InvoiceNo]);
	filteredData.push(["COUNTRY OF ORIGIN OF GOODS :", countryOrgin,"","","BILL OF LADING NO. :", lrData]);
	filteredData.push(["COUNTRY OF FINAL DESTINATION :", countryOfFinalDestination,"","","InvoiceDate :", InvoiceDate]);
	filteredData.push(["SHIPMENT MODE :", modeOfTransport]);
	filteredData.push(["PORT OF LOADING :", portOfLoading]);
	filteredData.push(["PORT OF DISCHARGE :", portOfDischarge]);
	filteredData.push(["FINAL DESTINATION OF GOODS :", finalDestinationOfGoods]);
	filteredData.push(["TERM OF DELIVERY :", termOfDelivery]);
	filteredData.push(["TERM OF PAYMENT :", termOfPayment]); 
	
	//adding extra columns
	filteredData.push([]);
	filteredData.push([]);
	filteredData.push(["","","","","","","","","MASTERS"]);
	filteredData.push([]);
	filteredData.push([]);
	
	//Getting Item level Details
	var table = document.getElementById("example1");
	var sumTempTotQty = 0;
	var sumVolBOM = 0;
	var sumTotNetWt = 0;
	var sumTotGrWt = 0;
	if (table) {
	    
	    //var headers = ["Raw Material","RMO No","PO No","Line", "Material","Eng Description", "Mat Description","Man Description", "Color(Eng)","Color(Man)","UOM", "Total Qty","Submitted Qty","Balance Qty", "Confirmed Qty", "Quantity", "QTY of Package","QTY per Package Unit", "Volume(CBM)", "Total Net Weight(KGS)", "Total Gross Weight(KGS)", "HSN/SAC" ,"Invoiced QTY", "Unit Price In USD", "Total Value In USD"];
	    var headers = ["PO_NO","LINE_NO","RMO NO","RANGE NAME","SAP MAT DESCRIPTION"," MATERIAL GROUP","HS CODE" ,"MATERIAL","ENG DESCRIPTION", "MAN DESCRIPTION", "COLOR(ENG)","COLOR(MAN)","UOM","PO ORDER QTY", "SUBMITTED_QUANTITY", "BD CONFIRMED_QUANTITY","Balance Qty", "SHIP_QTY", "QTY_OF_PACKAGE","QTY_PER_PACKAGE_UNIT","TOTAL_QTY", "VOLUME_CBM", "TOTAL_NET_WEIGHT_KGS", "TOTAL_GROSS_WEIGHT_KGS","CONTAINER_NO","SEAL_NO", "Invoiced QTY", "Unit Price In USD", "Total Value In USD"];
	    filteredData.push(headers); // Initialize filteredData with header row

	    var totalQtyByMatNum = {};
	    var totalNetPriceByMatNum = {};
	    var countByMatNum = {};
	    var processedMatNum = {};
	    var rows = table.getElementsByTagName("tr");

	    for (var i = 1; i < rows.length; i++) { // Start from index 1 to skip the header row.
		var rowData = [];
		var cells = rows[i].getElementsByTagName("td");
		// Gather data from the cells in the row.
		var tempPONo	=cells[0].innerText;
		var lineNum	=cells[1].innerText;
		var rangename	=cells[3].innerText;
		var rmoNum	= cells[2].innerText;
		var tempmatDesc	= cells[4].innerText;
		var rawMat 	= cells[5].innerText;
		var hsn_Code  	= cells[6].getElementsByTagName("input")[0].value;
		//alert(hsn_Code)
		var matNum 	= cells[7].innerText;
		var tempengDesc = cells[8].innerText;
		var tempmanDesc = cells[9].innerText;
		var engCol 	= cells[10].innerText;
		var manCol 	= cells[11].innerText;
		var uom 	= cells[12].innerText;
		var poodrqty	= cells[13].innerText;
		var tempSubQty 	= cells[14].innerText;
		var tempConfQty = cells[15].innerText;
		var tempBalQty = cells[16].innerText;
		var tempQty 	= cells[17].getElementsByTagName("input")[0].value;
		var tempQtyPac 	= cells[18].getElementsByTagName("input")[0].value;
		var tempQtyPacUnit = cells[19].getElementsByTagName("input")[0].value;
		var tempTotQty 	= parseFloat(cells[20].getElementsByTagName("input")[0].value); 
		var volBOM 	= cells[21].getElementsByTagName("input")[0].value;
		var totNetWt 	= cells[22].getElementsByTagName("input")[0].value;
		var totGrWt 	= cells[23].getElementsByTagName("input")[0].value;
		var containerno = cells[28].getElementsByTagName("input")[0].value;
		var sealno 	= cells[29].getElementsByTagName("input")[0].value;
		var netPriceFromHash = parseFloat(cells[24].getElementsByTagName("input")[0].value); // Get the input value for netPriceFromHash.
		//alert("containerno:::"+containerno);
		//alert("sealno:::"+sealno);
		
		sumTempTotQty += tempTotQty;
		sumVolBOM += parseFloat(volBOM);
		sumTotNetWt += parseFloat(totNetWt);
		sumTotGrWt += parseFloat(totGrWt);
			
//alert(total_qty)
		// Check if the matNum already exists in the totalQtyByMatNum object.
		// If it exists, add the total_qty to the existing value; otherwise, initialize it.
		if (totalQtyByMatNum.hasOwnProperty(matNum)) {
		    totalQtyByMatNum[matNum] += tempTotQty;
		    totalNetPriceByMatNum[matNum] += netPriceFromHash;
		    countByMatNum[matNum] += 1;
		} else {
		    totalQtyByMatNum[matNum] = tempTotQty;
		    totalNetPriceByMatNum[matNum] = netPriceFromHash;
		    countByMatNum[matNum] = 1;
		}

		// Check if the matNum already exists in rowData.
		var existingIndex = -1;
		/*
		for (var j = 1; j < filteredData.length; j++) {
		    if (filteredData[j][7] === matNum) { // Check if matNum matches the existing row.
			existingIndex = j;
			break;
		    }
		}
		*/
//alert(existingIndex+"<<total>>>"+totalQtyByMatNum[matNum])
		if (existingIndex >= 0) {
		    // If matNum exists, update the rowData with the sum of total_qty.
		    filteredData[existingIndex][26] = totalQtyByMatNum[matNum];
		} else {
		    // If matNum does not exist, add a new row to filteredData.
		    rowData.push(tempPONo,lineNum,rmoNum,rangename,tempmatDesc,rawMat,hsn_Code,matNum,tempengDesc,tempmanDesc,engCol,manCol,uom,poodrqty,tempSubQty,tempConfQty,tempBalQty,tempQty,tempQtyPac,tempQtyPacUnit,tempTotQty,volBOM,totNetWt,totGrWt,containerno,sealno, totalQtyByMatNum[matNum], netPriceFromHash/1000, ""); 
		    if(tempQty != '' && tempQty != '0')
		    	filteredData.push(rowData);
		}
		
	    }    
//alert(filteredData.length)
	    // Calculate the average netPriceFromHash for repeated matNum and update filteredData.
	    for (var k = 15; k < filteredData.length; k++) {
		var matNum = filteredData[k][7];
		// Calculate average only for repeated matNum.
		if (countByMatNum[matNum] > 1) { 
		    var averageNetPrice = totalNetPriceByMatNum[matNum] / countByMatNum[matNum];
		    filteredData[k][27] = (averageNetPrice )/1000; 
		}
	    }

	    // Calculate the multiplication 
	    for (var k = 15; k < filteredData.length; k++) {
		var matNum = filteredData[k][7];
		var totalQty = totalQtyByMatNum[matNum];
		var netPrice = filteredData[k][27]; // Reverse the division for calculation.
		
		filteredData[k][28] = (totalQty * netPrice).toFixed(2);
		}

		filteredData.push([]);
		filteredData.push([]);
		filteredData.push(["RMO DETAILS :",rmoNum]); 
		filteredData.push([]);
		filteredData.push([]);
		filteredData.push([]);
		filteredData.push(["","","VESSEL DETAIL :"]);
		filteredData.push(["","","VESSEL/VOY.NO "]);
		filteredData.push([]);
		filteredData.push(["","","ETD:"]);
		filteredData.push(["","","ETA: "]);
		filteredData.push([]);
		filteredData.push(["TOTAL :",sumTempTotQty]); 
		filteredData.push(["GROSS WEIGHT :",sumTotGrWt]); 
		filteredData.push(["NET WEIGHT :",sumTotNetWt]); 
		filteredData.push(["VOLUME :",sumVolBOM]);

	   filteredData.sort(function(a, b) {
	    if (a[5] < b[5]) return -1;
	    if (a[5] > b[5]) return 1;
	    return 0;
		});
		
	    if (filteredData.length > 1) {
		var maxColumns = filteredData.reduce(function (max, row) {
		    return Math.max(max, row.length);
		}, 0);

		for (var i = 0; i < filteredData.length; i++) {
		    while (filteredData[i].length < maxColumns) {
			filteredData[i].push('');
		    }
		}
		
		var worksheet = XLSX.utils.aoa_to_sheet(filteredData);
		var workbook = XLSX.utils.book_new();
		XLSX.utils.book_append_sheet(workbook, worksheet, "Sheet 1");
		XLSX.writeFile(workbook, "Master_List.xlsx");
	    } else {
		alert("No rows found with entered quantity.");
	    }
	} else {
	    alert("Table not found.");
	}
    hiddenTable.style.display = 'none';
}    

function funCommercialInvoiceDownload()
{
	document.myForm.action="ezCIDownloadExcel.jsp";
	document.myForm.submit();
}
function funCIDownload()
{
	var filteredData = [];
	//Saving header details
	var shipperAddress = document.getElementById("shipperAddress").value;
	var countryOrgin = document.getElementById("countryOrgin").value;
	var countryOfFinalDestination = '';
	var modeOfTransport = document.getElementById("ListBoxDiv1").value;
	var portOfLoading = document.getElementById("portOfLoading").value;
	var portOfDischarge = document.getElementById("portOfDischarge").value;
	var finalDestinationOfGoods = '';
	var termOfDelivery = '';
	var termOfPayment = '';
	var InvoiceNo = document.getElementById("InvoiceNo").value;
	var InvoiceDate = document.getElementById("InvoiceDate").value;
	var lrData = document.getElementById("LR").value;
	
	//alert(shipperAddress+"<<countryOrgin>>"+countryOrgin+":::"+modeOfTransport+":::"+InvoiceNo)
		
	// Add the data to the filteredData array in the specified format.
	filteredData.push(["SHIPPER ADDRESS:", shipperAddress,"","","InvoiceNo :", InvoiceNo]);
	filteredData.push(["COUNTRY OF ORIGIN OF GOODS :", countryOrgin,"","","BILL OF LADING NO. :", lrData]);
	filteredData.push(["COUNTRY OF FINAL DESTINATION :", countryOfFinalDestination,"","","InvoiceDate :", InvoiceDate]);
	filteredData.push(["SHIPMENT MODE :", modeOfTransport]);
	filteredData.push(["PORT OF LOADING :", portOfLoading]);
	filteredData.push(["PORT OF DISCHARGE :", portOfDischarge]);
	filteredData.push(["FINAL DESTINATION OF GOODS :", finalDestinationOfGoods]);
	filteredData.push(["TERM OF DELIVERY :", termOfDelivery]);
	filteredData.push(["TERM OF PAYMENT :", termOfPayment]); 
	
	//adding extra columns
	filteredData.push([]);
	filteredData.push([]);
	filteredData.push(["","","","","","","COMMERCIAL","INVOICE"]);
	filteredData.push([]);
	filteredData.push([]);
	
	//Getting Item level Details
	var table = document.getElementById("example1");
		if (table) {
		    
	            //var headers = ["Raw Material","RMO No","PO No", "Material", "Mat Description", "Color(Eng)", "UOM", "HSN/SAC","Balance Qty", "Invoiced QTY", "Unit Price In USD", "Total Value In USD"];
		    var headers = ["PO_NO","RMO NO","SAP MAT DESCRIPTION"," MATERIAL GROUP","HS CODE", " MATERIAL",  "COLOR(ENG)", "UOM", "Balance Qty", "Invoiced QTY", "Unit Price In USD", "Total Value In USD"];
		    filteredData.push(headers); // Initialize filteredData with header row
	
		    var totalQtyByMatNum = {};
		    var totalNetPriceByMatNum = {};
		    var countByMatNum = {};
		    var processedMatNum = {};
		    var rows = table.getElementsByTagName("tr");
	
		    for (var i = 1; i < rows.length; i++) { // Start from index 1 to skip the header row.
			var rowData = [];
			var cells = rows[i].getElementsByTagName("td");
	
			// Gather data from the cells in the row.
			var tempPONo=(cells[0].innerText).trim();
			var rmoNo=cells[2].innerText;
			var tempmatDesc = cells[4].innerText;
			var rawMat = cells[5].innerText;
			var hsn_Code  	= cells[6].getElementsByTagName("input")[0].value;
			var matNum = (cells[7].innerText).trim();
			var engCol = cells[10].innerText;
			var uom = cells[12].innerText;
			var balQty = cells[16].innerText;
			var total_qty 	= parseFloat(cells[17].getElementsByTagName("input")[0].value); 
			var netPriceFromHash = parseFloat(cells[24].getElementsByTagName("input")[0].value); // Get the input value for netPriceFromHash.
			var tempmatPO=matNum+tempPONo;
			netPriceFromHash = netPriceFromHash/1000;
			
			
			// Check if the matNum already exists in the totalQtyByMatNum object.
			// If it exists, add the total_qty to the existing value; otherwise, initialize it.
			if (totalQtyByMatNum.hasOwnProperty(tempmatPO)) {
			//alert("Combined PO    "+tempmatPO+"   netPriceFromHash>>>"+netPriceFromHash);
			    totalQtyByMatNum[tempmatPO] += total_qty;
			    totalNetPriceByMatNum[tempmatPO] += netPriceFromHash;
			    countByMatNum[tempmatPO] += 1;
			    //alert("<<count value >>>"+countByMatNum[tempmatPO])
			} else {
			    totalQtyByMatNum[tempmatPO] = total_qty;
			    totalNetPriceByMatNum[tempmatPO] = netPriceFromHash;
			    countByMatNum[tempmatPO] = 1;
			}
	
			// Check if the matNum already exists in rowData.
			var existingIndex = -1;
			for (var j = 1; j < filteredData.length; j++) {
			var matTemp=filteredData[j][5];
			var poTemp=filteredData[j][0];
			var comTemp=matTemp+poTemp;
			    if (comTemp === tempmatPO ) { // Check if matNum matches the existing row.
				existingIndex = j;
				break;
			    }
			}
	
			if (existingIndex >= 0) {
			    // If matNum exists, update the rowData with the sum of total_qty.
			    	filteredData[existingIndex][9] = totalQtyByMatNum[tempmatPO];
			 	     filteredData[existingIndex][10] += (netPriceFromHash / countByMatNum[tempmatPO]); // Update "Unit Price In USD"
			        filteredData[existingIndex][11] = (parseFloat(filteredData[existingIndex][9]) * filteredData[existingIndex][10]).toFixed(2); // Update Total Value In USD
			    } else {
			        // If matNum does not exist, add a new row to filteredData.
			        rowData.push(tempPONo, rmoNo, tempmatDesc, rawMat, hsn_Code, matNum, engCol, uom, balQty, totalQtyByMatNum[tempmatPO], netPriceFromHash, totalQtyByMatNum[tempmatPO] * (netPriceFromHash));
				   alert("rowData[9] "+rowData[9]);
				   if ( rowData[9] !== 0 && rowData[9] !== '' ) {
				   	filteredData.push(rowData);
				}
				   
			}
			
		    }
	


filteredData.push([]);
   filteredData.push([]);
   filteredData.push(["RMO DETAILS :",rmoNo]); 
   filteredData.push([]);
   filteredData.push([]);
   filteredData.push([]);
   filteredData.push(["","","VESSEL DETAIL :"]);
   filteredData.push(["","","VESSEL/VOY.NO "]);
   filteredData.push([]);
   filteredData.push(["","","ETD:"]);
   filteredData.push(["","","ETA: "]);
   filteredData.push([]);
   filteredData.push(["TOTAL :"]); 
   filteredData.push(["GROSS WEIGHT :"]); 
   filteredData.push(["NET WEIGHT :"]); 
filteredData.push(["VOLUME :"]);

	 filteredData.sort(function(a, b) {
		    if (a[3] < b[3]) return -1;
		    if (a[3] > b[3]) return 1;
		    return 0;
		});
	
	    if (filteredData.length > 1) {
		var maxColumns = filteredData.reduce(function (max, row) {
		    return Math.max(max, row.length);
		}, 0);

		for (var i = 0; i < filteredData.length; i++) {
		    while (filteredData[i].length < maxColumns) {
			filteredData[i].push('');
		    }
		}

		var worksheet = XLSX.utils.aoa_to_sheet(filteredData);
		var workbook = XLSX.utils.book_new();
		XLSX.utils.book_append_sheet(workbook, worksheet, "Sheet 1");
		XLSX.writeFile(workbook, "CI List.xlsx");
	    } else {
		alert("No rows found with entered quantity.");
	    }
	} else {
	    alert("Table not found.");
	}

}
function funShowFile()
{
	var file = document.myForm.file;
	var dotPos 	= file.value.lastIndexOf('.');
	var fileExt	= file.value.substring(dotPos+1,file.length);

	if(fileExt=='xlsx' || fileExt=='xls')
	{

		document.getElementById("uploadExcel").style.display="none";
		document.getElementById("uploadSelExcel").style.display="inline-block";
		document.myForm.fileName.value=file.files[0].name;
		document.getElementById("uploadSelExcel").innerHTML = '<span class=\'glyphicon glyphicon-open-file\'></span>  Upload  '+file.files[0].name;

	}
	else
	{
		alert("Upload only Excel file!");
		document.getElementById("uploadExcel").style.display="inline-block"
		document.getElementById("uploadSelExcel").style.display="none"
	}
	
}
// Method to upload a valid excel file
      function funUpload() {
        var files = document.getElementById('file-upload').files;
        if(files.length==0){
          alert("Please choose any file...");
          return;
        }
        var filename = files[0].name;
        var extension = filename.substring(filename.lastIndexOf(".")).toUpperCase();
        if (extension == '.XLS' || extension == '.XLSX') {
            excelFileToJSON(files[0]);
        }else{
            alert("Please select a valid excel file.");
        }
      }
       
      //Method to read excel file and convert it into JSON 
      function excelFileToJSON(file){
          try {
            var reader = new FileReader();
            reader.readAsBinaryString(file);
            reader.onload = function(e) {
 
                var data = e.target.result;
                var workbook = XLSX.read(data, {type : 'binary', cellText: false, cellDates: true});
                var result = {};
                workbook.SheetNames.forEach(function(sheetName) {
                var roa = XLSX.utils.sheet_to_row_object_array(workbook.Sheets[sheetName], {header:0,raw:false,dateNF:'dd-MMM-yy'});
                if (roa.length > 0) {
                    result[sheetName] = roa;
                }
              });
                //displaying the json result
                debugger;
                fillShipmentDetails(result);
                //populateTable(result);
                
               // Displaying the second table as it is
	       var dataTable2 = $("#example3 tbody");
	       dataTable2.empty(); // Clear existing data
	       
	       var sheetName = workbook.SheetNames[0];
	       var sheet = workbook.Sheets[sheetName];
	       var tableData = XLSX.utils.sheet_to_json(sheet, { header: 1 });
	       tableData.shift();
	       
	       // Populate the second table with data rows
	       tableData.forEach(function (rowData) {
	           var row = $("<tr>");
	           for (var i = 0; i < rowData.length; i++) {
	               var cellValue = rowData[i];
	               if (cellValue === undefined || cellValue === null || cellValue === "") {
	                   cellValue = 0;
	               }
	               row.append($("<td>").text(cellValue));
	           }
	           dataTable2.append(row);
	       });

                
                /*
                var resultEle=document.getElementById("json-result");
                resultEle.value=JSON.stringify(result, null, 4);
                resultEle.style.display='block';*/
                }
            }catch(e){
                console.error(e);
            }
      }
      /*
      function fillShipmentDetails(result)
      {
      	//debugger;
      	var poLineDet = {};
      	$.each(result.shipment, function(index,jsonObject){
	    var lineNo=jsonObject.LINE_NO;
	    var poNo=jsonObject.PO_NO;
	    $("#EnterQty"+poNo+"_"+lineNo).val(jsonObject.SHIP_QTY);
	   $("#packageQty"+poNo+"_"+lineNo).val(jsonObject.QTY_OF_PACKAGE);
	    $("#qtyPackUnit"+poNo+"_"+lineNo).val(jsonObject.QTY_PER_PACKAGE_UNIT);
	    //$("#total_Qty"+poNo+"_"+lineNo).val(jsonObject.TOTAL_QTY);
	    $("#total_Qty"+poNo+"_"+lineNo).val(jsonObject.QTY_OF_PACKAGE * jsonObject.QTY_PER_PACKAGE_UNIT );
	    $("#volCBM"+poNo+"_"+lineNo).val(jsonObject.VOLUME_CBM);
	    $("#netWght"+poNo+"_"+lineNo).val(jsonObject.TOTAL_NET_WEIGHT_KGS);
	    $("#grossWght"+poNo+"_"+lineNo).val(jsonObject.TOTAL_GROSS_WEIGHT_KGS);
	
// Your JavaScript code in the main page
var calculatedValue = jsonObject.QTY_OF_PACKAGE * jsonObject.QTY_PER_PACKAGE_UNIT;
$("#total_Qty" + poNo + "_" + lineNo).val(calculatedValue);
$("#calculated_total_Qty"+poNo+"_"+lineNo).val(calculatedValue);

// Send the calculated value to the server using AJAX

$.ajax({
    type: "POST",
    url: "ezGetTotalQTY.jsp", // Replace with the URL of your servlet or JSP file
    data: {
        calculated_total_Qty: calculatedValue,
        tempPONo: poNo,
        lineNum: lineNo
    },
    success: function(response) {
        // Update the hidden input field with the received calculated value
        $("#calculated_total_Qty"+poNo+"_"+ lineNo).val(response);
        
        // Now you can use the received value in your main page
        var hiddenValue = $("#calculated_total_Qty"+poNo+"_"+lineNo).val();
        alert("Received Hidden Value: " + hiddenValue);
    },
    error: function(xhr, textStatus, errorThrown) {
        // Handle errors if necessary
    }
});

        });
	
	
 }
 
*/
/*
document.addEventListener("DOMContentLoaded", function () {
    var displayButton = document.getElementById("uploadExcel");
    var dataTable = document.getElementById("example3");

    displayButton.addEventListener("click", function () {
        var fileInput = document.createElement("input");
        fileInput.type = "file";
        fileInput.accept = ".xlsx, .xls";
        fileInput.addEventListener("change", function (event) {
            var file = event.target.files[0];
            var reader = new FileReader();

            reader.onload = function (e) {
                var data = new Uint8Array(e.target.result);
                var workbook = XLSX.read(data, { type: "array" });

                var sheetName = workbook.SheetNames[0];
                var sheet = workbook.Sheets[sheetName];

                var tableData = XLSX.utils.sheet_to_json(sheet, { header: 1 });
                var tableHTML = generateTableHTML(tableData);
                dataTable.innerHTML = tableHTML;
            };

            reader.readAsArrayBuffer(file);
        });

        fileInput.click();
    });
});
*/
function generateTableHTML(data) {
alert("hi")
    var tableHTML = '<table border="1">';

    // Adding data rows
    tableHTML += '<tbody>';
    for (var i = 1; i < data.length; i++) { 
        var row = data[i];
        tableHTML += '<tr>';
        for (var key in row) {
            var cellValue = row[key];
            if (cellValue === undefined || cellValue === null || cellValue.trim() === "") {
                cellValue = "NA";
            }
            alert("Cell Value:"+cellValue); 
            tableHTML += '<td>' + cellValue + '</td>';
        }
        tableHTML += '</tr>';
    }
    tableHTML += '</tbody></table>';

    return tableHTML;
}

function fillShipmentDetails(result) {
	
 	var accumulatedData = {};
 	
    $.each(result.shipment, function(index, jsonObject) {
        var lineNo=jsonObject.LINE_NO;
        var poNo = jsonObject.PO_NO;

        if (!accumulatedData[lineNo]) {
            accumulatedData[lineNo] = {};
        }
        if (!accumulatedData[lineNo][poNo]) {
            accumulatedData[lineNo][poNo] = {
                shipQty: 0,
                qtyOfPackage: 0,
                qtyPerPackageUnit: 0,
                totalQty: 0,
                volumeCBM: 0,
                totalNetWeight: 0,
                totalGrossWeight: 0,
                container: "",
                sealNo: "",
            };
        }

        var shipQty = parseFloat(jsonObject.SHIP_QTY);
        if (isNaN(shipQty)) {
            shipQty = 0;
        }
        accumulatedData[lineNo][poNo].shipQty += shipQty;

        var qtyOfPackage = parseFloat(jsonObject.QTY_OF_PACKAGE);
        if (isNaN(qtyOfPackage)) {
            qtyOfPackage = 0;
        }
        accumulatedData[lineNo][poNo].qtyOfPackage += qtyOfPackage;

        var qtyPerPackageUnit = parseFloat(jsonObject.QTY_PER_PACKAGE_UNIT);
        if (isNaN(qtyPerPackageUnit)) {
            qtyPerPackageUnit = 0;
        }
        accumulatedData[lineNo][poNo].qtyPerPackageUnit += qtyPerPackageUnit;
        accumulatedData[lineNo][poNo].totalQty += qtyOfPackage * qtyPerPackageUnit;
        var volumeCBM = parseFloat(jsonObject.VOLUME_CBM);
        if (isNaN(volumeCBM)) {
	            volumeCBM = 0;
        }
        accumulatedData[lineNo][poNo].volumeCBM += volumeCBM;
        
        var totalNetWeight = parseFloat(jsonObject.TOTAL_NET_WEIGHT_KGS);
        if (isNaN(totalNetWeight)) {
	            totalNetWeight = 0;
        }
        accumulatedData[lineNo][poNo].totalNetWeight += totalNetWeight;
        
        var totalGrossWeight = parseFloat(jsonObject.TOTAL_GROSS_WEIGHT_KGS);
        if (isNaN(totalGrossWeight)) {
	            totalGrossWeight = 0;
        }
        accumulatedData[lineNo][poNo].totalGrossWeight += totalGrossWeight;
        
       var container = jsonObject.CONTAINER_NO;
       //alert("container::"+container);
      if (container == undefined)     container = "NA";

       accumulatedData[lineNo][poNo].container += container.toString();

       var sealNo = jsonObject.SEAL_NO;
       	 if (sealNo == undefined)   sealNo = "NA";
       	 
        accumulatedData[lineNo][poNo].sealNo += sealNo.toString();
    });

    $.each(result.shipment, function(index, jsonObject) {
        var lineNo = jsonObject.LINE_NO;
        var poNo = jsonObject.PO_NO;
        if (accumulatedData[lineNo][poNo]) {
            $("#EnterQty" + poNo + "_" + lineNo).val(accumulatedData[lineNo][poNo].shipQty);
            $("#packageQty" + poNo + "_" + lineNo).val(accumulatedData[lineNo][poNo].qtyOfPackage);
            $("#qtyPackUnit" + poNo + "_" + lineNo).val(accumulatedData[lineNo][poNo].qtyPerPackageUnit);
            $("#total_Qty" + poNo + "_" + lineNo).val(accumulatedData[lineNo][poNo].totalQty);
            $("#volCBM" + poNo + "_" + lineNo).val(accumulatedData[lineNo][poNo].volumeCBM);
            $("#netWght" + poNo + "_" + lineNo).val(accumulatedData[lineNo][poNo].totalNetWeight);
            $("#grossWght" + poNo + "_" + lineNo).val(accumulatedData[lineNo][poNo].totalGrossWeight);
            $("#container" + poNo + "_" + lineNo).val(accumulatedData[lineNo][poNo].container);
            $("#sealNo" + poNo + "_" + lineNo).val(accumulatedData[lineNo][poNo].sealNo);
        }
    });
    
    var displayButton = document.getElementById("uploadExcel");
        var dataTable = document.getElementById("example3");
    //alert(displayButton)
        displayButton.addEventListener("click", function () {
            var fileInput = document.createElement("input");
            fileInput.type = "file";
            fileInput.accept = ".xlsx, .xls";
            fileInput.addEventListener("change", function (event) {
                var file = event.target.files[0];
                var reader = new FileReader();
    
                reader.onload = function (e) {
                    var data = new Uint8Array(e.target.result);
                    var workbook = XLSX.read(data, { type: "array" });
    
                    var sheetName = workbook.SheetNames[0];
                    var sheet = workbook.Sheets[sheetName];
    
                    var tableData = XLSX.utils.sheet_to_json(sheet, { header: 1 });
                    var tableHTML = generateTableHTML(tableData);
                    dataTable.innerHTML = tableHTML;
                };
    
                reader.readAsArrayBuffer(file);
            });
    
            fileInput.click();
    });
}

/*
function populateTable(result) {
    var tableBody = $('#tableBody');

    // Clear any existing rows from the table.
    tableBody.empty();

    // Iterate through each data object in the excelData array.
    $.each(result.shipment, function(index, jsonObject) {
	// Create a new row for each object.
	var newRow = $('<tr>');

	// Append each cell (td) to the new row.
	newRow.append('<td>' + jsonObject.PO_NO + '</td>');
	newRow.append('<td>' + jsonObject.LINE_NO + '</td>');
	newRow.append('<td>' + jsonObject.RMO NO + '</td>');
	newRow.append('<td>' + jsonObject.RANGE NAME + '</td>');
	newRow.append('<td>' + jsonObject.SAP MAT DESCRIPTION + '</td>');
	newRow.append('<td>' + jsonObject.MATERIAL GROUP + '</td>');
	newRow.append('<td>' + jsonObject.HS_CODE + '</td>');
	newRow.append('<td>' + jsonObject.MATERIAL + '</td>');
	newRow.append('<td>' + jsonObject.ENG DESCRIPTION + '</td>');
	newRow.append('<td>' + jsonObject.MAN DESCRIPTION + '</td>');
	newRow.append('<td>' + jsonObject.COLOR(ENG) + '</td>');
	newRow.append('<td>' + jsonObject.COLOR(MAN) + '</td>');
	newRow.append('<td>' + jsonObject.UOM + '</td>');
	newRow.append('<td>' + jsonObject.PO ORDER QTY + '</td>');
	newRow.append('<td>' + jsonObject.SUBMITTED_QUANTITY + '</td>');
	newRow.append('<td>' + jsonObject.BD CONFIRMED_QUANTITY + '</td>');
	newRow.append('<td>' + jsonObject.Balance Qty + '</td>');
	newRow.append('<td>' + jsonObject.SHIP_QTY(INVOICE QTY/CI Qty) + '</td>');
	newRow.append('<td>' + jsonObject.QTY_OF_PACKAGE + '</td>');
	newRow.append('<td>' + jsonObject.QTY_PER_PACKAGE_UNIT + '</td>');
	newRow.append('<td>' + jsonObject.Total QTY + '</td>');
	newRow.append('<td>' + jsonObject.VOLUME_CBM + '</td>');
	newRow.append('<td>' + jsonObject.TOTAL_NET_WEIGHT_KGS + '</td>');
	newRow.append('<td>' + jsonObject.TOTAL_GROSS_WEIGHT_KGS + '</td>');
	newRow.append('<td>' + jsonObject.CONTAINER_NO + '</td>');
	newRow.append('<td>' + jsonObject.SEAL_NO + '</td>');
	tableBody.append(newRow);
    });
        }
        populateTable(result);
*/
/*
function fillShipmentDetails(result) {

$.each(result.shipment, function(index,jsonObject){
    var lineNo2=jsonObject.LINE_NO;
    var poNo2=jsonObject.PO_NO;
    var shipQty = parseFloat(jsonObject.SHIP_QTY);
    //alert("shipQty:: "+shipQty);
    if (isNaN(shipQty)) {
	shipQty = 0;
    }

    var qtyOfPackage = parseFloat(jsonObject.QTY_OF_PACKAGE);
    //alert("qtyOfPackage:: "+qtyOfPackage);
    if (isNaN(qtyOfPackage)) {
	qtyOfPackage = 0;
    }

    var qtyPerPackageUnit = parseFloat(jsonObject.QTY_PER_PACKAGE_UNIT);
    if (isNaN(qtyPerPackageUnit)) {
	qtyPerPackageUnit = 0;
    }

    var volumeCBM = parseFloat(jsonObject.VOLUME_CBM);
    if (isNaN(volumeCBM)) {
	    volumeCBM = 0;
    }


    var totalNetWeight = parseFloat(jsonObject.TOTAL_NET_WEIGHT_KGS);
    if (isNaN(totalNetWeight)) {
	    totalNetWeight = 0;
    }


    var totalGrossWeight = parseFloat(jsonObject.TOTAL_GROSS_WEIGHT_KGS);
    if (isNaN(totalGrossWeight)) {
	    totalGrossWeight = 0;
    }


    var container = parseFloat(jsonObject.CONTAINER_NO);
    if (isNaN(container)) {
	    container = 0;
	}
    var sealNo = parseFloat(jsonObject.SEAL_NO);
    if (isNaN(sealNo)) 
    {
	 sealNo = 0;
    }
    $("#EnterQty2"+poNo2+"_"+lineNo2).val(shipQty);
    $("#packageQty2"+poNo2+"_"+lineNo2).val(qtyOfPackage);
    $("#qtyPackUnit2"+poNo2+"_"+lineNo2).val(qtyPerPackageUnit);
    $("#total_Qty2"+poNo2+"_"+lineNo2).val(qtyOfPackage * qtyPerPackageUnit);
    $("#volCBM2"+poNo2+"_"+lineNo2).val(volumeCBM);
    $("#netWght2"+poNo2+"_"+lineNo2).val(totalNetWeight);
    $("#grossWght2"+poNo2+"_"+lineNo2).val(totalGrossWeight);
    $("#container2" + poNo2 + "_" + lineNo2).val(container);
    $("#sealNo2" + poNo2 + "_" + lineNo2).val(sealNo);

});
    var accumulatedData = {};
    var mostRecentLine = {};

    $.each(result.shipment, function (index, jsonObject) {
        var lineNo = jsonObject.LINE_NO;
        var poNo = jsonObject.PO_NO;
        var material = jsonObject.MATERIAL;
        var key = poNo + '_' + material;

        if (!accumulatedData[key]) {
            accumulatedData[key] = {
                shipQty: 0,
                qtyOfPackage: 0,
                qtyPerPackageUnit: 0,
                totalQty: 0,
                volumeCBM: 0,
                totalNetWeight: 0,
                totalGrossWeight: 0,
                container: 0,
                sealNo: 0,
                count: 0
            };
        }

        accumulatedData[key].shipQty += parseFloat(jsonObject.SHIP_QTY);
        accumulatedData[key].qtyOfPackage += parseFloat(jsonObject.QTY_OF_PACKAGE);
        accumulatedData[key].qtyPerPackageUnit += parseFloat(jsonObject.QTY_PER_PACKAGE_UNIT);
        accumulatedData[key].totalQty += parseFloat(jsonObject.QTY_OF_PACKAGE) * parseFloat(jsonObject.QTY_PER_PACKAGE_UNIT);
        accumulatedData[key].volumeCBM += parseFloat(jsonObject.VOLUME_CBM);
        accumulatedData[key].totalNetWeight += parseFloat(jsonObject.TOTAL_NET_WEIGHT_KGS);
        accumulatedData[key].totalGrossWeight += parseFloat(jsonObject.TOTAL_GROSS_WEIGHT_KGS);
        accumulatedData[key].container += parseFloat(jsonObject.CONTAINER_NO);
        accumulatedData[key].sealNo += parseFloat(jsonObject.SEAL_NO);
        accumulatedData[key].count++;
        mostRecentLine[key] = lineNo;
    });

    
    $.each(result.shipment, function (index, jsonObject) {
        var lineNo = jsonObject.LINE_NO;
        var poNo = jsonObject.PO_NO;
        var key = poNo + '_' + jsonObject.MATERIAL;

        if (accumulatedData[key] && lineNo === mostRecentLine[key]) {
            if (accumulatedData[key].count > 1) {
                $("#EnterQty" + poNo + "_" + lineNo).val(accumulatedData[key].shipQty);
                $("#packageQty" + poNo + "_" + lineNo).val(accumulatedData[key].qtyOfPackage);
                $("#qtyPackUnit" + poNo + "_" + lineNo).val(accumulatedData[key].qtyPerPackageUnit);
                $("#total_Qty" + poNo + "_" + lineNo).val(accumulatedData[key].totalQty);
                $("#volCBM" + poNo + "_" + lineNo).val(accumulatedData[key].volumeCBM);
                $("#netWght" + poNo + "_" + lineNo).val(accumulatedData[key].totalNetWeight);
                $("#grossWght" + poNo + "_" + lineNo).val(accumulatedData[key].totalGrossWeight);
                $("#container" + poNo + "_" + lineNo).val(accumulatedData[key].container);
                $("#sealNo" + poNo + "_" + lineNo).val(accumulatedData[key].sealNo);
            } else {
                
                $("#EnterQty" + poNo + "_" + lineNo).val(jsonObject.SHIP_QTY);
                $("#packageQty" + poNo + "_" + lineNo).val(jsonObject.QTY_OF_PACKAGE);
                $("#qtyPackUnit" + poNo + "_" + lineNo).val(jsonObject.QTY_PER_PACKAGE_UNIT);
                $("#total_Qty" + poNo + "_" + lineNo).val(jsonObject.QTY_OF_PACKAGE * jsonObject.QTY_PER_PACKAGE_UNIT);
                $("#volCBM" + poNo + "_" + lineNo).val(jsonObject.VOLUME_CBM);
                $("#netWght" + poNo + "_" + lineNo).val(jsonObject.TOTAL_NET_WEIGHT_KGS);
                $("#grossWght" + poNo + "_" + lineNo).val(jsonObject.TOTAL_GROSS_WEIGHT_KGS);
                $("#container" + poNo + "_" + lineNo).val(jsonObject.CONTAINER_NO);
                $("#sealNo" + poNo + "_" + lineNo).val(jsonObject.SEAL_NO);
            }
        }
    });
    var table = document.getElementById("example1");
    	if (table) {
    	    
    	   
    	    var rows = table.getElementsByTagName("tr");
    
    	    for (var i = 1; i < rows.length; i++) { // Start from index 1 to skip the header row.
    		var rowData = [];
    		var cells = rows[i].getElementsByTagName("td");
    		
    		
    		var tempQty 	= cells[17].getElementsByTagName("input")[0].value;
    		var tempQtyPac 	= cells[18].getElementsByTagName("input")[0].value;
    		var tempQtyPacUnit = cells[19].getElementsByTagName("input")[0].value;
    		var tempTotQty 	= parseFloat(cells[20].getElementsByTagName("input")[0].value); 
    		var volBOM 	= cells[21].getElementsByTagName("input")[0].value;
    		var totNetWt 	= cells[22].getElementsByTagName("input")[0].value;
    		var totGrWt 	= cells[23].getElementsByTagName("input")[0].value;
    		var containerno = cells[28].getElementsByTagName("input")[0].value;
		var sealno 	= cells[29].getElementsByTagName("input")[0].value;
		
		
		if (
		            tempQtyPacUnit.trim() === '' &&
		            totNetWt.trim() === '' &&
		            totGrWt.trim() === '' &&
		            containerno.trim() === '' && tempQty.trim() === ''
		        ) {
		            rows[i].style.display = 'none';
        }
	}	
    }
}
*/

window.closeModal = function(){
    $('#woModal').modal('hide');
};
$('#woModal').on('shown.bs.modal', function () {
    $(this).find('.modal-dialog').addClass('modal-lg');
});
</script>
<script>

 function downloadFile(upItemNo,fileName)
  {
  	var upDocId 	= $('#upDocId').val();
  	var upDocType 	= $('#upDocType').val();
  	window.open("../Inbox/ezFileDownloadEnter.jsp?upDocId="+upDocId+"&upDocType="+upDocType+"&upItemNo="+upItemNo+"&fileName="+fileName);
 }
 function valUploadForm()
 {
 	var upItemNo = $('#upItemNo').val();
 	var fileName = $('#file').val().replace(/C:\\fakepath\\/i, '');
 	var isValid = true;
 	if(fileName == "")
	{
		alert("Please upload file");
		isValid = false;
		return false;
	}
 	$('input[name="fileItem'+upItemNo+'"]').each(function(){
	  if($(this).val() == fileName)
	  {
	  	alert("File already uploaded");
	  	isValid = false;
		return false;
	  }	  
	});
	if(isValid)
	{
		$('#uploadbutton').hide(); 	
       		$('#loadingInd').show();
	}
	return isValid;
 }
 function deleteFile(thisObj,upItemNo,fileName)
 {
 	var upDocId 	= $('#upDocId').val();
 	var upDocType 	= $('#upDocType').val();
 	$.ajax({
	    url: '../Inbox/ezDeleteFileTemp.jsp',
	    data: { upDocId: upDocId, upDocType : upDocType,upItemNo:upItemNo,fileName:fileName},
	    dataType: "json",
	    type: 'POST',
	    success: function(result) {
	      result=$.trim(result);  
	      if(result === 'true')
	      {
	      	$(thisObj).closest("tr").remove();	
	      }
	    }
	});
 }
   $( function() {
     $( "#uploadDialogBtn" ).button().on( "click", function() {
        $("#upItemNo").val($(this).val());
        $("#file").val("");
       $('#uploadMod').modal('show');
       	return false;
     });
     $('#uploadForm').ajaxForm({
     	  beforeSubmit: valUploadForm,	
	  success: function(msg) {
	      $('#uploadbutton').show(); 	
       	      $('#loadingInd').hide();
	      msg=$.trim(msg);
	      console.log("msg"+msg);
	      //alert(msg);
	      if(msg.split("##")[0] === 'true')
	      {
	      	  $('#noDataStatUpload').hide();
	      	  var upItemNo = $('#upItemNo').val();
	      	  var count =msg.split("##")[1].split(",").length-1;
		  			  //var fileNameTemp = msg.split("##")[1].split("##")[1];
		  			   for (var i = 0; i <count; ++i) {
		  			   var fileNameTemp = msg.split("##")[1].split(",")[i];
		  			 // if(msg.split("##").length>2)
		  			  	//var fileType= msg.split("##")[2].split(",")[0];
		  			   $('#uploadTable'+upItemNo).append('<tr><td  width="95%"><input type="hidden" name="fileItem" value="'+fileNameTemp+'"><a href="javascript:downloadFile(\''+upItemNo+'\',\''+fileNameTemp+'\')">'+fileNameTemp+'</a></td><td width="5%"><span onclick="javascript:deleteFile(this,\''+upItemNo+'\',\''+fileNameTemp+'\')" class="fa fa-trash fa-lg" style="margin-left: 25%;"></span></td></tr>')
		      }}
	      //alert("File has been uploaded successfully");
	      $('#uploadMod').modal('hide');
	  },
	  error: function(msg) {
	     $('#uploadbutton').show(); 	
       	     $('#loadingInd').hide();	
	     alert("Couldn't upload file");
	  }
     });

   } );
var tabVal;
$( function() {
		        $(".sidebar-toggle").trigger("click");	
		    $( "#tabs" ).tabs();
		    $("#tabs").tabs("option", "disabled", [1,2,3]);
		    $('.select2').select2()
		    $('.btn').click(function() {
		        $(this).toggleClass('btn-success');
		        $(this).toggleClass('btn-default');
		   });
		   

			
	            //Get the first tab in document and will assume will always use first one
		    	var selectedTab = $(document).find('div[class^="ui-tabs"]').first();
		    	
		    //Navigation button, select tab when button click.
		    $(".Footer").on('click', ':button', function () {
		    debugger;
		    
			if(!$("#myForm").validationEngine('validate'))
			{
				return ;
			}
		    	 
		    	
		    	var selected = selectedTab.tabs("option", "active");
		    	//alert(selected);
		    	
			if(selected==0)
			$("#tabs").tabs("option", "disabled", [selected,2,3]);
			if(selected==1)
			$("#tabs").tabs("option", "disabled", [selected,0,3,1]);
			if(selected==2)
			$("#tabs").tabs("option", "disabled", [selected,1,3,0]);

			tabVal=selected+1;
			//alert(selected);
					
			$("#tabs").tabs("enable", selected+1);  			
			if (this.id == "btnMoveLeftTab") {
			    if (selected >= 1) {
			    //alert(selected);
			    if(selected==2)
			    {
			    $("#tabs").tabs("enable", selected-1);
			    //alert(selected-1);
			    $("#tabs").tabs("option", "disabled", [selected,0]);
			    }
			    if(selected==1)
			    {
			    $("#tabs").tabs("enable", selected-1);
			    $("#tabs").tabs("option", "disabled", [selected,2]);
			    }
			   
			    
				selectedTab.tabs("option", "active", selected - 1);
				
			    }
			} else {
			    selectedTab.tabs("option", "active", selected + 1);
			   
			}
					    	console.log(selected);
		    });

		    //Tab activated, only display next on first tab, and previous in last tab
		    selectedTab.tabs({

			activate: function (event, ui) { 
			    var active = selectedTab.tabs("option", "active");
			    var selected = selectedTab.tabs("option", "active");
			    
			    if (active == 0) {
				$("#btnMoveLeftTab").hide();
			    }else if (selectedTab.find("li:not(li[style='display:none'])").size()-1 == selected){
				$("#btnMoveRightTab").hide();
			    }else{
				$("#btnMoveLeftTab").show();
				$("#btnMoveRightTab").show();
			    }

			}
		    });

		    //First time loading hide the previous button
		    $("#btnMoveLeftTab").hide();
		} );		

		
</script>
 <link rel="stylesheet" href="../../../../EzCommon/Library/plugins/jQuery/confirm.css" type="text/css" media="screen" />  
    <script src="../../../../EzCommon/Library/plugins/jQuery/confirm.min.js"></script>
     