<%@page import="java.util.*"%>
<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/Jsps/Misc/iblockcontrol.jsp" %>
<%@ include file="../../../Includes/Jsps/Rfq/iListPR.jsp" %>

<%
	
	out.println("<?xml version=\"1.0\"?>");
	out.println("<rows>");
	if(myRetCount>0){
 		String prno = "";
		String item = "";
		String creadate = "";
		String reldate = "";
		String deldate = "";
		String mat = "";
		String matdesc = "";
		String qty = "";
		String uom = "";
		String chkLink ="";
		ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate();
		boolean showStr = false;
  	
		for(int i=0;i<myRetCount;i++)
		{
			try
			{
				prno=""+Long.parseLong(myRet.getFieldValueString(i,"REQNO"));
			}
			catch(Exception e)
			{
				prno=myRet.getFieldValueString(i,"REQNO");
			}
			
			try
			{
				item=""+Long.parseLong(myRet.getFieldValueString(i,"ITEM"));
			}
			catch(Exception e)
			{	
				item=myRet.getFieldValueString(i,"ITEM");
			}
			
			try
			{
				mat =""+Long.parseLong(myRet.getFieldValueString(i,"MATERIAL"));
			}
			catch(Exception e)
			{
				mat =myRet.getFieldValueString(i,"MATERIAL");
			}
			
			creadate = fd.getStringFromDate((Date)myRet.getFieldValue(i,"REQDATE"),(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
			reldate  = fd.getStringFromDate((Date)myRet.getFieldValue(i,"REL_DATE"),(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
			deldate  = fd.getStringFromDate((Date)myRet.getFieldValue(i,"DELIV_DATE"),(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
			matdesc  = myRet.getFieldValueString(i,"DESCRIPTION");
			plant 	 = myRet.getFieldValueString(i,"PLANT");
			qty 	 = myRet.getFieldValueString(i,"QUANTITY");
			uom 	 = myRet.getFieldValueString(i,"UNIT"); 	
			
			matdesc = matdesc.replace('\'','`');
			
			/*
				String styleTemp="",prColor="";
				if(Status.equals("R"))
				{
					String searchKey=myRet.getFieldValueString(i,"REQNO")+"¥"+myRet.getFieldValueString(i,"ITEM");

					if(prTreeSet.contains(searchKey))
					{
						showStr = true;
						prColor = "style='color:#ff0000'";
					}
				}	
			*/
			///if(Status.equals("R"))
			
			//chkLink= prno+"#"+item;
			chkLink= mat+"$$"+plant+"$$"+deldate+"$$"+qty+"$$"+uom+"$$"+matdesc+"$$"+prno+"$$"+item+"$$"+myRet.getFieldValueString(i,"VAL_TYPE");
			out.println("<row id='"+chkLink+"'><cell><![CDATA[<nobr><input type=checkbox name=purchReq value="+chkLink+"></nobr>]]></cell><cell>"+prno+" - "+item+"</cell><cell>"+creadate+"</cell><cell>"+reldate+"</cell><cell>"+deldate+"</cell><cell>"+mat+"</cell><cell>"+matdesc+"</cell><cell>"+plant+"</cell><cell>"+qty+"</cell><cell>"+uom+"</cell></row>");
			///mat+"$$"+plant+"$$"+deldate+"$$"+qty+"$$"+uom+"$$"+matdesc+"$$"+prno+"$$"+item+"$$"+myRet.getFieldValueString(i,"VAL_TYPE");
		}
		
	}else{
	
		out.println("<row id='"+myRetCount+"'></row>");
		ezc.ezcommon.EzLog4j.log("<row id='"+myRetCount+"'></row>"+"NO PR---LIST FROM R/3","I");
	}
	
	out.println("</rows>");
%>
