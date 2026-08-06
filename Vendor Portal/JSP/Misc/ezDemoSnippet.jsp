<%@ include file="../Assets/Library/Globals/ezErrorPagePath.jsp"%>
<%@ include file="../Assets/Library/Globals/ezCheckValidUser.jsp"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ include file="../Includes/JSPs/iGetDefectCodes.jsp"%>
<%@ include file="ezGetAllSessionValues.jsp"%>
<jsp:useBean id="servAdmManager" class="ezc.service.admin.client.EzServiceAdminManager" scope="page" />
<jsp:useBean id="CustomerManager" class="ezc.ezcustomer.client.EzCustomerManager" scope = "page"/>
<%@ include file="ezGetNotifCodeDesc.jsp"%>
<%@ page import="ezc.service.admin.params.*" %>
<%
	String eqipNum=request.getParameter("eqipNum");
	String dealerName=(String)session.getValue("LOGGED_IN_USER_NAME");
	boolean isAPB = ("1100".equals(salesOrg) || "1500".equals(salesOrg));
	
	String defectCodeOpionsStr = "", damageCodeOpionsStr = "", causeCodeOpionsStr = "";
		
	String tempCode = "", tempDesc = "";
	for(int d=0;d<retNotifCodesObjCnt;d++) 
	{
		//if(!"DE".equals(retNotifCodesObj.getFieldValueString(d,"ESCC_CATALOG_TYPE")))
		//{
		if("1100".equals(salesOrg) && !retNotifCodesObj.getFieldValueString(d,"ESCC_CODE_GROUP").startsWith("APB"))
			continue;

		if("1300".equals(salesOrg) && !retNotifCodesObj.getFieldValueString(d,"ESCC_CODE_GROUP").startsWith("AEB"))
			continue;	
		//}		

		if("DE".equals(retNotifCodesObj.getFieldValueString(d,"ESCC_CATALOG_TYPE")))
		{
			tempCode = retNotifCodesObj.getFieldValueString(d,"ESCC_CODE_GROUP")+"¥"+retNotifCodesObj.getFieldValueString(d,"ESCC_CODE");
			tempDesc = retNotifCodesObj.getFieldValueString(d,"ESCC_DESCRIPTION");

			if(!"FLD".equals(retNotifCodesObj.getFieldValueString(d,"ESCC_CODE")) && !"BDR".equals(retNotifCodesObj.getFieldValueString(d,"ESCC_CODE")) && !"IAC".equals(retNotifCodesObj.getFieldValueString(d,"ESCC_CODE")) && !"PRC".equals(retNotifCodesObj.getFieldValueString(d,"ESCC_CODE")) && !"PVM".equals(retNotifCodesObj.getFieldValueString(d,"ESCC_CODE")) && !("PRI".equals(retNotifCodesObj.getFieldValueString(d,"ESCC_CODE"))) && !("BCP".equals(retNotifCodesObj.getFieldValueString(d,"ESCC_CODE"))))
				continue;

			if("1100".equals(salesOrg) && !retNotifCodesObj.getFieldValueString(d,"ESCC_CODE_GROUP").startsWith("APB"))
				continue;

			if("1200".equals(salesOrg) && !retNotifCodesObj.getFieldValueString(d,"ESCC_CODE_GROUP").startsWith("FEB"))
				continue;

			if("1300".equals(salesOrg) && !retNotifCodesObj.getFieldValueString(d,"ESCC_CODE_GROUP").startsWith("AEB"))
				continue;

			if("1400".equals(salesOrg) && !retNotifCodesObj.getFieldValueString(d,"ESCC_CODE_GROUP").startsWith("CEB"))
				continue;	
			if("1500".equals(salesOrg) && !retNotifCodesObj.getFieldValueString(d,"ESCC_CODE_GROUP").startsWith("IEB"))
				continue;	

			defectCodeOpionsStr += "<option value='"+tempCode+"'>"+tempDesc+"</option>";
		}
		else if("DM".equals(retNotifCodesObj.getFieldValueString(d,"ESCC_CATALOG_TYPE")))
		{
			if("1200".equals(salesOrg) && !retNotifCodesObj.getFieldValueString(d,"ESCC_CODE_GROUP").startsWith("FEB"))
				continue;

			if("1400".equals(salesOrg) && !retNotifCodesObj.getFieldValueString(d,"ESCC_CODE_GROUP").startsWith("CEB"))
				continue;

			if("1100".equals(salesOrg) && !retNotifCodesObj.getFieldValueString(d,"ESCC_CODE_GROUP").startsWith("APB"))
				continue;
			if("1500".equals(salesOrg) && !retNotifCodesObj.getFieldValueString(d,"ESCC_CODE_GROUP").startsWith("IEB"))
				continue;

			tempCode = retNotifCodesObj.getFieldValueString(d,"ESCC_CODE_GROUP")+"¥"+retNotifCodesObj.getFieldValueString(d,"ESCC_CODE");
			tempDesc = retNotifCodesObj.getFieldValueString(d,"ESCC_DESCRIPTION");

			damageCodeOpionsStr += "<option value='"+tempCode+"'>"+tempDesc+"</option>";
		}
		else if("CA".equals(retNotifCodesObj.getFieldValueString(d,"ESCC_CATALOG_TYPE")))
		{
			if("1400".equals(salesOrg) || "1200".equals(salesOrg))
			{
				if(retNotifCodesObj.getFieldValueString(d,"ESCC_CODE_GROUP").startsWith("APB") || retNotifCodesObj.getFieldValueString(d,"ESCC_CODE_GROUP").startsWith("AEB"))	
					continue;
			}

			tempCode = retNotifCodesObj.getFieldValueString(d,"ESCC_CODE_GROUP")+"¥"+retNotifCodesObj.getFieldValueString(d,"ESCC_CODE");
			tempDesc = retNotifCodesObj.getFieldValueString(d,"ESCC_DESCRIPTION");

			causeCodeOpionsStr += "<option value='"+tempCode+"'>"+tempDesc+"</option>";
		}
	}
	
	
