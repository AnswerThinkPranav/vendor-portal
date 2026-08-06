<%//@ include file="../../Library/Globals/errorPagePath.jsp"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/JSPs/Labels/iViewAttachmentFile_Labels.jsp"%>
<%@ page import="java.util.*" %>
<%@ include file="../../../Includes/JSPs/Materials/iGetUploadTempDir.jsp" %>
<%
	String serverFileName = request.getParameter("serverfiles");
	String uploadedBy = request.getParameter("uploadedBy");
	String uploadedByArry[]=uploadedBy.split("µ");
	//out.println("uploadedBy.=="+uploadedBy);
	//out.println("uploadedByArry.lengfth=="+uploadedByArry.length);
	
%>
<html>
<head>
	<title>Attachments</title>
	<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
	<script>
	function funDone()
	{
		window.close();
	}
	</script>

<script>
function funOpenFile(serverFileInd)
{

  serverFile = eval("document.myForm.upFile"+serverFileInd).value
  var fVal = serverFile.split('*')
  sFile="";
  for(var i=0;i<fVal.length;i++)
  {
      sFile = sFile+fVal[i]+"/"
  }
  sFile = sFile.substring(0,sFile.length-1)
  window.open("../Misc/ezViewFile.jsp?filename=<%=uploadFilePathDir%>"+sFile,"newWin","titlebar=yes")
  //document.location.href="/<%=uploadFilePathDir%>"+sFile
}

</script>

</head>
<body >
<%
	String bool="false";

	Vector vcfiles=new Vector();
	Vector vsfiles=new Vector();

	String cfiles=request.getParameter("filestring");
	String sfiles=request.getParameter("serverfiles");

	StringTokenizer cstk=new StringTokenizer(cfiles,"§");
	StringTokenizer sstk=new StringTokenizer(sfiles,"µ");

	while(cstk.hasMoreElements())
	{
		vcfiles.addElement(cstk.nextToken());
		vsfiles.addElement(sstk.nextToken());
	}
%>
<form name="myForm">

	<table width="90%" align=center border=0>
	<tr><td><%=attFiles_L%></td></tr>
	<tr><td class="blankcell"><hr></td></tr>
	<tr><td class="blankcell"><%=clkViewSav_L%></td></tr>
	</table>

	<br>
	<table width="90%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
	<%
	String vendCode = ((String)session.getValue("SOLDTO")).trim();
	//out.println("vendCode=="+vendCode);
	//out.println("Session.getUserId()=="+Session.getUserId());
	
	if(vcfiles.size()>0)
	{
%>
		<tr>
			<Th>Uploaded By</Th>
			<th  align="left">Document</th>
			
		</tr>
<%
		bool="true";
		for(int i=0;i<vcfiles.size();i++)
		{
%>
			<tr>
				
				<Td>
				<%=uploadedByArry[i]%>
				</Td>
				<td align="left">
				<input type='hidden' name='upFile<%=i%>' value='<%=(String)vsfiles.elementAt(i)%>'>
				<a href='javascript:funOpenFile(<%=i%>)'><%=(String)vcfiles.elementAt(i)%></a>
				<input type="hidden"   value="" name="serverfile">
				</Td>
				
			</tr>
<%
		}
	}
%>
	</table><br>
<%
	if(bool.equals("false"))
	{
%>
		
		<!-- <br><br>
		<TABLE align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
		<tr>
			<Th><%=noFilesPres_L%></th>
		</tr>
		</table> -->
		<% String noDataStatement = noFilesPres_L;%>
		<%@ include file="../Misc/ezDisplayNoData.jsp" %>
		
<%
	}
%>


	
	

<div id="ButtonDiv" align="center" style="postion:absolute;top:90%">
<center>
<%
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();

	buttonName.add("Close");
	buttonMethod.add("funDone()");

	out.println(getButtonStr(buttonName,buttonMethod));
%>
</center>
</div>


	<input type="hidden" name="shipupload" value="<%=request.getParameter("filestring")%>" >
	<input type="hidden" name="shipserver" value="<%=request.getParameter("serverfiles")%>" >
</form>
<Div id="MenuSol"></Div>
</body>
</html>
