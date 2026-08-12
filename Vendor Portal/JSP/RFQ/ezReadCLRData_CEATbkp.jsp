<%@ include file="../Misc/ezVendHeader.jsp"%>  
<%@ page import="ezc.ezutil.*" %>
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<%@ page import = "java.io.*,java.util.*,java.math.*,java.text.SimpleDateFormat,java.text.ParseException, javax.servlet.*,org.apache.poi.hssf.usermodel.*,org.apache.poi.ss.usermodel.*,org.apache.poi.xssf.usermodel.*" %>
<%@ page import ="ezc.sapconnection.*,com.sap.mw.jco.*,com.sap.mw.jco.JCO" %>
<%@ page import = "javax.servlet.http.*" %>
<%@ page import = "org.apache.commons.fileupload.*" %>
<%@ page import = "org.apache.commons.fileupload.disk.*" %>
<%@ page import = "org.apache.commons.fileupload.servlet.*" %>
<%@ page import = "org.apache.commons.io.output.*" %>  
<%!	

	public String checkNull(String value)   
	{ 
		if(value==null || "null".equals(value.trim()))value="";  
		return value.trim(); 
	}
	public String convertDateObjToStringForm(java.util.Date inputDate)
	{
		java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd-MM-yyyy");
		String stringObj = "";
		try {
			stringObj = sdf.format(inputDate);

		} catch (Exception e) {

		}
		return stringObj;

	}
	public String getCellValue(String fileExt,Iterator cellIter) 
	{
		String celValue = "";
		if(cellIter.hasNext())
		{
			if("xlsx".equals(fileExt))
			{
					XSSFCell myCellX = (XSSFCell) cellIter.next();
					
					if(myCellX.getCellTypeEnum() == CellType.NUMERIC) 
					{
							celValue=new BigDecimal(myCellX.getNumericCellValue())+"";
							//System.out.print("Integer:::"+celValue);
					}
					else if(myCellX.getCellTypeEnum() == CellType.STRING) 
					{
							celValue=myCellX.getStringCellValue()+"";
							//System.out.print("String:::"+celValue);
					}
					else
					{
							celValue=myCellX.getStringCellValue()+"";
					}
			}
			else
			{ 
					HSSFCell myCellH = (HSSFCell) cellIter.next();
					
					if(myCellH.getCellTypeEnum() == CellType.NUMERIC) 
					{
							celValue=myCellH.getNumericCellValue()+"";
							//System.out.print("Integer:::"+celValue);
					}
					else if(myCellH.getCellTypeEnum() == CellType.STRING) 
					{
							celValue=myCellH.getStringCellValue()+"";
							//System.out.print("String:::"+celValue);
					}else{
							celValue=myCellH.getStringCellValue()+"";
					}
			}
			if(celValue == null || "null".equals(celValue.trim()) || "".equals(celValue.trim()))
					celValue ="";
		} 
		return celValue;
	}
	public String getCellValue2(String fileExt,Iterator cellIter) 
	{
		String celValue = "";
		DataFormatter formatter = new DataFormatter();
		if(cellIter.hasNext())
		{
			if("xlsx".equals(fileExt))
			{
					XSSFCell myCellX = (XSSFCell) cellIter.next();

					
					celValue=formatter.formatCellValue(myCellX);
					
					
			}
			else
			{ 
					HSSFCell myCellH = (HSSFCell) cellIter.next();

					celValue=formatter.formatCellValue(myCellH);
					
			}
			if(celValue == null || "null".equals(celValue.trim()) || "".equals(celValue.trim()))
					celValue ="";
		} 
		return celValue;
	}

	public ReturnObjFromRetrieve readExcel(InputStream uploadedInputStream,String fileExt,Hashtable<String,String> htHeaderCol)
	{
			XSSFWorkbook wbX        = null;
			HSSFWorkbook wbH       = null;
			HSSFSheet mySheetH    = null;
			XSSFSheet mySheetX     = null;
			Iterator rowIter = null;
			//String fileExt       = "xlsx";
			String vendNum="";
			ReturnObjFromRetrieve retObj= new ReturnObjFromRetrieve();
				
			try {
					if("xlsx".equals(fileExt))
					{
						wbX                = new XSSFWorkbook(uploadedInputStream);
						mySheetX           = wbX.getSheetAt(0);
						rowIter 	   = mySheetX.rowIterator();		
					}
					else
					{
						wbH                = new HSSFWorkbook(uploadedInputStream);
						mySheetH           = wbH.getSheetAt(0);
						rowIter 	   = mySheetH.rowIterator();		
					}
							

			} catch (Exception e) {
					e.printStackTrace();
			}
			
			int firstRow=0;
			int colNo=0;
			int noOfCols = 0;
			try{
					HSSFRow myRowH          = null;
					XSSFRow myRowX           = null;
					DataFormatter df = new DataFormatter();
					while (rowIter.hasNext()) 
					{
							if("xlsx".equals(fileExt))
									myRowX              = (XSSFRow) rowIter.next();
							else
									myRowH              = (HSSFRow) rowIter.next();
							
							
							Iterator cellIter = null;
							if("xlsx".equals(fileExt))
									cellIter = myRowX.cellIterator();
							else
									cellIter = myRowH.cellIterator();
							
							
							
							if(firstRow==0)
							{



									boolean endLoop = true;
									while(endLoop)
									{
											String colName = getCellValue(fileExt,cellIter);
											ezc.ezcommon.EzLog4j.log("COLNAME>>>>>>>>>>"+colName,"I"); 
											if(colName != null && !"".equals(colName))
											{
													colName = colName.trim();
													colName = colName.toUpperCase();
													ezc.ezcommon.EzLog4j.log("COLNAME-OLD>>>>>>"+colName,"I"); 
													ezc.ezcommon.EzLog4j.log("COLNAME-NEW>>>>>>>"+htHeaderCol.get(colName),"I"); 
													if(htHeaderCol.containsKey(colName))
														colName = htHeaderCol.get(colName);
													
													retObj.addColumn(colName);
													noOfCols++;
											}
											else{
													endLoop=false;
											}
									}


									firstRow++;
							}
							else
							{	ezc.ezcommon.EzLog4j.log("noOfCols>>>>>>>>"+noOfCols,"I");	
									for(int i=0;i<noOfCols;i++)
									{
											
											String colValue = "";//getCellValue(fileExt,cellIter);
											if("xlsx".equals(fileExt))
											{
													XSSFCell myCellX = (XSSFCell) myRowX.getCell(i);
													
													if(myCellX != null)
													{
															/*if(myCellX.getCellTypeEnum() == CellType.NUMERIC) 
															{
																	colValue=new BigDecimal(myCellX.getNumericCellValue())+"";
																	System.out.print("Integer:::"+colValue);
															}
															else if(myCellX.getCellTypeEnum() == CellType.STRING) 
															{
																	colValue=myCellX.getStringCellValue()+"";
																	System.out.print("String:::"+colValue);
															}
															else */
															if(myCellX.getCellTypeEnum() == CellType.NUMERIC) 
															{
																if(DateUtil.isCellDateFormatted(myCellX))
																{

																	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
																	colValue =  sdf.format(myCellX.getDateCellValue());
																	ezc.ezcommon.EzLog4j.log("COLVALUE>>>>>>>>>>>>"+colValue+"<<index>2>"+i,"I"); 

																}
																else
																{
																	colValue= df.formatCellValue(myCellX);//myCellX.getStringCellValue()+"";
																}
															}
															else
															{
																	colValue= df.formatCellValue(myCellX);//myCellX.getStringCellValue()+"";
															}
													}

											}
											else
											{
													HSSFCell myCellH = (HSSFCell) myRowH.getCell(i);
													ezc.ezcommon.EzLog4j.log("myCellH value>>>>>>>>>>>>"+myCellH+"<<index>>>"+i,"I"); 
													if(myCellH != null)
													{
															/*if(myCellH.getCellTypeEnum() == CellType.NUMERIC) 
															{
																	colValue=myCellH.getNumericCellValue()+"";

																	System.out.print("Integer:::"+colValue);
															}
															else if(myCellH.getCellTypeEnum() == CellType.STRING) 
															{
																	colValue=myCellH.getStringCellValue()+"";
																	System.out.print("String:::"+colValue);
															}
															else */
															
															if(myCellH.getCellTypeEnum() == CellType.NUMERIC) 
															{
																if(HSSFDateUtil.isCellDateFormatted(myCellH))
																{
																	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
																	colValue =  sdf.format(myCellH.getDateCellValue());

																}
																else
																{
																	colValue=df.formatCellValue(myCellH);//myCellH.getStringCellValue()+"";
																}
															}
															else
															{
																	colValue=df.formatCellValue(myCellH);//myCellH.getStringCellValue()+"";
															}
													}
													
											}
											try{
											retObj.setFieldValue(i, colValue);
											}catch(Exception e){ezc.ezcommon.EzLog4j.log("Exception>>>>>>>>>>"+e,"I");}
											
											
											
									}
									
									
									retObj.addRow();
									ezc.ezcommon.EzLog4j.log("row added>>>>>>>>>>>>"+retObj.toEzcString(),"I");

							}
							
							
					}
			}
			catch(Exception Ex)
			{
					System.out.println(Ex+":::Exception:::"); 
			
			}
			finally
			{
					try
					{
							uploadedInputStream.close();
					}
					catch(Exception ex){}
			} 
			//out.println("::::retObj"+retObj.toEzcString());
			//ezc.ezcommon.EzLog4j.log("ret Obj>>>>>>>>>>"+retObj.toEzcString(),"I");
			return retObj;
	}

