<%@ page import ="ezc.ezparam.*,java.util.*,ezc.ezutil.*,ezc.ezvendorapp.params.*,ezc.ezpurchase.params.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@ include file="../Misc/ezCommonMethods.jsp"%>
<%
	String cnKey=request.getParameter("cnKey");
	String selState=request.getParameter("selVal");
	ezc.ezcommon.EzLog4j.log("****==cnKey55=====**"+cnKey,"I");
	ezc.ezcommon.EzLog4j.log("****==selState55=====**"+selState,"I");
	
	ReturnObjFromRetrieve retReg=ezMiscSelect(Session,"select distinct EMKV_VALUE1,EMKV_VALUE from ezc_master_key_values where EMKV_MASTER_TYPE='V_COUNTRY' and EMKV_KEY='"+cnKey+"'");
	int retRegCnt=0;
	if(retReg != null)
		retRegCnt= retReg.getRowCount();
%>	
		<select name="state" id="state" value="" class="form-control select2 validate[required]" style="width:200px;margin-left: 3%;">
				<option value="">--Select Region--</option>
<%		
			for(int i=0;i<retRegCnt;i++)
			{
%>
					<option value='<%=retReg.getFieldValueString("EMKV_VALUE1")%>'><%=retReg.getFieldValueString(i,"EMKV_VALUE1")%>--><%=retReg.getFieldValueString(i,"EMKV_VALUE")%></option>
<%

			}
%>
		</select>