%>
<Html>
<head>

<Style>
.process-step .btn:focus{outline:none}
.process{display:table;width:100%;position:relative}
.process-row{display:table-row}
.process-step button[disabled]{opacity:1 !important;filter: alpha(opacity=100) !important}
.process-row:before{top:25px;bottom:0;position:absolute;content:" ";width:100%;height:1px;background-color:#ccc;z-order:0}
.process-step{display:table-cell;text-align:center;position:relative}
.process-step p{margin-top:4px}
.btn-circle{width:50px;height:50px;text-align:center;font-size:12px;border-radius:50%}
.textbox { 
    -webkit-border-radius: 5px; 
    -moz-border-radius: 5px; 
    border-radius: 5px; 
    border: 1px solid #848484; 
    outline:0; 
    height:25px; 
    width: 275px; 
 }
  
</Style>

<meta charset="utf-8">
<meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
<link rel="stylesheet" href="../Assets/Library/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
<link rel="stylesheet" href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css">
<link rel="stylesheet" href="../Assets/Library/dist/css/AdminLTE.min.css">
<link rel="stylesheet" href="../Assets/Library/plugins/iCheck/square/blue.css">
<link rel="stylesheet" href="https://jqueryvalidation.org/files/demo/site-demos.css">


</head>
<body class="hold-transition login-page" >
<form name = "myForm" id="myForm">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css">
<input type=hidden name='equipDefectStr' value=''>
<input type=hidden name='serviceVisitStr' value=''>
<input type=hidden name='defectCodeDescription' value=''>
<input type=hidden name='damageCodeDescription' value=''>
<input type=hidden name='causeCodeDescription' value=''>

<div class="container">
	<div class="row">
	<br>
		<div class="process">
			<div class="process-row nav nav-tabs">
				<div class="process-step">
					<button type="button" class="btn btn-info btn-circle" data-toggle="tab" href="#menu1" disabled><i class="fa fa-info fa-2x"></i></button>
					<p><small><b>Equipment<br />Number</b></small></p>
				</div>
				<div class="process-step">
					<button type="button" class="btn btn-default btn-circle" data-toggle="tab" href="#menu2" disabled><i class="fa fa-file-text-o fa-2x"></i></button>
					<p><small><b>Equipment<br />Description</b></small></p>
				</div>
				<div class="process-step">
					<button type="button" class="btn btn-default btn-circle" data-toggle="tab" href="#menu3" disabled><i class="fa fa-cogs fa-2x"></i></button>
					<p><small><b>Service<br />Request</b></small></p>
				</div>
				<div class="process-step">
					<button type="button" class="btn btn-default btn-circle" data-toggle="tab" href="#menu4" disabled><i class="fa fa-check fa-2x"></i></button>
					<p><small><b>Submit</b></small></p>
				</div>
			</div>
		</div>
		<div class="tab-content">
			<div id="menu1" class="tab-pane fade active in">
				<div class="login-box">
					<div class="login-box-body">
						<div class="form-group has-feedback">
							<input type="text" class="form-control" placeholder="Equipment No." name="eqipNum" id="eqipNum">
						</div>
					</div>
				</div>
				<ul class="list-unstyled list-inline pull-right">
				<li id="butone"><button type="button" class="btn btn-info next-step">Next <i class="fa fa-chevron-right"></i></center></li>
				</ul>
			</div>
			<div id="menu2" class="tab-pane fade">
				<section class="content">
				<div class="row">
					<div class="col-md-12 col-xs-12">
						
						<div class="box-body ">

							<Table width=100% align=center style="background:white" border=1 frame=void rules=rows >
								<Tr>
									<Th  align="center">Equipment Number</Th>
									<Td  align="center" ><div class="eqipNo"></div></Td>
								</Tr>
								
								<Tr>
									<Th  align="center" >Equipment Description</Th>
									<Td  align="center"><div class="eqipDesc"></div></Td>
								</Tr>
								
								<Tr>
									<Th  align="center" >Dealer Name</Th>
									<Td  align="center" ><%=dealerName%></div></Td>
								</Tr>
							</Table>

						</div>
						
					</div>

					<div class="col-md-12 col-xs-12">
						
						<div class="box-body ">
							<Table width=100% align=center border=1  borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>
								<Tr>
									<Th  align="center"><Font color='RED'><center><B><div class="warStat"></div></B></center></Font></Th>
								</Tr>	
							</Table>
						</div>
						
					</div>
				</div>
				</section>
				<ul class="list-unstyled list-inline pull-right">
				<li><button type="button" class="btn btn-default prev-step"><i class="fa fa-chevron-left"></i> Back</button></li>
				<li><button type="button" class="btn btn-info next-step">Next <i class="fa fa-chevron-right"></i></button></li>
				</ul>
			</div>
			<div id="menu3" class="tab-pane fade">
				<section class="content">
				<div class="row">
					<div class="col-md-12 col-xs-12" >
						<div class="box-body" >

<%
							if(isAPB){
%>

								<label for="engineType"><b>Engine Type:</b></label>

										<select class="textbox" id="engineType" name="engineType" style="width: 100%" onchange="document.myForm.defectCode.value=''">
											<option value= "">--Select--</Option>
											<option value= "D">D - SERIES</Option>
											<option value= "G">G - SERIES</Option>
											<option value= "E">ESCORT SERIES</Option>
											<option value= "A">AEB - Single Cylinder Series</Option>
										</select><br>

<%
							}
%>
							<label for="shortText"><b>Request Description:<font color='red'>*</font></b></label>

								<textarea  id="shortText" rows="2" name="shortText" maxlength="100" style="width: 100%; resize:none"></textarea><br>
								 
							
							<label for="servReqPriority"><b>Priority:<font color='red'>*</font></b></label>
<%
							if(!"CALLEXE".equals(Session.getUserId()) && !"AM1013215".equals(Session.getUserId()))
							{
%>

									<Select class="required"  name="servReqPriority" id="servReqPriority" style="width: 100%">
										<Option value='' >--Select Priority--</Option>
										<Option value='2'>High  Priority Complaint</Option>
										<Option value='3'>Medium Priority Complaint</Option>
										<Option value='4'>Low Priority Complaint</Option>
									</Select><br>	

<%
							}else{
%>

									<Select class="textbox" name="servReqPriority" id="servReqPriority" style="width: 100%">
										<Option value='0'></Option>
										<Option value='2'>High  Priority Complaint</Option>
										<Option value='3'>Medium Priority Complaint</Option>
										<Option value='4'>Low Priority Complaint</Option>
									</Select><br>	
							
							<label for="requestType"><b>Request Type:</b></label>

									<Select  class="textbox" name="requestType" id="requestType" style="width: 100%" >
										<Option value=''>--Select Type--</Option>
										<Option value='major'>Major</Option>
										<Option value='minor'>Minor</Option>
									</Select><br>		
<%
							}
%>
							
							<label for="defectCode"><b>Defect Type:<font color='red'>*</font></b></label>
								<Select class="textbox" name="defectCode" id="defectCode" style="width: 100%" >
									<option value="">--Select Defect Type--</option>
									<%=defectCodeOpionsStr%>
								</Select><br>			
							
							<label for="mileageCheckType"><b>Mileage  Type:</b></label>
								<select class="textbox" name="mileageCheckType" id="mileageCheckType" style="width: 100%">
									<option value="">--Select check type--</option>
									<option Value="HRS">Hours</option>
									<option value="KM">Kilo Meters</option>
								</select><br>
								
							<label for="mileageValue"><b>Reading:</b></label>
								<input class="textbox" type="text"  id="mileageValue" name="mileageValue" maxlength="15" style="width:100%" ><br>
								
							<label for="curMileageValue"><b>Prev Value:</b></label>
								<input class="textbox" type="text" id="curMileageValue"  name="curMileageValue" style="width:100%"   value="" readonly><br>
								
							<label for="damageCode"><b>Damage Type:</b></label>
								<select class="textbox" name="damageCode" id="damageCode" style="width: 100%" >
									<option value="">--Select Damage Type--</option>
									<%=damageCodeOpionsStr%>
								</select><br>
								
							<label for="causeCode"><b>Reason:<font color='red'>*</font></b></label>
								<select class="textbox" name="causeCode" id="causeCode" style="width: 100%">
									<option value="">--Select Reason--</option>
									<%=causeCodeOpionsStr%>	
								</select><br>
								
							<label for="ContactNo"><b>Contact Number:<font color='red'>*</font> </b></label>
								<input type="text" class="textbox" id="ContactNo" name="ContactNo" value="" maxlength="10" style="width: 100%" onpaste="return false;" ><br>
								
							<label for="comments"><b>Comments :</b></label>
								<textarea  name ="comments" id="comments" placeholder="Maximum 1000 characters" rows="5"  maxlength="1000"  style="width: 100%; resize:none" ></textarea>

						</div>
						
						<%@ include file="ezCheckCustomerSEMapping.jsp"%>
							
						
<%
						if(retCustSeMapObjCnt==0)
						{
%>
							<center><b><font color='GREEN'>Service Engineer is not assigned. Please contact administrator.</b></center>	
<%
						}
%>
					</div>
				</div>
				</section>
				<ul class="list-unstyled list-inline pull-right">
				<li><button type="button" class="btn btn-default prev-step"><i class="fa fa-chevron-left"></i> Back</button></li>
				<li id="butThree"><button type="button" class="btn btn-info next-step" >Next <i class="fa fa-chevron-right"></i></button></li>
				</ul>
			</div>
			<div id="menu4" class="tab-pane fade">
				<h3>Service Request Submitted Successfully</h3>
				<ul class="list-unstyled list-inline pull-right">
				<li id='butDone'><button type="button" class="btn btn-success"><i class="fa fa-check" "></i> Done!</button></li>
				</ul>
			</div>
		</div>
	</div>
</div>
</form>
</Body>
<script src="../Assets/Library/jquery-validation-1.16.0/lib/jquery.js"></script>
<script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
<script src="../Assets/Library/jquery-validation-1.16.0/dist/jquery.validate.min.js"></script>
<script src="../Assets/Library/jquery-validation-1.16.0/dist/additional-methods.min.js"></script>
<script type="text/javascript">
$(function(){
  	
 $('.next-step, .prev-step').on('click', function (e){
  
   var $activeTab = $('.tab-pane.active');

   $('.btn-circle.btn-info').removeClass('btn-info').addClass('btn-default');

   if ( $(e.target).hasClass('next-step') )
   {
      var nextTab = $activeTab.next('.tab-pane').attr('id');
      if (!$("#myForm").valid()) {
         return;
      }
      $('[href="#'+ nextTab +'"]').addClass('btn-info').removeClass('btn-default');
      $('[href="#'+ nextTab +'"]').tab('show');
   }
   else
   {
      var prevTab = $activeTab.prev('.tab-pane').attr('id');
      $('[href="#'+ prevTab +'"]').addClass('btn-info').removeClass('btn-default');
      $('[href="#'+ prevTab +'"]').tab('show');
   }
 });
 
});



$(document).ready(function(){
	var eqipNum ="";
	var equipDesc ="";
	var equipDefectStr ="";
	var serviceVisitStr ="";
	var warrantyStatus ="";
	$('#butone').click(function(){
		eqipNum = $("#eqipNum").val();
		$.post("../Includes/JSPs/iGetEquipDesc.jsp", {eqipNum: eqipNum} , function(data){
			var $response=$(data);
			equipDesc = $response.filter('#equipDesc').text();
			var warrantyDispMsg = $response.filter('#warrantyDispMsg').text();
			warrantyStatus = $response.filter('#warrantyStatus').text();
			var mileageValue = $response.filter('#mileageValue').text();
			equipDefectStr =$response.filter('#equipDefectStr').text();
			serviceVisitStr = $response.filter('#serviceVisitStr').text();	
			$('.eqipDesc').html(equipDesc);
			$('.warStat').html(warrantyDispMsg);
			$('.eqipNo').html(eqipNum);
			$('#curMileageValue').val(mileageValue);
		});
	});
	$('#butDone').click(function(){
		$(location).attr('href','ezDemoSnippet.jsp');
	});
	

	$(function() { 

		 if(<%=isAPB%>)
		 {
			var defArrDesc = new Array();
			defArrDesc["PRC"] = "Pre-commissioning";
			defArrDesc["IAC"] = "Installation and commissioning";
			defArrDesc["PVM"] = "Preventive Maintenance";
			defArrDesc["PRI"] = "Pre Inspection";
			defArrDesc["BCP"] = "Before Commissioning Problems";

			$.validator.addMethod("empty", function() {
			    return $('#defectCode').val() != "";
			}, 'Please select Defect Type');
			$.validator.addMethod("mileageValid", function() {
				return $('#mileageCheckType').val() != "";
			}, 'Please select Mileage Type');

			$.validator.addMethod("PRCValid", function(value) { 
			    return !($('#engineType').val() != "D" && $('#engineType').val() != "G" && value.split('¥')[1]=="PRC");
			}, "Defect type pre-commisiong(PRC) not allowed for the given engine");

			$.validator.addMethod("PRIValid", function(value) { 
				return !($('#engineType').val() != "D" && $('#engineType').val() != "G" && value.split('¥')[1]=="PRI");
			}, "Defect type pre-commisiong(PRI) not allowed for the given engine");

			$.validator.addMethod("defectValid", function(value) { 
				if(equipDefectStr.indexOf("PVM") >=0)
				{
					return !(value.split('¥')[1]=="PRC" || value.split('¥')[1]=="IAC" || (value.split('¥')[1]=="PVM" && (serviceVisitStr.indexOf("D") > 0 || equipDefectStr.match(/PVM/g) > 3)));
				}
			}, "Selected Defect type is not allowed for equipment, Please recheck the history");

			$.validator.addMethod("defectValid1", function(value) { 
				if(equipDefectStr.indexOf("PRI") >=0)
				{
					return !(value.split('¥')[1]=="PRI");
				}
			}, "Selected Defect type is not allowed for equipment, Please recheck the history");

			$.validator.addMethod("defectValid2", function(value) { 
				if(equipDefectStr.indexOf("IAC") >=0)
				{
					return !(value.split('¥')[1]=="IAC" || value.split('¥')[1]=="PRC" || value.split('¥')[1]=="BCP");
				}
			}, "Selected Defect type is not allowed for equipment, Please recheck the history");

			$.validator.addMethod("defectValid3", function(value) { 
				if(equipDefectStr.indexOf("PRC") >=0)
				{
					return !(value.split('¥')[1]=="PRC");
				}
			}, "Selected Defect type is not allowed for equipment, Please recheck the history");

		}
		$.validator.addMethod("mileageValid1", function(value) { 
			if(value.split('¥')[1]=="BDR" || value.split('¥')[1]=="FLD" || value.split('¥')[1]=="PVM")
			{
<%
				if(!"1200".equals(salesOrg))	
				{
%>  
				return $("#mileageCheckType").val('HRS');
<%
				}
%>
			}
		}, "Mileage details are mandatory for the defect type's:\n Breakdown repair \n Field Complaint \n Preventive Maintenance");
		
			/*if((document.myForm.defectCode.value).split('¥')[1]=="PRC")
			{
				document.myForm.damageText.value="";
				document.myForm.causeText.value="";
				//document.getElementById("objectPart").selectedIndex=0;
				document.getElementById("damageCode").selectedIndex=0;
				document.getElementById("causeCode").selectedIndex=0;
				//document.getElementById('objectPart').disabled = true;
				document.getElementById('damageCode').disabled = true;
				document.getElementById('causeCode').disabled = true;
				document.getElementById('damageText').disabled = true;		
				document.getElementById('causeText').disabled = true;
			}
			else
			{
		
				//document.getElementById('objectPart').disabled = false;
				document.getElementById('damageCode').disabled = false;
				document.getElementById('causeCode').disabled = false;
				document.getElementById('damageText').disabled = false;
				document.getElementById('causeText').disabled = false;
			}*/
		$("#myForm").validate({

			 onfocusout: function (element) {
				$(element).valid();
			},
			rules: {
				eqipNum	: {               
					required: true

				  },            
				agree: 'required',

				engineType: {               
					required: function() {
					      return $('#engineType').val() != "";
					}
				  },            
				agree: 'required',

				shortText: {
					required: true,
					maxlength: 100
				},
				servReqPriority: {               
					required: function() {
					      return $('#servReqPriority').val() != "";
					}

				  },            
				agree: 'required',

				requestType: {               
					required: function() {
					      return $('#requestType').val() != "";
					}
				  },            
				agree: 'required',

				 defectCode: {               
					 empty: true,
					PRCValid: true,
					PRIValid: true,
					defectValid: true,
					defectValid1: true,
					defectValid2: true,
					defectValid3: true
				   },            
				 agree: 'required',

				 mileageCheckType: {   
				 	mileageValid: true,
				 	mileageValid1: true
				},
				
				mileageValue: {
					required: true,
					number: true
				},

				damageCode: {               
					required: function() {
					      return $('#damageCode').val() != "";
					}
				   }, 
				 agree: 'required',

				 causeCode: {               
					required: function() {
					      return $('#causeCode').val() != "";
					}
				   },            
				 agree: 'required',



				ContactNo : {
					required: true,
					minlength: 10,
					number: true
				},

				comments : {
					required: true,
					maxlength: 1000
				}
			},
			messages: {
				eqipNum: "Please enter Equipment No.",

				engineType: "Please select the Engine Type",

				shortText: {
					required: "Please Enter ShortText",
					maxlength: "shortText must be less than 100 characters"
				},
				servReqPriority: "Please select Priority",

				requestType: "Please select Request Type",




				mileageCheckType: "Please select Mileage Type",

				mileageValue: {
					required : "Please Enter the Mileage Value"+equipDesc,
					number : "Please enter Numeric value only"
				},
				damageCode : "Please select Damage Code",


				causeCode : "Please select Cause Code",

				ContactNo : {
					required: "Please Enter Contoct NO.",
					minlength: "Contoct NO. must consist of only 10 characters ",
					number: "Please enter Numeric value only"
				},
				comments : {
					required: "Please Enter Comments",
					maxlength:  "Comments must be less than 1000 character"
				}

			}
		});

 	});
});

</script>
</Html>    