%> 

<%
	ReturnObjFromRetrieve retExcl = null;
	String isValidate = request.getParameter("isValidate");
	boolean showError = false;
	String errTabStr="",displayErrMsg="none",dispMsg="";
 
   Hashtable<String,String> htHeaderCol = new Hashtable<String,String>();
  						

 		 htHeaderCol.put("VENDOR_CODE","VENDOR_CODE"); 	
  		 htHeaderCol.put("DCA","DCA"); 
	  	 htHeaderCol.put("ETA","ETA"); 
	  	 htHeaderCol.put("NO_OF_DAYS_FROM_ETA","NO_OF_DAYS_FROM_ETA"); 
	  	 htHeaderCol.put("BOE_NO","BOE_NO"); 
	  	 htHeaderCol.put("BOE_DATE","BOE_DATE"); 
	  	 htHeaderCol.put("CRITICAL_DELIVERY","CRITICAL_DELIVERY"); 
	  	 htHeaderCol.put("MATERIAL_CODE","MATERIAL_CODE"); 
	  	 htHeaderCol.put("MATERIAL_DESC","MATERIAL_DESC"); 
	  	 htHeaderCol.put("QTY_SHIPPED","QTY_SHIPPED"); 
	  	 htHeaderCol.put("VALUATION_BY_BUYER","VALUATION_BY_BUYER"); 
	  	 htHeaderCol.put("VALUATION_TYPE","VALUATION_TYPE"); 
	  	 htHeaderCol.put("LINE_NO","LINE_NO"); 
	  	 htHeaderCol.put("CONT_NO","CONT_NO"); 
	  	 htHeaderCol.put("DISPATCH_PLANT","DISPATCH_PLANT"); 
	  	 htHeaderCol.put("PROP_DEL_DATE","PROP_DEL_DATE"); 
	  	 htHeaderCol.put("PLANNED_DEL_DATE","PLANNED_DEL_DATE"); 
	  	 htHeaderCol.put("TRANSPORTER","TRANSPORTER"); 
	  	 htHeaderCol.put("VEHICLE_TYPE","VEHICLE_TYPE"); 
	  	 htHeaderCol.put("PALLETS_NO","PALLETS_NO"); 
	  	 htHeaderCol.put("CHA","CHA"); 
	  	 htHeaderCol.put("DOCKET","DOCKET"); 
	  	 htHeaderCol.put("DUTY_INITIATION","DUTY_INITIATION"); 
	  	 htHeaderCol.put("EX_RATE","EX_RATE"); 
	  	 htHeaderCol.put("DUTY_AMT","DUTY_AMT"); 
	  	 htHeaderCol.put("OBL_BY_CHA","OBL_BY_CHA"); 
	  	 htHeaderCol.put("LIC_NO","LIC_NO"); 
	  	 htHeaderCol.put("PLANT","PLANT"); 
	  	 htHeaderCol.put("PO_NO","PO_NO"); 
	  	 htHeaderCol.put("RTP","RTP"); 
	  	 htHeaderCol.put("RTP_STATUS","RTP_STATUS"); 
	  	 htHeaderCol.put("FTA","FTA"); 
	  	 htHeaderCol.put("FTA_STATUS","FTA_STATUS"); 
	  	 htHeaderCol.put("DO_RECP","DO_RECP"); 
	  	 htHeaderCol.put("DUTY_PMNT_DATE","DUTY_PMNT_DATE"); 
	  	 htHeaderCol.put("EXAM_DATE","EXAM_DATE"); 
	  	 htHeaderCol.put("DLV_DATE","DLV_DATE"); 
	  	 htHeaderCol.put("DLV_FROM_BOND","DLV_FROM_BOND"); 
	  	 htHeaderCol.put("WH_BOE","WH_BOE"); 
	  	 htHeaderCol.put("WH_BOE_DATE","WH_BOE_DATE"); 
	  	 htHeaderCol.put("DO_VALID_DATE","DO_VALID_DATE"); 
	  	 htHeaderCol.put("REMARKS","REMARKS"); 
	  	 htHeaderCol.put("MANU_DATE","MANU_DATE"); 
	  	 htHeaderCol.put("SLED","SLED"); 
	  	 htHeaderCol.put("REM_FREE_DAYS","REM_FREE_DAYS");
	  	 htHeaderCol.put("PICK_UP_POINT","PICK_UP_POINT"); 
	  	 htHeaderCol.put("FINAL_DEL_DATE","FINAL_DEL_DATE"); 
	  	 htHeaderCol.put("INWARD_WH_DATE","INWARD_WH_DATE"); 
	  	 htHeaderCol.put("WH_PLANT","WH_PLANT"); 
	  	 htHeaderCol.put("DISP_CONF_BY_TRANS","DISP_CONF_BY_TRANS"); 
	  	 htHeaderCol.put("DISP_CONF_BY_CHA","DISP_CONF_BY_CHA"); 
	  	 htHeaderCol.put("LR_NO","LR_NO"); 
	  	 htHeaderCol.put("TRUCK_NO","TRUCK_NO"); 
	  	 htHeaderCol.put("POD","POD"); 
	  	 htHeaderCol.put("SHIPP_CO","SHIPP_CO"); 
	  	 htHeaderCol.put("BUYER","BUYER"); 
	  	 htHeaderCol.put("MIGO_103","MIGO_103"); 
	  	 htHeaderCol.put("MIGO_105","MIGO_105"); 
	  	 htHeaderCol.put("SAP_BATCH","SAP_BATCH"); 
	  	 htHeaderCol.put("STO","STO"); 
	  	 htHeaderCol.put("DO","DO"); 
	  	 htHeaderCol.put("TAX_INV","TAX_INV"); 
	  	 htHeaderCol.put("EMPTY_RETURN_DT","EMPTY_RETURN_DT"); 
	  	 htHeaderCol.put("INV_NO","INV_NO"); 
	  	 htHeaderCol.put("INV_DT","INV_DT"); 
	  	 htHeaderCol.put("BL_NO","BL_NO"); 
	  	 htHeaderCol.put("BL_DT","BL_DT"); 
	  	 htHeaderCol.put("PRICE","PRICE"); 
	  	 htHeaderCol.put("VALUE","VALUE"); 
	  	 htHeaderCol.put("COURIER_NO","COURIER_NO"); 
	  	 htHeaderCol.put("OBL_BY_BANK","OBL_BY_BANK"); 
	  	 htHeaderCol.put("BANK_NAME","BANK_NAME"); 
	  	 htHeaderCol.put("PRESENTATION_DT","PRESENTATION_DT"); 
	  	 htHeaderCol.put("ACCEPT_DT","ACCEPT_DT"); 
	  	 htHeaderCol.put("GR_RENT","GR_RENT"); 
	  	 htHeaderCol.put("DETENTION","DETENTION"); 
	  	 htHeaderCol.put("PENALTY","PENALTY"); 
	  	 htHeaderCol.put("COPQ_REC_STATUS","COPQ_REC_STATUS"); 
	  	 htHeaderCol.put("ASN","ASN"); 
	  	 htHeaderCol.put("ASN DT","ASN DT"); 
	 	
   
   File file ;
   int maxFileSize = 5000 * 1024;
   int maxMemSize = 5000 * 1024;
   ServletContext context = pageContext.getServletContext();
   String filePath = context.getInitParameter("file-upload");

   // Verify the content type
   String contentType = request.getContentType();
   ezc.ezcommon.EzLog4j.log(":::::::content type:::::::"+contentType,"I");    
	if("".equals(contentType) || "null".equals(contentType) || null == contentType)
	contentType ="";
   if ((contentType.indexOf("multipart/form-data") >= 0)) {
      DiskFileItemFactory factory = new DiskFileItemFactory(); 
      // maximum size that will be stored in memory
      factory.setSizeThreshold(maxMemSize);

      // Location to save data that is larger than maxMemSize.
      factory.setRepository(new File("c:\\temp"));

      // Create a new file upload handler
      ServletFileUpload upload = new ServletFileUpload(factory);

      // maximum file size to be uploaded.
      upload.setSizeMax( maxFileSize );

      try { 
	 // Parse the request to get file items.
	 List fileItems = upload.parseRequest(request);

	 // Process the uploaded file items
	 Iterator i = fileItems.iterator();



	 while ( i.hasNext () ) {
	    FileItem fi = (FileItem)i.next();
	    if ( !fi.isFormField () ) {
	       // Get the uploaded file parameters
	       String fieldName = fi.getFieldName();
	       String fileName = fi.getName(); 
	       boolean isInMemory = fi.isInMemory();
	       String fileExt = "";
	       int e = fieldName.lastIndexOf('.');
	       if (e > 0) {
		   fileExt = fieldName.substring(e+1);
		}
		//out.println(fieldName); 
	       long sizeInBytes = fi.getSize(); 
		retExcl = readExcel(fi.getInputStream(),fileExt,htHeaderCol);
		ezc.ezcommon.EzLog4j.log(":::::::ret excel:::::::"+retExcl.toEzcString(),"I"); 
	       //out.print(retExcl.toEzcString());
	    }
	 }

      } catch(Exception ex) {
	 System.out.println(ex);
      }
   } else { 

   }
   int maxCommId = 9000;
   String maxCnt="";
  /*************************GET MAX ID FOR CLRDAHBOARD**********************************/
	ReturnObjFromRetrieve  shipRet=null;
	ezc.ezparam.EzcParams mainParamsCRT = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgrCRT = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTableCRT = new ezc.misctransactions.params.EzMiscTable();

	ezc.misctransactions.params.EzMiscTableRow miscTableRowCRT = new ezc.misctransactions.params.EzMiscTableRow();
	miscTableRowCRT.setQuery("SELECT MAX(ECD_SHID) AS MAXID FROM EZC_CLR_DASHBOARD WHERE ECD_EXT1='FROMXL'");
	miscTableCRT.appendRow(miscTableRowCRT);	
	mainParamsCRT.setLocalStore("Y");
	mainParamsCRT.setObject(miscTableCRT);
	Session.prepareParams(mainParamsCRT);
	try
	{
	shipRet=(ReturnObjFromRetrieve)miscMgrCRT.ezGetMiscTransactions(mainParamsCRT);

	}
	catch(Exception e)
	{
	ezc.ezcommon.EzLog4j.log("::Exception:while getting data:"+e,"E");
	}
	if(shipRet!=null && shipRet.getRowCount()>0)
	{
		maxCnt=checkNull(shipRet.getFieldValueString(0,"MAXID"));
		
		ezc.ezcommon.EzLog4j.log("::maxCnt:"+maxCnt,"I");
		if("".equals(maxCnt))maxCnt="9000";
		else
		maxCommId = Integer.parseInt(maxCnt)+1;
	}
	else
	{
		maxCommId=9000;

	}	
