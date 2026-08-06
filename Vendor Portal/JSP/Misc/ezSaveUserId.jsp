<%@ page import="java.sql.*" import="java.util.*"   %>
<%@ page import="javax.xml.parsers.*,org.w3c.dom.*,javax.xml.transform.*,javax.xml.transform.dom.DOMSource,java.io.FileOutputStream,javax.xml.transform.stream.StreamResult" %>
<%@ page import="java.util.*,java.io.*"%>
<%@ page import="ezc.ezutil.*"%>

<%@ page import="org.xml.sax.*" %>

<%
	String accept="Y";
	//String userId=(String)session.getValue("USER_ID");
	String userId=Session.getUserId();
	userId = userId.trim();
	//out.println("userID:::"+userId);
	
	String firstName=(String)session.getValue("FIRST_NAME");
	if("null".equals(firstName)||null==firstName)firstName="";
	
	
	String middleName=(String)session.getValue("MIDDLE_INITIAL");
	if("null".equals(middleName)||null==middleName)middleName="";
	String lastName=(String)session.getValue("LAST_NAME");
	if("null".equals(lastName)||null==lastName)lastName="";
	
	String name=firstName+""+middleName+""+lastName;
	
	
	try
	{
		DocumentBuilderFactory docFactory = javax.xml.parsers.DocumentBuilderFactory.newInstance();	
		DocumentBuilder docBuilder = docFactory.newDocumentBuilder();	
		
		String fileName ="ezSaveUserId.jsp";
		//out.println(fileName);
		String filePath=request.getRealPath(fileName);	
		//filePath=filePath.substring(0,filePath.indexOf(fileName));	
		//filePath += "EzCommerce//EzCommon//XMLs//ezDrl.xml";
		
		filePath = "E:\\Ora10gHome\\j2ee\\home\\default-web-app\\EzCommerce\\EzCommon\\XMLs\\ezDrl.xml";
		
		//out.println(filePath);
		Document doc = docBuilder.parse("file:"+filePath);		
		Element root = doc.getDocumentElement(); 		
		
		java.util.Date today=  new java.util.Date();		
		FormatDate fd = new FormatDate(); 		
		String toDaysDate = fd.getStringFromDate(today,".",fd.DDMMYYYY);  
                Element element=null;		
		NodeList x=doc.getElementsByTagName("UserId");
		String idd="";
		
		boolean idExistt = false;
		
		for(int i=0;i<x.getLength();i++)
		{
			element=(Element)x.item(i);
			idd=element.getAttribute("id");
			
			if(idd.equals(userId)) 
				idExistt = true;
				
			
		}

		if(!idExistt)
		{
			element=doc.createElement("UserId");
			element.setAttribute("id",userId);
			Node nodeelement=(Node)element;

			Node nodename=null;	
			Node nodevalue=null;

			nodename=(Node)doc.createElement("Accept");	
			nodevalue=doc.createTextNode(accept);	
			nodename.appendChild(nodevalue);	
			nodeelement.appendChild(nodename);
			
			
			nodename=(Node)doc.createElement("Name");
			nodevalue=doc.createTextNode(name);	
			nodename.appendChild(nodevalue);	
			nodeelement.appendChild(nodename); 
			
			nodename=(Node)doc.createElement("Date");	
			nodevalue=doc.createTextNode(toDaysDate);	
			nodename.appendChild(nodevalue);	
			nodeelement.appendChild(nodename);
			

		        Node rootelement=(Node)root;	
			root.appendChild(nodeelement);

			TransformerFactory factory = TransformerFactory.newInstance();	
			Transformer transformer = factory.newTransformer();
			transformer.transform(new DOMSource(root),new StreamResult(new FileOutputStream(filePath)));
		}
		//response.sendRedirect("ezDisclaimer1.jsp");
	}
	catch(Exception e)
	{
		System.out.println(e);
	}
	
%>
