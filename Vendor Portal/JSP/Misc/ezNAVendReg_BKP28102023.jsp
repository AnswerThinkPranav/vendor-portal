<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<%@ page import="ezc.ezutil.*,java.util.*,java.text.*,java.math.BigDecimal,java.math.RoundingMode" %>
<%@ include file="iVendorDetails.jsp" %>
<%@ include file="ezGetUserAuthDefaults.jsp"%>
<%@ include file="ezHeader.jsp"%>
<jsp:useBean id="esManager" class="ezc.client.EzSystemConfigManager" scope="session"/>
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<%@ include file="../Misc/ezCommonMethods.jsp"%>
<%@ include file="../Misc/ezWFCommonMethods.jsp"%> 
<%@ include file="ezCountryHT.jsp"%> 
<%@ include file="../../../Includes/JSPs/Misc/iDocComments.jsp"%> 
<%@ include file="../../../Includes/JSPs/Inbox/iGetUploadList.jsp"%>  
<%@ include file="iViewVendRegDetails.jsp"%>   
<%@ include file="iViewVendRegHeader.jsp"%>  
<%@ include file="../../../../EzVendor/Includes/JSPs/Labels/iTempVend_Labels.jsp"%>

<%

	session.putValue("VEND_CREATE",""); 
	ezc.ezparam.ReturnObjFromRetrieve retUploadDocs	  =	null;	 
	miscTableRow.setQuery("select * from ezc_upload_document  WHERE EUD_DOC_NO='"+docId+"' ");
	miscTable.appendRow(miscTableRow);
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscTable);
	Session.prepareParams(mainParams);
	try
	{
		retUploadDocs=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);
		//out.print(miscTableRow.getQuery());
	}
	catch(Exception e)
	{
		log("Exception in getting Purchase Group List>>>>>"+e);
	}
	int retUploadDocsCnt = 0; 
	if(retUploadDocs != null)
	retUploadDocsCnt = retUploadDocs.getRowCount();	
	if(vendName == null || "null".equals(vendName) || "".equals(vendName))
		vendName = hdrName;
	if(PAN_Number == null || "null".equals(PAN_Number) || "".equals(PAN_Number))
		PAN_Number = hdrPan;
	//if(INCO_Terms == null || "null".equals(INCO_Terms) || "".equals(INCO_Terms))
		//INCO_Terms = "EXW";
	//if(country == null || "null".equals(country) || "".equals(country))
		//country = "IN";	
	if(serachTerm == null || "null".equals(serachTerm) || "".equals(serachTerm))
		serachTerm = vendName;
		
	ReturnObjFromRetrieve retQry=ezMiscSelect(Session,"select * from ezc_qcf_comments where EQC_CODE='"+docId+"' and EQC_TYPE='QUERY' and EQC_EXT2='VNR' and EQC_QUERY_MAP='0'");
	int retQryCnt=0;
	if(retQry != null)
		retQryCnt= retQry.getRowCount();
	
	String regDesc ="";
	ReturnObjFromRetrieve retRegDesc=ezMiscSelect(Session,"select distinct EMKV_VALUE1,EMKV_VALUE from ezc_master_key_values where EMKV_MASTER_TYPE='V_COUNTRY' and EMKV_KEY='"+country+"' and EMKV_VALUE1='"+State+"'");
	
	if(retRegDesc != null)
		regDesc= retRegDesc.getFieldValueString(0,"EMKV_VALUE");		
		
		
%>

