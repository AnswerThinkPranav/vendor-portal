<%@ include file="../../../Vendor2/Library/Globals/errorPagePath.jsp"%>
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%> 

<%@ include file="../Misc/ezVendorCompanyCodes.jsp" %>
<%@ page import ="java.io.*,java.util.*,java.text.*,com.itextpdf.text.*,com.itextpdf.text.pdf.*,com.itextpdf.text.Font.*,com.itextpdf.text.pdf.RadioCheckField" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="vendortransactions" class="ezc.vendortransactions.client.EzVendorTransactionsManager" scope="session"></jsp:useBean>
<%@ page import="ezc.ezparam.ReturnObjFromRetrieve"%>
<%@ page import="ezc.vendortransactions.params.*,ezc.ezparam.*,java.util.*,java.io.*,ezc.ezcommon.EzGlobalConfig" %>
<%@ page import="java.util.*,java.io.File,java.io.*,java.lang.*" %>
<%@ include file="../../../Includes/JSPs/Misc/iMultiVendorDetails.jsp" %>
<%@ include file="../../../Includes/JSPs/Misc/iEzDateConvertion.jsp" %>
<%!
		public String checkNull(String value)
		{
			if(value==null || "null".equals(value.trim()))value="";
			
			return value.trim();
		}
%>

