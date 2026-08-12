<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" />
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*,ezc.ezcommon.*,ezc.ezutil.*" %>
<%@page import="com.sap.mw.jco.*,ezc.sapconnection.EzSAPHandler"%>
<%@include file="../../../Includes/Lib/AddButtonDir.jsp"%>

<%
	java.util.ArrayList RFQNos = new java.util.ArrayList();
	java.util.ArrayList selectedItems = new java.util.ArrayList();
	String matNo[]= request.getParameterValues("matNo");
	String allRFQs[]= request.getParameterValues("RFQNos");
	
	for(int i=0;i<allRFQs.length;i++)
	{
		if(!RFQNos.contains(allRFQs[i]))
			RFQNos.add(allRFQs[i]);
	}

	String RFQItems[]= request.getParameterValues("RFQItems");
	String QCFNo= request.getParameter("cRFQNo");
	
	String msg = "";
	ezc.ezparam.EzcParams mainParams=new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams = new EziMiscParams();

	String r3SysSID = "245~999";
	JCO.Function function = null;
	JCO.Client client = null;
	boolean errorOccured = false;
	try
	{

		client = EzSAPHandler.getSAPConnection(r3SysSID);
		function = EzSAPHandler.getFunction("Z_EZ_QCF_VEN_SELECTION",r3SysSID);

		JCO.ParameterList tablesList = function.getTableParameterList();
		JCO.Table RFQItemsTable  = tablesList.getTable("RFQ_ITEMS");
		JCO.Table RFQRemarksTable  = tablesList.getTable("RFQ_ITEM_TEXT");

		if(matNo!=null)
		{
			for(int i=0;i<allRFQs.length;i++)
			{
				int cnt=0;
				
				String selRFQNoItemStr= request.getParameter("vSelection_"+RFQItems[i]);
				
				if(selRFQNoItemStr==null || "null".equals(selRFQNoItemStr.trim()))continue;
				String selRFQNoItemArr[] = selRFQNoItemStr.split("¥");
				String selRFQNo = selRFQNoItemArr[0];
				String itemNo	= selRFQNoItemArr[1];

				
								
								
				for(int j=0;j<RFQNos.size();j++)
				{
					String isRFQRej = "Y";
					String reasons	= request.getParameter("Resons"+(String)RFQNos.get(j)+itemNo);
					String remarks	= request.getParameter("comments"+(String)RFQNos.get(j)+itemNo);
					String rank	= request.getParameter("rank"+(String)RFQNos.get(j)+itemNo);
					String value	= request.getParameter("value"+(String)RFQNos.get(j)+itemNo);
					String quantity	= request.getParameter("Quantity"+(String)RFQNos.get(j)+itemNo);
					String tempRFQNo="";
					String dbRFQ="";

					if(remarks==null || "null".equals(remarks.trim()) || "".equals(remarks.trim()))remarks="";
					if(reasons==null || "null".equals(reasons.trim()) || "".equals(reasons.trim()))reasons="";
					if(value==null || "null".equals(value.trim()) || "".equals(value.trim()))value="0";

					if(RFQNos!=null)
					{
						tempRFQNo=(String)RFQNos.get(j);
						try{
						dbRFQ = Integer.parseInt(tempRFQNo)+"";
						}catch(Exception e){dbRFQ=tempRFQNo;}
					}

					if(selRFQNo.equals(tempRFQNo))isRFQRej="N";

					mainParams=new ezc.ezparam.EzcParams(false);
					miscParams = new EziMiscParams();

					miscParams.setQuery("UPDATE EZC_RFQ_DETAILS SET ERD_NET_VALUE='"+value+"',ERD_REASONS='"+reasons+"',ERD_QUOT_CMMT_TEXT='"+remarks+"',ERD_REJ_INDICATOR='"+isRFQRej+"',ERD_QUOT_COMMENTS='"+rank+"',ERD_COUNTER_QUANTITY='"+quantity+"'  WHERE  ERD_RFQ_NO='"+dbRFQ+"' and ERD_LINE_NO='"+itemNo+"'");
					mainParams.setLocalStore("Y");
					mainParams.setObject(miscParams);
					Session.prepareParams(mainParams);

					try{
					ezMiscManager.ezUpdate(mainParams);
					}catch(Exception e){errorOccured = true;ezc.ezcommon.EzLog4j.log(":::::Exception while updating ranks in db::::"+e,"I");}

					RFQItemsTable.appendRow();
					//if(!"".equals(remarks))
					RFQItemsTable.setValue(rank,"COMMENT");
					RFQItemsTable.setValue(tempRFQNo,"RFQ");
					RFQItemsTable.setValue(itemNo,"RFQ_ITEM");
					if("Y".equals(isRFQRej))
					RFQItemsTable.setValue("X","REJ_IND");
					if(!"".equals(reasons))
					RFQItemsTable.setValue(reasons,"ORD_REAS");

					RFQRemarksTable.appendRow();
					RFQRemarksTable.setValue(tempRFQNo,"PO_NUMBER");
					RFQRemarksTable.setValue(itemNo,"PO_ITEM");
					RFQRemarksTable.setValue(remarks,"TEXT_LINE");
				}
			}

			if(!errorOccured)
			client.execute(function);

			JCO.Table fieldsOut = function.getTableParameterList().getTable("RETURN1");
			ezc.ezcommon.EzLog4j.log(":::::::::::RETURN1:::::::::::"+fieldsOut,"I");

			int fieldsOutCount = fieldsOut.getNumRows();


			if(fieldsOutCount>0)
			{
				do
				{
					String type 	= (String)fieldsOut.getValue("TYPE");
					String comment 	= (String)fieldsOut.getValue("MESSAGE");
					String id 	= (String)fieldsOut.getValue("ID");

					if("S".equals(type))
					{
						errorOccured = false;
						if(!"TD".equals(id))
						{
							if("".equals(msg))
							msg = comment;
							else
							msg = msg+"<br>"+comment;
						}
					}
					else if("E".equals(type))
					{
						errorOccured = true;
						if("".equals(msg))
						msg = comment;
						else
						msg = msg+"<br>"+comment;
					}
					else
					msg = "Problem Occured While Updating RFQ in SAP.";

				}
				while(fieldsOut.nextRow());
			}

			if(!errorOccured)
			{
				mainParams=new ezc.ezparam.EzcParams(false);
				miscParams = new EziMiscParams();

				miscParams.setQuery("UPDATE ezc_rfq_header SET ERH_RELEASE_INDICATOR='Y' where erh_colletive_rfq_no='"+QCFNo+"'");
				mainParams.setLocalStore("Y");
				mainParams.setObject(miscParams);
				Session.prepareParams(mainParams);
				ezMiscManager.ezUpdate(mainParams);
			}	
		}
		
	}
	catch(Exception e)
	{
		ezc.ezcommon.EzLog4j.log("Exception :::"+e,"I");
	}
	finally
	{
		if(client!=null)
		{
			JCO.releaseClient(client);
			client = null;
			function = null;
		}
	}

%>
<html>
<head>
<Script>
function qcfList()
{
	window.close();
	
}
</Script>
<body>
<Form name="myForm" method="post">

<Div align=center style="position:absolute;visibility:visible;width:100%;top:40%">    
<Table  width="60%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
	<Tr align="center">
    		<Td class="displayheader"><%=msg%> </Td>
  	</Tr>
</Table>
</Div>
<Div id="ButtonsDiv" align=center style="visibility:visible;width:100%;position:absolute;top:90%">    
<%
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();
	
	buttonName.add("Ok");   
	buttonMethod.add("qcfList()");
	
	out.println(getButtonStr(buttonName,buttonMethod));
%>
</Div>
</Form>
</body>
</html>