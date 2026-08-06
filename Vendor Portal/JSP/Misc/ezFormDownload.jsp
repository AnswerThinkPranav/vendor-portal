<%@page contentType="application/octet-stream"%> 
<%@page pageEncoding="UTF-8"%> 
<%@page import="java.io.*,java.net.*,java.util.*,javax.servlet.* "%>

<% 
	String year	=	request.getParameter("year");
	String quarter	=	request.getParameter("quarter");
	String section	=	request.getParameter("section");
	String filename	=	request.getParameter("filename");
	
	BufferedInputStream filein = null; 
	BufferedOutputStream outputs = null; 
	try 
	{ 

		File file = new File("E:\\TDS_VIKRETA\\"+year+"\\"+quarter+"\\"+section+"\\"+filename);

		if (file.exists())
		{
			byte b[] = new byte[2048]; 
			int len = 0; 
			filein = new BufferedInputStream(new FileInputStream(file)); 
			outputs = new BufferedOutputStream(response.getOutputStream()); 
			response.setHeader("Content-Length", ""+file.length()); 
			//response.setContentType("application/force-download");
			response.setContentType( "application/pdf" );

			response.setHeader("Content-Disposition","attachment;filename="+filename); 
			response.setHeader("Content-Transfer-Encoding", "binary"); 
			while ((len = filein.read(b)) > 0)
			{ 
				outputs.write(b, 0, len); 
				outputs.flush(); 
			} 
		}	
	} 
catch(Exception e)
{ 
	ezc.ezcommon.EzLog4j.log(":::::::::::Error occured while downloading file in ezFormDownload.jsp:::::::::::"+e,"I");
} 
finally
{
	if (filein != null)
	filein.close();
	if (outputs != null)
	outputs.close();
}

%> 