<Html>
<Head>
<meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge"> 
    <title>EzCommerce Suite</title>
    
    <meta http-equiv="cache-control" content="max-age=0" />
    <meta http-equiv="cache-control" content="no-cache" />
    <meta http-equiv="expires" content="0" />
    <meta http-equiv="expires" content="Tue, 01 Jan 1990 12:00:00 GMT" />

    <!-- Bootstrap 3.3.5 -->
    <link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/datepicker.css">

    <!-- Font Awesome -->
    <!--<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">-->
    
    <!-- Ionicons -->
    <!--<link rel="stylesheet" href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css">-->
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
    <link rel="stylesheet" href="../../../../EzCommon/Library/plugins/jQueryUI/jquery-ui.css">
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
    /*a {
        color: #337ab7 !important;
        text-decoration: none !important;
	}*/
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
	text-align: -webkit-center;
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
	
	line-height: 2.4 !important;

    }
   input[type="text"]
   {
       font-size:13;
       font-family: -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif,"Apple Color Emoji","Segoe UI Emoji","Segoe UI Symbol";
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
input[type="radio"][disabled]{background-color:blue;}

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

td
{
	font-family: -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif,"Apple Color Emoji","Segoe UI Emoji","Segoe UI Symbol";
	    font-weight: 500;
	    font-size: 13;
    line-height: 1.4 !important;
}

</style>	
</Head>

<body>
<form name="myForm" id="myForm">
<div class="content-wrapper">
<!-- Content Header (Page header) --> 
<section class="content-header">
   <h1>
      New Vendor Registration
   </h1>
</section>
<!-- Main content -->  

<input type="hidden" name="vendName" id="vendName" value="<%=vendName%>">
<input type="hidden" name="docId" id="docId" value="<%=docId%>">
<input type="hidden" name="actionSts" id="actionSts" value="">
<input type="hidden" name="purOrg" value="<%=purOrg%>">
<input type="hidden" name="venWFPlant" value="<%=venWFPlant%>">
<input type="hidden" name="venWFCategory" value="<%=venWFCategory%>">
<input type="hidden" name="compCode" value="<%=compCode%>">
<input type="hidden" name="category" value="VNR">
<input type="hidden" name="qcfNo" value="<%=docId%>">
<input type="hidden" name="commentType">
<input type="hidden" name="wfTemplate" value="<%=wfTemplate%>">
<input type="hidden" name="wfCurStep" value="<%=wfCurStep%>">
<input type="hidden" name="wfNextPart" value="<%=wfNextPart%>">

<%	 String selectedMr	="";
	 String selectedMs	="";
	 String Selected 	="";
	 String isSuccess       = "N";
 	 String userInput	= request.getParameter("userID");
 	 String dispMSME="none";
	 
	int year = Calendar.getInstance().get(Calendar.YEAR);	 
	String sessionId = session.getId();
	
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
		<div>
		  <ul>
		    <li><a href="#tabs-1">Vendor Information</a></li>
		    <li><a href="#tabs-2">Commercial Information</a></li>
		    <li><a href="#tabs-3">Financial Information</a></li> 
		    <li><a href="#tabs-4">Attachments</a></li>
		    <li><a href="#tabs-5">Bank Details(ACH/Wire Transfer)</a></li>
		    
		  </ul>
		</div>

		
		  <div id="tabs-1">
		  <input type="hidden" name="tabVal1" id="tabVal1" value="" >
		    <table class="table table-bordered">
		    	<Tr>
				<Th align="left">Title <font color="red">*</font></Th> 
				<Td>
					<select name="title" class="form-control select2 validate[required]" data-errormessage-value-missing="Please Select Title" >
					  <option value="" selected>--select--</option>
					  <option value="Company">Company</option>
					  <option value="Mr.">Mr.</option>
					  <option value="Ms.">Ms.</option>
					  <option value="Mr. and Mrs.">Mr. and Mrs.</option>
					  <option value="Physician">Physician</option>
					  
					</select>
				</Td>
			</Tr>
			<Tr>
		    		<Th align="left">Vendor Name<font color="red">*</font></Th> 
		    		<Td>
		    			<input type="text" class="form-control input-sm validate[required]" data-errormessage-value-missing="Please Enter vendor Name"   name="vendName"  value="<%=checkNull(vendName)%>" maxlength="100">

		    		</Td>
		    	</Tr>
		    	<Tr>
				<Th align="left">Search Term<font color="red">*</font></Th>
				<Td>
					<input type="text" class="form-control input-sm validate[required]" data-errormessage-value-missing="Please Enter Search term"  name="searchTerm"  value="<%=checkNull(serachTerm)%>" maxlength="100">

				</Td>	    		 
			</Tr>
			<!--<Tr>
				<Th align="left">C/O Name</Th>
				<Td>
					<input type="text" class="form-control input-sm "   name="careOf_Name" value="<%=checkNull(careOf)%>" maxlength="50">

				</Td>
								    		 
			</Tr> -->
		    </table>
		    <div class="row" id="tabContents">
			<!-- left column -->
			<div class="col-md-12">
				<div class="box box-primary">
					<div class="box-header with-border">
						
						<h2 class="box-title">Address</h2>
					</div>
					<div class="box-body">
						<table class="table table-bordered">
						 <tr>
							    <th align="left">Address Line1<font color="red">*</font></th>
							    <td>
								<input type="text" class="form-control validate[required]" name="addrsLine1" value="<%=checkNull(AddressLine1)%>" maxlength="50">
							    </Td>
							    <th align="left">District</th>
							    <td>
								<input type="text" class="form-control" name="districtName" value="<%=checkNull(District)%>" maxlength="50">
							    </Td>
							   <th align="left">Phone Number<font color="red">*</font> </th>
							    <td>
								<input type="text" class="form-control validate[required]" data-errormessage-value-missing="Please Enter Phone Number" name="phoneNum" value="<%=checkNull(PhoneNumber)%>" minlength="15" maxlength="15" onKeyPress="return onlyNumbers()">
							    </Td>
						</tr>
						<tr>

							    <th align="left">Address Line2</th>
							    <td>
								<input type="text" class="form-control" name="addrsLine2" value="<%=checkNull(AddressLine2)%>" maxlength="50">
							    </Td>
							    <th align="left">Zip Code <font color="red">*</font></th>
							    <td>
								<input type="text" class="form-control validate[required]" data-errormessage-value-missing="Please Enter Zip Code" name="postalCode" value="<%=checkNull(PostalCode)%>" maxlength="50">
							    </Td>
							    <th align="left">Alternate Phone Number</th>
							    <td>
								<input type="text" class="form-control " name="altPhoneNum" value="<%=checkNull(AlternatePhoneNumber)%>" minlength="15" maxlength="15" onKeyPress="return onlyNumbers()" >
							    </Td>
						</tr>
						<tr>
 
							    <th align="left">Address Line3</th>
							    <td>
								<input type="text" class="form-control" name="addrsLine3" value="<%=checkNull(AddressLine3)%>" maxlength="50">
							    </Td>
							    
							    <th align="left">Country <font color="red">*</font></th>
							    <td>
								<Select name="country" id="country"  onchange="funSelCountry()" class="form-control select2">
									<option value="">--Select Country--</option>
<%
									Set set = cuntLHM.entrySet(); 
									Iterator i = set.iterator();
									while(i.hasNext()) 
									{
										Map.Entry me = (Map.Entry)i.next();
										cntVal=(String)me.getKey();
										chksel="";
										if(cntVal.equals(country))chksel="selected";
%>
										<option value="<%=me.getKey()%>" <%=chksel%> ><%=me.getValue()%></option>
<%

									}
%>
								</select>
							    </Td>
							    <th align="left">Mobile Number<font color="red">*</font></th>
								<td>
								<input type="text" class="form-control validate[required]" data-errormessage-value-missing="Please Enter Mobile Number" name="mobNum" value="<%=checkNull(MobileNumber)%>" minlength="15" maxlength="15" onKeyPress="return onlyNumbers()" >
								</Td>
						</tr>
						<tr>
						<th align="left">Address Line4</th>
							<td>
							<input type="text" class="form-control" name="addrsLine4" value="<%=checkNull(AddressLine4)%>" maxlength="50">
							</Td>
							
							

							    <th align="left">City<font color="red">*</font></th>
							    <td>
								<input type="text" class="form-control input-sm validate[required]" data-errormessage-value-missing="Please Enter City" name="city" value="<%=checkNull(City)%>" maxlength="50">
							    </Td>
							    <th align="left">Mobile Number</th>
							    <td>
								<input type="text" class="form-control input-sm " name="altMobNum" value="<%=checkNull(AlternateMobileNumber)%>" minlength="15" maxlength="15" onKeyPress="return onlyNumbers()" >
							    </Td>
						</tr>
						<tr>
							   <th align="left">Address Line5</th>
							    <td>
								<input type="text" class="form-control" name="addrsLine5" value="<%=checkNull(AddressLine5)%>" maxlength="50">
							    </Td>
							    <th align="left">Region <font color="red">*</font></th>
							    <Td id="REGION">
								<input type="text" class="form-control validate[required]" data-errormessage-value-missing="Please Enter Region" name="state" value="<%=checkNull(State)%>" readonly>
							    </Td>
							    <th align="left">Fax</th>
							    <td>
								<input type="text" class="form-control" name="fax" value="<%=checkNull(fax)%>" maxlength="50">
							    </Td>
						</tr>
						<tr>
							   <th align="left">Email Address1<font color="red">*</font></th>
							    <td>
								<input type="text" class="form-control validate[required]" data-errormessage-value-missing="Please Enter Address" name="email_1" value="<%=checkNull(EamilAddress1)%>" maxlength="50">
							    </Td>
						<th align="left">Email Address2</th>
						<td>
						<input type="text" class="form-control" name="email_2" value="<%=checkNull(EamilAddress2)%>" maxlength="50">
						</Td>
						<th align="left">Website</th>
						<td>
						<input type="text" class="form-control" name="website" value="<%=checkNull(webSite)%>" maxlength="50">
						</Td>						
							   
						</tr>
						<Tr>
							<Th colspan="2" align="left"> Preferred Contact Method<font color="red">*</font></Th>
							
							<Td colspan="4">
								<div >
<%
									Set set1 = conMethodHT.entrySet();
									Iterator i1 = set1.iterator();
									while(i1.hasNext()) 
									{
										Map.Entry me1 = (Map.Entry)i1.next();
										cntVal=(String)me1.getKey();
										chksel="";
										if(conMethodVec.contains(cntVal)) chksel="checked";
%>
											<input type="checkbox"  name="conMethod" class="form-check-input validate[required]"  data-errormessage-value-missing="Please Check Preferred Contact Method" value="<%=me1.getKey()%>" <%=chksel%> >&nbsp;&nbsp;&nbsp;<%=me1.getValue()%>&nbsp;&nbsp;&nbsp;&nbsp;	
<%
									}
%>	
									<input type="text" name="othConMethod" value="<%=checkNull(othConMethod)%>" maxlength="50" style="width:30%;"></input> 
								</div>
							</Td>					

						</Tr>						
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
						<h2 class="box-title">Contacts</h2> 
					</div>
					<div class="box-body">
						<table id="contactTab" class="table table-bordered">
							<tr>

								    <th align="left">SR No</th>
								    <Th align="left">Title</Th> 
								    <th align="left">Main Contact Person(s) </th>
								    <th align="left">Designation</th>
								    <th align="left">Phone Number</th>
								    <th align="left">Email</th>
								    
								    
							</tr>
<%
 				
							int numVend = 0;
							if("N".equals("") && !"REAPP".equals(""))
								numVend = retVendItemsCnt1;

							else if("N".equals("")&& "REAPP".equals("")&& retVendItemsCnt1==0)
								numVend = 2;
							else if("N".equals("")&& "REAPP".equals("")&& retVendItemsCnt1!=0)
							numVend = retVendItemsCnt1;
							
							else
								numVend=1;
							
							int lineItemNo = 0; 
							for(int m=0;m<numVend;m++)
							{
							      				         
							lineItemNo = (m+1); 
%>  
								<tr>
									<td align="center">
										<%=lineItemNo%>
										<input type="hidden" name="tLineNumber" value="" >
									</td>
									<td>
										<select name="contactTitle_<%=lineItemNo%>" class="form-control">
											<option value="" selected>--select--</option>
											<option value="Mr.">Mr.</option>
											<option value="Ms.">Ms.</option>
											<option value="Mr. and Mrs.">Mr. and Mrs.</option>
											
										</select>
									</td>
									<td>
										<input type="text" class="form-control" id="contactName_<%=lineItemNo%>" name="contactName_<%=lineItemNo%>" value="<%=checkNull(contactMap.get("contactName_"+lineItemNo))%>" maxlength="30">
									</td>
									<td>
										<input type="text" class="form-control" id="contactDesgtn_<%=lineItemNo%>" name="contactDesgtn_<%=lineItemNo%>" value="<%=checkNull(contactMap.get("contactDesgtn_"+lineItemNo))%>" maxlength="30">
									</td>
									<td>
										<input type="text" class="form-control" onkeyup="validphone('contactPhone_<%=lineItemNo%>',<%=lineItemNo%>)" id="contactPhone_<%=lineItemNo%>" name="contactPhone_<%=lineItemNo%>" value="<%=checkNull(contactMap.get("contactPhone_"+lineItemNo))%>" minlength="15" maxlength="15" onKeyPress="return onlyNumbers()" ><span id="errmsg_<%=lineItemNo%>" style="color:red"></span>
									</td>									
									<td>
										<input type="text" class="form-control" id="contactEmail_<%=lineItemNo%>" name="contactEmail_<%=lineItemNo%>" value="<%=checkNull(contactMap.get("contactEmail_"+lineItemNo))%>" maxlength="50">
									</td>									    
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
		  </div>
 
		  <div id="tabs-2" >
		  <input type="hidden" name="tabVal2" id="tabVal2" value="" >

			<table class="table table-bordered">
				<Tr>
					<Th align="left">Type of Entity/Organization <font color="red">*</font></Th>
					<Td colspan="3">
						<div class="form-check" style="padding-top:12px">
						
<%
									Set set2 = constTypeHT.entrySet();
									Iterator i2 = set2.iterator();
									
									while(i2.hasNext()) 
									{
										Map.Entry me2 = (Map.Entry)i2.next();
										cntVal=(String)me2.getKey();
										chksel="";
										chkOthSel="";
										
										if("OTH".equals(typeOfOrg))
										{
											chkOthSel="checked";
										}	
										if(!"OTH".equals(cntVal))
										{
										
											if(cntVal.equals(typeOfOrg))chksel="checked";
%>
												<input type="radio" name="typeOfOrg"  class="form-check-input validate[required]"  data-errormessage-value-missing="Please Select Type of Entity/Organization"  value="<%=me2.getKey()%>" <%=chksel%>>&nbsp;<%=me2.getValue()%>&nbsp;
<%
										}
									}
%>									
								</div>	
								<br>
								<div class="form-check">
									<input type="radio" name="typeOfOrg"  class="form-check-input"  value="OTH" <%=chkOthSel%>>&nbsp;Other&nbsp;
									<input type="text" name="othCompType" value="<%=checkNull(othCompType)%>" maxlength="50" style="width:30%;"></input>
								</div>	
					</td>
					
					</Tr>
					<Tr>
					<Th align="left">Type of Supplier <font color="red">*</font></Th>
					<Td colspan="3">
						<div>
<%						
							set = supTypeHM.entrySet();
							i = set.iterator();
							while(i.hasNext()) 
							{	
								Map.Entry me = (Map.Entry)i.next();
								cntVal=(String)me.getKey();
								chksel="";
								chkOthSel="";
								if(supTypeVec.contains("OTH")) chkOthSel="checked";
								
								if(!"OTH".equals(cntVal))
								{
									if(supTypeVec.contains(cntVal)) chksel="checked";
%>
										<input type="checkbox"  name="supType" class="form-check-input validate[required]"  data-errormessage-value-missing="Please Select Type of Supplier"  value="<%=me.getKey()%>" <%=chksel%> >&nbsp;&nbsp;&nbsp;<%=me.getValue()%>&nbsp;&nbsp;&nbsp;	
<%
								}
							}
%>							
						</div>	
						<br>
						<div>
							<input type="checkbox" name="supType" value="OTH" <%=chkOthSel%>>&nbsp;&nbsp;&nbsp;Other&nbsp;		
							<input type="text" name="othSupType" value="<%=checkNull(othSupType)%>" maxlength="50" style="width:30%;"></input>
						</div>
					</Td>					

				</Tr>
				<Tr>
					<Th align="left">Type of Vendor <font color="red">*</font></Th>
					<Td colspan="3">
						<div >
<%						
							set = vendorTypeHM.entrySet();
							i = set.iterator();
							while(i.hasNext()) 
							{	
								Map.Entry me = (Map.Entry)i.next();
								cntVal=(String)me.getKey();
								chksel="";
								if(vendorTypeVec.contains(cntVal)) chksel="checked";
%>						
									<input type="checkbox" name="vendorType" class="form-check-input validate[required]"  data-errormessage-value-missing="Please Select Type of Vendor"  value="<%=me.getKey()%>" <%=chksel%>>&nbsp;&nbsp;&nbsp;<%=me.getValue()%>&nbsp;&nbsp;&nbsp;		
<%
							}
%>								
						</div>
					</Td>					

				</Tr>
				<Tr>
					<Th align="left">Purchase Order Currency <font color="red">*</font> </Th>
					<Td>
						
						<Select name="purOrdCurr" id="purOrdCurr" class="form-control select2 validate[required]" data-errormessage-value-missing="Please Select Currenncy">	
								<option value="">--Select currency--</option>
<%
								set = curHt.entrySet(); 
								i = set.iterator();
								while(i.hasNext()) 
								{
									Map.Entry me = (Map.Entry)i.next();
									cntVal=(String)me.getKey();
									chksel="";
									if(cntVal.equals(PurchaseOrderCurrency))chksel="selected";
%>
									<option value="<%=me.getKey()%>" <%=chksel%> ><%=me.getValue()%></option>
<%

								}
%>
						</select>
					</Td>				
					<Th align="left"> Payment Terms <font color="red">*</font></Th>
					<Td>
								<Select name="paymntTerms" id="paymntTerms" class="form-control select2 validate[required]" data-errormessage-value-missing="Please Select Payment Terms">	
										<option value="">--Select Payment terms--</option>
<%
									for(int j=0;j<pmntTmCnt;j++)
									{	
										chksel="";
										String payTm=pmntObj.getFieldValueString(j,"EMKV_KEY").trim();
										if(payTm.equals(Payment_Terms))chksel="selected";
%>				
										<option value="<%=pmntObj.getFieldValueString(j,"EMKV_KEY").trim()%>" <%=chksel%>><%=payTm%>--><%=pmntObj.getFieldValueString(j,"EMKV_VALUE")%></option>
<%				
									}
%>					
								</select>
					</Td>
											
				</Tr>
				<Tr>
					<Th align="left">Place of Delivery<font color="red">*</font> </Th>
					<Td>
						<input type="text" class="form-control validate[required]"  id="INCO_Terms2" name="INCO_Terms2"  value="<%=checkNull(INCO_Terms2)%>" maxlength="100"  data-errormessage-value-missing="Please Enter Place of Delivery">
					</Td>				

					<Th align="left"> Inco Terms<font color="red">*</font></Th>
					<Td>
						<Select name="INCO_Terms" id="INCO_Terms" class="form-control select2">	
								<option value="">--Select inco terms--</option>
<%
									for(int j=0;j<incoTmCnt;j++)
									{	
										chksel="";
										String incoTm=incoObj.getFieldValueString(j,"EMKV_KEY").trim();
										if(incoTm.equals(INCO_Terms))chksel="selected";
%>				
										<option value="<%=incoObj.getFieldValueString(j,"EMKV_KEY").trim()%>" <%=chksel%>><%=incoTm%>--><%=incoObj.getFieldValueString(j,"EMKV_VALUE")%></option>
<%				
									}
%>					
						</select>
					</Td>
				</Tr>	
				
			</table>
				</td>
			</Tr>
		    	</table>
		


			<table class="table table-bordered" style="display:none"  id="isCountryIndia">
				<Tr style="width:31%;">
					<Th align="left" style="width:34%;">Copy of PAN card Attached</Th>
					<Td>
						<select class="form-control select2 validate[required]" id="PAN_Attach" name="PAN_Attach" >
							<option value="" selected>--select--</option>
							<option value="Y">Yes</option>
							<option value="N">No</option>
						</select>
					</Td>							
				
					<Th align="left"> Legal Name as per PAN <font color="red">*</font></Th>
					<Td>
						<input type="text" class="form-control"  id="PAN_Name" name="PAN_Name"  value="<%=checkNull(PAN_Name)%>" maxlength="100">
					</Td>								
				</Tr>

				<Tr>
					<Th align="left"> PAN Number <font color="red">*</font></Th>
					<Td>
						<input type="text" class="form-control"  id="PAN_Number" name="PAN_Number"  value="<%=checkNull(PAN_Number)%>" maxlength="100">
					</Td>
					<td><button type="button"  id="VENDREGPAN" value="VENDREGPAN"  class="btn btn-primary uploadDialogBtn" ><i class="fa fa-upload"></i>&nbsp;Upload</button></td>
					<td>
					 <table class="VENDREGPANTABLE table  table-bordered dt-responsive nowrap" id="VENDREGPANTABLE" name="VENDREGPANTABLE" >
<%
		Vector itemIndPan=retUploadDocs.where(new String[]{"EUD_DOC_TYPE"},new String[]{"VENDREGPAN"});
		for(int v1=0;v1<itemIndPan.size();v1++)
		{	
			int index1 = -1;
			try{
			index1 = Integer.parseInt(itemIndPan.get(v1)+"");	}
			catch(Exception e){}				
			if(index1>=0){
			
%>	
		<tr>
			<td>
				<input type="hidden" name="fileItem" value="<%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%>" >
				<a href="javascript:downloadFile('O','<%=retUploadDocs.getFieldValueString(index1,"EUD_ITEM_NO")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_DOC_TYPE")%>')"><%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%></a>
			</td>
			<td>
				<span onclick="javascript:deleteFile(this,'<%=retUploadDocs.getFieldValueString(index1,"EUD_ITEM_NO")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_DOC_TYPE")%>')" class="fa fa-trash fa-lg deleteBtn" style="margin-left: 25%;"></span>
			</td>
		</tr>
<%
		}
	}
%>
					</table>
					</td>					
				
				</Tr>
				<Tr>
					<Th align="left"> GST Status of Firm <font color="red">*</font></Th>
					<Td>
						<Select name="gstVendorClas" id="gstVendorClas" class="form-control select2 " data-errormessage-value-missing="Please Select GST Staus of Firm ">
						<!--<option value="">--Select--</option>-->
								
<%
								set = gstClassHt.entrySet(); 
								i = set.iterator();
								while(i.hasNext()) 
								{
									Map.Entry me = (Map.Entry)i.next();
									cntVal=(String)me.getKey();
									chksel="";
									if(cntVal.equals(GSTVendorClassification))chksel="selected";
%>
									<option value="<%=me.getKey()%>" <%=chksel%> ><%=me.getValue()%></option>
<%

								}
