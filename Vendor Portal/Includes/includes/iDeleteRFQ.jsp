<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"/>
<%@ page import ="ezc.ezparam.*,ezc.ezsap.*" %>
<%@ page import ="java.io.*" %>
<%@ page import="com.sap.mw.jco.*,java.util.*,javax.swing.*,java.awt.*" %>
<%@ page import ="ezc.sapconnection.*,com.sap.mw.jco.*,com.sap.mw.jco.JCO" %>
<%
		String fields []= {"MSG","TYPE","CODE","MSGNO"};
		ReturnObjFromRetrieve retTab = new ReturnObjFromRetrieve(fields);
		String rfqNO=request.getParameter("PurchaseOrder");
		rfqNO="0000000000"+rfqNO;
		rfqNO=rfqNO.substring(rfqNO.length()-10,rfqNO.length());
		
		String msg="RFQ deleted successfully.";
		
		String [] itemNO=request.getParameterValues("itemNO");
		int itemCount=itemNO.length;
		boolean isDeleteInSAP =false;
		
		JCO.Client client1=null;
		JCO.Function function = null;
		JCO.Function function1 = null;
		try
		{
			client1 = EzSAPHandler.getSAPConnection("245~999");
			function = EzSAPHandler.getFunction("Z_EZ_RFQ_DELETE","245~999");
			JCO.ParameterList sapRFQ = function.getImportParameterList();
			
			JCO.Table rfqItem          = function.getTableParameterList().getTable("RFQ_ITEMS");

			sapRFQ.setValue(rfqNO,"RFQ_NO");
			
			for(int i=0;i<itemCount;i++)
			{
				rfqItem.appendRow();
				rfqItem.setValue(itemNO[i],"PO_ITEM");
			}	
			
			client1.execute(function);
			//EzSAPHandler.commit(client1,"245~999");
			ezc.ezcommon.EzLog4j.log("Successfully Excuted FM Z_EZ_RFQ_DELETE====>>>>","D");
			
			}catch(Exception e){
				ezc.ezcommon.EzLog4j.log("Exception occured while executing FM Z_EZ_RFQ_DELETE====> "+e,"D");
				
			}
					
			
			try
			{

				JCO.Table ret = function.getTableParameterList().getTable("RETURN");
				int retCount = ret.getNumRows();
				if(retCount>0)
				{
					do
					{
						if("S".equals((String)ret.getValue("TYPE")))
						{
							isDeleteInSAP=true;
							msg="RFQ- "+rfqNO+" deleted successfully.";
						}	
						else
							msg=(String)ret.getValue("MESSAGE");
							
						retTab.setFieldValue("TYPE",ret.getValue("TYPE"));
						retTab.setFieldValue("MSG",ret.getValue("MESSAGE"));
						retTab.setFieldValue("CODE",ret.getValue("MESSAGE_V2"));
						retTab.setFieldValue("MSGNO",ret.getValue("MESSAGE_V1"));
						retTab.addRow();

					}	
					while(ret.nextRow());
				}
			
			}
			catch(Exception e)
			{
				ezc.ezcommon.EzLog4j.log("Exception occured while getting data from RETURN table====>"+e,"D");
			}

			finally
			{
				if (client1!=null)
				{
					JCO.releaseClient(client1);
					client1 = null;
					function=null;

				}
			}
			System.out.println("retTabretTabretTabretTab>>>"+retTab.toEzcString());
		
							
%>