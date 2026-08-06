<%@ page import="javax.xml.parsers.*,org.w3c.dom.*" %>
<%@page import="java.util.*,java.io.*"%>
<%@page import="javax.xml.parsers.*" %>
<%@page import="org.w3c.dom.*" %>
<%@page import="org.xml.sax.*" %>


<%
	String userRole	= "", eMail = "";
	
	Hashtable eMailIdHT = new Hashtable();
	Vector emailIdsVector = new Vector();
	
	try
	{
	
		DocumentBuilderFactory docFactory 	= javax.xml.parsers.DocumentBuilderFactory.newInstance();
		DocumentBuilder docBuilder 		= docFactory.newDocumentBuilder();
		
		String filePath=request.getRealPath("ezListSbuPlantAddresses.jsp");
		filePath=filePath.substring(0,filePath.indexOf("ezListSbuPlantAddresses.jsp"));
		filePath += "\\EzCommerce\\EzCommon\\XMLs\\ezRoleEMail.xml";
		
		File fileObj = new File(filePath);
		Document xmlDoc = docBuilder.parse(fileObj);
		Element root = xmlDoc.getDocumentElement();
		NodeList list = root.getElementsByTagName("EzEMail");
		int rowsCount = list.getLength();
		
		Node node=null;
		Element element=null;
		NodeList resultList=null;

		for(int i=0;i<rowsCount;i++)
		{
			element	=(Element)list.item(i);
			userRole=element.getAttribute("ROLE");
			eMail	=element.getAttribute("EMAIL");
			
			
			
			if(emailIdsVector.contains(userRole))
				eMailIdHT.put(userRole,eMailIdHT.get(userRole)+","+eMail);
			else
			{
				eMailIdHT.put(userRole,eMail);
				emailIdsVector.addElement(userRole);
			}	
		}
	}
	catch(Exception e)
	{
		try{
			out.println(e);
		}catch(Exception ex){}
	}
		
%>

