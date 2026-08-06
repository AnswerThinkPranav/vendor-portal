<%@ page import = "java.text.*"%> 
<%@ page import = "java.util.Date"%>  
<%@ page import="ezc.vendorprofile.params.*,ezc.ezparam.*,ezc.ezworkflow.params.*,java.util.*" %>		
<%@ page import = "ezc.ezutil.FormatDate"%>
<%@ include file="../Misc/ezCommonMethods.jsp"%> 
<%@ include file="ezGetUserAuthDefaults.jsp"%> 
<%@ include file="../Misc/ezHeader.jsp"%> 
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<jsp:useBean id="EzWorkFlowManager" class="ezc.ezworkflow.client.EzWorkFlowManager" scope="session" />
<jsp:useBean id="vendorprofile" class="ezc.vendorprofile.client.EzVendorProfileManager" scope="session"></jsp:useBean>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"/>
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<Html>
<Head>
<meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
<link rel="stylesheet" type="text/css" href="../../Library/jquery/jquery-ui-1.12.1.custom/jquery-ui.css">
<link rel="stylesheet" href="../Misc/library/fancybox2/jquery.fancybox.css" type="text/css" media="screen" />	
<style>
.dashBoxHeader
{
	background-color: #3C8DBC;
	color: azure;
    	font-weight: bold;
}
.pinBoxHeader
{
	    float: right;
}
tr
{
	height: 39px;
}
input
{
	    border: none;
}

.my-error-class {
    float:none;
    color:red;
    display: block;
    padding-left: .5em;
   vertical-align: top; 
}
 <%	
 
 ReturnObjFromRetrieve docHeaderListRetObj=null;
 int docHeaderListRetObjCnt=0;
 String docStr="";
 		ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams 		= new EziMiscParams();

try{
		miscParams.setQuery("SELECT * FROM EZC_WF_WORKGROUP_USERS WHERE EWWU_USER ='"+Session.getUserId()+"'");

		mainParams.setObject(miscParams);
		mainParams.setLocalStore("Y");
		Session.prepareParams(mainParams);
		ReturnObjFromRetrieve userWorkGroupsRetObj = (ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);

		if(userWorkGroupsRetObj!=null)
		{
		userWfGroupsStr="";
		for(int i=0;i<userWorkGroupsRetObj.getRowCount();i++)
		{
			String DBUserGroup = checkNull(userWorkGroupsRetObj.getFieldValueString(i,"EWWU_GROUP"));

			if("".equals(userWfGroupsStr))
			userWfGroupsStr=DBUserGroup;
			else
			userWfGroupsStr=userWfGroupsStr+"','"+DBUserGroup;
		}
		}
	}catch(Exception e){System.out.println(e);}
		String wfCheckName 	= 	"'"+Session.getUserId()+"','"+userWfGroupsStr+"','"+userRole+"'";	
		ezc.ezcommon.EzLog4j.log("::wfCheckName::::"+wfCheckName,"I");
		mainParams	= new ezc.ezparam.EzcParams(false);			
		EziWFDocHistoryParams wfparams= new EziWFDocHistoryParams();
		wfparams.setAuthKey("'VENDOR_ENQUIRY'");

		wfparams.setStatus("'SUBMITTED'");
		wfparams.setParticipant(wfCheckName);
		
		mainParams.setObject(wfparams);
		Session.prepareParams(mainParams);
		try{
			docHeaderListRetObj = (ezc.ezparam.ReturnObjFromRetrieve)EzWorkFlowManager.getWFDocList(mainParams);
			//out.println("docHeaderListRetObj"+docHeaderListRetObj.toEzcString());

			docHeaderListRetObjCnt=docHeaderListRetObj.getRowCount();
		}catch(Exception e){}
	

		
	for(int i=0;i<docHeaderListRetObjCnt;i++)
	{
		if("".equals(docStr))
		docStr=checkNull(docHeaderListRetObj.getFieldValueString(i,"EWDHH_DOC_ID"));
		else
		docStr=docStr+"','"+checkNull(docHeaderListRetObj.getFieldValueString(i,"EWDHH_DOC_ID"));
	}
     	ReturnObjFromRetrieve retQuery	=  null;
     	int    QueryCnt	=  0;
     	