<%

	Hashtable paymentMthDescHT = new Hashtable();
	paymentMthDescHT.put("0","Demand Drafts-KBL - 1601");
	paymentMthDescHT.put("1","Demand Drafts-KBL - 2311");
	paymentMthDescHT.put("2","Demand Draft-KBL-2197");
	paymentMthDescHT.put("3","Demand Drafts-KBL - 2532");
	paymentMthDescHT.put("4","Demand Drafts-KBL - 2533");
	paymentMthDescHT.put("5","Demand Drafts-SBI C/a");
	paymentMthDescHT.put("A","Cheque-for KBL -1601");
	paymentMthDescHT.put("B","Cheque-for KBL -2311");
	paymentMthDescHT.put("C","Cheque");
	paymentMthDescHT.put("D","Demand Drafts");
	paymentMthDescHT.put("E","Cash Payment");
	paymentMthDescHT.put("F","Cheue-for-KBL-2197");
	paymentMthDescHT.put("G","Cheque-for KBL -2532");
	paymentMthDescHT.put("H","Cheque-for KBL -2533");
	paymentMthDescHT.put("I","Cheque-for SBI C/a");
	paymentMthDescHT.put("K","RTGS Payment");
	paymentMthDescHT.put("T","Bank Transfer");
	paymentMthDescHT.put("W","BOE - India");
	
	

	ezc.ezutil.FormatDate formatDate = new ezc.ezutil.FormatDate();
	String ShowData = request.getParameter("ShowData");
	if(ShowData == null)
		ShowData = "N";
	else
		ShowData = "Y";
	ShowData = "Y";	
	ezc.ezbasicutil.EzCurrencyFormat myFormat= new ezc.ezbasicutil.EzCurrencyFormat();
	myFormat.setLocale((java.util.Locale)session.getValue("LOCALE"));
	myFormat.setNeedSybmol(((Boolean)session.getValue("SREQUIRED")).booleanValue());
	myFormat.isPre(((Boolean)session.getValue("CPOSITION")).booleanValue());
	myFormat.setSymbol((String)session.getValue("CURRENCY"));
	String base 	= request.getParameter("FromForm");
	String fd 	= request.getParameter("FromDate");
	String td 	= request.getParameter("ToDate");
	
	if(fd== null && td == null)
	{
		Date toDateObj=new Date();
		String toDay="",toMonth="",toYear="";
		String fromDay="",fromMonth="",fromYear="";

		toDay=""+toDateObj.getDate();
		if(toDateObj.getDate()<10)
			toDay="0"+toDateObj.getDate();

		toMonth=""+(toDateObj.getMonth()+1);
		if((toDateObj.getMonth()+1)<10)
			toMonth="0"+(toDateObj.getMonth()+1);

		toYear=""+(toDateObj.getYear()+1900);

		td = toDay+"/"+toMonth+"/"+toYear;

		Date fromDateObj=new Date(toDateObj.getYear(),toDateObj.getMonth(),toDateObj.getDate()-120);

		fromDay=""+fromDateObj.getDate();
		if(fromDateObj.getDate()<10)
			fromDay="0"+fromDateObj.getDate();

		fromMonth=""+(fromDateObj.getMonth()+1);	
		if((fromDateObj.getMonth()+1)<10)
			fromMonth="0"+(fromDateObj.getMonth()+1);

		fromYear=""+(fromDateObj.getYear()+1900);

		fd = fromDay+"/"+fromMonth+"/"+fromYear;

	}	
			
	
	
	int dataCount = 0;
	ezc.ezparam.EzInvoice SeqInv = new ezc.ezparam.EzInvoice();
	
	Date balDate = null;
	
	Date fromDateObj = null;
	Date toDateObj = null;
	double invBal = 0;
	if(fd != null && td != null)
	{
		//fd = dateConvertion(fd,(String)session.getValue("DATEFORMAT"));
		//td = dateConvertion(td,(String)session.getValue("DATEFORMAT"));
		
		GregorianCalendar gc=new GregorianCalendar(Integer.parseInt(fd.substring(6,10)),Integer.parseInt(fd.substring(3,5))-1,Integer.parseInt(fd.substring(0,2)));
		fromDateObj = gc.getTime();
		gc.add(Calendar.DATE,-1);
		balDate = gc.getTime();

		gc=new GregorianCalendar(Integer.parseInt(td.substring(6,10)),Integer.parseInt(td.substring(3,5))-1,Integer.parseInt(td.substring(0,2)));
		toDateObj = gc.getTime();
		
		
		
		

		//---------TO GET LIST OF ALL INVOICES OF INVFLAG 'D'
		
		ezc.client.EzVendorInvManager VendInvManager = new ezc.client.EzVendorInvManager();


		ezc.ezparam.EzcVendorParams newParams = new ezc.ezparam.EzcVendorParams();
		ezc.ezparam.EzVendorParams ioparams = new ezc.ezparam.EzVendorParams();
		ezc.ezvendor.params.EziVendorInvoiceInputParams eviip = new ezc.ezvendor.params.EziVendorInvoiceInputParams();

		ioparams.setBussPartnerNo(soldTo);

		eviip.setInvoiceFlag("B");
		ioparams.setToDate(toDateObj);		//fromDateObj
		ioparams.setFromDate(fromDateObj);
		ioparams.setCompCode(selCompCode);//company code added for mtr

		//out.println(ioparams.getFromDate()+":::::::::"+ioparams.getToDate());

		newParams.createContainer();
		newParams.setObject(ioparams);
		newParams.setObject(eviip);
		Session.prepareParams(newParams);
		SeqInv = (ezc.ezparam.EzInvoice)VendInvManager.getListOfInvoicesAndDocuments(newParams);

		//out.println("SeqInvSeqInvSeqInv		"+SeqInv.toEzcString());
		
		
		ezc.ezparam.EzVendorParams ioparams1 = new ezc.ezparam.EzVendorParams();
		ezc.ezparam.EzcVendorParams newParams1 = new ezc.ezparam.EzcVendorParams();
		ezc.ezvendor.params.EziVendorInvoiceInputParams eviip1 = new ezc.ezvendor.params.EziVendorInvoiceInputParams();


		ioparams1.setVendor(soldTo);
		ioparams1.setToDate(balDate);//fromDateObj);
		ioparams1.setFromDate(balDate);//fromDateObj);
		ioparams1.setCompCode(selCompCode);//company code added for mtr
		eviip1.setInvoiceFlag("B");
		newParams1.createContainer();
		newParams1.setObject(ioparams1);
		Session.prepareParams(newParams1);

		ezc.ezvendor.client.EzVendorManager VendManager = new ezc.ezvendor.client.EzVendorManager();
		ezc.ezparam.EzSupplBalance supplbal = (ezc.ezparam.EzSupplBalance)VendManager.getVendorBalance(newParams1);
		

		for(int i=0;i<supplbal.getRowCount();i++)
		{
			if (!"O".equalsIgnoreCase(supplbal.getFieldValueString(i,"SPGLIND")))
			{
				try
				{
					invBal +=Double.parseDouble(supplbal.getFieldValueString(i,"LCBAL"));
				}
				catch(Exception e)
				{
					invBal += 0;
				}
			}
		}
		//out.println(":::::::supplbal::::::::::"+supplbal.toEzcString());
		invBal *=-1;
		dataCount = SeqInv.getRowCount();
	}	
