<%@ page import="com.sap.mw.jco.*,java.util.*,javax.swing.*,java.awt.*" %>
<%@ page import ="ezc.sapconnection.*,com.sap.mw.jco.*,com.sap.mw.jco.JCO" %>
<%
	Hashtable venMailIds = new Hashtable();
	Hashtable venMailAndSeqNum = new Hashtable();

if(vendorCodes!=null)
{
	JCO.Client jcoClient=null;
	JCO.Function jcoFunction = null;
	try
	{
		jcoClient = EzSAPHandler.getSAPConnection("200~999");
		jcoFunction = EzSAPHandler.getFunction("Z_EZ_GET_VEN_MAIL_IDS","200~999");
		JCO.Table vendorCodeTable = jcoFunction.getTableParameterList().getTable("VENDORCODE");

		int vendCount=vendorCodes.size();

		ezc.ezcommon.EzLog4j.log("=========vendorCodes==============>"+vendorCodes,"I");
		for(int ven=0;ven<vendCount;ven++)
		{
			String mySoldToStr = (String) (vendorCodes.elementAt(ven));
			String mySoldTo = "0000000000"+mySoldToStr.trim();
			mySoldTo = mySoldTo.substring(mySoldTo.length()-10,mySoldTo.length());  

			vendorCodeTable.appendRow();
			vendorCodeTable.setValue(mySoldTo,"LIFNR");

		}

		jcoClient.execute(jcoFunction);


		JCO.Table ret = jcoFunction.getTableParameterList().getTable("VENDORMAILIDS");
		int retCount = ret.getNumRows();
		if(retCount>0)
		{
			do
			{
				String persnumber 	= (String)ret.getValue("PERSNUMBER");
				String mailId 		= (String)ret.getValue("SMTP_ADDR");
				String seqNumber 	= (String)ret.getValue("CONSNUMBER");
				String mailIdAndSeqNum  = mailId+"¥"+seqNumber;
				if(venMailIds.containsKey(persnumber))
				{
					String temp 			= (String)venMailIds.get(persnumber);
					String tempVenMailAndSeqNum 	= (String)venMailAndSeqNum.get(persnumber);
					venMailIds.remove(persnumber);
					venMailAndSeqNum.remove(persnumber);
					mailId = temp+","+mailId;
					mailIdAndSeqNum = tempVenMailAndSeqNum+","+mailIdAndSeqNum;

				}
				venMailIds.put(persnumber,mailId);
				venMailAndSeqNum.put(persnumber,mailIdAndSeqNum);
			}
			while(ret.nextRow());
			ezc.ezcommon.EzLog4j.log("=========venMailIds==============>"+venMailIds,"I");
			ezc.ezcommon.EzLog4j.log("=========venMailAndSeqNum==============>"+venMailAndSeqNum,"I");

		}

	}

	catch(Exception e)
	{
		e.printStackTrace();
	}
	finally
	{
		if (jcoClient!=null)
		{
			JCO.releaseClient(jcoClient);
			jcoClient = null;
			jcoFunction=null;

		}
	}

}
%>