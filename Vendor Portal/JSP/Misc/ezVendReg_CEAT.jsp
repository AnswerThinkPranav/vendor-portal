<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" /> 
<%@ include file="ezCountryHT.jsp"%> 
<%@ page import="javax.sql.DataSource,javax.naming.InitialContext,javax.naming.Context" %> 
<%@ page import="java.util.*"%>         
<%@ include file="ezUserType.jsp"%>  
<%@ include file="ezVendRegHT.jsp"%> 
<%!
 public String getMaxRefNo(ezc.session.EzSession Session)
	{
		String maxDocId="";  
		Boolean ackFlag = true;
		ezc.ezparam.ReturnObjFromRetrieve vendRet	  =	null; 
		try{
			ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false); 				
			ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
			ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
			ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
			miscTableRow.setQuery("SELECT MAX(ECFH_DOC_ID) AS DOC_NO FROM EZC_CUSTOMER_FORM_HEADER");
			miscTable.appendRow(miscTableRow);
			mainParams.setLocalStore("Y");
			mainParams.setObject(miscTable);
			Session.prepareParams(mainParams);
			vendRet=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
			if(vendRet != null){
				maxDocId = vendRet.getFieldValueString(0,"DOC_NO");
			}
		}
		catch(Exception e){
			ackFlag = false;
		}
		java.util.Date curDate = new java.util.Date();
		java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyMM");
		String tempStr = sdf.format(curDate);
		if(ackFlag)
		{
			if(maxDocId == null || "null".equals(maxDocId) || "".equals(maxDocId) || !maxDocId.startsWith(tempStr)){
				maxDocId = tempStr+"0001";
			}
			else{
				maxDocId = (Long.parseLong(maxDocId)+1)+"";
			} 
		}
		return maxDocId+"";
	}
%>
<%@ include file="../../../EzVendor/Includes/JSPs/VenApproval/iViewVendRegDetails.jsp"%>

<%!        
 
	public String checkNull(String str)   
	{  
		String retStr = "";
		 
		if(str == null || "null".equals(str) || "".equals(str)) 
			retStr = "";
		else
			retStr = str;
			 
		return retStr;	
	}
	      
%>

<!DOCTYPE html>   
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge"> 
    <title>EzCommerce Suite</title>
    <!-- Tell the browser to be responsive to screen width -->
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    
    <meta http-equiv="cache-control" content="max-age=0" />
    <meta http-equiv="cache-control" content="no-cache" />
    <meta http-equiv="expires" content="0" />
    <meta http-equiv="expires" content="Tue, 01 Jan 1990 12:00:00 GMT" />

    <!-- Bootstrap 3.3.5 -->
    <link rel="stylesheet" href="../../../EzCommon/Library/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="../../../EzCommon/Library/bootstrap/css/datepicker.css">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
    
    <!-- Ionicons -->
    <link rel="stylesheet" href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css">
    <!-- Theme style --> 
    <link rel="stylesheet" href="../../../EzCommon/Library/dist/css/AdminLTE.min.css">
    <!-- AdminLTE Skins. We have chosen the skin-blue for this starter
          page. However, you can choose any other skin. Make sure you
          apply the skin class to the body tag so the changes take effect.
    -->
    <link rel="stylesheet" href="../../../EzCommon/Library/dist/css/skins/skin-blue.min.css">
    <!-- Select2 -->
    <link rel="stylesheet" href="../../../EzCommon/Library/plugins/select2/select2.min.css">
    <link rel="stylesheet" href="../../../EzCommon/Library/plugins/pace/pacetopline.css">
    <link rel="stylesheet" href="../../../EzCommon/Library/plugins/jQueryUI/jquery-ui.css">
    <!--datatables css-->
	<link rel="stylesheet" type="text/css" href="../../../EzCommon/Library/dataTables/dataTables.bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="../../../EzCommon/Library/dataTables/dataTables.responsive.min.css">
	<link rel="stylesheet" type="text/css" href="../../../EzCommon/Library/dataTables/dataTables.tableTools.css"> 
	<link rel="stylesheet" type="text/css" href="../../../EzCommon/Library/jQuery-Validation/css/validationEngine.jquery.css">
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
    <style>
    .ui-datepicker {
        width: 300px;
        height: 300px;
        margin: 5px auto 0;
        font: 12pt Arial, sans-serif;
        /*-webkit-box-shadow: 0px 0px 10px 0px rgba(0, 0, 0, .5);
        -moz-box-shadow: 0px 0px 10px 0px rgba(0, 0, 0, .5);*/
    }
    
        .ui-datepicker table {
            width: 100%;
        }
    
    .ui-datepicker-header {
        background: #3399ff;
        color: #ffffff;
        font-family:'Times New Roman';
        border-width: 1px 0 0 0;
        border-style: solid;
        border-color: #111;
    }
    
    .ui-datepicker-title {
        text-align: center;
        font-size: 15px;
    
    }
    
    .ui-datepicker-prev {
        float: left;
        cursor: pointer;
        background-position: center -30px;
    }
    
    .ui-datepicker-next {
        float: right;
        cursor: pointer;
        background-position: center 0px;
    }
    
    .ui-datepicker thead {
        background-color: #f7f7f7;
    
        /*border-bottom: 1px solid #bbb;*/
    }
    
    .ui-datepicker th {
        background-color:#808080;
        text-transform: uppercase;
        font-size: 8pt;
        color: #666666;
        /*text-shadow: 1px 0px 0px #fff;*/
        /*filter: dropshadow(color=#fff, offx=1, offy=0);*/
    }
    
    .ui-datepicker tbody td {
        padding: 0;
        /*border-right: 1px solid #808080;*/
    }
    
        .ui-datepicker tbody td:last-child {
            border-right: 0px;
        }
    
    .ui-datepicker tbody tr {
        border-bottom: 1px solid #bbb;
    }
    
        .ui-datepicker tbody tr:last-child {
            border-bottom: 0px;
        }
    
    .ui-datepicker a {
        text-decoration: none;
    }
    
    .ui-datepicker td span, .ui-datepicker td a {
        display: inline-block;
        /*font-weight: bold;*/
        text-align: center;
        width: 30px;
        height: 30px;
        line-height: 30px;
        color: #ffffff;
        /*text-shadow: 1px 1px 0px #fff;*/
        /*filter: dropshadow(color=#fff, offx=1, offy=1);*/
    }
    
    .ui-datepicker-calendar .ui-state-default {
          background: linear-gradient(#999999, #737373);
          color:#ffffff;
          height:40px;
          width:40px;
    
    }
    
    .ui-datepicker-calendar .ui-state-hover {
        background: #33adff;
        color: #FFFFFF;
    }
    
    .ui-datepicker-calendar .ui-state-active {
        background: #33adff;
        -webkit-box-shadow: inset 0px 0px 10px 0px rgba(0, 0, 0, .1);
        -moz-box-shadow: inset 0px 0px 10px 0px rgba(0, 0, 0, .1);
        box-shadow: inset 0px 0px 10px 0px rgba(0, 0, 0, .1);
        color: #e0e0e0;
        text-shadow: 0px 1px 0px #4d7a85;
        border: 1px solid #55838f;
        position: relative;
        margin: -1px;
    }
    
    .ui-datepicker-unselectable .ui-state-default {
        background: #D6E4BE;
        color: #000;
    }

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
	color: #212529;
	line-height: 2.4 !important;

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

    
    .geoDiv
    {
    	display: inline-block;
	    margin-bottom: 0px;
	    font-weight: 600;
	    position: relative;
	    line-height: 1em;
	    text-indent: 3.25em;
	    margin-top: 2em;
	    cursor: pointer;
	    -webkit-user-select: none;
	    -moz-user-select: none;
	    -ms-user-select: none;
    	user-select: none;
    }
    
    .btn.btn-default span.glyphicon {    			
    	opacity: 0;				
    }
    .btn.btn-success.active span.glyphicon {				
    	opacity: 1;				
}

/*.switch {
  position: relative;
  display: inline-block;
  width: 60px;
  height: 34px;
}*/

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




#qmsYes:checked ~ .toggle_option_slider,
#qmsYes1:checked ~ .toggle_option_slider,
#qmsYes2:checked ~ .toggle_option_slider,
#qmsYes3:checked ~ .toggle_option_slider,
#qmsYes4:checked ~ .toggle_option_slider,
#qmsYes5:checked ~ .toggle_option_slider,
#qmsYes6:checked ~ .toggle_option_slider,
#qmsYes7:checked ~ .toggle_option_slider,
#qmsYes8:checked ~ .toggle_option_slider,
#qmsYes9:checked ~ .toggle_option_slider,
#qmsYes10:checked ~ .toggle_option_slider,
#qmsYes11:checked ~ .toggle_option_slider,
#qmsYes12:checked ~ .toggle_option_slider,
#qmsYes13:checked ~ .toggle_option_slider,
#qmsYes14:checked ~ .toggle_option_slider,
#qmsYes15:checked ~ .toggle_option_slider,
#qmsYes16:checked ~ .toggle_option_slider,
#qmsYes17:checked ~ .toggle_option_slider,
#qmsYes18:checked ~ .toggle_option_slider,
#qmsYes19:checked ~ .toggle_option_slider,
#qmsYes20:checked ~ .toggle_option_slider,
#qmsYes21:checked ~ .toggle_option_slider,
#qmsYes22:checked ~ .toggle_option_slider,
#qmsYes23:checked ~ .toggle_option_slider,
#qmsYes24:checked ~ .toggle_option_slider,
#qmsYes25:checked ~ .toggle_option_slider,
#qmsYes26:checked ~ .toggle_option_slider,
#qmsYes27:checked ~ .toggle_option_slider,
#qmsYes28:checked ~ .toggle_option_slider,
#qmsYes29:checked ~ .toggle_option_slider,
#qmsYes30:checked ~ .toggle_option_slider,
#taxYes:checked ~ .toggle_option_slider,
#whYes:checked ~ .toggle_option_slider{
  background: rgba(255,255,255,.3);
  left: 3px;
}
#qmsNo:checked ~ .toggle_option_slider,
#qmsNo1:checked ~ .toggle_option_slider,
#qmsNo2:checked ~ .toggle_option_slider,
#qmsNo3:checked ~ .toggle_option_slider,
#qmsNo4:checked ~ .toggle_option_slider,
#qmsNo5:checked ~ .toggle_option_slider,
#qmsNo6:checked ~ .toggle_option_slider,
#qmsNo7:checked ~ .toggle_option_slider,
#qmsNo8:checked ~ .toggle_option_slider,
#qmsNo9:checked ~ .toggle_option_slider,
#qmsNo10:checked ~ .toggle_option_slider,
#qmsNo11:checked ~ .toggle_option_slider,
#qmsNo12:checked ~ .toggle_option_slider,
#qmsNo13:checked ~ .toggle_option_slider,
#qmsNo14:checked ~ .toggle_option_slider,
#qmsNo15:checked ~ .toggle_option_slider,
#qmsNo16:checked ~ .toggle_option_slider,
#qmsNo17:checked ~ .toggle_option_slider,
#qmsNo18:checked ~ .toggle_option_slider,
#qmsNo19:checked ~ .toggle_option_slider,
#qmsNo20:checked ~ .toggle_option_slider,
#qmsNo21:checked ~ .toggle_option_slider,
#qmsNo22:checked ~ .toggle_option_slider,
#qmsNo23:checked ~ .toggle_option_slider,
#qmsNo24:checked ~ .toggle_option_slider,
#qmsNo25:checked ~ .toggle_option_slider,
#qmsNo26:checked ~ .toggle_option_slider,
#qmsNo27:checked ~ .toggle_option_slider,
#qmsNo28:checked ~ .toggle_option_slider,
#qmsNo29:checked ~ .toggle_option_slider,
#qmsNo30:checked ~ .toggle_option_slider,
#taxNo:checked ~ .toggle_option_slider,
#whNo:checked ~ .toggle_option_slider{
  background: rgba(255,255,255,.3);
  left: 109px;
}

}
    
    
   
	</style>	
  </head>
<body class="hold-transition register-page">
<div class="content-wrapper">
<!-- Content Header (Page header) --> 
<section class="content-header">
   <h1>
      New Vendor Registration
   </h1>
</section>
<!-- Main content -->  
<section class="content"> 

<%	  
	 String isSuccess       = "N";
 	 String userInput	= request.getParameter("userID");
	 String userName 	= "escltduser";
	 String password 	= "escltduser";
	 String connGrp 	= "640"; 
	
	int year = Calendar.getInstance().get(Calendar.YEAR);
	 
	ezc.ezcommon.EzLog4j.log("matTypemain:::::::::::::::::::::"+matType,"I");
	
	 //out.println("matType:::::::::::::::::::::"+matType);
					
	 if("null".equals(matType) || matType==null || "".equals(matType))
	 	matType = "RAW";
	// key		= ""; 
	 
	 //out.println("matType:::::::::::::::::::::"+matType);
	 
	String sessionId = session.getId();
	ezc.ezcommon.EzLog4j.log("sessionId:::::::::::::::::::::"+sessionId,"I");
	
	ezc.ezparam.EzcParams mainParamsStatus = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgrStatus = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTableStatus = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableStatusRow = new ezc.misctransactions.params.EzMiscTableRow();
	ezc.ezparam.ReturnObjFromRetrieve dtlXMLStatus	  =	null;
	ezc.ezparam.ReturnObjFromRetrieve dtlXMLUsers	  =	null;
	
	String vCode = request.getParameter("vCode");
	appFlag	= request.getParameter("appFlag");	
		
	 if("Y".equals(vendFlag) || "D".equals(vendFlag))
	 {
		ezc.ezcommon.EzLog4j.log("vCode:::::::::"+vCode,"I");
		if(vCode == null || "".equals(vCode) || "null".equals(vCode))
		vCode = Session.getUserId();
		 	
		miscTableStatusRow.setQuery("SELECT * FROM EZC_VEND_GEN_DATA WHERE EVGD_VENDOR='"+vCode+"'");
		miscTableStatus.appendRow(miscTableStatusRow);
		mainParamsStatus.setLocalStore("Y");
		mainParamsStatus.setObject(miscTableStatus);
		Session.prepareParams(mainParamsStatus);
		try
		{
			dtlXMLStatus=(ezc.ezparam.ReturnObjFromRetrieve)miscMgrStatus.ezGetMiscTransactions(mainParamsStatus);

		}
		catch(Exception e)
		{
			log("Exception in getting Purchase Group List>>>>>"+e);
		}

		
		compName   = checkNull(dtlXMLStatus.getFieldValueString(0,"EVGD_NAME"));
		zipCode = checkNull(dtlXMLStatus.getFieldValueString(0,"EVGD_POSTAL_CODE"));
		city 	   = checkNull(dtlXMLStatus.getFieldValueString(0,"EVGD_CITY"));
		country    = checkNull(dtlXMLStatus.getFieldValueString(0,"EVGD_COUNTRY"));
		fax	   = checkNull(dtlXMLStatus.getFieldValueString(0,"EVGD_FAX"));
	}
	else if("N".equals(vendFlag))
	{ 
		miscTableStatusRow.setQuery("select * from ezc_customer_form_details where ECFD_DOC_ID IN (select ECFH_DOC_ID from ezc_customer_form_header where ECFH_CREATED_BY = '"+Session.getUserId()+"')");
		miscTableStatus.appendRow(miscTableStatusRow);
		mainParamsStatus.setLocalStore("Y");
		mainParamsStatus.setObject(miscTableStatus);
		Session.prepareParams(mainParamsStatus);
		try
		{
			dtlXMLStatus=(ezc.ezparam.ReturnObjFromRetrieve)miscMgrStatus.ezGetMiscTransactions(mainParamsStatus);
			ezc.ezcommon.EzLog4j.log("dtlXMLStatus<<<<<<<"+dtlXMLStatus.toEzcString(),"I");
		}
		catch(Exception e)
		{
			log("Exception in getting Purchase Group List>>>>>"+e);
		}
		int rowCount = 0;
		rowCount = dtlXMLStatus.getRowCount();
		for(int i=0;i<rowCount;i++)
		{
			
		}
			
	}
	else
	{
		try
		 {
			ezc.session.EzLogonStructure logs = new ezc.session.EzLogonStructure();
			logs.setUserGroup("0");
			logs.setUserId(userName);
			logs.setPassWd(password);
			logs.setConnGroup(connGrp);
			ezc.ezparam.EzLogonStatus LogonStatus =  (ezc.ezparam.EzLogonStatus)Session.logon(logs);
		 }catch(Exception e){
				ezc.ezcommon.EzLog4j.log("Exception occured in getting Session","E");
	 	 }
	}
	
	miscTableStatusRow.setQuery("SELECT * FROM EZC_USERS WHERE EU_ID='"+Session.getUserId()+"'");
	miscTableStatus.appendRow(miscTableStatusRow);
	mainParamsStatus.setLocalStore("Y");
	mainParamsStatus.setObject(miscTableStatus);
	Session.prepareParams(mainParamsStatus);
	try
	{
		dtlXMLUsers	=(ezc.ezparam.ReturnObjFromRetrieve)miscMgrStatus.ezGetMiscTransactions(mainParamsStatus);

	}
	catch(Exception e)
	{
		log("Exception in getting Purchase Group List>>>>>"+e);
	}

	
	compName   = checkNull(dtlXMLUsers.getFieldValueString(0,"EU_FIRST_NAME"));	 
		   
	
%>

