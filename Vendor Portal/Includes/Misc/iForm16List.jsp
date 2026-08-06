<%@ page import="java.util.*,java.io.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" />
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*,ezc.ezcommon.*,ezc.ezutil.*" %>

<%

 				
	String sYear 		=	request.getParameter("sYear");
	String sQtr 		=	request.getParameter("sQtr");
	String userID		=	(String)session.getValue("SOLDTOS");
	ArrayList venForm16Docs	=	new ArrayList();
	int venForm16DocsCnt	=	0;
	
	if(sYear==null||"null".equals(sYear.trim()))sYear="2012";
	if(sQtr==null||"null".equals(sQtr.trim()))sQtr="Q1";
		
		
	ezc.ezparam.EzcParams mainParams	= new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams 		= new EziMiscParams();
	ReturnObjFromRetrieve venPanSectRet	= null;

	miscParams.setQuery("SELECT * FROM EZC_VENDOR_PAN_SECTIONS WHERE EVPS_VENDOR='"+userID+"'");
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscParams);
	Session.prepareParams(mainParams);

	try{
		venPanSectRet =  (ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);
	}catch(Exception e){ezc.ezcommon.EzLog4j.log(":::::::::::Error occured while getting vendor pan nunber in iForm16List.jsp:::::::::::"+e,"I");}
	
	//out.println(venPanSectRet.toEzcString());
	if(venPanSectRet!=null && venPanSectRet.getRowCount()>0)
	{
		String filePath		= "E:\\TDS_VIKRETA\\"+sYear+"\\"+sQtr+"\\";
		for(int i=0;i<venPanSectRet.getRowCount();i++)
		{
			String venSections	=	venPanSectRet.getFieldValueString(i,"EVPS_SECTIONS");
			String venPan		=	venPanSectRet.getFieldValueString(i,"EVPS_PAN_NO");
		
			File file 		= 	new File((filePath+venSections));
			
			if (file.exists())
			{
				
				File[] filesList = file.listFiles();   
				for (int j=0;j<filesList.length;j++)
				{   
					String fileName	 = filesList[j].getName();
					if(fileName.indexOf(venPan)>=0)
					venForm16Docs.add(fileName+"¥"+venSections);
					
				}	
								//out.println(venForm16Docs+"*****************");

			}
		}	
	}
	
	
	if(venForm16Docs!=null)
	venForm16DocsCnt = venForm16Docs.size();
	
%>