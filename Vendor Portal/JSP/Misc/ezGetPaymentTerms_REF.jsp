<%@ page import ="ezc.ezparam.*,java.util.*,ezc.ezutil.*,ezc.ezvendorapp.params.*,ezc.ezpurchase.params.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@ include file="../Misc/ezCommonMethods.jsp"%>
<%
	String cnKey=request.getParameter("cnKey");
	String selVal = request.getParameter("selVal");
	
	ezc.ezcommon.EzLog4j.log("****==cnKey111=====**"+cnKey,"I");

	ReturnObjFromRetrieve retPaymentReg=null;
	if("IN".equals(cnKey))
	{
		 retPaymentReg=ezMiscSelect(Session,"select * from ezc_vend_details_mapping where EVDM_DETAIL_TYPE='PAYMENT_TERMS' and EVDM_COUNTRY='"+cnKey+"' ");
	}
	else
	{
		retPaymentReg=ezMiscSelect(Session,"select * from ezc_vend_details_mapping where EVDM_DETAIL_TYPE='PAYMENT_TERMS' and EVDM_COUNTRY='' ");
	}
	int retPaymentRegCnt=0;
	if(retPaymentReg != null)
		retPaymentRegCnt= retPaymentReg.getRowCount();
%>	
		<select name="paymntTerms" id="paymntTerms" value="" class="form-control select2 validate[required]" style="width:200px;margin-left: 3%;">
				<option value="">--Select Payment Terms--</option>
<%		
			for(int i=0;i<retPaymentRegCnt;i++)
			{	
			ezc.ezcommon.EzLog4j.log("****==retPaymentRegCnt=====**"+retPaymentRegCnt,"I");
			ezc.ezcommon.EzLog4j.log("****==retPaymentRegCnt=====**"+retPaymentReg.getFieldValueString(i,"EVDM_TERM_VALUE"),"I");
%>
					<option <%=selVal.equals(retPaymentReg.getFieldValueString(i,"EVDM_TERM_VALUE"))?"selected":""%> value='<%=retPaymentReg.getFieldValueString(i,"EVDM_TERM_VALUE")%>' ><%=retPaymentReg.getFieldValueString(i,"EVDM_DESC")%></option>
<%

			}
%>
		</select>