<form name="myForm" id="myForm" data-persist="garlic">
<input type="hidden" name="prodOffChkdet" id="prodOffChkdet" value=""/>
<input type="hidden" name="geodet" value=""/>
<input type="hidden" name="appFlag" value="<%=appFlag%>"/>
<input type="hidden" name="matType" value="<%=matType%>"/>
<input type="hidden" name="vendFlag" value="<%=vendFlag%>"/>
<input type="hidden" name="vCode" value="<%=vCode%>"/>
<input type="hidden" name="docRef" value="<%=docRef%>"/>
<input type="hidden" name="notPresentFlag" value="<%=notPresentFlag%>"/>
<input type="hidden" name="userType" value="<%=userType%>"/>
<input type="hidden" name="docId" id = "docId" value="<%=docId%>"/>
<input type="hidden" name="geoVa" value=""/>

<div class="container">
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
			
			<button id="btnMoveLeftTab" type="button" class="btn btn-primary btn-sm" value="Previous Tab" >
				<span class="glyphicon glyphicon-fast-backward"></span>
			</button>
		    </div>
		    <div class="divright">
			
			<button id="btnMoveRightTab" type="button" value="Next Tab"  class="btn btn-primary btn-sm">
				<span class="glyphicon glyphicon-fast-forward"></span>
			</button>
		    </div>
		</div>
		  <ul>
		    <li><a href="#tabs-1">Company Details</a></li>
		    <li><a href="#tabs-2">Add Plant</a></li>
		    <li><a href="#tabs-3">Product/Service Details</a></li> 
		    <li><a href="#tabs-4">PPAP Acknowledgement</a></li>
		    <li><a href="#tabs-5">Quality Certification Details</a></li>
		    <li><a href="#tabs-6">Geographic Details</a></li>
		  </ul>
		  <div id="tabs-1">
		  <input type="hidden" name="tabVal1" id="tabVal1" value="" >
		    <table class="table table-bordered">
		    	<Tr>
		    		<Th align="left">Manufacturer Name <font color="red">*</font></Th> 
		    		<Td>
		    			<input type="text" class="form-control garlic-auto-save input-sm validate[required]" data-errormessage-value-missing="Please Enter Manufacturer Name"   name="compName" onchange="funCompName()" value="<%=checkNull(compName)%>" maxlength="100">

		    		</Td>
		    		 
			</Tr>
			<Tr>
				<Th align="left">Material trade name<font color="red">*</font></Th>
				<Td>
					<input type="text" class="form-control garlic-auto-save input-sm validate[required]" data-errormessage-value-missing="Please Enter Material trade name"   name="materialTrade" value="<%=checkNull(materialTrade)%>" maxlength="100">

				</Td>	    		 
			</Tr>
			<Tr>
				<Th align="left">Plant Location <font color="red">*</font></Th>
				<Td>
					<input type="text" class="form-control garlic-auto-save input-sm validate[required]" data-errormessage-value-missing="Please Enter Plant Location"   name="plantLoc" value="<%=checkNull(plantLoc)%>" maxlength="50">

				</Td>
								    		 
			</Tr>
		    </table>
		    <div class="row" id="tabContents">
			<!-- left column -->
			<div class="col-md-12">
				<div class="box box-primary">
					<div class="box-header with-border">
						
						<h3 class="box-title">Registered Office Address</h3>
					</div>
					<div class="box-body">
						<table class="table table-bordered">
						 <tr>
							    <th align="left">Building Name</th>
							    <td>
								<input type="text" class="form-control garlic-auto-save" name="buildName" value="<%=checkNull(buildName)%>" maxlength="50">
							    </Td>

						</tr>
						<tr>

							    <th align="left">Street Name</th>
							    <td>
								<input type="text" class="form-control garlic-auto-save" name="StreetName" value="<%=checkNull(StreetName)%>" maxlength="50">
							    </Td>
							    <th align="left">Postal Code</th>
							    <td>
								<input type="text" class="form-control garlic-auto-save" name="zipCode" value="<%=checkNull(zipCode)%>" maxlength="50">
							    </Td>
						</tr>
						<tr>
 
							    <th align="left">Locality</th>
							    <td>
								<input type="text" class="form-control garlic-auto-save" name="locality" value="<%=checkNull(locality)%>" maxlength="50">
							    </Td>
							    <th align="left">Country<font color="red">*</font></th>
							    <td>
								<Select name="country" id="country" class="form-control garlic-auto-save select2" onchange="handleChange(event)">
									<option value="">--Select Country--</option>
<%
									Set set = cuntLHM.entrySet();
									Iterator i = set.iterator();
									while(i.hasNext()) 
									{
										Map.Entry me = (Map.Entry)i.next();
										cntVal=(String)me.getValue();
										chksel="";
										if(cntVal.equals(country))chksel="selected";
%>
										<option value="<%=me.getKey()%>" <%=chksel%> ><%=me.getValue()%></option>
<%

									}
%>
								</select>
							    </Td>
						</tr>
						<tr>

							    <th align="left">City<font color="red">*</font></th>
							    <td>
								<input type="text" class="form-control garlic-auto-save input-sm validate[required]" data-errormessage-value-missing="Please Enter City" name="city" value="<%=checkNull(city)%>" maxlength="50">
							    </Td>
							    <th align="left">Company Website<font color="red">*</font></th>
							    <td>
								<input type="text" class="form-control garlic-auto-save input-sm validate[required]" data-errormessage-value-missing="Please Enter Company Website" name="compWebSite" value="<%=checkNull(compWebSite)%>" maxlength="50">
							    </Td>
						</tr>
						<tr>

							    <th align="left">State/Province/Region</th>
							    <td>
								<input type="text" class="form-control garlic-auto-save" name="state" value="<%=checkNull(state)%>" maxlength="50">
							    </Td>
							    <th align="left">Fax</th>
							    <td>
								<input type="text" class="form-control garlic-auto-save" name="fax" value="<%=checkNull(fax)%>" maxlength="50">
							    </Td>
						</tr>
					   </table>
				   </div>
				</div>
			</div>
		</div>
		<div class="row" id="tabContents">
			<!-- left column -->
			<div class="col-md-12">
				<div class="box box-primary">
					<div class="box-header with-border">
						<h3 class="box-title">Contacts</h3>
					</div>
					<div class="box-body">
						<table id="contactTab" class="table table-bordered">
							<tr>

								    <th align="left"><b><a href="javascript:addLine('contactTab')"><font color="red" >[+]</font></a></b>&nbsp;Sr No.</th>
								    <th align="left">Main Contact Persons <font color="red">*</font></th>
								    <th align="left">Phone Numbers <font color="red">*</font></th>
								    <th align="left">Email Ids <font color="red">*</font></th>
								    <th align="left">Designation<font color="red">*</font></th>
							</tr>
<%
							int numVend = 0;
							if("N".equals(vendFlag) && !"REAPP".equals(appFlag)&& retContDetCnt!=0)
								numVend = retContDetCnt;
						//reapproval
							else if("N".equals(vendFlag)&& "REAPP".equals(appFlag)&& retContDetCnt==0)
								numVend = 2;
							else if("N".equals(vendFlag)&& "REAPP".equals(appFlag)&& retContDetCnt!=0)
							numVend = retContDetCnt;
							
							else
								numVend=2;
							
							String emailContact = "";
							
							for(int m=0;m<numVend;m++)
							{
								int lineItemNo = (m+1); 
								emailContact = checkNull(retContDet.getFieldValueString(m,"ERCD_EMAIL_ID"));
								
								if(m==0)
									emailContact = checkNull(dtlXMLUsers.getFieldValueString(0,"EU_EMAIL"));	 
		
%>
								<tr>

									    <td align="center">
										<%=lineItemNo%>
										<input type="hidden" name="tLineNumber" value="<%=lineItemNo%>" >
									    </Td>
									   <td>
										<input type="text" class="form-control garlic-auto-save validate[required]" id="contactName_<%=lineItemNo%>" name="contactName_<%=lineItemNo%>" value="<%=checkNull(retContDet.getFieldValueString(m,"ERCD_CONTACT_PERSON"))%>" maxlength="30">
									    </Td>
									     <td>
										<input type="text" class="form-control garlic-auto-save validate[required,custom[phone]]" onkeyup="validphone('contactPhone_<%=lineItemNo%>',<%=lineItemNo%>)" id="contactPhone_<%=lineItemNo%>" name="contactPhone_<%=lineItemNo%>" value="<%=checkNull(retContDet.getFieldValueString(m,"ERCD_PHONE_NO"))%>" maxlength="15"><span id="errmsg_<%=lineItemNo%>" style="color:red"></span>
									    </Td>
									     <td>
										<input type="text" class="form-control garlic-auto-save validate[required,custom[email]]" onkeyup="validemail('contactEmail_<%=lineItemNo%>',<%=lineItemNo%>)" id="contactEmail_<%=lineItemNo%>" name="contactEmail_<%=lineItemNo%>" value="<%=emailContact%>" maxlength="50"><span id="erremail_<%=lineItemNo%>" style="color:red"></span>
									    </Td>
									    <Td>
										<input type="text" class="form-control garlic-auto-save validate[required]" id="contactDesgtn_<%=lineItemNo%>" name="contactDesgtn_<%=lineItemNo%>" value="<%=checkNull(retContDet.getFieldValueString(m,"ERCD_DESIGNATION"))%>" maxlength="30">
									    </Td>
								</tr>
<%
							}
%>
								<input type="hidden" name="tLineNumberVal" id="tLineNumberVal" value="" >

							</table>
						</div>
					</div>
				</div>
			</div>
			<div class="row" id="tabContents">
				<!-- left column -->
				<div class="col-md-12">
					<div class="box box-primary">
						<div class="box-header with-border">
							<h3 class="box-title">Company Details</h3>
						</div>
						<div class="box-body">
							<table class="table table-bordered">
								<tr>
									    <th align="left">Country of Incorporation</th>
									    <td>
									<Select name="compCountry" id="compCountry" class="form-control garlic-auto-save select2" onchange="indRadio()">
									<option value="">--Select Country--</option>
<%
									Set set1 = cuntLHM.entrySet();
									Iterator i1 = set1.iterator();
									while(i1.hasNext()) 
									{
										Map.Entry me1 = (Map.Entry)i1.next();
										cntVal=(String)me1.getValue();
										chksel="";
										if(cntVal.equals(country))chksel="selected";
%>
								 <option value="<%=me1.getKey()%>" <%=chksel%> ><%=me1.getValue()%></option>
<%

									}
%>
								</select>								
								</Td>

								</tr>
								<tr>
									    <th align="left">Year of Incorporation</th>
									    <td>
									    	<Select name="compyear" id="compyear" class="form-control garlic-auto-save select2" >
<%
											//int year = Calendar.getInstance().get(Calendar.YEAR);

											for(int yr=year;yr>(year-60);yr--)
											{
%>
												<option value="<%=yr%>"><%=yr%></option>
<%
											}
%>
										</select>
									    </Td>

								</tr>
								<tr>
									    <th  style="text-align: center !important;">Is your company registered for Indian Tax in India</th>
									    <td>
									    									
										<div class="toggle_radio">
										    <input type="radio"  class="toggle_option" id="taxYes" name="taxReg" value="yes" <%if("yes".equals(taxReg))out.println("checked");%>>
										    <input type="radio" class="toggle_option" id="taxNo" name="taxReg" value="no" <%if("no".equals(taxReg) || "".equals(taxReg))out.println("checked");%>>
										    <label for="taxYes"><p>Yes</p></label>
										    <label for="taxNo"><p>No</p></label>
										    <div class="toggle_option_slider">
										    </div>
										</div>
									</Td>
								</tr>
								
							
								<tr>
									    <th align="left">If yes please provide the PAN No.</th>
									    <td>
										<input type="text" class="form-control garlic-auto-save" name="compPan" value="<%=checkNull(compPan)%>" maxlength="50">
									    </Td>

								</tr>
								<tr>
									    <th align="left">Please provide the Income Tax certificate No.</th>
									    <td>
										<input type="text" class="form-control garlic-auto-save" name="compTaxCertNo" value="<%=checkNull(compTaxCertNo)%>" maxlength="50">
									    </Td>

								</tr>
								<tr>
									    <th align="left">Please provide the MVAT / GST Registration No.</th>
									    <td>
										<input type="text" class="form-control garlic-auto-save" name="compCSTRegNo" value="<%=checkNull(compCSTRegNo)%>" maxlength="50" >
									    </Td>

								</tr>
								<tr>
									    <th align="left">Please provide the MVAT / GST Registration Date</th>
									    <td>
										<input type="text" class="form-control garlic-auto-save" name="compCSTRegDt" value="<%=checkNull(compCSTRegDt)%>"maxlength="50" >
									    </Td>

								</tr>
								<tr>
									    <th align="left">Please provide the SSI No.(if register)</th>
									    <td>
										<input type="text" class="form-control garlic-auto-save" name="compSSINo" value="<%=checkNull(compSSINo)%>" maxlength="50" >
									    </Td>

								</tr>
						<tr id="ind1" style="visibility:collapse;">
							<th align="left" >Select the Type of Organization<font color="red">*</font></th>
							<td >
							<div style="position:relative;left:-15px">
								<input type="radio" id="" name="typeOfOrg" value="" style="display:none" checked>&nbsp;<b><lable></lable></b> &nbsp;
								<input type="radio" id="propRd" name="typeOfOrg" value="prop" >&nbsp;<b><lable>Proprietary</lable></b> &nbsp;
								<input type="radio" id="partRd" name="typeOfOrg" value="partComp" >&nbsp;<b><lable>Partnership Company</lable></b>&nbsp;
								<input type="radio" id="pvtRd"  name="typeOfOrg" value="pvtComp" >&nbsp;<b><lable>Private Limited Company</lable></b>
								</div>
								

							<div class="row" style="position:relative;top:-5px;left:15px">
							 <br>
							 	
								<input type="radio" id="pubRd" name="typeOfOrg" value="PubComp" >&nbsp;<b><lable>Public Limited Company</lable></b>&nbsp;&nbsp;
								<input type="radio" style="position:relative;top:2px" id="othrRd" name="typeOfOrg" value="othr" >&nbsp;<b><lable style="position:relative;top:1px">Others</lable></b>
							</div>
							</Td>

						</tr>

						<tr id="ind2" style="visibility:collapse">
							<th align="left">Select the major activity under which your company is registered<font color="red">*</font></th>
						<td>
							
							<input type="radio" id="" name="compReg" value="" style="display:none" checked>
							<input type="radio" id="ServRd" name="compReg" value="Serv" >&nbsp;<b><lable>Services</lable></b>
							&nbsp; &nbsp;
							<input type="radio" id="ManfRd" name="compReg" value="Manf" >&nbsp;<b><lable>Manufacturing</lable></b>
						</Td>
						</tr>
						
						<tr id="ind3" style="visibility:collapse">
							<th align="left">Select the Type of Enterprise under which your company is registered<font color="red">*</font>  </th>
						<td>
							<input type="radio" id="" name="EntrprseCmpny"  value="" style="display:none" checked>
							<input type="radio" id="MicroRd" name="EntrprseCmpny" onClick="EntrprseCmpnyFun()" value="Micro">&nbsp;<b><lable>Micro</lable></b>
							&nbsp;
							<input type="radio" id="SmallRd" name="EntrprseCmpny" onClick="EntrprseCmpnyFun()" value="Small" >&nbsp;<b><lable>Small</lable></b>
							&nbsp;
							<input type="radio" id="MediumRd" name="EntrprseCmpny" onClick="EntrprseCmpnyFun()" value="Medium" >&nbsp;<b><lable>Medium</lable></b>
							&nbsp;
							<input type="radio" id="LargeRd" name="EntrprseCmpny" onClick="EntrprseCmpnyFun1()" value="Large" >&nbsp;<b><lable>Large</lable></b>
							&nbsp;
							<input type="radio" id="NotApRd" name="EntrprseCmpny" onClick="EntrprseCmpnyFun1()" value="notApp" >&nbsp;<b><lable>Not Applicable</lable></b>
						</Td>	
						</tr>
						
						<tr id="ind4" style="visibility:">
									<th align="left">Enter your MSME Registration Number <font color="red">*</font></th>
								<td>
									<input type="text" class="form-control garlic-auto-save " id="msmenum" name="msmeRegnNum" maxlength="20"  >
								</Td>
								</tr>
									<tr id="ind5" style="visibility:collapse">
									<th align="left">Upload MSME Certificate <font color="red">*</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<button type="button" id="uploadMSMEBtn" class="btn btn-primary" ><i class="fa fa-upload"></i>&nbsp;Upload</button></th>
								<td class="msmeFilePara" id="msmeFilePara" name="msmeFilePara" >
