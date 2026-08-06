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
<%@ include file="../../../../EzVendor/Includes/JSPs/Labels/iLang_Labels.jsp"%>  
<%@ include file="../../../../EzVendor/Includes/JSPs/Labels/iTempVend_Labels.jsp"%>

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
	String compCode = request.getParameter("compCode");
	String plant = request.getParameter("plant");
	String category = request.getParameter("category");
	String docValue = request.getParameter("docValue");
	BigDecimal docVal = new BigDecimal(docValue);
	String wfStatus = request.getParameter("wfStatus");
	
	int retObjCnt=0;
	int retAudCnt=0;
	int retQryCnt=0;
	java.util.Hashtable auditHash = new java.util.Hashtable();
		
	String docId = request.getParameter("docId");
	String docType = request.getParameter("docType");
	
	ReturnObjFromRetrieve retDoc=ezMiscSelect(Session,"select EWDHH_CREATED_BY,EU_FIRST_NAME from ezc_wf_doc_history_header,ezc_users where EWDHH_DOC_ID='"+docId+"' and EWDHH_CREATED_BY=EU_ID ");		
	String qcfBuyer ="";
	if(retDoc != null)
		qcfBuyer= retDoc.getFieldValueString(0,"EWDHH_CREATED_BY")+"["+ retDoc.getFieldValueString(0,"EU_FIRST_NAME")+"]";
		
	//ReturnObjFromRetrieve retObj=ezMiscSelect(Session,"SELECT *,(SELECT GROUP_CONCAT(CONCAT(B.EU_ID)) FROM EZC_WF_WORKGROUP_USERS A,EZC_USERS B WHERE A.EWWU_USER=B.EU_ID  AND A.EWWU_GROUP =EWPC_GROUP AND  A.EWWU_USER IN (SELECT EUDKV_USER_ID FROM EZC_USER_DEF_KEY_VALUES WHERE EUDKV_KEY='CATEGORY' AND EUDKV_VALUE='"+plant+"#"+category+"') GROUP BY A.EWWU_GROUP) AS USER_STR FROM EZC_WF_PRICING_CONDITIONS WHERE EWPC_TEMPLATE IN (SELECT EWKM_TEMPLATE FROM EZC_WF_KEY_MAP WHERE EWKM_COMP_CODE='"+compCode+"' AND EWKM_PLANT='"+plant+"' AND EWKM_CATEGORY='"+category+"' AND EWKM_DOC_TYPE='"+docType+"') ORDER BY EWPC_LEVEL");
	ReturnObjFromRetrieve retObj=ezMiscSelect(Session,"SELECT *,(SELECT GROUP_CONCAT(CONCAT(B.EU_ID)) FROM EZC_WF_WORKGROUP_USERS A,EZC_USERS B WHERE A.EWWU_USER=B.EU_ID  AND A.EWWU_GROUP =EWPC_GROUP AND TRIM(A.EWWU_USER) IN (SELECT EUDKV_USER_ID FROM EZC_USER_DEF_KEY_VALUES WHERE EUDKV_KEY='PLANT' AND EUDKV_VALUE='"+plant+"')AND A.EWWU_USER IN (SELECT EUDKV_USER_ID FROM EZC_USER_DEF_KEY_VALUES WHERE EUDKV_KEY='CATEGORY' AND EUDKV_VALUE='"+plant+"#"+category+"') GROUP BY A.EWWU_GROUP) AS USER_STR FROM EZC_WF_PRICING_CONDITIONS WHERE EWPC_TEMPLATE IN (SELECT EWKM_TEMPLATE FROM EZC_WF_KEY_MAP WHERE EWKM_COMP_CODE='"+compCode+"' AND EWKM_PLANT='"+plant+"' AND EWKM_CATEGORY='"+category+"' AND EWKM_DOC_TYPE='"+docType+"') ORDER BY EWPC_LEVEL");
	
	if(retObj != null)
		retObjCnt= retObj.getRowCount();
		
	ReturnObjFromRetrieve retQry=ezMiscSelect(Session,"SELECT * from ezc_qcf_comments,ezc_users where eqc_code='"+docId+"' and EQC_USER=EU_ID order by eqc_date");		
	
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
		<Th colspan="3" align=center >Query</Th>
	</Tr>
	<Tr>
		<Th width="20%">User</Th>
		<Th width="20%">Date</Th>
		<Th width="60%">COmments</Th>
	</Tr>	
