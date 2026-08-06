<%@ page import="java.util.Enumeration,javax.servlet.*,javax.servlet.http.*,java.io.*,java.util.*" %>
<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%
	 
	 File file= null;
	 File[] files= null;
	 StringTokenizer stoken = null;
	 String[] filenames= null;
	 String[] filedates= null;
	 int[] 	  noOfFiles= null;
    	try
    	{
       		
       		String dirpath = "E:/VendorAssessment";
       		file=new File(dirpath);
	        files = file.listFiles();
	        filenames = new String[files.length];
	        filedates = new String[files.length];
	        noOfFiles = new int[files.length];
		for(int i=0;i<files.length;i++)
		{
			if(files[i]!=null && files[i].getName()!=null && !"".equals(files[i].getName().trim()) && !"null".equals(files[i].getName().trim()))
			{
				stoken = new StringTokenizer(files[i].getName(),"^^");
				while(stoken.hasMoreTokens())
				{					
					filenames[i]=stoken.nextToken();
					filedates[i]=stoken.nextToken();
					String str = stoken.nextToken();
					
				}
				
				noOfFiles[i] = ((new File(dirpath+"/"+files[i].getName().trim())).list()).length; 
			}
			
		}
       		
       		
       		
       	}
       	catch(Exception e)
       	{
       		out.println(""+e);
       	}
       	
%>
<Script>
function Download(path)
{
	
	document.myForm.action ="../Misc/ezDownloadPopUp.jsp?path="+path;
	document.myForm.submit();
	//document.myForm.action="../Misc/ezDownloadPopUp.jsp";
	//document.myForm.submit()
	//window.open("ezDownloadPopUp.jsp?path="+path,"Download","resizable=no,left=0,left=0,top=132,height=0,width=0,status=no,toolbar=no,menubar=no,location=no");
	

}
</Script>
<Script>
var tabHeadWidth=56
var tabHeight="65%"
</Script>
<script src="../../Library/JavaScript/ezTabScroll.js"></Script>
</head>

<body bgcolor="#FFFFF7" onLoad="scrollInit('SHOWTOT')" onResize="scrollInit('SHOWTOT')">
<form  name="myForm" method="post">
<%
	String display_header	= "Vendor Assessment Forms";
%>
<%@ include file="../Misc/ezDisplayHeader.jsp" %>
<br><br>
<%
	if(filenames.length>0)
	{
%>
<DIV id="theads">
 	<table id="tabHead" width="56%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0>
 	<tr align="center" valign="middle">
    	<th width="50%">Vendor</th>
    	<th width="40%">Upload Date</th>
      	<th width="10%">Files</th>
      	</tr>
 	</table>
 	</div>

	<DIV id="InnerBox1Div" style="overflow:auto;position:absolute;width:56%;height:60%;left:2%">
	<table id="InnerBox1Tab" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0  width="100%">
<%
	
   	for(int i=0;i<filenames.length;i++)
	{	
	
%>
	<tr>
      		<td width="50%" align=left><%=filenames[i]%></td>
      		<td width="40%" align=center><%=filedates[i]%></td>
      		<%
      			if(noOfFiles[i]>0)
      			{
      		%>
      				<td width="10%" align=center><a href="JavaScript:onClick=Download('<%=files[i].getName()%>')"><%=noOfFiles[i]%></a>&nbsp;</td>
      		<%
      			}
      			else
      			{
      		%>	
      				<td width="10%" align=center>0&nbsp;</td>
      		<%
      			}
      		%>	
      	</tr>
<%
	}
	}
	else
	{	
%>	
		<DIV id="theads">
		 <table id="tabHead" width="56%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0>
 		<tr align="center" valign="middle">
		<th width="10%" align=center>Files are not uploaded &nbsp;</th></tr>
		</table>
 		</div>
<%
	}
%>
	</table>
	</div>
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