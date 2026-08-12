<%@ page import="ezc.ezparam.*" %>
<%@ include file="../../../Includes/JSPs/Misc/iReadRFCTable.jsp"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ page import = "java.io.*"%>
<%
	String vendChk = request.getParameter("vendChk"); //"0000100199";
	//vendChk = "0000100199";
	ezc.ezcommon.EzLog4j.log("vendChk>>>"+vendChk,"I");
	String poBlk="";

	//Vendor Block Check
	String logonSite = (String)session.getValue("SITE");
	String [] outputFeilds = null;
	String [] queryValues = null;

	queryValues =new String[]{"LIFNR EQ '"+vendChk+"'"}; 
	outputFeilds =new String[]{"SPERQ"};

	ReturnObjFromRetrieve retBlk = readRFCTable(logonSite,"LFA1",outputFeilds,queryValues);
	poBlk = retBlk.getFieldValueString(0,"SPERQ");
	ezc.ezcommon.EzLog4j.log("::poBlk:::"+poBlk,"I");
	
	/*if("01".equals(poBlk)|| "02".equals(poBlk)|| "03".equals(poBlk)|| "04".equals(poBlk)|| "99".equals(poBlk)|| "Z9".equals(poBlk))
	{
		successFlg = true;
		
	}*/	
	
	out.print(poBlk);
%>
