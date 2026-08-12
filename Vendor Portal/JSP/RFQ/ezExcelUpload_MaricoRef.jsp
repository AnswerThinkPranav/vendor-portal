 <%@ page import="java.util.*,ezc.ezparam.ReturnObjFromRetrieve" %>
 <%@ page import="jxl.Sheet,jxl.Workbook,jxl.read.biff.BiffException,jxl.write.Label,jxl.write.WritableSheet,jxl.write.WritableWorkbook,jxl.format.*"%>
 <%!
 public void ezCreateExcel(HttpServletResponse response,String fileName,ArrayList headerData,ArrayList dispColNames,ReturnObjFromRetrieve vendorlist)
 {
 	WritableWorkbook workbook = null;
 	try
	 	{	
	 		ezc.ezcommon.EzLog4j.log("START download excel"+fileName,"I");
	 		response.resetBuffer();
	 		response.setContentType("application/vnd.ms-excel");
	 		response.setHeader("Content-Disposition", "attachment; filename="+fileName);
	 		workbook = Workbook.createWorkbook(response.getOutputStream());
	 		ezc.ezcommon.EzLog4j.log("START1 download excel"+response.getOutputStream(),"I");
	 		
				
			//WritableSheet wsASN = workbook.createSheet("PO-ASN Wise", 0);
			//WritableSheet wsPO = workbook.createSheet("PO Wise", 0);
			//WritableSheet wsVEND = workbook.createSheet("Vendor Wise", 0);
			//WritableSheet wsBuy = workbook.createSheet("Buyer Wise", 0);
			//WritableSheet wsMatGrp = workbook.createSheet("Material Group Wise", 0);
			//WritableSheet wsCatGrp = workbook.createSheet("Material Category Wise", 0);
			WritableSheet wsSum = workbook.createSheet("Summary", 0);
			
			
			ezc.ezcommon.EzLog4j.log("START2 download excel","I");
	 		
	 		String empty="";
	 		if(dispColNames!=null)
	 		{
	 			ezc.ezcommon.EzLog4j.log("dispColNames download excel"+dispColNames.size(),"I");
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

					wsSum.addCell(new Label(j, 0, (String)dispColNames.get(j), boldRed));

				}
			}
			if(vendorlist!=null)
			{
				for(int k=1;k<=vendorlist.getRowCount();k++)
				{
					for(int j=0;j<dispColNames.size();j++)
					{
						jxl.write.WritableFont boldRedFont = new jxl.write.WritableFont(jxl.write.WritableFont.TIMES, 11);
						jxl.write.WritableCellFormat boldRed = new jxl.write.WritableCellFormat(boldRedFont);

						wsSum.addCell(new Label(j, k, vendorlist.getFieldValueString(k-1,(String)dispColNames.get(j)), boldRed));


					}
				}
			}	
			/*if(dispColNames1!=null)
			{
	 			ezc.ezcommon.EzLog4j.log("dispColNames1 download excel"+dispColNames1.size(),"I");
	 			for(int j=0;j<dispColNames1.size();j++)
				{
					jxl.write.WritableFont boldRedFont = new jxl.write.WritableFont(jxl.write.WritableFont.TIMES, 11 , jxl.write.WritableFont.BOLD);
					boldRedFont.setColour(jxl.format.Colour.BLACK);
					jxl.write.WritableCellFormat boldRed = new jxl.write.WritableCellFormat(boldRedFont);
					boldRed.setBackground(jxl.format.Colour.PALE_BLUE);
					boldRed.setShrinkToFit(false);

					if(j==0)
						boldRed.setBorder(jxl.format.Border.LEFT, jxl.format.BorderLineStyle.THIN , jxl.format.Colour.BLACK);

					else if(j==(dispColNames1.size()-1))
						boldRed.setBorder(jxl.format.Border.RIGHT, jxl.format.BorderLineStyle.THIN , jxl.format.Colour.BLACK);

					wsMatGrp.addCell(new Label(j, 0, (String)dispColNames1.get(j), boldRed));
					
					if(j==0)
						wsCatGrp.addCell(new Label(j, 0, "MAT_CAT", boldRed));
					else
						wsCatGrp.addCell(new Label(j, 0, (String)dispColNames1.get(j), boldRed));
					if(j==0)
						wsBuy.addCell(new Label(j, 0, "BUYER", boldRed));
					else
						wsBuy.addCell(new Label(j, 0, (String)dispColNames1.get(j), boldRed));


				}

			}
			if(MatGrpRetObj!=null)
			{
				for(int k=1;k<=MatGrpRetObj.getRowCount();k++)
				{
					for(int j=0;j<dispColNames1.size();j++)
					{
						jxl.write.WritableFont boldRedFont = new jxl.write.WritableFont(jxl.write.WritableFont.TIMES, 11);
						jxl.write.WritableCellFormat boldRed = new jxl.write.WritableCellFormat(boldRedFont);

						wsMatGrp.addCell(new Label(j, k, MatGrpRetObj.getFieldValueString(k-1,(String)dispColNames1.get(j)), boldRed));


					}
				}
			}
			if(MatCatRetObj!=null)
			{
				for(int k=1;k<=MatCatRetObj.getRowCount();k++)
				{
					for(int j=0;j<dispColNames1.size();j++)
					{
						jxl.write.WritableFont boldRedFont = new jxl.write.WritableFont(jxl.write.WritableFont.TIMES, 11);
						jxl.write.WritableCellFormat boldRed = new jxl.write.WritableCellFormat(boldRedFont);
						String colName=(String)dispColNames1.get(j);
						if(j==0)colName="MAT_CAT";
						wsCatGrp.addCell(new Label(j, k, MatCatRetObj.getFieldValueString(k-1,colName), boldRed));


					}
				}
			}
			if(BuyRetObj!=null)
			{
				for(int k=1;k<=BuyRetObj.getRowCount();k++)
				{
					for(int j=0;j<dispColNames1.size();j++)
					{
						jxl.write.WritableFont boldRedFont = new jxl.write.WritableFont(jxl.write.WritableFont.TIMES, 11);
						jxl.write.WritableCellFormat boldRed = new jxl.write.WritableCellFormat(boldRedFont);
						String colName=(String)dispColNames1.get(j);
						if(j==0)colName="BUYER";
						wsBuy.addCell(new Label(j, k, BuyRetObj.getFieldValueString(k-1,colName), boldRed));


					}
				}
			}
			if(dispColNames2!=null)
			{
				ezc.ezcommon.EzLog4j.log("dispColNames2 download excel"+dispColNames2.size(),"I");
				for(int j=0;j<dispColNames2.size();j++)
				{
					jxl.write.WritableFont boldRedFont = new jxl.write.WritableFont(jxl.write.WritableFont.TIMES, 11 , jxl.write.WritableFont.BOLD);
					boldRedFont.setColour(jxl.format.Colour.BLACK);
					jxl.write.WritableCellFormat boldRed = new jxl.write.WritableCellFormat(boldRedFont);
					boldRed.setBackground(jxl.format.Colour.PALE_BLUE);
					boldRed.setShrinkToFit(false);

					if(j==0)
						boldRed.setBorder(jxl.format.Border.LEFT, jxl.format.BorderLineStyle.THIN , jxl.format.Colour.BLACK);

					else if(j==(dispColNames2.size()-1))
						boldRed.setBorder(jxl.format.Border.RIGHT, jxl.format.BorderLineStyle.THIN , jxl.format.Colour.BLACK);

					wsVEND.addCell(new Label(j, 0, (String)dispColNames2.get(j), boldRed));

				}
			}
			if(vendRetObj!=null)
			{
				for(int k=1;k<=vendRetObj.getRowCount();k++)
				{
					for(int j=0;j<dispColNames2.size();j++)
					{
						jxl.write.WritableFont boldRedFont = new jxl.write.WritableFont(jxl.write.WritableFont.TIMES, 11);
						jxl.write.WritableCellFormat boldRed = new jxl.write.WritableCellFormat(boldRedFont);

						wsVEND.addCell(new Label(j, k, vendRetObj.getFieldValueString(k-1,(String)dispColNames2.get(j)), boldRed));


					}
				}
			}
			if(dispColNames3!=null)
			{
				ezc.ezcommon.EzLog4j.log("dispColNames3 download excel"+dispColNames3.size(),"I");
				for(int j=0;j<dispColNames3.size();j++)
				{
					jxl.write.WritableFont boldRedFont = new jxl.write.WritableFont(jxl.write.WritableFont.TIMES, 11 , jxl.write.WritableFont.BOLD);
					boldRedFont.setColour(jxl.format.Colour.BLACK);
					jxl.write.WritableCellFormat boldRed = new jxl.write.WritableCellFormat(boldRedFont);
					boldRed.setBackground(jxl.format.Colour.PALE_BLUE);
					boldRed.setShrinkToFit(false);

					if(j==0)
						boldRed.setBorder(jxl.format.Border.LEFT, jxl.format.BorderLineStyle.THIN , jxl.format.Colour.BLACK);

					else if(j==(dispColNames3.size()-1))
						boldRed.setBorder(jxl.format.Border.RIGHT, jxl.format.BorderLineStyle.THIN , jxl.format.Colour.BLACK);

					wsPO.addCell(new Label(j, 0, (String)dispColNames3.get(j), boldRed));

				}
			}
			if(PORetObj!=null)
			{
				for(int k=1;k<=PORetObj.getRowCount();k++)
				{
					for(int j=0;j<dispColNames3.size();j++)
					{
						jxl.write.WritableFont boldRedFont = new jxl.write.WritableFont(jxl.write.WritableFont.TIMES, 11);
						jxl.write.WritableCellFormat boldRed = new jxl.write.WritableCellFormat(boldRedFont);

						wsPO.addCell(new Label(j, k, PORetObj.getFieldValueString(k-1,(String)dispColNames3.get(j)), boldRed));


					}
				}
			}
			if(dispColNames4!=null)
			{
				ezc.ezcommon.EzLog4j.log("dispColNames4 download excel"+dispColNames4.size(),"I");
				for(int j=0;j<dispColNames4.size();j++)
				{
					jxl.write.WritableFont boldRedFont = new jxl.write.WritableFont(jxl.write.WritableFont.TIMES, 11 , jxl.write.WritableFont.BOLD);
					boldRedFont.setColour(jxl.format.Colour.BLACK);
					jxl.write.WritableCellFormat boldRed = new jxl.write.WritableCellFormat(boldRedFont);
					boldRed.setBackground(jxl.format.Colour.PALE_BLUE);
					boldRed.setShrinkToFit(false);

					if(j==0)
						boldRed.setBorder(jxl.format.Border.LEFT, jxl.format.BorderLineStyle.THIN , jxl.format.Colour.BLACK);

					else if(j==(dispColNames4.size()-1))
						boldRed.setBorder(jxl.format.Border.RIGHT, jxl.format.BorderLineStyle.THIN , jxl.format.Colour.BLACK);

					wsASN.addCell(new Label(j, 0, (String)dispColNames4.get(j), boldRed));

				}
			}
			if(ASNRetObj!=null)
			{
				for(int k=1;k<=ASNRetObj.getRowCount();k++)
				{
					for(int j=0;j<dispColNames4.size();j++)
					{
						jxl.write.WritableFont boldRedFont = new jxl.write.WritableFont(jxl.write.WritableFont.TIMES, 11);
						jxl.write.WritableCellFormat boldRed = new jxl.write.WritableCellFormat(boldRedFont);
						String value=ASNRetObj.getFieldValueString(k-1,(String)dispColNames4.get(j));
						int compInt=0;
						if(j==(dispColNames4.size()-1))
						{
							ezc.ezcommon.EzLog4j.log("Number Cell..."+dispColNames4.size(),"I");
							
							jxl.write.Number numbercell = new jxl.write.Number(j, k, compInt);
 
							wsASN.addCell(numbercell);
						}
						else
							wsASN.addCell(new Label(j, k, ASNRetObj.getFieldValueString(k-1,(String)dispColNames4.get(j)), boldRed));


					}
				}
			}*/			
			
	 			
	 	}
	 	catch(Exception e)
	 	{
	 		System.out.println("Following Exception occured in creating JExcel...."+e);
	 		ezc.ezcommon.EzLog4j.log("Following Exception occured in creating JExcel...."+e,"E");
	 		e.printStackTrace();
	 	}
	 	finally
	 	{
	 		try{
	 			workbook.write();
	 			workbook.close();
	 			response.getOutputStream().close();
	 			
	 		}catch(Exception ex){ezc.ezcommon.EzLog4j.log("Following Exception occured in creating JExcel...."+ex,"E");}
 	}
 	
 	
 }
 %>
 
 
 
 <%
 out.println("EZDOWNLOAD");
 ezc.ezcommon.EzLog4j.log("reportData:","I");
   	ReturnObjFromRetrieve reportData=(ReturnObjFromRetrieve)session.getValue("reportData");
   	
   	//String reportFlag = "";
   	
   	//reportFlag = (String)session.getValue("reportFlag");
   	
	//ReturnObjFromRetrieve MatCatRetObj=(ReturnObjFromRetrieve)session.getValue("Report_MAT_CAT");
   	//ReturnObjFromRetrieve MatGrpRetObj=(ReturnObjFromRetrieve)session.getValue("Report_MAT_GRP");
   	//ReturnObjFromRetrieve BuyRetObj=(ReturnObjFromRetrieve)session.getValue("Report_BUYER");
   	//ReturnObjFromRetrieve vendRetObj=(ReturnObjFromRetrieve)session.getValue("Report_VEND");
   	//ReturnObjFromRetrieve PORetObj=(ReturnObjFromRetrieve)session.getValue("Report_PO");
   	//ReturnObjFromRetrieve ASNRetObj=(ReturnObjFromRetrieve)session.getValue("Report_ASN");
   	ezc.ezcommon.EzLog4j.log("reportData:"+reportData.toEzcString(),"I");
   	ezc.ezcommon.EzLog4j.log("reportData:"+reportData.getRowCount(),"I");
   	//out.println("vendorlist:"+vendorlist.getRowCount());
   	//out.println("BuyRetObj:"+vendorlist.toEzcString());
   	//out.println("PORetObj:"+PORetObj.toEzcString());
 	
 
 	ArrayList headerData 	= new ArrayList();
 	ArrayList headerData1 	= new ArrayList();
 	ArrayList headerData2 	= new ArrayList();
 	ArrayList dispColNames 	= new ArrayList();
 	ArrayList dispColNames1	= new ArrayList();
 	ArrayList dispColNames2	= new ArrayList();
 	ArrayList dispColNames3	= new ArrayList();
 	ArrayList dispColNames4	= new ArrayList();
 	ArrayList retObjCols 	= new ArrayList();
 	
 	
 	headerData.add("Summary");
	
	
		dispColNames.add("MatCode");
		dispColNames.add("leadTime");
	
		dispColNames.add("MatCat");
		dispColNames.add("MatDesc");
	
		dispColNames.add("MatGroup");
		
	
	
	
	
 	
 	
 
 	try
 	{
 		
 		ezCreateExcel(response,"GovernanceReport.xls",headerData,dispColNames,reportData);
 	}
 	catch(Exception e)
 	{
 		ezc.ezcommon.EzLog4j.log("Excel Driver Exception in Page ezDownloadExcel.jsp..."+e,"E");
 		out.println("Excel Driver Exception in Page ezDownloadExcel.jsp:"+e);
 	}
%>