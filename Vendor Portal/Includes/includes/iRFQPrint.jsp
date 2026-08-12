<%@page  import="ezc.ezparam.ReturnObjFromRetrieve,ezc.ezparam.*,ezc.ezcommon.*"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<jsp:useBean id="ShManager" class="ezc.ezshipment.client.EzShipmentManager" scope="session" />
<%@ include file="../Labels/iPrint_Labels.jsp"%>
<%       
	PrintWriter pwriter = null;
	javax.servlet.ServletOutputStream sos = null;
	StringReader stringReader = null;
	String type = "PDF";      
	String ponum  = request.getParameter("PurchaseOrder");
	ponum="0000000000"+ponum;
	ponum=ponum.substring(ponum.length()-10,ponum.length());
	String vendor = request.getParameter("rfqVendor");
	boolean showPDF=true;

	if(vendor==null)
		vendor  = (String)session.getValue("SOLDTO");

	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(true);
	EziPrintParams params= new EziPrintParams();
	params.setObjectType("RFQ");
	params.setObjectNo(ponum);
	params.setDocType(type);
	//params.setMsgType("ZNEU");
	params.setVendor(vendor);
	mainParams.setObject(params);
	Session.prepareParams(mainParams);
	try{
		if ("PDF".equals(type))
		{
			ReturnObjFromRetrieve myTable=(ReturnObjFromRetrieve)ShManager.ezGetPrintVersion(mainParams);
			
			int rowCount=myTable.getRowCount();
			java.io.ByteArrayOutputStream baos = new java.io.ByteArrayOutputStream();
			try{
				java.io.ObjectOutputStream oos = new java.io.ObjectOutputStream(baos);
				oos.writeObject(myTable.getFieldValue(0,"OUTTAB"));
			}catch(java.io.IOException ioe){

			}
						byte Z_STRING[]=baos.toByteArray();
			if(Z_STRING.length<100){
				showPDF=false;
			}else{

			
				response.setContentType("application/x-download");
				response.setHeader ("Content-Disposition", "attachment;filename="+ponum+".pdf");

				sos=response.getOutputStream();
				sos.write(Z_STRING);
			}
			
			/*int rowCount=myTable.getRowCount();
			response.setContentType("application/x-download");
			response.setHeader ("Content-Disposition", "attachment;filename="+ponum+".pdf");
			pwriter = new PrintWriter(response.getOutputStream());
			int charInt;
			for(int i=0;i<rowCount;i++)
			{
				charInt=0;
				stringReader = new StringReader(new String((myTable.getFieldValueString(i,"OUTTAB")).getBytes("UTF-16LE")));
				//while ((charInt = stringReader.read()) != -1)
				//pwriter.write((char)charInt);
				char sapData1 = ' ';
				char sapData2 = ' ';
				while ((charInt = stringReader.read()) != -1)
				{
					sapData1=(char)charInt;
					if((charInt = stringReader.read()) != -1)
					{
						pwriter.print((char)charInt);
					}
					pwriter.print(sapData1);
				} 
			}*/
		}
	}
	catch(Exception e)
	{
		showPDF=false;
	}
	finally
	{
		if (pwriter!=null)
			pwriter.close();
		if (sos!=null)
			sos.close();
	}
	if(!showPDF)
	{
		String display_header = "";
		String noDataStatement = "Sorry ! Document Disabled for Printing"+"<BR><BR>"+conSysAdm_L;
%>
		<html>
		<head>
		<%@include file="../../Lib/AddButtonDir.jsp" %>
		</head>
		<body scroll=no>
		<%@ include file="../../../Vendor2/JSPs/Misc/ezDisplayHeader.jsp"%>
		<%@ include file="../../../Vendor2/JSPs/Misc/ezDisplayNoData.jsp"%>
		<Div id="MenuSol"></Div>
		</body>
		</html>
<%
	}
%>