<%									
					Vector itemIndMsme=retUADet.where(new String[]{"EUD_DOC_TYPE"},new String[]{"MSMEDOC"});
					if("Y".equals(docRef))
					{
						if(itemIndMsme!=null)
						{
							for(int v1=0;v1<itemIndMsme.size();v1++)
							{	int index1 = -1;
								try{
								index1 = Integer.parseInt(itemIndMsme.get(v1)+"");	}
								catch(Exception e){}				
								if(index1>=0){
%>
											<input type="hidden" name="fileItem" value="<%=retUADet.getFieldValueString(index1,"EUD_FILE_NAME")%>" >
											<a href="javascript:downloadFile('O','<%=retUADet.getFieldValueString(index1,"EUD_ITEM_NO")%>','<%=retUADet.getFieldValueString(index1,"EUD_FILE_NAME")%>','<%=retUADet.getFieldValueString(index1,"EUD_DOC_TYPE")%>')"><%=retUADet.getFieldValueString(index1,"EUD_FILE_NAME")%></a>
									<%
											}
										}
									}
							}
									%>								
								</Td>
						</tr>				
						
								<tr>
								        <th align="left">Estimated number of employees</th>
									  <td>
										<input type="text" class="form-control garlic-auto-save" name="compEmplStr" value="<%=checkNull(compEmplStr)%>" maxlength="50" >
									  </Td>

								</tr>
								<tr>
									    <th align="left">Annual Turnover (in INR)</th>
									    <td>
										<input type="text" class="form-control garlic-auto-save" name="compAnualIncm" value="<%=checkNull(compAnualIncm)%>" maxlength="50" >
									    </Td>

								</tr>
								<tr>
									    <th align="left">Warehousing facilities in India</th>
									    <td>
										

										<div class="toggle_radio">
										    <input type="radio"  class="toggle_option" id="whYes" name="compWareHouse" value="yes" <%if("yes".equals(compWareHouse))out.println("checked");%>>
										    <input type="radio" class="toggle_option" id="whNo" name="compWareHouse" value="no"   <%if("no".equals(compWareHouse) || "".equals(compWareHouse))out.println("checked");%>>
										    <label for="whYes"><p>Yes</p></label>
										    <label for="whNo"><p>No</p></label>
										    <div class="toggle_option_slider">
										    </div>
  										</div>
									    </Td>

								</tr>
							</table>
						</div>
					</div>
				</div>
			</div>
			<div class="row" id="tabContents">
				<!-- left column -->
				<div class="col-md-12">
					<div class="box box-primary">
						<div class="box-header with-border">
							<h3 class="box-title">Affiliations</h3>
						</div>
						<div class="box-body">
							<table class="table table-bordered">
								<tr>
									<th align="left">Parent Company</th>
									    <td>
										<input type="text" class="form-control garlic-auto-save" name="parntCmpny" value="<%=checkNull(parntCmpny)%>"  maxlength="50" >
									    </Td>
								</tr>
								<tr>
									<th align="left">Parent Company City &amp; Country</th>
									    <td>
										<input type="text" class="form-control garlic-auto-save" name="parntCmpnyCity" value="<%=checkNull(parntCmpnyCity)%>"  maxlength="50">
									    </Td>
								</tr>
							</table>
						</div>
					</div>
				</div>
			</div>
			<div class="row" id="tabContents">
				<!-- left column -->
				<div class="col-md-12">
					<div class="box box-primary">
						<div class="box-header with-border">
							<h3 class="box-title">If your company has key affiliations(e.g. JV Partners,Tech Collaborations or suppliers)Please mention below</h3>
						</div>
						<div class="box-body">
							<table id="compTab" class="table table-bordered">
							<tr>

								    <th align="left"><b><a href="javascript:addLine('compTab')"><font color="red" >[+]</font></a></b>&nbsp;Sr No.</th>
								    <th align="left">Manufacturer Name</th>
								    <th align="left">Type of Relationship</th>
								    <th align="left">Country</th>
							</tr>
<%
						int numAff = 0;
						if("N".equals(vendFlag)&&  !"REAPP".equals(appFlag) && retAffDetCnt!=0)
							numAff = retAffDetCnt;
						else if("N".equals(vendFlag)&& "REAPP".equals(appFlag)&& retAffDetCnt==0)
							numAff = 1;
						else if("N".equals(vendFlag)&& "REAPP".equals(appFlag)&& retAffDetCnt!=0)
							numAff = retAffDetCnt;
							
						else
							numAff=1;
								
							for(int c=0;c<numAff;c++)
							{
								int compLineItemNo = (c+1); 
%>
							    <td align="center">
								<%=compLineItemNo%>
								<input type="hidden" name="cLineNumber" value="<%=compLineItemNo%>" >
							    </Td>
							    <td>
								<input type="text" class="form-control garlic-auto-save" id="afflCompName_<%=compLineItemNo%>" name="afflCompName_<%=compLineItemNo%>" value="<%=checkNull(retAffDet.getFieldValueString(c,"ERAD_AFFLCOMPNAME"))%>"  maxlength="50">
							    </Td>
							     <td>
								<input type="text" class="form-control garlic-auto-save" id="afflCompRelat_<%=compLineItemNo%>" name="afflCompRelat_<%=compLineItemNo%>" value="<%=checkNull(retAffDet.getFieldValueString(c,"ERAD_TYPEOFREL"))%>"  maxlength="50">
							    </Td>
							     <td>
								<Select name="affCompCunt_<%=compLineItemNo%>" id="affCompCunt_<%=compLineItemNo%>" class="form-control garlic-auto-save select2">
									<option value="">--Select Country--</option>
<%

									Set setAC = cuntLHM.entrySet();
									Iterator iAC = setAC.iterator();
									while(iAC.hasNext())
									{
										Map.Entry me = (Map.Entry)iAC.next();

										cntVal=(String)me.getValue();
										chksel="";
										if(cntVal.equals(retAffDet.getFieldValueString(c,"ERAD_AFFCOMPCUNT")))chksel="selected";		
%>
										<option value="<%=me.getKey()%>" <%=chksel%>><%=me.getValue()%></option>
<%

									}
%>
									</select>
							    </Td>
						</tr>
<%
					}
%>

<input type="hidden" name="cLineNumberVal" id="cLineNumberVal" value="" >
							</table>
						</div>
					</div>
				</div>
			</div>
			<div class="row" id="tabContents">
			<!-- left column -->
			<div class="col-md-12">
				<div class="box box-primary">
					<div class="box-header with-border">

						<h3 class="box-title">Executives/Partners/Owners</h3>
					</div>
					<div class="box-body">
						<table id="partTab" class="table table-bordered">
						<tr>

							    <th align="left"><b><a href="javascript:addLine('partTab')"><font color="red" >[+]</font></a></b>&nbsp;Sr No.</th>
							    <th align="left">Name</th>
							    <th align="left">Designation</th>
							    <th align="left">Phone No</th>
							    <th align="left">Mobile</th>
						</tr>
<%
						int numPartners = 0;
						if("N".equals(vendFlag)&& !"REAPP".equals(appFlag)&& retEpoDetCnt!=0)
							numPartners = retEpoDetCnt;
						else if("N".equals(vendFlag)&& "REAPP".equals(appFlag) && retEpoDetCnt==0)
						numPartners = 1;
						
						else if("N".equals(vendFlag)&& "REAPP".equals(appFlag) && retEpoDetCnt!=0)
						numPartners = retEpoDetCnt;
						
						else
							numPartners=1;
						for(int c=0;c<numPartners;c++)
						{
							int partLineItemNo = (c+1); 

%>
							<tr>
							
							    <td align="center">
								<%=partLineItemNo%>
								<input type="hidden" name="pLineNumber" value="<%=partLineItemNo%>" >
							    </Td>
							    <td>
								<input type="text" class="form-control garlic-auto-save" id="partName_<%=partLineItemNo%>" name="partName_<%=partLineItemNo%>" value="<%=checkNull(retEpoDet.getFieldValueString(c,"ERED_PART_NAME"))%>" maxlength="50">
							    </Td>
							     <td>
								<input type="text" class="form-control garlic-auto-save" id="partDesg_<%=partLineItemNo%>" name="partDesg_<%=partLineItemNo%>" value="<%=checkNull(retEpoDet.getFieldValueString(c,"ERED_PART_DESG"))%>" maxlength="50">
							    </Td>
							     <td>
								<input type="text" class="form-control garlic-auto-save" id="partPhNO_<%=partLineItemNo%>" name="partPhNO_<%=partLineItemNo%>" value="<%=checkNull(retEpoDet.getFieldValueString(c,"ERED_PART_PHO"))%>" maxlength="15">
							    </Td>
							     <td>
								<input type="text" class="form-control garlic-auto-save" id="partMob_<%=partLineItemNo%>" name="partMob_<%=partLineItemNo%>" value="<%=checkNull(retEpoDet.getFieldValueString(c,"ERED_PART_MOB"))%>" maxlength="15">
							    </Td>
															    
							</tr>
							
<%
						}
%>
							<input type="hidden" name="pLineNumberVal" id ="pLineNumberVal" value="" >

						</table>
					</div>
				</div>
			     </div>
			</div>
			<div class="row" id="tabContents">
				<!-- left column -->
				<div class="col-md-12">
					<div class="box box-primary">
						<div class="box-header with-border">
							<h3 class="box-title">References of your top customers</h3>
						</div>
						<div class="box-body">
							<table id="refTab" class="table table-bordered">
							<tr>

								    <th align="left"><b><a href="javascript:addLine('refTab')"><font color="red" >[+]</font></a></b>&nbsp;Sr No.</th>
								    <th align="left">Manufacturer Name</th>
								    <th align="left">Country</th>
								    <th align="left">Material Supplied</th>
								    <th align="left">Year</th>
								    <th align="left">Reference Name</th>
								    <th align="left">Reference Contact (email / telephone )</th>
							</tr>
<%
						int numRefs = 0;
						if("N".equals(vendFlag)&& !"REAPP".equals(appFlag)&& retCusRefDetCnt!=0)
							numRefs = retCusRefDetCnt;
						else if("N".equals(vendFlag)&& "REAPP".equals(appFlag)&& retCusRefDetCnt==0 )
						numRefs = 1;
						
						else if("N".equals(vendFlag)&& !"REAPP".equals(appFlag)&& retCusRefDetCnt!=0)
						numRefs = retCusRefDetCnt;
						
						else
							numRefs=1;
							for(int r=0;r<numRefs;r++)
							{
								int refLineItemNo = (r+1); 

%>
								<tr>

									    <td align="center">
										<%=refLineItemNo%>
										<input type="hidden" name="rLineNumber" value="<%=refLineItemNo%>" >
									    </Td>
									    <td>
										<input type="text" class="form-control garlic-auto-save" id="refCompName_<%=refLineItemNo%>" name="refCompName_<%=refLineItemNo%>" value="<%=checkNull(retCusRefDet.getFieldValueString(r,"ERCD_REFCOMPNAME"))%>"  maxlength="30" >
									    </Td>

									     <td>
										<Select name="refCompCunt_<%=refLineItemNo%>" id="refCompCunt_<%=refLineItemNo%>" class="form-control garlic-auto-save select2" >
											<option value="">--Select Country--</option>
<%

											Set setRC = cuntLHM.entrySet();
											Iterator iRC = setRC.iterator();
											while(iRC.hasNext())
											{
												Map.Entry me = (Map.Entry)iRC.next();
												cntVal=(String)me.getValue();
												chksel="";
												if(cntVal.equals(checkNull(retCusRefDet.getFieldValueString(r,"ERCD_REFCOMPCUNT"))))chksel="selected";
%>
												<option value="<%=me.getKey()%>" <%=chksel%>><%=me.getValue()%></option>
<%

											}
%>
											</select>
									    </Td>
									    <td>
										<input type="text" class="form-control garlic-auto-save" id="refCompMatSup_<%=refLineItemNo%>" name="refCompMatSup_<%=refLineItemNo%>" value="<%=checkNull(retCusRefDet.getFieldValueString(r,"ERCD_REFCOMPMATSUP"))%>"  maxlength="40" >
									    </Td>
									     <td>
										<Select name="refCompyear_<%=refLineItemNo%>" id="refCompyear_<%=refLineItemNo%>" class="form-control garlic-auto-save select2" >
<%

											for(int refCompYr=year;refCompYr>(year-50);refCompYr--)
											{
											yea=refCompYr+"";
											sel="";
											if(yea.equals(retCusRefDet.getFieldValueString(r,"ERCD_REFCOMPYEAR")))sel="selected";

%>
												<option value="<%=refCompYr%>" <%=sel%>><%=refCompYr%></option>
<%
											}
%>
										</select>
									    </Td>
									    <td>
										<input type="text" class="form-control garlic-auto-save" id="refName_<%=refLineItemNo%>" name="refName_<%=refLineItemNo%>" value="<%=checkNull(retCusRefDet.getFieldValueString(r,"ERCD_REFNAME"))%>"  maxlength="40" >
									    </Td>
									    <td>
										<input type="text" class="form-control garlic-auto-save" id="refCont_<%=refLineItemNo%>" name="refCont_<%=refLineItemNo%>" value="<%=checkNull(retCusRefDet.getFieldValueString(r,"ERCD_REFCONT"))%>"  maxlength="20" >
									    </Td>
								</tr>
<%
							}
%>
							<input type="hidden" name="rLineNumberVal" id="rLineNumberVal" value="" >

							</table>
						</div>
					</div>
				</div>
			</div>
			<div class="row" id="tabContents">
				<!-- left column -->
				<div class="col-md-12">
					<div class="box box-primary">
						<div class="box-header with-border">
							<h3 class="box-title">Comments</h3>
						</div>
						<div class="box-body">
	   					 <textarea  maxlength="200" name="comments" placeholder="If you have any other information, please include them here..." rows="5" style="width:100%;"><%=comments%></textarea> 
	   					</div>
					</div>
				</div>
			</div>
			<div class="row" id="tabContents">
				<!-- left column -->
				<div class="col-md-12">
					<div class="box box-primary">
						<div class="box-header with-border">
							<h3 class="box-title">Agents in India</h3>
						</div>
						<div class="box-body">
							<table class="table table-bordered">
								<tr>
								    <th align="left">Name</th>
								    <td>
									<input type="text" class="form-control garlic-auto-save" name="agtName" value="<%=checkNull(agtName)%>" maxlength="50" >
								    </Td>
								    <th align="left">Contact</th>
								    <td>
									<input type="text" class="form-control garlic-auto-save" name="agtContact" value="<%=checkNull(agtContact)%>" maxlength="50">
								    </Td>
								</tr>
								
							</table>
						</div>
					</div>
				</div>
			</div>

		  </div>
		  <div id="tabs-2" >
		  <input type="hidden" name="tabVal2" id="tabVal2" value="" >
			<table class="table table-bordered">
				<Tr>
					<Th align="left">Manufacturer Name</Th>
					<Td>
						<input type="text" class="form-control garlic-auto-save"   name="compNamePlant"  value="<%=checkNull(compNamePlant)%>" maxlength="100">
					</Td>  

				</Tr>
		    	</table>
		    	<div class="row" id="tabContents">
			<!-- left column -->
			<div class="col-md-12">
				<div class="box box-primary">
					<div class="box-header with-border">
						<h3 class="box-title">Contacts</h3>
					</div>
					<div class="box-body">
					<p> <font color="red" >Note:</font> Vendor code is optional, only existing vendors need to put it.</p>
					<table id="plantTab" class="table table-bordered">
						<tr>
							    
							    <th align="left"><b><a href="javascript:addLine('plantTab')"><font color="red" >[+]Add Line</font></a></b>&nbsp;Sr No.</th>
							    <th align="left"></th>
							    <th align="left">Plant Name</th>
							    <th align="left">Address</th>
							    <th align="left">Vendor Code</th>
							    <th align="left">Annual Capacity</th>
							    <th align="left">Utilization %</th>
							    <th align="left">Production Range</th>
						</tr>
<%
				
				int plantCnt = 0;
						if("N".equals(vendFlag))
							plantCnt = retPlantDetCnt;
						if("N".equals(vendFlag)&& "REAPP".equals(appFlag)&& retContDetCnt==0)
							plantCnt = 2;
						if("N".equals(vendFlag)&& "REAPP".equals(appFlag)&& retContDetCnt!=0)
						plantCnt = retPlantDetCnt;
						
						else
							plantCnt=retPlantDetCnt;
							
				int defaultPlantInt = 0;
				if(defaultPlant!=null && !"null".equals(defaultPlant) && !"".equals(defaultPlant))
					defaultPlantInt = Integer.parseInt(defaultPlant);
					String checkedPlant="";
					for(int m=0;m<plantCnt;m++)
					{
						int lineItemNo = (m+1); 
						if(defaultPlantInt==lineItemNo)
							checkedPlant="checked";
						else
							checkedPlant = "";
%>
						<tr>

							    <td align="center">
								<%=lineItemNo%>
								<input type="hidden" name="ptLineNumber" value="<%=lineItemNo%>" >
							    </Td>
							    <td> 
							    	<div class="custom-control custom-radio"><input type="radio"  class="custom-control-input" id="customRadio_<%=lineItemNo%>" name="example1" value="<%=lineItemNo%>" <%=checkedPlant%>></div>
							    </td>
							    <td>
								<input type="text" class="form-control garlic-auto-save" id="plantName_<%=lineItemNo%>" name="plantName_<%=lineItemNo%>" value="<%=checkNull(retPlantDet.getFieldValueString(m,"ERPD_PLANTNAME"))%>"  maxlength="30"  >
							    </Td>
							     <td>
								<input type="text" class="form-control garlic-auto-save" id="plantPlace_<%=lineItemNo%>" name="plantPlace_<%=lineItemNo%>" value="<%=checkNull(retPlantDet.getFieldValueString(m,"ERPD_PLANTPLACE"))%>"  maxlength="100" >
							    </Td>
							     <td>
								<input type="text" class="form-control garlic-auto-save" id="vendorCode_<%=lineItemNo%>" name="vendorCode_<%=lineItemNo%>" value="<%=checkNull(retPlantDet.getFieldValueString(m,"ERPD_VENDORCODE"))%>"   maxlength="25">
							    </Td>
							     <td>
								<input type="text" class="form-control garlic-auto-save" id="capacity_<%=lineItemNo%>" name="capacity_<%=lineItemNo%>" value="<%=checkNull(retPlantDet.getFieldValueString(m,"ERPD_CAPACITY"))%>"  maxlength="50">
							    </Td>
							     <td>
								<input type="text" class="form-control garlic-auto-save" id="utilPer_<%=lineItemNo%>" name="utilPer_<%=lineItemNo%>" value="<%=checkNull(retPlantDet.getFieldValueString(m,"ERPD_UTIL_PER"))%>"   maxlength="50">
							    </Td>
							     <td>
								<input type="text" class="form-control garlic-auto-save" id="prodRang_<%=lineItemNo%>" name="prodRang_<%=lineItemNo%>" value="<%=checkNull(retPlantDet.getFieldValueString(m,"ERPD_PROD_RAN"))%>"   maxlength="100">
							    </Td>
						</tr>
<%
					}
