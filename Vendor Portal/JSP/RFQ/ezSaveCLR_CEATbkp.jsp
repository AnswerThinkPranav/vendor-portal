<%@ include file="../Misc/ezVendHeader.jsp"%>  
<%@ page import="java.util.*,ezc.ezdelvschedules.params.*,ezc.ezparam.*,java.text.*" %>
<%!
	public String checkNull(String value)
	{
		if(value==null || "null".equals(value.trim()))value="";
		
		return value.trim();
	}
%>
<% 
	
	String userIDTemp = Session.getUserId();
	String VENDOR_CODE[] = request.getParameterValues("VENDORCODE");
	String DCA[] = request.getParameterValues("DCA");
	String ETA[] = request.getParameterValues("ETA");
	String NOOFDAYSFROMETA[] = request.getParameterValues("NOOFDAYSFROMETA");
	String BOENO[] = request.getParameterValues("BOENO");
	String BOEDATE[] = request.getParameterValues("BOEDATE");
	String CRITICALDLVRY[] = request.getParameterValues("CRITICALDLVRY");
	String MATERIAL_CODE[] = request.getParameterValues("MATERIALCODE");
	String MATERIAL_DESC[] = request.getParameterValues("MATERIALDESC");
	String QTYSHIPPED[] = request.getParameterValues("QTYSHIPPED");
	String VALBYBUYER[] = request.getParameterValues("VALBYBUYER");
	String VALTYPE[] = request.getParameterValues("VALTYPE");
	String LINENO[] = request.getParameterValues("LINENO");
	String CONTNO[] = request.getParameterValues("CONTNO");
	String DISPATCHPLANT[] = request.getParameterValues("DISPATCHPLANT");
	String PROPDELDATE[] = request.getParameterValues("PROPDELDATE");
	String PLANNEDDELDATE[] = request.getParameterValues("PLANNEDDELDATE");
	String TRANSPORTER[] = request.getParameterValues("TRANSPORTER");
	String VEHICLETYPE[] = request.getParameterValues("VEHICLETYPE");
	String PALLETSNO[] = request.getParameterValues("PALLETSNO");
	String CHA[] = request.getParameterValues("CHA");
	String DOCKET[] = request.getParameterValues("DOCKET");
	String DUTYINIT[] = request.getParameterValues("DUTYINIT");
	String EXRATE[] = request.getParameterValues("EXRATE");
	String DUTYAMT[] = request.getParameterValues("DUTYAMT");
	String OBLBYCHA[] = request.getParameterValues("OBLBYCHA");
	String LICNO[] = request.getParameterValues("LICNO");
	String PLANT[] = request.getParameterValues("PLANT");
	String PONO[] = request.getParameterValues("PONO");
	String RTP[] = request.getParameterValues("RTP");
	String RTPSTATUS[] = request.getParameterValues("RTPSTATUS"); 
	String FTA[] = request.getParameterValues("FTA");
	String FTASTATUS[] = request.getParameterValues("FTASTATUS");
	String DORECP[] = request.getParameterValues("DORECP");
	String DUTYPMNTDATE[] = request.getParameterValues("DUTYPMNTDATE");
	String EXAMDATE[] = request.getParameterValues("EXAMDATE");
	String DLVDATE[] = request.getParameterValues("DLVDATE");
	String DLVFROMBOND[] = request.getParameterValues("DLVFROMBOND");
	String WHBOE[] = request.getParameterValues("WHBOE");
	String WHBOEDATE[] = request.getParameterValues("WHBOEDATE");
	String DOVALIDDATE[] = request.getParameterValues("DOVALIDDATE");
	String REMARKS[] = request.getParameterValues("REMARKS");
	String MANUDATE[] = request.getParameterValues("MANUDATE");
	String SLED[] = request.getParameterValues("SLED");
	String REMFREEDAYS[] = request.getParameterValues("REMFREEDAYS");
	String PICKUPPOINT[] = request.getParameterValues("PICKUPPOINT");
	String FINDELDATE[] = request.getParameterValues("FINDELDATE");
	String INWARDWHDATE[] = request.getParameterValues("INWARDWHDATE");
	String WHPLANT[] = request.getParameterValues("WHPLANT");
	String DISPCONFBYTRANS[] = request.getParameterValues("DISPCONFBYTRANS");
	String DISPCONFBYCHA[] = request.getParameterValues("DISPCONFBYCHA");
	String LRNO[] = request.getParameterValues("LRNO");
	String TRUCKNO[] = request.getParameterValues("TRUCKNO");
	String POD[] = request.getParameterValues("POD");
	String SHIPPCO[] = request.getParameterValues("SHIPPCO");
	String BUYER[] = request.getParameterValues("BUYER");
	String MIGO103[] = request.getParameterValues("MIGO103");
	String MIGO105[] = request.getParameterValues("MIGO105");
	String SAPBATCH[] = request.getParameterValues("SAPBATCH");
	String STO[] = request.getParameterValues("STO");
	String DO[] = request.getParameterValues("DO");
	String TAXINV[] = request.getParameterValues("TAXINV");
	String EMPTYRETDATE[] = request.getParameterValues("EMPTYRETDATE");
	String INVNO[] = request.getParameterValues("INVNO");
	String INVDT[] = request.getParameterValues("INVDT");
	String BLNO[] = request.getParameterValues("BLNO");
	String BLDT[] = request.getParameterValues("BLDT");
	String PRICE[] = request.getParameterValues("PRICE");
	String VALUE[] = request.getParameterValues("VALUE");
	String COURIERNO[] = request.getParameterValues("COURIERNO");
	String OBLBYBANK[] = request.getParameterValues("OBLBYBANK");
	String BANKNAME[] = request.getParameterValues("BANKNAME");
	String PRESENTATIONDT[] = request.getParameterValues("PRESENTATIONDT");
	String ACCEPTDT[] = request.getParameterValues("ACCEPTDT");
	String GRRENT[] = request.getParameterValues("GRRENT");
	String DETENTION[] = request.getParameterValues("DETENTION");
	String PENALTY[] = request.getParameterValues("PENALTY");
	String COPQRECSTATUS[] = request.getParameterValues("COPQRECSTATUS");
	String SHID[] = request.getParameterValues("SHID");
	String SHDT[] = request.getParameterValues("SHDT");
	
	
	String displayMsg="";
	ezc.ezcommon.EzLog4j.log("venCode"+VENDOR_CODE.length,"I");
	
	
	
	ezc.ezparam.EzcParams mainParamsCert = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgrCert = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTableCert = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	
	
	for(int i=0; i<VENDOR_CODE.length; i++)
	{
		
		String querytStr="";
		String ECD_HIERARCHY = "";
		//int shipIdInt=Integer.parseInt(SHID[i]);
		String vend=VENDOR_CODE[i];
		vend = "0000000000"+vend;
		vend = vend.substring(vend.length()-10,vend.length());
		querytStr="insert INTO EZC_CLR_DASHBOARD (ECD_SOLD_TO,ECD_DCA,ECD_ETA,ECD_NODAYSFROM_ETA,ECD_BOE_NO,ECD_BOE_DATE,ECD_CRT_DEL,ECD_MAT_NR,ECD_MAT_DESC,ECD_QTY_SHIPPED,ECD_BUY_VAL_TYPE,ECD_VAL_TYPE,ECD_LINE_NUM,ECD_CONT_NUM,ECD_DISP_PLANT,ECD_PROP_DEL_DT,ECD_PLAN_DEL_DT,ECD_TRANSPORTER,ECD_VEHICLE_TYPE,ECD_NO_OF_PALLETS,ECD_CHA,ECD_DOCKET,ECD_DUTY_INIT,ECD_EX_RATE,ECD_DUTY_AMT,ECD_OBL_BY_CHA,ECD_LIC_NO,ECD_PLANT,ECD_PO_NUM,ECD_RTP,ECD_RTP_STAT,ECD_FTA,ECD_FTA_STAT,ECD_DO_RECP_DT,ECD_DUTY_PAY_DT,ECD_EXAM_DT,ECD_DLV_DATE,ECD_DLV_FROM_BOND_DT,ECD_WH_BOE_NO,ECD_WH_BOE_DATE,ECD_DO_VALID_DT,ECD_REMARKS,ECD_MANU_DT,ECD_SLED_DT,ECD_REM_FREE_DAYS,ECD_PICK_UP_POINT,ECD_FINAL_DEL_DT,ECD_INWARD_WH_DT,ECD_WH_PLANT,ECD_DISP_CONF_BY_TRANS,ECD_DISP_CONF_BY_CHA,ECD_LR_NO,ECD_TRUCK_NO,ECD_POD,ECD_SHIPPING_CO,ECD_BUYER,ECD_MIGO_103,ECD_MIGO_105,ECD_SAP_BATCH,ECD_STO,ECD_DO,ECD_TAX_INV,ECD_EMPTY_RET_DT,ECD_INV_NUM,ECD_INV_DATE,ECD_BL_NUM,ECD_BL_DATE,ECD_PRICE,ECD_CIF_VALUE,ECD_COUR_NO,ECD_OBL_BY_BANK,ECD_BANK_NAME,ECD_PRESENTATION_DT,ECD_ACCEPT_DT,ECD_GR_RENT,ECD_DETENTION,ECD_PENALTY,ECD_COPQ_REC_STAT,ECD_SHID,ECD_SHDT,ECD_EXT1,ECD_HIERARCHY)values('"+vend+"','"+DCA[i]+"',STR_TO_DATE('"+ETA[i]+"','%d/%m/%Y'),'"+NOOFDAYSFROMETA[i]+"','"+BOENO[i]+"',STR_TO_DATE('"+BOEDATE[i]+"','%d/%m/%Y'),'"+CRITICALDLVRY[i]+"','"+MATERIAL_CODE[i]+"','"+MATERIAL_DESC[i]+"','"+QTYSHIPPED[i]+"','"+VALBYBUYER[i]+"','"+VALTYPE[i]+"','"+LINENO[i]+"','"+CONTNO[i]+"','"+DISPATCHPLANT[i]+"',STR_TO_DATE('"+PROPDELDATE[i]+"','%d/%m/%Y'),STR_TO_DATE('";
		querytStr +=PLANNEDDELDATE[i]+"','%d/%m/%Y'),'"+TRANSPORTER[i]+"','"+VEHICLETYPE[i]+"','"+PALLETSNO[i]+"','"+CHA[i]+"','"+DOCKET[i]+"',STR_TO_DATE('"+DUTYINIT[i]+"','%d/%m/%Y'),'"+EXRATE[i]+"','"+DUTYAMT[i]+"',STR_TO_DATE('"+OBLBYCHA[i]+"','%d/%m/%Y'),'"+LICNO[i]+"','"+PLANT[i]+"','"+PONO[i]+"','"+RTP[i]+"','"+RTPSTATUS[i]+"','";
		querytStr +=FTA[i]+"','"+FTASTATUS[i]+"',STR_TO_DATE('"+DORECP[i]+"','%d/%m/%Y'),STR_TO_DATE('"+DUTYPMNTDATE[i]+"','%d/%m/%Y'),STR_TO_DATE('"+EXAMDATE[i]+"','%d/%m/%Y'),STR_TO_DATE('"+DLVDATE[i]+"','%d/%m/%Y'),STR_TO_DATE('"+DLVFROMBOND[i]+"','%d/%m/%Y'),'"+WHBOE[i]+"',STR_TO_DATE('"+WHBOEDATE[i]+"','%d/%m/%Y'),STR_TO_DATE('"+DOVALIDDATE[i]+"','%d/%m/%Y'),'"+REMARKS[i]+"',STR_TO_DATE('"+MANUDATE[i]+"','%d/%m/%Y'),STR_TO_DATE('"+SLED[i]+"','%d/%m/%Y'),'"+REMFREEDAYS[i]+"','"+PICKUPPOINT[i]+"',STR_TO_DATE('"+FINDELDATE[i]+"','%d/%m/%Y'),STR_TO_DATE('"+INWARDWHDATE[i]+"','%d/%m/%Y'),'"+WHPLANT[i]+"',STR_TO_DATE('";
		querytStr +=DISPCONFBYTRANS[i]+"','%d/%m/%Y'),STR_TO_DATE('"+DISPCONFBYCHA[i]+"','%d/%m/%Y'),'"+LRNO[i]+"','"+TRUCKNO[i]+"','"+POD[i]+"','"+SHIPPCO[i]+"','"+BUYER[i]+"','"+MIGO103[i]+"','"+MIGO105[i]+"','"+SAPBATCH[i]+"','"+STO[i]+"','"+DO[i]+"','"+TAXINV[i]+"',STR_TO_DATE('"+EMPTYRETDATE[i]+"','%d/%m/%Y'),'"+INVNO[i]+"',STR_TO_DATE('"+INVDT[i]+"','%d/%m/%Y'),'"+BLNO[i]+"',STR_TO_DATE('"+BLDT[i]+"','%d/%m/%Y'),'"+PRICE[i]+"','"+VALUE[i]+"','"+COURIERNO[i]+"',STR_TO_DATE('";
		querytStr +=OBLBYBANK[i]+"','%d/%m/%Y'),'"+BANKNAME[i]+"',STR_TO_DATE('"+PRESENTATIONDT[i]+"','%d/%m/%Y'),STR_TO_DATE('"+ACCEPTDT[i]+"','%d/%m/%Y'),'"+GRRENT[i]+"','"+DETENTION[i]+"','"+PENALTY[i]+"','"+COPQRECSTATUS[i]+"','"+SHID[i]+"',STR_TO_DATE('"+SHDT[i]+"','%d/%m/%Y'),'FROMEXCEL','P')";
		miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
		miscTableRow.setQuery(querytStr);

		miscTableCert.appendRow(miscTableRow);   
		
	}

	mainParamsCert.setLocalStore("Y");
	mainParamsCert.setObject(miscTableCert);
	Session.prepareParams(mainParamsCert);
	try
	{
		miscMgrCert.ezSaveMiscTransactions(mainParamsCert);
	}catch(Exception e){ezc.ezcommon.EzLog4j.log("<<Exception in saving data>>>"+e,"E");}
	
	
    response.sendRedirect("ezCLRDashBoard.jsp");  		
	
%>
























































