%>
						</select>
						
					</Td>
					<Th align="left"> Type of Registration <font color="red">*</font></Th>
					<Td>
						<Select name="gstType" id="gstType" class="form-control select2" data-errormessage-value-missing="Please Select Type of Registration">
						<option value="">--Select--</option>
								
<%
								set = gstTypeHt.entrySet(); 
								i = set.iterator();
								while(i.hasNext()) 
								{
									Map.Entry me = (Map.Entry)i.next();
									cntVal=(String)me.getKey();
									chksel="";
									if(cntVal.equals(gstType))chksel="selected";
%>
									<option value="<%=me.getKey()%>" <%=chksel%> ><%=me.getValue()%></option>
<%

								}
%>
						</select>
						
					</Td>							
				</Tr>
				<Tr>
					<Th align="left"> GSTIN Number of Business </Th>
					<Td>
						<input type="text" onchange="validateGST()" class="form-control"   id="gst_Number" name="gst_Number"  value="<%=checkNull(GST_Number)%>" maxlength="100" >
					</Td>
					<td><button type="button"   id="VENDREGGST" value ="VENDREGGST"  class="btn btn-primary uploadDialogBtn" ><i class="fa fa-upload"></i>&nbsp;Upload</button></td>
					<td>
					 <table class="VENDREGGSTTABLE table  table-bordered dt-responsive nowrap" id="VENDREGGSTTABLE" name="VENDREGGSTTABLE" >
<%
	Vector itemIndGst=retUploadDocs.where(new String[]{"EUD_DOC_TYPE"},new String[]{"VENDREGGST"});
	for(int v1=0;v1<itemIndGst.size();v1++)
	{	
		int index1 = -1;
		try{
		index1 = Integer.parseInt(itemIndGst.get(v1)+"");	}
		catch(Exception e){}				
		if(index1>=0){
		
%>
		<tr>
			<td>
				<input type="hidden" name="fileItem" value="<%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%>" >
				<a href="javascript:downloadFile('O','<%=retUploadDocs.getFieldValueString(index1,"EUD_ITEM_NO")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_DOC_TYPE")%>')"><%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%></a>
			</td>
			<td>
				<span onclick="javascript:deleteFile(this,'<%=retUploadDocs.getFieldValueString(index1,"EUD_ITEM_NO")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_DOC_TYPE")%>')" class="fa fa-trash fa-lg deleteBtn" style="margin-left: 25%;"></span>
			</td>
		</tr>
<%
		}
	}
%>
					</table>
					</td>					

				</Tr>
						

		    	</table>
		    	</DIV>
				
		
		  <div id="tabs-3">
		  <input type="hidden" name="tabVal3" id="tabVal3" value="" >
		<table class="table table-bordered">
<%
		//if("IN".equals(country))
		//{
%>
		<!--<Tr id='isCountrystatus' style="display:"> 
			<Th align="left">Status of Vendor  <font color="red">*</font> </Th>
			<Td colspan="3">
				<div class="form-check">
<%

						set = msmeTypeHM.entrySet(); 
						i = set.iterator();
						while(i.hasNext()) 
						{
							Map.Entry me = (Map.Entry)i.next();
							cntVal=(String)me.getKey();
							chksel="";
							if(cntVal.equals(MSME_Type))chksel="checked";
							if("1".equals(MSME_Type) || "5".equals(MSME_Type) || "9".equals(MSME_Type))
								dispMSME="";
%>									
								<input type="radio" name="msme_Type"  class="form-check-input validate[required]" data-errormessage-value-missing="Please Select Staus of Vendor"  value="<%=me.getKey()%>" onChange="showMSME(this)" <%=chksel%> >&nbsp;&nbsp;&nbsp;<%=me.getValue()%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<%
						}
			//}			
%>										
				</div>
			</Td>
		</Tr>
		
		<Tr id="msmeInfo" style="display:<%=dispMSME%>;">
							<Th align="left">MSME Registration Number</Th>
							<Td width="30%">
								<input type="text" class="form-control"   id="msme_Udyog_AdhrNo" name="msme_Udyog_AdhrNo"  value="<%=checkNull(MSME_Udyog_Aadhaar)%>" maxlength="50">
							</Td>
							<td><button type="button"  id="VENDREGMSME" value="VENDREGMSME"  class="btn btn-primary uploadDialogBtn" ><i class="fa fa-upload"></i>&nbsp;Upload</button></td>
							<td>
							<table class="VENDREGMSMETABLE table  table-bordered dt-responsive nowrap" id="VENDREGMSMETABLE" name="VENDREGMSMETABLE" >
		<%
				Vector itemIndMSME=retUploadDocs.where(new String[]{"EUD_DOC_TYPE"},new String[]{"VENDREGMSME"});
				for(int v1=0;v1<itemIndMSME.size();v1++)
				{	
					int index1 = -1;
					try{
						index1 = Integer.parseInt(itemIndMSME.get(v1)+"");	}
					catch(Exception e){}				
					if(index1>=0)
					{
				
		%>
						<tr>
							<td>
								<input type="hidden" name="fileItem" value="<%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%>" >
								<a href="javascript:downloadFile('O','<%=retUploadDocs.getFieldValueString(index1,"EUD_ITEM_NO")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_DOC_TYPE")%>')"><%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%></a>
							</td>
							<td>
								<span onclick="javascript:deleteFile(this,'<%=retUploadDocs.getFieldValueString(index1,"EUD_ITEM_NO")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_DOC_TYPE")%>')" class="fa fa-trash fa-lg deleteBtn" style="margin-left: 25%;"></span>
							</td>
						</tr>
		<%
					
					}
				}
			
		%>
		
				</table>
				</td>					
		</Tr>-->
		
		
		<Tr>	
			<Th align="left">Business Status of Vendor  <font color="red">*</font> </Th>
			<Td colspan="3">
				<div class="form-check">
<%
					String dispOtherBus="none";
					set = busStatusHM.entrySet(); 
					i = set.iterator();
					while(i.hasNext()) 
					{
						Map.Entry me = (Map.Entry)i.next();
						cntVal=(String)me.getKey();
						chksel="";
						//me.getValue()
						if(cntVal.equals(busStatus))chksel="checked";
						
%>
							<input type="radio" name="bus_Status"  class="form-check-input validate[required]" data-errormessage-value-missing="Please Select Business Staus of Vendor" value="<%=me.getKey()%>" <%=chksel%> onChange="showOtherBus(this)">&nbsp;&nbsp;&nbsp;<%=me.getValue()%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<%
					}
					
						if("OTH".equals(busStatus))
							dispOtherBus="";
%>						
				</div>
			</Td>

		</Tr>
		<!--Testing new-->
		<Tr id="otherBus" style="display:<%=dispOtherBus%>">
					<Th align="left">Business Status Details<font color="red">*</font></Th>
					<Td colspan="3">
						<input type="text" class="form-control validate[required]" data-errormessage-value-missing="Please Select Business Status Details"  name="otherBusInfo" id="otherBusInfo" value="<%=checkNull(otherBusInfo)%>" maxlength="20" >
					</Td>					
				</Tr>
		<Tr>
			<Th align="left">E-Invoicing(Applicable if annual turnover in previous year is in excess of $100M )</Th>
			<Td colspan="3">
				<div class="form-check">
<%

					if("Y".equals(e_Invoice)) 
						chkYes="checked";
					else if("N".equals(e_Invoice))
						chkNo="checked";
%>							
					<input class="form-check-input" type="radio"  name="e_Invoice" value="Y" <%=chkYes%>>&nbsp;&nbsp;&nbsp;Yes&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input class="form-check-input" type="radio"  name="e_Invoice" value="N" <%=chkNo%>>&nbsp;&nbsp;&nbsp;No&nbsp;
				</div>
			</Td>
		</Tr>
				
				<Tr>
					<Th align="left" width="61%">Is Supplier Currently Created With Other JUBILANT Entities</Th>
					<Td colspan="3">
						<div class="form-check">
<%
						String dispUnit="none";
						
							if("Y".equals(vend_Jgl)) 
							{
								chkSupYes="checked";
								dispUnit="";
							}	
							else if("N".equals(vend_Jgl))
								chkSupNo="checked";
%>						
							<input class="form-check-input" type="radio"   name="vend_Jgl" value="Y" onChange="showUnit(this)" <%=chkSupYes%>>&nbsp;&nbsp;&nbsp;Yes&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input class="form-check-input" type="radio"   name="vend_Jgl" value="N" onChange="showUnit(this)" <%=chkSupNo%>>&nbsp;&nbsp;&nbsp;No&nbsp;
						</div>
					</Td>
				</Tr>
				<Tr id="vendUnit" style="display:<%=dispUnit%>;">
					<Th align="left">Name of Business Unit<font color="red">*</font></Th>
					<Td colspan="3">
						<input type="text" class="form-control"  name="vend_Unit" id="vend_Unit" value="<%=checkNull(vend_Unit)%>" maxlength="20" >
					</Td>					
				</Tr>				
				<Tr>
					<Th align="left" width="61%">Is Supplier done any transaction earlier with JUBILANT with any other name or related concerns firm</Th>
					<Td colspan="3">
						<div class="form-check">
<%
							String dispDtls="none";
							if("Y".equals(vend_Trans)) 
							{
								chkSupYes="checked";
								dispDtls="";
							}	
							else if("N".equals(vend_Trans))
								chkSupNo="checked";
%>						
							<input class="form-check-input" type="radio"   name="vend_Trans"  value="Y" onChange="showDtls(this)" <%=chkSupYes%>>&nbsp;&nbsp;&nbsp;Yes&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input class="form-check-input" type="radio"   name="vend_Trans"  value="N" onChange="showDtls(this)" <%=chkSupNo%>>&nbsp;&nbsp;&nbsp;No&nbsp;
						</div>
					</Td>
				</Tr>
				<Tr id="vendDtls" style="display:<%=dispDtls%>;">
					<Th align="left">Vendor Details<font color="red">*</font></Th>
					<Td colspan="3" >
						<input type="text" class="form-control"  name="vend_Dtls"  value="<%=checkNull(vend_Dtls)%>" maxlength="100" >
					</Td>					
				</Tr>				
				<Tr>
					<Th align="left" width="61%">Vendor Site Visit Performed</Th>
					<Td colspan="3">
<%
						String dispSite="none";
						
						if("Y".equals(vend_Site)) 
						{
							chkSiteYes="checked";
							dispSite="";
						}	
						else if("N".equals(vend_Site))
						{
							chkSiteNo="checked";
						}	
%>					
						<div class="form-check">
							<input class="form-check-input" type="radio"   name="vend_Site" value="Y"  onChange="showSite(this)" <%=chkSiteYes%> >&nbsp;&nbsp;&nbsp;Yes&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input class="form-check-input" type="radio"   name="vend_Site" value="N"  onChange="showSite(this)" <%=chkSiteNo%>>&nbsp;&nbsp;&nbsp;No&nbsp;
						</div>
					</Td>
				</Tr>	
				<Tr id="sitePerson" style="display:<%=dispSite%>;">
					<Th align="left">Name of the Person</Th>
					<Td colspan="3">
						<input type="text" class="form-control"  name="sitePerson" value="<%=checkNull(sitePerson)%>" maxlength="20" >
					</Td>					
				</Tr>
				<Tr id="siteViDt" style="display:<%=dispSite%>;">
					<Th align="left">Site Visited on</Th>
					<Td colspan="3">
						<input type="text" class="form-control"  name="siteViDt" value="<%=checkNull(siteViDt)%>" maxlength="20" >
					</Td>				
				</Tr>				
</table>
</DIV>
	<div id="tabs-4">
	<input type="hidden" name="tabVal4" id="tabVal4" value="" >
		<table class="table table-bordered">
			<Tr>
				<Th align="left" width="30%">Certified Copy of Financial Statements</Th>
				<Td width="20%">
					<input type="text" class="form-control"  name="fsAttach" value="<%=checkNull(fsAttach)%>" maxlength="20" >
				</Td>					
				<td width="20%"><button type="button"  value = "VENDFS"  class="btn btn-primary uploadDialogBtn" ><i class="fa fa-upload"></i>&nbsp;Upload</button></td>
				<td width="30%">
					<table class="VENDFSTABLE table  table-bordered dt-responsive nowrap" id="VENDFSTABLE" name="VENDFSTABLE" >
<%
		Vector itemIndFS=retUploadDocs.where(new String[]{"EUD_DOC_TYPE"},new String[]{"VENDFS"});
		for(int v1=0;v1<itemIndFS.size();v1++)
		{	
			int index1 = -1;
			try{
			index1 = Integer.parseInt(itemIndFS.get(v1)+"");	
			}catch(Exception e){}				
			if(index1>=0)
			{
%>
				<tr>
					<td>
						<input type="hidden" name="fileItem" value="<%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%>" >
						<a href="javascript:downloadFile('O','<%=retUploadDocs.getFieldValueString(index1,"EUD_ITEM_NO")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_DOC_TYPE")%>')"><%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%></a>
					</td>
					<td>
						<span onclick="javascript:deleteFile(this,'<%=retUploadDocs.getFieldValueString(index1,"EUD_ITEM_NO")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_DOC_TYPE")%>')" class="fa fa-trash fa-lg deleteBtn" style="margin-left: 25%;"></span>
					</td>
				</tr>
<%
			}
		}
