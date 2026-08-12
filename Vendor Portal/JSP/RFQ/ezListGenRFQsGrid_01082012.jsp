<%
	response.setContentType("text/xml");
	out.println("<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?>");	
	out.println("<rows>");
%>
<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/Lib/ezPurchaseBean.jsp"%>
<%@ include file="../../../Includes/Jsps/Rfq/iListGenRFQs.jsp"%>
<%
  
	//out.println("<?xml version=\"1.0\"?>");
	//out.println("<rows>");
	ezc.ezutil.FormatDate formatDate = new ezc.ezutil.FormatDate();
	ezc.ezcommon.EzLog4j ezLog4j=new ezc.ezcommon.EzLog4j();
	
	
	String dateSep = (String)session.getValue("DATESEPERATOR");
	Vector types = new Vector();
	types.addElement("date");
	types.addElement("date");	        
	EzGlobal.setColTypes(types);

	Vector names = new Vector();
	names.addElement("VALID_UPTO");
	names.addElement("RFQ_DATE");		
	EzGlobal.setColNames(names);
	//EzGlobal.setDateFormat("MM"+dateSep+"dd"+dateSep+"yyyy hh:mm");
	
	EzGlobal.setDateFormat("MM"+dateSep+"dd"+dateSep+"yyyy");

	ezc.ezparam.ReturnObjFromRetrieve ret = EzGlobal.getGlobal((ezc.ezparam.ReturnObjFromRetrieve)myRetrfq);
	
	
	String collectiveRFQNo  = "";
	String Description	= "";
	String orderNo 		= "";
	String soldToInfo	= "";
	String closeDate 	= "";
	String orderDate 	= "";
	String clDate 		= "";
	String vendType		= "";
	String status		= "";
	String agentCode	= "";
	String ext		= "";
	String ext1		= "";
	String custName		= ""; 
	String reQuote		= "";
	String sysKey = (String)session.getValue("SYSKEY");
	String chkStatus ="0";
	String stat="";
	//String userType = (String)session.getValue("UserType");
	String VenSearch=request.getParameter("VenSearch");
	//out.println(myRetrfq.toEzcString());
	FormatDate fd = new FormatDate();
	//ezLog4j.log("Count:"+Count,"w");
	 Hashtable vendorsHT=(Hashtable)session.getValue("VENDORHT");
	 
	 ezLog4j.log("vendorsHT:"+vendorsHT,"w");
	 
	 
	 
	 java.util.Date currentDateObj =new java.util.Date();
 	 java.util.Date myChkDateObj=new java.util.Date(currentDateObj.getYear(),currentDateObj.getMonth(),currentDateObj.getDate());
	 //java.util.Date myChkDateObj=new java.util.Date();
	 java.util.Date validUPToDate =null;
	  String validUPToStr = ""; 
	  String isValidExpire = ""; 
	  
	  int month = 0,date = 0,year = 0; 

	
	 
	 
	           
	if(Count > 0)
	{
		for(int i=0;i<myRetrfq.getRowCount();i++)
		{
		
		 ezLog4j.log("SOLD_TO:"+myRetrfq.getFieldValueString(i,"SOLD_TO"),"w");

		 	
			if(vendorsHT.containsKey(myRetrfq.getFieldValueString(i,"SOLD_TO")))
			{

		 	collectiveRFQNo = myRetrfq.getFieldValueString(i,"COLLECTIVE_RFQ_NO");
			reQuote		= myRetrfq.getFieldValueString(i,"ERH_REQUOTE");
			orderNo 	= myRetrfq.getFieldValueString(i,"RFQ_NO");
			Description	= myRetrfq.getFieldValueString(i,"RFQ_TITLE");
			Description	= Description.replaceAll("&","&amp;");
			
			
			String reQouteStatus="No";
			if("Y".equals(reQuote))
				reQouteStatus = "<![CDATA[<nobr><font color='#FF3300'><b>Yes</b></font></nobr>]]>";
				
				
				
				
				
				
			
			if(Description==null || "null".equals(Description))Description="";
			
			if(reQuote==null || "null".equals(reQuote) || "".equals(reQuote))reQuote="N";
			
			 ezLog4j.log("orderNo:"+orderNo,"w");
			
			soldToInfo	= myRetrfq.getFieldValueString(i,"SOLD_TO");			
			closeDate 	= ret.getFieldValueString(i,"VALID_UPTO");
			orderDate 	= ret.getFieldValueString(i,"RFQ_DATE");
			clDate 		= fd.getStringFromDate((Date)myRetrfq.getFieldValue(i,"VALID_UPTO"),(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
			vendType	= myRetrfq.getFieldValueString(i,"VENDOR_TYPE");
			status		= myRetrfq.getFieldValueString(i,"STATUS");
			agentCode	= "";
			ext		= myRetrfq.getFieldValueString(i,"EXT3");
			custName	= (String)vendorsHT.get(myRetrfq.getFieldValueString(i,"SOLD_TO"));//myRetrfq.getFieldValueString(i,"SOLD_TO_NAME");
			custName	= custName.replaceAll("&","&amp;");
			
			if(custName==null||"null".equals(custName)) custName="";
			ext1		= myRetrfq.getFieldValueString(i,"EXT1");
			boolean flg=false;
			if(custName!=null)
				custName = custName.trim();
			
			if(vendType!=null)
				vendType = vendType.trim();
				
				
			
			if("I".equals(vendType) || "N".equals(vendType))
			{
				flg = true;
				agentCode = myRetrfq.getFieldValueString(i,"AGENT_CODE");
				
			}
			String num = "IMG"+i;
			
			if("Invite".equals(ext3Type))
			{
	
				if(flg)
				{
					out.println("<row id='"+orderNo+"¥"+soldToInfo+"¥"+collectiveRFQNo+"¥"+vendType+"¥"+agentCode+"¥"+orderDate+"¥"+closeDate+"'><cell>"+chkStatus+"</cell><cell><![CDATA[<nobr><a href=JavaScript:viewRFQDetailsFun('"+orderNo+"','"+clDate+"','"+soldToInfo+"','"+collectiveRFQNo+"','"+vendType+"','','"+agentCode+"','"+status+"','"+ext+"','"+reQuote+"')>"+orderNo+"</a></nobr>]]></cell><cell>"+collectiveRFQNo+"</cell><cell><![CDATA[<nobr><a href=Javascript:funShowAgentDetails('"+agentCode+"','"+vendType+"')>"+agentCode+" "+soldToInfo+"</a></nobr>]]></cell><cell>"+custName+"</cell><cell>"+orderDate+"</cell><cell>"+closeDate+"</cell><cell>"+reQouteStatus+"</cell><cell><![CDATA[<nobr><a href=Javascript:RFQPrint('"+orderNo+"','"+soldToInfo+"')><img border=0 id='"+num+"'  src='../../Images/print_ico.jpg'></a></nobr>]]></cell></row>");

				}
				else
				{
					out.println("<row id='"+orderNo+"¥"+soldToInfo+"¥"+collectiveRFQNo+"¥"+vendType+"¥"+agentCode+"¥"+orderDate+"¥"+closeDate+"'><cell>"+chkStatus+"</cell><cell><![CDATA[<nobr><a href=JavaScript:viewRFQDetailsFun('"+orderNo+"','"+clDate+"','"+soldToInfo+"','"+collectiveRFQNo+"','"+vendType+"','','"+agentCode+"','"+status+"','"+ext+"','"+reQuote+"')>"+orderNo+"</a></nobr>]]></cell><cell>"+collectiveRFQNo+"</cell><cell><![CDATA[<nobr><a href=Javascript:funShowVndrDetails('"+sysKey+"','"+soldToInfo+"')>"+agentCode+" "+soldToInfo+"</a></nobr>]]></cell><cell>"+custName+"</cell><cell>"+orderDate+"</cell><cell>"+closeDate+"</cell><cell>"+reQouteStatus+"</cell><cell><![CDATA[<nobr><a href=Javascript:RFQPrint('"+orderNo+"','"+soldToInfo+"')><img border=0 id='"+num+"'  src='../../Images/print_ico.jpg'></a></nobr>]]></cell></row>");
				}    		
			}
    			else
    			{
    				if("3".equals(userType) && "All".equals(ext3Type))
    				{
    					if("Y".equals(ext))
    					{
						if(flg)
						{
							out.println("<row id='"+orderNo+"'><cell><![CDATA[<nobr><a href=JavaScript:viewRFQDetailsFun('"+orderNo+"','"+clDate+"','"+soldToInfo+"','"+collectiveRFQNo+"','"+vendType+"','','"+agentCode+"','"+status+"','"+ext+"','"+reQuote+"')>"+orderNo+"</a></nobr>]]></cell><cell>"+Description+"</cell><cell>"+collectiveRFQNo+"</cell><cell><![CDATA[<nobr><a href=Javascript:funShowAgentDetails('"+agentCode+"','"+vendType+"')>"+agentCode+" "+soldToInfo+"</a></nobr>]]></cell><cell>"+custName+"</cell><cell>"+orderDate+"</cell><cell>"+closeDate+"</cell><cell>"+reQouteStatus+"</cell><cell><![CDATA[<nobr><a href=Javascript:RFQPrint('"+orderNo+"','"+soldToInfo+"')><img border=0 id='"+num+"'  src='../../Images/print_ico.jpg'></a></nobr>]]></cell></row>");
						}
						else
						{
							out.println("<row id='"+orderNo+"'><cell><![CDATA[<nobr><a href=JavaScript:viewRFQDetailsFun('"+orderNo+"','"+clDate+"','"+soldToInfo+"','"+collectiveRFQNo+"','"+vendType+"','','"+agentCode+"','"+status+"','"+ext+"','"+reQuote+"')>"+orderNo+"</a></nobr>]]></cell><cell>"+Description+"</cell><cell>"+collectiveRFQNo+"</cell><cell><![CDATA[<nobr><a href=Javascript:funShowVndrDetails('"+sysKey+"','"+soldToInfo+"')>"+agentCode+" "+soldToInfo+"</a></nobr>]]></cell><cell>"+custName+"</cell><cell>"+orderDate+"</cell><cell>"+closeDate+"</cell><cell>"+reQouteStatus+"</cell><cell><![CDATA[<nobr><a href=Javascript:RFQPrint('"+orderNo+"','"+soldToInfo+"')><img border=0 id='"+num+"'  src='../../Images/print_ico.jpg'></a></nobr>]]></cell></row>");
						}
					}
				}
				else
				{
				
					if("ToBeQuote".equals(ext3Type))
					{
						//validUPToDate=(java.util.Date)myRetrfq.getFieldValue(i,"VALID_UPTO");  
						
						 ezLog4j.log("validUPToDate:"+validUPToDate,"w");
						 ezLog4j.log("myChkDateObj:"+myChkDateObj,"w");
						 
						 validUPToStr = myRetrfq.getFieldValueString(i,"VALID_UPTO");
						 				
						date = Integer.parseInt(validUPToStr.split("-")[2]);
						month = Integer.parseInt(validUPToStr.split("-")[1])-1;
						year = Integer.parseInt(validUPToStr.split("-")[0])-1900;
						 				
						 validUPToDate = new java.util.Date(year,month,date);
						 
						
						if(myChkDateObj.compareTo(validUPToDate)<=0)
							isValidExpire = "No";
						else
							isValidExpire = "<![CDATA[<nobr><a href=JavaScript:UpdateValidityDate('"+orderNo+"') ><font color='#FF3300'><b>Yes</b></font></a></nobr>]]>";
						
						if(!("3".equals((String)session.getValue("UserType"))))
						{
							if(flg)
								out.println("<row id='"+orderNo+"'><cell><![CDATA[<nobr><a href=JavaScript:viewRFQDetailsFun('"+orderNo+"','"+clDate+"','"+soldToInfo+"','"+collectiveRFQNo+"','S','','"+agentCode+"','"+status+"','"+ext+"','"+reQuote+"')>"+orderNo+"</a></nobr>]]></cell><cell>"+Description+"</cell><cell>"+collectiveRFQNo+"</cell><cell><![CDATA[<nobr><a href=Javascript:funShowAgentDetails('"+agentCode+"','"+vendType+"')>"+agentCode+" "+soldToInfo+"</a></nobr>]]></cell><cell>"+custName+"</cell><cell>"+orderDate+"</cell><cell>"+closeDate+"</cell><cell>"+reQouteStatus+"</cell><cell>"+isValidExpire+"</cell><cell><![CDATA[<nobr><a href=Javascript:RFQPrint('"+orderNo+"','"+soldToInfo+"')><img border=0 id='"+num+"'  src='../../Images/print_ico.jpg'></a></nobr>]]></cell></row>");
							else
								out.println("<row id='"+orderNo+"'><cell><![CDATA[<nobr><a href=JavaScript:viewRFQDetailsFun('"+orderNo+"','"+clDate+"','"+soldToInfo+"','"+collectiveRFQNo+"','S','','"+agentCode+"','"+status+"','"+ext+"','"+reQuote+"')>"+orderNo+"</a></nobr>]]></cell><cell>"+Description+"</cell><cell>"+collectiveRFQNo+"</cell><cell><![CDATA[<nobr><a href=Javascript:funShowVndrDetails('"+sysKey+"','"+soldToInfo+"')>"+agentCode+" "+soldToInfo+"</a></nobr>]]></cell><cell>"+custName+"</cell><cell>"+orderDate+"</cell><cell>"+closeDate+"</cell><cell>"+reQouteStatus+"</cell><cell>"+isValidExpire+"</cell><cell><![CDATA[<nobr><a href=Javascript:RFQPrint('"+orderNo+"','"+soldToInfo+"')><img border=0 id='"+num+"'  src='../../Images/print_ico.jpg'></a></nobr>]]></cell></row>");
						}
						else
						{
							if(flg)
								out.println("<row id='"+orderNo+"'><cell><![CDATA[<nobr><a href=JavaScript:viewRFQDetailsFun('"+orderNo+"','"+clDate+"','"+soldToInfo+"','"+collectiveRFQNo+"','S','','"+agentCode+"','"+status+"','"+ext+"','"+reQuote+"')>"+orderNo+"</a></nobr>]]></cell><cell>"+Description+"</cell><cell>"+collectiveRFQNo+"</cell><cell><![CDATA[<nobr><a href=Javascript:funShowAgentDetails('"+agentCode+"','"+vendType+"')>"+agentCode+" "+soldToInfo+"</a></nobr>]]></cell><cell>"+custName+"</cell><cell>"+orderDate+"</cell><cell>"+closeDate+"</cell><cell>"+reQouteStatus+"</cell><cell><![CDATA[<nobr><a href=Javascript:RFQPrint('"+orderNo+"','"+soldToInfo+"')><img border=0 id='"+num+"'  src='../../Images/print_ico.jpg'></a></nobr>]]></cell></row>");
							else
								out.println("<row id='"+orderNo+"'><cell><![CDATA[<nobr><a href=JavaScript:viewRFQDetailsFun('"+orderNo+"','"+clDate+"','"+soldToInfo+"','"+collectiveRFQNo+"','S','','"+agentCode+"','"+status+"','"+ext+"','"+reQuote+"')>"+orderNo+"</a></nobr>]]></cell><cell>"+Description+"</cell><cell>"+collectiveRFQNo+"</cell><cell><![CDATA[<nobr><a href=Javascript:funShowVndrDetails('"+sysKey+"','"+soldToInfo+"')>"+agentCode+" "+soldToInfo+"</a></nobr>]]></cell><cell>"+custName+"</cell><cell>"+orderDate+"</cell><cell>"+closeDate+"</cell><cell>"+reQouteStatus+"</cell><cell><![CDATA[<nobr><a href=Javascript:RFQPrint('"+orderNo+"','"+soldToInfo+"')><img border=0 id='"+num+"'  src='../../Images/print_ico.jpg'></a></nobr>]]></cell></row>");
						}
					
					}
				 	else
					{
					
						if(flg)
						{
							out.println("<row id='"+orderNo+"'><cell><![CDATA[<nobr><a href=JavaScript:viewRFQDetailsFun('"+orderNo+"','"+clDate+"','"+soldToInfo+"','"+collectiveRFQNo+"','S','','"+agentCode+"','"+status+"','"+ext+"','"+reQuote+"')>"+orderNo+"</a></nobr>]]></cell><cell>"+Description+"</cell><cell>"+collectiveRFQNo+"</cell><cell><![CDATA[<nobr><a href=Javascript:funShowAgentDetails('"+agentCode+"','"+vendType+"')>"+agentCode+" "+soldToInfo+"</a></nobr>]]></cell><cell>"+custName+"</cell><cell>"+orderDate+"</cell><cell>"+closeDate+"</cell><cell>"+reQouteStatus+"</cell><cell><![CDATA[<nobr><a href=Javascript:RFQPrint('"+orderNo+"','"+soldToInfo+"')><img border=0 id='"+num+"'  src='../../Images/print_ico.jpg'></a></nobr>]]></cell></row>");
						}
						else
						{
							out.println("<row id='"+orderNo+"'><cell><![CDATA[<nobr><a href=JavaScript:viewRFQDetailsFun('"+orderNo+"','"+clDate+"','"+soldToInfo+"','"+collectiveRFQNo+"','S','','"+agentCode+"','"+status+"','"+ext+"','"+reQuote+"')>"+orderNo+"</a></nobr>]]></cell><cell>"+Description+"</cell><cell>"+collectiveRFQNo+"</cell><cell><![CDATA[<nobr><a href=Javascript:funShowVndrDetails('"+sysKey+"','"+soldToInfo+"')>"+agentCode+" "+soldToInfo+"</a></nobr>]]></cell><cell>"+custName+"</cell><cell>"+orderDate+"</cell><cell>"+closeDate+"</cell><cell>"+reQouteStatus+"</cell><cell><![CDATA[<nobr><a href=Javascript:RFQPrint('"+orderNo+"','"+soldToInfo+"')><img border=0 id='"+num+"'  src='../../Images/print_ico.jpg'></a></nobr>]]></cell></row>");
						} 
				 	}
				}
    				
    			}

			
			}	
		}	
	}
	out.println("</rows>");
	
	
%>	


