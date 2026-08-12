<%@ page import="java.io.*,org.apache.commons.io.*,java.util.*" %>
<%
String excelFilePath= request.getParameter("excelFilePath");
File file = null;


ezc.ezcommon.EzLog4j.log("excelFilePath  : " + excelFilePath,"I");
 InputStream in = null;
    OutputStream outstream = null;
    try {
   	 file = new File(excelFilePath);
    	
	String s2 = file.getName();
	
      response.reset();
      in = new FileInputStream(excelFilePath);
      response.setContentType("application/vnd.ms-excel");
      response.addHeader("content-disposition", "attachment; filename="+s2);
      outstream = response.getOutputStream();
      IOUtils.copyLarge(in, outstream);
     }
    catch (Exception e) {
        out.write("Unable to download file");
    }finally {
        IOUtils.closeQuietly(outstream);
        IOUtils.closeQuietly(in);
        IOUtils.closeQuietly(out);	
	if(file!=null && file.exists())
	file.delete();
    }
/*
javax.servlet.ServletOutputStream servletoutputstream = null;
ByteArrayOutputStream outputStream=null;
FileInputStream fileinputstream = null;
try
{
	
	file = new File(excelFilePath);
	
	String s2 = file.getName();
	
	response.setContentType("application/xlsx");
response.setCharacterEncoding("UTF-8");
response.setHeader("Content-Disposition","attachment;filename=" + s2);
	fileinputstream = new FileInputStream(file);
	servletoutputstream = response.getOutputStream();

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
	try{
		servletoutputstream.flush();
		outputStream.close();
		fileinputstream.close();
		if(file!=null && file.exists())
			file.delete();
	}catch(Exception clex){}
}
*/

%>