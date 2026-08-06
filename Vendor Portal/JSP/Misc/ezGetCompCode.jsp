<%@ page import="java.util.*" %>
<%
	int hdrXMLCnt = 0;
	int hdrXMLCnt1 = 0;
	//String qryRFQ = "";
	Hashtable<String,String> naCompHt = new Hashtable<String,String>();
	
	ezc.ezparam.EzcParams rfqParams = new ezc.ezparam.EzcParams(false); 	
	ezc.misctransactions.client.EzMiscTransactionsManager rfqMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable rfqTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow rfqTableRow = new ezc.misctransactions.params.EzMiscTableRow();

	ezc.ezparam.ReturnObjFromRetrieve hdrXML	  =	null; 
	
	
	rfqTableRow.setQuery("SELECT * FROM EZC_VALUE_MAPPING WHERE MAP_TYPE IN ('NA_COMP')");
	rfqTable.appendRow(rfqTableRow);
	rfqParams.setLocalStore("Y");
	rfqParams.setObject(rfqTable);
	Session.prepareParams(rfqParams);

	ezc.ezcommon.EzLog4j.log(">>>>QUERY_COMPCODES>>>>:"+rfqTableRow.getQuery(),"D");
	try
	{
		hdrXML=(ezc.ezparam.ReturnObjFromRetrieve)rfqMgr.ezGetMiscTransactions(rfqParams);
		ezc.ezcommon.EzLog4j.log("::::hdrXML_VendSync11:::"+hdrXML.toEzcString(),"D");
	}
	catch(Exception e)
	{
		ezc.ezcommon.EzLog4j.log("Exception in getting company codes >>>"+e,"I");		
	}
	int Count = hdrXML.getRowCount();
	if(hdrXML != null)
		hdrXMLCnt = hdrXML.getRowCount();
	/*for(int i=0;i<hdrXMLCnt;i++)
	{		
		naCompHt.put(hdrXML1.getFieldValueString(i,"EVGD_VENDOR"),hdrXML1.getFieldValueString(i,"EVGD_NAME"));
		ezc.ezcommon.EzLog4j.log(":::::naCompHt::::naCompHt:::"+naCompHt.toString(),"I");
	}*/
	
		ezc.ezparam.EzcParams rfqParams1 = new ezc.ezparam.EzcParams(false); 	
		ezc.misctransactions.client.EzMiscTransactionsManager rfqMgr1 = new ezc.misctransactions.client.EzMiscTransactionsManager();
		ezc.misctransactions.params.EzMiscTable rfqTable1 = new ezc.misctransactions.params.EzMiscTable();
		ezc.misctransactions.params.EzMiscTableRow rfqTableRow1 = new ezc.misctransactions.params.EzMiscTableRow();
		ezc.ezparam.ReturnObjFromRetrieve hdrXML1	  =	null; 
		
		rfqTableRow1.setQuery("SELECT EVGD_VENDOR,EVGD_NAME FROM EZC_VEND_GEN_DATA");
		rfqTable1.appendRow(rfqTableRow1);
		rfqParams1.setLocalStore("Y");
		rfqParams1.setObject(rfqTable1);
		Session.prepareParams(rfqParams1);
	
		ezc.ezcommon.EzLog4j.log(">>>>QUERY_COMPCODES>>>>:"+rfqTableRow1.getQuery(),"D");
		try
		{
			hdrXML1=(ezc.ezparam.ReturnObjFromRetrieve)rfqMgr1.ezGetMiscTransactions(rfqParams1);
			ezc.ezcommon.EzLog4j.log("::::hdrXML1_VendSync11:::"+hdrXML1.toEzcString(),"D");
		}
		catch(Exception e)
		{
			ezc.ezcommon.EzLog4j.log("Exception in getting company codes >>>"+e,"I");		
		}
		int Count1 = hdrXML1.getRowCount();
		if(hdrXML1 != null)
			hdrXMLCnt1 = hdrXML1.getRowCount();
		for(int i=0;i<hdrXMLCnt1;i++)
		{		
			naCompHt.put(hdrXML1.getFieldValueString(i,"EVGD_VENDOR"),hdrXML1.getFieldValueString(i,"EVGD_NAME"));
			//ezc.ezcommon.EzLog4j.log(":::::naCompHt::::naCompHt:::"+naCompHt.toString(),"I");
		}
		
		
		//if(!naCompHt.containsKey(sapVendCode))
	
	
	
%>


