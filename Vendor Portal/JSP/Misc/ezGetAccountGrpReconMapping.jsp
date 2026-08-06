 <%@ page import="ezc.vendorprofile.params.*,ezc.ezparam.*,ezc.ezmisc.params.*,java.util.*,java.text.*" %>		
 <jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
 <jsp:useBean id="vendorprofile" class="ezc.vendorprofile.client.EzVendorProfileManager" scope="session"></jsp:useBean>
 <jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"/>
 <jsp:useBean id="ConfigManager" class="ezc.client.EzSystemConfigManager" scope="session"></jsp:useBean>
  <%@ page import="org.json.JSONArray,org.json.JSONObject" %>
 
 <%!
 	public String checkNull(String value)
 	{
 		if(value==null || "null".equals(value.trim()))value="";
 		value=value.trim();
 		
 		return value;
 	}
 %>
 
<%
	JSONArray jsonArrObj 	= new JSONArray();
	JSONObject jsonObj 	= new JSONObject();
	//String acctGrpReconMapping= checkNull(request.getParameter("term"));
	
	String acctGrpReconMapping= checkNull(request.getParameter("accountGrp"));
	
	ezc.ezcommon.EzLog4j.log("::::acctGrpReconMapping:::::"+acctGrpReconMapping,"I");
	ezc.ezparam.EzcParams mainParams	= new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams = new EziMiscParams();

	//miscParams.setQuery("SELECT * FROM  EZC_RECON_ACCOUNT_GROUP_MAPPING WHERE ERAGM_ACCOUNT_GROUP like'%"+acctGrpReconMapping+"%' OR ERAGM_RECON_ACCOUNT LIKE'%"+acctGrpReconMapping+"%' OR ERAGM_ACCOUNT_GROUP_DESC LIKE'%"+acctGrpReconMapping+"%' OR ERAGM_RECON_ACCOUNT_DESC LIKE'%"+acctGrpReconMapping+"%'");
	miscParams.setQuery("SELECT * FROM  EZC_RECON_ACCOUNT_GROUP_MAPPING WHERE ERAGM_ACCOUNT_GROUP IN('"+acctGrpReconMapping+"')");

	mainParams.setObject(miscParams);
	mainParams.setLocalStore("Y");
	Session.prepareParams(mainParams);
	ReturnObjFromRetrieve acctGrpReconRetObj = (ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);
	int acctGrpReconRetObjCnt=0;
	
	
		
		
	try
	{
		if(acctGrpReconRetObj!=null && acctGrpReconRetObj.getRowCount()>0)
		{
			acctGrpReconRetObjCnt = acctGrpReconRetObj.getRowCount();	
			ezc.ezcommon.EzLog4j.log("::::acctGrpReconRetObj:::::"+acctGrpReconRetObj.toEzcString(),"I");
		
			for(int i=0;i<acctGrpReconRetObjCnt;i++)
			{
				String accountGrp 	= checkNull(acctGrpReconRetObj.getFieldValueString(i,"ERAGM_ACCOUNT_GROUP_DESC"));
				String reconAcct = checkNull(acctGrpReconRetObj.getFieldValueString(i,"ERAGM_RECON_ACCOUNT_DESC"));
				String accountGrpCode = checkNull(acctGrpReconRetObj.getFieldValueString(i,"ERAGM_ACCOUNT_GROUP"));
				String reconAcctCode = checkNull(acctGrpReconRetObj.getFieldValueString(i,"ERAGM_RECON_ACCOUNT"));

				jsonObj 	= new JSONObject();

				/*jsonObj.put("accountGrp",accountGrp+" ["+accountGrpCode+"]");
				jsonObj.put("reconAAccount",reconAcct+" ["+reconAcctCode+"]");
				jsonObj.put("key",accountGrpCode+"-"+reconAcctCode);*/
				
				jsonObj.put("reconAAccountCode",reconAcctCode);
				jsonObj.put("reconAAccountDesc",reconAcct);
				jsonArrObj.put(jsonObj);
			}
		}
		else
		{
				ezc.ezparam.EzcParams mainParams5	= new ezc.ezparam.EzcParams(false);
				EziMiscParams miscParams5	= new EziMiscParams();
				miscParams5.setQuery("SELECT * FROM EZC_MASTER_KEY_VALUES WHERE EMKV_MASTER_TYPE='RECONACCT' ORDER BY EMKV_VALUE");
				mainParams5.setLocalStore("Y");
				mainParams5.setObject(miscParams5);
				Session.prepareParams(mainParams5);

				ReturnObjFromRetrieve retReconAcct=(ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams5);

				int ReconAcctCnt=0;
					ReconAcctCnt=retReconAcct.getRowCount();	
					ezc.ezcommon.EzLog4j.log("::::retReconAcct:::::"+retReconAcct.toEzcString(),"I");
				
					for(int i=0;i<ReconAcctCnt;i++)
					{
						String masterType 	= checkNull(retReconAcct.getFieldValueString(i,"EMKV_MASTER_TYPE"));
						String masterKey 	= checkNull(retReconAcct.getFieldValueString(i,"EMKV_KEY"));
						String masterValue	= checkNull(retReconAcct.getFieldValueString(i,"EMKV_VALUE"));
								
						jsonObj 	= new JSONObject();
							
						jsonObj.put("reconAAccountCode",masterKey);
						jsonObj.put("reconAAccountDesc",masterValue);
						jsonArrObj.put(jsonObj);
					}
		
		}
		/*else{
			jsonObj 	= new JSONObject();

			jsonObj.put("accountGrp","Entered Data Does not Exists.");
			jsonObj.put("reconAAccount","");
			jsonArrObj.put(jsonObj);
		}*/
	}catch(Exception e){System.out.println(e);}
	
	String jsondata = jsonArrObj.toString();
			ezc.ezcommon.EzLog4j.log(jsondata+"::::::::::jsondata::::::::","I");
	out.println(jsondata);
	
%>