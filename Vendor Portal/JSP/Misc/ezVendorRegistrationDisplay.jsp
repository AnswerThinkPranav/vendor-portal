<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@ include file="../../../Includes/JSPs/Inbox/iGetUploadTempDir.jsp"%>
<%@ page import = "java.io.*,java.util.*"%>

<%

	site=null;
	String certPath = "";
	try
	{
		site = ResourceBundle.getBundle("Site");
		certPath = site.getString("CERTIFICATEPATH");
	}
	catch(Exception e)
	{}

	String vendorCode=(String)session.getAttribute("SOLDTO");
	
	String filePath = certPath+vendorCode;
	
%>
<Html>
<Head>
<Title>VIew Attachments</Title>
</Head>
<Body>
<Form>
<% 
	
	File folder = new File(filePath);
	File[] listOfFiles = folder.listFiles();
	if(listOfFiles == null)
	{
		out.println("<br><br><br><br><br><h3 style='color:red;' align='center'>No files to display</h3>");
	}
	else
	{
%>	
		<br><br><br>
		<table align=center width='70%' border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>
		<tr>
			<th width=100%>
				Click on the below file link to View or Save.
			</th>	
		</tr>	
<%
		for (int i = 0; i < listOfFiles.length; i++) 
		{
			if (!"Thumbs.db".equals(listOfFiles[i].getName())) 
			{
%>
			<tr>
				<td width=100% align='left'>
					<a href="ezFileDownLoadVendors.jsp?listoffiles=<%=listOfFiles[i].getName()%>&&pathName=<%=filePath%>" target=_blank><h5 align='center'><%=listOfFiles[i].getName()%></a>
				</td>	
				 
			</tr>		
<%
				
			} 
		}
%>
		</table>
<%
	}    
%>

<Div id="ButtonDiv" align="center" style="position:absolute;top:90%;width:100%">

<%
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();
	buttonName.add("Ok");
	buttonMethod.add("window.close()");
	out.println(getButtonStr(buttonName,buttonMethod));
%>
</div>
<Div id="MenuSol"></Div>