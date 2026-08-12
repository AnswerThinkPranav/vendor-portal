<%@ page import = "ezc.ezcommon.*" %>
<%@ page import = "ezc.ezparam.*,java.math.BigDecimal" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ include file="../../../../EzVendor/Includes/JSPs/Labels/iQCFsLabels.jsp"%>

<Html>
<Head>
<%@ include file="../Misc/ezPopUpIncludes.jsp"%> 
<%@ include file="../Misc/ezCommonMethods.jsp"%> 
<%@ include file="../Misc/ezWFCommonMethods.jsp"%> 

</head>

<body>
<%
	String qcfNo = request.getParameter("qcfNo");

	ReturnObjFromRetrieve retObj=ezMiscSelect(Session,"SELECT A.*,B.ERH_SOLD_TO FROM EZC_RFQ_POS A,EZC_RFQ_HEADER B WHERE A.ERP_RFQ_NO=B.ERH_RFQ_NO AND B.ERH_COLLETIVE_RFQ_NO='"+qcfNo+"'");	
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
            <%=purOrdList_L%> <strong><%=qcfNo%></strong>
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
		<Th><%=vend_L%></Th>
		<Th><%=PO_num_L%></Th>
		<Th><%=PO_item_L%></Th>
		<Th><%=RFQ_No_L%></Th>
		<Th><%=RFQ_item_L%></Th>
		<Th><%=PR_No_L%></Th>
		<Th><%=PR_item_L%></Th>
		<Th><%=Qty_L%></Th>
		
	</Tr>
	
<%
	
	for(int i=0;i<retObjCnt;i++)
	{
%>	
		<Tr>
			<Td><%=retObj.getFieldValueString(i,"ERH_SOLD_TO")%></Td>
			<Td><%=retObj.getFieldValueString(i,"ERP_PO_NO")%></Td>
			<Td><%=retObj.getFieldValueString(i,"ERP_PO_ITEM")%></Td>
			<Td><%=retObj.getFieldValueString(i,"ERP_RFQ_NO")%></Td>
			<Td><%=retObj.getFieldValueString(i,"ERP_RFQ_LINE_NO")%></Td>
			<Td><%=retObj.getFieldValueString(i,"ERP_PR_NO")%></Td>
			<Td><%=retObj.getFieldValueString(i,"ERP_PR_ITEM")%></Td>
			<Td><%=retObj.getFieldValueString(i,"ERP_QUANTITY")%></Td>
		</Tr>
<%
	}
%>	
	
</Table>
<div style="margin-top:2%;margin-bottom:2%">
	<button type="button" class="btn btn-danger pull-right" style="margin:5px" onclick="window.parent.closeIframe()"><i class="fa fa-remove"></i>&nbsp;Close</button>
</div>
</div></div></div></div>
        </section><!-- /.content -->
      </div><!-- /.content-wrapper --> 
      		
</form>
</Body>
</Html>
