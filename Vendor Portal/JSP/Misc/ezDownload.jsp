<%@ page import="java.util.*,java.io.*"%>
<html>
<body onLoad="setTimeout('window.close()', 0);">
<%

	File f = null;
	String path = request.getParameter("path");
	out.println("pathpathpath	"+path);
	String filename = "";
	if(path!=null && !"".equals(path.trim())  && !"null".equals(path.trim()))
	{
		if(path.indexOf("~")>-1)
			path = path.replaceAll("~"," ");
			
		filename = path.substring(path.lastIndexOf("/")+1,path.length());
		
		
		/*if(filename.indexOf(" ")>-1)
			filename = filename.replaceAll("~"," ");
		*/	
		
		
		f = new File ("E:/VendorAssessment/"+path);
		
		
	}	
	else
	{
		f = new File ("E:/Ora10gHome/j2ee/home/default-web-app/VendorAssessmentForm.doc");
		//response.setContentType("application/x-download");
		filename = "VendorAssessmentForm.doc";
	}	
	out.println("filenamefilenamefilename	"+filename);
	
	out.println("pathpathpathpath	"+path);
	response.setContentType("application/x-download");
	response.setHeader("Content-Disposition", "attachment; filename="+filename);
	//get the file name
	String name = f.getName().substring(f.getName().lastIndexOf("/") + 1,f.getName().length());
	//out.println("namenamename	"+name);
	//OPen an input stream to the file and post the file contents thru the 
	//servlet output stream to the client m/c
	
		InputStream in = new FileInputStream(f);
		ServletOutputStream outs = response.getOutputStream();				
		int bit = 256;
		int i = 0;


    		try {


        			while ((bit) >= 0) {
        				bit = in.read();
        				outs.write(bit);
        			}
        			//System.out.println("" +bit);


            		} catch (IOException ioe) {
            			ioe.printStackTrace(System.out);
            		}
            	out.println( "\n" + i + " bytes sent.");
            	out.println( "\n" + f.length() + " bytes sent.");
		outs.flush();
		outs.close();
		in.close();
	 	
%>
</body>
</html>