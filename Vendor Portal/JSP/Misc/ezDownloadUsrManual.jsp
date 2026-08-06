<%@ page import="java.io.*,java.util.*" %>
<%
//out.println("download");
String userType=request.getParameter("userType");
String flagVar=request.getParameter("flag");
ezc.ezcommon.EzLog4j.log("flagVar>>>>>>>>"+flagVar,"I");	
File file = null;
FileInputStream fileinputstream = null;
javax.servlet.ServletOutputStream servletoutputstream = null;

try
{
	response.setContentType("application/pdf");
	response.setHeader("Content-Disposition","attachment;filename=Manual.pdf" );
	if("U".equals(flagVar))
	{
		file=new File("D:\\EZC\\EzCom\\Upload\\UserDocs\\User Manual _latest (Freight & Handling).pdf");//D:\\EZC\\EzCom\\Upload\\UserDocs\\Purperson1.txt
	}
	else if("S".equals(flagVar))
	{
		file=new File("D:\\EZC\\EzCom\\Upload\\UserDocs\\Step by Step approach for uploading of Invoices.pdf");//D:\\EZC\\EzCom\\Upload\\UserDocs\\Purperson1.txt
	}
	else if("M".equals(flagVar))
	{
		file=new File("D:\\EZC\\EzCom\\Upload\\UserDocs\\Portal user manual latest.pdf");//D:\\EZC\\EzCom\\Upload\\UserDocs\\Purperson1.txt
	}
	else if("MU".equals(flagVar))
	{
		file=new File("D:\\EZC\\EzCom\\Upload\\UserDocs\\Step by Step approach for uploading of Invoices.pdf");//D:\\EZC\\EzCom\\Upload\\UserDocs\\Purperson1.txt
	}
	/*else
	{
		file=new File("D:\\EZC\\EzCom\\Upload\\UserDocs\\Portal user manual latest.pdf");//D:\\EZC\\EzCom\\Upload\\UserDocs\\Purperson1.txt
	}*/
	//file=new File("../UserDocs/user doc.docx");

	servletoutputstream = response.getOutputStream();
	fileinputstream = new FileInputStream(file);
	int i ;
	boolean flag = false;
	while((i = fileinputstream.read())!=-1)
	servletoutputstream.write(i);
}
catch(IOException ioexception)
{
	ezc.ezcommon.EzLog4j.log("Got exception  : " + ioexception,"E");
}
finally
{
System.out.println("Got exception  : ");
	try{
		servletoutputstream.flush();
		servletoutputstream.close();
		fileinputstream.close();
		/*if(file!=null && file.exists())
			file.delete();*/
	}catch(Exception clex){System.out.println("Got exception 2 : ");}
}
%>