%>
							<input type="hidden" name="ptLineNumberVal" id="ptLineNumberVal" value="" >
						</table>
					</div>
				</div>
			</div>
		</div>    
		  </div>
		  <div id="tabs-3">
		  <input type="hidden" name="tabVal3" id="tabVal3" value="" >
		   	<table class="table table-bordered">
				<Tr>
					<Th align="left">Manufacturer Name</Th>
					<Td>
						<input type="text" class="form-control garlic-auto-save"   name="compNamePrdSerDet" value="<%=checkNull(compNamePrdSerDet)%>" maxlength="100">
						
					</Td>

				</Tr>
		    	</table>
		    	<div class="row" id="tabContents">
			<!-- left column -->
			   <div class="col-md-12">
				<div class="box box-primary">
					<div class="box-header with-border">

						<h3 class="box-title">Functional area(Please check which may best apply)</h3>
					</div>
					<div class="box-body">
						<p class="text-center">
					                    <strong>Products Offered</strong>
					        </p>
						<div class="funkyradio">
							<div class="row">
								<div class="col-md-3">
																	
									<%for(int h=1;h<=9;h++){
									 key=h+"";  
									// out.println("key123"+key+prodOffChkFromDBHT.contains(key));
									if(prodOffChkFromDBHT.contains(key))checked="checked";
									else 	
										checked="";
									 %><div class="funkyradio-success" style="">
									    <input type="checkbox" name="prodOffChk" id="<%=h%>" value="<%=prodDetHT.get(key)%>" <%=checked%>/>
									    <label for="<%=h%>"><%=prodDetHT.get(key)%></label>
									    </div>
									<%}%>    



								</div>
								<div class="col-md-3">

									<%for(int h=10;h<=18;h++){
									 key=h+"";
									 if(prodOffChkFromDBHT.contains(key))checked="checked";
									 else 	
										checked="";
									 %>
									 <div class="funkyradio-success" style="">
									    <input type="checkbox" name="prodOffChk" id="<%=h%>" value="<%=prodDetHT.get(key)%>" <%=checked%>/>
									    <label for="<%=h%>"><%=prodDetHT.get(key)%></label>
									  </div>  
									   <%}%>     


								</div>
								<div class="col-md-3">

									<%for(int h=19;h<=27;h++){
									key=h+"";
									if(prodOffChkFromDBHT.contains(key))checked="checked";
									else 	
										checked="";
									%><div class="funkyradio-success" style="">
									    <input type="checkbox" name="prodOffChk" id="<%=h%>" value="<%=prodDetHT.get(key)%>" <%=checked%>/>
									    <label for="<%=h%>"><%=prodDetHT.get(key)%></label>
									    </div>
									   <%}%>   


								</div>
								<div class="col-md-3">

									<%for(int h=28;h<=36;h++){
									key=h+"";
									if(prodOffChkFromDBHT.contains(key))checked="checked";
									else 	
										checked="";
									%><div class="funkyradio-success" style="">
									    <input type="checkbox" name="prodOffChk" id="<%=h%>" value="<%=prodDetHT.get(key)%>" <%=checked%>/>
									    <label for="<%=h%>"><%=prodDetHT.get(key)%></label>
									    </div>
									    <%}%>   
								</div>
						        </div>
    						</div>
				   	</div>
				</div>
			    </div>
			</div>
		  </div>
<%
	String displayStyle = "";
	if("REAPP".equals(appFlag))
		displayStyle = "style=\"display:none\"";
%>
		   <div id="tabs-4" <%=displayStyle%>>
		   <input type="hidden" name="tabVal4" id="tabVal4" value="" >
			<table class="table table-bordered">
				<Tr>
					<Th align="left">Manufacturer Name</Th>
					<Td>
						<input type="text" class="form-control garlic-auto-save"   name="compNamePPAPDet"  value = "<%=checkNull(compNamePrdSerDet)%>" maxlength="100">
					</Td>

				</Tr>
			</table>
			<div class="row" id="tabContents">
			<!-- left column -->
			   <div class="col-md-12">
				<div class="box box-primary">
					<div class="box-body">
						<table class="table table-bordered" <%=displayStyle%>>
							<tr>
								<th align="left" colspan="3">PPAP Submission is an essential step in our Supplier/RM approval process. Following documents would be required under PPAP before start of Bulk Trials. Kindly confirm whether you would be able to submit these documents or not.</th>
														
							</tr>
							<tr>
								<td style="width:5%;">1</td>
								<th align="left"><font color='orange'>Part Submission Warrant (PSW)</font>	</th>
								<td>

									<div class="toggle_radio">
									    <input type="radio"  class="toggle_option" id="qmsYes1" name="partSubWarrant" value="yes" <%if("yes".equals(partSubWarrant))out.println("checked");%>>
									    <input type="radio" class="toggle_option" id="qmsNo1"  name="partSubWarrant" value="no" <%if("no".equals(partSubWarrant) || "".equals(partSubWarrant))out.println("checked");%>>
									    <label for="qmsYes1"><p>Yes</p></label>
									    <label for="qmsNo1"><p>No</p></label>
									    <div class="toggle_option_slider">
									    </div>
									</div>
								</Td>

							</tr>
							<tr>
								<td style="width:5%;">2</td>
								<th align="left"><font color='orange'>Test Results (All test parameters  mentioned in CEAT Specification.)</font></th>
								<td>

									<div class="toggle_radio">
									    <input type="radio"  class="toggle_option" id="qmsYes2" name="testRes" value="yes" <%if("yes".equals(testRes))out.println("checked");%>>
									    <input type="radio" class="toggle_option" id="qmsNo2"  name="testRes" value="no"  <%if("no".equals(testRes) || "".equals(testRes))out.println("checked");%>>
									    <label for="qmsYes2"><p>Yes</p></label>
									    <label for="qmsNo2"><p>No</p></label>
									    <div class="toggle_option_slider">
									    </div>
									</div>
								</Td>

							</tr>
							<tr>
								<td style="width:5%;">3</td>
								<th align="left">Appearance Approval Report (AAR) If applicable</th>
								<td>

									<div class="toggle_radio">
									    <input type="radio" class="toggle_option" id="qmsYes4" name="appeApprRep" value="yes" 	<%if("yes".equals(appeApprRep))out.println("checked");%>>
									    <input type="radio" class="toggle_option" id="qmsNo4" name="appeApprRep"  value="no" <%if("no".equals(appeApprRep) || "".equals(appeApprRep))out.println("checked");%>>
									    <label for="qmsYes4"><p>Yes</p></label>
									    <label for="qmsNo4"><p>No</p></label>
									    <div class="toggle_option_slider">
									    </div>
									</div>
								</Td>

							</tr>
							<tr>
								<td style="width:5%;">4</td>
								<th align="left">Product Sample</th>
								<td>

									<div class="toggle_radio">
									    <input type="radio"  class="toggle_option" id="qmsYes5" name="prodSample" value="yes"      <%if("yes".equals(prodSample))out.println("checked");%>>
									    <input type="radio"  class="toggle_option" id="qmsNo5" name="prodSample" value="no" <%if("no".equals(prodSample) || "".equals(prodSample))out.println("checked");%>>
									    <label for="qmsYes5"><p>Yes</p></label>
									    <label for="qmsNo5"><p>No</p></label>
									    <div class="toggle_option_slider">
									    </div>
									</div>
								</Td>

							</tr>
							<tr>
								<td style="width:5%;">5</td>
								<th align="left"><font color='orange'>Special Process Characteristics/ Declaration</font></th>
								<td>

									<div class="toggle_radio">
									    <input type="radio"  class="toggle_option" id="qmsYes6" name="splProcessChar" value="yes"	    <%if("yes".equals(splProcessChar))out.println("checked");%>>		
									    <input type="radio"  class="toggle_option" id="qmsNo6" name="splProcessChar" value="no"  <%if("no".equals(splProcessChar) || "".equals(splProcessChar))out.println("checked");%>>
									    <label for="qmsYes6"><p>Yes</p></label>
									    <label for="qmsNo6"><p>No</p></label>
									    <div class="toggle_option_slider">
									    </div>
									</div>
								</Td>

							</tr>
							<tr>
								<td style="width:5%;">6</td>
								<th align="left">Engineering Change Documents (if any)</th>
								<td>

									<div class="toggle_radio">
									    <input type="radio"  class="toggle_option" id="qmsYes7" name="enggChangeDoc" value="yes"	<%if("yes".equals(enggChangeDoc))out.println("checked");%>>			
									    <input type="radio"  class="toggle_option" id="qmsNo7" name="enggChangeDoc" value="no" 	<%if("no".equals(enggChangeDoc) || "".equals(enggChangeDoc))out.println("checked");%>>
									    <label for="qmsYes7"><p>Yes</p></label>
									    <label for="qmsNo7"><p>No</p></label>
									    <div class="toggle_option_slider">
									    </div>
									</div>
								</Td>

							</tr>
							<tr>
								<td style="width:5%;">7</td>
								<th align="left">Process Failure Mode & Effect Analysis (PFMEA)</th>
								<td>

									<div class="toggle_radio">
									    <input type="radio"  class="toggle_option" id="qmsYes8" name="procFailure" value="yes" <%if("yes".equals(procFailure))out.println("checked");%>>
									    <input type="radio"  class="toggle_option" id="qmsNo8" name="procFailure" value="no" <%if("no".equals(procFailure) || "".equals(procFailure))out.println("checked");%>>
									    <label for="qmsYes8"><p>Yes</p></label>
									    <label for="qmsNo8"><p>No</p></label>
									    <div class="toggle_option_slider">
									    </div>
									</div>
								</Td>

							</tr>
							<tr>
								<td style="width:5%;">8</td>
								<th align="left">Design Failure Mode & Effect Analysis (DFMEA)</th>
								<td>

									<div class="toggle_radio">
									    <input type="radio"  class="toggle_option" id="qmsYes9" name="DFMEA" value="yes" <%if("yes".equals(DFMEA))out.println("checked");%>>
									    <input type="radio"  class="toggle_option" id="qmsNo9" name="DFMEA" value="no" <%if("no".equals(DFMEA) || "".equals(DFMEA))out.println("checked");%>>
									    <label for="qmsYes9"><p>Yes</p></label>
									    <label for="qmsNo9"><p>No</p></label>
									    <div class="toggle_option_slider">
									    </div>
									</div>
								</Td>

							</tr>
							<tr>
								<td style="width:5%;">9</td>
								<th align="left"><font color='orange'>Initial Process Study</font></th>
								<td>

									<div class="toggle_radio">
									    <input type="radio"  class="toggle_option" id="qmsYes10" name="intProcStudy" value="yes"  <%if("yes".equals(intProcStudy))out.println("checked");%>>
									    <input type="radio"  class="toggle_option" id="qmsNo10" name="intProcStudy" value="no" <%if("no".equals(intProcStudy) || "".equals(intProcStudy))out.println("checked");%>>
									    <label for="qmsYes10"><p>Yes</p></label>
									    <label for="qmsNo10"><p>No</p></label>
									    <div class="toggle_option_slider">
									    </div>
									</div>
								</Td>

							</tr>
							<tr>
								<td style="width:5%;">10</td>
								<th align="left">Measurement System Analysis Studies (If required)</th>
								<td>

									<div class="toggle_radio">
									    <input type="radio"  class="toggle_option" id="qmsYes3" name="mesSysAna" value="yes" <%if("yes".equals(mesSysAna))out.println("checked");%>>
									    <input type="radio" class="toggle_option" id="qmsNo3"  name="mesSysAna" value="no" <%if("no".equals(mesSysAna) || "".equals(mesSysAna))out.println("checked");%>>
									    <label for="qmsYes3"><p>Yes</p></label>
									    <label for="qmsNo3"><p>No</p></label>
									    <div class="toggle_option_slider">
									    </div>
									</div>
								</Td>

							</tr>							
							<tr>
								<td style="width:5%;">11</td>	
								<th align="left"><font color='orange'>Packing Standard/Requirements</font></th>
								<td>

									<div class="toggle_radio">
									    <input type="radio"  class="toggle_option" id="qmsYes12" name="packStndrd" value="yes" <%if("yes".equals(packStndrd))out.println("checked");%>>
									    <input type="radio"  class="toggle_option" id="qmsNo12" name="packStndrd" value="no" <%if("no".equals(packStndrd) || "".equals(packStndrd))out.println("checked");%>>
									    <label for="qmsYes12"><p>Yes</p></label>
									    <label for="qmsNo12"><p>No</p></label>
									    <div class="toggle_option_slider">
									    </div>
									</div>
								</Td>

							</tr><tr>
								<td style="width:5%;">12</td>
								<th align="left">Process qualification for Special Processes?	</th>
								<td>

									<div class="toggle_radio">
									    <input type="radio"  class="toggle_option" id="qmsYes13" name="procQualf" value="yes" <%if("yes".equals(procQualf))out.println("checked");%>>
									    <input type="radio"  class="toggle_option" id="qmsNo13" name="procQualf" value="no" <%if("no".equals(procQualf) || "".equals(procQualf))out.println("checked");%>>
									    <label for="qmsYes13"><p>Yes</p></label>
									    <label for="qmsNo13"><p>No</p></label>
									    <div class="toggle_option_slider">
									    </div>
									</div>
								</Td>

							</tr><tr>
								<td style="width:5%;">13</td>
								<th align="left"><font color='orange'>Valid Copy of the Quality Management System (ISO/IATF certificate)</font></th>
								<td>

									<div class="toggle_radio">
									    <input type="radio"  class="toggle_option" id="qmsYes14" name="quaManagSys" value="yes" <%if("yes".equals(quaManagSys))out.println("checked");%>>
									    <input type="radio"  class="toggle_option" id="qmsNo14" name="quaManagSys" value="no" <%if("no".equals(quaManagSys) || "".equals(quaManagSys))out.println("checked");%>>
									    <label for="qmsYes14"><p>Yes</p></label>
									    <label for="qmsNo14"><p>No</p></label>
									    <div class="toggle_option_slider">
									    </div>
									</div>
								</Td>

							</tr><tr>
								<td style="width:5%;">14</td>
								<th align="left">RM, Bought out parts & subcontracted process details</th>
								<td>

									<div class="toggle_radio">
									    <input type="radio"  class="toggle_option" id="qmsYes15" name="subcontracted" value="yes" <%if("yes".equals(subcontracted))out.println("checked");%>>
									    <input type="radio"  class="toggle_option" id="qmsNo15" name="subcontracted" value="no" <%if("no".equals(subcontracted) || "".equals(subcontracted))out.println("checked");%>>
									    <label for="qmsYes15"><p>Yes</p></label>
									    <label for="qmsNo15"><p>No</p></label>
									    <div class="toggle_option_slider">
									    </div>
									</div>
								</Td>

							</tr><tr>
								<td style="width:5%;">15</td>
								<th align="left">COA Sample</th>
								<td>

									<div class="toggle_radio">
									    <input type="radio"  class="toggle_option" id="qmsYes16" name="coa" value="yes" <%if("yes".equals(coa))out.println("checked");%>>
									    <input type="radio"  class="toggle_option" id="qmsNo16" name="coa" value="no" <%if("no".equals(coa) || "".equals(coa))out.println("checked");%>>
									    <label for="qmsYes16"><p>Yes</p></label>
									    <label for="qmsNo16"><p>No</p></label>
									    <div class="toggle_option_slider">
									    </div>
									</div>
								</Td>

							</tr><tr>
								<td style="width:5%;">16</td>
								<th align="left">Checking Aids</th>
								<td>

									<div class="toggle_radio">
									    <input type="radio"  class="toggle_option" id="qmsYes17" name="chkAids" value="yes" <%if("yes".equals(chkAids))out.println("checked");%>>
									    <input type="radio"  class="toggle_option" id="qmsNo17" name="chkAids" value="no" <%if("no".equals(chkAids) || "".equals(chkAids))out.println("checked");%>>
									    <label for="qmsYes17"><p>Yes</p></label>
									    <label for="qmsNo17"><p>No</p></label>
									    <div class="toggle_option_slider">
									    </div>
									</div>
								</Td>

							</tr><tr>
								<td style="width:5%;">17</td>
								<th align="left">Material, Performance Test Results</th>
								<td>

									<div class="toggle_radio">
									    <input type="radio"  class="toggle_option" id="qmsYes18" name="ptr" value="yes" <%if("yes".equals(ptr))out.println("checked");%>>
									    <input type="radio"  class="toggle_option" id="qmsNo18" name="ptr" value="no" <%if("no".equals(ptr) || "".equals(ptr))out.println("checked");%>>
									    <label for="qmsYes18"><p>Yes</p></label>
									    <label for="qmsNo18"><p>No</p></label>
									    <div class="toggle_option_slider">
									    </div>
									</div>
								</Td>

							</tr><tr>
								<td style="width:5%;">18</td>
								<th align="left">Main PFD & Sub Process Flow Diagrams (Index Sheet)</th>
								<td>

									<div class="toggle_radio">
									    <input type="radio"  class="toggle_option" id="qmsYes19" name="subProcFDia" value="yes" <%if("yes".equals(subProcFDia))out.println("checked");%>>
									    <input type="radio"  class="toggle_option" id="qmsNo19" name="subProcFDia" value="no" <%if("no".equals(subProcFDia) || "".equals(subProcFDia))out.println("checked");%>>
									    <label for="qmsYes19"><p>Yes</p></label>
									    <label for="qmsNo19"><p>No</p></label>
									    <div class="toggle_option_slider">
									    </div>
									</div>
								</Td>

							</tr><tr>
								<td style="width:5%;">19</td>
								<th align="left"><font color='orange'>Process Control Plan / Declaration</font>	</th>
								<td>

									<div class="toggle_radio">
									    <input type="radio"  class="toggle_option" id="qmsYes20" name="procCtrlplan" value="yes" <%if("yes".equals(procCtrlplan))out.println("checked");%>>
									    <input type="radio"  class="toggle_option" id="qmsNo20" name="procCtrlplan" value="no" <%if("no".equals(procCtrlplan) || "".equals(procCtrlplan))out.println("checked");%>>
									    <label for="qmsYes20"><p>Yes</p></label>
									    <label for="qmsNo20"><p>No</p></label>
									    <div class="toggle_option_slider">
									    </div>
									</div>
								</Td>

							</tr><tr>
								<td style="width:5%;">20</td>
								<th align="left">Standard Operating Procedures (Index Sheet)</th>
								<td>

									<div class="toggle_radio">
									    <input type="radio" class="toggle_option validate[required]" id="qmsYes21" name="stdOpeProc" value="yes" <%if("yes".equals(stdOpeProc))out.println("checked");%>>
									    <input type="radio"  class="toggle_option" id="qmsNo21" name="stdOpeProc" value="no" <%if("no".equals(stdOpeProc) || "".equals(stdOpeProc))out.println("checked");%>>
									    <label for="qmsYes21"><p>Yes</p></label>
									    <label for="qmsNo21"><p>No</p></label>
									    <div class="toggle_option_slider">
									    </div>
									</div>
								</Td>

							</tr><tr>
								<td style="width:5%;">21</td>
								<th align="left">Customer Engineering Approval</th>
								<td>

									<div class="toggle_radio">
									    <input type="radio"  class="toggle_option" id="qmsYes22" name="custEnggApp" value="yes" <%if("yes".equals(custEnggApp))out.println("checked");%>>
									    <input type="radio"  class="toggle_option" id="qmsNo22" name="custEnggApp" value="no" <%if("no".equals(custEnggApp) || "".equals(custEnggApp))out.println("checked");%>>
									    <label for="qmsYes22"><p>Yes</p></label>
									    <label for="qmsNo22"><p>No</p></label>
									    <div class="toggle_option_slider">
									    </div>
									</div>
								</Td>

							</tr>
							<tr>
								<td style="width:5%;">22</td>
								<th align="left">Qualified Laboratory documentation/Testing Equipment list/Tests</th>
								<td>

									<div class="toggle_radio">
									    <input type="radio"  class="toggle_option" id="qmsYes23" name="quaLabDoc" value="yes" <%if("yes".equals(quaLabDoc))out.println("checked");%>>
									    <input type="radio"  class="toggle_option" id="qmsNo23" name="quaLabDoc" value="no" <%if("no".equals(quaLabDoc) || "".equals(quaLabDoc))out.println("checked");%>>
									    <label for="qmsYes23"><p>Yes</p></label>
									    <label for="qmsNo23"><p>No</p></label>
									    <div class="toggle_option_slider">
									    </div>
									</div>
								</Td>

							</tr>
							<tr>
								<td style="width:5%;">23</td>
								<th align="left">Plant Machinery List</th>
								<td>

									<div class="toggle_radio">
									    <input type="radio"  class="toggle_option" id="qmsYes24" name="plantMacLt" value="yes" <%if("yes".equals(plantMacLt))out.println("checked");%>>
									    <input type="radio"  class="toggle_option" id="qmsNo24" name="plantMacLt" value="no" <%if("no".equals(plantMacLt) || "".equals(plantMacLt))out.println("checked");%>>
									    <label for="qmsYes24"><p>Yes</p></label>
									    <label for="qmsNo24"><p>No</p></label>
									    <div class="toggle_option_slider">
									    </div>
									</div>
								</Td>

							</tr><tr>
								<td style="width:5%;">24</td>
								<th align="left"><font color='orange'>Quality Agreement</font>	</th>
								<td>

									<div class="toggle_radio">
									    <input type="radio"  class="toggle_option" id="qmsYes25" name="quaAggr" value="yes" <%if("yes".equals(quaAggr))out.println("checked");%>>
									    <input type="radio"  class="toggle_option" id="qmsNo25" name="quaAggr" value="no" <%if("no".equals(quaAggr) || "".equals(quaAggr))out.println("checked");%>>
									    <label for="qmsYes25"><p>Yes</p></label>
									    <label for="qmsNo25"><p>No</p></label>
									    <div class="toggle_option_slider">
									    </div>
									</div>
								</Td>

							</tr><tr>
								<td style="width:5%;">25</td>
								<th align="left">Organization chart</th>
								<td>  

									<div class="toggle_radio">
									    <input type="radio"  class="toggle_option" id="qmsYes26" name="oc" value="yes" <%if("yes".equals(oc))out.println("checked");%>>
									    <input type="radio"  class="toggle_option" id="qmsNo26" name="oc" value="no" <%if("no".equals(oc) || "".equals(oc))out.println("checked");%>>
									    <label for="qmsYes26"><p>Yes</p></label>
									    <label for="qmsNo26"><p>No</p></label>
									    <div class="toggle_option_slider">
									    </div>
									</div>
								</Td>

							</tr><tr>
								<td style="width:5%;">26</td>
								<th align="left"><font color='orange'>Calibration list</font>	</th>
								<td>

									<div class="toggle_radio">
									    <input type="radio"  class="toggle_option" id="qmsYes27" name="calList" value="yes" <%if("yes".equals(calList))out.println("checked");%>>
									    <input type="radio"  class="toggle_option" id="qmsNo27" name="calList" value="no" <%if("no".equals(calList) || "".equals(calList))out.println("checked");%>>
									    <label for="qmsYes27"><p>Yes</p></label>
									    <label for="qmsNo27"><p>No</p></label>
									    <div class="toggle_option_slider">
									    </div>
									</div>
								</Td>

							</tr><tr>
								<td style="width:5%;">27</td>
								<th align="left">Design Record	</th>
								<td>

									<div class="toggle_radio">
									    <input type="radio"  class="toggle_option" id="qmsYes28" name="desRec" value="yes"  <%if("yes".equals(desRec))out.println("checked");%>>
									    <input type="radio"  class="toggle_option" id="qmsNo28" name="desRec" value="no" <%if("no".equals(desRec) || "".equals(desRec))out.println("checked");%>>
									    <label for="qmsYes28"><p>Yes</p></label>
									    <label for="qmsNo28"><p>No</p></label>
									    <div class="toggle_option_slider">
									    </div>
									</div>
								</Td>

							</tr><tr>
								<td style="width:5%;">28</td>
								<th align="left">Dimensional Results</th>
								<td>

									<div class="toggle_radio"> 
									    <input type="radio"  class="toggle_option" id="qmsYes29" name="Dimensional" value="yes"  <%if("yes".equals(Dimensional))out.println("checked");%>>
									    <input type="radio"  class="toggle_option" id="qmsNo29" name="Dimensional" value="no" <%if("no".equals(Dimensional) || "".equals(Dimensional))out.println("checked");%>>
									    <label for="qmsYes29"><p>Yes</p></label>
									    <label for="qmsNo29"><p>No</p></label>
									    <div class="toggle_option_slider">
									    </div>
									</div>
								</Td>

							</tr><tr>
								<td style="width:5%;">29</td>
								<th align="left">Master Sample</th>
								<td>

									<div class="toggle_radio">
									    <input type="radio"  class="toggle_option" id="qmsYes30" name="mstrSam" value="yes" <%if("yes".equals(mstrSam))out.println("checked");%>>
									    <input type="radio"  class="toggle_option" id="qmsNo30" name="mstrSam" value="no" <%if("no".equals(mstrSam) || "".equals(mstrSam))out.println("checked");%>>
									    <label for="qmsYes30"><p>Yes</p></label>
									    <label for="qmsNo30"><p>No</p></label>
									    <div class="toggle_option_slider">
									    </div>
									</div>
								</Td>

							</tr>

						</table>
					</div>
				</div>
			   </div>
			   
			</div>
		  </div>

		  <div id="tabs-5">
		  <input type="hidden" name="tabVal5" id="tabVal5" value="" >
		  	<table class="table table-bordered">
				<Tr>
					<Th align="left">Manufacturer Name</Th>
					<Td>
						<input type="text" class="form-control garlic-auto-save"   name="compNameQtyCertDet"  value = "<%=checkNull(compNamePrdSerDet)%>" maxlength="100">
					</Td>

				</Tr>
		    	</table>
		    	
			 
 	 		<div class="alert alert-info">
			                <h4><i class="icon fa fa-info"></i> Mandatory!</h4>
			                Certificates ISO9001/ IATF, MSDS, TDS,REACH are mandatory.
			                
			                
              		</div>
              		
               		<div class="col-xs-12" align="center">
			<button type="button" onclick="funClick()">Click Here</button>
 </div>      		
 

 	 		<div class="row">
			    <div class="col-md-12 col-xs-12">
			      <!-- general form elements -->
			      <div class="box box-default">


				 <div class="box-body table-responsive no-padding">
				    <div class="box-body">
				       <table id="uploadTable" class="table  table-bordered dt-responsive nowrap" >	
					<tr>					
						<th>Standard Used</th>
						<th>Name Of Certifying Entity</th>
						<th>Year Of Ceritificate</th>
						<th>Certificate Number</th>
						<th>Validity Till</th>
						<th> Certificate</th>										
						<th></th>										
					</tr>
