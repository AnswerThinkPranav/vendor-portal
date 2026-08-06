<%@ page import="javax.xml.parsers.*,org.w3c.dom.*,javax.xml.transform.*,org.w3c.dom.NodeList.*,javax.xml.transform.dom.DOMSource,java.io.FileOutputStream,javax.xml.transform.stream.StreamResult" %>
<%@ page import="java.util.*,java.io.*"%>  
<%@ page import = "ezc.ezparam.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />



<%
	String id="";
	String status="N";
	String idExist="N";
	System.out.println("idExist::"+idExist);
	ezc.ezparam.ReturnObjFromRetrieve ret=new ezc.ezparam.ReturnObjFromRetrieve(new String[]{"SALESCODE","ACCEPT","NAME","DATE"});
	
	try
	{
		System.out.println("idExist::"+idExist);
		DocumentBuilderFactory docFactory = javax.xml.parsers.DocumentBuilderFactory.newInstance();	
		DocumentBuilder docBuilder = docFactory.newDocumentBuilder();	
		String fileName = "ezGetUserId.jsp";	
		String filePath=request.getRealPath(fileName);	
		//filePath=filePath.substring(0,filePath.indexOf(fileName));
		
		//filePath += "EzCommerce//EzCommon//XMLs//ezDrl.xml";
		
		filePath = "E:\\Ora10gHome\\j2ee\\home\\default-web-app\\EzCommerce\\EzCommon\\XMLs\\ezDrl.xml";
		
		Document doc = docBuilder.parse("file:"+filePath);	
		Element root = doc.getDocumentElement();
		NodeList list=doc.getElementsByTagName("UserId");
		String userID=(String)Session.getUserId();
		userID = userID.trim();
		System.out.println("userID:::"+userID);
		NodeList resultList=null;  
		Node node=null;
		
		Element element=null;	
		
		for(int i=0;i<list.getLength();i++)
		{
			element=(Element)list.item(i);
			id=element.getAttribute("id");
			node=(Node)element;
			resultList=node.getChildNodes();

			ret.setFieldValue("SALESCODE",id);
	
			resultList=((Element)node).getElementsByTagName("Accept");			
			
			ret.setFieldValue("ACCEPT",resultList.item(0).getFirstChild().getNodeValue());	
			id = id.trim();			
			

			resultList=((Element)node).getElementsByTagName("Name");
			ret.setFieldValue("NAME",resultList.item(0).getFirstChild().getNodeValue());
			
			resultList=((Element)node).getElementsByTagName("Date");
			ret.setFieldValue("DATE",resultList.item(0).getFirstChild().getNodeValue());
			
			ret.addRow();
			System.out.println("id::::"+id);
			System.out.println("userID::::"+userID);

			if(id.equals(userID))
			{
				idExist="Y";
			}
			
		}
	}
	
	
	catch (Exception e)
	{
		System.out.println(e);
	}
	System.out.println("ret:::"+ret.toEzcString());
	System.out.println("idExist::::::::;"+idExist);
	
	
%>
				
			
			
	


