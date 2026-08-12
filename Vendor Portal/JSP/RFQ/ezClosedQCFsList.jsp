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
	//inputParams.setStatus("C");
	inputParams.setStatus("R");
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
function funClick(docId) 
{

var Url="ezViewQuotationComparisionFormPopUp.jsp?docId="+docId;
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
		});
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
		display_header = "RFQ > Closed QCF(s)";
%>
	 <%@ include file="../Misc/ezSubHeader.jsp"%> 
<%
	if(qcfListRetCnt>0)
	{
%>
		<table id="example" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
		<thead>
			<tr <%=trBGColor%>>
				<th align="center">QCF Number</th>
				<th align="center">Total RFQ(s)</th>
				<th align="center">Quoted</th>
				<th align="center">Not Quoted</th>
			</tr>
		</thead>
		<tbody>
<%
		String color = "";
		for(int i=0;i<qcfListRetCnt;i++)
		{
			color = "";
			if(i%2==0) {color = altRowColor;} 

				String qcfNumber	=  checkNull(qcfListRet.getFieldValueString(i,"ERH_COLLETIVE_RFQ_NO"));
				String totRFQs 		=  checkNull(qcfListRet.getFieldValueString(i,"TOT_RFQ"));
				String totQuoted	=  checkNull(qcfListRet.getFieldValueString(i,"TOT_QUOTED"));
				String totNotQuoted 	=  checkNull(qcfListRet.getFieldValueString(i,"TOT_NOT_QUOTED"));
				
				try{
				totQuoted=((Integer.parseInt(totRFQs))-(Integer.parseInt(totNotQuoted)))+"";
				}catch(Exception e){}
%>				
				<tr >
					<td align="center" <%=color%>><a style='text-decoration:underline' href="javaScript:funClick('<%=qcfNumber%>')"><%=qcfNumber%></a>&nbsp;</td>
					<td align="center" <%=color%>><%=totRFQs%></td>
					<td align="center" <%=color%>><%=totQuoted%></td>
					<td align="center" <%=color%>><%=totNotQuoted%></td>
				</tr>
<%
		}
%>
			 
		</tbody>
		</table>
		</div>
<%
		}else{
%>
			<div class="box-body" style="display: block;">
			<div class="col-md-12" >
				<div class="form-group">
				<label>No QCFs To List. </label> 
				</div>
			</div>	
			</div>
<%
		}
%>
		</div>
		</div>
		</div>
		</section><!-- /.content -->

		</div><!-- /.content-wrapper -->	
		</form>
		</body>
		</html>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%>
<%@ include file="../Misc/ezDataTableScript.jsp"%>
          
       <link rel="stylesheet" href="../Misc/library/fancybox2/jquery.fancybox.css" type="text/css" media="screen" />
        <script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.js"></script>
       <script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.pack.js"></script>
