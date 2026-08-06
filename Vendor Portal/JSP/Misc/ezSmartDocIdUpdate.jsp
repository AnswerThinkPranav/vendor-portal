<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*,java.util.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean> 
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" />
<%!
	public String checkNull(String value)
	{
		if(value==null || "null".equals(value.trim()))value="";
		value=value.trim();

		return value;
	}
%>
<%

	ezc.session.EzLogonStructure logs = new ezc.session.EzLogonStructure();

	logs.setUserId("SESSIONUSR");
	logs.setPassWd("portal");
	logs.setConnGroup("200");
	ezc.ezparam.EzLogonStatus LogonStatus =  (ezc.ezparam.EzLogonStatus)Session.logon(logs);

	Hashtable poratalSmartDocHT = new Hashtable();

	ReturnObjFromRetrieve dispatchPortalIdRetObj=null;
	int dispatchPortalIdRetObjCnt=0;
	ReturnObjFromRetrieve shipmentPortalIdRetObj=null;
	int shipmentPortalIdRetObjCnt=0;
	ReturnObjFromRetrieve sapSmartDocIdsRetObj=null;
	int sapSmartDocIdsRetObjCnt=0;

	String portalRefIds = "";

	ezc.ezparam.EzcParams mainParams_duplicate	= new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams_duplicate		= new EziMiscParams();
	miscParams_duplicate.setQuery("SELECT * FROM EZC_DISPATCH_HEADER WHERE EDH_SAP_ID is null");
	mainParams_duplicate.setLocalStore("Y");
	mainParams_duplicate.setObject(miscParams_duplicate);
	Session.prepareParams(mainParams_duplicate);

	try{ 
		dispatchPortalIdRetObj=(ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams_duplicate);
		if(dispatchPortalIdRetObj!=null)
		{
			dispatchPortalIdRetObjCnt=dispatchPortalIdRetObj.getRowCount();
		}
	}catch(Exception e){}
	ezc.ezcommon.EzLog4j.log("::::::::::::dispatchPortalIdRetObjCnt::::::::::>>>>>>>>"+dispatchPortalIdRetObjCnt,"I");
	for(int i=0;i<dispatchPortalIdRetObjCnt;i++)
	{ 
		if("".equals(portalRefIds))
		portalRefIds = checkNull(dispatchPortalIdRetObj.getFieldValueString(i,"EDH_ID").trim());
		else
		portalRefIds = portalRefIds+"','"+checkNull(dispatchPortalIdRetObj.getFieldValueString(i,"EDH_ID").trim());
	}


	ezc.ezparam.EzcParams mainParams_duplicate11	= new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams_duplicate11		= new EziMiscParams();
	miscParams_duplicate11.setQuery("SELECT * FROM EZC_SHIPMENT_HEADER WHERE EZSH_STATUS='I' AND EZSH_SAP_ID is null");
	mainParams_duplicate11.setLocalStore("Y");
	mainParams_duplicate11.setObject(miscParams_duplicate11);
	Session.prepareParams(mainParams_duplicate11);

	try{ 
		shipmentPortalIdRetObj=(ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams_duplicate11);
		if(shipmentPortalIdRetObj!=null)
		{
			shipmentPortalIdRetObjCnt=shipmentPortalIdRetObj.getRowCount();
		}
	}catch(Exception e){}

	ezc.ezcommon.EzLog4j.log("::::::::::::shipmentPortalIdRetObjCnt::::::::::>>>>>>>>"+shipmentPortalIdRetObjCnt,"I");

	for(int j=0;j<shipmentPortalIdRetObjCnt;j++)
	{
		if("".equals(portalRefIds))
		portalRefIds = checkNull(shipmentPortalIdRetObj.getFieldValueString(j,"EZSH_SH_ID").trim());
		else
		portalRefIds = portalRefIds+"','"+checkNull(shipmentPortalIdRetObj.getFieldValueString(j,"EZSH_SH_ID").trim());
		//ezc.ezcommon.EzLog4j.log("::::::::::::portalRefIdsportalRefIdsportalRefIds::::::::::>>>>>>>>"+portalRefIds,"I");
	}


	ezc.ezparam.EzcParams mainParams_duplicate12	= new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams_duplicate12		= new EziMiscParams();
	miscParams_duplicate12.setQuery("SELECT * from EZC_SMARTDOC_IDS where ESI_PORTAL_ID IN('"+portalRefIds+"')");
	mainParams_duplicate12.setLocalStore("Y");
	mainParams_duplicate12.setObject(miscParams_duplicate12);
	Session.prepareParams(mainParams_duplicate12);

	try{ 
		sapSmartDocIdsRetObj=(ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams_duplicate12);
		if(sapSmartDocIdsRetObj!=null)
		{
			sapSmartDocIdsRetObjCnt=sapSmartDocIdsRetObj.getRowCount();
		}
	}catch(Exception e){} 
	ezc.ezcommon.EzLog4j.log("::::::::::::sapSmartDocIdsRetObjCnt::::::::::>>>>>>>>"+sapSmartDocIdsRetObjCnt,"I");
	for(int k=0;k<sapSmartDocIdsRetObjCnt;k++)
	{
		String portalId = checkNull(sapSmartDocIdsRetObj.getFieldValueString(k,"ESI_PORTAL_ID").trim());
		String smartDocId = checkNull(sapSmartDocIdsRetObj.getFieldValueString(k,"ESI_SMART_DOC_ID").trim());
		poratalSmartDocHT.put(portalId,smartDocId);
	}
	if(dispatchPortalIdRetObjCnt>0)
	{
		for(int l=0;l<dispatchPortalIdRetObjCnt;l++)
		{
			String portalId = checkNull(dispatchPortalIdRetObj.getFieldValueString(l,"EDH_ID").trim());
			if(poratalSmartDocHT!=null && poratalSmartDocHT.containsKey(portalId))
			{
				String smartDocVal = (String)poratalSmartDocHT.get(portalId);

				ezc.ezparam.EzcParams mainParams_duplicate13	= new ezc.ezparam.EzcParams(false);
				EziMiscParams miscParams_duplicate13		= new EziMiscParams();
				miscParams_duplicate13.setQuery("UPDATE EZC_DISPATCH_HEADER SET EDH_SAP_ID='"+smartDocVal+"',EDH_STATUS='POSTEDTOSAP',EDH_MODIFIED_ON=now() WHERE EDH_ID = '"+portalId+"'");
				mainParams_duplicate13.setLocalStore("Y");
				mainParams_duplicate13.setObject(miscParams_duplicate13);
				Session.prepareParams(mainParams_duplicate13);

				try{ 
					ezMiscManager.ezUpdate(mainParams_duplicate13);

				}catch(Exception e){}

			}
		}
	}
	if(shipmentPortalIdRetObjCnt>0)
	{
		for(int m=0;m<shipmentPortalIdRetObjCnt;m++)
		{
			String portalShipmentId = checkNull(shipmentPortalIdRetObj.getFieldValueString(m,"EZSH_SH_ID").trim());
			if(poratalSmartDocHT!=null && poratalSmartDocHT.containsKey(portalShipmentId))
			{
				String smartDocVal = (String)poratalSmartDocHT.get(portalShipmentId);

				ezc.ezparam.EzcParams mainParams_duplicate14	= new ezc.ezparam.EzcParams(false);
				EziMiscParams miscParams_duplicate14		= new EziMiscParams();
				miscParams_duplicate14.setQuery("UPDATE EZC_SHIPMENT_HEADER SET EZSH_LAST_MOD_ON = now() ,EZSH_SAP_ID='"+smartDocVal+"',EZSH_TRANSACTION_STATUS='POSTEDTOSAP' WHERE EZSH_SH_ID ='"+portalShipmentId+"'");
				mainParams_duplicate14.setLocalStore("Y");
				mainParams_duplicate14.setObject(miscParams_duplicate14);
				Session.prepareParams(mainParams_duplicate14);

				try{ 
					ezMiscManager.ezUpdate(mainParams_duplicate14);

				}catch(Exception e){}

			}
		}
	}
//ezc.ezcommon.EzLog4j.log(":::::::portalRefIds:::::::>>>>>>>>"+portalRefIds,"I");
	try{ 
		ezc.ezcommon.EzLog4j.log("SMARTDOC STATUS IN PORTAL UPDATE_LOGOUT>>>>>>>>","I");
		Session.logOut(); 
	} catch(Exception e) { 
		ezc.ezcommon.EzLog4j.log("SMARTDOC STATUS IN PORTAL UPDATE_ERROR>>>>>>>>"+e,"E");
		} 
	session.invalidate();
%>