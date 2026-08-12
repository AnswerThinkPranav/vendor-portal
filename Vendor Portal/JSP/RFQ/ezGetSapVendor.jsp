<%@ page import = "ezc.ezcommon.*" %>
<%@ page import="java.text.*" %>
<%@ page import = "ezc.ezparam.*,java.math.BigDecimal" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />

<Html>
<Head>
<%@ include file="../Misc/ezPopUpIncludes.jsp"%> 
<%@ include file="../../../Includes/JSPs/Inbox/iGetUploadList.jsp"%>
<%@ include file="../Misc/ezCommonMethods.jsp"%> 
<%@ include file="../Misc/ezWFCommonMethods.jsp"%> 

</head>
<style>
table {
  border-collapse: collapse;
  background: white;
  table-layout: fixed;
  width: 100%;
}
th, td {
  padding: 5px 5px;
  border: 1px solid black;
  line-height: inherit !important;
  overflow: hidden;
  
}
</style>

<body>
<%
	
	String selRfq = request.getParameter("chkRfq");
	String selVen = request.getParameter("chkVen");
	String selQcf = request.getParameter("qcfNo");
	String sapVend ="";
	
	//out.println("selRfq>>"+selRfq);
	//out.println("selVen>>"+selVen);
	//out.println("selQcf>>"+selQcf);

	ReturnObjFromRetrieve retDoc=ezMiscSelect(Session,"SELECT ECFH_DOC_ID,ECFH_SAP_CODE FROM EZC_CUSTOMER_FORM_HEADER WHERE LPAD(TRIM(ECFH_DOC_ID),10,0)='"+selVen+"'");		
	
	if(retDoc != null)
		sapVend= retDoc.getFieldValueString(0,"ECFH_SAP_CODE");
		
	//out.println("sapVend>>"+sapVend);		
	String trBGColor = "Bgcolor=\"#325786\"  style=\"color:white\"";
	
%>
<form name="myForm1" method="post">
	<!--<div>
		<h5 class="modal-title">Enter SAP Vendor </h5>
	</div>-->
	<div class="modal-body">
		<table class="table  table-bordered dt-responsive nowrap" >	
			<Tr <%=trBGColor%>>
				<Th align=left ><B>RFQ No.</B></Th>
				<Th align=left ><B>Non SAP Vendor</B></Th>
				<Th align=left ><B>SAP Vendor</B></Th>
			</Tr>
			<Tr>
				<Td align=left ><%=selRfq%></Td>
				<Td align=left ><%=selVen%></Td>
				<Td align=left ><input type="hidden" name="sapVend" value="<%=checkNull(sapVend)%>"><%=checkNull(sapVend)%></Td>
			</Tr>	
		</table>	
	</div>
	<br>
	<div style="margin-top:2%;margin-bottom:2%">
		<button type="button" class="btn btn-danger pull-right"  style="margin:5px" onclick="window.parent.closeIframe1()"><i class="fa fa-remove"></i>&nbsp;Close</button>
		<button type="button" class="btn btn-primary pull-right" style="margin:5px" onclick="updateSapVendor('<%=selQcf%>','<%=selRfq%>','<%=selVen%>')"><i class="fa fa-update"></i>&nbsp;Update</button>
	</div>	
</form>	
<script>
function updateSapVendor(chkQcf,chkRfq,chkVen)
{

	if(document.myForm1.sapVend.value=="")
	{
		alert("Please Enter SAP Vendor Code");
		document.myForm1.sapVend.value="";
		document.myForm1.sapVend.focus();		
		return;
	}
	var sapVend = document.myForm1.sapVend.value;
	
	document.myForm1.action="ezUpdateSapVendor.jsp?qcfNo="+chkQcf+"&rfqNo="+chkRfq+"&vendor="+chkVen+"&sapVen="+sapVend;  
	document.myForm1.submit();
}
</script>
	
	
