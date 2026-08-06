<%@ page import ="org.apache.commons.fileupload.servlet.*,org.apache.commons.fileupload.*,org.apache.commons.fileupload.disk.*" %>


<%@ page import="java.util.Enumeration,javax.servlet.*,javax.servlet.http.*,java.io.*" %>
<%@ page import="ezc.ezupload.MultipartRequest" %>
<%@ include file="../../../Includes/JSPs/Inbox/iGetUploadTempDir.jsp"%>
<%
	String filename	= "",attachTime="",fileDesc="",attachmentType="",path="";
	Hashtable attachFilesHT = new Hashtable();
	
    	try
    	{ 
    		//inboxPath="D:\\EZC\\EzUpload\\";
    		File upFile=null;
       		ServletFileUpload ServletFileUpload  = new ServletFileUpload ();
		boolean isMultipart = ServletFileUpload.isMultipartContent(request);  
		
		if (isMultipart)
		{    

			String realPath = request.getRealPath("ezAttachDocs.jsp");
									
			realPath = realPath.substring(0,realPath.lastIndexOf("\\"));

			ezc.ezcommon.EzLog4j.log("::::::::realPath::::::::"+realPath,"I");

			//FileItemFactory factory = new DiskFileItemFactory();    
			FileItemFactory factory = new DiskFileItemFactory(DiskFileItemFactory.DEFAULT_SIZE_THRESHOLD,new File(realPath));    

			ServletFileUpload upload = new ServletFileUpload(factory); 

			List  items  = null;
			try{
			  items = upload.parseRequest(request); 
			  }catch(Exception e){System.out.println("::::::"+e);}

			if(items!=null)
			{
				String currIndex="";

			Iterator iter = items.iterator();
			String index="";
			while (iter.hasNext()) 
			{      

				FileItem item = (FileItem) iter.next();  
				if (item.isFormField())
				{      
					// Process form field.      
					String name = item.getFieldName();
					String value = item.getString();
					
					if(("index").equals(name))
					index=value;
					
					if(("AttachTime"+index).equals(name))					
					attachTime=value;
					
					if(("path"+index).equals(name))	
					{
					path=value;
					if(path!=null)
					path = path.replaceAll(",","");
					}
				
					if(("Desc"+index).equals(name))					
					fileDesc=value;
					
					if(("attachmentType"+index).equals(name))					
					attachmentType=value;
					
					ezc.ezcommon.EzLog4j.log(index+":::index:::"+value+":::value:::::name::::::::"+name,"I");
				}
				else
				{   	
					if(path!=null)
					path = path.replaceAll(",","");
					
					String hashValue=attachTime+"_"+path+"¥"+fileDesc+"¥"+attachmentType;
					if("".equals(attachTime.trim()) || "".equals(path.trim()))hashValue=fileDesc;
					//attachFilesHT.put(attachTime+"_"+path,fileDesc);
					attachFilesHT.put(index,hashValue);

				} 
			} 
			
			
			}
		}
		ezc.ezcommon.EzLog4j.log(":::::::::attachFilesHT::::::::"+attachFilesHT,"I");
		if(session.getValue("ATTACHEDFILES")!=null)
		session.removeValue("ATTACHEDFILES");
		session.putValue("ATTACHEDFILES",attachFilesHT);

	
         
        
    	}
    	catch(Exception e)
    	{
      		System.out.println("Error while reading file : "+e);
    	}
 
    	
    	
%>
<!DOCTYPE html>
<html lang="en">
  <head>
  <script type="text/javascript">
  parent.jQuery.fancybox.close(); 
  </script>
  </head>
  </html>