%>	
	
	
	<%
		


	try
	{
		ezc.ezcommon.EzLog4j.log("Start PDF Creation::::CustRegForm:","I");      
		Document document = new Document();
		response.reset(); 
		response.setHeader("Content-disposition","attachment;filename=Account_Statement.pdf");
		response.setContentType("application/pdf");
		 response.setHeader("Cache-Control", "cache, must-revalidate");
     		 response.setHeader("Pragma", "public");
		PdfWriter writer=PdfWriter.getInstance(document, response.getOutputStream());
//PdfContentByte pdfContentByte = writer.getDirectContent();
		
		Font header=new Font(FontFamily.COURIER,12,Font.BOLD);
		header.setColor(BaseColor.WHITE);

String FomDate 	= request.getParameter("FomDate");
String tooDate 	= request.getParameter("ToDate");
		PdfPTable tableDet = new PdfPTable(1);                          
		PdfPCell headerDet = new PdfPCell (new Paragraph ("Statement of Account as in Enterprise Books Statement Period:"+FomDate+" to "+tooDate,header));

		headerDet.setHorizontalAlignment (Element.ALIGN_CENTER);                                          
		headerDet.setBackgroundColor (new BaseColor (16, 134,206));
		

		tableDet.addCell(headerDet);
		tableDet.setWidthPercentage(64);
		tableDet.setSpacingBefore(5.0f);       
		tableDet.setSpacingAfter(5.0f);
	

		Font cmtDetfont=new Font(FontFamily.COURIER,10,Font.BOLD);
		cmtDetfont.setColor(BaseColor.WHITE);
		
		Font valuefont=new Font(FontFamily.COURIER,10,Font.BOLD);
		valuefont.setColor(BaseColor.BLACK);
		
		//deliveriesHeaderTable.setTotalWidth(new float[] {50,50,50,50,50,50});
		String fullName = (String)session.getValue("Vendor");
					String text_9	 = fullName+" ("+(String)Session.getUserId()+")";					               				
					String text_8	=   "Opening Balance : "+invBal;
					Font commentDetfont=new Font(FontFamily.COURIER,10,Font.BOLD);
					commentDetfont.setColor(BaseColor.WHITE);
					
					Chunk textChunk_8=new Chunk(text_8,commentDetfont);
					Chunk textChunk_9=new Chunk(text_9,commentDetfont);
					Phrase textPh_8=new Phrase(textChunk_8);
					Phrase textPh_9=new Phrase(textChunk_9);
					
					Paragraph p_8=new Paragraph();
					Paragraph p_9=new Paragraph();
					//p_8.add(imagePh);
					p_8.add(textPh_8);
					p_9.add(textPh_9);
				
					                          
					PdfPTable deliveriesTable = new PdfPTable(1);	
					PdfPCell deliveriesHeader = new PdfPCell (p_8);
					PdfPCell deliveriesHeader2 = new PdfPCell (p_9);
					deliveriesTable.setSpacingBefore(4.0f);   
					
					deliveriesHeader.setColspan (1);
					deliveriesHeader.setHorizontalAlignment (Element.ALIGN_LEFT);                                          
					deliveriesHeader.setBackgroundColor (new BaseColor (16, 134,206));
					
					deliveriesHeader2.setColspan (1);
					deliveriesHeader2.setHorizontalAlignment (Element.ALIGN_LEFT);                                          
					deliveriesHeader2.setBackgroundColor (new BaseColor (16, 134,206));
					
					
					
					deliveriesTable.setWidthPercentage(100);
					deliveriesTable.addCell(deliveriesHeader2);
					deliveriesTable.addCell(deliveriesHeader);
					
					
					 PdfPTable deliveriesDtlsTable = new PdfPTable(6); 
					 
					 PdfPCell cell1     	= new PdfPCell(new Paragraph ("Transaction Date",cmtDetfont));
					 PdfPCell cell2    	= new PdfPCell(new Paragraph ("Particulars",cmtDetfont));
					 PdfPCell cell3	   	= new PdfPCell(new Paragraph ("Bill Reference",cmtDetfont)); 
					 PdfPCell cell4		= new PdfPCell(new Paragraph ("Debit",cmtDetfont)); 
					 PdfPCell cell5    	= new PdfPCell(new Paragraph ("Credit",cmtDetfont)); 
					 PdfPCell cell6    	= new PdfPCell(new Paragraph ("Balance",cmtDetfont)); 
					
					cell1.setColspan (1);
					cell1.setHorizontalAlignment (Element.ALIGN_CENTER);      
					cell1.setBackgroundColor (new BaseColor (16, 134,206));
				
					cell2.setColspan (1);
					cell2.setHorizontalAlignment (Element.ALIGN_CENTER);    
					cell2.setBackgroundColor (new BaseColor (16, 134,206));					
				
					cell3.setColspan (1);
					cell3.setHorizontalAlignment (Element.ALIGN_CENTER);    
					cell3.setBackgroundColor (new BaseColor (16, 134,206));

					cell4.setColspan (1);
					cell4.setHorizontalAlignment (Element.ALIGN_CENTER);    
					cell4.setBackgroundColor (new BaseColor (16, 134,206));

					cell5.setColspan (1);
					cell5.setHorizontalAlignment (Element.ALIGN_CENTER);    
					cell5.setBackgroundColor (new BaseColor (16, 134,206));

					cell6.setColspan (1);
					cell6.setHorizontalAlignment (Element.ALIGN_CENTER);    
					cell6.setBackgroundColor (new BaseColor (16, 134,206));
					
					 deliveriesDtlsTable.addCell(cell1);
					 deliveriesDtlsTable.addCell(cell2);
					 deliveriesDtlsTable.addCell(cell3);
					 deliveriesDtlsTable.addCell(cell4);
					 deliveriesDtlsTable.addCell(cell5);
					 deliveriesDtlsTable.addCell(cell6);
					
					 deliveriesDtlsTable.completeRow();
					
					 Font cmtfont=new Font(FontFamily.COURIER,10,Font.BOLD);        
					String cmnts ="";
			
			String invDt = null;
			Date dt1 = null;
			int items = 0;
			String fontColor = null;
			String tdBGColor = null;
			String tdClass = null;
			String acType = null;
			double totAmount = 0;
			double balance = 0;
			double invAmt = 0;
			//String str[]={"INVOICEDATE"};
			//boolean b=SeqInv.sort(str,true);
			String clearDocLink = "";

			String dbcrIndicator = new String();
			String color="";
			for(int i=0;i<dataCount;i++)
			{
				color="";
				clearDocLink = "";
				if(i%2==0) {color = "style='background-color:#c9e0ff'";}
				dt1= (Date)SeqInv.getFieldValue(i,"POSTINGDATE"); // ADDED BY MUKESH
				
				String paymentMethodDesc = (String)paymentMthDescHT.get(SeqInv.getFieldValueString(i,"PMNT_METHOD"));
				
				String assignmentNo = SeqInv.getFieldValueString(i,"ASSIGNMENT_NO");
				
				String chqNumber = SeqInv.getFieldValueString(i,"CHEQUENUMBER");
				
				if("K".equals(SeqInv.getFieldValueString(i,"PMNT_METHOD")))
					chqNumber = paymentMethodDesc;
				else if(chqNumber==null || "null".equals(chqNumber) || "".equals(chqNumber))
					chqNumber = assignmentNo;
				
					
				if("RE".equals(SeqInv.getFieldValueString(i,"DOCTYPE"))) //MTR
					chqNumber = "";
				
				invDt = formatDate.getStringFromDate(dt1,(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));

				if((fromDateObj.compareTo(dt1) <= 0) && (toDateObj.compareTo(dt1) >=0))
				{
					items += 1;
					try{
						invAmt = Double.parseDouble(SeqInv.getFieldValueString(i,"AMOUNT"));
					}catch(Exception numFmtEx)
					{
						invAmt = 0;
					}
					totAmount += invAmt;
					if(SeqInv.getFieldValueString(i,"DBCRINDICATOR").equals("H"))
					{
						fontColor = "black";
						acType = "Credit";
						tdClass = "credit";
						balance = invBal + invAmt;
						dbcrIndicator = "";
						
						chqNumber = ""; //MTR
					}
					else
					{
						fontColor = "red";
						acType = "Debit";
						tdClass = "debit";
						balance = invBal - invAmt;
						dbcrIndicator = "-";
					}
					if (SeqInv.getFieldValueString(i,"DOCTYPE").equals("KZ"))
					{
						acType="Payment";
					}
					if (SeqInv.getFieldValueString(i,"DOCTYPE").equals("RE"))
					{
						acType="Invoice";
					}
					if (SeqInv.getFieldValueString(i,"DOCTYPE").equals("AB"))
					{
						acType="A/c Adjustments";
					}
					if (SeqInv.getFieldValueString(i,"DOCTYPE").equals("OV"))
					{
						acType="Carry Forward";
					}
					
					String clearDoc = SeqInv.getFieldValueString(i,"GRNUMBER");
					String compCode = SeqInv.getFieldValueString(i,"COMPCODE");
					String vendCode = SeqInv.getFieldValueString(i,"SUPPLIER");					
					
					if (SeqInv.getFieldValueString(i,"DOCTYPE").equals("ZP")) 
					{
						//clearDocLink = "<a href=\"JavaScript:funclearDocsRefence('"+clearDoc+"','"+compCode+"','"+vendCode+"')\">"+clearDoc+"</a>";
						clearDocLink = clearDoc;
					}
					
					else
						clearDocLink = clearDoc;
					 	
					 	
					 	
					 		
					 
								String invoiceDate 	= invDt;
								String acctype 		= acType;
								String refDoc 	= SeqInv.getFieldValueString(i,"REFDOC");
								String debitAmt 	="";
								String creditAmt 	= "";
								
						if (dbcrIndicator.equals("-")) 
						{
								 debitAmt 	= myFormat.getCurrencyString(SeqInv.getFieldValueString(i,"AMOUNT"));
						}else		
						{
										 debitAmt 	= " ";
						}
						if (dbcrIndicator.equals("")) 
						{
								 creditAmt 	= myFormat.getCurrencyString(SeqInv.getFieldValueString(i,"AMOUNT"));
						}else		
						{
										 creditAmt 	= " ";
						}		
								String balanceAmt	 	= myFormat.getCurrencyString(balance);
								
							       
							        cell1      	= new PdfPCell(new Paragraph (invoiceDate,cmtfont));
							        cell2      	= new PdfPCell(new Paragraph (acctype,cmtfont));
							        cell3      	= new PdfPCell(new Paragraph (refDoc,cmtfont));
							        cell4      	= new PdfPCell(new Paragraph (debitAmt,cmtfont));
							        cell5      	= new PdfPCell(new Paragraph (creditAmt,cmtfont));
							        cell6      	= new PdfPCell(new Paragraph (balanceAmt,cmtfont));
							     
															
								
								cell1.setColspan (1);
								cell1.setHorizontalAlignment (Element.ALIGN_LEFT);
								cell1.setBackgroundColor (new BaseColor (239, 243,247));

								cell2.setColspan (1);
								cell2.setHorizontalAlignment (Element.ALIGN_LEFT);
								cell2.setBackgroundColor (new BaseColor (239, 243,247));

								cell3.setColspan (1);
								cell3.setHorizontalAlignment (Element.ALIGN_LEFT);
								cell3.setBackgroundColor (new BaseColor (239, 243,247));

								cell4.setColspan (1);
								cell4.setHorizontalAlignment (Element.ALIGN_LEFT);
								cell4.setBackgroundColor (new BaseColor (239, 243,247));

								cell5.setColspan (1);
								cell5.setHorizontalAlignment (Element.ALIGN_LEFT);
								cell5.setBackgroundColor (new BaseColor (239, 243,247));

								cell6.setColspan (1);
								cell6.setHorizontalAlignment (Element.ALIGN_LEFT);
								cell6.setBackgroundColor (new BaseColor (239, 243,247));

								
								deliveriesDtlsTable.addCell(cell1);
								deliveriesDtlsTable.addCell(cell2);
								deliveriesDtlsTable.addCell(cell3);
								deliveriesDtlsTable.addCell(cell4);
								deliveriesDtlsTable.addCell(cell5);
								deliveriesDtlsTable.addCell(cell6);
								
								deliveriesDtlsTable.completeRow();								
							}
							invBal = balance;
						}
						PdfPCell total      	= new PdfPCell(new Paragraph (" ",cmtfont));
						total.setColspan (1);
						total.setHorizontalAlignment (Element.ALIGN_LEFT);
						total.setBackgroundColor (new BaseColor (239, 243,247));
						
						 						
					//0deliveriesDtlsTable.addCell(cell14);
					deliveriesDtlsTable.addCell(total);
					 deliveriesDtlsTable.completeRow();
					 
							deliveriesDtlsTable.setWidthPercentage(100);
							deliveriesDtlsTable.setTotalWidth(new float[] {75,80,105,90,80,95});
							deliveriesDtlsTable.setLockedWidth(true);
						        
							
						deliveriesDtlsTable.setSpacingAfter(30.0f);

			
		
		document.open();
							
		document.add(tableDet); 	 
		//document.add(deliveriesHeaderTable);
		document.add(deliveriesTable);
		document.add(deliveriesDtlsTable);
		document.close(); 

		ezc.ezcommon.EzLog4j.log("Pdf Created Successfully::::End::::","I");
	} 
	catch (Exception e) 
	{           
		ezc.ezcommon.EzLog4j.log(":::::::::ERROR while downloading PDF file in ezPrintPDF.jsp::::::::"+e,"I");
	}    
%>
