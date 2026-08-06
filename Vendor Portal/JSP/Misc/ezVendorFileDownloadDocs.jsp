
<%@ page import="java.io.*"%>
<%
	String fileReqName         = request.getRealPath("/")+"/Uploads"+"//Vendor//"+request.getParameter("listoffiles");
	File fileObj                          = new File(fileReqName);
	String fileName                 = fileObj.getName();
	//fileName = fileName.substring(fileName.indexOf("_")+1,fileName.length());
	response.setContentType("application/x-download");
	response.setHeader("Content-Disposition","attachment;filename="+fileName);
	ezc.ezcommon.EzLog4j.log("fileName6666  "+fileName,"I");
	FileInputStream fileinputstream = null;
	javax.servlet.ServletOutputStream servletoutputstream = null;
	fileinputstream                 = new FileInputStream(fileObj);
	servletoutputstream      = response.getOutputStream();
	int i = 256;
	while(i >= 0)
	{
			i = fileinputstream.read();
			servletoutputstream.write(i);
	}
	servletoutputstream.flush();
	servletoutputstream.close();
	fileinputstream.close();
%>