<%
		for(int q=0;q<retQryCnt;q++)
		{
			
%>		
		<Tr>
			<Td  width='20%'>
				<%=retQry.getFieldValueString(q,"EU_FIRST_NAME")%>
			</Td>		
			<Td  width='20%'>
				<%=sdf.format((Date)retQry.getFieldValue(q,"EQC_DATE"))%>
			</Td>
			<Td  width='60%'>
				<%=retQry.getFieldValueString(q,"EQC_COMMENTS")%>
			</Td>			
		</Tr>	
<%
		
		}
%>		
		
	</Table>
<%
	}
	else
	{
%>
		<Table class="table table-bordered">
			<Tr <%=trBGColor%>>
				<Th colspan="3" align=center ><b>No Query Data Found</b></Th>
			</Tr>
		</Table>	
<%	
	}
	
	
	//ReturnObjFromRetrieve retUploadList = getUploadList(Session,docId,"QCF"); 
	ReturnObjFromRetrieve retUploadList=ezMiscSelect(Session,"select * from EZC_UPLOAD_DOCUMENT where EUD_DOC_NO='"+docId+"' AND EUD_DOC_TYPE='"+docType+"' AND EUD_EXT1='QRY'");
	int retUploadListCnt = 0;
	String itemId="H";
	if(retUploadList != null)
		retUploadListCnt = retUploadList.getRowCount();
	if(retUploadListCnt>0)
	{
%>
		<h5>
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

<%
	if(!"APPROVED".equals(wfStatus))
	{
%>	
		<Table class="table table-bordered" id="ezRCItemTab1">
		<Tr <%=trBGColor%>>
			<Th align=left ><b>Enter your Query here</b></Th>
		</Tr>
		<Tr>	
			<Td class='blankcell' width='100%'>
				<textarea name = 'qcfComments' style='width:100%' rows=3 cols=73 ></textarea>
			</Td>
		</Tr> 
		</Table>	


	      <div class="content-wrapper" style="margin-left: 0px !important;">
		<!-- Content Header (Page header) -->
		<section class="content-header">

		  <h1>
		    Approval Hirearchy
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
			<Th width="10%">&nbsp;</Th>
			<Th>Level</Th>
			<Th>Role</Th>
			<Th>User</Th>


		</Tr>

<%


		for(int i=0;i<retObjCnt;i++)
		{
			String chkRole = retObj.getFieldValueString(i,"EWPC_ROLE");

			if(userRole.equals(chkRole))
				break;

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

			String chkStr = retObj.getFieldValueString(i,"USER_STR");
			chkStr	= chkStr.replaceAll(",","','");
			String tempUser = "";
			String tempName = "";

			ReturnObjFromRetrieve retAudit=ezMiscSelect(Session,"SELECT DISTINCT(EWAT_SOURCE_PARTICIPANT),EU_FIRST_NAME FROM ezc_wf_audit_trail,ezc_users where EWAT_DOC_ID='"+docId+"' and EWAT_TYPE='"+docType+"' and EWAT_SOURCE_PARTICIPANT= EU_ID and EWAT_SOURCE_PARTICIPANT IN('"+chkStr+"') ORDER BY EWAT_DATE DESC LIMIT 1");		

			if(retAudit != null)
			{
				tempUser= retAudit.getFieldValueString(0,"EWAT_SOURCE_PARTICIPANT");
				tempName= tempUser+"["+retAudit.getFieldValueString(0,"EU_FIRST_NAME")+"]";

			}


%>	
			<Tr>
				<Td width=10% align=center>


				<input type=checkbox name=chk1 value='<%=tempUser%>'>
				</Td>
				<Td><%=retObj.getFieldValueString(i,"EWPC_LEVEL")%></Td>
				<Td><%=retObj.getFieldValueString(i,"EWPC_ROLE")%></Td>

				<Td><%=tempName%></Td>
			</Tr>
<%
			if("Approve".equals(dispStatus))
				break;
		}
	}
	
%>	
	
</Table>
<div style="margin-top:2%;margin-bottom:2%">
<%
	if(!"APPROVED".equals(wfStatus))
	{
%>	
	<button type="button" class="btn btn-primary pull-right" style="margin:5px" onclick="submitQuery()"><i class="fa fa-save"></i>&nbsp;Send</button>
<%
	}
%>	
	<button type="button" class="btn btn-danger pull-right" style="margin:5px" onclick="window.parent.closeIframe()"><i class="fa fa-remove"></i>&nbsp;Close</button>
</div>
</div></div></div></div>
        </section><!-- /.content -->
      </div><!-- /.content-wrapper -->  
<Input type=hidden name='QcfNumber'>
<Input type=hidden name='Type'>
<Input type=hidden name='Initiator'>
<Input type=hidden name='DOCTYPE' value='<%=docType%>'>
<input type="hidden" id="upDocType" name="upDocType" value="<%=docType%>">
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
