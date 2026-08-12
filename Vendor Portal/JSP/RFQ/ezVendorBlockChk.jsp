<%@ page import="ezc.ezparam.*" %>
<%@ include file="../../../Includes/JSPs/Misc/iReadRFCTable.jsp"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ page import = "java.io.*"%>
<%
	String vendChk = request.getParameter("vendChk"); //"0000100199";
	//vendChk = "0000100199";  //LFA1
	//vendChk = "0000100553";  //LFM1
	ezc.ezcommon.EzLog4j.log("vendChk>>>"+vendChk,"I");
	String plantChk = request.getParameter("plant");
	//plantChk = "2001";
	ezc.ezcommon.EzLog4j.log("plantChk>>>"+plantChk,"I");
	String pOrg = "";
	String vendBlk="";
	String poBlk="";
	String blkFlag="";
	
	String logonSite = (String)session.getValue("SITE");
	String [] outputFeilds = null;
	String [] queryValues = null;
	ReturnObjFromRetrieve retBlk = null;
	int retBlkCnt=0;
	
	//Vendor Block Check
	
	queryValues =new String[]{"LIFNR EQ '"+vendChk+"'"}; 
	outputFeilds =new String[]{"SPERQ"};
	
	retBlk = readRFCTable(logonSite,"LFA1",outputFeilds,queryValues);
	ezc.ezcommon.EzLog4j.log("::retBlk in LFA1:::"+retBlk.toEzcString(),"I");
	
	if(retBlk!=null)
	    retBlkCnt=retBlk.getRowCount();
	    
	if(retBlkCnt>0)
		poBlk = retBlk.getFieldValueString(0,"SPERQ");	 
	ezc.ezcommon.EzLog4j.log("::poBlk at LFA1:::"+poBlk,"I");
	
	if("01".equals(poBlk)|| "02".equals(poBlk)|| "03".equals(poBlk)|| "04".equals(poBlk)|| "99".equals(poBlk)|| "Z9".equals(poBlk))
	{
		vendBlk= "X";
	}
	
	if((!"".equals(vendBlk) && vendBlk!=null && !"null".equals(vendBlk)))
	{
		//TO Fetch Purchase Org based on selected Plant
		queryValues =new String[]{"WERKS EQ '"+plantChk+"'"}; 
		outputFeilds =new String[]{"EKORG"};

		ReturnObjFromRetrieve retPOrg = readRFCTable(logonSite,"T024W",outputFeilds,queryValues);
		pOrg = retPOrg.getFieldValueString(0,"EKORG");
		ezc.ezcommon.EzLog4j.log("::pOrg:::"+pOrg,"I");	

		queryValues =new String[]{"LIFNR EQ '"+vendChk+"' AND EKORG EQ '"+pOrg+"'"}; 
		outputFeilds =new String[]{"SPERM"};

		retBlk = readRFCTable(logonSite,"LFM1",outputFeilds,queryValues);
		ezc.ezcommon.EzLog4j.log("::retBlkOBJ in LFM1:::"+retBlk.toEzcString(),"I");


		if(retBlk!=null)
		    retBlkCnt=retBlk.getRowCount();	
		   
		 if(retBlkCnt == 0)
		 	vendBlk ="E";

		if(retBlkCnt>0)
			blkFlag = retBlk.getFieldValueString(0,"SPERM");
		ezc.ezcommon.EzLog4j.log("::blkFlag11 in LFM1:::"+blkFlag,"I");

		if("X".equals(blkFlag))
			vendBlk= blkFlag;

		ezc.ezcommon.EzLog4j.log("::vendBlkNew11:::"+vendBlk,"I");
	}	
	
	out.print(vendBlk);
%>