<% 
				
					Vector itemInd=retUADet.where(new String[]{"EUD_DOC_TYPE"},new String[]{"VENDOTH"});
					if("Y".equals(docRef))
					{
						if(itemInd!=null)
						{
							for(int v1=0;v1<itemInd.size();v1++)
							{	int index1 = -1;
								try{
								index1 = Integer.parseInt(itemInd.get(v1)+"");	}
								catch(Exception e){}				
								if(index1>=0){%>
							<tr>
							<!--<td><input type="text" class="form-control garlic-auto-save" name="upItemNo" value="<%=checkNull(retUADet.getFieldValueString(index1,"EUD_ITEM_NO"))%>"  ></td>-->
							<td><input type="text" class="form-control garlic-auto-save stdUsed" name="stdUsed" value="<%=checkNull(retUADet.getFieldValueString(index1,"EUD_EXT1"))%>" ></td>
							<td><input type="text" class="form-control garlic-auto-save" name="certName" value="<%=checkNull(retUADet.getFieldValueString(index1,"EUD_EXT2"))%>" ></td>
							<td><input type="text" class="form-control garlic-auto-save" name="certYr" value="<%=checkNull(retUADet.getFieldValueString(index1,"EUD_EXT3"))%>" ></td>
							<td><input type="text" class="form-control garlic-auto-save" name="validityDate" value="<%=checkNull(retUADet.getFieldValueString(index1,"EUD_EXT4"))%>" ></td>
							<td><input type="text" class="form-control garlic-auto-save" name="certNumber" value="<%=checkNull(retUADet.getFieldValueString(index1,"EUD_EXT5"))%>" ></td>
							<td>
							<input type="hidden" name="fileItem" value="<%=retUADet.getFieldValueString(index1,"EUD_FILE_NAME").split("##")[0]%>" >
							<a href="javascript:downloadFile('O','<%=retUADet.getFieldValueString(index1,"EUD_ITEM_NO")%>','<%=retUADet.getFieldValueString(index1,"EUD_FILE_NAME").split("##")[0]%>','<%=retUADet.getFieldValueString(index1,"EUD_DOC_TYPE")%>')"><%=retUADet.getFieldValueString(index1,"EUD_FILE_NAME").split("##")[0]%></a>
							</td>
							<td width="5%">

								<span onclick="javascript:deleteCertFile(this,'<%=retUADet.getFieldValueString(index1,"EUD_ITEM_NO")%>','<%=retUADet.getFieldValueString(index1,"EUD_FILE_NAME").split("##")[0]%>')" class="fa fa-trash fa-lg" style="margin-left: 25%;"></span>

							</td>
							</tr>
							<%}
							}
					 	}
					}%> 
					</table>

				</div>
			      </div>
			    </div>
			    <!-- Your Page Content Here -->
			  </div>
			</div><!--row-->
			<div class="alert alert-info">
					<h4><i class="icon fa fa-info"></i> Mandatory!</h4>
					PANCARD, CANCELLED CHEQUE, GST CERTIFICATE, ADDRESS PROOF are mandatory.
              		</div>
			<div class="row">
					    <div class="col-md-12 col-xs-12">
					      <!-- general form elements -->
					      <div class="box box-default">


						 <div class="box-body table-responsive no-padding">
						    <div class="box-body">
						       <table id="uploadKYCTable" class="table  table-bordered dt-responsive nowrap" >	
							<tr>								
								<th>Type</th>
								<th>KYC Document</th>
								<th></th>
							</tr>
							<%
					itemInd=retUADet.where(new String[]{"EUD_DOC_TYPE"},new String[]{"KYCDOC"});
					if("Y".equals(docRef))
					{
						if(itemInd!=null)
						{
							for(int v1=0;v1<itemInd.size();v1++)
							{	int index1 = -1;
								try{
								index1 = Integer.parseInt(itemInd.get(v1)+"");	}
								catch(Exception e){}				
								if(index1>=0){%>
							<tr>
							<td><input type="text" class="form-control garlic-auto-save" name="kycDoc" value="<%=checkNull(retUADet.getFieldValueString(index1,"EUD_EXT1"))%>" readonly></td>
							<td>
							<input type="hidden" name="fileItem" value="<%=retUADet.getFieldValueString(index1,"EUD_FILE_NAME").split("##")[0]%>" >
							<a href="javascript:downloadFile('O','<%=retUADet.getFieldValueString(index1,"EUD_ITEM_NO")%>','<%=retUADet.getFieldValueString(index1,"EUD_FILE_NAME").split("##")[0]%>','<%=retUADet.getFieldValueString(index1,"EUD_DOC_TYPE")%>')"><%=retUADet.getFieldValueString(index1,"EUD_FILE_NAME").split("##")[0]%></a>
							</td>
							<td width="5%">

							<span onclick="javascript:deleteCertFile(this,'<%=retUADet.getFieldValueString(index1,"EUD_ITEM_NO")%>','<%=retUADet.getFieldValueString(index1,"EUD_FILE_NAME").split("##")[0]%>')" class="fa fa-trash fa-lg" style="margin-left: 25%;"></span>

							</td>
							</tr>
							<%}
							}
					  }
				}
					%> 

							</table>

						</div>
					      </div>
					    </div>
					    <!-- Your Page Content Here -->
					  </div>
			</div><!--row-->
			 <div class="row">
						   	 <div class="col-xs-12" align="center">
						   	 	<button type="button" id="uploadDialogBtn" class="btn btn-primary" ><i class="fa fa-upload"></i>&nbsp;Upload Certificates</button>
						   	 	<button type="button" id="uploadKYCBtn" class="btn btn-primary" ><i class="fa fa-upload"></i>&nbsp;Upload KYC</button>
						    	 </div>
 	 		  </div><br>
		  </div>
		  <div id="tabs-6">
		  <input type="hidden" name="tabVal6" id="tabVal6" value="" >
		  	<table class="table table-bordered">
				<Tr>
					<Th align="left">Manufacturer Name</Th>
					<Td>
						<input type="text" class="form-control garlic-auto-save"   name="compNameGeoDet" value="<%=checkNull(compNamePrdSerDet)%>" maxlength="100">
					</Td>

				</Tr>
		    	</table>
		    	<div class="row" id="tabContents">
			<!-- left column -->
			   <div class="col-md-12">
				<div class="box box-primary">
					<div class="box-header with-border">
						<h3 class="box-title">Check all that apply</h3>
					</div>
					<div class="box-body">
						<table class="table table-bordered">
							<tr>

							    <th align="left">Geographic Country</th>
							    <th align="center">Currently Served	</th>
							    <th align="center">Able to Serve</th>
							    <th align="center">R & D Center</th>
							</tr>
							<%
														
							java.util.Hashtable<String,String> valueHt=new java.util.Hashtable<String,String>(); 
								String value=geodet;
								//out.println("valuegeodet"+value);
								if(value != null && !"null".equals(value) && !"".equals(value))
								{
								for(int k=0;k<value.split("?").length;k++)
								{
								if("".equals(value.split("?")[k]))
								continue;
								int j=value.split("?")[k].length();
								if(!valueHt.containsKey(value.split("?")[k].split("#")[0]))
								valueHt.put(value.split("?")[k].split("#")[0],value.split("?")[k].substring(2,j));
								else
								{
								String valueofHT=(String)valueHt.get(value.split("?")[k].split("#")[0]);
								valueofHT=valueofHT+"#"+value.split("?")[k].substring(2,j);
								valueHt.remove(value.split("?")[k].split("#")[0]);
								valueHt.put(value.split("?")[k].split("#")[0],valueofHT);

								}

								}
								}
								//out.println(valueHt+"valuegeodet");
								//out.println(valueHt+"valueHt");
								//out.println(geoDetHT+"geoDetHT");
								for(Map.Entry entry: geoDetHT.entrySet())
								{
								geochk1="default";
								geochk2="default";
								geochk3="default";
								if(valueHt.containsKey(entry.getKey())){
								String pp=valueHt.get(entry.getKey());
								//out.println(pp+"ppvalue");
								for(int g=0;g<pp.split("#").length;g++)
								{
								if("0".equals(pp.split("#")[g].substring(0,1)))geochk1="success active";
								if("1".equals(pp.split("#")[g].substring(0,1)))geochk2="success active";
								if("2".equals(pp.split("#")[g].substring(0,1)))geochk3="success active";
								} 
								}

							%>
							<tr>

								<Th align="left"><%=entry.getValue()%></Th>
								<td align="center">
									 <div class="btn-group" data-toggle="buttons" onclick="funCheck('<%=entry.getKey()%>','0')">
									 <label for="currServInd" class="btn btn-<%=geochk1%>" style="">
										<input type="checkbox" autocomplete="off" class="garlic-auto-save" name="geoChk<%=entry.getKey()%>" id="currServInd" onclick="funCheck('<%=entry.getKey()%>','0')">
										<span class="glyphicon glyphicon-ok" ></span>
									</label>
									</div> 
								</td>
								<td align="center">

									 <div class="btn-group" data-toggle="buttons" onclick="funCheck('<%=entry.getKey()%>','1')">
									 <label for="ablToSrvInd" class="btn btn-<%=geochk2%>" style="">
										<input type="checkbox" autocomplete="off" class="garlic-auto-save" name="geoChk<%=entry.getKey()%>" id="ablToSrvInd" onclick="funCheck('<%=entry.getKey()%>','1')">
										<span class="glyphicon glyphicon-ok" ></span>
									</label>
									</div>
								</td>
								<td align="center">

									 <div class="btn-group" data-toggle="buttons" onclick="funCheck('<%=entry.getKey()%>','2')">
									 <label for="radInd" class="btn btn-<%=geochk3%>" style="">
										<input type="checkbox" autocomplete="off" class="garlic-auto-save" name="geoChk<%=entry.getKey()%>" id="radInd" onclick="funCheck('<%=entry.getKey()%>','2')">
										<span class="glyphicon glyphicon-ok" ></span>
									</label>
									</div>
								</td>

							</tr>
							<%}
							%>
							<input type="hidden" name="geoHT" value="<%=geoDetHT.size()%>">
							<!--<tr>
								<Th align="left">Europe</Th>
								
								<td align="center">
									 <div class="btn-group" data-toggle="buttons">
									 <label for="currServInd" class="btn btn-default">
										<input type="checkbox" autocomplete="off" name="geoChk" id="currServErp">
										<span class="glyphicon glyphicon-ok"></span>
									</label>
									</div>
								</td>
								<td align="center">

									 <div class="btn-group" data-toggle="buttons">
									 <label for="ablToSrvInd" class="btn btn-default">
										<input type="checkbox" autocomplete="off" name="geoChk" id="ablToSrvErp">
										<span class="glyphicon glyphicon-ok"></span>
									</label>
									</div>
								</td>
								<td align="center">

									 <div class="btn-group" data-toggle="buttons">
									 <label for="radInd" class="btn btn-default">
										<input type="checkbox" autocomplete="off" name="geoChk" id="radErp">
										<span class="glyphicon glyphicon-ok"></span>
									</label>
									</div>
								</td>
														
							</tr>
							<tr>
								<Th align="left">Asia Pacific</Th>
								<td align="center">
									 <div class="btn-group" data-toggle="buttons">
									 <label for="currServInd" class="btn btn-default">
										<input type="checkbox" autocomplete="off" name="geoChk" id="currServAP">
										<span class="glyphicon glyphicon-ok"></span>
									</label>
									</div>
								</td>
								<td align="center">

									 <div class="btn-group" data-toggle="buttons">
									 <label for="ablToSrvInd" class="btn btn-default">
										<input type="checkbox" autocomplete="off" name="geoChk" id="ablToSrvAP">
										<span class="glyphicon glyphicon-ok"></span>
									</label>
									</div>
								</td> 
								<td align="center">

									 <div class="btn-group" data-toggle="buttons">
									 <label for="radInd" class="btn btn-default">
										<input type="checkbox" autocomplete="off" name="geoChk" id="radAP">
										<span class="glyphicon glyphicon-ok"></span>
									</label>
									</div>
								</td>
														
							</tr>
							<tr>
								<Th align="left">Africa</Th>
								
								<td align="center">
									 <div class="btn-group" data-toggle="buttons">
									 <label for="currServInd" class="btn btn-default">
										<input type="checkbox" autocomplete="off" name="geoChk" id="currServAfr">
										<span class="glyphicon glyphicon-ok"></span>
									</label>
									</div>
								</td>
								<td align="center">

									 <div class="btn-group" data-toggle="buttons">
									 <label for="ablToSrvInd" class="btn btn-default">
										<input type="checkbox" autocomplete="off" name="geoChk" id="ablToSrvAfr">
										<span class="glyphicon glyphicon-ok"></span>
									</label>
									</div>
								</td>
								<td align="center">

									 <div class="btn-group" data-toggle="buttons">
									 <label for="radInd" class="btn btn-default">
										<input type="checkbox" autocomplete="off" name="geoChk" id="radAfr">
										<span class="glyphicon glyphicon-ok"></span>
									</label>
									</div>
								</td>

							</tr>
							<tr>
								<Th align="left">South America</Th>
								
								<td align="center">
									 <div class="btn-group" data-toggle="buttons">
									 <label for="currServInd" class="btn btn-default">
										<input type="checkbox" autocomplete="off" name="geoChk" id="currServSA">
										<span class="glyphicon glyphicon-ok"></span>
									</label>
									</div>
								</td>
								<td align="center">

									 <div class="btn-group" data-toggle="buttons">
									 <label for="ablToSrvInd" class="btn btn-default">
										<input type="checkbox" autocomplete="off" name="geoChk" id="ablToSrvSA">
										<span class="glyphicon glyphicon-ok"></span>
									</label>
									</div>
								</td>
								<td align="center">

									 <div class="btn-group" data-toggle="buttons">
									 <label for="radInd" class="btn btn-default">
										<input type="checkbox" autocomplete="off" name="geoChk" id="radSA">
										<span class="glyphicon glyphicon-ok"></span>
									</label>
									</div>
								</td>
																					
							</tr>
							<tr>
								<Th align="left">North America</Th>
								<td align="center">
									 <div class="btn-group" data-toggle="buttons">
									 <label for="currServInd" class="btn btn-default">
										<input type="checkbox" autocomplete="off" name="geoChk" id="currServNA">
										<span class="glyphicon glyphicon-ok"></span>
									</label>
									</div>
								</td>
								<td align="center">

									 <div class="btn-group" data-toggle="buttons">
									 <label for="ablToSrvInd" class="btn btn-default">
										<input type="checkbox" autocomplete="off" name="geoChk" id="ablToSrvNA">
										<span class="glyphicon glyphicon-ok"></span>
									</label>
									</div>
								</td>
								<td align="center">

									 <div class="btn-group" data-toggle="buttons">
									 <label for="radInd" class="btn btn-default">
										<input type="checkbox" autocomplete="off" name="geoChk" id="radNA" >
										<span class="glyphicon glyphicon-ok"></span>
									</label>
									</div>
								</td>
																												
							</tr>-->
						</table>
						<textarea id="docComments" name="docComments" class="form-control garlic-auto-save" rows="3" placeholder="Enter comments here"></textarea>
					</div>
				</div>
			    </div>
			    <div class="row">
				 <div class="col-xs-12" align="center">
					<button type="button" id="uploadDialogBtn" class="btn btn-primary" onclick="funSubmit()" ><i class="fa fa-submit"></i>&nbsp;Submit</button>
				</div>
			    			<!-- Your Page Content Here -->
			   </div>
			</div>
		  </div>
		</div>
		
 		<div class="Clearboth"></div>
 
	</div>

	</div>
	</div>


	
	</div>
	</div><!--row-->
	
	<br>
	
	
