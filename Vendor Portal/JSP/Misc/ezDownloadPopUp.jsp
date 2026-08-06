<%//@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<html>
<head><title>Attachment</title>
<%
	String filestring = request.getParameter("filestring");
%>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<script>
function Download(path)
{	
	//alert(path)
	window.open("ezDownload.jsp?path="+path,"Download","resizable=no,left=0,left=0,top=132,height=0,width=0,status=no,toolbar=no,menubar=no,location=no");
	//window.showModalDialog("ezDownload.jsp?path="+path,"ALERT","center=yes;dialogHeight=10;dialogWidth=30;help=no;titlebar=no;status=no;minimize:no")	
	
}
</script>
 <%
 	String path = request.getParameter("path");
 	File file = new File("E:/VendorAssessment/"+path);
 	File[] files = null;
 	String[] fileName = null;
 	try
	{		
		files = file.listFiles();
		fileName = new String[files.length];
		for(int i=0;i<files.length;i++)
		{
			if(files[i]!=null && files[i].getName()!=null && !"".equals(files[i].getName().trim()) && !"null".equals(files[i].getName().trim()))
				fileName[i]=files[i].getName();
			//out.println("files[i]	"+files[i]);	
		}
	}
	catch(Exception e)
	{
		out.println(""+e);
	}
	        	
%>
<body  scroll=no>
<form name="myForm">
<%
	String display_header	= "Download File";
%>
<%@ include file="../Misc/ezDisplayHeader.jsp" %>
<center>
	<table width="40%">
	<tr><td><b></b></td>
	<tr><td class="blankcell"><br></td>
	<tr><td class="blankcell">Download the file by clicking on it.</td>
	</tr></table>
	<table width="40%" border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
	<tr>
	<th colspan=3 align="left">Download Files</th>
	</tr>
<%
	for(int i=0;i<fileName.length;i++)
	{
%>	
	<tr>
	<td align="center"><a href="JavaScript:void(0)" onClick=Download('<%=path%>/<%=fileName[i].replaceAll(" ","~")%>')><%=fileName[i]%></a>&nbsp;</td>
	</tr>
<%	
	}
%>
	</table>
	</center>
<Div align='center' style='position:absolute;top:88%'>
		<Table align="center" width="100%" >
			<Tr align="center">
				<Td class=blankcell>
	<%
		buttonName = new java.util.ArrayList();
		buttonMethod = new java.util.ArrayList();
		buttonName.add("Back");
		buttonMethod.add("history.go(-1)");
		
		out.println(getButtonStr(buttonName,buttonMethod));
	%>			
				</Td>
			</Tr>
		</Table>
</Div>	
</form>
<Div id="MenuSol"></Div>
</body>
</html>	