<%@ page import = "ezc.ezcommon.*" %>
<%@ page import = "ezc.ezparam.*,java.math.BigDecimal" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />

<Html>
<Head>
<%@ include file="../Misc/ezPopUpIncludes.jsp"%> 
<%@ include file="../Misc/ezCommonMethods.jsp"%> 
<%@ include file="../Misc/ezWFCommonMethods.jsp"%>
<%@ include file="../../../../EzVendor/Includes/JSPs/Labels/iLang_Labels.jsp"%> 
<%@ include file="../../../../EzVendor/Includes/JSPs/Labels/iQCFsLabels.jsp"%>

</head>

<body onload="onLoadMatSch()">
<%
	String compCode = request.getParameter("compCode");
	String plant = request.getParameter("plant");
	String category = request.getParameter("category");
	String docValue = request.getParameter("docValue");
	BigDecimal docVal = new BigDecimal(docValue);
	ReturnObjFromRetrieve retObj=getWFHirearchy(Session,"QCF",plant,category,compCode);	
	int retObjCnt=0;
	if(retObj != null)
		retObjCnt=retObj.getRowCount();
%>
<form name="myForm" method="post">
<!-- Content Wrapper. Contains page content -->
      <div class="content-wrapper" style="margin-left: 0px !important;">
        <!-- Content Header (Page header) -->
        <section class="content-header">
          <h1>
            <%=appr_Hrcy_L%>
          </h1>
        </section>

        <!-- Main content -->
        <section class="content">
        <div class="row">
	<div class="col-md-12 col-xs-12">
	<div class="box box-primary">
	<div class="box-body">
	<table class="table table-bordered" id="ezRCItemTab1">
	<Tr>
		<Th><%=level_L%></Th>
		<Th><%=role_L%></Th>
		<Th><%=user_L%></Th>
		<Th><%=type_L%></Th>
		
	</Tr>
	
<%
	
	for(int i=0;i<retObjCnt;i++)
	{
		BigDecimal cmpVal=BigDecimal.valueOf((Long)retObj.getFieldValue(i,"EWPC_QCF_RELEASE"));
		String cmpOp = retObj.getFieldValueString(i,"EWPC_QCF_FLAG");
		String dispStatus = "";
		if("LE".equals(cmpOp))
		{	
			if(cmpVal.compareTo(BigDecimal.ZERO) == 0 || cmpVal.compareTo(docVal) <= 0)
			{
				dispStatus="Submit";
			}
			else
			{
				dispStatus="Approve";
			}
		}
		if("GE".equals(cmpOp))
		{	
			if(docVal.compareTo(cmpVal) >= 0)
			{
				dispStatus="Approve";
			}
			else
			{
				dispStatus="Submit";
			}
		}
%>	
		<Tr>
			<Td><%=retObj.getFieldValueString(i,"EWPC_LEVEL")%></Td>
			<Td><%=retObj.getFieldValueString(i,"EWPC_ROLE")%></Td>
			<Td><%=retObj.getFieldValueString(i,"USER_STR")%></Td>
			<Td><%=dispStatus%></Td>
		</Tr>
<%
		if("Approve".equals(dispStatus))
			break;
	}
%>	
	
</Table>
<div style="margin-top:2%;margin-bottom:2%">
	<button type="button" class="btn btn-danger pull-right" style="margin:5px" onclick="window.parent.closeIframe()"><i class="fa fa-remove"></i>&nbsp;<%=close_L%></button>
</div>
</div></div></div></div>
        </section><!-- /.content -->
      </div><!-- /.content-wrapper --> 
      		
</form>
</Body>
</Html>