</form>
 
<div id="uploadMod" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog">
      <form id="uploadForm" action="ezUploadCertificate.jsp" method="post" enctype="multipart/form-data" style="width:1000px;position:relative;left:-190px">
      <div class="modal-content">
      <div class="modal-header">
	      <button type="button" class="close" data-dismiss="modal" aria-label="Close">
		<span aria-hidden="true">X</span></button>
	      <h4 class="modal-title">Certificate Upload <h6 style="color:orange">Maximum file size(8Mb)!</h6></h4>
	</div>
	 <div class="modal-body">	    
		         <fieldset>
				<div class="row" id="tabContents">
							<!-- left column -->
							<div class="col-md-12">
								<div class="box box-primary">
									<div class="box-header with-border">
										<h3 class="box-title">Quality Certification Details</h3>
									</div>
									<div class="box-body">
									<table class="table table-bordered">
										<tr>
				
											    <th align="left">Standard Used</th>
											    <th align="left">Name Of Certifying Entity</th>
											    <th align="left">Year Of Ceritificate</th>
											    <th align="left">Certificate Number</th>
											    <th align="left">Validity Till</th>
										</tr>
				
										<tr>
				
											    <td>
												<select class="form-control garlic-auto-save pull-right validate[required]" data-errormessage-value-missing="Please Select Standard" id="stdUsed" name="stdUsed">
													<option Value="">--Select Type--</option>
													<option Value="ISO9001/IATF">ISO9001/IATF</option>
													<option Value="ISO 14001">ISO 14001</option>
													<option Value="ISO 18001">ISO 18001</option>
													<option Value="MSDS">MSDS</option>
													<option Value="TDS">TDS</option>
													<option Value="REACH">REACH</option>
													<option Value="OTHERS">OTHERS</option>
												</select>
											    </Td>
											     <td>
												<input type="text" class="form-control garlic-auto-save pull-right validate[required]" data-errormessage-value-missing="Please Enter Certificate Name" id="certName" name="certName" value="" maxlength="50">
											    </Td>
											     <td>
												<select class="form-control garlic-auto-save pull-right validate[required]" data-errormessage-value-missing="Please Select Certificate Year" id="certYr" name="certYr">
													<option Value="">--Select Year--</option>
<%
	int curYear = (new java.util.Date().getYear())+1900;
	for(int k=curYear;k>=1990;k--)
	{
%>
														<option Value="<%=k%>"><%=k%></option>
<%
	}
%>
												</select>
											    </Td>
											    <td>
											    	<div class="input-group">
													<input type="text" class="form-control garlic-auto-save pull-right validate[required]" data-errormessage-value-missing="Please Enter Valid Number" name="certNumber" id="certNumber" maxlength="40">
												</div>
                        
											    </td>
											     <td>
												<div class="input-group">
													<!--<input class="form-control garlic-auto-save input-sm validate[required]" data-errormessage-value-missing="Please Enter Date" type="text"  name="validityDate" id="validityDate" value=""  style="width:100%" readonly>-->
													<div class="input-group date">
													                  <div class="input-group-addon">
													                    <i class="fa fa-calendar"></i>
													                  </div>
													                  <input type="text" class="form-control garlic-auto-save pull-right validate[required]" data-errormessage-value-missing="Please Enter Validity" name="validityDate" id="validityDate" onchange= "funChk()" readonly >
                											</div>
                                								</div>
											    </Td>
										</tr>
										</table>
										<fieldset>
											<input type="hidden" id="upDocType" name="upDocType" value="VENDOTH">
											<input type="hidden" id="upDocId" name="upDocId" value="<%=docId%>">
											<input type="hidden" id="upItemNo" name="upItemNo" value="">
											<input type="file" id="file" name="file"/>
											<div id="loadingInd" style="display:none;margin-left: 25%;">
												<i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i>
												<span class="sr-only">Loading...</span>
											</div>
	         								</fieldset>
									</div>
								</div>
							</div>
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
<div id="uploadKYCMod" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog">
      <form id="uploadKYCForm" action="ezUploadCertificate.jsp" method="post" enctype="multipart/form-data" style="width:1000px;position:relative;left:-190px">
      <div class="modal-content">
      <div class="modal-header">
	      <button type="button" class="close" data-dismiss="modal" aria-label="Close">
		<span aria-hidden="true">X</span></button>
	      <h4 class="modal-title">Certificate Upload</h4>
	</div>
	 <div class="modal-body">	    
		         <fieldset>
				<div class="row" id="tabContents">
			<!-- left column -->
			<div class="col-md-12">
				<div class="box box-primary">
					<div class="box-header with-border">
						<h3 class="box-title">Quality Certification Details</h3>
					</div>
					<div class="box-body">
					<table class="table table-bordered">
						<tr>

							    <th align="left">Documents</th>
						</tr>

						<tr>

							    <td>
								<select class="form-control garlic-auto-save pull-right validate[required]" data-errormessage-value-missing="Please Select Standard" id="kycDoc" name="kycDoc">
									<option Value="">--Select Type--</option>
									<option Value="PANCARD">PANCARD</option>
									<option Value="CANCELLED CHEQUE">CANCELLED CHEQUE</option>
									<option Value="GST CERTIFICATE">GST CERTIFICATE</option>
									<option Value="ADDRESS PROOF">ADDRESS PROOF</option>
									<option Value="OTHERS">OTHERS</option>
								</select>
							    </Td>
							    <td>
								<input type="hidden" id="upKYCDocType" name="upKYCDocType" value="KYCDOC">
								<input type="hidden" id="upKYCDocId" name="upKYCDocId" value="<%=docId%>">
									<input type="hidden" id="upKYCItemNo" name="upKYCItemNo" value="">
									<input type="file" id="kycFile" name="kycFile"/>
							    </td>
						</tr>
						</table>
							<div id="loadingKYCInd" style="display:none;margin-left: 25%;">
								<i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i>
								<span class="sr-only">Loading...</span>
							</div>
					</div>
				</div>
			</div>
		</div>    
		         </fieldset>
	   		
	 </div>
	 <div class="modal-footer">
	 	<button type="submit" id="uploadkycbutton" class="btn btn-primary">Upload</button>
	 </div>
      </div>
     </form>
   </div>  
</div> 	 
<div id="uploadMSMEMod" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog">
      <form id="uploadMSMEForm" action="ezUploadFileTemp.jsp" method="post" enctype="multipart/form-data" style="width:1000px;position:relative;left:-190px">
      <div class="modal-content">
      <div class="modal-header">
	      <button type="button" class="close" data-dismiss="modal" aria-label="Close">
		<span aria-hidden="true">X</span></button>
	      <h4 class="modal-title">MSME Upload</h4>
	</div>
	 <div class="modal-body">	    
		       <fieldset>
		      			<input type="hidden" id="upMSMEDocType" name="upMSMEDocType" value="">
		      			<input type="hidden" id="upMSMEItemNo" name="upMSMEItemNo" value="">        
		      			<input type="file" id="MSMEFile" name="file"/>
		      				<!--<input type="submit" id="uploadbutton" value="upload" />-->
		      
		      			<div id="loadingMSMEInd" style="display:none;margin-left: 25%;">
		      				<i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i>
		      				<span class="sr-only">Loading...</span>
		      			</div>
		      	         </fieldset>
		         		
		      	 </div>
		      	 <div class="modal-footer">
		      	 	<p class="text-red" style="float:left;"><strong>Maximum File size 5MB.</strong></p>
		      	 	<button type="submit" id="uploadMSMEbutton" class="btn btn-primary">Upload</button>
		      	 </div>
		            </div>  
		           </form>
		         </div>    
