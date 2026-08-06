<%@ page import ="ezc.ezparam.*,java.util.*,ezc.ezutil.*,ezc.ezvendorapp.params.*,ezc.ezpurchase.params.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@ include file="../Misc/ezCommonMethods.jsp"%>
<%
	
	String fieldVal=request.getParameter("fieldVal");
	String selVal = request.getParameter("selVal");
	
	
	

	ReturnObjFromRetrieve retPaymentReg=null;
	if("0".equals(fieldVal))
	{
		 retPaymentReg=ezMiscSelect(Session,"SELECT * FROM ezc_master_key_values WHERE EMKV_MASTER_TYPE = 'PMNT_TERM' and EMKV_VALUE1 is NULL");
		 ezc.ezcommon.EzLog4j.log("****==fieldVal0000(NON-MSME)=====**"+retPaymentReg.toEzcString(),"I");
	}
	else
	{
		retPaymentReg=ezMiscSelect(Session,"select * from ezc_master_key_values where EMKV_MASTER_TYPE='PMNT_TERM' and EMKV_VALUE1='M'");
		ezc.ezcommon.EzLog4j.log("****==fieldVal111(MSME)=====**"+retPaymentReg.toEzcString(),"I");
	}
	int retPaymentRegCnt=0;
	if(retPaymentReg != null)
		retPaymentRegCnt= retPaymentReg.getRowCount();
		
			for(int j=0;j<retPaymentRegCnt;j++)
			{	
			
				String chksel1="";
				String Payment_Terms1="";
				String payTm1=retPaymentReg.getFieldValueString(j,"EMKV_KEY").trim();
				ezc.ezcommon.EzLog4j.log("****==PMNT_TERMS=====**"+payTm1,"I");
				//if(payTm1.equals(Payment_Terms1))chksel1="selected";
%>				
				<option value="<%=retPaymentReg.getFieldValueString(j,"EMKV_KEY").trim()%>" <%=chksel1%>><%=payTm1%>--><%=retPaymentReg.getFieldValueString(j,"EMKV_VALUE")%></option>
<%

			}
%>
		
		
		