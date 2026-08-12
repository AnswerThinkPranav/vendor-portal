<%@ page import ="java.io.*,java.nio.channels.*" %>
<%
	int uploadedFileCnt=0;
	ezc.ezparam.EzcParams ul_mainParams = new ezc.ezparam.EzcParams(true);
	String attachflag 	= checkNull(request.getParameter("attachFlag"));
	if("".equals(attachflag))
		attachflag="N";
	ezc.ezcommon.EzLog4j.log("::::::attachflag qry:::::::::::"+attachflag,"I");
	try
	{
		if("Y".equals(attachflag))
		{
			ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
			ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();

			String attachDocDesc = request.getParameter("attachDocDesc");
			String attachDocFiles = request.getParameter("attachDocFiles");
			String attachFileTime = request.getParameter("attachFileTime");
			String tempAttachFile="";

			ezc.ezcommon.EzLog4j.log("::::::attachDocDesc qry:::::::::::"+attachDocDesc,"I");
			ezc.ezcommon.EzLog4j.log("::::::attachDocFiles qry:::::::::::"+attachDocFiles,"I");

			Hashtable docDescFiles = new Hashtable();

			if(attachDocFiles.indexOf("¥")>0)
			{
				String[] attachDocFilesArr = attachDocFiles.split("¥");
				String[] attachDocDescArr = attachDocDesc.split("¥");
				String[] attachFileTimeArr = attachFileTime.split("¥");


				if(attachDocFilesArr!=null)
				{
					for(int i=0;i<attachDocFilesArr.length;i++)
					{		
						int lastindex = attachDocFilesArr[i].lastIndexOf("\\");

						try
						{
							if(lastindex>=0)
								tempAttachFile = attachDocFilesArr[i].substring(lastindex+1,attachDocFilesArr[i].length());
							else
								tempAttachFile=attachDocFilesArr[i];
						}catch(Exception e){
							tempAttachFile=attachDocFilesArr[i];ezc.ezcommon.EzLog4j.log("::::::Exception while getting filename:::::::::::"+e,"I");
						}
						ezc.ezcommon.EzLog4j.log("::::::filename tempAttachFile:::::::::::"+tempAttachFile,"I");

						docDescFiles.put(attachFileTimeArr[i]+"_"+tempAttachFile,attachDocDescArr[i]);

					}
				}
			}
			else
			{
				int lastindex = attachDocFiles.lastIndexOf("\\");
					ezc.ezcommon.EzLog4j.log("::::::lastindex2:::::::::::"+lastindex,"I");

				try{
				if(lastindex>=0)
					tempAttachFile = attachDocFiles.substring(lastindex+1,attachDocFiles.length());
				else
					tempAttachFile=attachDocFiles;
				}catch(Exception e){tempAttachFile=attachDocFiles;ezc.ezcommon.EzLog4j.log("::::::Exception while getting filename:::::::::::"+e,"I");}
						ezc.ezcommon.EzLog4j.log("::::::filename tempAttachFile:::::::::::"+tempAttachFile,"I");

				docDescFiles.put(attachFileTime+"_"+tempAttachFile,attachDocDesc);

			}

			ezc.ezcommon.EzLog4j.log("::::::docDescFiles qry:::::::::::"+docDescFiles,"I");

			String srcPath="",destinationPath="";

			try
			{
				ResourceBundle site1= ResourceBundle.getBundle("Site");
				srcPath=site1.getString("UPLOADTEMPDIR");
				destinationPath=site1.getString("SERVERUPLOADPATH");
			}
			catch(Exception e)
			{ 
			    ezc.ezcommon.EzLog4j.log("Got Exception while getting Upload Temp Dir "+e,"E");	
			}

			ezc.ezcommon.EzLog4j.log("::::::srcPath qry:::::::::::"+srcPath,"I"); 
			File srcDir	= new File(srcPath+session.getId());

			File[] files = null;

			if(srcDir.exists())
				files = srcDir.listFiles();

			FileChannel in = null;
			FileChannel outSt = null;

			if(files!=null)
			{
				//uploadedFileCnt=files.length;
				ezc.ezcommon.EzLog4j.log("******files.length*****"+files.length,"I");

				for (int i=0;i<files.length;i++)
				{

					String fileName	 = files[i].getName();

					ezc.ezcommon.EzLog4j.log("******fileName*****"+fileName,"I");

					try
					{
						in = new FileInputStream(files[i]).getChannel();
						File destFolder	= null;

						destFolder	= new File(destinationPath+docNumber);


						if (!destFolder.exists())
						destFolder.mkdirs();

						String serFileName=docNumber+"\\\\"+fileName;

						String attachmentDesc = (String)docDescFiles.get(fileName);


						if(attachmentDesc==null || "null".equals(attachmentDesc))attachmentDesc="";


						if(!"".equals(attachmentDesc))
						{
						uploadedFileCnt=uploadedFileCnt+1;
							File outFile 	= new File(destFolder, fileName);
							outSt 		= new FileOutputStream(outFile).getChannel();
							in.transferTo(0, in.size(), outSt);

							attachmentDesc = attachmentDesc.replaceAll("'","`");
							attachmentDesc = attachmentDesc.replaceAll("\"","``");

							ezc.ezcommon.EzLog4j.log("******serFileName*****"+serFileName,"I");
							String qry="INSERT INTO EZC_UPLOAD_FILES (EUF_DOC_ID,EUF_ATTACHED_BY,EUF_ATTACHED_DATE,EUF_FILE_DESCRTIPTION,EUF_CLIENT_FILE_NAME,EUF_SERVER_FILE_NAME,EUF_EXT1,EUF_EXT2,EUF_EXT3) VALUES('"+docNumber+"','"+Session.getUserId()+"',NOW(),'"+attachmentDesc+"','"+fileName+"','"+serFileName+"','','','')" ;
							ezc.ezcommon.EzLog4j.log("******EZC_UPLOAD_FILES qry*****"+qry,"I");

							miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
							miscTableRow.setQuery(qry);
							miscTable.appendRow(miscTableRow);
						}
						files[i].delete();
					}
					catch (Exception e)
					{
						ezc.ezcommon.EzLog4j.log(" : :Error occured while moving files ::::"+e,"E");
					}
					finally
					{
						if (in != null)
							in.close();
						if (outSt != null)
							outSt.close();
					}
				}
				ul_mainParams.setLocalStore("Y");
				ul_mainParams.setObject(miscTable);
				Session.prepareParams(ul_mainParams);

				ezc.ezparam.ReturnObjFromRetrieve retObj = (ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezSaveMiscTransactions(ul_mainParams);

				try
				{
					for (File file : files)
						file.delete();

				}catch(Exception e){
					ezc.ezcommon.EzLog4j.log("::::::Batch query execution failed in ezSaveCRNDetails::::::"+e,"E");
				}
			}
		}		
		session.removeValue("ATTACHEDFILES");
	}catch(Exception e){
		ezc.ezcommon.EzLog4j.log("::::::Exception occured while uploading files::::::"+e,"E");
	}	
 %>