%>

					</table>
		    		</td>				
			</Tr>
	
		<table class="table table-bordered">
			<Tr>
				<Th align="left" width="30%">Certified Copy of Supply agreement or proposal attached </Th>
				<Td width="20%">
					<input type="text" class="form-control"  name="saAttach" value="<%=checkNull(saAttach)%>" maxlength="20" >
				</Td>					
				<td width="20%"><button type="button"  value = "VENDSA"  class="btn btn-primary uploadDialogBtn" ><i class="fa fa-upload"></i>&nbsp;Upload</button></td>
				<td width="30%">
				<table class="VENDSATABLE table  table-bordered dt-responsive nowrap" id="VENDSATABLE" name="VENDSATABLE" >
<%
		Vector itemIndSA=retUploadDocs.where(new String[]{"EUD_DOC_TYPE"},new String[]{"VENDSA"});
		for(int v1=0;v1<itemIndSA.size();v1++)
		{	
			int index1 = -1;
			try{
			index1 = Integer.parseInt(itemIndSA.get(v1)+"");	
			}catch(Exception e){}				
			if(index1>=0)
			{
		
%>
			<tr>
				<td>
					<input type="hidden" name="fileItem" value="<%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%>" >
					<a href="javascript:downloadFile('O','<%=retUploadDocs.getFieldValueString(index1,"EUD_ITEM_NO")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_DOC_TYPE")%>')"><%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%></a>
				</td>
				<td>
					<span onclick="javascript:deleteFile(this,'<%=retUploadDocs.getFieldValueString(index1,"EUD_ITEM_NO")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_DOC_TYPE")%>')" class="fa fa-trash fa-lg deleteBtn" style="margin-left: 25%;"></span>
				</td>
			</tr>
<%
			}
		}
%>

				</table>
			</td>					
		</Tr>
		<table class="table table-bordered">
			<Tr>
				<Th align="left" width="30%">List of key Customer Reference</Th>
				<Td width="20%">
					<input type="text" class="form-control"  name="kcAttach" value="<%=checkNull(kcAttach)%>" maxlength="20" >
				</Td>
				<td width="20%"><button type="button"  value = "VENDCUST"  class="btn btn-primary uploadDialogBtn" ><i class="fa fa-upload"></i>&nbsp;Upload</button></td>
				<td width="30%">
				 	<table class="VENDCUSTTABLE table  table-bordered dt-responsive nowrap" id="VENDCUSTTABLE" name="VENDCUSTTABLE" >
<%
		Vector itemIndKeyCust=retUploadDocs.where(new String[]{"EUD_DOC_TYPE"},new String[]{"VENDCUST"});
		for(int v1=0;v1<itemIndKeyCust.size();v1++)
		{	
			int index1 = -1;
			try{
			index1 = Integer.parseInt(itemIndKeyCust.get(v1)+"");	
			}catch(Exception e){}				
			if(index1>=0)
			{
		
%>
			<tr>
				<td>
					<input type="hidden" name="fileItem" value="<%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%>" >
					<a href="javascript:downloadFile('O','<%=retUploadDocs.getFieldValueString(index1,"EUD_ITEM_NO")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_DOC_TYPE")%>')"><%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%></a>
				</td>
				<td>
					<span onclick="javascript:deleteFile(this,'<%=retUploadDocs.getFieldValueString(index1,"EUD_ITEM_NO")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_DOC_TYPE")%>')" class="fa fa-trash fa-lg deleteBtn" style="margin-left: 25%;"></span>
				</td>
			</tr>
<%
			}
		}
%>
					</table>
				</td>					
		</Tr>
<%
	if("5".equals(userType))
	{
%>
		  	<table class="table table-bordered">
				<Tr>
					<Th align="left" width="30%">Vendor Creation Forms<br>(As per Business specific SOPs) </Th>
					<Td width="20%">
						<input type="text" class="form-control"  name="sopAttach" value="" maxlength="20" >
					</Td>
					<td width="20%"><button type="button"  value = "VENDSOP"  class="btn btn-primary uploadDialogBtn" ><i class="fa fa-upload"></i>&nbsp;Upload</button></td>
					<td width="30%">
					 <table class="VENDSOPTABLE table  table-bordered dt-responsive nowrap" id="VENDSOPTABLE" name="VENDSOPTABLE" >
<%
	Vector itemIndSOP=retUploadDocs.where(new String[]{"EUD_DOC_TYPE"},new String[]{"VENDSOP"});
	for(int v1=0;v1<itemIndSOP.size();v1++)
	{	
		int index1 = -1;
		try{
		index1 = Integer.parseInt(itemIndSOP.get(v1)+"");	}
		catch(Exception e){}				
		if(index1>=0){
		
%>
		<tr>
			<td>
				<input type="hidden" name="fileItem" value="<%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%>" >
				<a href="javascript:downloadFile('O','<%=retUploadDocs.getFieldValueString(index1,"EUD_ITEM_NO")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_DOC_TYPE")%>')"><%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%></a>
			</td>
			<td>
				<span onclick="javascript:deleteFile(this,'<%=retUploadDocs.getFieldValueString(index1,"EUD_ITEM_NO")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_DOC_TYPE")%>')" class="fa fa-trash fa-lg deleteBtn" style="margin-left: 25%;"></span>
			</td>
		</tr>
<%
		}
	}
%>

	</table>
	</td>					

</Tr>
<%
	}
%>
		  	<table class="table table-bordered">
				<Tr>
					<Th align="left" width="30%">Other</Th>
					<Td width="20%">
						<input type="text" class="form-control"  name="othAttach" value="<%=checkNull(othAttach)%>" maxlength="20" >
					</Td>
					<td width="20%"><button type="button"  value = "VENDOTH"  class="btn btn-primary uploadDialogBtn" ><i class="fa fa-upload"></i>&nbsp;Upload</button></td>
					<td width="30%">
					 <table class="VENDOTHTABLE table  table-bordered dt-responsive nowrap" id="VENDOTHTABLE" name="VENDOTHTABLE" >
<%
	Vector itemIndOTH=retUploadDocs.where(new String[]{"EUD_DOC_TYPE"},new String[]{"VENDOTH"});
	for(int v1=0;v1<itemIndOTH.size();v1++)
	{	
		int index1 = -1;
		try{
		index1 = Integer.parseInt(itemIndOTH.get(v1)+"");	}
		catch(Exception e){}				
		if(index1>=0){
		
%>
		<tr>
			<td>
				<input type="hidden" name="fileItem" value="<%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%>" >
				<a href="javascript:downloadFile('O','<%=retUploadDocs.getFieldValueString(index1,"EUD_ITEM_NO")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_DOC_TYPE")%>')"><%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%></a>
			</td>
			<td>
				<span onclick="javascript:deleteFile(this,'<%=retUploadDocs.getFieldValueString(index1,"EUD_ITEM_NO")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_DOC_TYPE")%>')" class="fa fa-trash fa-lg deleteBtn" style="margin-left: 25%;"></span>
			</td>
		</tr>
<%
		}
	}
%>

	</table>
	</td>					

</Tr>
		    	</table>
<%

	//if("IM".equals(vendType)  && !"IN".equals(country))
	if("7501".equals(compCode)|| "4500".equals(compCode)) 
	{
%>
		  <!--My attchment task-->
		   <table class="table table-bordered">
				<Tr>
					<Th align="left" width="30%">W9Form <%if("IN".equals(vendType) && !"IN".equals(country)){%><%}%></Th>
					<Td width="20%">
						<input type="text" class="form-control "  name="w9Attach" id="w9Attach" value="<%=checkNull(w9Attach)%>" maxlength="20" >
					</Td>
					<td width="20%"><button type="button"  value = "VENDW9"  class="btn btn-primary uploadDialogBtn" ><i class="fa fa-upload"></i>&nbsp;Upload</button></td>
					<td width="30%">
					 <table class="VENDW9TABLE table  table-bordered dt-responsive nowrap" id="VENDW9TABLE" name="VENDW9TABLE" >
<%
			Vector itemIndW9=retUploadDocs.where(new String[]{"EUD_DOC_TYPE"},new String[]{"VENDW9"});
			for(int v1=0;v1<itemIndW9.size();v1++)
			{	
				int index1 = -1;
				try{
				index1 = Integer.parseInt(itemIndW9.get(v1)+"");	}
				catch(Exception e){}				
				if(index1>=0){

%>
				<tr>
					<td>
						<input type="hidden" name="fileItem" value="<%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%>" >
						<a href="javascript:downloadFile('O','<%=retUploadDocs.getFieldValueString(index1,"EUD_ITEM_NO")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_DOC_TYPE")%>')"><%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%></a>
					</td>
					<td>
						<span onclick="javascript:deleteFile(this,'<%=retUploadDocs.getFieldValueString(index1,"EUD_ITEM_NO")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_DOC_TYPE")%>')" class="fa fa-trash fa-lg deleteBtn" style="margin-left: 25%;"></span>
					</td>
				</tr>
<%
				}
			}
		}
		else 
		{
%>
			<table class="table table-bordered">
			<Tr>
				<Th align="left" width="30%">W9Form <%if("IN".equals(vendType) && !"IN".equals(country)){%><font color="red">*</font><%}%></Th>
				<Td width="20%">
					<input type="text" class="form-control "  name="w9Attach" id="w9Attach" value="<%=checkNull(w9Attach)%>" maxlength="20" >
				</Td>
				<td width="20%"><button type="button"  value = "VENDW9"  class="btn btn-primary uploadDialogBtn" ><i class="fa fa-upload"></i>&nbsp;Upload</button></td>
				<td width="30%">
				 <table class="VENDW9TABLE table  table-bordered dt-responsive nowrap" id="VENDW9TABLE" name="VENDW9TABLE" >
<%
			Vector itemIndW9=retUploadDocs.where(new String[]{"EUD_DOC_TYPE"},new String[]{"VENDW9"});
			for(int v1=0;v1<itemIndW9.size();v1++)
			{	
				int index1 = -1;
				try{
				index1 = Integer.parseInt(itemIndW9.get(v1)+"");	}
				catch(Exception e){}				
				if(index1>=0){

%>
				<tr>
					<td>
						<input type="hidden" name="fileItem" value="<%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%>" >
						<a href="javascript:downloadFile('O','<%=retUploadDocs.getFieldValueString(index1,"EUD_ITEM_NO")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_DOC_TYPE")%>')"><%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%></a>
					</td>
					<td>
						<span onclick="javascript:deleteFile(this,'<%=retUploadDocs.getFieldValueString(index1,"EUD_ITEM_NO")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_DOC_TYPE")%>')" class="fa fa-trash fa-lg deleteBtn" style="margin-left: 25%;"></span>
					</td>
				</tr>
<%
				}
			}
		}	
%>
				</table>
			</td>					
			</Tr>
			</table>

		   <!--My attchment task-2-->

		   <table class="table table-bordered">
						<Tr>
							<Th align="left" width="30%">W8Form<%if("IM".equals(vendType)){%><font color="red">*</font><%}%></Th>
							<Td width="20%">
								<input type="text" class="form-control"  name="w8Attach" id="w8Attach" value="<%=checkNull(w8Attach)%>" maxlength="20" >
							</Td>
							<td width="20%"><button type="button"  value = "VENDW8"  class="btn btn-primary uploadDialogBtn" ><i class="fa fa-upload"></i>&nbsp;Upload</button></td>
							<td width="30%">
							 <table class="VENDW8TABLE table  table-bordered dt-responsive nowrap" id="VENDW8TABLE" name="VENDW8TABLE" >
		   <%
			Vector itemIndW8=retUploadDocs.where(new String[]{"EUD_DOC_TYPE"},new String[]{"VENDW8"});
			for(int v1=0;v1<itemIndW8.size();v1++)
			{	
				int index1 = -1;
				try{
				index1 = Integer.parseInt(itemIndW8.get(v1)+"");	}
				catch(Exception e){}				
				if(index1>=0){

		   %>
				<tr>
					<td>
						<input type="hidden" name="fileItem" value="<%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%>" >
						<a href="javascript:downloadFile('O','<%=retUploadDocs.getFieldValueString(index1,"EUD_ITEM_NO")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_DOC_TYPE")%>')"><%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%></a>
					</td>
					<td>
						<span onclick="javascript:deleteFile(this,'<%=retUploadDocs.getFieldValueString(index1,"EUD_ITEM_NO")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_FILE_NAME")%>','<%=retUploadDocs.getFieldValueString(index1,"EUD_DOC_TYPE")%>')" class="fa fa-trash fa-lg deleteBtn" style="margin-left: 25%;"></span>
					</td>
				</tr>
		   <%
				}
			}
		   %>

			</table>
			</td>					

		   </Tr>
			</table>

<%

	//}
%>	    	
		   </div>
		  <div id="tabs-5">
		  <input type="hidden" name="tabVal5" id="tabVal5" value="5" >

		  	<table class="table table-bordered">
			<Tr>
					<Th align="left">Accounting Point person <font color="red">*</font> </Th>
					<Td>
						<input type="text" class="form-control validate[required]"   name="accnt_Per" value="<%=checkNull(Accnt_Person)%>" data-errormessage-value-missing="Please enter Accounting Point person name" maxlength="100">
					</Td>
					<Th align="left">Vendor Email <font color="red">*</font> </Th>
					<Td>
					<input type="text" class="form-control validate[required]" data-errormessage-value-missing="Please enter Vendor Email"  name="accnt_Email" value="<%=checkNull(Accnt_Email)%>" maxlength="100">
					</Td>
					
				</Tr>		  	
				<Tr>
					<Th align="left">Mobile <font color="red">*</font> </Th>
					<Td>
					<input type="text" class="form-control validate[required]" data-errormessage-value-missing="Please enter Mobile number"  name="accnt_Mobile" value="<%=checkNull(Accnt_Mobile)%>" minlength="15" maxlength="15" onKeyPress="return onlyNumbers()" >
					</Td>				
					<Th align="left">RTGS/NEFT/IFSC <font color="red">*</font> </Th>
					<Td>
