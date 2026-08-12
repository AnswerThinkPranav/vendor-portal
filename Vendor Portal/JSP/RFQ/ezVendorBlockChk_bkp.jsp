<%@ page import="ezc.ezparam.*" %>
<%@ include file="../../../Includes/JSPs/Misc/iReadRFCTable.jsp"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ page import = "java.io.*"%>
<%
	boolean successFlg = false;
	String vendChk = request.getParameter("vendChk"); //"0000100199";
	//vendChk = "0000100199";
	ezc.ezcommon.EzLog4j.log("vendChk>>>"+vendChk,"I");
	String plantChk = request.getParameter("plant"); //"0000100199";
	ezc.ezcommon.EzLog4j.log("plant>>>"+plant,"I");
	String poBlk="";

	//Vendor Block Check
	String logonSite = (String)session.getValue("SITE");
	String [] outputFeilds = null;
	String [] queryValues = null;

	queryValues =new String[]{"LIFNR EQ '"+vendChk+"'"}; 
	outputFeilds =new String[]{"SPERQ"};

	ReturnObjFromRetrieve retBlk = readRFCTable(logonSite,"LFA1",outputFeilds,queryValues);
	if(retBlk!=null)
		poBlk = retBlk.getFieldValueString(0,"SPERQ");
	ezc.ezcommon.EzLog4j.log("::poBlk at LFA1:::"+poBlk,"I");
	
	if("01".equals(poBlk)|| "02".equals(poBlk)|| "03".equals(poBlk)|| "04".equals(poBlk)|| "99".equals(poBlk)|| "Z9".equals(poBlk))
	{
		successFlg = true;
		
	}
	/*
	if(!successFlg)
	{
	
		String pOrg = "3001";
		int retOrgBlkCnt=0;
		String [] queryValues1 =new String[]{"LIFNR EQ '"+vendChk+"' AND EKORG EQ '"+pOrg+"'"}; 
		String [] outputFeilds1 =new String[]{"SPERM"};
		ReturnObjFromRetrieve retOrgBlk = readRFCTable(logonSite,"LFM1",outputFeilds1,queryValues1);
	
		if(retOrgBlk!=null)
			retOrgBlkCnt=rfqObj.getRowCount();
		
		if(retOrgBlkCnt>0)
			poBlk = retOrgBlk.getFieldValueString(0,"SPERM");
		ezc.ezcommon.EzLog4j.log("::poBlk at LFM1 New:::"+poBlk,"I");
	}*/	
	
		out.print(poBlk);
%>
