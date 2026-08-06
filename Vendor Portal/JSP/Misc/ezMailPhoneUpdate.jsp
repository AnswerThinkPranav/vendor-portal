<%@ page import ="ezc.sapconnection.*,com.sap.conn.jco.monitor.*,com.sap.conn.jco.*,com.sap.conn.jco.ext.DestinationDataProvider,java.io.*" %>
<%@ page import="ezc.vendorprofile.params.*,ezc.ezparam.*,java.util.*,java.text.*" %>	
<%@ page import="ezc.vendortransactions.params.*,ezc.ezparam.*,java.util.*" %>	
<%@ page import="ezc.ezmisc.params.*,java.io.*,java.nio.channels.*,com.sap.mw.jco.*,com.sap.mw.jco.JCO" %>
<%@ page import="com.sap.conn.jco.JCoDestination" %>
<%@ page import="com.sap.conn.jco.JCoDestinationManager" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.sap.conn.jco.ext.DestinationDataProvider" %>
<jsp:useBean id="miscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"></jsp:useBean>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="vendortransactions" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="session"></jsp:useBean>
<jsp:useBean id="vendorprofile" class="ezc.vendorprofile.client.EzVendorProfileManager" scope="session"></jsp:useBean>
<%@ include file="ezGetUserAuthDefaults.jsp"%> 
<%@ include file="ezHeader.jsp"%> 
<%!
public String checkNull(String value)
{
	if(value==null || "null".equals(value.trim()))value="";
	value=value.trim();
	
	return value;
} 
%>
<%
EziMiscParams miscParams = new EziMiscParams();   
ezc.ezparam.EzcParams mainParams	= new ezc.ezparam.EzcParams(false);
String vendUser	= 	(String)Session.getUserId();
String defSoldTo    = "0000000000"+vendUser; 		
defSoldTo=defSoldTo.substring(vendUser.length(),defSoldTo.length());

String email = checkNull(request.getParameter("emaill"));
String mobile = checkNull(request.getParameter("mobilee"));
out.println(email+"<>"+mobile+"<>"+vendUser);

	String SAPUserId	= checkNull(request.getParameter("SAPUSER")); 	
	String SAPPassword      = checkNull(request.getParameter("SAPPASSWORD")); 
	String vendCode = "";
	String AcctGroup = checkNull(request.getParameter("AcctGroup"));
	String purchOrg  = checkNull(request.getParameter("purchOrg"));
	String CompanyCode = "CFL";
	out.println(SAPUserId+"<>"+SAPPassword+"<>"+vendUser);
	ezc.ezcommon.EzLog4j.log(SAPUserId+":::::::::SAPUserId:::::::::","I");
	ezc.ezcommon.EzLog4j.log(SAPPassword+"::::::::SAPPassword::::::::","I");
	
JCO.Client client1=null;
JCO.Function function = null;
boolean errorOccured=false;
String dispMessage="Problem occured while posting vendor details to SAP.",dispMsgType="E",divWidth="90%";

