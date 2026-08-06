<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>

<%@ page import="java.util.Enumeration,javax.servlet.*,javax.servlet.http.*,java.io.*,java.util.*" %>
<%@ page import="ezc.ezupload.MultipartRequest" %>

<%
	String filename="";
	String username = request.getParameter("filestring");
	
	/*if(username.indexOf(" ")>-1)
		username = username.replaceAll(" ","_");
	out.println("usernameusername	"+username);*/
    	try
    	{
       		File f=null;
       		String dirpath = "E:/VendorAssessment";
       		java.text.SimpleDateFormat sdf=new java.text.SimpleDateFormat("dd.MM.yyyy");
		java.util.Date dt = new java.util.Date();
		String createdOn= sdf.format(dt);
	
	        File f1=new File(dirpath+"/"+username+"^^"+createdOn+"^^"+session.getId());
	        f1.mkdir();
	       
        	if((f1.exists()) && (f1.isFile()))
         	{
	        }
         	else
         	{
          		boolean dir=f1.mkdirs();
	  		System.out.println("directory created:"+dir);
	 	}
       		String dirName=f1.getPath();

         	MultipartRequest multi = new MultipartRequest(request, dirName, 10*1024*1024);
         	Enumeration params = multi.getParameterNames();
        	while (params.hasMoreElements())
        	{
           		String name = (String)params.nextElement();
           		String value = multi.getParameter(name);
	        }
        	Enumeration files = multi.getFileNames();

	        while (files.hasMoreElements())
        	{
           		String name = (String)files.nextElement();
           		filename = multi.getFilesystemName(name);
           		/*if(filename.indexOf(" ")>-1)
				filename = filename.replaceAll(" ","_");
			
			out.println("filenamefilename	"+filename);	*/
				
				
           		String type = multi.getContentType(name);
          		f = multi.getFile(name);
        	}
        	
	//     response.sendRedirect("ezAttachment.jsp?fname="+f1.getName());
    	}
    	catch(Exception e)
    	{
      		System.out.println("Error while reading file : "+e);
    	}

	response.sendRedirect("ezAfterAttach.jsp?filename="+filename);
%>
<Div id="MenuSol"></Div>