<%
					if("Y".equals(showStr) && "LB".equals(userRole))
					{
%>					
						<input type="text" class="form-control validate[required]"  name="rtgs_Code" id="rtgs_Code" style="background-color:#ff0000bf" value="<%=checkNull(RTGSCode)%>" maxlength="100" onChange="chkIFSC(this)">
<%
					}else{
%>
						<input type="text" class="form-control validate[required]" data-errormessage-value-missing="Please enter RTGS/NEFT/IFSC  Code"  name="rtgs_Code" id="rtgs_Code"  value="<%=checkNull(RTGSCode)%>" maxlength="100">			
<%
					}
%>
					</Td>
				</Tr>
				<Tr>
					<Th align="left">Bank Name <font color="red">*</font> </Th>
					<Td>
						<input type="text" class="form-control validate[required]" data-errormessage-value-missing="Please enter Bank Name"  name="bankName" value="<%=checkNull(BankName)%>" maxlength="100">
					</Td>
					
					<Th align="left">Branch <font color="red">*</font> </Th>
					<Td>
						<input type="text" class="form-control validate[required]"  data-errormessage-value-missing="Please enter Branch Name" name="bank_Branch" value="<%=checkNull(Branch)%>" maxlength="100">
					</Td>
								
				</Tr>				
				<Tr>
					<Th align="left">Account Number <font color="red">*</font> </Th>
					<Td>
						<input type="text" class="form-control validate[required]" data-errormessage-value-missing="Please enter Account Number" name="accnt_Number" value="<%=checkNull(Account_Number)%>"  maxlength="50" onKeyPress="return onlyNumbers()">
					</Td>
					
					<Th align="left">Swift Code <font color="red">*</font> </Th>
					<Td>
						<input type="text" class="form-control validate[required]"  data-errormessage-value-missing="Please enter Swift Code" name="bank_Swift" value="<%=checkNull(BankSwift)%>" maxlength="100">
					</Td>
				</Tr>
<%
	if("LB".equals(userRole) || showApprove || "SCA".equals(userRole))
	{
		//isEditable = true;
%>
				<Tr>
					<Th colspan="2" align="left">Account Group</Th>
					<Td colspan="2">
						<input type="text" class="form-control" value="<%=venGrpVal%>" readOnly>
					</Td>
				</Tr>
		<Tr>
				<Th align="left">WithHold Tax Type</Th>
				<Td>
					<Select name="whTaxType" id="whTaxType" onchange="funSelWithHold()" class="form-control select2">	
							<option value="">--Select Tax Type--</option>
<%
						for(int wt=0;wt<withCDList.size();wt++)
						{
							cntVal=(String)withCDList.get(wt);
							chksel="";
							if(cntVal.equals(whTaxType))chksel="selected";							
%>
							<option value="<%=withCDList.get(wt)%>" <%=chksel%>><%=withCDList.get(wt)%></option>
<%

						}
%>
					</select>
				</Td>
				<Th align="left">WithHold Tax Code</Th>
					<Td id="WTT">
					
						<%=checkNull(whTaxCode)%>
					</Td>
				</Tr>
				<Tr>
					<Th align="left"> Recon Account Type <font color="red">*</font>  </Th>
					<Td>
						
						<Select name="recType" id="recType" class="form-control select2 validate[required]" data-errormessage-value-missing="Please Select Recon Account Type">	
								<option value="">--Select Account type--</option>
<%
								set = recTypeHM.entrySet(); 
								i = set.iterator();
								while(i.hasNext()) 
								{
									Map.Entry me = (Map.Entry)i.next();
									cntVal=(String)me.getKey();
									chksel="";
									if(cntVal.equals(recType))chksel="selected";
%>
									<option value="<%=me.getKey()%>" <%=chksel%> ><%=me.getKey()%>--><%=me.getValue()%></option>
<%

								}
%>
						</select>
					</Td>
			
					<Th align="left"> Recon Account <font color="red">*</font></Th>
					<Td>
						
						<Select name="reconAccount" id="reconAccount" class="form-control select2 validate[required]" data-errormessage-value-missing="Please Select Recon Account">	
								<option value="">--Select Account--</option>
<%
								set = recAcctHM.entrySet(); 
								i = set.iterator();
								while(i.hasNext()) 
								{
									Map.Entry me = (Map.Entry)i.next();
									cntVal=(String)me.getKey();
									chksel="";
									if(cntVal.equals(reconAccount))chksel="selected";
%>
									<option value="<%=me.getKey()%>" <%=chksel%> ><%=me.getKey()%>--><%=me.getValue()%></option>
<%

								}
%>
						</select>
					</Td>
				</Tr>	
				<Tr>
					<Th colspan="2" align="left">Documents Verified<font color="red">*</font></Th>
					<Td colspan="2">
						<div class="form-check">
<%

							if("Y".equals(docAck)) 
								chkAckYes="checked";
							else if("N".equals(docAck))
								chkAckNo="checked";
%>							
							<input class="form-check-input validate[required]" type="radio"  id="docAck" name="docAck" value="Y" <%=chkAckYes%>>&nbsp;&nbsp;&nbsp;Yes&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input class="form-check-input validate[required]" type="radio"  id="docAck" name="docAck" value="N" <%=chkAckNo%>>&nbsp;&nbsp;&nbsp;No&nbsp;
						</div>
					</Td>
				</Tr>				
<%
	}
%>				
		</table>
<%		
	String trBGColor = "Bgcolor=\"#325786\"  style=\"color:white\"";
	int commentsCount =0;
	ReturnObjFromRetrieve commentsRet = getJGLDocComments(Session,docId,"VNR");
	
	if(commentsRet!= null)
		commentsCount = commentsRet.getRowCount();
		

	if(commentsCount>0)
	{
			commentsRet.sort(new String[]{"EDC_DATE"},true);
			SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
%>

		<table id="table-2" class="table table-bordered">
<%
		String displayStr ="";
		for(int k=0;k<commentsCount;k++)
		{
			if(k == 0)
			{
%>	
				<Tr <%=trBGColor%>>
				
					<Th width="20%">User</Th>
					<Th width="20%">Date</Th>
					<Th width="60%">Comments</Th>
				</Tr>
<%
			}
					displayStr = commentsRet.getFieldValueString(k,"EDC_COMMENTS");
%>				
				<Tr>
					<Td align="left">&nbsp;<%=commentsRet.getFieldValueString(k,"EDC_USER_ID")+"["+checkNull(commentsRet.getFieldValueString(k,"EU_FIRST_NAME"))+"]"%></Td>
					<Td align="left">&nbsp;<%=sdf.format((Date)commentsRet.getFieldValue(k,"EDC_DATE"))%></Td>					
					<Td title='<%=displayStr%>' align="left"><textarea style='width:100%' rows='2' readonly><%=checkNull(displayStr)%></textarea></td>
				</Tr>
			
<%
		}	
%>
	</Table>
<%
	}
	if("2".equals(userType))
	{
	ReturnObjFromRetrieve retUploadList = getUploadList(Session,docId,"VNRH"); 
	int retUploadListCnt = 0; 
	String itemId="H";
	if(retUploadList != null)
		retUploadListCnt = retUploadList.getRowCount();
%>
		<h5 style="text-align:left">
			Attachment(s)
		</h5>
		<div class="row">
		  <div class="col-md-12 col-xs-12">
			<!-- general form elements -->
			<div class="box box-default">
				<div class="box-body table-responsive no-padding">
					<div class="box-body">
					       <table id="uploadTable<%=itemId%>" class="table  table-bordered dt-responsive nowrap" >
							<tr <%=trBGColor%>>
								<th width="95%" align='left'>File Name</th>
								<th width="5%"></th>
							</tr>
<%
		if(retUploadListCnt == 0)
		{
%>
			<tr id="noDataStatUpload">
				<td>No files attached</td>
			</tr>
<%
		}
		for(int r=0;r<retUploadListCnt;r++)
		{
%>
			<tr>
				<td align="left" width="95%"><input type="hidden" name="fileItemH" value="<%=retUploadList.getFieldValueString(r,"EUD_FILE_NAME")%>"><a href="javascript:downloadFileNew('<%=retUploadList.getFieldValueString(r,"EUD_ITEM_NO")%>','<%=retUploadList.getFieldValueString(r,"EUD_FILE_NAME")%>')"><%=retUploadList.getFieldValueString(r,"EUD_FILE_NAME")%></a></td>
				<!--<td width="5%"><span onclick="javascript:deleteFile(this,'<%=retUploadList.getFieldValueString(r,"EUD_ITEM_NO")%>','<%=retUploadList.getFieldValueString(r,"EUD_FILE_NAME")%>')" class="fa fa-trash fa-lg" style="margin-left: 25%;"></span></td>-->
				<td width="5%">&nbsp;</td>
				
			</tr>
<%
		}
%>
	</table>
	</div>
	</div>
	</div>
	</div>
	</div>		
<%
	}	
	if(vendSubmit || showSubmit || showApprove || vendReSubmit)
	{
%>
		<Table align="center" width="100%" border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0 >
			<Tr <%=trBGColor%>>
				<Th align=left ><B>Enter Comments</B></Th>
			</Tr>
			<Tr>	
				<Td class='blankcell' width='100%'>
				<textarea name = 'comments' id='comments' style='width:100%' rows=3 cols=73 ></textarea>
				</Td>
			</Tr> 
		</Table>
<%
	}
%>	
		<div class="row" id="tabContents">
			<!-- left column -->
			   <div class="col-md-12">
			</div>
<%
	if(retQryCnt>0)
	{
%>
		<br>
		<div class="row">
		<div class="col-xs-12" align="center"><p><b><font color=red >* Query has not been replied to this Vendor Registration. You cannot submit/approve Vendor Registration now.</font></b></p></div>
		</div>

<%
	}
%>			
		<br><br>	
		<div class="row">
			<div class="col-xs-12" align="center">
				<button type="button" class="btn btn-primary" onclick="javascript:history.go(-1)" style="margin-right: 5px;"><i class="fa fa-backward"></i>&nbsp;Back</button>			
<%
	if(vendSubmit)
	{
%>
				<button type="button" class="btn btn-primary" onclick="funSubmit('V')" style="margin-right: 5px;"><i class="fa fa-submit"></i>&nbsp;Submit</button>
<%
	}
	if(vendReSubmit)
	{
%>	
				<button type="button" class="btn btn-primary" onclick="funSubmit('U')" style="margin-right: 5px;"><i class="fa fa-submit"></i>&nbsp;Resubmit</button>	
<%				
	}
	if(showSubmit)
	{
%>
				<button type="button"  value="H" class="btn btn-info uploadDialogBtnTemp" ><i class="fa fa-upload"></i>&nbsp;Upload Attachments</button>			
				<button type="button" class="btn btn-success" onclick="funSubmit('S')" style="margin-right: 5px;"><i class="fa fa-submit"></i>&nbsp;Submit</button>
<%
	}
	if(showApprove)
	{
%>
				<button type="button" id="postSAP" class="btn btn-success" onclick="funSubmit('P')" style="margin-right: 5px;"><i class="fa fa-submit"></i>&nbsp;Approve</button>
<%
	}
	if(showReject && !"PP".equals(userRole))	
	{
%>
				<button type="button"  class="btn btn-danger" onclick="funSubmit('R')" style="margin-right: 5px;"><i class="fa fa-submit"></i>&nbsp;Reject</button>
				
<%
	}

	if("2".equals(userType))
	{
		if(("PP".equals(userRole) && "REJECTED".equals(wfStatus)) || "PP".equals(userRole) && "SUBMITTED".equals(wfStatus) && "PUR_PERSON".equals(wfNextPart) && "1".equals(String.valueOf(wfCurStep)) || ("BY".equals(userRole) && "REJECTED".equals(wfStatus)) || "BY".equals(userRole) && "SUBMITTED".equals(wfStatus) && "BY".equals(wfNextPart) && "1".equals(String.valueOf(wfCurStep)))
		{
%>
				<button type="button"  class="btn btn-danger" onclick="funSubmit('B')" style="margin-right: 5px;"><i class="fa fa-submit"></i>&nbsp;Send Back</button>
<%
		}
		if(!"PP".equals(userRole) && !"VIW".equals(userRole) && !"APPROVED".equals(wfStatus))
		{		
		
%>	
				<button type="button" class="btn btn-warning" onclick="funQuery('<%=docId%>','VNR','<%=compCode%>','<%=venWFPlant%>','<%=venWFCategory%>','0')" style="margin-right: 5px;"><i class="fa fa-question-circle"></i>Query</button>
<%
		}
%>				
				<button type="button" class="btn btn-primary" onclick="funShowApprovalHirearchy('<%=compCode%>','<%=venWFPlant%>','<%=venWFCategory%>','0')" style="margin-right: 5px;"><i class="fa fa-users"></i>Show Approval Hierarchy</button>
				<button type="button" class="btn btn-primary" onclick="funAuditTrail('<%=docId%>','VNR')" style="margin-right: 5px;"><i class="fa fa-list"></i> Audit Trail</button>			
<%
	}
