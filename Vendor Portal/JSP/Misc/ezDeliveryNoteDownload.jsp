<%@page import="ezc.sapconnection.*"%>
<%@page import="com.sap.mw.jco.*"%>
<%
	String docId = request.getParameter("docId");
	String byteStr = "";
	if(docId != null && !"null".equals(docId) && !"".equals(docId.trim()))
	{
		docId = docId.trim();
		//docId = "00000000000"+docId;
		//docId = docId.substring(docId.length()-12,docId.length());		
		javax.servlet.ServletOutputStream sos=null;
		response.setContentType("application/x-download");
		response.setHeader("Content-Disposition","attachment;filename="+docId+".pdf");
		try
		{
			 JCO.Client client1=null;
			 JCO.Function function = null;

			String site_S = (String)session.getValue("Site");
			String skey_S = "999";

			 try
			 {
				client1 = EzSAPHandler.getSAPConnection("200~999");
				function = EzSAPHandler.getFunction("Z_EZ_REJECTED_DOWNLOAD_PDF","200~999");
				JCO.ParameterList docDet = function.getImportParameterList();
				docDet.setValue(docId,"MBLNR");//4902016049
				ezc.ezcommon.EzLog4j.log(":::::::::::Before execute-->Z_EZ_REJECTED_DOWNLOAD_PDF::::::::::","I");
				ezc.ezcommon.EzLog4j.log(":::::::::::MBLNR::::::::::"+docId,"I");
				try
				{
					client1.execute(function);
					ezc.ezcommon.EzLog4j.log(":::::::::::After execute::::::::::","I");
					{
						byte OUT_STRING[]= (function.getExportParameterList()).getByteArray("OUT_STRING");
						ezc.ezcommon.EzLog4j.log("::::::::::OUT_STRING::::::::::"+OUT_STRING,"I");
						//if(OUT_STRING != null && OUT_STRING.length > 0)
						{
							sos=response.getOutputStream();
							sos.write(OUT_STRING);
						}
					}
				}
				catch(Exception err){
					ezc.ezcommon.EzLog4j.log(":::::::::::Exception while file downloading::::::::::"+err,"I");
					
				}
			}
			catch(Exception e){}
			finally
			{
				if(client1!=null)
				{
					JCO.releaseClient(client1);
					client1 = null;
					function=null;
					sos.close();
				}
			}
		}
		catch(Exception e){
			ezc.ezcommon.EzLog4j.log(":::::::::::Exception in inputs::::::::::"+e,"I");
		}
	}
%>