</div> 
</section>
</div>


      <!-- Main Footer -->
      <footer class="main-footer">
        <!-- To the right -->
        
        <!-- Default to the left -->
        <strong>Copyright &copy; 2015 <a href="http://www.thehackettgroup.com/">The Hackett Group</a>.</strong> All rights reserved.
      </footer>

      
     
     
    <!-- REQUIRED JS SCRIPTS -->
    <!-- jQuery 2.1.4 -->
    <script src="../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>
    <script src="../../../EzCommon/Library/jquery.form.js"></script> 
    <script src="../../../EzCommon/Library/plugins/jQueryUI/jquery-ui.min.js"></script>
    <script src="../../../EzCommon/Library/plugins/select2/select2.full.min.js"></script>
    
    <!-- Bootstrap 3.3.5 -->
    <script src="../../../EzCommon/Library/bootstrap/js/bootstrap.min.js"></script>
    <!-- AdminLTE App --> 
    <script src="../../../EzCommon/Library/js/datepicker.js"></script>
    <script src="../../../EzCommon/Library/js/alert_confirm.js"></script>
    <script src="../../../EzCommon/Library/dist/js/app.min.js"></script>
	<script src="../../../EzCommon/Library/dataTables/ZeroClipboard.js"></script>
	<script type="text/javascript" language="javascript" src="../../../EzCommon/Library/dataTables/jquery.dataTables.min.js"></script>
	<script type="text/javascript" language="javascript" src="../../../EzCommon/Library/dataTables/dataTables.bootstrap.min.js"></script>
	<script type="text/javascript" language="javascript" src="../../../EzCommon/Library/dataTables/dataTables.responsive.min.js"></script>
	<script type="text/javascript" language="javascript" src="../../../EzCommon/Library/dataTables/dataTables.tableTools.js"></script>	
	<script src="../../../EzCommon/Library/plugins/pace/pace.min.js"></script>
    <!-- Optionally, you can add Slimscroll and FastClick plugins.
         Both of these plugins are recommended to enhance the
         user experience. Slimscroll is required when using the
         fixed layout. -->  
         <script src="../../../EzCommon/Library/jQuery-Validation/js/jquery.validationEngine.js" type="text/javascript" charset="utf-8"></script>
         <script src="../../../EzCommon/Library/jQuery-Validation/js/jquery.validationEngine-en.js" type="text/javascript" charset="utf-8"></script>
         <script>
               function funClick()
               {
                  //document.myForm.action="../../../EzVendor/Vendor2/JSPs/VenApproval/ezDocumentPopup.jsp"; 
		  		  		//document.myForm.target="_parent";
		  		  		//document.myForm.submit();
		  		  		var url="../../../EzVendor/Vendor2/JSPs/VenApproval/ezDocumentPopup.jsp"
				var clickHereWin=window.open(url,"PopupWin","width=400,height=220,left=100,top=120,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
	       }	
	       	
	
	var tabVal;
		function deleteCertFile(thisObj,upItemNo,fileName,upDocType)
		  {
			var upDocId 	= document.myForm.docId.value;//$('#upDocId').val();
			if(confirm("Are you sure you want to delete this file?"))
			{
				$.ajax({
				    url: '../../../EzVendor/Vendor2/JSPs/Inbox/ezDeleteFile.jsp',
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

		 }
		function downloadFile(status,upItemNo,fileName,upDocType)
		  {
			var upDocId 	= document.myForm.docId.value;
			fileName=encodeURIComponent(fileName);
			window.open("../../../EzVendor/Vendor2/JSPs/Inbox/ezFileDownload.jsp?upDocId="+upDocId+"&upDocType="+upDocType+"&upItemNo="+upItemNo+"&fileName="+fileName);
		  }
		  
		  document.myForm.geoVa.value='<%=geodet%>';
		  
		function funCheck(key,value)
		{
			var geoVa=''
			if(document.myForm.geoVa.value=='')
				geoVa='<%=geodet%>';
			else
				geoVa=document.myForm.geoVa.value;
			//alert(geoVa);
			 for(var g=1;g<geoVa.split("?").length;g++)
			  {
				var h=geoVa.split("?")[g].split("#")[0];
				var va=geoVa.split("?")[g].split("#")[1];
				va=va.substring(0,1);
				//?1#0on?1#1on?1#2ongeoVa
				//alert(h+"h"+va+"va");
				if(key==h && value==va)
				{
				var reva='?'+h+"#"+va+'on';
				//alert("reva"+reva);
				var geoVa = geoVa.replace(reva,'');
				continue;
				
				}
				
			  }
		document.myForm.geoVa.value=geoVa;

		}
		 
		

		
		
		
		function validateCert()  
		{	
			debugger;
			/*var flag = false;
			var count = document.getElementsByClassName("stdUsed");
			var x = count.length;
			var certCnt = 0;
			$(".stdUsed").each(function() {
			        if(this.value == "ISO9001/IATF" || this.value == "MSDS" || this.value == "TDS" || this.value == "REACH")
			        {
			        	certCnt++;    
			        }
    			});
    			if(certCnt >= 4)
    				flag=true;
    				//return true;   
    			else
    			{
    				alert("Please enter all the mandatory certificates");
    				return false;
    				flag=false;
    				//flag=true;
    			}
    			return flag;*/
    			return true;
		}
		function validateKYC()
		{
			/*var certCnt = 0;
			$(".kycDoc").each(function() {
			        if(this.value == "PANCARD" || this.value == "CANCELLED CHEQUE" || this.value == "GST CERTIFICATE"|| this.value == "ADDRESS PROOF")
			        {
			        	certCnt++;
			        }
    			});
    			if(certCnt >= 4) 
    				return true;
    			else
    			{
    				alert("Please enter all the mandatory KYC certificates");
    				return false;
    			}*/
    			return true;
		}
		$( function() {
		    $( "#tabs" ).tabs();
		    $("#tabs").tabs("option", "disabled", [1,2,3,4,5]);	
		   $('.select2').select2();
		   $('.btn').click(function() {
		        $(this).toggleClass('btn-success');
		        $(this).toggleClass('btn-default');
		   });
		    
			
	            //Get the first tab in document and will assume will always use first one
		    	var selectedTab = $(document).find('div[class^="ui-tabs"]').first();
		    	
		    //Navigation button, select tab when button click.
		    $(".Footer").on('click', ':button', function () {
		    	var selected = selectedTab.tabs("option", "active");
		    	if(!$("#myForm").validationEngine('validate'))
		    	{
		    		return ;
		    	}
		    	var x=document.getElementById("compCountry").value;
			x=x.toUpperCase();
			var y="INDIA";
			 
		    	if(selected == 0 && x==y)
		   	{
		   	var x=1;
		   	var y=document.getElementsByClassName("msmeFilePara").length;
		   	
		   	
		   	/*if( x===y && document.getElementById("MicroRd").checked==true || document.getElementById("SmallRd").checked==true || document.getElementById("MediumRd").checked==true)
		   	{
		   	}*/
		   	
		   	if(document.getElementById("MicroRd").checked!=true && document.getElementById("SmallRd").checked!=true && document.getElementById("MediumRd").checked!=true && document.getElementById("LargeRd").checked!=true && document.getElementById("NotApRd").checked!=true)
		   	{
		   	alert("Please Select the Enterprise ");
		   	return;
		   	}
		   	if(document.getElementById("propRd").checked!=true && document.getElementById("partRd").checked!=true && document.getElementById("pvtRd").checked!=true && document.getElementById("pubRd").checked!=true && document.getElementById("othrRd").checked!=true)
			{
			alert("Please Select the Type of Organization ");
		   	return;
			}
			if(document.getElementById("ServRd").checked!=true && document.getElementById("ManfRd").checked!=true)
			{
			alert("Please select under which your company is registered ");
			return;
			}
				$("#tabs").tabs("option", "disabled", [selected,2,3,4,5]);
		   	}					
			if(selected==2)
		    		$("#tabs").tabs("option", "disabled", [selected,1,3,4,5,0]);
		   	if(selected == 3)
		   	{	
		   	<%
		   		if(!"REAPP".equals(appFlag))
		   		{
		   	%>
					if(!($("#qmsYes1").is(":checked")&&$("#qmsYes2").is(":checked")&&$("#qmsYes6").is(":checked")&&$("#qmsYes10").is(":checked")&&$("#qmsYes12").is(":checked")&&$("#qmsYes14").is(":checked")&&$("#qmsYes20").is(":checked")&&$("#qmsYes25").is(":checked")&&$("#qmsYes27").is(":checked"))){
					alert("Documents Colored in Orange color are mandatory");
					return;
					}
					$("#tabs").tabs("option", "disabled", [selected,2,4,5,1,0]);
		   	<%
		   		}else{
		   	%>
		   		$("#tabs").tabs("option", "disabled", [selected,2,4,5,1,0]);
		   		//if(!validateKYC())
		   			//return ;
		   	<%
				}
		   	%>
		   	}
		   	if(selected == 4)
		   	{
		   		debugger;
		   		
		   		if(!validateCert())
		   			return ;
		   		
		   		$("#tabs").tabs("option", "disabled", [selected,2,4,5,1,0]);
		   	}
		   	
			if(selected == 1)
			{	
				var checkedFlag= false;
				for(var i=0;i<document.getElementsByName("example1").length;i++)
				{
					if(document.getElementsByName("example1")[i].checked == true)
					{
						checkedFlag = true;
					}
				}
				
				if(!checkedFlag)
				{
					alert("Please select a default plant!");
					return;
				}
				$("#tabs").tabs("option", "disabled", [selected,0,3,4,5,1]);
						
				//if(!validateKYC())
					//return ;		   			
		   	}
		   	if(selected==5)
		    		$("#tabs").tabs("option", "disabled", [selected,2,3,4,1,0]);
		    		
			$("#tabs").tabs("enable", selected+1);  
			tabVal=selected+1;
			
			 $(function tabSave() {
				var tLineNumber=document.getElementsByName("tLineNumber").length;
				var ptLineNumber=document.getElementsByName("ptLineNumber").length;
				var pLineNumber=document.getElementsByName("pLineNumber").length;
				var rLineNumber=document.getElementsByName("rLineNumber").length;
				var cLineNumber=document.getElementsByName("cLineNumber").length;
				debugger;

				document.getElementById("tLineNumberVal").value=tLineNumber;
				document.getElementById("ptLineNumberVal").value=ptLineNumber;
				document.getElementById("pLineNumberVal").value=pLineNumber;
				document.getElementById("cLineNumberVal").value=cLineNumber;
				document.getElementById("rLineNumberVal").value=rLineNumber;
				
				document.getElementById("tabVal"+tabVal).value=tabVal;
				
				
				
				var prodOffChkVal='';
				var chkbox=document.getElementsByName("prodOffChk").length;

				console.log("chkbox::::"+chkbox);

				for(var i=0;i<chkbox;i++)
				{
					if(document.getElementsByName("prodOffChk")[i].checked)
					{
						if(prodOffChkVal=='')
							prodOffChkVal = document.getElementsByName("prodOffChk")[i].value;
						else
							prodOffChkVal = prodOffChkVal + "$$" +document.getElementsByName("prodOffChk")[i].value;		
					}
				}
				debugger;
				document.getElementById("prodOffChkdet").value = prodOffChkVal;
				
				var docId=$("#docId").val();
				$.ajax({
				type: 'post',
				url: 'ezSaveVendRegOthMatNew.jsp?prodOffChk='+prodOffChkVal,
				data: $('#tabs-'+tabVal).find("select, textarea, input,radio").serialize()+"&docId="+docId,
				success: function (response) {
				console.log(response);
				},
				error: function(response) {
				console.log(response)
				}
				});
			});
			
			if (this.id == "btnMoveLeftTab") {
			    if (selected >= 1) {
			    if(selected==5)
			    {
			    $("#tabs").tabs("enable", selected-1);
			    $("#tabs").tabs("option", "disabled", [selected,2,3,1,0]);
			    }
			    if(selected==4)
			    {
			    	$("#tabs").tabs("enable", selected-1);
			    	$("#tabs").tabs("option", "disabled", [selected,2,5,1,0]);
<%
			if("REAPP".equals(appFlag))
			{
%>	
			    	selected=3;
			     $("#tabs").tabs("enable", selected-1);
			     $("#tabs").tabs("option", "disabled", [selected,4,1,0,5]);
<%
			     }
%>
			    }
			    if(selected==3)
			    {
			    $("#tabs").tabs("enable", selected-1);
			    $("#tabs").tabs("option", "disabled", [selected,4,1,0,5]);	
			    
			    }
			    if(selected==2)
			    {
			    $("#tabs").tabs("enable", selected-1);
			    $("#tabs").tabs("option", "disabled", [selected,3,4,0,5]);
			    }
			    if(selected==1)
			    {
			    $("#tabs").tabs("enable", selected-1);
			    $("#tabs").tabs("option", "disabled", [selected,2,3,4,5]);
			    }

				selectedTab.tabs("option", "active", selected - 1);

			    }
			} else {
<%
		   		if("REAPP".equals(appFlag))
		   		{
%>			
			   if(selected==2)
			    {			  
				selected=3;
			     $("#tabs").tabs("enable", selected+1);
			     $("#tabs").tabs("option", "disabled", [selected,3,1,0,5]);
			    }
<%
				}
%>			    
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
	<script>
		function addLine(tabName)
		{
			var tabObj		= document.getElementById(tabName)
			var rowItems 		= tabObj.getElementsByTagName("tr");
			var rowCountValue 	= rowItems.length;
			
			
			
			var itemNumber_JS	= parseFloat(rowCountValue);
			if(itemNumber_JS>3 && tabName=="contactTab") return false;
			if(itemNumber_JS>2 && tabName=="compTab") return false; 
			if(itemNumber_JS>4 && tabName=="partTab") return false; 
			if(itemNumber_JS>2 && tabName=="refTab") return false; 
			if(itemNumber_JS>5 && tabName=="plantTab") return false; 
			
			eleAlign = new Array();
			eleVal   = new Array();
		
			eleAlign[0] = "center";
			eleAlign[1] = "left";
			eleAlign[2] = "left";
			eleAlign[3] = "left";
			if(tabName=="plantTab")
			{
				eleVal[0] =itemNumber_JS+'<input type="hidden" name="ptLineNumber" value="'+itemNumber_JS+'" >';
				eleVal[1] ='<div class="custom-control custom-radio"><input type="radio" class="custom-control-input" id="customRadio_'+itemNumber_JS+'" name="example1" value="'+itemNumber_JS+'"></div>';
				eleVal[2] ='<input type="text" class="form-control garlic-auto-save" id="plantName_'+itemNumber_JS+'" name="plantName_'+itemNumber_JS+'" value="" maxlength="30">'
				eleVal[3] ='<input type="text" class="form-control garlic-auto-save" id="plantPlace_'+itemNumber_JS+'" name="plantPlace_'+itemNumber_JS+'" value="" maxlength="20">';
				eleVal[4] ='<input type="text" class="form-control garlic-auto-save" id="vendorCode_'+itemNumber_JS+'" name="vendorCode_'+itemNumber_JS+'" value="" maxlength="40">';
				eleVal[5] ='<input type="text" class="form-control garlic-auto-save" id="capacity_'+itemNumber_JS+'" name="capacity_'+itemNumber_JS+'" value="" maxlength="20">';
				eleVal[6] ='<input type="text" class="form-control garlic-auto-save" id="utilPer_'+itemNumber_JS+'" name="utilPer_'+itemNumber_JS+'" value="" maxlength="20">';
				eleVal[7] ='<input type="text" class="form-control garlic-auto-save" id="prodRang_'+itemNumber_JS+'" name="prodRang_'+itemNumber_JS+'" value="" maxlength="20">';
			}
			if(tabName=="contactTab")
			{
				eleVal[0] =itemNumber_JS+'<input type="hidden" name="tLineNumber" value="'+itemNumber_JS+'" >';
				eleVal[1] ='<input type="text" class="form-control garlic-auto-save validate[required]" data-errormessage-value-missing="Please Enter Contact Person" id="contactName_'+itemNumber_JS+'" maxlength="30" name="contactName_'+itemNumber_JS+'" value="" >'
				eleVal[2] ='<input type="text" onkeyup= validphone("contactPhone_'+itemNumber_JS+'",'+itemNumber_JS+') class="validate[required,custom[phone]] form-control garlic-auto-save" id="contactPhone_'+itemNumber_JS+'" maxlength="15" data-errormessage-value-missing="Please Enter Contact Phone" name="contactPhone_'+itemNumber_JS+'" value="" ><span id="errmsg_'+itemNumber_JS+'" style="color:red"></span>';
				eleVal[3] ='<input type="text" onkeyup= validemail("contactEmail_'+itemNumber_JS+'",'+itemNumber_JS+') class="validate[required,custom[email]] form-control garlic-auto-save" id="contactEmail_'+itemNumber_JS+'" data-errormessage-value-missing="Please Enter Contact Email" maxlength="40" name="contactEmail_'+itemNumber_JS+'" value="" ><span id="erremail_'+itemNumber_JS+'" style="color:red"></span>';
				eleVal[4] ='<input type="text" class="form-control garlic-auto-save validate[required]" data-errormessage-value-missing="Please Enter Contact Person Designation" id="contactDesgtn_'+itemNumber_JS+'" maxlength="30" name="contactDesgtn_'+itemNumber_JS+'" value="" >'
			}
			else if(tabName=="compTab")
			{
			
				eleVal[0] =itemNumber_JS+'<input type="hidden" name="cLineNumber" value="'+itemNumber_JS+'" >';
				eleVal[1] ='<input type="text" class="form-control garlic-auto-save" id="afflCompName_'+itemNumber_JS+'" name="afflCompName_'+itemNumber_JS+'" maxlength="50" value="" >'
				eleVal[2] ='<input type="text" class="form-control garlic-auto-save" id="afflCompRelat_'+itemNumber_JS+'" name="afflCompRelat_'+itemNumber_JS+'" maxlength="50" value="" >';
				eleVal[3] ='<Select name="affCompCunt_'+itemNumber_JS+'" id="affCompCunt_'+itemNumber_JS+'" class="form-control garlic-auto-save select2" >'+
						'<option value="">--Select Country--</option>'+
				
<%
						
						Set setACJS = cuntLHM.entrySet();
						Iterator iACJS = setACJS.iterator();
						while(iACJS.hasNext())
						{
							Map.Entry me = (Map.Entry)iACJS.next();
%>
							'<option value="<%=me.getKey()%>"><%=me.getValue()%></option>'+
<%

						}
%>
					    
					    
					    
					    
					    
					    '</select>';
				//$('#affCompCunt_'+itemNumber_JS).select2();
			}
			else if(tabName=="partTab")
			{
				eleVal[0] =itemNumber_JS+'<input type="hidden" name="pLineNumber" value="'+itemNumber_JS+'" >';
				eleVal[1] ='<input type="text" class="form-control garlic-auto-save" id="partName_'+itemNumber_JS+'" name="partName_'+itemNumber_JS+'" maxlength="30" value="" >';
				eleVal[2] ='<input type="text" class="form-control garlic-auto-save" id="partDesg_'+itemNumber_JS+'" name="partDesg_'+itemNumber_JS+'" maxlength="50" value="" >';
				eleVal[3] ='<input type="text" class="form-control garlic-auto-save" id="partPhNO_'+itemNumber_JS+'" name="partPhNO_'+itemNumber_JS+'" maxlength="15" value="" >';
				eleVal[4] ='<input type="text" class="form-control garlic-auto-save" id="partMob_'+itemNumber_JS+'" name="partMob_'+itemNumber_JS+'" value="" maxlength="15">';
				
			}
			else if(tabName=="refTab")
			{
				eleVal[0] =itemNumber_JS+'<input type="hidden" name="rLineNumber" value="'+itemNumber_JS+'" >'; 
				eleVal[1] ='<input type="text" class="form-control garlic-auto-save" id="refCompName_'+itemNumber_JS+'" name="refCompName_'+itemNumber_JS+'" value="" maxlength="30">';
				eleVal[2] ='<Select name="refCompCunt_'+itemNumber_JS+'" id="refCompCunt_'+itemNumber_JS+'" class="form-control garlic-auto-save select2" >'+
						'<option value="">--Select Country--</option>'+				
<%						
						Set setRCJS = cuntLHM.entrySet();
						Iterator iRCJS = setRCJS.iterator();
						while(iRCJS.hasNext())
						{
							Map.Entry me = (Map.Entry)iRCJS.next();
%>
							'<option value="<%=me.getKey()%>"><%=me.getValue()%></option>'+
<%  

						}
%>				    
					    '</select>';
				eleVal[3] ='<input type="text" class="form-control garlic-auto-save" id="refCompMatSup_'+itemNumber_JS+'" name="refCompMatSup_'+itemNumber_JS+'" value="" maxlength="20">';
				eleVal[4] ='<Select name="refCompyear_'+itemNumber_JS+'" id="refCompyear_'+itemNumber_JS+'" class="form-control garlic-auto-save select2" >'+
<%
						//int year = Calendar.getInstance().get(Calendar.YEAR);
						for(int refCompYr=year;refCompYr>(year-50);refCompYr--)
						{
%>
							'<option value="<%=refCompYr%>"><%=refCompYr%></option>'+
<%
						}
%>
						'</select>';
				eleVal[5] ='<input type="text" class="form-control garlic-auto-save" id="refName_'+itemNumber_JS+'" name="refName_'+itemNumber_JS+'" value="" maxlength="40">';
				eleVal[6] ='<input type="text" class="form-control garlic-auto-save" id="refCont_'+itemNumber_JS+'" name="refCont_'+itemNumber_JS+'" value="" maxlength="20">';
			}
			
			var rowId = tabObj.insertRow(rowCountValue);
			for(i=0; i<eleVal.length;i++){
				var cell0=rowId.insertCell(i);
				cell0.align = eleAlign[i];
				cell0.innerHTML =eleVal[i];
			}
			
			
		}
		function funCompName()
		{
			var compName = document.myForm.compName.value;
			document.myForm.compNamePrdSerDet.value= compName;
			document.myForm.compNamePlant.value= compName; 
			document.myForm.compNameGeoDet.value= compName;  
			document.myForm.compNameQtyCertDet.value= compName;  
			document.myForm.compNamePPAPDet.value= compName; 
		}
		function funCheckLength()
		{
			 var geoChk="";
			  var chkbox=document.getElementsByName("geoChk").length;
			  for(var i=0;i<chkbox;i++)
			  {
				if(document.getElementsByName("geoChk")[i].checked)
				{
					if(geoChk=="")
						geoChk = document.getElementsByName("geoChk")[i].value;
					else
						geoChk = geoChk + "#"+document.getElementsByName("geoChk")[i].value		
				}
			  }
			  if(geoChk=="")
				alert("Please select geoChk");
		}
		function funSubmit()
		{
		/*
		if($("#myForm").validationEngine('validate'))
		{
			
		}*/
		//alert("ok");
		
		var prodOffChkVal='';
		  var chkbox=document.getElementsByName("prodOffChk").length;
		 
		  for(var i=0;i<chkbox;i++)
		  {
			if(document.getElementsByName("prodOffChk")[i].checked)
			{
			
		   		if(prodOffChkVal=='')
				prodOffChkVal = document.getElementsByName("prodOffChk")[i].value;
				else
				prodOffChkVal = prodOffChkVal + "$$"+document.getElementsByName("prodOffChk")[i].value;		
			}
			
		  }
		  debugger;
		 var geoVa=document.myForm.geoVa.value;
		 var geoChkVal=geoVa;
		  var chkbox=document.myForm.geoHT.value;
		// alert(geoChkVal+"geoChkVal");
		  for(var i=1;i<=chkbox;i++)
		  { 
			for(var j=0;j<3;j++)
		  	{
				
				if(document.getElementsByName("geoChk"+i)[j].checked) 
				{
					if(j==0 || geoChkVal!="")geoChkVal=geoChkVal+"?"+i;
					if(geoChkVal=="")
					geoChkVal = i+"#"+j+document.getElementsByName("geoChk"+i)[j].value;
					else
					geoChkVal = geoChkVal+"#"+j+document.getElementsByName("geoChk"+i)[j].value		
				}
			}
			
  		 }
		// alert(geoChkVal+"geoChkVal");
		document.myForm.prodOffChkdet.value=prodOffChkVal;
		document.myForm.geodet.value=geoChkVal;
		//alert(document.myForm.prodOffChkdet.value);
<%		
		 if(!"Y".equals(docIdRef))
		 {
%>
		document.myForm.action="ezSaveVendRegOthMat.jsp"; 
		document.myForm.submit();
<%		
		}
		else{
%>		
		document.myForm.action="ezSaveVendRegOthMatOld.jsp"; 
		document.myForm.submit();
<%		
		}
%>		
		}
		function valuploadKYCForm()
		{
			var fileName = $('#kycFile').val().replace(/C:\\fakepath\\/i, '');
			var isValid = true;
			if(fileName == "")
			{
				alert("Please upload file");
				isValid = false;
				return false; 
			}
			if(!$("#uploadKYCForm").validationEngine('validate'))
			{
				isValid = false;
				return false;
			}

			if(isValid)
			{ 
				$('#uploadkycbutton').hide(); 	
				$('#loadingKYCInd').show();
			}
			return isValid;
 		 }
 		function valuploadMSMEForm()
		{
			var fileName = $('#MSMEFile').val().replace(/C:\\fakepath\\/i, '');
			var isValid = true;
			if(fileName == "")
			{
				alert("Please upload file");
				isValid = false;
				return false; 
			}
			if(!$("#uploadMSMEForm").validationEngine('validate'))
			{
				isValid = false;
				return false;
			}

			if(isValid)
			{ 
				$('#uploadMSMEbutton').hide(); 	
				$('#loadingMSMEInd').show();
			}
			return isValid;
 		 }
		 function valUploadForm()
		 {
		 	var fileName = $('#file').val().replace(/C:\\fakepath\\/i, '');
		 	var isValid = true;
		 	if(fileName == "")
			{
				alert("Please upload file");
				isValid = false;
				return false;
			}
		 	if(!$("#uploadForm").validationEngine('validate'))
		 	{
		 		isValid = false;
				return false;
		 	}
		 	
			if(isValid)
			{
				$('#uploadbutton').hide(); 	
		       		$('#loadingInd').show();
			}
			return isValid;
 		 }
 		 var itemCnt = 0;
 		 var itemKYCCnt = 0;
 		 var itemMSMECnt = 0;
		 $( function() {
			$( "#uploadKYCBtn").button().on( "click", function() {
					document. getElementById("uploadKYCForm").reset();
					itemKYCCnt = itemKYCCnt+1;
					$("#upKYCItemNo").val(itemKYCCnt);
					$("#kycFile").val("");
				       $('#uploadKYCMod').modal('show');
					return false;
		     });
		     $('#uploadKYCForm').ajaxForm({
		     		     	  beforeSubmit: valuploadKYCForm,	
		     			  success: function(msg) {
		     			      $('#uploadkycbutton').show(); 	
		     		       	      $('#loadingKYCInd').hide();
		     			      msg=$.trim(msg);
		     			      //alert(msg);
		     			      if(msg.split("##")[0] === 'true')  
		     			      {
		     			      	  var upKYCItemNo = $('#upKYCItemNo').val();
		     			      	  var kycDoc = $('#kycDoc').val();
		     			      	  var fileNameTemp = msg.split("##")[1];
		     			      	   $('#uploadKYCTable').append('<tr><td><input type="hidden" name="upKYCItemNo" value="'+upKYCItemNo+'"><input type="hidden" class="kycDoc" name="kycDoc" value="'+kycDoc+'">'+kycDoc+'</td><td><input type="hidden" name="kycFileItem" value="'+fileNameTemp+'"><a href="javascript:downloadFile(\''+upKYCItemNo+'\',\''+fileNameTemp+'\')">'+fileNameTemp+'</a></td><td width="5%"><span onclick="javascript:deleteKYCFile(this,\''+upKYCItemNo+'\',\''+fileNameTemp+'\')" class="fa fa-trash fa-lg" style="margin-left: 25%;"></span></td></tr>')
		     			      }
		     			      alert("File has been uploaded successfully");
		     			      $('#uploadKYCMod').modal('hide');
		     			  },
		     			  error: function(msg) {
		     			     $('#uploadkycbutton').show(); 	
		     		       	     $('#loadingKYCInd').hide();	
		     			     alert("Couldn't upload file");
		     			  }
		     });
		     $( "#uploadMSMEBtn").button().on( "click", function() {
					document. getElementById("uploadMSMEForm").reset();
					itemMSMECnt = itemMSMECnt+1;
					$("#upMSMEItemNo").val(itemMSMECnt);
					$("#MSMEFile").val("");
				       $('#uploadMSMEMod').modal('show');
					return false;
		     });
		     $('#uploadMSMEForm').ajaxForm({
					  beforeSubmit: valuploadMSMEForm,	
					  success: function(msg) {
					      $('#uploadMSMEbutton').show(); 	
					      $('#loadingMSMEInd').hide();
					      msg=$.trim(msg);
					      alert(msg);
					      if(msg.split("##")[0] === 'true')
					      {
						  var upMSMEItemNo = $('#upMSMEItemNo').val();
						  var MSMEDoc = $('#upMSMEDocType').val();
						  var fileNameTemp = msg.split("##")[1];
						  debugger;
						    $('#msmeFilePara').html('<span><input type="hidden" id="MSMEFileItem" name="MSMEFileItem" value="'+fileNameTemp+'"><input type="hidden" name="upMSMEItemNo" value="'+upMSMEItemNo+'"><a href="javascript:downloadFile(\'O\',\''+upMSMEItemNo+'\',\''+fileNameTemp+'\',\''+MSMEDoc+'\')">'+fileNameTemp+'</a></span>');
						   debugger;
					      }
					      alert("File has been uploaded successfully");
					      $('#uploadMSMEMod').modal('hide');
					  },
					  error: function(msg) {
					     $('#uploadMSMEbutton').show(); 	
					     $('#loadingMSMEInd').hide();	
					     alert("Couldn't upload file");
					  }
		     });
		     $( "#uploadDialogBtn").button().on( "click", function() {
		        document. getElementById("uploadForm").reset();
		        itemCnt = itemCnt+1;
		        $("#upItemNo").val(itemCnt);
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
			      //alert(msg);
			      if(msg.split("##")[0] === 'true')
			      {
			      	  var upItemNo = $('#upItemNo').val();
			      	  var stdUsed = $('#stdUsed').val();
			      	  var certName = $('#certName').val();
			      	  var certYr = $('#certYr').val();
			      	  var certNumber = $('#certNumber').val();
			      	  var validityDate = $('#validityDate').val();
			      	  var fileNameTemp = msg.split("##")[1];
			      	   $('#uploadTable').append('<tr><td><input type="hidden" name="upItemNo" value="'+upItemNo+'"><input type="hidden" class="stdUsed" name="stdUsed" value="'+stdUsed+'">'+stdUsed+'</td><td><input type="hidden" name="certName" value="'+certName+'">'+certName+'</td><td><input type="hidden" name="certYr" value="'+certYr+'">'+certYr+'</td><td><input type="hidden" name="certNumber" value="'+certNumber+'">'+certNumber+'</td><td><input type="hidden" name="validityDate" value="'+validityDate+'">'+validityDate+'</td><td><input type="hidden" name="fileItem" value="'+fileNameTemp+'"><a href="javascript:downloadFile(\''+upItemNo+'\',\''+fileNameTemp+'\')">'+fileNameTemp+'</a></td><td width="5%"><span onclick="javascript:deleteFile(this,\''+upItemNo+'\',\''+fileNameTemp+'\')" class="fa fa-trash fa-lg" style="margin-left: 25%;"></span></td></tr>')
			      }
			      alert("File has been uploaded successfully");
			      $('#uploadMod').modal('hide');
			  },
			  error: function(msg) {
			     $('#uploadbutton').show(); 	
		       	     $('#loadingInd').hide();	
			     alert("Couldn't upload file");
			  }
		     });
		  });
		$(document).ready(function() {
		
				$("#myForm").validationEngine();
				$("#uploadForm").validationEngine();
				$('#validityDate').datepicker({
				      format:'dd/mm/yyyy',
				      autoclose: true
    				});
 
		
			});
		function deleteFile(thisObj,upItemNo,fileName)
		{
			itemCnt = itemCnt-1;
			var upDocId 	= $('#upDocId').val();
			var upDocType 	= $('#upDocType').val();
			$.ajax({
			    url: 'ezDeleteFileTemp.jsp',
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
		function funChk() {
			var validity = $("#validityDate").val();
			var validDate = new Date(validity);		
				 var today = new Date(); 
				        
				        var dd = today.getDate(); 
				        var mm = today.getMonth() + 1; 
				  
				        var yyyy = today.getFullYear(); 
				        if (dd < 10) { 
				            dd = '0' + dd; 
				        } 
				        if (mm < 10) { 
				            mm = '0' + mm; 
				        } 
       			 today = dd + '/' + mm + '/' + yyyy; 
       			 console.log(validity+":;"+today+":;;;");
       			 console.log(typeof validity+":;"+typeof today+":;;;");
       			 var validityDate = Date.parseDate(validDate, "dd/mm/yyyy");
			 var todayDate = Date.parseDate(today, "dd/mm/yyyy");
				if (validityDate < todayDate)
				{
					alert("The Date must be Bigger or Equal to today date")
					return false;
				}
				    return true;
		}							
			
		function deleteKYCFile(thisObj,upItemNo,fileName)
		 {
			itemKYCCnt = itemKYCCnt-1;
			var upDocId 	= $('#upDocId').val();
			var upDocType 	= $('#upDocType').val();
			$.ajax({
			    url: 'ezDeleteFileTemp.jsp',
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
 		var sessionActMin = 0;
		setInterval(function() {
		 if(sessionActMin < 1200)
		 {
			 $.get("ezKeepSessionActive.jsp?t="+new Date().getTime(), function(data, status){
			    sessionActMin++;
			    console.log(sessionActMin);			   
			  });
		  }
		 },1000 * 60 * 1); // where X is your every X minutes
		
		function validphone(paramId , paramVal)
				{
				 var span=paramVal;
				 var char1 = document.getElementById(paramId).value;
				 var regx1 = /^[0-9-+()]*$/;
				 document.getElementById("errmsg_"+span).innerHTML="";
			           if (!regx1.test(char1))
			           {
			          	 document.getElementById("errmsg_"+span).innerHTML="Invalid Phone Number";
			           }
			           else
			           {
			                 document.getElementById("errmsg_"+span).innerHTML=""
			           }
	         }
	         
	         function validemail(paramId1 ,paramVal1 ) 
		 {
		  var span =paramVal1;
		  var email = document.getElementById(paramId1).value;
		  var x = email.length;
		  if(x<=0)
		  {
		   document.getElementById("erremail_"+span).innerHTML="";
		  }
		  else
		  {
		  var regx = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
		  document.getElementById("erremail_"+span).innerHTML="";
		  if (!regx.test(email))
		   {
		     document.getElementById("erremail_"+span).innerHTML="Email Not Valid";
		   }
		   else
		   {
		     document.getElementById("erremail_"+span).innerHTML="";
                   }
                   }
		}
		
		var x=document.getElementById("compCountry").value;
				x=x.toUpperCase();
				var y="INDIA";
				 if(x==y)
				 {
				 indRadio();
		 }
		
		
		function indRadio()
			         {
			         
			         var x=document.getElementById("compCountry").value;
			         x=x.toUpperCase();
			         var y="INDIA";
			         if(x==y)
			         {
			      
					 document.getElementById('ind1').style.visibility="visible";
					 document.getElementById('ind2').style.visibility="visible";
					 document.getElementById('ind3').style.visibility="visible";
			     	 

			         }
			         else
			         {
		        	        document.getElementById('ind1').style.visibility="collapse";
		        	        document.getElementById('ind2').style.visibility="collapse";
		        	        document.getElementById('ind3').style.visibility="collapse";
		        	        
			         }
			         }
		function EntrprseCmpnyFun()
		{
 		       var EntrprseCmpnyVal1 =document.getElementById("MicroRd").value;
 		       var EntrprseCmpnyVal2 =document.getElementById("SmallRd").value;
 		       var EntrprseCmpnyVal3 =document.getElementById("MediumRd").value;
 		       var msmenum = document.getElementById("msmenum");


 		       if(EntrprseCmpnyVal1=="Micro"||EntrprseCmpnyVal2=="Small"||EntrprseCmpnyVal3=="Medium")
 		       {
 		        
			document.getElementById('ind4').style.visibility="visible";
			document.getElementById('ind5').style.visibility="visible";
			msmenum.classList.add("validate[required]");
 		       }
 		       
 		       else
 		       {
 		       document.getElementById('ind4').style.visibility="collapse";
		       document.getElementById('ind5').style.visibility="collapse";
 		       }
 		      
 		        

		}
		function EntrprseCmpnyFun1()
		{
		   var EntrprseCmpnyVal4 =document.getElementById("LargeRd").value;
 		   var EntrprseCmpnyVal5 =document.getElementById("NotApRd").value;
		if(EntrprseCmpnyVal4=="Large"||EntrprseCmpnyVal5=="notApp")
		{
		if(EntrprseCmpnyVal4=="Large")
		{
		alert("You are not availing any benefit under MSME Act");
		}
		   document.getElementById('ind4').style.visibility="collapse";
		   document.getElementById('ind5').style.visibility="collapse";
		    msmenum.classList.remove("validate[required]");

		 }
		}
		/*function MsmeUpload()
		{
		var MsmeUpload =document.getElementById("MSMEFileItem").value;
		if(MsmeUpload!="null")
		{
		return MsmeUpload;
		}
		else
		{
		alert("Please upload MSME Certificate");
		return MsmeUpload;
		}
		}*/
		
		function handleChange(event) {
			  event.preventDefault();
			  debugger;
			  var data = new FormData(event.target.form);

			  var value = Object.fromEntries(data.entries());

			  console.log({ value });
		}	         

	</script>
  </body>
</html>







