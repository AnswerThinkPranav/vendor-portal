<%@ page import="javax.xml.parsers.*,org.w3c.dom.*,javax.xml.transform.*,javax.xml.transform.dom.DOMSource,java.io.FileOutputStream,javax.xml.transform.stream.StreamResult" %>
<%

	String name		  =(request.getParameter("name").equals("")?"  ":request.getParameter("name"));
	String category		  =(request.getParameter("category").equals("")?"  ":request.getParameter("category"));
	String address		  =(request.getParameter("address").equals("")?"  ":request.getParameter("address"));
	String eccnumber	  =(request.getParameter("eccno").equals("")?"  ":request.getParameter("eccno"));
	String tinno		  =(request.getParameter("tinno").equals("")?"  ":request.getParameter("tinno"));
	String location		  =(request.getParameter("location").equals("")?"  ":request.getParameter("location"));
	String cst		  =(request.getParameter("cst").equals("")?" ":request.getParameter("cst"));
	String phone		  =(request.getParameter("phone").equals("")?" ":request.getParameter("phone"));
	String Fax 		  =(request.getParameter("fax").equals("")?"  ":request.getParameter("fax"));

	
	String  exciseRegNo	  =(request.getParameter("exciseRegNo").equals("")?"  ":request.getParameter("exciseRegNo"));
	String  exciseRange	  =(request.getParameter("exciseRange").equals("")?"  ":request.getParameter("exciseRange"));
	String  exciseDivision	  =(request.getParameter("exciseDivision").equals("")?"  ":request.getParameter("exciseDivision"));
	String  exciseComm	  =(request.getParameter("exciseComm").equals("")?"  ":request.getParameter("exciseComm"));
	String  cstNum		  =(request.getParameter("cstNum").equals("")?"  ":request.getParameter("cstNum"));
	String  lstNum		  =(request.getParameter("lstNum").equals("")?"  ":request.getParameter("lstNum"));
	String  permanentAccNum	  =(request.getParameter("permanentAccNum").equals("")?"  ":request.getParameter("permanentAccNum"));
	String  serviceTaxRegNum  =(request.getParameter("serviceTaxRegNum").equals("")?"  ":request.getParameter("serviceTaxRegNum"));
	
	
	String code		  = request.getParameter("plantCode");


	if(name.indexOf("&")>-1)
		name = name.replaceAll("&","&amp;");
	if(category.indexOf("&")>-1)
		category = category.replaceAll("&","&amp;");	
	if(address.indexOf("&")>-1)
		address = address.replaceAll("&","&amp;");
	if(eccnumber.indexOf("&")>-1)
		eccnumber = eccnumber.replaceAll("&","&amp;");
		
	if(tinno.indexOf("&")>-1)
		tinno = tinno.replaceAll("&","&amp;");
	if(location.indexOf("&")>-1)
		location = location.replaceAll("&","&amp;");
	if(cst.indexOf("&")>-1)
		cst = cst.replaceAll("&","&amp;");
	if(phone.indexOf("&")>-1)
		phone = phone.replaceAll("&","&amp;");
		
	if(code.indexOf("&")>-1)
		code = code.replaceAll("&","&amp;");
	if(Fax.indexOf("&")>-1)
		Fax = Fax.replaceAll("&","&amp;");	
	if(exciseRegNo.indexOf("&")>-1)
		exciseRegNo = exciseRegNo.replaceAll("&","&amp;");		
	if(exciseRange.indexOf("&")>-1)
		exciseRange = exciseRange.replaceAll("&","&amp;");
		
	if(exciseDivision.indexOf("&")>-1)
		exciseDivision = exciseDivision.replaceAll("&","&amp;");
	if(exciseComm.indexOf("&")>-1)
		exciseComm = exciseComm.replaceAll("&","&amp;");	
	if(cstNum.indexOf("&")>-1)
		cstNum = cstNum.replaceAll("&","&amp;");
	if(lstNum.indexOf("&")>-1)
		lstNum = lstNum.replaceAll("&","&amp;");
		
	if(permanentAccNum.indexOf("&")>-1)
		permanentAccNum = permanentAccNum.replaceAll("&","&amp;");		
	if(serviceTaxRegNum.indexOf("&")>-1)
		serviceTaxRegNum = serviceTaxRegNum.replaceAll("&","&amp;");	
		
		
	//Fax=request.getParameter("fax");
	//out.println(name+":"+address1+":"+address2+":"+city+":"+state+":"+country+":"+centralexice+":"+cst+":"+phone+":"+sbu+":"+code);
	//out.println(name+":"+address+":"+eccnumber+":"+tinno+":"+location+":"+Fax+":"+cst+":"+phone+":"+category+":"+code);

	try
	{
		DocumentBuilderFactory docFactory = javax.xml.parsers.DocumentBuilderFactory.newInstance();
		DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

		String fileName = "ezAddSaveSbuPlantAddress.jsp";
		String filePath=request.getRealPath(fileName);
		filePath=filePath.substring(0,filePath.indexOf(fileName));
		filePath += "\\ezSbuPlantAddress.xml";

		Document doc = docBuilder.parse("file:"+filePath);

		Element root = doc.getDocumentElement();
		Element element=null;
		element=doc.createElement("EzPlant");
		element.setAttribute("code",code);
		//element.setAttribute("sbu",sbu);

		Node nodeelement=(Node)element;

		Node nodename=null;
		Node nodevalue=null;
		
		nodename=(Node)doc.createElement("Name");
		nodevalue=doc.createTextNode(name);
		nodename.appendChild(nodevalue);
		nodeelement.appendChild(nodename);

		nodename=(Node)doc.createElement("Category");
		nodevalue=doc.createTextNode(category);
		nodename.appendChild(nodevalue);
		nodeelement.appendChild(nodename);

		nodename=(Node)doc.createElement("Address");
		nodevalue=doc.createTextNode(address);
		nodename.appendChild(nodevalue);
		nodeelement.appendChild(nodename);

		nodename=(Node)doc.createElement("Eccnumber");
		nodevalue=doc.createTextNode(eccnumber);
		nodename.appendChild(nodevalue);
		nodeelement.appendChild(nodename);

		nodename=(Node)doc.createElement("Tinno");
		nodevalue=doc.createTextNode(tinno);
		nodename.appendChild(nodevalue);
		nodeelement.appendChild(nodename);

		nodename=(Node)doc.createElement("Location");
		nodevalue=doc.createTextNode(location);
		nodename.appendChild(nodevalue);
		nodeelement.appendChild(nodename);


		nodename=(Node)doc.createElement("CST");
		nodevalue=doc.createTextNode(cst);
		nodename.appendChild(nodevalue);
		nodeelement.appendChild(nodename);

		nodename=(Node)doc.createElement("Phone");
		nodevalue=doc.createTextNode(phone);
		nodename.appendChild(nodevalue);
		nodeelement.appendChild(nodename);
		
		nodename=(Node)doc.createElement("Fax");
		nodevalue=doc.createTextNode(Fax);
		nodename.appendChild(nodevalue);
		nodeelement.appendChild(nodename);
		
		
		
		nodename=(Node)doc.createElement("ExciseRegNo");
		nodevalue=doc.createTextNode(exciseRegNo);
		nodename.appendChild(nodevalue);
		nodeelement.appendChild(nodename);	
		
		nodename=(Node)doc.createElement("ExciseRange");
		nodevalue=doc.createTextNode(exciseRange);
		nodename.appendChild(nodevalue);
		nodeelement.appendChild(nodename);
		
		nodename=(Node)doc.createElement("ExciseDivision");
		nodevalue=doc.createTextNode(exciseDivision);
		nodename.appendChild(nodevalue);
		nodeelement.appendChild(nodename);
		
		nodename=(Node)doc.createElement("ExciseComm");
		nodevalue=doc.createTextNode(exciseComm);
		nodename.appendChild(nodevalue);
		nodeelement.appendChild(nodename);
		
		nodename=(Node)doc.createElement("CstNum");
		nodevalue=doc.createTextNode(cstNum);
		nodename.appendChild(nodevalue);
		nodeelement.appendChild(nodename);
		
		nodename=(Node)doc.createElement("LstNum");
		nodevalue=doc.createTextNode(lstNum);
		nodename.appendChild(nodevalue);
		nodeelement.appendChild(nodename);
		
		nodename=(Node)doc.createElement("PermanentAccNum");
		nodevalue=doc.createTextNode(permanentAccNum);
		nodename.appendChild(nodevalue);
		nodeelement.appendChild(nodename);
		
		nodename=(Node)doc.createElement("ServiceTaxRegNum");
		nodevalue=doc.createTextNode(serviceTaxRegNum);
		nodename.appendChild(nodevalue);
		nodeelement.appendChild(nodename);
		
		
		
		Node rootelement=(Node)root;
		root.appendChild(nodeelement);

		TransformerFactory factory = TransformerFactory.newInstance();
		Transformer transformer = factory.newTransformer();

		transformer.transform(new DOMSource(root),new StreamResult(new FileOutputStream(filePath)));

	}
	catch(Exception e)
	{
		out.println(e);
	}

	response.sendRedirect("ezListSbuPlantAddresses.jsp");
%>