/*********************************************************************************************/	
   Hashtable vendHt=new Hashtable();
   if(retExcl!=null)
   {
   	for(int i=0;i<retExcl.getRowCount();i++)
   	{
   		String vend		=checkNull(retExcl.getFieldValueString(i,"VENDOR_CODE")); 
   		String invNO		=checkNull(retExcl.getFieldValueString(i,"INV_NO")); 
   		
   		if(i==0)
   			vendHt.put(vend+"#"+invNO,maxCommId);
   		else
   		{
   			if(vendHt.containsKey(vend+"#"+invNO))
   				vendHt.put(vend+"#"+invNO,maxCommId);
   			else
   			{
   				maxCommId=maxCommId+1;
   				vendHt.put(vend+"#"+invNO,maxCommId);
   			
   			}
   			
   		
   		
   		}
   	
   	}
   	ezc.ezcommon.EzLog4j.log(":::::::vendHt:::::::"+vendHt,"I");
   
   }
   
   
//out.println("vendHt"+vendHt);	
%>


<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
<!-- Content Header (Page header) --> 
<section class="content-header">
   <h1>
      Add CLR Dashboard
   </h1>
</section>
<!-- Main content -->  
<section class="content">
<form name="myForm" id="formID" method="post" >
<input type="hidden" name="isValidate" value="N">
<%
	
	
	if(retExcl!=null && retExcl.getRowCount()>0)
	{
	ezc.ezcommon.EzLog4j.log(":::::::retExcl>>:::::::"+retExcl.toEzcString(),"I");
	ezc.ezcommon.EzLog4j.log(":::::::retExcl>>:::::::"+retExcl.getRowCount(),"I");
%>
   <div class="row">
   <!-- left column -->
   <div class="col-md-12 col-xs-12">
   <!-- general form elements -->
  <div class="box box-default">
  <div class="box-body table-responsive no-padding">
  <div class="box-body">
  
  <div style="Height: 460px;overflow: scroll;">
  	<table id="example" class="table table-bordered" >
	<thead>
		<tr>
			<th>VENDOR_CODE</th>
			<th>DCA</th>
			<th>ETA</th>
			<th>NO_OF_DAYS_FROM_ETA</th>
			<th>BOE_NO</th>
			<th>BOE_DATE</th>
			<th>CRITICAL_DELIVERY</th>
			<th>MATERIAL_CODE</th>
			<th>MATERIAL_DESC</th>
			<th>QTY_SHIPPED</th>
			<th>VALUATION_BY_BUYER</th>
			<th>VALUATION_TYPE</th>
			<th>LINE_NO</th>
			<th>CONT_NO</th>
			<th>DISPATCH_PLANT</th>
			<th>PROP_DEL_DATE</th>
			<th>PLANNED_DEL_DATE</th>
			<th>TRANSPORTER</th>
			<th>VEHICLE_TYPE</th>
			<th>PALLETS_NO</th>
			<th>CHA</th>
			<th>DOCKET</th>
			<th>DUTY_INITIATION</th>
			<th>EX_RATE</th>
			<th>DUTY_AMT</th>
			<th>OBL_BY_CHA</th>
			<th>LIC_NO</th>
			<th>PLANT</th>
			<th>PO_NO</th>
			<th>RTP</th>
			<th>RTP_STATUS</th>
			<th>FTA</th>
			<th>FTA_STATUS</th>
			<th>DO_RECP</th>
			<th>DUTY_PMNT_DATE</th>
			<th>EXAM_DATE</th>
			<th>DLV_DATE</th>
			<th>DLV_FROM_BOND</th>
			<th>WH_BOE</th>
			<th>WH_BOE_DATE</th>
			<th>DO_VALID_DATE</th>
			<th>REMARKS</th>
			<th>MANU_DATE</th>
			<th>SLED</th>
			<th>REM_FREE_DAYS</th>
			<th>PICK_UP_POINT</th>
			<th>FINAL_DEL_DATE</th>
			<th>INWARD_WH_DATE</th>
			<th>WH_PLANT</th>
			<th>DISP_CONF_BY_TRANS</th>
			<th>DISP_CONF_BY_CHA</th>
			<th>LR_NO</th>
			<th>TRUCK_NO</th>
			<th>POD</th>
			<th>SHIPP_CO</th>
			<th>BUYER</th>
			<th>MIGO_103</th>
			<th>MIGO_105</th>
			<th>SAP_BATCH</th>
			<th>STO</th>
			<th>DO</th>
			<th>TAX_INV</th>
			<th>EMPTY_RETURN_DT</th>
			<th>INV_NO</th>
			<th>INV_DT</th>
			<th>BL_NO</th>
			<th>BL_DT</th>
			<th>PRICE</th>
			<th>VALUE</th>
			<th>COURIER_NO</th>
			<th>OBL_BY_BANK</th>
			<th>BANK_NAME</th>
			<th>PRESENTATION_DT</th>
			<th>ACCEPT_DT</th>
			<th>GR_RENT</th>
			<th>DETENTION</th>
			<th>PENALTY</th>
			<th>COPQ_REC_STATUS</th>    
			<th>ASN</th>
			<th>ASN DT</th>	
		</tr>
	</thead>
	<tbody> 
<% 
	//out.println("::::retObj"+retExcl.toEzcString());
	String ECD_SOLD_TO="",ECD_DCA="",ECD_NODAYSFROM_ETA="",ECD_BOE_NO="",ECD_CRT_DEL="",ECD_MAT_NR="",ECD_MAT_DESC="",ECD_QTY_SHIPPED="",ECD_BUY_VAL_TYPE="",ECD_VAL_TYPE="",ECD_LINE_NUM="",ECD_CONT_NUM="",ECD_DISP_PLANT="",ECD_TRANSPORTER="",ECD_VEHICLE_TYPE="",ECD_NO_OF_PALLETS="",ECD_CHA="",ECD_DOCKET="",ECD_EX_RATE="",ECD_DUTY_AMT="",ECD_LIC_NO="",ECD_PLANT="",ECD_PO_NUM="",ECD_RTP="",ECD_RTP_STAT="",ECD_FTA="",ECD_FTA_STAT="",ECD_WH_BOE_NO="",ECD_REMARKS="",ECD_LIC_TYPE="",ECD_MANU="",ECD_SLED_DT="",ECD_REM_FREE_DAYS="",ECD_PICK_UP_POINT="",ECD_WH_PLANT="",ECD_LR_NO="",ECD_TRUCK_NO="",ECD_POD="",ECD_SHIPPING_CO="",ECD_BUYER="",ECD_MIGO_103="",ECD_MIGO_105="",ECD_SAP_BATCH="",ECD_STO="",ECD_DO="",ECD_TAX_INV="",ECD_INV_NUM="",ECD_INV_DATE="",ECD_BL_NUM="",ECD_BL_DATE="",ECD_PRICE="",ECD_CIF_VALUE="",ECD_COUR_CO="",ECD_COUR_NO="",ECD_BANK_NAME="",ECD_PRESENTATION_DT="",ECD_ACCEPT_DT="",ECD_GR_RENT="",ECD_DETENTION="",ECD_PENALTY="",ECD_COPQ_REC_STAT="",ECD_SHID="",ECD_SHDT="";
	int SHID=0;
	SimpleDateFormat simpleDateFormat = new SimpleDateFormat("dd-MM-yyyy");
	Date date = new Date();
	String ECD_ETA="",ECD_BOE_DATE="",ECD_PROP_DEL_DT="",ECD_PLAN_DEL_DT="",ECD_DUTY_INIT="",ECD_OBL_BY_CHA="",ECD_DUTY_PAY_DT="",ECD_EXAM_DT="",ECD_DLV_DATE="",ECD_DLV_FROM_BOND_DT="",ECD_WH_BOE_DATE="",ECD_DO_VALID_DT="",ECD_DO_RECP_DT="",ECD_MANU_DT="",ECD_FINAL_DEL_DT="",ECD_INWARD_WH_DT="",ECD_DISP_CONF_BY_TRANS="",ECD_DISP_CONF_BY_CHA="",ECD_EMPTY_RET_DT="",ECD_OBL_BY_BANK="";
	for(int i=0; i<retExcl.getRowCount(); i++)
	{ 
	
		ECD_SOLD_TO				=checkNull(retExcl.getFieldValueString(i,"VENDOR_CODE"));
		ECD_DCA					=checkNull(retExcl.getFieldValueString(i,"DCA"));
		ECD_ETA					=checkNull(retExcl.getFieldValueString(i,"ETA"));
		ECD_NODAYSFROM_ETA 			=checkNull(retExcl.getFieldValueString(i,"NO_OF_DAYS_FROM_ETA"));
		ECD_BOE_NO  				=checkNull(retExcl.getFieldValueString(i,"BOE_NO"));
		ECD_BOE_DATE 				=checkNull(retExcl.getFieldValueString(i,"BOE_DATE"));
		ECD_CRT_DEL				=checkNull(retExcl.getFieldValueString(i,"CRITICAL_DELIVERY"));
		ECD_MAT_NR				=checkNull(retExcl.getFieldValueString(i,"MATERIAL_CODE"));
		ECD_MAT_DESC				=checkNull(retExcl.getFieldValueString(i,"MATERIAL_DESC"));
		ECD_QTY_SHIPPED				=checkNull(retExcl.getFieldValueString(i,"QTY_SHIPPED"));
		ECD_BUY_VAL_TYPE			=checkNull(retExcl.getFieldValueString(i,"VALUATION_BY_BUYER"));
		ECD_VAL_TYPE 				=checkNull(retExcl.getFieldValueString(i,"VALUATION_TYPE"));
		ECD_LINE_NUM				=checkNull(retExcl.getFieldValueString(i,"LINE_NO"));
		ECD_CONT_NUM				=checkNull(retExcl.getFieldValueString(i,"CONT_NO"));
		ECD_DISP_PLANT				=checkNull(retExcl.getFieldValueString(i,"DISPATCH_PLANT"));
		ECD_PROP_DEL_DT 			=checkNull(retExcl.getFieldValueString(i,"PROP_DEL_DATE"));
		ECD_PLAN_DEL_DT 			=checkNull(retExcl.getFieldValueString(i,"PLANNED_DEL_DATE"));
		ECD_TRANSPORTER 			=checkNull(retExcl.getFieldValueString(i,"TRANSPORTER"));
		ECD_VEHICLE_TYPE 			=checkNull(retExcl.getFieldValueString(i,"VEHICLE_TYPE"));
		ECD_NO_OF_PALLETS			=checkNull(retExcl.getFieldValueString(i,"PALLETS_NO"));
		ECD_CHA 				=checkNull(retExcl.getFieldValueString(i,"CHA"));
		ECD_DOCKET 				=checkNull(retExcl.getFieldValueString(i,"DOCKET"));	
		ECD_DUTY_INIT 				=checkNull(retExcl.getFieldValueString(i,"DUTY_INITIATION"));
		ECD_EX_RATE 				=checkNull(retExcl.getFieldValueString(i,"EX_RATE"));
		ECD_DUTY_AMT 				=checkNull(retExcl.getFieldValueString(i,"DUTY_AMT"));
		ECD_OBL_BY_CHA 				=checkNull(retExcl.getFieldValueString(i,"OBL_BY_CHA"));
		ECD_LIC_NO 				=checkNull(retExcl.getFieldValueString(i,"LIC_NO"));	
		ECD_PLANT				=checkNull(retExcl.getFieldValueString(i,"PLANT"));
		ECD_PO_NUM				=checkNull(retExcl.getFieldValueString(i,"PO_NO"));
		ECD_RTP					=checkNull(retExcl.getFieldValueString(i,"RTP"));
		ECD_RTP_STAT				=checkNull(retExcl.getFieldValueString(i,"RTP_STATUS"));
		ECD_FTA					=checkNull(retExcl.getFieldValueString(i,"FTA"));
		ECD_FTA_STAT				=checkNull(retExcl.getFieldValueString(i,"FTA_STATUS"));
		ECD_DO_RECP_DT 				=checkNull(retExcl.getFieldValueString(i,"DO_RECP"));
		ECD_DUTY_PAY_DT 			=checkNull(retExcl.getFieldValueString(i,"DUTY_PMNT_DATE"));
		ECD_EXAM_DT 				=checkNull(retExcl.getFieldValueString(i,"EXAM_DATE"));
		ECD_DLV_DATE				=checkNull(retExcl.getFieldValueString(i,"DLV_DATE"));
		ECD_DLV_FROM_BOND_DT			=checkNull(retExcl.getFieldValueString(i,"DLV_FROM_BOND"));
		ECD_WH_BOE_NO  				=checkNull(retExcl.getFieldValueString(i,"WH_BOE"));
		ECD_WH_BOE_DATE 			=checkNull(retExcl.getFieldValueString(i,"WH_BOE_DATE"));
		ECD_DO_VALID_DT				=checkNull(retExcl.getFieldValueString(i,"DO_VALID_DATE"));
		ECD_REMARKS 				=checkNull(retExcl.getFieldValueString(i,"REMARKS")); 		 
		ECD_MANU_DT 				=checkNull(retExcl.getFieldValueString(i,"MANU_DATE"));
		ECD_SLED_DT 				=checkNull(retExcl.getFieldValueString(i,"SLED"));
		ECD_REM_FREE_DAYS 			=checkNull(retExcl.getFieldValueString(i,"REM_FREE_DAYS"));
		ECD_PICK_UP_POINT 			=checkNull(retExcl.getFieldValueString(i,"PICK_UP_POINT"));
		ECD_FINAL_DEL_DT 			=checkNull(retExcl.getFieldValueString(i,"FINAL_DEL_DATE"));
		ECD_INWARD_WH_DT 			=checkNull(retExcl.getFieldValueString(i,"INWARD_WH_DATE"));
		ECD_WH_PLANT 				=checkNull(retExcl.getFieldValueString(i,"WH_PLANT"));
		ECD_DISP_CONF_BY_TRANS			=checkNull(retExcl.getFieldValueString(i,"DISP_CONF_BY_TRANS"));
		ECD_DISP_CONF_BY_CHA 			=checkNull(retExcl.getFieldValueString(i,"DISP_CONF_BY_CHA"));
		ECD_LR_NO				=checkNull(retExcl.getFieldValueString(i,"LR_NO"));
		ECD_TRUCK_NO				=checkNull(retExcl.getFieldValueString(i,"TRUCK_NO"));
		ECD_POD					=checkNull(retExcl.getFieldValueString(i,"POD"));
		ECD_SHIPPING_CO 			=checkNull(retExcl.getFieldValueString(i,"SHIPP_CO"));
	 	ECD_BUYER 				=checkNull(retExcl.getFieldValueString(i,"BUYER"));
		ECD_MIGO_103 				=checkNull(retExcl.getFieldValueString(i,"MIGO_103"));
		ECD_MIGO_105 				=checkNull(retExcl.getFieldValueString(i,"MIGO_105"));
		ECD_SAP_BATCH 				=checkNull(retExcl.getFieldValueString(i,"SAP_BATCH"));
		ECD_STO 				=checkNull(retExcl.getFieldValueString(i,"STO"));
		ECD_DO 					=checkNull(retExcl.getFieldValueString(i,"DO"));
		ECD_TAX_INV 				=checkNull(retExcl.getFieldValueString(i,"TAX_INV"));
		ECD_EMPTY_RET_DT 			=checkNull(retExcl.getFieldValueString(i,"EMPTY_RETURN_DT"));   
		ECD_INV_NUM				=checkNull(retExcl.getFieldValueString(i,"INV_NO"));
		ECD_INV_DATE				=checkNull(retExcl.getFieldValueString(i,"INV_DT"));
		ECD_BL_NUM				=checkNull(retExcl.getFieldValueString(i,"BL_NO"));
		ECD_BL_DATE				=checkNull(retExcl.getFieldValueString(i,"BL_DT"));
		ECD_PRICE				=checkNull(retExcl.getFieldValueString(i,"PRICE"));
		ECD_CIF_VALUE				=checkNull(retExcl.getFieldValueString(i,"VALUE"));
		ECD_COUR_NO				=checkNull(retExcl.getFieldValueString(i,"COURIER_NO"));    
		ECD_OBL_BY_BANK 			=checkNull(retExcl.getFieldValueString(i,"OBL_BY_BANK"));
		ECD_BANK_NAME				=checkNull(retExcl.getFieldValueString(i,"BANK_NAME"));
		ECD_PRESENTATION_DT 			=checkNull(retExcl.getFieldValueString(i,"PRESENTATION_DT"));
		ECD_ACCEPT_DT 				=checkNull(retExcl.getFieldValueString(i,"ACCEPT_DT"));
		ECD_GR_RENT 				=checkNull(retExcl.getFieldValueString(i,"GR_RENT"));
		ECD_DETENTION 				=checkNull(retExcl.getFieldValueString(i,"DETENTION"));
		ECD_PENALTY 				=checkNull(retExcl.getFieldValueString(i,"PENALTY"));
		ECD_COPQ_REC_STAT 			=checkNull(retExcl.getFieldValueString(i,"COPQ_REC_STATUS"));
		ECD_SHID 				=checkNull(retExcl.getFieldValueString(i,"ASN"));
		ECD_SHDT 				=checkNull(retExcl.getFieldValueString(i,"ASN DT"));
		 
		/*String ECD_ETAStr=checkNull(convertDateObjToStringForm(ECD_ETA)); 
		String ECD_BOE_DATEStr=checkNull(convertDateObjToStringForm(ECD_BOE_DATE)); 
		String ECD_DUTY_INITStr=checkNull(convertDateObjToStringForm(ECD_DUTY_INIT)); 
		String ECD_WH_BOE_DATEStr=checkNull(convertDateObjToStringForm(ECD_WH_BOE_DATE));  
		String ECD_OBL_BY_BANKStr=checkNull(convertDateObjToStringForm(ECD_OBL_BY_BANK));  
		String ECD_DO_RECP_DTStr=checkNull(convertDateObjToStringForm(ECD_DO_RECP_DT));  
		String ECD_DUTY_PAY_DTStr=checkNull(convertDateObjToStringForm(ECD_DUTY_PAY_DT));  
		String ECD_EXAM_DTStr=checkNull(convertDateObjToStringForm(ECD_EXAM_DT));  
		String ECD_DLV_DATEStr=checkNull(convertDateObjToStringForm(ECD_DLV_DATE));  
		String ECD_DLV_FROM_BOND_DTStr=checkNull(convertDateObjToStringForm(ECD_DLV_FROM_BOND_DT));  
		String ECD_DO_VALID_DTStr=checkNull(convertDateObjToStringForm(ECD_DO_VALID_DT));  
		String ECD_MANU_DTStr=checkNull(convertDateObjToStringForm(ECD_MANU_DT));  
		String ECD_PROP_DEL_DTStr=checkNull(convertDateObjToStringForm(ECD_PROP_DEL_DT));  
		String ECD_PLAN_DEL_DTStr=checkNull(convertDateObjToStringForm(ECD_PLAN_DEL_DT));  
		String ECD_FINAL_DEL_DTStr=checkNull(convertDateObjToStringForm(ECD_FINAL_DEL_DT));  
		String ECD_INWARD_WH_DTStr=checkNull(convertDateObjToStringForm(ECD_INWARD_WH_DT));  
		String ECD_EMPTY_RET_DTStr=checkNull(convertDateObjToStringForm(ECD_EMPTY_RET_DT));  
		String ECD_DISP_CONF_BY_TRANSStr=checkNull(convertDateObjToStringForm(ECD_DISP_CONF_BY_TRANS));
		String ECD_DISP_CONF_BY_CHAStr=checkNull(convertDateObjToStringForm(ECD_DISP_CONF_BY_CHA));
		String ECD_OBL_BY_CHAStr=checkNull(convertDateObjToStringForm(ECD_OBL_BY_CHA));*/ 
		
		 
	
	//SHID=(Integer)vendHt.get(ECD_SOLD_TO+"#"+ECD_INV_NUM);
%>   
		<tr>     
		
			<td><input type="text" name="VENDORCODE" id="VENDORCODE<%=i%>" class="validate[required] form-control" value="<%=ECD_SOLD_TO%>"  /></td>	
			<td><input type="text" name="DCA" id="DCA<%=i%>" style="width:100px;"  class="validate[required] form-control" value="<%=ECD_DCA%>"  /></td>	
			<td><input type="text" name="ETA" id="ETA<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_ETA%>"  /></td>	
			<td><input type="text" name="NOOFDAYSFROMETA" id="NOOFDAYSFROMETA<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_NODAYSFROM_ETA%>"  /></td>	
			<td><input type="text" name="BOENO" id="BOENO<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_BOE_NO%>"  /></td>	
			<td><input type="text" name="BOEDATE" id="BOEDATE<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_BOE_DATE%>"  /></td>	
			<td><input type="text" name="CRITICALDLVRY" id="CRITICALDLVRY<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_CRT_DEL%>"  /></td>	
			<td><input type="text" name="MATERIALCODE" id="MATERIALCODE<%=i%>" class="validate[required] form-control" value="<%=ECD_MAT_NR%>"  /></td>	
			<td><input type="text" name="MATERIALDESC" id="MATERIALDESC<%=i%>" class="validate[required] form-control" value="<%=ECD_MAT_DESC%>"  /></td>	
			<td><input type="text" name="QTYSHIPPED" id="QTYSHIPPED<%=i%>" class="validate[required] form-control" value="<%=ECD_QTY_SHIPPED%>"  /></td>	
			<td><input type="text" name="VALBYBUYER" id="VALBYBUYER<%=i%>" class="validate[required] form-control" value="<%=ECD_BUY_VAL_TYPE%>"  /></td>	
			<td><input type="text" name="VALTYPE" id="VALTYPE<%=i%>" class="validate[required] form-control" value="<%=ECD_VAL_TYPE%>"  /></td>	
			<td><input type="text" name="LINENO" id="LINENO<%=i%>" class="validate[required] form-control" value="<%=ECD_LINE_NUM%>"  /></td>
			<td><input type="text" name="CONTNO" id="CONTNO<%=i%>" class="validate[required] form-control" value="<%=ECD_CONT_NUM%>"  /></td>
			<td><input type="text" name="DISPATCHPLANT" id="DISPATCHPLANT<%=i%>" class="validate[required] form-control" value="<%=ECD_DISP_PLANT%>"  /></td>
			<td><input type="text" name="PROPDELDATE" id="PROPDELDATE<%=i%>" class="validate[required] form-control" value="<%=ECD_PROP_DEL_DT%>"  /></td>
			<td><input type="text" name="PLANNEDDELDATE" id="PLANNEDDELDATE<%=i%>" class="validate[required] form-control" value="<%=ECD_PLAN_DEL_DT%>"  /></td>
			<td><input type="text" name="TRANSPORTER" id="TRANSPORTER<%=i%>" class="validate[required] form-control" value="<%=ECD_TRANSPORTER%>"  /></td>
			<td><input type="text" name="VEHICLETYPE" id="VEHICLETYPE<%=i%>" class="validate[required] form-control" value="<%=ECD_VEHICLE_TYPE%>"  /></td>
			<td><input type="text" name="PALLETSNO" id="PALLETSNO<%=i%>" class="validate[required] form-control" value="<%=ECD_NO_OF_PALLETS%>"  /></td>	
			<td><input type="text" name="CHA" id="CHA<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_CHA%>"  /></td>	
			<%
			ezc.ezcommon.EzLog4j.log(":::::::CHA>>:::::::"+ECD_CHA,"I");   
			out.println("::::::CHA>>:::::"+ECD_CHA);
			%>			
			<td><input type="text" name="DOCKET" id="DOCKET<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_DOCKET%>"  /></td>	
			<td><input type="text" name="DUTYINIT" id="DUTYINIT<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_DUTY_INIT%>"  /></td>	
			<td><input type="text" name="EXRATE" id="EXRATE<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_EX_RATE%>"  /></td>	
			<td><input type="text" name="DUTYAMT" id="DUTYAMT<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_DUTY_AMT%>"  /></td>	
			<td><input type="text" name="OBLBYCHA" id="OBLBYCHA<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_OBL_BY_CHA%>"  /></td>	
			<td><input type="text" name="LICNO" id="LICNO<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_LIC_NO%>"  /></td>	
			<td><input type="text" name="PLANT" id="PLANT<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_PLANT%>"  /></td>
			<td><input type="text" name="PONO" id="PONO<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_PO_NUM%>"  /></td>
			<td><input type="text" name="RTP" id="RTP<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_RTP%>"  /></td>
			<td><input type="text" name="RTPSTATUS" id="RTPSTATUS<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_RTP_STAT%>"  /></td>
			<td><input type="text" name="FTA" id="FTA<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_FTA%>"  /></td>
			<td><input type="text" name="FTASTATUS" id="FTASTATUS<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_FTA_STAT%>"  /></td>
			<td><input type="text" name="DORECP" id="DORECP<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_DO_RECP_DT%>"  /></td>
			<td><input type="text" name="DUTYPMNTDATE" id="DUTYPMNTDATE<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_DUTY_PAY_DT%>"  /></td>
			<td><input type="text" name="EXAMDATE" id="EXAMDATE<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_EXAM_DT%>"  /></td>
			<td><input type="text" name="DLVDATE" id="DLVDATE<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_DLV_DATE%>"  /></td>
			<td><input type="text" name="DLVFROMBOND" id="DLVFROMBOND<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_DLV_FROM_BOND_DT%>"  /></td>
			<td><input type="text" name="WHBOE" id="WHBOE<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_WH_BOE_NO%>"  /></td>
			<td><input type="text" name="WHBOEDATE" id="WHBOEDATE<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_WH_BOE_DATE%>"  /></td>
			<td><input type="text" name="DOVALIDDATE" id="DOVALIDDATE<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_DO_VALID_DT%>"  /></td>
			<td><input type="text" name="REMARKS" id="REMARKS<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_REMARKS%>"  /></td>
			<td><input type="text" name="MANUDATE" id="MANUDATE<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_MANU_DT%>"  /></td>
			<td><input type="text" name="SLED" id="SLED<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_SLED_DT%>"  /></td>
			<td><input type="text" name="REMFREEDAYS" id="REMFREEDAYS<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_REM_FREE_DAYS%>"  /></td>
			<td><input type="text" name="PICKUPPOINT" id="PICKUPPOINT<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_PICK_UP_POINT%>"  /></td>
			<td><input type="text" name="FINDELDATE" id="FINDELDATE<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_FINAL_DEL_DT%>"  /></td>
			<td><input type="text" name="INWARDWHDATE" id="INWARDWHDATE<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_INWARD_WH_DT%>"  /></td>
			<td><input type="text" name="WHPLANT" id="WHPLANT<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_WH_PLANT%>"  /></td>
			<td><input type="text" name="DISPCONFBYTRANS" id="DISPCONFBYTRANS<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_DISP_CONF_BY_TRANS%>"  /></td>
			<td><input type="text" name="DISPCONFBYCHA" id="DISPCONFBYCHA<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_DISP_CONF_BY_CHA%>"  /></td>
			<td><input type="text" name="LRNO" id="LRNO<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_LR_NO%>"  /></td>
			<td><input type="text" name="TRUCKNO" id="TRUCKNO<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_TRUCK_NO%>"  /></td>
			<td><input type="text" name="POD" id="POD<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_POD%>"  /></td>
			<td><input type="text" name="SHIPPCO" id="SHIPPCO<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_SHIPPING_CO%>"  /></td>
			<td><input type="text" name="BUYER" id="BUYER<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_BUYER%>"  /></td>
			<td><input type="text" name="MIGO103" id="BUYER<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_MIGO_103%>"  /></td>
			<td><input type="text" name="MIGO105" id="BUYER<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_MIGO_105%>"  /></td>
			<td><input type="text" name="SAPBATCH" id="SAPBATCH<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_SAP_BATCH%>"  /></td>
			<td><input type="text" name="STO" id="STO<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_STO%>"  /></td>
			<td><input type="text" name="DO" id="DO<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_DO%>"  /></td>
			<td><input type="text" name="TAXINV" id="TAXINV<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_TAX_INV%>"  /></td>
			<td><input type="text" name="EMPTYRETDATE" id="EMPTYRETDATE<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_EMPTY_RET_DT%>"  /></td>
			<td><input type="text" name="INVNO" id="INVNO<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_INV_NUM%>"  /></td>	
			<td><input type="text" name="INVDT" id="INVDT<%=i%>" class="validate[required] form-control" style="width:100px;"  value="<%=ECD_INV_DATE%>"  /></td>	
			<td><input type="text" name="BLNO" id="BLNO<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_BL_NUM%>"  /></td>	
			<td><input type="text" name="BLDT" id="BLDT<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_BL_DATE%>"  /></td>	
			<td><input type="text" name="PRICE" id="PRICE<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_PRICE%>"  /></td>	
			<td><input type="text" name="VALUE" id="VALUE<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_CIF_VALUE%>"  /></td>		
			<td><input type="text" name="COURIERNO" id="COURIERNO<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_COUR_NO%>"  /></td>
			<td><input type="text" name="OBLBYBANK" id="OBLBYBANK<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_OBL_BY_BANK%>"  /></td>
			<td><input type="text" name="BANKNAME" id="BANKNAME<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_BANK_NAME%>"  /></td>
			<td><input type="text" name="PRESENTATIONDT" id="PRESENTATIONDT<%=i%>" class="validate[required] form-control"  style="width:100px;" value="<%=ECD_PRESENTATION_DT%>"  /></td>
			<td><input type="text" name="ACCEPTDT" id="PRESENTATIONDT<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_ACCEPT_DT%>"  /></td>
			<td><input type="text" name="GRRENT" id="PRESENTATIONDT<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_GR_RENT%>"  /></td>
			<td><input type="text" name="DETENTION" id="DETENTION<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_DETENTION%>"  /></td>
			<td><input type="text" name="PENALTY" id="PENALTY<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_PENALTY%>"  /></td>
			<td><input type="text" name="COPQRECSTATUS" id="COPQRECSTATUS<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_COPQ_REC_STAT%>"  /></td>
			<td><input type="text" name="SHID" id="SHID<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_SHID%>"  /></td>
			<td><input type="text" name="SHDT" id="SHDT<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=ECD_SHDT%>"  /></td>

				
				
		
		<input type="hidden" name="SHID" id="SHID<%=i%>"  value="<%=ECD_SHID%>"  />	
		</tr>
<%
		
	} 
%>
	</tbody>
	</table>
	</DIV>
	</div>

	</div>
	</div>
	<!-- Your Page Content Here -->
	</div>
	</div><!--row-->
	<br>
	
	
	
	<!-- Table row -->
	<div class="row" id="validErrorMsgDiv" style="display:<%=displayErrMsg%>">
	   <div class="col-xs-12">
	      <div class="alert alert-info alert-dismissible">
	         <i class="icon fa fa-info"></i><span id="validErrorMsg"><%=dispMsg%></span>
	      </div>
	   </div>
	</div>
	</br>

  
  
  
	<div class="row" >
		<div class="col-xs-12" align="center">
			<button type="button" class="btn btn-primary" onclick="funBack()"><span class="glyphicon glyphicon-backward"></span> Back </button>  &nbsp;
			<!--<button type="button" class="btn btn-primary" onclick="funValidate()" ><span class="glyphicon glyphicon-info-sign"></span> Validate </button>  &nbsp;-->
			<button type="button" class="btn btn-primary" onclick="funSubmit()" id="saveData"  ><span class="glyphicon glyphicon-forward" ></span> Submit </button>  &nbsp;
			
		</div>
	</div>
<%
	}
