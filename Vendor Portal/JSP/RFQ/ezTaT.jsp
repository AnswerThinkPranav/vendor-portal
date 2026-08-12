<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%> 
<%@ include file="../Misc/ezCommonMethods.jsp"%> 
<%@ include file="../Misc/ezWFCommonMethods.jsp"%> 
<%@ include file="../Misc/ezHeader.jsp"%> 
<%@ page import ="ezc.ezparam.*"%>           
<%@ page import ="ezc.ezbasicutil.*" %>
<%@ page import="ezc.ezutil.*,java.util.*,java.math.BigDecimal,java.math.RoundingMode" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<Html>
<body>
<form name="myForm">
	<table>
	<tr>
	<th>QCF No</th>
	<th>Approval Time</th>
	</tr>
<%	
	ReturnObjFromRetrieve retQry=ezMiscSelect(Session,"select distinct ERP_PR_NO,ERH_PLANT,EWDHH_DOC_ID,ERH_FINAL_VALUE,EWDHH_CREATED_BY,(select z.eu_first_name from ezc_users z where z.eu_id=EWDHH_CREATED_BY) AS INITIATOR,ewdhh_created_on,EWAT_DATE,EWAT_SOURCE_PARTICIPANT,d.EU_FIRST_NAME,EWW_DESCRIPTION from ezc_rfq_prs A,ezc_wf_doc_history_header B,ezc_wf_audit_trail c,ezc_users d,ezc_wf_workgroup_users e,ezc_wf_workgroups f,ezc_rfq_header g where B.ewdhh_auth_key='QCF' and B.ewdhh_wf_status='APPROVED' and B.EWDHH_DOC_ID=A.ERP_QCF_NO and b.EWDHH_DOC_ID=c.EWAT_DOC_ID and c.EWAT_SOURCE_PARTICIPANT=d.eu_id and d.eu_id=e.EWWU_USER and e.EWWU_GROUP=f.EWW_GROUP and g.erh_colletive_rfq_no=b.EWDHH_DOC_ID and erp_pr_no  in ('0011258141') order by EWAT_DOC_ID,EWAT_DATE");
	int retQryCnt=0;
	if(retQry != null)
		retQryCnt= retQry.getRowCount();
		//out.println("retQryCnt>>>"+retQryCnt);
	Vector qcfVect = new Vector();	
	
		
	if(retQryCnt>0)
	{
%>
	<table>
	<tr>
	<th>QCF No</th>
	<th>Approval Time</th>
	</tr>
<%
		for(int i=0;i<retQryCnt;i++)
		{
			String qcfNo = retQry.getFieldValueString(i,"EWDHH_DOC_ID");
			out.println("qcfNo>>>"+qcfNo);
			String dispAprTime= "0"; 
			if(qcfVect.contains(qcfNo))
			{
				Date d1= (Date)retQry.getFieldValue(i-1,"EWAT_DATE"); 
				out.println("D1>>>"+d1);
				Date d2= (Date)retQry.getFieldValue(i,"EWAT_DATE"); 
				out.println("D2>>>"+d2);
				long apprTime = d2.getTime()-d1.getTime();
				out.println("apprTime>>>"+apprTime);
				//long apprDays = (apprTime/(1000*60*60*24))%365;
				//out.println("apprDays>>>"+apprDays);
				//long apprHrs = (apprTime/(1000*60*60))%24;
				//out.println("apprHrs>>>"+apprHrs);
				long apprMin = (apprTime/(1000*60))%60;
				out.println("apprMin>>>"+apprMin);
				dispAprTime = apprMin+"";
			}
			else
			{
				qcfVect.add(qcfNo);
				Date d2= (Date)retQry.getFieldValue(i,"EWAT_DATE"); 
			}
%>			
			<tr>
			<td><%=qcfNo%></td>
			<td><%=dispAprTime%></td>
			</tr>
<%

		}
%>
		</table>
<%
	}		
		
%>
</form>
<%//@ include file="../Misc/ezSubFooter.jsp"%>
<%//@ include file="../Misc/ezFooter.jsp"%>
<Div id="MenuSol"></Div>
</body>
</html>