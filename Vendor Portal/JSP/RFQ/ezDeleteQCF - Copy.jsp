<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@ page import = "ezc.ezparam.*" %>
<%@ page import = "ezc.ezreverseauction.params.*" %>
<%@ page import="ezc.ezutil.*,java.util.*" %>
<%@ include file="../Misc/ezCommonMethods.jsp" %>
<%@ include file="../Misc/ezWFCommonMethods.jsp" %>
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>  
<%@ include file="../Misc/ezHeader.jsp"%>
<%
	String qcfNo	=  "1150000001";  //request.getParameter("PurchaseOrder");
	ReturnObjFromRetrieve retHeaderObj	  =	ezMiscSelect(Session,"select count(*) from ezc_rfq_header where erh_colletive_rfq_no='"+qcfNo+"'");
	ReturnObjFromRetrieve retLinesObj	  =	ezMiscSelect(Session,"select count(*) from ezc_rfq_details where erd_rfq_no in (select erh_rfq_no  from ezc_rfq_header where erh_colletive_rfq_no='"+qcfNo+"')");
	ReturnObjFromRetrieve retCondObj	  =	ezMiscSelect(Session,"select count(*) from ezc_rfq_item_conditions where eric_rfq_no in (select erh_rfq_no  from ezc_rfq_header where erh_colletive_rfq_no='"+qcfNo+"')");
	ReturnObjFromRetrieve retHistoryObj	  =	ezMiscSelect(Session,"select count(*) from ezc_rfq_quote_history where erqh_rfq_no in (select erh_rfq_no  from ezc_rfq_header where erh_colletive_rfq_no='"+qcfNo+"')");
	ReturnObjFromRetrieve retServObj	  =	ezMiscSelect(Session,"select count(*) from ezc_rfq_services where ers_srv_rfq in (select erh_rfq_no  from ezc_rfq_header where erh_colletive_rfq_no='"+qcfNo+"')");
	ReturnObjFromRetrieve retPrsObj	  	  =	null;
	ReturnObjFromRetrieve retComments	  =	null;
	ReturnObjFromRetrieve retDocs	     	  =	null;
	ReturnObjFromRetrieve retWF	  	  =	null;
	ReturnObjFromRetrieve retAudit	  	  =	null;
	
	
	select * from EZC_UPLOAD_DOCUMENT where eud_doc_no in (select erh_rfq_no  from ezc_rfq_header where ERH_colletive_rfq_no='1150000001')	
	
	select * from ezc_document_comments where edc_doc_id in (select erh_rfq_no  from ezc_rfq_header where ERH_colletive_rfq_no='1150000001')
	
	select * from ezc_rfq_prs where erp_qcf_no in('1150000001')
	
	select * from ezc_rfq_services where ers_srv_rfq in (select erh_rfq_no  from ezc_rfq_header where ERH_colletive_rfq_no='1150000001')
	
	select * from ezc_rfq_quote_history where erqh_rfq_no in (select erh_rfq_no  from ezc_rfq_header where ERH_colletive_rfq_no='1150000001')
	
	select * from ezc_rfq_item_conditions where eric_rfq_no in (select erh_rfq_no  from ezc_rfq_header where ERH_colletive_rfq_no='1150000001')
	
	select * from ezc_rfq_details where erd_rfq_no in (select erh_rfq_no  from ezc_rfq_header where ERH_colletive_rfq_no='1150000001')
	
	select *  from ezc_rfq_header where ERH_colletive_rfq_no='1150000001'
	
	
	
	
%>	