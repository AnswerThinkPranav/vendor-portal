<%@ page import = "ezc.ezparam.*" %>
<%@ page import = "ezc.client.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "ezc.session.EzLogonStructure" %>
<%@ page import = "ezc.ezparam.EzLogonStatus" %>
<%@ page import = "ezc.ezparam.EzExecReportParams" %>
<%@ page import="ezc.ezparam.*" %>
<%@ page import="ezc.ezparam.ReturnObjFromRetrieve" %>


<jsp:useBean id="UserManager" class="ezc.client.EzUserAdminManager" />

<% 
	String purOrg = "";
	String colRfq = collNo;
	
	
	
	
	ezc.client.EzSystemConfigManager esManager = new ezc.client.EzSystemConfigManager();
	ezc.ezparam.EzcSysConfigParams sparams1 = new ezc.ezparam.EzcSysConfigParams();
	ezc.ezparam.EzcSysConfigNKParams snkparams1 = new ezc.ezparam.EzcSysConfigNKParams();
	snkparams1.setLanguage("EN");
	snkparams1.setSystemKey((String)session.getValue("SYSKEY"));
	snkparams1.setSiteNumber(200);
	sparams1.setObject(snkparams1);
	Session.prepareParams(sparams1);
	ezc.ezparam.ReturnObjFromRetrieve retdef = (ezc.ezparam.ReturnObjFromRetrieve)esManager.getCatAreaDefaults(sparams1);	
	
	
	
	
	if(retdef != null)
	{
		
		for(int i=0;i<retdef.getRowCount();i++)
		{
			if("PURORG".equals(retdef.getFieldValueString(i,"ECAD_KEY")))
			{
				purOrg=retdef.getFieldValueString(i,"ECAD_VALUE");
				break;
			}
		}
	}	
	
	ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate();

	String plant = request.getParameter("plant");
	String vendor= (String) session.getValue("SOLDTO");
	String fromDate = request.getParameter("fromDate");
	String toDate = request.getParameter("toDate");
	

	//-------------REPORT PARAMS----------------------
	EzReportInfoStructure repInfo = new EzReportInfoStructure();
	EzReportSelectTable repTable = new EzReportSelectTable();
	EzReportSelectRow repRow = null;

	EzReportTable selectTable = new EzReportTable();
	EzReportTableRow selectRow = null;

	EzReportHtmlTable outTable = null;

	EzExecReportParams repParams = null;

	EzExecReportParams in = new EzExecReportParams();
	EzReportManager rprtObj = new EzReportManager();

	ReturnObjFromRetrieve bexec=null;

	Session.prepareParams(in);
	//-------------END REPORT PARAMS----------------------

	// Get the input parameters
	String system = "999";
	String reportNo = "246";
	String reportName= "ZMPSR00_PRICE_COMPARISON"; 
	String reportDesc= "ZMPSR00_PRICE_COMPARISON";
	String reportType= "2";
	String exeType= "O";
	String visibility= "";
	String status= "";

	String execTC=request.getParameter("execTC");
	exeType=("A".equals(exeType))?execTC:exeType;


	String paramName[]= new String[2];
	String paramNo[]= new String[2];
	String paramType[]= new String[2];
	String paramDataType[]= new String[2];
	String paramMulti[]= new String[2];
	String lowValue[]= new String[2];
	String highValue[]= new String[2];
	String paramIsDef[]= new String[2];
	String paramMod[]= new String[2];
	String paramOpt[]= new String[2];



	paramName[0]="P_EKORG";
	paramNo[0]="1";
	paramType[0]="S";
	paramDataType[0]="C,,,,";
	paramMulti[0]="";
	lowValue[0]=purOrg;
	highValue[0]="";
	paramIsDef[0]="N";
	paramMod[0]="I";
	paramOpt[0]="EQ";
	
	
	
	paramName[1]="P_SUBMI";
	paramNo[1]="2";
	paramType[1]="S";
	paramDataType[1]="C,,,,";
	paramMulti[1]="";
	lowValue[1]=colRfq;
	highValue[1]="";
	paramIsDef[1]="N";
	paramMod[1]="I";
	paramOpt[1]="EQ";
	
	/*
	paramName[1]="P_EBELN";
	paramNo[1]="2";
	paramType[1]="S";
	paramDataType[1]="C,,,,";
	paramMulti[1]="";
	lowValue[1]=(String)rfqVector.get(0);
	highValue[1]=(rfqVector.size()>1)?(String)rfqVector.get(rfqVector.size()-1):"";
	paramIsDef[1]="N";
	paramMod[1]="I";
	paramOpt[1]=(rfqVector.size()>1)?"BT":"EQ";*/
	
	
	
	
	
	StringTokenizer st = null;
	StringTokenizer st1 = null;
	StringTokenizer st2 = null;
	StringTokenizer st3 = null;
	StringTokenizer st4 = null;

	String low,operator,mode,high="";

	try
	{
		String yr,mn,dt="";
		for(int i=0;i<paramName.length;i++)
		{


			st=new StringTokenizer(paramMulti[i],"");
			String valColumns[]=new String[st.countTokens()];
			int j=0;
			while(st.hasMoreTokens())
			{
				valColumns[j]=st.nextToken();
				j++;
			}
			try
			{

				for(int k=0;k<valColumns.length;k++) //for no of columns in each line
				{
					st1=new StringTokenizer(valColumns[0],"");
					st2=new StringTokenizer(valColumns[1],"");
					st3=new StringTokenizer(valColumns[2],"");
					st4=new StringTokenizer(valColumns[3],"");
				}
				while(st1.hasMoreTokens())
				{
					low=st1.nextToken();
					try{
						high=st2.nextToken();
					}catch(Exception e){high="";}
					try
					{
						mode=st3.nextToken();
					}catch(Exception e){mode="I";}
					try{
					operator=st4.nextToken();
					}catch(Exception e){operator="EQ";}

					high=("N".equals(high))?"":high;

					if(!"N".equals(low))
					{
						selectRow = new EzReportTableRow();
						if("DATS".equals(paramDataType[i]))
						{
							try{
							// Set values for low if date
							 mn = low.substring(0,2);
							 dt = low.substring(3,5);
							 yr = low.substring(6,10);
							low=yr+mn+dt;
							}catch(Exception e){out.println(e);}
							if(high.trim().length() == 10)
							{
								try{
								// Set values for high if date
								mn = high.substring(0,2);
								dt = high.substring(3,5);
								yr = high.substring(6,10);
								high=yr+mn+dt;
								}catch(Exception e){out.println(e);}
							}

						}
						mode=("".equals(mode) || "N".equals(mode))?"I":mode;
						operator=("".equals(operator) || "N".equals(operator))?"EQ":operator;
						selectRow.setSelname(paramName[i]);
						selectRow.setLow(low);
						selectRow.setHigh(high);
						selectRow.setKind(paramType[i]);
						selectRow.setOption(mode);
						selectRow.setSign(operator);

						selectTable.appendRow(selectRow);
						selectRow = null;
					}
				}
			}catch(Exception e){}

			if(lowValue[i].trim().length()!=0 &&  !"".equals(lowValue[i]))
			{
				highValue[i]=("".equals(highValue[i]))?"":highValue[i];
				///out.println("paramIsDef[i]"+paramIsDef[i]);
				if("Y".equals(paramIsDef[i]))
				{
					////out.println("lowValue[i]"+lowValue[i]);
					st1=new StringTokenizer(lowValue[i],",");
					String wast="";
					while(st1.hasMoreTokens())
					{
						wast=st1.nextToken();
						if(wast.trim().length()!=0)
						{
							selectRow = new EzReportTableRow();

							selectRow.setSelname(paramName[i]);
							selectRow.setLow(wast);
							selectRow.setHigh(highValue[i]);
							selectRow.setKind(paramType[i]);
							selectRow.setOption("I");
							selectRow.setSign("EQ");

							selectTable.appendRow(selectRow);
							selectRow = null;
						}
					}

				}else
				{

					if("D,,,,".equals(paramDataType[i]))
					{
						try{

							// Set values for low if date
							mn = lowValue[i].substring(0,2);
							dt = lowValue[i].substring(3,5);
							yr = lowValue[i].substring(6,10);
							lowValue[i]=yr+mn+dt;
						}catch(Exception e){}
						//if(high.trim().length() == 10)
						{
							try{
								// Set values for high if date
								mn = highValue[i].substring(0,2);
								dt = highValue[i].substring(3,5);
								yr = highValue[i].substring(6,10);
								highValue[i]=yr+mn+dt;
							}catch(Exception e){out.println(e);}

						}
					}
					paramMod[i]=("".equals(paramMod[i]) || "N".equals(paramMod[i]))?"I":paramMod[i];
					paramOpt[i]=("".equals(paramOpt[i]) || "N".equals(paramOpt[i]))?"EQ":paramOpt[i];


					selectRow = new EzReportTableRow();

					selectRow.setSelname(paramName[i]);
					selectRow.setLow(lowValue[i]);
					selectRow.setHigh(highValue[i]);
					selectRow.setKind(paramType[i]);
					selectRow.setOption(paramOpt[i]);
					selectRow.setSign(paramMod[i]);
					selectTable.appendRow(selectRow);
					selectRow = null;
				}

			}

		}

		if("B".equals(exeType))
		{
			java.util.Date current = new java.util.Date();
			//ezc.ezutil.FormatDate fd= new ezc.ezutil.FormatDate();
			String dat = fd.getStringFromDate(current,"/",ezc.ezutil.FormatDate.DDMMYYYY);
			java.text.SimpleDateFormat sdf =new java.text.SimpleDateFormat("HH:mm:ss");

			String email ="";


			ReturnObjFromRetrieve retUserData = null;
			EzcUserParams uparams= new EzcUserParams();

			uparams.setUserId(Session.getUserId());
			EzcUserNKParams ezcUserNKParams = new EzcUserNKParams();
			ezcUserNKParams.setLanguage("EN");
			uparams.createContainer();
			uparams.setObject(ezcUserNKParams);
			Session.prepareParams(uparams);
			try{
			retUserData = (ReturnObjFromRetrieve)UserManager.getUserData(uparams);
			retUserData.check();
			email = retUserData.getFieldValueString(0,"EU_EMAIL");
			}catch(Exception e){}

			selectRow = new EzReportTableRow();
			selectRow.setSelname("");
			selectRow.setLow("EZ_LIST_TITLE");
			selectRow.setHigh(reportName+Session.getUserId()+dat);
			selectRow.setKind("S");
			selectRow.setOption("");
			selectRow.setSign("");


			selectTable.appendRow(selectRow);
			selectRow = null;

			EzReportParams ezreportparams= new EzReportParams();

			EzReportExecStoreStructure exestore = new EzReportExecStoreStructure();
			exestore.setReportNo(reportNo);
			exestore.setSystemNo(system);
			///in.setCounter();
			exestore.setSpoolNo(" ");
			exestore.setUserId(Session.getUserId());
			exestore.setCreationDate(dat);
			exestore.setCreationTime(sdf.format(current));
			exestore.setReportPath(" ");
			exestore.setViewFlag("N");
			exestore.setEmail(email);
			exestore.setReportFormat(" ");
			exestore.setExt1(" ");
			exestore.setExt2(" ");

			ezreportparams.setReportExecStore(exestore);
			in.setReportParams(ezreportparams);
		}

		in.setIsWithCustomer(false);
		in.setReportName(reportName);
		in.setSelTable(selectTable);
		in.setSystemNo(system);
		in.setSysNum(system);	// for fill call
		in.setExecutionType(exeType);


		if("B".equals(exeType))
		{
			bexec =(ReturnObjFromRetrieve)rprtObj.executeReport(in);
		}else
		{
			outTable  = (EzReportHtmlTable) rprtObj.executeReport(in);

		}

	}
	catch(Exception e)
	{
	
		e.printStackTrace();
	}

%>
