
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp"%>
<%@ include file="../../../Includes/JSPs/Inbox/iGetUploadTempDir.jsp"%>
<%@ page import = "java.io.*,java.util.*"%>

<%
	
	
	String	pathName = request.getRealPath("/")+"\\Uploads\\"+"DOCS";
	
	
%>
<Html>
<Head>
<Title>VIew Attachments</Title>

</Head>
<Body>
<Form>
<% 	
	File folder = new File(request.getRealPath("/")+"//Uploads//"+"DOCS");
	File[] listOfFiles = folder.listFiles();
	//out.println("folder:::"+folder);
	//out.println("listOfFiles:::"+listOfFiles.length);
	if(listOfFiles == null || listOfFiles.length == 0 )
	{
%>
		<br><br><br>
		<table align=center width='75%' border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>
		<tr>
			<th width=100%>
				
				No files to display
			</th>	
		</tr>	
		</table>
<%
	}
	else
	{
%>			<br><br><br>
		<table align=center width='100%' border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>
		<tr>
			<th width=100%>
				Click on the below file link to View or Save.
			</th>	
		</tr>	
<%
		for (int i = 0; i < listOfFiles.length; i++) 
		{
			if (listOfFiles[i].isFile() && !"Thumbs.db".equals(listOfFiles[i].getName())) 
			{
%>
			<tr>
				<td width=100% align='left'>
					<a href="ezFileDownloadDocs.jsp?listoffiles=<%=listOfFiles[i].getName()%>&&pathName=<%=pathName%>" target=_blank><h5 align='center'><%=listOfFiles[i].getName()%></a>					
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

<Div id="ButtonDiv" align="center" style="position:absolute;top:80%;width:100%">

<%
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();
	buttonName.add("Ok");
	buttonMethod.add("window.close()");
	out.println(getButtonStr(buttonName,buttonMethod));
%>
</div>
<Div id="MenuSol"></Div>