%>
</form>
</section>
<!-- /.content -->
</div><!-- /.content-wrapper --> 
<div id="woModal" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog">
      <div class="modal-content">
         <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <iframe src="" width="100%" height="540" frameborder="0" allowtransparency="true"></iframe>
         </div>
      </div>
   </div>
</div>
<%
	
	if(showError)
	{
%>
	<div id="errModal" class="modal fade" tabindex="-1" role="dialog">
	   <div class="modal-dialog">
	      <div class="modal-content">
		 <div class="modal-body">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
              	   <div class="alert alert-warning">
			   <h4><i class="icon fa fa-warning"></i> Alert!</h4>
			   <hs>Scheduled quantity does not match with SAP quantity for below PO's</hs>
              	   </div>
		    <table class="table table-bordered">
		    	<tr>
		    		<th>PO No.</th>
		    		<th>Item No.</th>
		    		<th>Scheduled Qty</th>
		    		<th>SAP Qty</th>
		    	</tr>
		    	<%=errTabStr%>
		    </table>
		 </div>
	      </div>
	   </div>
	</div>	
<%
	}
%>
<%@ include file="../Misc/ezVendFooter.jsp"%>

<script src="../../Library/JavaScript/ezTabScroll.js"></Script>
<script src="../../Library/JavaScript/ezConvertDates.js"></Script>
<script>
		window.closeModal = function(){
		    $('#woModal').modal('hide');
		};
		$('#woModal').on('shown.bs.modal', function () {
		    $(this).find('.modal-dialog').addClass('modal-lg');
});
	</script>
