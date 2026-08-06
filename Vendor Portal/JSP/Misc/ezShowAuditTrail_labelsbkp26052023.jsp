<%@ page import = "ezc.ezcommon.*,java.text.SimpleDateFormat" %>
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
	String docId = request.getParameter("docId");
	String docType = request.getParameter("docType");
	ReturnObjFromRetrieve retObj=ezMiscSelect(Session,"SELECT * FROM ezc_wf_audit_trail where EWAT_DOC_ID='"+docId+"' and EWAT_TYPE='"+docType+"'");
	
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
            <%=audit_Trail_L%>- <%=docId%>
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
		<Th><%=audit_L%></Th>
		<Th><%=action_L%></Th>
		<Th><%=date_L%></Th>		
	</Tr>
	
<%
	SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy hh:mm aaa");
	for(int i=0;i<retObjCnt;i++)
	{
%>	
		<Tr>
			<Td><%=retObj.getFieldValueString(i,"EWAT_AUDIT_NO")%></Td>
			<Td><%=retObj.getFieldValueString(i,"EWAT_COMMENTS")%></Td>
			<td><%=sdf.format((Date)retObj.getFieldValue(i,"EWAT_DATE"))%></td>
		</Tr>
<%
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