mainParams = new ezc.ezparam.EzcParams(true);
	ezc.vendorprofile.params.EziVendorGeneralDataParams generalParams= new ezc.vendorprofile.params.EziVendorGeneralDataParams();
	ezc.vendorprofile.params.EziVendorProfileKeyParams keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();
	EziVendorKeyParamsTable keyTableParams = new EziVendorKeyParamsTable();
		
	keyParams.setKey("GetGeneralData");
	keyTableParams.appendRow(keyParams);
	mainParams.setLocalStore("Y");
	
	generalParams.setDocId(docStr);
	
	mainParams.setObject(keyTableParams);	
	
	mainParams.setObject(generalParams);
	Session.prepareParams(mainParams);
	
	ReturnObjFromRetrieve vendorDtlsObj =null;
	int vendorDtlsObjCnt=0;
	try{
	 retQuery=(ReturnObjFromRetrieve)vendorprofile.ezGetDetails(mainParams);
	 retQuery=((ReturnObjFromRetrieve)retQuery.getObject("GetGeneralData"));
	 if(retQuery!=null)
	 {
	 QueryCnt=retQuery.getRowCount();
	}		
	}catch(Exception e){}
	     	
%>
</style>
</Head>
<!-- Content Wrapper. Contains page content -->
      <Div class="content-wrapper">
      <section class="content-header">
        <!-- Content Header (Page header) -->
  <h5>
	     <B> Vendor Corporate Enquiry</B>
	      <!--<small>Optional description</small>--> 
   </h5>
   </section>
  
<section class="content">
   <form method="post" action="" name='myForm' id='myForm'>
      <div class="row">
      <div class="col-md-12  col-xs-12 ">
      <div class="box box-primary">	
<% 	
 	String docId ="",city="",name1="",email="",mob="",state="",landline="",loc="",coments="";
   	if(QueryCnt>0)
   	{
	
	String display_header ="";	
		display_header = "Enquiry List";
%>
<%
	  String trBGColor = "Bgcolor=\"#59584C\"  style=\"color:white\"";
	  String altRowColor = "style=\"background-color:#d0d0d0\""; 
%> 
<Script>
	function setMessageVisible()
	{
		var divVal = document.getElementById("ButtonDiv");
		if(divVal == null)
		 	alert("divVal is null !!!!");
		else
		divVal.style.visibility="hidden";
		document.getElementById("EzButtonsMsg").style.visibility="visible";
	}
</Script>	

       <h5>
             <B> &nbsp;<%=display_header%> </B>
             <!--<small>Optional description</small>-->
    </h5>
      <div class="box box-primary">
      <div class="box-body table-responsive no-padding">	 	          
	<table id="" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
		<thead>
		<Tr <%=trBGColor%>>
		<Th width="10%" filter="false">Ref.No</Th>
			<Th width="8%" filter="false">Location</Th>
			<Th width="25%" filter="false">Name</Th>
			<Th width="20%" filter="false">EMail</Th>
			<Th width="10%" filter="false">Mobile</Th>			
			<Th width="10%" filter="false">Create <Br> <Br>Temp Login</Th>
		</Tr>
		</thead>		
		<tbody>
		
	<%
	
	
			for (int i=0;i<QueryCnt;i++) 
			{
			 docId = retQuery.getFieldValueString(i,"EVGD_DOC_ID");
			 city = retQuery.getFieldValueString(i,"EVGD_CITY");
			 name1 = retQuery.getFieldValueString(i,"EVGD_NAME1");
			 email = retQuery.getFieldValueString(i,"EVGD_EMAIL");
			 mob = retQuery.getFieldValueString(i,"EVGD_MOBILE");
			 state = retQuery.getFieldValueString(i,"EVGD_STATE");
			 landline = retQuery.getFieldValueString(i,"EVGD_LANDLINE");
			 loc = retQuery.getFieldValueString(i,"EVGD_ADDR_NR");
			 //out.println("docId:::::::"+docId);
			 try{
				miscParams.setQuery("SELECT * FROM ezc_document_comments WHERE edc_doc_type ='VEND_PROFILE' and EDC_DOC_ID='"+docId+"'");

				mainParams.setObject(miscParams);
				mainParams.setLocalStore("Y");
				Session.prepareParams(mainParams);
				ReturnObjFromRetrieve userCommentsRetObj = (ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);

				if(userCommentsRetObj!=null)
				{

				for(int j=0;j<userCommentsRetObj.getRowCount();j++)
				{
					 coments = checkNull(userCommentsRetObj.getFieldValueString(j,"EDC_COMMENTS"));
					//out.println("docId:::::::"+coments);

				}
				}
			}catch(Exception e){System.out.println(e);}
	%>
		<Tr>
			<Td width="8%" filter="false"><center><u><a href="javascript:onClick=funUpload('<%=coments%>','<%=docId%>','<%=city%>','<%=name1%>','<%=email%>','<%=mob%>','<%=state%>','<%=landline%>','<%=loc%>')"><%=docId%></a></u></center></Td>
			<Td width="8%" filter="false"><%=retQuery.getFieldValueString(i,"EVGD_CITY")%></Td>
			<Td width="25%" filter="false"><%=retQuery.getFieldValueString(i,"EVGD_NAME1")%></Td>
			<Td width="20%" filter="false"><%=retQuery.getFieldValueString(i,"EVGD_EMAIL")%></Td>
			<Td width="10%" filter="false"><%=retQuery.getFieldValueString(i,"EVGD_MOBILE")%></Td>			
			<!--<Td width="10%" filter="false"><button onclick="javascript:history.go(-1)">Back</button></Td>-->
			<Td width="10%" filter="false"><button onclick="funCreVen('<%=docId%>','<%=city%>','<%=name1%>','<%=email%>','<%=mob%>','<%=state%>','<%=landline%>','<%=loc%>')">Create</button></Td>
		</Tr>	
	<%
		}
	%>	
		</tbody>
	</Table>
        </div>
     </div>
     
<%
	
}else{	
%>
<div class="col-xs-12 col-xs-offset-5 col-md-12 col-md-offset-5" > 
     	<h4>No Enquires to Act</h4> 
	</div>	
<%
}

