<%@ page import="javax.xml.parsers.*,org.w3c.dom.*,ezc.ezparam.ReturnObjFromRetrieve" %>
<%@page import="java.util.*,java.io.*"%>
<%@page import="javax.xml.parsers.*" %>
<%@page import="org.w3c.dom.*" %>
<% //@page import="org.apache.xml.serialize.*" %>
<%@page import="org.xml.sax.*" %>
<% //@page import="org.apache.xerces.parsers.*" %>


<%
	String redirectcode	=request.getParameter("code");
	String redirectindex	=request.getParameter("index");
	int count =0;
	
	
	ezc.ezparam.ReturnObjFromRetrieve ret=new ezc.ezparam.ReturnObjFromRetrieve(new String[]{"CODE","CATEGORY","NAME","ADDRESS","LOCATION","ECCNUMBER","TINNO","COUNTRY","CST","PHONE","FAX","EXCISEREGNO","EXCISERANGE","EXCISEDIVISION","EXCISECOMM","CSTNUM","LSTNUM","PERMANENTACCNUM","SERVICETAXREGNUM"});
	
	try
	{
	
		DocumentBuilderFactory docFactory 	= javax.xml.parsers.DocumentBuilderFactory.newInstance();
		DocumentBuilder docBuilder 		= docFactory.newDocumentBuilder();
		
		String filePath=request.getRealPath("ezListSbuPlantAddresses.jsp");
		filePath=filePath.substring(0,filePath.indexOf("ezListSbuPlantAddresses.jsp"));
		filePath += "\\ezSbuPlantAddress.xml";
		
		File fileObj = new File(filePath);
		Document doc = docBuilder.parse(fileObj);
		Element root = doc.getDocumentElement();
		NodeList list = root.getElementsByTagName("EzPlant");
		int n = list.getLength();
		
		Node node=null;
		Element element=null;
		NodeList resultList=null;
		//String sbu="";
		String code="";

		for(int i=0;i<n;i++)
		{
			element=(Element)list.item(i);
			code=element.getAttribute("code");
			ret.setFieldValue("CODE",code);
			
			node=(Node)element;
			resultList=node.getChildNodes();

			
			resultList=((Element)node).getElementsByTagName("Category");
			if(resultList.item(0).getFirstChild()!=null)
				ret.setFieldValue("CATEGORY",resultList.item(0).getFirstChild().getNodeValue());
			else	
				ret.setFieldValue("CATEGORY","");
				
			resultList=((Element)node).getElementsByTagName("Name");			
			if(resultList.item(0).getFirstChild()!=null)
				ret.setFieldValue("NAME",resultList.item(0).getFirstChild().getNodeValue());
			else	
				ret.setFieldValue("NAME","");
					
			resultList=((Element)node).getElementsByTagName("Address");
			if(resultList.item(0).getFirstChild()!=null)
				ret.setFieldValue("ADDRESS",resultList.item(0).getFirstChild().getNodeValue());
			else	
				ret.setFieldValue("ADDRESS","");
				
			resultList=((Element)node).getElementsByTagName("Location");
			if(resultList.item(0).getFirstChild()!=null)
				ret.setFieldValue("LOCATION",resultList.item(0).getFirstChild().getNodeValue());
			else	
				ret.setFieldValue("LOCATION","");
			
			resultList=((Element)node).getElementsByTagName("Eccnumber");
			if(resultList.item(0).getFirstChild()!=null)
				ret.setFieldValue("ECCNUMBER",resultList.item(0).getFirstChild().getNodeValue());
			else	
				ret.setFieldValue("ECCNUMBER","");
				

			resultList=((Element)node).getElementsByTagName("Tinno");
			if(resultList.item(0).getFirstChild()!=null)
				ret.setFieldValue("TINNO",resultList.item(0).getFirstChild().getNodeValue());
			else	
				ret.setFieldValue("TINNO","");
							

			resultList=((Element)node).getElementsByTagName("CST");
			if(resultList.item(0).getFirstChild()!=null)
				ret.setFieldValue("CST",resultList.item(0).getFirstChild().getNodeValue());
			else	
				ret.setFieldValue("CST","");
				
			resultList=((Element)node).getElementsByTagName("Phone");
			if(resultList.item(0).getFirstChild()!=null)
				ret.setFieldValue("PHONE",resultList.item(0).getFirstChild().getNodeValue());
			else	
				ret.setFieldValue("PHONE","");
				
			resultList=((Element)node).getElementsByTagName("Fax");
			if(resultList.item(0).getFirstChild()!=null)
				ret.setFieldValue("FAX",resultList.item(0).getFirstChild().getNodeValue());
			else	
				ret.setFieldValue("FAX","");
				
				
				
				
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
				
				
				
			ret.addRow();
		}
	}
	catch(Exception e)
	{
		out.println(e);
		try{
		e.printStackTrace(new PrintStream(new FileOutputStream("CLICK.log")));
		}catch(Exception ex){}
	}
	
	//out.println("retretret	"+ret.toEzcString());
	String columns[]=new String[]{"CODE"};
	ret.sort(columns,true);
	if(ret!=null)
		count= ret.getRowCount();
		
	Hashtable plantAddrHT = new Hashtable();	
	if(count>0)
	{
		for(int i=0;i<count;i++)
		{
			plantAddrHT.put(ret.getFieldValueString(i,"CODE"),ret.getFieldValueString(i,"NAME")+" , "+ret.getFieldValueString(i,"LOCATION"));
		}
	}	
%>

