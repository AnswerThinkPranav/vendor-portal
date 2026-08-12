<%@ include file="../../Library/Globals/errorPagePath.jsp"%>  
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/Lib/DateFunctions.jsp"%>
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%> 
<%@ include file="../Misc/ezCommonMethods.jsp"%> 
<%@ include file="../Misc/ezHeader.jsp"%> 
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<%@ page import="ezc.vendortransactions.params.*,ezc.ezparam.*,java.util.*,java.text.*" %> 
<%@ page import = "ezc.ezutil.FormatDate"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean> 
<jsp:useBean id="rfqManager" class="ezc.ezpreprocurement.client.EzPreProcurementManager" />
<%@ page import ="ezc.ezpreprocurement.params.*,ezc.ezparam.*,java.util.*" %>

<%	
	EzcParams 		ezparams	= new EzcParams(true);
	
	int qcfListRetCnt = 0;
	ReturnObjFromRetrieve    qcfListRet 	= null;
	EziRFQHeaderParams  	inputParams 	= new EziRFQHeaderParams();

	inputParams.setSysKey(userSyskeysStr);
	inputParams.setStatus("Y','N','R");
	inputParams.setExt1("CR");

	ezparams.setLocalStore("Y");
	ezparams.setObject(inputParams);
	Session.prepareParams(ezparams);
	
	try{
		qcfListRet = (ReturnObjFromRetrieve)rfqManager.ezGetRFQList(ezparams);
		
	}
	catch(Exception e){
		ezc.ezcommon.EzLog4j.log("Error while getting QCF List :::::::::"+e,"E");
	}

	if(qcfListRet!=null)
		qcfListRetCnt    = qcfListRet.getRowCount();
%>
<html>
 <head>
 <link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.bootstrap.min.css">
 <link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.responsive.min.css">
 <link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.tableTools.css">


</head>
<script type="text/javascript">
function funQuotedNotQuoted(docId,status)
{
var Url="ezQuotedNotQuotedDtls.jsp?docId="+docId+"&status="+status;
$.fancybox.open({
				href : Url,
				type : 'iframe',
				padding : 5,
				width:'60%',
				height:'350px',
				autoSize : false,
				closeBtn : true,
				helpers     : {  
						overlay : {closeClick: false}
				 }
		});
}
function funEDIT(qcfQote)
{
	var Url="ezRFQSendMail.jsp?";
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
	
}
function funSubmit()
{
 window.location = "ezToActQCFsList.jsp"
/*var docId = document.myForm.qcfQote.value;
var Url="ezQuotationComparisionFormPopUp.jsp?docId="+docId;
				$.fancybox.open({
				href : Url,
				type : 'iframe',
				padding : 5,
				width:'100%',
				height:'720px',
				autoSize : false,
				closeBtn : true,
				helpers     : {  
						overlay : {closeClick: false}
				 }
		});*/
}
function funGo()
{
document.myForm.submit();
}
</script>
<body>

<form name="myForm" method="post"  > 

<%	
	String display_header ="";	
		display_header = "RFQ > QCF(s)";
%>
	 <%@ include file="../Misc/ezSubHeader.jsp"%> 
	 <br>
	 <Div id="ButtonDiv" align="center">
		<button type="button" class="btn btn-primary" onclick="funEDIT()">OTP To View Docs</button>
		<button type="button" class="btn btn-primary" onclick="funSubmit()">QCF</button>
	</div>
	</div>
	</div>
	</section><!-- /.content -->

	</div><!-- /.content-wrapper -->
	<input type="hidden" name="qcfQote" value="">
	</form>
	</body>
	</html>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%>
<%@ include file="../Misc/ezDataTableScript.jsp"%>
          
       <link rel="stylesheet" href="../Misc/library/fancybox2/jquery.fancybox.css" type="text/css" media="screen" />
        <script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.js"></script>
       <script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.pack.js"></script>
