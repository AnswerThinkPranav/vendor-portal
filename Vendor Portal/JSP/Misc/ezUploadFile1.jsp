<%@ page import ="org.apache.commons.fileupload.servlet.*,org.apache.commons.fileupload.*,org.apache.commons.fileupload.disk.*" %>
<%@ page import="java.util.Enumeration,javax.servlet.*,javax.servlet.http.*,java.io.*" %>
<%@ page import="ezc.ezupload.MultipartRequest" %>
<%@ include file="../../../Includes/JSPs/Inbox/iGetUploadTempDir.jsp"%>
<%
	String filename	= "",attachTime="",attachmentType="",fileDesc="",currAttachTime="",currPath="",path="",fromPage="ezFileAttachment.jsp";
	Hashtable attachFilesHT = new Hashtable();
	
    	try
    	{

//		inboxPath="D:\\EZC\\EzUpload\\";
		//inboxPath="D:\\usr\\sap\\VMP\\J00\\j2ee\\cluster\\apps\\answerthink.com\\EzCFL\\servlet_jsp\\CFL\\root\\Uploads\\";
		String bankACCode="";
    	
    		File upFile=null;
       		ServletFileUpload ServletFileUpload  = new ServletFileUpload ();
		boolean isMultipart = ServletFileUpload.isMultipartContent(request);  
		ezc.ezcommon.EzLog4j.log("::::::::isMultipart::::::::"+isMultipart,"I");

		if (isMultipart)
		{    
			String index="";
			String realPath = request.getRealPath("ezUploadFile1.jsp");
			
			realPath = realPath.substring(0,realPath.lastIndexOf("\\"));
			realPath = realPath.substring(0,realPath.lastIndexOf("\\"));
			out.println(realPath +"::::realPath");
			
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
			while (iter.hasNext()) 
			{      

				FileItem item = (FileItem) iter.next();  
				//ezc.ezcommon.EzLog4j.log(":::::::item.isFormField::::"+item.isFormField(),"I");	
				if (item.isFormField())
				{      
					// Process form field.      
					String name = item.getFieldName();
					String value = item.getString();
					//ezc.ezcommon.EzLog4j.log(name+"::::::::name:::value:::::"+value,"I");	
					if(("index").equals(name))
					index=value;
					
					
					if("bankACCode".equals(name))
					{
						bankACCode=value;
					}
					if("currIndex".equals(name))
					{
						currIndex=value;
					}
					if("fromPage".equals(name))
					{
						fromPage=value;
					}
					if("docId".equals(name))
					{
						fromPage=fromPage+"?docId="+value;
					}
					
					if(("AttachTime"+currIndex).equals(name))					
					currAttachTime=value;
														
					if(("path"+currIndex).equals(name))	
						currPath=value;

					
					if(("AttachTime"+index).equals(name))					
					attachTime=value;
					
					if(("path"+index).equals(name))					
					path=value;
				
					if(("Desc"+index).equals(name))					
					fileDesc=value;
					//ezc.ezcommon.EzLog4j.log("::::::::fileDesc::::::::"+fileDesc,"I");
					if(("attachmentType"+index).equals(name))					
					attachmentType=value;
					
					//ezc.ezcommon.EzLog4j.log(index+":::index:::"+value+":::value:::::name::::::::"+name,"I");
				}
				else
				{   
					ezc.ezcommon.EzLog4j.log("::::::::currPath1::::::::"+currPath,"I");
					
					fileDesc=fileDesc.replaceAll("'","`");
					fileDesc=fileDesc.replaceAll("&","AND");
					fileDesc=fileDesc.replaceAll(",","");
					fileDesc=fileDesc.replaceAll("%","PER");

					if(!"".equals(currPath))
					{
					
						currPath=currPath.replaceAll("'","`");
						currPath=currPath.replaceAll("&","AND");
						currPath=currPath.replaceAll(",","");
						currPath=currPath.replaceAll("%","PER");
					
					
						ezc.ezcommon.EzLog4j.log("::::::::currPath::::::::"+currPath,"I");
						String fieldName = item.getFieldName();  
						String fileName = item.getName();  
						String contentType = item.getContentType(); 
						long sizeInBytes = item.getSize(); 
						boolean isInMemory = item.isInMemory();



						File upFile1=new File(inboxPath+session.getId());
						ezc.ezcommon.EzLog4j.log("::::::::upFile1::::::::"+upFile1,"I");

						if(!((upFile1.exists()) && (upFile1.isDirectory())))
						{
							boolean dir=upFile1.mkdirs();
						}
						upFile=new File(inboxPath+session.getId()+"\\"+currAttachTime+"_"+currPath);
						item.write(upFile);  
					}
					//ezc.ezcommon.EzLog4j.log("::::::::attachmentType1::::::::"+attachmentType,"I");
					//ezc.ezcommon.EzLog4j.log("::::::::fileDesc1::::::::"+fileDesc,"I");
					String hashValue=attachTime+"_"+path+"¥"+fileDesc+"¥"+attachmentType;
					if("".equals(attachTime.trim()) || "".equals(path.trim()))hashValue=fileDesc;
					
					attachFilesHT.put(index,hashValue);

				} 
			} 
			
			
			}
		}
		if( attachFilesHT!=null && attachFilesHT.size()>0)
		{
			if(session.getValue("ATTACHEDFILES")!=null)
			session.removeValue("ATTACHEDFILES");
//ezc.ezcommon.EzLog4j.log(":::::::::attachFilesHT::::::::"+attachFilesHT,"I");
			session.putValue("ATTACHEDFILES",attachFilesHT);		
		}
	
        response.sendRedirect(fromPage+"?bankACCode="+bankACCode);
         
        
    	}
    	catch(Exception e)
    	{
      		out.println("Error while reading file : "+e);
    	}
 
    	
    	
%>
