<%@ page import ="ezc.sapconnection.*,com.sap.conn.jco.monitor.*,com.sap.conn.jco.*,com.sap.conn.jco.ext.DestinationDataProvider,java.io.*, java.net.*" %>
<jsp:useBean id="log4j" class="ezc.ezcommon.EzLog4j" scope="session" />
<%@ include file="../../../Includes/JSPs/Inbox/iGetUploadTempDir.jsp" %>
<%!
	public static byte[] getBytesFromFile(File file) throws IOException 
	{
		InputStream is = new FileInputStream(file);
		long length = file.length();
		byte[] bytes = new byte[(int)length];
		int offset = 0;
		int numRead = 0;
		while (offset < bytes.length && (numRead=is.read(bytes, offset, bytes.length-offset)) >= 0) 
		{
			offset += numRead;
		}
		if (offset < bytes.length) 
		{
			throw new IOException("Could not completely read file "+file.getName());
		}
		is.close();
		return bytes;
	}
%>
<%
	byte[] zDocString_U = null;
	String fileName_U = "test.pdf";
	
	String docNumber_U = "51057557342020";
	String docType_U = "KR";
	/*
	if(docNumber_U !=null && !"null".equals(docNumber_U))
	{
		docNumber_U = "00000000"+docNumber_U;
		docNumber_U = docNumber_U.substring(docNumber_U.length()-12,docNumber_U.length());
	}*/
	ArrayList multiDocs_A = new ArrayList();

	try 
	{
		
			
			String logonSite = (String)session.getValue("SITE");
			JCoDestination destination = EzSAPHandler.getDestination(logonSite+"~999");
			JCoFunction funFunction = EzSAPHandler.getJCoFunction(destination,"Z_EZ_DOCATT_UPLOAD");
			JCoParameterList docDetail 	= funFunction.getImportParameterList();
			byte[] fileBytes = getBytesFromFile(new File("F:\\ANSR\\test.pdf"));
			
			docDetail.setValue("Z_STRING",fileBytes);
			docDetail.setValue("FILENAME",fileName_U);//fileName_U
			docDetail.setValue("DOC_NUMBER",docNumber_U);
			docDetail.setValue("DOC_TYPE",docType_U);
			//out.print(docDetail.getValue("Z_STRING"));
			ezc.ezcommon.EzLog4j.log("FILENAME::"+fileName_U,"I");
			ezc.ezcommon.EzLog4j.log("DOC_NUMBER::"+docNumber_U,"I");
			ezc.ezcommon.EzLog4j.log("DOC_TYPE::"+docType_U,"I");

			out.println("Z_STRING::::::::::::::"+docDetail.getValue("Z_STRING"));

			funFunction.execute(destination);
	}
	catch(Exception e){
		out.print(e);
		ezc.ezcommon.EzLog4j.log("Exception in uploading file::"+e,"I");
	}
%>
