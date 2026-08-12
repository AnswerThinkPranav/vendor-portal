<%@ page import="jxl.Sheet,jxl.Workbook,jxl.read.biff.BiffException,jxl.write.*"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@ page import="ezc.ezparam.*,java.util.*,java.util.Date,java.text.ParseException,java.text.SimpleDateFormat" %>
<%!
public String checkNullinDown(String str)  
 	{ 
 		String retStr = "";
 		 
 		if(str == null || "null".equals(str) || "".equals(str)) 
 			retStr = "";
 		else
 			retStr = str;
 			
 		return retStr;	
	}
public void ezCreateExcel(HttpServletResponse response,String fileName,ArrayList dispColNames,ReturnObjFromRetrieve rowsRetObj,ArrayList retObjCols)
 {
 	WritableWorkbook workbook = null;
 	try
	 	{
	 		response.resetBuffer();
	 		response.setContentType("application/vnd.ms-excel");
	 		response.setHeader("Content-Disposition", "attachment; filename="+fileName);
	 		response.setContentLength(600000);
	 		workbook = Workbook.createWorkbook(response.getOutputStream());
	 
	 		WritableSheet ws = workbook.createSheet("Sheet1", 0);
	 		String empty="";
	 		for(int j=0;j<dispColNames.size();j++)
	 		{
	 			jxl.write.WritableFont boldRedFont = new jxl.write.WritableFont(jxl.write.WritableFont.TIMES, 11 , jxl.write.WritableFont.BOLD);
	 			boldRedFont.setColour(jxl.format.Colour.BLACK);
	 			jxl.write.WritableCellFormat boldRed = new jxl.write.WritableCellFormat(boldRedFont);
	 			boldRed.setBackground(jxl.format.Colour.PALE_BLUE);
	 			boldRed.setShrinkToFit(false);
	 
	 			if(j==0)
	 				boldRed.setBorder(jxl.format.Border.LEFT, jxl.format.BorderLineStyle.THIN , jxl.format.Colour.BLACK);
	 
	 			else if(j==(dispColNames.size()-1))
	 				boldRed.setBorder(jxl.format.Border.RIGHT, jxl.format.BorderLineStyle.THIN , jxl.format.Colour.BLACK);
	 
	 			ws.addCell(new Label(j, 0, (String)dispColNames.get(j), boldRed));
	 		}
	 
	 		for(int k=1;k<=rowsRetObj.getRowCount();k++)
	 		{
	 			for(int j=0;j<retObjCols.size();j++)
	 			{
	 				jxl.write.WritableFont boldRedFont = new jxl.write.WritableFont(jxl.write.WritableFont.TIMES, 11);
	 				jxl.write.WritableCellFormat boldRed = new jxl.write.WritableCellFormat(boldRedFont);
	 
	 				if(k==1 && j==0)
	 						boldRed.setBorder(jxl.format.Border.LEFT, jxl.format.BorderLineStyle.THIN , jxl.format.Colour.BLACK);
	 
	 				else if(k<rowsRetObj.getRowCount())
	 				{
	 					if(j==0)
	 						boldRed.setBorder(jxl.format.Border.LEFT, jxl.format.BorderLineStyle.THIN , jxl.format.Colour.BLACK);
	 
	 					else if(j==(retObjCols.size()-1))
	 						boldRed.setBorder(jxl.format.Border.RIGHT, jxl.format.BorderLineStyle.THIN , jxl.format.Colour.BLACK);
	 
	 				}
	 				else if(k==rowsRetObj.getRowCount())
	 				{
	 					if(j==0)
	 						boldRed.setBorder(jxl.format.Border.LEFT, jxl.format.BorderLineStyle.THIN , jxl.format.Colour.BLACK);
	 
	 					else if(j==(retObjCols.size()-1))
	 						boldRed.setBorder(jxl.format.Border.RIGHT, jxl.format.BorderLineStyle.THIN , jxl.format.Colour.BLACK);
	 
	 
	 					boldRed.setBorder(jxl.format.Border.BOTTOM , jxl.format.BorderLineStyle.THIN , jxl.format.Colour.BLACK);
	 
	 				}
	 
	 				ws.addCell(new Label(j, k, rowsRetObj.getFieldValueString(k-1,(String)retObjCols.get(j)), boldRed));
	 			}
	 		}
	 	}
	 	catch(Exception e)
	 	{
	 		System.out.println("Following Exception occured in creating JExcel...."+e);
	 		e.printStackTrace();
	 	}
	 	finally
	 	{
	 		try{
	 			workbook.write();
	 			workbook.close();
	 		}catch(Exception ex){}
 	}
 	
 	
 }
 %>
 