<script>

	function funValidate()
	{ 
		if ( $("#formID").validationEngine('validate') )
		{
			//document.myForm.action="ezReadDeliverySchedules.jsp";
			//document.myForm.submit();
			document.getElementById("validErrorMsgDiv").style.display="block"
			document.myForm.isValidate.value="Y";
			document.myForm.action="ezReadCLRData.jsp";
			document.myForm.submit();
		}
		
	}
	
	
	function funSubmit()
	{ 
		if($("#formID").validationEngine('validate'))
		{
			
		
		document.myForm.action="ezSaveCLRExcel.jsp";
		document.myForm.submit();
		}
		
	}
	
	function funHideSubBut()
	{
		document.getElementById("saveData").style.display="none";
		//document.getElementById("saveInvalid").style.display="none";
	}
	function funBack()
	{
		document.myForm.action="ezUploadCertificateMaster.jsp";
		document.myForm.submit();
	}
	
	function showLog(status,msg)
	{
		$('iframe').attr("src","../Misc/ezShowMsg.jsp?msg="+encodeURIComponent(msg)+"&status="+status);
		$('#woModal').modal({show:true});
	}
	
	

	
</script>
<script type="text/javascript" class="init">
   $(document).ready( function () {
   $('#example').dataTable( {
   "bPaginate": false,  
           "bInfo": false,  
           "bFilter": false,
           "bAutoWidth": false,
           "aoColumns" : [
               { sWidth: '50px' },
               { sWidth: '200px' },
               { sWidth: '120px' },
               { sWidth: '30px' }
        ] 
       } ); 
<%
   	if(showError)
   	{
%>
		$('#errModal').modal({show:true});
<%
	}
%>
	$("#formID").validationEngine();
 
   }); 
   $("#formID").bind("jqv.field.result", function(event, field, errorFound, prompText) {
     if(errorFound)
     {
        field.removeAttr("readonly");
        //alert(field.attr('id')); 
        
        
     }  
      
  });
  $("#formID").bind("jqv.form.result", function(event, errorFound) {
     if(errorFound)
     {
        //document.getElementById("saveInvalid").style.display="inline-block"; 
	document.getElementById("saveData").style.display="none";
	//document.getElementById("validErrorMsg").innerHTML="Re enter invalid data or press Submit button to post entries by excluding invalid data ";
        
     }
     else
     {
        document.getElementById("saveData").style.display="inline-block";
	//document.getElementById("saveInvalid").style.display="none";
	document.getElementById("validErrorMsg").innerHTML="Press Submit button to post data";
     }
  });
   
	            
		   
</script>