%>
  </form>
  </Body>
  </section>
</div>
<script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>
<script src="../../Library/jquery/jquery-validation-1.16.0/dist/jquery.validate.min.js"></script>
<script src="../../Library/jquery/jquery-validation-1.16.0/dist/additional-methods.min.js"></script>
  
 <script type="text/javascript">
 function funUpload(coments,docId,city,name1,email,mob,state,landline,loc)
 {
 	//alert("hi");
 	/*var city='<%=city%>';
 	var name1='<%=name1%>';
 	var email='<%=email%>';
 	var mob='<%=mob%>';
 	var state='<%=state%>';
 	var landline='<%=landline%>';
 	var loc='<%=loc%>';*/
 	var Url="../../../../../ezEnquiry.jsp?city="+city+"&coments="+coments+"&name1="+name1+"&mob="+mob+"&email="+email+"&state="+state+"&landline="+landline+"&loc="+loc+"&flag=F";
 		$.fancybox.open({
 		href : Url,
 		type : 'iframe',
 		padding : 0,
 		width:'40%',
 		height:'65%',
 		autoSize : false,
 		closeBtn : true,
 		helpers     : { 
 				overlay : {closeClick: false}
 		 }
 	});
 	
}
 function funCreVen(docId,city,name1,email,mob,state,landline,loc)
  {
  	/*var docId='<%=docId%>';
  	var loc='<%=loc%>';
  	var name1='<%=name1%>';
  	var email='<%=email%>';
 	var mob='<%=mob%>';*/
    	document.myForm.action="ezTempUserCreation.jsp?docId="+docId+"&loc="+loc+"&name1="+name1+"&email="+email+"&mob="+mob;
 	document.myForm.submit(); 	
 	
 }
 
 
 $(document).ready(function(){
	
 	$(function() { 
 	
 		  $.validator.addMethod("catv", function() {
		    return $('#category').val() != "";
			}, 'Please select category');
 		
 		$("#myForm").validate({
 			onfocusout: function (element) {
 				$(element).valid();
 			},
 			
 			errorClass: "my-error-class",
 			
 			rules: {
 				
 				
 				comment: {
					required: true,
					maxlength: 1000,
					alphanumeric: true
				},
				category: {
					catv: true					
				}
 			},
 			messages: {
 				
 				
 				comment: {
				 	required: "Please Enter comments",
				 	alphanumeric: "Please Enter only Alphanumeric Characters",
				 	maxlength: "maxlength is 1000 characters"
 				}
 			}
 		});
 	});
});
</script>

</html>
<%//@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter1.jsp"%> 
<%@ include file="../Misc/ezDataTableScript.jsp"%>
 <script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.js"></script>
<script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.pack.js"></script>