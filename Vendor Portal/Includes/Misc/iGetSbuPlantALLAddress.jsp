
<%
	
	ezc.ezparam.ReturnObjFromRetrieve ret=new ezc.ezparam.ReturnObjFromRetrieve(new String[]{"CODE","CATEGORY","NAME","ADDRESS","LOCATION","ECCNUMBER","TINNO","COUNTRY","CST","PHONE","FAX","EXCISEREGNO","EXCISERANGE","EXCISEDIVISION","EXCISECOMM","CSTNUM","LSTNUM","PERMANENTACCNUM","SERVICETAXREGNUM"});
	try
	{
		String filePath=request.getRealPath(fileName);
		filePath=filePath.substring(0,filePath.indexOf(fileName));
		if(filePath.endsWith("Purorder\\"))
			filePath = replaceString(filePath,"Purorder","Misc");
		filePath += "/ezSbuPlantAddress.xml";
		out.println("filePath"+filePath);
		java.io.File fileObj = new java.io.File(filePath);

		DocumentBuilderFactory docFactory = javax.xml.parsers.DocumentBuilderFactory.newInstance();
		DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
		Document doc = docBuilder.parse(fileObj);
		
		Element root = doc.getDocumentElement();
		NodeList list = root.getElementsByTagName("EzPlant");
		int n = list.getLength();
		
		Node node=null;
		Element element=null;
		NodeList resultList=null;
		String sbu="";
		String code="";
		for(int i=0;i<n;i++)
		{	
			
			element=(Element)list.item(i);
			//sbu= element.getAttribute("sbu");
			code=element.getAttribute("code");
			node=(Node)element;
			resultList=node.getChildNodes();
			
			
			
			{
				
				ret.setFieldValue("CODE",code);
				//ret.setFieldValue("SBU",sbu);

				resultList=((Element)node).getElementsByTagName("Name");
				if(resultList.item(0).getFirstChild().getNodeValue()!=null)
				ret.setFieldValue("NAME",resultList.item(0).getFirstChild().getNodeValue());
				else
				ret.setFieldValue("NAME","");	
				
				resultList=((Element)node).getElementsByTagName("Address");
				if(resultList.item(0).getFirstChild().getNodeValue()!=null)
				ret.setFieldValue("ADDRESS",resultList.item(0).getFirstChild().getNodeValue());
				else
				ret.setFieldValue("ADDRESS","");		

				
				resultList=((Element)node).getElementsByTagName("Location");
				if(resultList.item(0).getFirstChild().getNodeValue()!=null)
					ret.setFieldValue("LOCATION",resultList.item(0).getFirstChild().getNodeValue());
				else
				ret.setFieldValue("LOCATION","");		

				resultList=((Element)node).getElementsByTagName("Eccnumber");
				if(resultList.item(0).getFirstChild().getNodeValue()!=null)
				ret.setFieldValue("ECCNUMBER",resultList.item(0).getFirstChild().getNodeValue());
				else
				ret.setFieldValue("ECCNUMBER","");		

				resultList=((Element)node).getElementsByTagName("Tinno");
				if(resultList.item(0).getFirstChild().getNodeValue()!=null)
				ret.setFieldValue("TINNO",resultList.item(0).getFirstChild().getNodeValue());
				else
				ret.setFieldValue("TINNO","");		

				resultList=((Element)node).getElementsByTagName("Fax");
				if(resultList.item(0).getFirstChild().getNodeValue()!=null)
				ret.setFieldValue("FAX",resultList.item(0).getFirstChild().getNodeValue());
				else
				ret.setFieldValue("FAX","");		

				resultList=((Element)node).getElementsByTagName("CST");
				if(resultList.item(0).getFirstChild().getNodeValue()!=null)
				ret.setFieldValue("CST",resultList.item(0).getFirstChild().getNodeValue());
				else
				ret.setFieldValue("CST","");		

				resultList=((Element)node).getElementsByTagName("Category");
				if(resultList.item(0).getFirstChild().getNodeValue()!=null)
				ret.setFieldValue("CATEGORY",resultList.item(0).getFirstChild().getNodeValue());
				else
				ret.setFieldValue("CATEGORY","");	
				

				resultList=((Element)node).getElementsByTagName("Phone");
				if(resultList.item(0).getFirstChild().getNodeValue()!=null)
				ret.setFieldValue("PHONE",resultList.item(0).getFirstChild().getNodeValue());
				else
				ret.setFieldValue("PHONE","");	
				
				
				try{	
								
					resultList=((Element)node).getElementsByTagName("ExciseRegNo");
					if(resultList.item(0).getFirstChild()!=null)
						ret.setFieldValue("EXCISEREGNO",resultList.item(0).getFirstChild().getNodeValue());
					else	
						ret.setFieldValue("EXCISEREGNO","");


					resultList=((Element)node).getElementsByTagName("ExciseRange");
					if(resultList.item(0).getFirstChild()!=null)
						ret.setFieldValue("EXCISERANGE",resultList.item(0).getFirstChild().getNodeValue());
					else	
						ret.setFieldValue("EXCISERANGE","");


					resultList=((Element)node).getElementsByTagName("ExciseDivision");
					if(resultList.item(0).getFirstChild()!=null)
						ret.setFieldValue("EXCISEDIVISION",resultList.item(0).getFirstChild().getNodeValue());
					else	
						ret.setFieldValue("EXCISEDIVISION","");


					resultList=((Element)node).getElementsByTagName("ExciseComm");
					if(resultList.item(0).getFirstChild()!=null)
						ret.setFieldValue("EXCISECOMM",resultList.item(0).getFirstChild().getNodeValue());
					else	
						ret.setFieldValue("EXCISECOMM","");


					resultList=((Element)node).getElementsByTagName("CstNum");
					if(resultList.item(0).getFirstChild()!=null)
						ret.setFieldValue("CSTNUM",resultList.item(0).getFirstChild().getNodeValue());
					else	
						ret.setFieldValue("CSTNUM","");


					resultList=((Element)node).getElementsByTagName("LstNum");
					if(resultList.item(0).getFirstChild()!=null)
						ret.setFieldValue("LSTNUM",resultList.item(0).getFirstChild().getNodeValue());
					else	
						ret.setFieldValue("LSTNUM","");


					resultList=((Element)node).getElementsByTagName("PermanentAccNum");
					if(resultList.item(0).getFirstChild()!=null)
						ret.setFieldValue("PERMANENTACCNUM",resultList.item(0).getFirstChild().getNodeValue());
					else	
						ret.setFieldValue("PERMANENTACCNUM","");


					resultList=((Element)node).getElementsByTagName("ServiceTaxRegNum");
					if(resultList.item(0).getFirstChild()!=null)
						ret.setFieldValue("SERVICETAXREGNUM",resultList.item(0).getFirstChild().getNodeValue());
					else	
						ret.setFieldValue("SERVICETAXREGNUM","");

				}catch(Exception e){
					//out.println("::::"+e);
			}
				
				
				
				
				
				

				ret.addRow();
			}
		}

	}
	catch(Exception e)
	{
		//out.println(e);

	}
%>
