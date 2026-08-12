<%@ page import ="ezc.ezparam.*,ezc.ezsap.*" %>
<%@ page import="com.sap.mw.jco.*,java.util.*,javax.swing.*,java.awt.*" %>
<%@ page import ="ezc.sapconnection.*" %>

<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%!
	/*public static String replaceString(String theString,String from,String to)
	{
		  int go=0;
		  String ret=theString;
		  while (ret.indexOf(from,go)>0)
		  {
			   go=ret.indexOf(from,go);
			   ret=ret.substring(0,go)+to+ret.substring(go+from.length());
			   go=go+to.length();
		  }
		  return ret;
	} */
%>

<%	
	String syskey 		= (String)session.getValue("SYSKEY");
	String CollectiveRFQNo  = request.getParameter("CollectiveRFQNo");
	String mat              = request.getParameter("material");
	String purchReq[]	=request.getParameterValues("purchReq");

	boolean withPlant=false;
	String PRDocType="";
	
	JCO.Client client	= EzSAPHandler.getSAPConnection("200~999");
	JCO.Function function	= EzSAPHandler.getFunction("RFC_READ_TEXT","200~999");
				
	JCO.Table textLines     = function.getTableParameterList().getTable("TEXT_LINES");
	
	for(int i=0;i<purchReq.length;i++)
	{
		
		java.util.StringTokenizer st2 =new java.util.StringTokenizer(purchReq[i],"$$");

		try{

			String matCode 	 = st2.nextToken();
			String plantCode = st2.nextToken();
			String delDate   = st2.nextToken();
			String qty 	 = st2.nextToken();
			String uom	 = st2.nextToken();
			String matDesc 	 = st2.nextToken();
			String reqNo   	 = st2.nextToken();
			String itmNo   	 = st2.nextToken();

			if(matCode!=null && "SERVICE".equals(matCode.trim()))
			PRDocType="SERVICE";

			if(!"NA".equals(plantCode))
			withPlant=true;
			
			String reqNoTemp = "0000000000"+reqNo;
			reqNoTemp	 = reqNoTemp.substring(reqNoTemp.length()-10,reqNoTemp.length());
			String itmNoTemp = "00000"+itmNo;
			itmNoTemp	 = itmNoTemp.substring(itmNoTemp.length()-5,itmNoTemp.length());

			textLines.appendRow();
			textLines.setValue("EBAN","TDOBJECT");
			textLines.setValue((reqNoTemp+itmNoTemp),"TDNAME");
			textLines.setValue("B02","TDID");
			textLines.setValue("EN","TDSPRAS");


		}catch(Exception e){ezc.ezcommon.EzLog4j.log("===============>"+e,"I");}
				
	}
	String fields []= {"TDOBJECT","TDNAME","TDID","TDLINE","TDFORMAT"};
	ReturnObjFromRetrieve retItemNote = new ReturnObjFromRetrieve(fields);
	Hashtable itemNoteHash=new Hashtable();
	Vector itemNoteVect=new Vector();
	String prItemStr = "",prItemNoteStr = "";

	try{
		client.execute(function);

		JCO.Table ret = function.getTableParameterList().getTable("TEXT_LINES");
		int retCount = ret.getNumRows();
		if(retCount>0)
		{
			do
			{
				prItemStr = (String)ret.getValue("TDNAME");
				if(itemNoteVect.contains(prItemStr))
				{
					prItemNoteStr =  (String)itemNoteHash.get(prItemStr);
					prItemNoteStr += (String)ret.getValue("TDLINE");
					itemNoteHash.put(prItemStr,prItemNoteStr); 
				}else{
					itemNoteVect.addElement(prItemStr);
					itemNoteHash.put(prItemStr,(String)ret.getValue("TDLINE"));
				}



				/*retItemNote.setFieldValue("TDOBJECT",ret.getValue("TDOBJECT"));
				retItemNote.setFieldValue("TDNAME",ret.getValue("TDNAME"));
				retItemNote.setFieldValue("TDID",ret.getValue("TDID"));
				retItemNote.setFieldValue("TDLINE",ret.getValue("TDLINE"));
				retItemNote.setFieldValue("TDFORMAT",ret.getValue("TDFORMAT"));
				retItemNote.addRow();*/

			}
			while(ret.nextRow());
		}
	}catch(Exception e){
		out.println(e);
		e.printStackTrace();
	}finally{
		ezc.ezcommon.EzLog4j.log(":::::::releaseClient:::::","I");

		JCO.releaseClient(client);
		client = null;
		function=null;
	}
		

	String soldTos = "";
	if(request.getParameter("soldTos") != null)
	{
		soldTos = request.getParameter("soldTos");
		soldTos = replaceString(soldTos,",","','");	
	}	
//out.println("::::::::::soldTos::::::::"+soldTos);
	ezc.ezpreprocurement.client.EzPreProcurementManager ezrfqmanager 	= new ezc.ezpreprocurement.client.EzPreProcurementManager();
	ezc.ezparam.EzcParams ezcparams				     		= new ezc.ezparam.EzcParams(false);
	ezc.ezpreprocurement.params.EziRFQHeaderParams ezirfqheaderparams 	= new ezc.ezpreprocurement.params.EziRFQHeaderParams();
	ezc.ezparam.ReturnObjFromRetrieve myRet = null;
	
	ezirfqheaderparams.setExt1("CRM");
	if(soldTos != null)
	{
		ezirfqheaderparams.setExt2(mat);	
		ezirfqheaderparams.setSoldTo(soldTos);
		ezirfqheaderparams.setSysKey(syskey);
	}
	else 
		ezirfqheaderparams.setExt2(mat);

	ezcparams.setObject(ezirfqheaderparams);
	ezcparams.setLocalStore("Y");
	Session.prepareParams(ezcparams);
	try
	{
		myRet = (ezc.ezparam.ReturnObjFromRetrieve)ezrfqmanager.ezGetRFQList(ezcparams);	
		myRet.sort(new String[]{"COLLECTIVE_RFQ_NO"},false);
	}
	catch(Exception e)
	{
		System.out.println("Exception Occured while getting QCFs List:"+e);
	}
%>	