%>					
					
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
      </div>
     </form>
   </div>  
</div> 	 
 </div>
 </form>
  </div>  
 
</section>
</div>
</div>
      </div>
     </form>
     
   </div>  
</div> 	
<div id="woModal" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog">
      <div class="modal-content" style="width:700px">
         <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <iframe src="" width="100%" height="450" frameborder="0" allowtransparency="true"></iframe>
         </div>
      </div>
   </div>
</div>
<div id="uploadMod" class="modal fade" tabindex="-1" role="dialog"> 
   <div class="modal-dialog">
      <form id="uploadForm" action="../Inbox/ezUploadFile.jsp" method="post" enctype="multipart/form-data">
      <div class="modal-content">
      <div class="modal-header">
	      <button type="button" class="close" data-dismiss="modal" aria-label="Close">
		<span aria-hidden="true">x</span></button>
	      <h4 class="modal-title">Attachments</h4>
	</div>
	 <div class="modal-body">	     
	         <fieldset>  
			<input type="hidden" id="upDocType" name="upDocType" value="">
			<input type="hidden" id="upDocId" name="upDocId" value="<%=docId%>">
			<input type="hidden" id="upItemNo" name="upItemNo" value="10">
			<input type="file" id="file" name="file"/> 

			<div id="loadingInd" style="display:none;margin-left: 25%;">
				<i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i>
				<span class="sr-only">Loading...</span>
			</div>
	         </fieldset>	
	 </div>
	 
	 <div class="modal-footer">
	 <p class="text-red" style="float:left;"><strong>Maximum File size 5MB.</strong></p>
	 <button type="submit" id="uploadbutton" class="btn btn-primary">Upload</button>
	 </div>
      </div>
     </form>
   </div>  
</div>
<div id="uploadModTemp" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog">
      <form id="uploadFormTemp" action="../Inbox/ezUploadFileTemp.jsp" method="post" enctype="multipart/form-data">
      <div class="modal-content">
      <div class="modal-header">
	      <button type="button" class="close" data-dismiss="modal" aria-label="Close">
		<span aria-hidden="true">?</span></button>
	      <h4 class="modal-title">Attachments</h4>
	</div>
	 <div class="modal-body">	    
	         <fieldset>
			<input type="hidden" id="upDocTypeTemp" name="upDocTypeTemp" value="">
			<input type="hidden" id="upDocIdTemp" name="upDocIdTemp" value="">
			<input type="hidden" id="upItemNoTemp" name="upItemNoTemp" value="">
			<input type="file" id="fileTemp" name="fileTemp"/>
			<div id="loadingIndTemp" style="display:none;margin-left: 25%;">
				<i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i>
				<span class="sr-only">Loading...</span>
			</div>
	         </fieldset>
   		
	 </div>
	 <div class="modal-footer">
	 	<button type="submit" id="uploadbuttonTemp" class="btn btn-primary">Upload</button>
	 </div>
      </div>
     </form>
   </div>  
</div>
</body>	
<script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>
<script src="../../Library/jquery/jquery-validation-1.16.0/dist/jquery.validate.min.js"></script>
<script src="../../Library/jquery/jquery-validation-1.16.0/dist/additional-methods.min.js"></script>
<script src="../../Library/jquery/jquery-ui-1.12.1.custom/jquery-ui.js"></script>
<script src="../../../../EzCommon/Library/jquery-ui-1.10.4/js/jquery-ui-1.10.4.custom.js"></script>
</Html>



   <!-- jQuery 2.1.4 -->
    <script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>
    <script src="../../../../EzCommon/Library/jquery.form.js"></script> 
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
	<script src="../../../../EzCommon/Library/jquery-ui-1.10.4/js/jquery-ui-1.10.4.custom.js"></script>
<script>
 $(document).ready(function() {
	 	
	 	//$('#country').select2().select2('val','US');
	 	//$('.inCaseIndia').hide();
	 	if(eval('document.myForm.country').value=="IN"){
			//$('#isCountryIndia').style.display="";
			document.getElementById('isCountryIndia').style.display="block";
			//document.getElementById('isCountrystatus').style.display="block";
				
		}
		/*
		if(eval('document.myForm.country').value!="IN"){
			//$('#isCountryIndia').style.display="";
			document.getElementById('isCountrystatus').style.display="none";
			//document.getElementById('isCountrystatus').style.display="block";

		}*/
			
	 		
	 });