try
	{   
			ReturnObjFromRetrieve retuser_groups	=  null;
			int   user_groupsCnt	=  0;
			ezc.ezparam.EzcParams mainParams_user_groups	= new ezc.ezparam.EzcParams(false);
			EziMiscParams miscParams_user_groups = new EziMiscParams();
			miscParams_user_groups.setQuery("Select * From Ezc_User_Groups Where Eug_Id='999'");
			mainParams_user_groups.setLocalStore("Y");
			mainParams_user_groups.setObject(miscParams_user_groups);
			Session.prepareParams(mainParams_user_groups);
	
			try
			{
				retuser_groups=(ReturnObjFromRetrieve)miscManager.ezSelect(mainParams_user_groups);
			}
			catch(Exception e)
			{
			ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Details:::::"+e,"I");
			}
			if(retuser_groups!=null)
			user_groupsCnt=retuser_groups.getRowCount();
			
			String eugID 	= retuser_groups.getFieldValueString(0,"EUG_ID");
			String hostIP 	= retuser_groups.getFieldValueString(0,"EUG_R3_HOST");
			String r3Lang 	= retuser_groups.getFieldValueString(0,"EUG_R3_LANG");
			String r3Client = retuser_groups.getFieldValueString(0,"EUG_R3_CLIENT");
			String r3Userid = retuser_groups.getFieldValueString(0,"EUG_R3_USER_ID");
			String r3Passwd = retuser_groups.getFieldValueString(0,"EUG_R3_PASSWD");
			String r3SysNo = retuser_groups.getFieldValueString(0,"EUG_R3_SYS_NO");
			//String lang = retuser_groups.getFieldValueString(0,"EUG_R3_LANG");
			out.println(eugID+"::::::::"+hostIP+"::::::::"+r3Lang+"::::::::"+r3Client+"::::::::"+r3Userid+"::::::::"+r3Passwd+"::::::::");
						
		client1 = JCO.createClient(r3Client, 		// SAP client
				r3Userid, 	// userid
				r3Passwd, 	// password
				r3Lang, 		
				hostIP,    
			r3SysNo); 
			
			//JCoDestination destination = EzSAPHandler.getDestination("200~999");
			// function = EzSAPHandler.getJCoFunction(destination,"Z_EZ_GET_VENDOR_UPDATE");		
			
			client1.connect();
			JCO.Repository mRepository = new JCO.Repository("REP123", client1);
			 function = new JCO.Function((mRepository).getFunctionTemplate("Z_EZ_GET_VENDOR_UPDATE"));
			
			JCO.ParameterList impParam = function.getImportParameterList();
			
		JCO.Table vendDataTable  	= function.getTableParameterList().getTable("VENDOR_DATA");			      
		JCO.Table vendEmailsTable  	= function.getTableParameterList().getTable("VEND_EMAILS");	
			
		//impParam.setValue(CompanyCode,"COMP_DATA");
		//impParam.setValue(purchOrg,"PUR_ORG");
		//impParam.setValue(AcctGroup,"ACCOUNT_GROUP");
		
		impParam.setValue(defSoldTo,"VENDOR");
		impParam.setValue(CompanyCode,"COMPCODE");
				
		ezc.ezcommon.EzLog4j.log(":::::::vendUser::::::"+defSoldTo,"I");
		ezc.ezcommon.EzLog4j.log(":::::::CompanyCode::::::"+CompanyCode,"I");	
		
		vendDataTable.appendRow();
		vendDataTable.setValue(mobile,"TELF2");
		
		vendEmailsTable.appendRow();
				if(!"".equals(email))
				vendEmailsTable.setValue(email,"SMTP_ADDR");				
				ezc.ezcommon.EzLog4j.log(":::::::vendEmailsTable::::::"+vendEmailsTable,"I");
				try
				{
					//function.execute(destination);		
					client1.execute(function);
				}
				catch(Exception e)
				{
					 errorOccured = true;
					ezc.ezcommon.EzLog4j.log("::::::Exception while executing Z_EZ_GET_VENDOR_UPDATE::::::"+e,"E");
				}
				//com.sap.mw.jco.JCO.ParameterList expParam = function.getExportParameterList();
				//vendCode=checkNull((String)expParam.getValue("VENCODE"));
				//ezc.ezcommon.EzLog4j.log("::::::new vendor created with number :::::::::"+vendCode,"I");
				JCO.Table retTable  = function.getTableParameterList().getTable("RETURN");	      	
				int retCount         = retTable.getNumRows();				
				ezc.ezcommon.EzLog4j.log("::::::retTable:::::::::"+retTable,"I");
				if(retCount > 0)
				{
					int i=0;
					do
					{						
						String  msgType       =  (String)retTable.getValue("TYPE");
						String  msgStr       =  (String)retTable.getValue("MESSAGE");						
						if("E".equals(msgType))
						{
							i=i+1;
							errorOccured = true;
							if(i==1)dispMessage=dispMessage+"<br>";
							dispMessage=dispMessage+"<br><b>"+i+")"+msgStr+"</b>";						
						}						
					}						 
					while(retTable.nextRow());			 
				}						
	}
	catch(Exception e){
				 errorOccured = true;
				ezc.ezcommon.EzLog4j.log("::::::Exception in Z_EZ_GET_VENDOR_UPDATE::::::"+e,"E");
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
	if(!errorOccured)
	{	
		mainParams	= new ezc.ezparam.EzcParams(false);
		miscParams = new EziMiscParams(); 
		
		if(mobile==null || "null".equals(mobile.trim()) || "".equals(mobile.trim()))
		{
			miscParams.setQuery("update ezc_vend_general_data set EVGD_EMAIL ='"+email+"' where EVGD_VENDOR='"+vendUser+"' and EVGD_STATUS='OPEN'");
		}
		else if(email==null || "null".equals(email.trim()) || "".equals(email.trim()))
		{
			miscParams.setQuery("update ezc_vend_general_data set EVGD_MOBILE='"+mobile+"' where EVGD_VENDOR='"+vendUser+"' and EVGD_STATUS='OPEN'");
		}
		else
		miscParams.setQuery("update ezc_vend_general_data set EVGD_MOBILE='"+mobile+"' , EVGD_EMAIL ='"+email+"' where EVGD_VENDOR='"+vendUser+"' and EVGD_STATUS='OPEN'");
		mainParams.setLocalStore("Y");
		mainParams.setObject(miscParams);
		Session.prepareParams(mainParams);
		try
		{		
			miscManager.ezUpdate(mainParams);
		}
		catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Employee List in iGetEmpListForMgr.jsp:::::"+e,"I");}	

		mainParams	= new ezc.ezparam.EzcParams(false);
		miscParams = new EziMiscParams(); 
		if(mobile==null || "null".equals(mobile.trim())|| "".equals(mobile.trim()))
		{
			miscParams.setQuery("update ezc_users set EU_EMAIL ='"+email+"' where EU_ID='"+vendUser+"'");
		}
		else if(email==null || "null".equals(email.trim()) || "".equals(email.trim()))
		{
			miscParams.setQuery("update ezc_users set EU_CONTACT_NO='"+mobile+"' where EU_ID='"+vendUser+"'");
		}
		else
		miscParams.setQuery("update ezc_users set EU_CONTACT_NO='"+mobile+"', EU_EMAIL ='"+email+"' where EU_ID='"+vendUser+"'");
		mainParams.setLocalStore("Y");
		mainParams.setObject(miscParams);
		Session.prepareParams(mainParams);
		try
		{		
			miscManager.ezUpdate(mainParams);
		}
		catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Employee List in iGetEmpListForMgr.jsp:::::"+e,"I");}
	}
	
%>
<%	
	response.sendRedirect("ezWelcome_New.jsp");  
%>	