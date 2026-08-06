<%@ page import = "ezc.ezcommon.*" %>
<%@ page import="java.text.*" %>
<%@ page import = "ezc.ezparam.*,java.math.BigDecimal" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />

<Html>
<Head>
<%@ include file="../Misc/ezPopUpIncludes.jsp"%> 
<%@ include file="../../../Includes/JSPs/Inbox/iGetUploadList.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iGetUserName.jsp" %>
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
	String userRole = (String)session.getValue("ROLE");
	ezc.ezcommon.EzLog4j.log("Role in Query>>>>>>>"+userRole,"I"); 				
	
	
	int retQryCnt=0;
	String docId = request.getParameter("docId");
	ReturnObjFromRetrieve retQry=ezMiscSelect(Session,"SELECT * from ezc_qcf_comments where eqc_code='"+docId+"' and EQC_QUERY_MAP='0' order by eqc_date limit 1");
	if(retQry != null)
		retQryCnt= retQry.getRowCount();		
		
	String trBGColor = "Bgcolor=\"#325786\"  style=\"color:white\"";
	SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
%>
	
	
<form name="myForm" method="post">
<!-- Content Wrapper. Contains page content -->
<%
	if(retQryCnt>0)
	{
%>
	<Table class="table table-bordered" id="ezRCItemTab1">
	<Tr <%=trBGColor%>>
		<Th colspan="2" align=center ><b>Query Status</b></Th>
	</Tr>
	
<%
		for(int q=0;q<retQryCnt;q++)
		{
			
%>		
		<Tr>
			<Th width="20%">Raised By</Th>
			<Td  width='20%'>
				<%=getUserName(Session,retQry.getFieldValueString(q,"EQC_USER"),"U",(String)session.getValue("SYSKEY"))%>
			</Td>
		</Tr>	
		<Tr>	
			<Th width="20%">Raised On</Th>
			<Td  width='20%'>
				<%=sdf.format((Date)retQry.getFieldValue(q,"EQC_DATE"))%>
			</Td>
		</Tr>
		<Tr>
			<Th width="60%">Raised To</Th>
			<Td  width='60%'>
			<%=getUserName(Session,retQry.getFieldValueString(q,"EQC_DEST_USER"),"U",(String)session.getValue("SYSKEY"))%>
				
			</Td>			
		</Tr>	
<%
		
		}
%>		
		
	</Table>
<%
	}
	
	//ReturnObjFromRetrieve retUploadList = getUploadList(Session,docId,"QCF"); 
	ReturnObjFromRetrieve retUploadList=ezMiscSelect(Session,"select * from EZC_UPLOAD_DOCUMENT where EUD_DOC_NO='"+docId+"' AND EUD_DOC_TYPE='QCF' AND EUD_EXT1='QRY'");
	int retUploadListCnt = 0;
	String itemId="H";
	if(retUploadList != null)
		retUploadListCnt = retUploadList.getRowCount();
	if(retUploadListCnt>0)
	{
%>
		<h5>
			<b>Attachment(s)</b>
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
					<td align="left" width="95%"><input type="hidden" name="fileItem" value="<%=retUploadList.getFieldValueString(r,"EUD_FILE_NAME")%>"><a href="javascript:downloadFile('<%=retUploadList.getFieldValueString(r,"EUD_ITEM_NO")%>','<%=retUploadList.getFieldValueString(r,"EUD_FILE_NAME")%>')"><%=retUploadList.getFieldValueString(r,"EUD_FILE_NAME")%></a></td>
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
		<!-- Your Page Content Here -->
		</div>
		</div><!--row-->	
<%
	}
%>	


<div style="margin-top:2%;margin-bottom:2%">
	<button type="button" class="btn btn-danger pull-right" style="margin:5px" onclick="window.parent.closeIframe()"><i class="fa fa-remove"></i>&nbsp;Close</button>
</div>
</div></div></div></div>
        </section><!-- /.content -->
      </div><!-- /.content-wrapper -->  
<Input type=hidden name='QcfNumber'>
<Input type=hidden name='Type'>
<Input type=hidden name='Initiator'>
<Input type=hidden name='DOCTYPE' value="QCF">
<input type="hidden" id="upDocType" name="upDocType" value="QCF">
<input type="hidden" id="upDocId" name="upDocId" value="<%=docId%>">

</form>
</Body>
</Html>
<Script>
function downloadFile(upItemNo,fileName)
{
	var upDocId 	= $('#upDocId').val();
	var upDocType 	= $('#upDocType').val();
	window.open("../Inbox/ezFileDownloadN.jsp?upDocId="+upDocId+"&upDocType="+upDocType+"&upItemNo="+upItemNo+"&fileName="+fileName);
}
function submitQuery()
{
	
	var rfqObj = document.myForm.chk1;
	var rfqLen; 
	var chooseUser = "";
	var chooseRfq = 0;
	
	
	if(document.myForm.qcfComments.value=="")
	{
		alert("Please Enter Query");
		document.myForm.qcfComments.value="";
		document.myForm.qcfComments.focus();		
		return;
	}
	else if(document.myForm.qcfComments.value.length>1000)
	{
		alert("Query Should Not Exceed 1000 Characters");
		document.myForm.qcfComments.focus();
		return;
	}
	
	if(rfqObj != null)
	{
		rfqLen = document.myForm.chk1.length;
		if(!isNaN(rfqLen))
		{
			for(i=0;i<rfqLen;i++)
			{
				if(document.myForm.chk1[i].checked)
				{
					if(chooseRfq == 0)
						chooseUser = document.myForm.chk1[i].value;
					else
						chooseUser += "¥"+document.myForm.chk1[i].value;
					chooseRfq++;
				}
			}
		}
		else
		{
			if(document.myForm.chk1.checked)
			{
				chooseUser = document.myForm.chk1.value;
				chooseRfq = 1;
			}	
			else
			{
				chooseRfq = 0;
			}
		}
		if(chooseRfq > 0)
		{
			
			document.myForm.QcfNumber.value		=	parent.document.myForm.qcfNo.value;
			//document.myForm.qcsCommentNo.value	=	parent.document.myForm.qcsCommentNo.value;
			document.myForm.Type.value		=	parent.document.myForm.commentType.value;
			document.myForm.Initiator.value		=	chooseUser;
			document.myForm.action="ezAddSaveQcfQuery.jsp";
			document.myForm.submit();
			
		}
		else
		{
			alert("Please select the user to send the query"); 
		}
	}	
	
		
}
</Script>