</script>
	<script>
	var tabVal;
		
	
		  
		$( function() {
		        $(".sidebar-toggle").trigger("click");	
		    $( "#tabs" ).tabs();
		    $("#tabs").tabs("option", "disabled", [1,2,3,4]);
		    $('.select2').select2()
		    $('.btn').click(function() {
		        $(this).toggleClass('btn-success');
		        $(this).toggleClass('btn-default');
		   });
		   $('.select2-selection__rendered').hover(function () {
		       $(this).removeAttr('title');
		   });
<%
	if(!isEditable)
	{
%>
			//$('#myForm').find('input:not(:checked), textarea, select').attr('disabled','disabled');
			//$('input:checkbox').attr('readonly','readonly');
			$('#myForm').find('input, textarea, select').attr('disabled','disabled');
			$('#comments').attr('disabled',false);
			$('.uploadDialogBtn').hide();
			$('.deleteBtn').hide();
			

<%
	}
	if("LB".equals(userRole) || "SCA".equals(userRole) && showSubmit)
	{
%>
			$('#rtgs_Code').attr('disabled',false);
			$('#whTaxType').attr('disabled',false);
			$('#recType').attr('disabled',false);			
			$('#reconAccount').attr('disabled',false);			
			$('#docAck').attr('disabled',false);
			//$('input[name=docAck]').attr('disabled',false);
<%
	}
%>			
			
	            //Get the first tab in document and will assume will always use first one
		    	var selectedTab = $(document).find('div[class^="ui-tabs"]').first();
		    	
		    //Navigation button, select tab when button click.
		    $(".Footer").on('click', ':button', function () {
		    
			if(!$("#myForm").validationEngine('validate'))
			{
				return ;
			}
		    	 
		    
		    	var selected = selectedTab.tabs("option", "active");
		    	
		    	
		    	if(selected==1)
		    	{
		    		if(!isValidComInfo())
		    		{
		    			return ;
		    		}
		    	}
		    	if(selected==2)
		    	{
		    		if(!isValidFinInfo())
		    		{
		    			return ;
		    		}
		    	}
		    	if(selected==3)
			{
				if(!isValidAttachments())
				{
					return ;
				}
		    	}
		    	
		    	
		    	if(selected==0)
		    	$("#tabs").tabs("option", "disabled", [selected,2,3,4]);
		    	if(selected==1)
		    	$("#tabs").tabs("option", "disabled", [selected,0,3,4,1]);
		    	if(selected==2)
		    	$("#tabs").tabs("option", "disabled", [selected,1,3,4,0]);
		    	if(selected==3)
		    	$("#tabs").tabs("option", "disabled", [selected,2,4,1,0]);
		    	if(selected==4)
		    	$("#tabs").tabs("option", "disabled", [selected,2,3,1,0]);
		    	
		    	tabVal=selected+1;
		    	//alert(selected);
<%
	if(isEditable)
	{
%>
		   $(function tabSave() {
			var tLineNumber=document.getElementsByName("tLineNumber").length;
			//var TopCusLineNumber=document.getElementsByName("TopCusLineNumber").length;
			var plantSiteLineNumber=document.getElementsByName("plantSiteLineNumber").length;
			//var DPASLineNumber=document.getElementsByName("DPASLineNumber").length;
			
			document.getElementById("tLineNumberVal").value=tLineNumber;
			//document.getElementById("topCusLineNumberVal").value=TopCusLineNumber;
			//document.getElementById("plantSiteLineNumberVal").value=plantSiteLineNumber;
			//document.getElementById("DPASLineNumberVal").value=DPASLineNumber;
			//alert("tabVal:::"+tabVal);
			document.getElementById("tabVal"+tabVal).value=tabVal;
			//alert($('#tabs-'+tabVal).find("select, textarea, input").serialize());
			var docId=$("#docId").val();
			$.ajax({
			type: 'post',
			url: 'ezSaveVendRegOthMat.jsp',
			data: $('#tabs-'+tabVal).find("select, textarea, input").serialize()+"&docId="+docId,
			success: function (response) {
			//alert(response);
			console.log(response);
			},
			error: function(response) {
			console.log(response)
			}
			});
			});
<%
	}
%>
		    	$("#tabs").tabs("enable", selected+1);  			
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
			    $("#tabs").tabs("option", "disabled", [selected,2,1,0]);
			    }
			    if(selected==3)
			    {
			    $("#tabs").tabs("enable", selected-1);
			    $("#tabs").tabs("option", "disabled", [selected,4,1,0]);
			    }
			    if(selected==2)
			    {
			    $("#tabs").tabs("enable", selected-1);
			    $("#tabs").tabs("option", "disabled", [selected,3,4,0]);
			    }
			    if(selected==1)
			    {
			    $("#tabs").tabs("enable", selected-1);
			    $("#tabs").tabs("option", "disabled", [selected,2,3,4]);
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
		
		$( function() {

		     $( ".uploadDialogBtn" ).button().on( "click", function() {
					$("#upDocType").val($(this).val());
					$("#upItemNo").val('10');
					$("#file").val("");
				       $('#uploadMod').modal('show');
					return false;
		     }); 
			
		      $('#uploadForm').ajaxForm({
			  beforeSubmit: valUploadForm,	
			  success: function(msg) {
			  //alert("alerttest"+msg);
			      $('#uploadbutton').show(); 	
			      $('#loadingInd').hide();
			      msg=$.trim(msg);
			      if(msg.split("##")[0] === 'true')
			      {
				  var upDocItemNo = $('#upItemNo').val();
				  var docType = $('#upDocType').val();
				  var fileNameTemp = msg.split("##")[1];
				  $('#'+docType+'TABLE').append('<tr><td><span><input type="hidden" id="fileItem" name="fileItem" value="'+fileNameTemp+'"><a href="javascript:downloadFile(\'O\',\''+upDocItemNo+'\',\''+fileNameTemp+'\',\''+docType+'\')">'+fileNameTemp+'</a></span></td><td><span onclick="javascript:deleteFile(this,\''+upDocItemNo+'\',\''+fileNameTemp+'\',\''+docType+'\')" class="fa fa-trash fa-lg deleteBtn" style="margin-left: 25%;"></span></td>');
			      }
			      //alert("File has been uploaded successfully");
			      $('#uploadMod').modal('hide');
			 },
			  error: function(msg) {
			     $('#uploadbutton').show(); 	
			     $('#loadingInd').hide();	
			     alert("Couldn't upload file");
			  }
		     });
		     //TEMP FILE
		     $( ".uploadDialogBtnTemp" ).button().on( "click", function() {
					$("#upItemNoTemp").val($(this).val());
					$("#upDocTypeTemp").val("VNRH");
					$("#fileTemp").val("");
				       $('#uploadModTemp').modal('show');
					return false;
		     }); 
		     
		     $('#uploadFormTemp').ajaxForm({
			  beforeSubmit: valUploadFormTemp,	
			  success: function(msg) {
			  //alert("alerttest"+msg);
			      $('#uploadbuttonTemp').show(); 	
			      $('#loadingIndTemp').hide();
			      msg=$.trim(msg);
			      if(msg.split("##")[0] === 'true')
			      {
			      	  $('#noDataStatUpload').hide();
				  var upItemNo = "H";
				  var docType = $('#upDocTypeTemp').val();
				  var fileNameTemp = msg.split("##")[1];
				  $('#uploadTable'+upItemNo).append('<tr><td align="left" width="95%"><input type="hidden" name="fileItemTemp" value="'+fileNameTemp+'"><a href="javascript:downloadFilePreView(\''+upItemNo+'\',\''+fileNameTemp+'\')">'+fileNameTemp+'</a></td><td width="5%"><span onclick="javascript:deleteFile(this,\''+upItemNo+'\',\''+fileNameTemp+'\')" class="fa fa-trash fa-lg" style="margin-left: 25%;"></span></td></tr>')
			      }
			      //alert("File has been uploaded successfully");
			      $('#uploadModTemp').modal('hide');
			 },
			  error: function(msg) {
			     $('#uploadbuttonTemp').show(); 	
			     $('#loadingIndTemp').hide();	
			     alert("Couldn't upload file");
			  }
		     });		     
		  });
	
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
		/*
		$('input[name="fileItem'+upItemNo+'"]').each(function(){
		  if($(this).val() == fileName)
		  {
			alert("File already uploaded");
			isValid = false;
			return false;
		  }	  
		});
		*/
		if(isValid)
		{
			$('#uploadbutton').hide(); 	
			$('#loadingInd').show();
		}
		return isValid;
	 }
	function valUploadFormTemp()
	{
		var upItemNo = $('#upItemNoTemp').val();
		var fileName = $('#fileTemp').val().replace(/C:\\fakepath\\/i, '');
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
			$('#uploadbuttonTemp').hide(); 	
			$('#loadingIndTemp').show();
		}
		return isValid;
	}	 	 
		  
		  
		  
		  
	</script>
	<script>
		function addLine(tabName)
		{
			var tabObj		= document.getElementById(tabName)
			var rowItems 		= tabObj.getElementsByTagName("tr");
			var rowCountValue 	= rowItems.length;
			
			
			
			var itemNumber_JS	= parseFloat(rowCountValue);
			if(itemNumber_JS>=6 && tabName=="TopCusTab") return false;
			if(itemNumber_JS>=1 && tabName=="plantSiteTab")
			if(itemNumber_JS>=1 && tabName=="DPASiteTab")
			if(itemNumber_JS>3 && tabName=="contactTab") 
			
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
			
			if(tabName=="DPASiteTab")
			{
				eleVal[0] =itemNumber_JS+'<input type="hidden" name="DPASLineNumber" value="'+itemNumber_JS+'" >';
				eleVal[1] ='<input type="text" class="form-control" id="dpaPersonName_'+itemNumber_JS+'" maxlength="30" name="dpaPersonName_'+itemNumber_JS+'" value="" >'
				eleVal[2] ='<input type="text" class="form-control" id="dpaAddress_'+itemNumber_JS+'"    maxlength="15"  name="dpaAddress_'+itemNumber_JS+'" value="" >';
				eleVal[3] ='<input type="text" class="form-control" id="dpaPhoneNum_'+itemNumber_JS+'   maxlength="40" name="dpaPhoneNum_'+itemNumber_JS+'" value="" >';
				eleVal[4] ='<input type="text" class="form-control" id="dpaEmail_'+itemNumber_JS+'" maxlength="30" name="dpaEmail_'+itemNumber_JS+'" value="" >'
				
			}
			if(tabName=="plantSiteTab")
			{
				eleVal[0] =itemNumber_JS+'<input type="hidden" name="plantSiteLineNumber" value="'+itemNumber_JS+'" >';
				eleVal[1] ='<input type="text" class="form-control" id="plantName_'+itemNumber_JS+'" maxlength="30" name="plantName_'+itemNumber_JS+'" value="" >'
				eleVal[2] ='<input type="text" class="form-control" id="product_'+itemNumber_JS+'" maxlength="15" name="product_'+itemNumber_JS+'" value="" >';
				eleVal[3] ='<input type="text" class="form-control" id="sq_Footage_'+itemNumber_JS+'" maxlength="40" name="sq_Footage_'+itemNumber_JS+'" value="" >';
				eleVal[4] ='<input type="text" class="form-control" id="total_No_Of_Machines_'+itemNumber_JS+'" maxlength="30" name="total_No_Of_Machines_'+itemNumber_JS+'" value="" >'
				eleVal[5] ='<input type="text" class="form-control" id="total_Employees_'+itemNumber_JS+'" maxlength="30" name="total_Employees_'+itemNumber_JS+'" value="" >'
				eleVal[6] ='<input type="text" class="form-control" id="monthly_Production_'+itemNumber_JS+'" maxlength="30" name="monthly_Production_'+itemNumber_JS+'" value="" >'
						
			}
			if(tabName=="TopCusTab")
			{
				eleVal[0] =itemNumber_JS+'<input type="hidden" name="TopCusLineNumber" value="'+itemNumber_JS+'" >';
				eleVal[1] ='<input type="text" class="form-control" id="TopCusName_'+itemNumber_JS+'" maxlength="30" name="TopCusName_'+itemNumber_JS+'" value="" >'
				eleVal[2] ='<input type="text" class="form-control" id="TopCusPrdOff_'+itemNumber_JS+'" maxlength="15" name="TopCusPrdOff_'+itemNumber_JS+'" value="" ><span id="errmsg_'+itemNumber_JS+'" style="color:red"></span>';
				eleVal[3] ='<input type="text" class="form-control" id="TopCusValue_'+itemNumber_JS+'" maxlength="40" name="TopCusValue_'+itemNumber_JS+'" value="" ><span id="erremail_'+itemNumber_JS+'" style="color:red"></span>';
				eleVal[4] ='<input type="text" class="form-control" id="TopCusPerOfTotBusiness_'+itemNumber_JS+'" maxlength="30" name="TopCusPercntOfTotBusiness_'+itemNumber_JS+'" value="" >'
				eleVal[5] ='<input type="text" class="form-control" id="TopCusContPerson_'+itemNumber_JS+'" maxlength="30" name="TopCusContPerson_'+itemNumber_JS+'" value="" >'
				eleVal[6] ='<input type="text" class="form-control" id="TopCusPhone_'+itemNumber_JS+'" maxlength="30" name="TopCusPhone_'+itemNumber_JS+'" value="" >'

			}
			
			if(tabName=="contactTab")
			{
				eleVal[0] =itemNumber_JS+'<input type="hidden" name="tLineNumber" value="'+itemNumber_JS+'" >';
				eleVal[1] ='<input type="text" class="form-control validate[required]" data-errormessage-value-missing="Please Enter Contact Person" id="contactName_'+itemNumber_JS+'" maxlength="30" name="contactName_'+itemNumber_JS+'" value="" >'
				eleVal[2] ='<input type="text" onkeyup= validphone("contactPhone_'+itemNumber_JS+'",'+itemNumber_JS+') class="validate[required,custom[phone]] form-control" id="contactPhone_'+itemNumber_JS+'" maxlength="15" data-errormessage-value-missing="Please Enter Contact Phone" name="contactPhone_'+itemNumber_JS+'" value="" ><span id="errmsg_'+itemNumber_JS+'" style="color:red"></span>';
				eleVal[3] ='<input type="text" class="form-control validate[required]" data-errormessage-value-missing="Please Enter Contact Person Designation" id="contactDesgtn_'+itemNumber_JS+'" maxlength="30" name="contactDesgtn_'+itemNumber_JS+'" value="" >'
			}
	
			var rowId = tabObj.insertRow(rowCountValue);
			for(i=0; i<eleVal.length;i++){
				var cell0=rowId.insertCell(i);
				cell0.align = eleAlign[i];
				cell0.innerHTML =eleVal[i];
			}
			 
			
		}
		
		
		function funSubmit(status)
		{
			//alert("status"+status);
			//alert("CHK1");	
			var qcfNo='<%=docId%>';
			var uRole='<%=userRole%>';
			$.ajax({
				url: '../RFQ/ezCheckQCFQuery.jsp', 
				data: { "qcfNo":qcfNo},
				type: 'POST',
				success: function(result) {
				result=$.trim(result);  
				//alert("result>>>>"+result.split("#")[1]);
				if(result.split("#")[1] == "Q")
				{
				    alert("Vendor Registration: "+qcfNo+" cannot be approved/rejected as you have sent a query");
				    return;
				}
				else
				{
					if(status != "R" && uRole == "LB")
					{
						if(document.myForm.recType.value == "")
						{
							$('#recType').validationEngine('showPrompt', 'Please select Recon Account Type', '');
							$('#recType').focus();
							return;	
						}

						
						if(document.myForm.recType.value != "" && document.myForm.reconAccount.value == "")
						{

							$('#reconAccount').validationEngine('showPrompt', 'Please select Recon Account', '');
							$('#reconAccount').focus();
							return;
						}
						
					}
					
					if(document.myForm.comments.value=="")
					{
						//alert("Please Enter Comments");
						$('#comments').validationEngine('showPrompt', 'Please Enter Comments', '');
						$('#comments').focus();
						return;
					}

					
					else
					{
						if(status == "V") 
						{
							if(!$("#myForm").validationEngine('validate'))
							{
								return ;
							}
							else
							{
								$('#myForm').find('input, textarea, select').attr('disabled',false);
								document.myForm.actionSts.value=status;
								document.myForm.action="ezSubmitVendRegOthMat.jsp"; 
								//document.myForm.action="ezSubmitVendRegOthMat_new.jsp"; 
								document.myForm.submit();
							}	
						}
						else if(status == "U") 
						{
							if(!$("#myForm").validationEngine('validate'))
							{
								return ;
							}
							else
							{
								$('#myForm').find('input, textarea, select').attr('disabled',false);
								document.myForm.actionSts.value=status;
								document.myForm.action="ezSubmitVendRegOthMat.jsp"; 
								document.myForm.submit();
							}	
						}						
						else if(status == "P")
						{
							if(confirm("Are you sure you want to submit to SAP?"))
							{					
								$('#myForm').find('input, textarea, select').attr('disabled',false);
								document.myForm.actionSts.value=status;
								$("#postSAP").hide();						
								document.myForm.action="ezPostImpVendorToSAP.jsp"; 
								document.myForm.submit();
							}
						}
						
						else if(status == "R")
						{
							if(confirm("Are you sure you want to Reject?"))
							{					
								$('#myForm').find('input, textarea, select').attr('disabled',false);
								document.myForm.actionSts.value=status;
								document.myForm.action="ezSubmitVendRegOthMat.jsp"; 
								document.myForm.submit();
							}
						}
						else if(status == "B")
						{
							if(confirm("Are you sure you want to Send Back to Vendor?"))
							{					
								$('#myForm').find('input, textarea, select').attr('disabled',false);
								document.myForm.actionSts.value=status;
								document.myForm.action="ezSubmitVendRegOthMat.jsp"; 
								document.myForm.submit();
							}
						}
						
						
						
						/*else if(status=="S"){															
								if(userRole=="VNR"){								
									if(document.myForm.docAck.value==""){
										alert("User Role"+<%=userRole%>);
										//$('#docAck').validationEngine('showPrompt', 'Document Verification YES or NO', '')
										$('input:radio[name="docAck"]').validationEngine('showPrompt','Document Verification YES or NO', '');																		
									}
								}
								
						
						}*/
						else 
						{
							var role = '<%=userRole%>';
							var chkStr = '<%=showStr%>';
							//alert("chkStr>>>"+chkStr);
							/*if((chkStr == "Y") &&(role == "VAR"))
							{
								//alert("Vendor IFSC code doesn't exist in SAP");
								//$('#rtgs_Code').validationEngine('showPrompt','Vendor IFSC code doesn`t exist in SAP', '');
								//$('#rtgs_Code').focus();
								return ;
							}
							else
							{*/
								/*if(!$("#myForm").validationEngine('validate'))
								{
									return ;
								}							

								else
								{*/
								
									$('#myForm').find('input, textarea, select').attr('disabled',false);
									document.myForm.actionSts.value=status;
									document.myForm.action="ezSubmitVendRegOthMat.jsp"; 
									document.myForm.submit();
									
								//}	
							//}		
						}
					}
				}
			
			}, 
			error: function()
			{
				alert("error::");
			}
			});	
		}
		$(document).ready(function() {
		
			$("#myForm").validationEngine();
			$("#uploadForm").validationEngine();
			$('#validityDate').datepicker({
				 format:'dd/mm/yyyy',
				 autoclose: true
    			});
    		});
		function deleteFile(thisObj,upItemNo,fileName,upDocType)
		{
			//itemCnt = itemCnt-1;
			var upDocId 	= $('#upDocId').val();
			
			$.ajax({
			    url: 'ezDeleteFile.jsp',
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
		function onlyNumbers(evt)
		{
			var e = event || evt;
			var charCode = e.which || e.keyCode;
			if(charCode > 31 && (charCode < 48 || charCode > 57 ) && charCode !== 43 )
			{
				return false;
			}
			return true;
		}
		
		/*function downloadFile(upItemNo,fileName)
		{
			//alert("fileName>>"+fileName);
			var upDocId 	= $('#upDocId').val();
			var upDocType 	= $('#upDocType').val();
			window.open("../Inbox/ezFileDownloadN.jsp?upDocId="+upDocId+"&upDocType="+upDocType+"&upItemNo="+upItemNo+"&fileName="+fileName);
		}*/
		 
		function downloadFile(status,upItemNo,fileName,upDocType)
		{
			var upDocId 	= document.myForm.docId.value;
			fileName=encodeURIComponent(fileName);
			window.open("../Inbox/ezDownloadFile.jsp?upDocId="+upDocId+"&upDocType="+upDocType+"&upItemNo="+upItemNo+"&fileName="+fileName);
		}
		function downloadFileNew(upItemNo,fileName)
		{
			//alert("fileName>>"+fileName);
			var upDocId 	= $('#upDocId').val();
			var upDocType 	= "VNRH";
			//alert("upDocType>>"+upDocType);
			window.open("../Inbox/ezFileDownloadN.jsp?upDocId="+upDocId+"&upDocType="+upDocType+"&upItemNo="+upItemNo+"&fileName="+fileName);
		}
		function downloadFilePreView(upItemNo,fileName)
		{
			var upDocId 	= $('#upDocId').val();
			var upDocType 	= "VNRH";
			window.open("../Inbox/ezFileDownloadEnter.jsp?upDocId="+upDocId+"&upDocType="+upDocType+"&upItemNo="+upItemNo+"&fileName="+fileName);
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
	function setSelectBoxVal(eleName,eleVal,disableFlg) 
	{
		var tempVal = eval("document.myForm."+eleName);
 
		 if(typeof  tempVal != "undefined")
		 {
			  tempVal.value = eleVal;
			  tempVal.disabled=disableFlg;
		 }
    	}
	var gstArr = [];
	<%
			set = gstStateCodeMap.entrySet(); 
			i = set.iterator();
			while(i.hasNext()) 
			{
				Map.Entry me = (Map.Entry)i.next();
							
	%>
				gstArr["<%=me.getKey()%>"]="<%=me.getValue()%>";
							
	<%
	
			}
	%>
	
	function validateGST()
	{
			var gstVendorClas = document.myForm.gstVendorClas.value;
			if(gstVendorClas == "")
			{
				$('#gstVendorClas').validationEngine('showPrompt', 'Please Select GST Staus of Firm', '')
				document.myForm.gstVendorClas.value = "";
				return ;
			}
			var gstVendorClas = document.myForm.gstVendorClas.value;
			if(gstVendorClas == "Y" && gstType == "" )
			{
				$('#gstType').validationEngine('showPrompt', 'Please provide Type of Registration', '')
				document.myForm.gstType.value = "";
				return ;
			}			
			var gstCd = document.myForm.gst_Number.value;
			var panCd = document.myForm.PAN_Number.value;
			var state = document.myForm.state.value;
			//debugger;
			gstCd = gstCd.toUpperCase();
			panCd = panCd.toUpperCase();
			if(panCd == "")
			{
				$('#PAN_Number').validationEngine('showPrompt', 'Please Enter PAN Number', '')
				//document.myForm.PAN_Number.value = "";
				return ;
			}			
			if(gstCd.length != 15)
			{
				$('#gst_Number').validationEngine('showPrompt', 'GST number should contain 15 charcters', '')
				document.myForm.gst_Number.value = "";
				return ;
			}
			var gstStateCode = gstCd.substring(0,2);
			if(typeof gstArr[state] === "undefined")
			{
				$('#gst_Number').validationEngine('showPrompt', 'GST Code must start with valid state code', '')
				document.myForm.gst_Number.value = "";
				return ;
			}
			if(gstStateCode !== gstArr[state])
			{
				$('#gst_Number').validationEngine('showPrompt', 'GST Code must start with '+gstArr[state], '')
				document.myForm.gst_Number.value = "";
				return ;
			}
			var res = gstCd.substring(2,12);
			if(res!=panCd)
			{
				$('#gst_Number').validationEngine('showPrompt', '3rd Digit to 12th Digit of GST number should be EQUAL to PAN Number', '')
				document.myForm.gst_Number.value = "";
				return ;
			}
			var res1 = gstCd.substring(13,14);
			if(res1!='Z')
			{
				$('#gst_Number').validationEngine('showPrompt', '14th Digit of GST number should be EQUAL to Z', '')
				document.myForm.gst_Number.value = "";
				return ;
			}			
	}
	function funQuery(docId,docType,compCode,plant,category,docValue)
	{
		//alert("TEST in SCRIPT");
		var url="../Misc/ezShowQuery2.jsp?docId="+docId+"&docType="+docType+"&compCode="+compCode+"&plant="+plant+"&category="+category+"&docValue="+docValue; 
		document.myForm.commentType.value="QUERY";
		$('iframe').attr("src",url);
		$('#woModal').modal({show:true});
	}
	function funShowApprovalHirearchy(compCode,purOrg,category,docValue)
	{
		var url="../Misc/ezShowVNRApprovalHirearchy.jsp?compCode="+compCode+"&plant="+purOrg+"&category="+category+"&docValue="+docValue;
		$('iframe').attr("src",url);
		$('#woModal').modal({show:true});
	}
	function funAuditTrail(docId,docType)
	{
		var url="../Misc/ezShowAuditTrail.jsp?docId="+docId+"&docType="+docType;
		$('iframe').attr("src",url);
		$('#woModal').modal({show:true});
	}	
	function closeIframe()
	{
	   $('#woModal').modal('toggle');
	}

	function showMSME(fieldObj)
	{
		var fieldVal = fieldObj.value;
		//alert(":::fieldVal:::"+fieldVal);
		if(fieldVal=="1" || fieldVal=="5" || fieldVal=="9")
		{
			document.getElementById("msmeInfo").style.display="";
		}
		else
		{
			document.getElementById("msmeInfo").style.display="none";
			
		}
	}
	function showUnit(fieldObj)
	{
		var fieldVal = fieldObj.value;
		if(fieldVal=="Y")
		{
			document.getElementById("vendUnit").style.display="";
		}
		else
		{
			document.getElementById("vendUnit").style.display="none";
			
		}
	}
	function showOtherBus(fieldObj)
	{
		var fieldVal = fieldObj.value;
		if(fieldVal=="OTH")
		{
			document.getElementById("otherBus").style.display="";
		}
		else
		{
			document.getElementById("otherBus").style.display="none";

		}
	}
	function showUnit(fieldObj)
	{
		var fieldVal = fieldObj.value;
		if(fieldVal=="Y")
		{
			document.getElementById("vendUnit").style.display="";
		}
		else
		{
			document.getElementById("vendUnit").style.display="none";
			
		}
	}	
	function showDtls(fieldObj)
	{
		var fieldVal = fieldObj.value;
		if(fieldVal=="Y")
		{
			document.getElementById("vendDtls").style.display="";
		}
		else
		{
			document.getElementById("vendDtls").style.display="none";
		}
	}
	function showSite(fieldObj)
	{
		var fieldVal = fieldObj.value;
		if(fieldVal=="Y")
		{
			document.getElementById("sitePerson").style.display="";
			document.getElementById("siteViDt").style.display="";
		}
		else
		{
			document.getElementById("sitePerson").style.display="none";
			document.getElementById("siteViDt").style.display="none";			
		}
	}	
	function funSelWithHold()
	{
	
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
					if(xmlhttp.responseText!=null)
					{
						if(eval('document.myForm.whTaxType').value!="")
						{
						 document.getElementById("WTT").innerHTML =xmlhttp.responseText;
						 $('.select2').select2()	
						}
						
					}
				}
			}
			xmlhttp.open("post","ezGetWithHoldDtls.jsp?cKey="+document.myForm.whTaxType.value+"&date="+new Date(),false);
			xmlhttp.send();	
	}
	function funSelCountry()
	{
			//$('#isCountryIndia').empty();
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
					if(xmlhttp.responseText!=null)
					{
						if(eval('document.myForm.country').value!="")
						{
							if(eval('document.myForm.country').value=="IN"){
								document.getElementById('isCountryIndia').style.display="block";																
							}
							if(eval('document.myForm.country').value!="IN"){
								document.getElementById('isCountryIndia').style.display="none";								
							}							
							/*if(eval('document.myForm.country').value!="IN"){															
								document.getElementById('isCountrystatus').style.display="none"								
							}*/
							if(eval('document.myForm.country').value=="IN"){															
								document.getElementById('isCountrystatus').style.display="block";															
							}
							
							
						 document.getElementById("REGION").innerHTML =xmlhttp.responseText;
						 $('.select2').select2()	
						}
						
					}
				}
			}
			xmlhttp.open("post","ezGetRegionDtls.jsp?cnKey="+document.myForm.country.value,false);
			xmlhttp.send();	
	}	
	
	function isValidComInfo()
	{
		var country = document.myForm.country.value;
		//alert(":::country:::"+country);
		if(country=="IN"){
		var panAttach = document.myForm.PAN_Attach.value;
		var panName = document.myForm.PAN_Name.value;
		var panCd = document.myForm.PAN_Number.value;
		var panTabLen = $('#VENDREGPANTABLE tr').length;
		
		if(panAttach == "Y" && panName == "")
		{
			$('#PAN_Name').validationEngine('showPrompt', 'Please Enter Legal Name', '')
			//document.myForm.PAN_Number.value = "";
			return false;
		}				
		else if(panAttach == "Y" && panName!="" && panCd == "")
		{
			$('#PAN_Number').validationEngine('showPrompt', 'Please Enter PAN Number', '')
			//document.myForm.PAN_Number.value = "";
			return false;
		}
		else if(panAttach == "Y" && panName!="" && panCd!="" && panTabLen == 0)
		{
			$('#VENDREGPAN').validationEngine('showPrompt', 'Please upload PAN document', '')
			//document.myForm.PAN_Number.value = "";
			return false;
		}		
		
		
		var gstCd = document.myForm.gst_Number.value;
		var gstVendorClasVal = document.myForm.gstVendorClas.value;
		var gstType = document.myForm.gstType.value;
		var gstTabLen = $('#VENDREGGSTTABLE tr').length;
		if(gstVendorClasVal != "0" && gstType == "")
		{
			//alert("Please enter GST No");
			$('#gstType').validationEngine('showPrompt', 'Please Select Type of Registration', '')
			return false;
		}		
		else if(gstVendorClasVal != "0" && gstCd == "")
		{
			//alert("Please enter GST No");
			$('#gst_Number').validationEngine('showPrompt', 'Please enter GST Number', '')
			return false;
		}
		else if(gstVendorClasVal != "0" && gstTabLen == 0)
		{
			$('#VENDREGGST').validationEngine('showPrompt', 'Please upload GST document', '')
			return false;
		}
		else
		{
			return true;
		}
	}
	else
	{
		return true;
	}
		
	}
	function isValidFinInfo()
	{
			
		var vendJgl = document.myForm.vend_Jgl.value;
		var otherBusInfo = document.myForm.otherBusInfo.value;
		var vendUnit = document.myForm.vend_Unit.value;
		var busStatus = document.myForm.bus_Status.value;
		
		
		var vendTrans = document.myForm.vend_Trans.value;
		var vendDtls = document.myForm.vend_Dtls.value;	
		
		var vendSite = document.myForm.vend_Site.value;
		var sitePerson = document.myForm.sitePerson.value;		
		var siteViDt = document.myForm.siteViDt.value;		
		
		if(vendJgl == "Y" && vendUnit=="")
		{
			$('#vendUnit').validationEngine('showPrompt', 'Please provide Business Unit', '');
			return false;
		}
		else if(otherBusInfo == "Y" && busStatus=="")
		{
			$('#vendDtls').validationEngine('showPrompt', 'Please provide Other Details', '');
			return false;
		}
		else if(vendTrans == "Y" && vendDtls=="")
		{
			$('#vendDtls').validationEngine('showPrompt', 'Please provide Vendor Details', '');
			return false;
		}
		else if(vendSite == "Y" && sitePerson=="")
		{
			$('#sitePerson').validationEngine('showPrompt', 'Please provide Name of the person', '');
			return false;
		}
		else if(vendSite == "Y" && siteViDt=="")
		{
			$('#siteViDt').validationEngine('showPrompt', 'Please provide Visited Date', '');
			return false;
		}
		else
		{	return true;
		
		}

	}
	function isValidAttachments()
	{
		// GETTING VENDOR TYPE "IN" OR "IM" And Vendor Country
		var vendType='<%=vendType%>';		
		var country = document.myForm.country.value;
		var compCode = document.myForm.compCode.value;
		
		//GETTING W9 Attachment  
		var w9TabLen = $('#VENDW9TABLE tr').length;		
		var w9Attach = document.myForm.w9Attach.value;
		
		//GETTING W8 Attachment		
		var w8TabLen = $('#VENDW8TABLE tr').length;		
		var w8Attach = document.myForm.w8Attach.value;
		
		//alert("::country::::::::"+country);
		//alert("::vendType::::::::"+vendType);
		//alert("::w9TabLen::::::::"+w9TabLen);
		//alert("::w9Attach::::::::"+w9Attach);
		//alert("::w8TabLen::::::::"+w8TabLen);
		//alert("::w8Attach::::::::"+w8Attach);
		
		if(country=="IN")
		{
			return true;
		}
		if(vendType!="IN")		
		{
			//alert("::country:::::NON-US-Vendor:::"+country);
			if(w8Attach=="" && w8TabLen==0)
			{
				$('#w8Attach').validationEngine('showPrompt', 'Please provide W8 Form Details', '');
				$('#VENDW8TABLE').validationEngine('showPrompt', 'Please provide W8 Form file', '');
				return false;
			}
			if(w8Attach=="")
			{
				$('#w8Attach').validationEngine('showPrompt', 'Please provide W8 Form Details', '');
				return false;
			}
			if(w8TabLen==0)
			{
				$('#VENDW8TABLE').validationEngine('showPrompt', 'Please provide W8 Form file', '');
				return false;
			}
			if(w8Attach!="" && w8TabLen!=0)
			{
				return true;
			}
		}
		if(vendType=="IN")
		{
			//alert("::compCode::::::::"+compCode);
			
			if("IN"==vendType && w9Attach=="")
			{
				if(compCode=="7300" || compCode=="4101" || compCode=="9000")
				{
					$('#w9Attach').validationEngine('showPrompt', 'Please provide W9 Form Details', '');
					return false;
				}
			}
			if("IN"===vendType && w9TabLen==0 )
			{
				if(compCode=="7300" || compCode=="4101" || compCode=="9000")
				{
					$('#VENDW9TABLE').validationEngine('showPrompt', 'Please provide W9 Form file', '');
					return false;
				}
			}
			if("IN"===vendType && w9Attach=="" && w9TabLen==0)
			{
				if(compCode=="7300" || compCode=="4101" || compCode=="9000")
				{
					$('#w9Attach').validationEngine('showPrompt', 'Please provide W9 Form Details', '');
					$('#VENDW9TABLE').validationEngine('showPrompt', 'Please provide W9 Form file', '');
					return false;
				}
			}
			else
			{
				return true;
			}
			
		
			
		}		
	}
	
	var disableFlag=false
	
	setSelectBoxVal('title','<%=title%>',disableFlag);
	//setSelectBoxVal('state','<%=State%>',disableFlag);
	setSelectBoxVal('contactTitle_1','<%=checkNull(contactMap.get("contactTitle_1"))%>',disableFlag);
	
	//setSelectBoxVal('state','<%=checkNull(regDesc)%>',disableFlag);
	setSelectBoxVal('PAN_Attach','<%=PAN_Attach%>',disableFlag);
</script>
<script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.js"></script>
<script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.pack.js"></script>
