<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Reports/iSaveExecuteReport.jsp"%>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp"%> 
<html>
<head>
<Script>
	function qcfPrint()
	{
		divObj = document.getElementById("ButtonsDiv");
		divObj.style.visibility="hidden"
		window.print();
		divObj.style.visibility="visible"
	}
</Script>
<Script src="../../Library/JavaScript/Rfq/ezQCS.js"></Script>
</head>
<body>
<Form name="myForm" method="post">
	

<input type=hidden name='QcfNumber' 	value='<%=request.getParameter("qcfNo")%>'>


<table align=center border="0" cellpadding="0" style=' background-color:#e6e6e6' cellspacing="0" width="100%">
<tr>
    <td style='color: #006666;font-family: verdana, arial;font-size: 12px;font-weight: 600;text-decoration: none;'  width="60%" align=center>Report</td>
</tr>
</table>
<%
int count = 0;  
if("B".equals(exeType))
{
	
	ReturnObjFromRetrieve objNo=(ReturnObjFromRetrieve)bexec.getObject("EXECINFO");
	String autoNo = objNo.getFieldValueString(0,"EXECNO");
	response.sendRedirect("ezDisplay.jsp?autoNo="+autoNo);
}
else
{
    
try
{

	
	count = outTable.getRowCount();
	
	
                 
         
	if ( outTable != null && count>0)
	{
		for ( int i = 0 ; i < count; i++ )
		{
			
		        String line = outTable.getLine(i);
		        
                        if (line.length() == 257)
                                line = line.substring(1,line.length()-1);
                        else
                                line = line.substring(1,line.length());
                                
                        line = line.replaceAll("<td","<td align=right");        
                        out.print(line);
	        	
		}
	}else{
%>
<br><br><br><br>
  <Table  width="60%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
	<Tr align="center">
    		<Td class="displayheader">There is no output from SAP for passed parameters </Td>
  	</Tr>
</Table>
<br><br><br><br>	
<%	}
	
       

}catch(Exception e)
{
%>
<br><br>
  <Table  width="95%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
	<Tr align="center">
    		<Td class="displayheader">There is no output for passed parameters </Td>
  	</Tr>
</Table>
	
<%
}
}
%>

<Div id="ButtonsDiv" align=center style="visibility:visible;width:100%;">    
<%
	
	buttonName.add("Back");   
	buttonMethod.add("history.go(-1)");
	if(count>0)	
	{
		buttonName.add("Print");   
		buttonMethod.add("qcfPrint()");
	}	
	buttonName.add("Requote");   
        buttonMethod.add("reQuote()");
	out.println(getButtonStr(buttonName,buttonMethod));
%>
</Div>


 <Div id="MenuSol"></Div>  
</Form>
</body>
</html>

