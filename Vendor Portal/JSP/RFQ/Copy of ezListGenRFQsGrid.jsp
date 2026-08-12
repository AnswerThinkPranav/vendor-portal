<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/Lib/ezPurchaseBean.jsp"%>
<%@ include file="../../../Includes/Jsps/Rfq/iListGenRFQs.jsp"%>
<%
  
	out.println("<?xml version=\"1.0\"?>");
	out.println("<rows>");
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
	EzGlobal.setDateFormat("MM"+dateSep+"dd"+dateSep+"yyyy hh:mm");

	ezc.ezparam.ReturnObjFromRetrieve ret = EzGlobal.getGlobal((ezc.ezparam.ReturnObjFromRetrieve)myRetrfq);
	
	
	String collectiveRFQNo  = "";
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
	String sysKey = (String)session.getValue("SYSKEY");
	String chkStatus ="0";
	//String userType = (String)session.getValue("UserType");;
	//out.println(myRetrfq.toEzcString());
	FormatDate fd = new FormatDate();
	//ezLog4j.log("Count:"+Count,"w");
	 Hashtable vendorsHT=(Hashtable)session.getValue("VENDORHT");
	           
	if(Count > 0)
	{
		for(int i=0;i<Count;i++)
		{
			if(vendorsHT.containsKey(myRetrfq.getFieldValueString(i,"SOLD_TO")))
			{
			collectiveRFQNo = myRetrfq.getFieldValueString(i,"COLLECTIVE_RFQ_NO");
			orderNo 	= myRetrfq.getFieldValueString(i,"RFQ_NO");
			soldToInfo	= myRetrfq.getFieldValueString(i,"SOLD_TO");			
			closeDate 	= ret.getFieldValueString(i,"VALID_UPTO");
			orderDate 	= ret.getFieldValueString(i,"RFQ_DATE");
			clDate 		= fd.getStringFromDate((Date)myRetrfq.getFieldValue(i,"VALID_UPTO"),(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
			vendType	= myRetrfq.getFieldValueString(i,"VENDOR_TYPE");
			status		= myRetrfq.getFieldValueString(i,"STATUS");
			agentCode	= "";
			ext		= myRetrfq.getFieldValueString(i,"EXT3");
			custName	= myRetrfq.getFieldValueString(i,"SOLD_TO_NAME");
			
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
					out.println("<row id='"+orderNo+"¥"+soldToInfo+"¥"+collectiveRFQNo+"¥"+vendType+"¥"+agentCode+"¥"+orderDate+"¥"+closeDate+"'><cell>"+chkStatus+"</cell><cell><![CDATA[<nobr><a href=JavaScript:viewRFQDetailsFun('"+orderNo+"','"+clDate+"','"+soldToInfo+"','"+collectiveRFQNo+"','"+vendType+"','"+custName+"','"+agentCode+"','"+status+"','"+ext+"')>"+orderNo+"</a></nobr>]]></cell><cell>"+collectiveRFQNo+"</cell><cell><![CDATA[<nobr><a href=Javascript:funShowAgentDetails('"+agentCode+"','"+vendType+"')>"+agentCode+" "+soldToInfo+"</a></nobr>]]></cell><cell>"+custName+"</cell><cell>"+orderDate+"</cell><cell>"+closeDate+"</cell><cell><![CDATA[<nobr><a href=Javascript:RFQPrint('"+orderNo+"','"+soldToInfo+"')><img border=0 id='"+num+"'  src='../../Images/print_ico.jpg'></a></nobr>]]></cell></row>");

				}
				else
				{
					out.println("<row id='"+orderNo+"¥"+soldToInfo+"¥"+collectiveRFQNo+"¥"+vendType+"¥"+agentCode+"¥"+orderDate+"¥"+closeDate+"'><cell>"+chkStatus+"</cell><cell><![CDATA[<nobr><a href=JavaScript:viewRFQDetailsFun('"+orderNo+"','"+clDate+"','"+soldToInfo+"','"+collectiveRFQNo+"','"+vendType+"','"+custName+"','"+agentCode+"','"+status+"','"+ext+"')>"+orderNo+"</a></nobr>]]></cell><cell>"+collectiveRFQNo+"</cell><cell><![CDATA[<nobr><a href=Javascript:funShowVndrDetails('"+sysKey+"','"+soldToInfo+"')>"+agentCode+" "+soldToInfo+"</a></nobr>]]></cell><cell>"+custName+"</cell><cell>"+orderDate+"</cell><cell>"+closeDate+"</cell><cell><![CDATA[<nobr><a href=Javascript:RFQPrint('"+orderNo+"','"+soldToInfo+"')><img border=0 id='"+num+"'  src='../../Images/print_ico.jpg'></a></nobr>]]></cell></row>");
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
							out.println("<row id='"+orderNo+"'><cell><![CDATA[<nobr><a href=JavaScript:viewRFQDetailsFun('"+orderNo+"','"+clDate+"','"+soldToInfo+"','"+collectiveRFQNo+"','"+vendType+"','"+custName+"','"+agentCode+"','"+status+"','"+ext+"')>"+orderNo+"</a></nobr>]]></cell><cell>"+collectiveRFQNo+"</cell><cell><![CDATA[<nobr><a href=Javascript:funShowAgentDetails('"+agentCode+"','"+vendType+"')>"+agentCode+" "+soldToInfo+"</a></nobr>]]></cell><cell>"+custName+"</cell><cell>"+orderDate+"</cell><cell>"+closeDate+"</cell><cell><![CDATA[<nobr><a href=Javascript:RFQPrint('"+orderNo+"','"+soldToInfo+"')><img border=0 id='"+num+"'  src='../../Images/print_ico.jpg'></a></nobr>]]></cell></row>");
						}
						else
						{
							out.println("<row id='"+orderNo+"'><cell><![CDATA[<nobr><a href=JavaScript:viewRFQDetailsFun('"+orderNo+"','"+clDate+"','"+soldToInfo+"','"+collectiveRFQNo+"','"+vendType+"','"+custName+"','"+agentCode+"','"+status+"','"+ext+"')>"+orderNo+"</a></nobr>]]></cell><cell>"+collectiveRFQNo+"</cell><cell><![CDATA[<nobr><a href=Javascript:funShowVndrDetails('"+sysKey+"','"+soldToInfo+"')>"+agentCode+" "+soldToInfo+"</a></nobr>]]></cell><cell>"+custName+"</cell><cell>"+orderDate+"</cell><cell>"+closeDate+"</cell><cell><![CDATA[<nobr><a href=Javascript:RFQPrint('"+orderNo+"','"+soldToInfo+"')><img border=0 id='"+num+"'  src='../../Images/print_ico.jpg'></a></nobr>]]></cell></row>");
						}
					}
				}
				else
				{
					if(flg)
					{
						out.println("<row id='"+orderNo+"'><cell><![CDATA[<nobr><a href=JavaScript:viewRFQDetailsFun('"+orderNo+"','"+clDate+"','"+soldToInfo+"','"+collectiveRFQNo+"','S','"+custName+"','"+agentCode+"','"+status+"','"+ext+"')>"+orderNo+"</a></nobr>]]></cell><cell>"+collectiveRFQNo+"</cell><cell><![CDATA[<nobr><a href=Javascript:funShowAgentDetails('"+agentCode+"','"+vendType+"')>"+agentCode+" "+soldToInfo+"</a></nobr>]]></cell><cell>"+custName+"</cell><cell>"+orderDate+"</cell><cell>"+closeDate+"</cell><cell><![CDATA[<nobr><a href=Javascript:RFQPrint('"+orderNo+"','"+soldToInfo+"')><img border=0 id='"+num+"'  src='../../Images/print_ico.jpg'></a></nobr>]]></cell></row>");
					}
					else
					{
						out.println("<row id='"+orderNo+"'><cell><![CDATA[<nobr><a href=JavaScript:viewRFQDetailsFun('"+orderNo+"','"+clDate+"','"+soldToInfo+"','"+collectiveRFQNo+"','S','"+custName+"','"+agentCode+"','"+status+"','"+ext+"')>"+orderNo+"</a></nobr>]]></cell><cell>"+collectiveRFQNo+"</cell><cell><![CDATA[<nobr><a href=Javascript:funShowVndrDetails('"+sysKey+"','"+soldToInfo+"')>"+agentCode+" "+soldToInfo+"</a></nobr>]]></cell><cell>"+custName+"</cell><cell>"+orderDate+"</cell><cell>"+closeDate+"</cell><cell><![CDATA[<nobr><a href=Javascript:RFQPrint('"+orderNo+"','"+soldToInfo+"')><img border=0 id='"+num+"'  src='../../Images/print_ico.jpg'></a></nobr>]]></cell></row>");
					}  
				}
    				
    			}

			}
		}	
	}
	out.println("</rows>");
	
	
%>	