<%

	ReturnObjFromRetrieve exlCLRRetObj=(ReturnObjFromRetrieve)session.getValue("CLR_Report_Ret");
	
	SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");  
	Date date = new Date();  
    	String dt = formatter.format(date);  
	
	ReturnObjFromRetrieve rowsRetObj=null;
	ArrayList headerData 	= new ArrayList();
	ArrayList dispColNames 	= new ArrayList();
	ArrayList retObjCols 	= new ArrayList();
	
	dispColNames.add("VENDOR_CODE"); 
	dispColNames.add("DCA"); 
	dispColNames.add("ETA"); 
	dispColNames.add("NO_OF_DAYS_FROM_ETA"); 
	dispColNames.add("BOE_NO"); 
	dispColNames.add("BOE_DATE"); 
	dispColNames.add("CRITICAL_DELIVERY"); 
	dispColNames.add("MATERIAL_CODE"); 
	dispColNames.add("MATERIAL_DESC"); 
	dispColNames.add("QTY_SHIPPED"); 
	dispColNames.add("VALUATION_BY_BUYER"); 
	dispColNames.add("VALUATION_TYPE"); 
	dispColNames.add("LINE_NO"); 
	dispColNames.add("CONT_NO"); 
	dispColNames.add("DISPATCH_PLANT"); 
	dispColNames.add("PROP_DEL_DATE"); 
	dispColNames.add("PLANNED_DEL_DATE"); 
	dispColNames.add("TRANSPORTER"); 
	dispColNames.add("VEHICLE_TYPE"); 
	dispColNames.add("PALLETS_NO"); 
	dispColNames.add("CHA"); 
	dispColNames.add("DOCKET"); 
	dispColNames.add("DUTY_INITIATION"); 
	dispColNames.add("EX_RATE"); 
	dispColNames.add("DUTY_AMT"); 
	dispColNames.add("OBL_BY_CHA"); 
	dispColNames.add("LIC_NO"); 
	dispColNames.add("PLANT"); 
	dispColNames.add("PO_NO"); 
	dispColNames.add("RTP"); 
	dispColNames.add("RTP_STATUS"); 
	dispColNames.add("FTA"); 
	dispColNames.add("FTA_STATUS"); 
	dispColNames.add("DO_RECP"); 
	dispColNames.add("DUTY_PMNT_DATE"); 
	dispColNames.add("EXAM_DATE"); 
	dispColNames.add("DLV_DATE"); 
	dispColNames.add("DLV_FROM_BOND"); 
	dispColNames.add("WH_BOE"); 
	dispColNames.add("WH_BOE_DATE"); 
	dispColNames.add("DO_VALID_DATE"); 
	dispColNames.add("REMARKS"); 
	dispColNames.add("MANU_DATE"); 
	dispColNames.add("SLED"); 
	dispColNames.add("REM_FREE_DAYS");
	dispColNames.add("PICK_UP_POINT"); 
	dispColNames.add("FINAL_DEL_DATE"); 
	dispColNames.add("INWARD_WH_DATE"); 
	dispColNames.add("WH_PLANT"); 
	dispColNames.add("DISP_CONF_BY_TRANS"); 
	dispColNames.add("DISP_CONF_BY_CHA"); 
	dispColNames.add("LR_NO"); 
	dispColNames.add("TRUCK_NO"); 
	dispColNames.add("POD"); 
	dispColNames.add("SHIPP_CO"); 
	dispColNames.add("BUYER"); 
	dispColNames.add("MIGO_103"); 
	dispColNames.add("MIGO_105"); 
	dispColNames.add("SAP_BATCH"); 
	dispColNames.add("STO"); 
	dispColNames.add("DO"); 
	dispColNames.add("TAX_INV"); 
	dispColNames.add("EMPTY_RETURN_DT"); 
	dispColNames.add("INV_NO"); 
	dispColNames.add("INV_DT"); 
	dispColNames.add("BL_NO"); 
	dispColNames.add("BL_DT"); 
	dispColNames.add("PRICE"); 
	dispColNames.add("VALUE"); 
	dispColNames.add("COURIER_NO"); 
	dispColNames.add("DOCKET"); 
	dispColNames.add("OBL_BY_BANK"); 
	dispColNames.add("BANK_NAME"); 
	dispColNames.add("PRESENTATION_DT"); 
	dispColNames.add("ACCEPT_DT"); 
	dispColNames.add("GR_RENT"); 
	dispColNames.add("DETENTION"); 
	dispColNames.add("PENALTY"); 
	dispColNames.add("COPQ_REC_STATUS"); 
	dispColNames.add("SHID"); 
	dispColNames.add("SHDT"); 
	 	
	
	retObjCols.add("VENDOR_CODE"); 
	retObjCols.add("DCA"); 
	retObjCols.add("ETA"); 
	retObjCols.add("NO_OF_DAYS_FROM_ETA"); 
	retObjCols.add("BOE_NO"); 
	retObjCols.add("BOE_DATE"); 
	retObjCols.add("CRITICAL_DELIVERY"); 
	retObjCols.add("MATERIAL_CODE"); 
	retObjCols.add("MATERIAL_DESC"); 
	retObjCols.add("QTY_SHIPPED"); 
	retObjCols.add("VALUATION_BY_BUYER"); 
	retObjCols.add("VALUATION_TYPE"); 
	retObjCols.add("LINE_NO"); 
	retObjCols.add("CONT_NO"); 
	retObjCols.add("DISPATCH_PLANT"); 
	retObjCols.add("PROP_DEL_DATE"); 
	retObjCols.add("PLANNED_DEL_DATE"); 
	retObjCols.add("TRANSPORTER"); 
	retObjCols.add("VEHICLE_TYPE"); 
	retObjCols.add("PALLETS_NO"); 
	retObjCols.add("CHA"); 
	retObjCols.add("DOCKET"); 
	retObjCols.add("DUTY_INITIATION"); 
	retObjCols.add("EX_RATE"); 
	retObjCols.add("DUTY_AMT"); 
	retObjCols.add("OBL_BY_CHA"); 
	retObjCols.add("LIC_NO"); 
	retObjCols.add("PLANT"); 
	retObjCols.add("PO_NO"); 
	retObjCols.add("RTP"); 
	retObjCols.add("RTP_STATUS"); 
	retObjCols.add("FTA"); 
	retObjCols.add("FTA_STATUS"); 
	retObjCols.add("DO_RECP"); 
	retObjCols.add("DUTY_PMNT_DATE"); 
	retObjCols.add("EXAM_DATE"); 
	retObjCols.add("DLV_DATE"); 
	retObjCols.add("DLV_FROM_BOND"); 
	retObjCols.add("WH_BOE"); 
	retObjCols.add("WH_BOE_DATE"); 
	retObjCols.add("DO_VALID_DATE"); 
	retObjCols.add("REMARKS"); 
	retObjCols.add("MANU_DATE"); 
	retObjCols.add("SLED"); 
	retObjCols.add("REM_FREE_DAYS");
	retObjCols.add("PICK_UP_POINT"); 
	retObjCols.add("FINAL_DEL_DATE"); 
	retObjCols.add("INWARD_WH_DATE"); 
	retObjCols.add("WH_PLANT"); 
	retObjCols.add("DISP_CONF_BY_TRANS"); 
	retObjCols.add("DISP_CONF_BY_CHA"); 
	retObjCols.add("LR_NO"); 
	retObjCols.add("TRUCK_NO"); 
	retObjCols.add("POD"); 
	retObjCols.add("SHIPP_CO"); 
	retObjCols.add("BUYER"); 
	retObjCols.add("MIGO_103"); 
	retObjCols.add("MIGO_105"); 
	retObjCols.add("SAP_BATCH"); 
	retObjCols.add("STO"); 
	retObjCols.add("DO"); 
	retObjCols.add("TAX_INV"); 
	retObjCols.add("EMPTY_RETURN_DT"); 
	retObjCols.add("INV_NO"); 
	retObjCols.add("INV_DT"); 
	retObjCols.add("BL_NO"); 
	retObjCols.add("BL_DT"); 
	retObjCols.add("PRICE"); 
	retObjCols.add("VALUE"); 
	retObjCols.add("COURIER_NO"); 
	retObjCols.add("DOCKET"); 
	retObjCols.add("OBL_BY_BANK"); 
	retObjCols.add("BANK_NAME"); 
	retObjCols.add("PRESENTATION_DT"); 
	retObjCols.add("ACCEPT_DT"); 
	retObjCols.add("GR_RENT"); 
	retObjCols.add("DETENTION"); 
	retObjCols.add("PENALTY"); 
	retObjCols.add("COPQ_REC_STATUS"); 
	retObjCols.add("SHID"); 
	retObjCols.add("SHDT"); 

	
	try
	{

		ezCreateExcel(response,"ADD_CLR_DATA"+dt+".xls",dispColNames,exlCLRRetObj,retObjCols);
	}
	catch(Exception e)
	{
		//System.out.println("Excel Driver Exception in Page ezDownloadDelSchedExcel.jsp:"+e);
	}
%>