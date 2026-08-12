<%//@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Reports/iSaveExecuteReport.jsp"%>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp"%> 

<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" />
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*,ezc.ezcommon.*" %> 



<%
	String matNo[]= request.getParameterValues("matNo");
	String RFQNos= request.getParameter("RFQNos");
	String QCFNo= request.getParameter("qcfNo");
	boolean isMassRFQ = false;
	String qcfStatus="";
	
	if(RFQNos==null || "null".equals(RFQNos))RFQNos="";
	//out.println(RFQNos+"::RFQNos");
	
	ezc.ezparam.EzcParams mainParams=new ezc.ezparam.EzcParams(false);
		EziMiscParams miscParams = new EziMiscParams();
		
		miscParams.setQuery("SELECT ERH_RELEASE_INDICATOR QSTATUS,ERH_RFQ_NO,ERH_STATUS,ERH_REQUOTE FROM EZC_RFQ_HEADER WHERE ERH_COLLETIVE_RFQ_NO='"+QCFNo+"'");
		mainParams.setLocalStore("Y");
		mainParams.setObject(miscParams);
		Session.prepareParams(mainParams);
		ReturnObjFromRetrieve retCnt=(ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);
		
		if(retCnt!=null && retCnt.getRowCount()>0)
		{
			qcfStatus=retCnt.getFieldValueString(0,"QSTATUS");
			
			for(int i=0;i<retCnt.getRowCount();i++)
			{
				if("".equals(RFQNos))
				RFQNos = retCnt.getFieldValueString(i,"ERH_RFQ_NO");
				else
				RFQNos = RFQNos+"','"+retCnt.getFieldValueString(i,"ERH_RFQ_NO");
				
			}
			String massRFQ = RFQNos.substring(0,2);
			if("63".equals(massRFQ))isMassRFQ=true;
			
			
		}
	
	//if(retCnt!=null)
%>
<html>
<head>
<Script>
	var newWindow = null;
	function qcfPrint()
	{
		divObj = document.getElementById("ButtonsDiv");
		divObj.style.visibility="hidden"
		window.print();
		divObj.style.visibility="visible"
	}
	function qcfDownload()
	{
		//newWindow=window.open("ezQCFDownload.jsp","VendWin","width=750,height=550,left=20,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
		document.myForm.action="ezQCFDownload.jsp";
		document.myForm.submit();
	}
	function selectVendor(flag)
	{
		var qcfStatus   =  "<%=qcfStatus%>"
		var qcfNum	=  document.myForm.QcfNumber.value
		var uurl	=  document.myForm.action= "ezVendorSelection.jsp";
		
		document.getElementById("ButtonsDiv1").style.visibility="visible"
		document.getElementById("ButtonsDiv").style.visibility="hidden"
		
		document.myForm.target = "PopUp";
		document.myForm.flag.value=flag;
		
		newWindow=window.showModalDialog(uurl+"?flag="+flag+"&isMassRFQ=<%=isMassRFQ%>&QcfNumber="+qcfNum+"&qcfStatus="+qcfStatus+"&myDate="+new Date(),"PopUp","top=5;left=50; resizable=1;scrollbars=yes;toolbar=no;menubar=no;dialogWidth=960px;dialogHeight=600px");
		//newWindow=window.showModalDialog(uurl+"?flag="+flag+"&QcfNumber="+qcfNum+"&myDate="+new Date(),"PopUp","top=5;left=50; resizable=1;scrollbars=yes;toolbar=no;menubar=no;dialogWidth=910px;dialogHeight=600px");
		//newWindow=window.open(uurl+"?flag="+flag+"&QcfNumber="+qcfNum,"PopUp","top=5;left=50; resizable=1;scrollbars=yes;toolbar=no;menubar=no;dialogWidth=910px;dialogHeight=600px");
		document.getElementById("ButtonsDiv1").style.visibility="hidden"
		document.getElementById("ButtonsDiv").style.visibility="visible"
		if(newWindow!="Cancel" )
		window.location = 'ezListQCS.jsp';
	}	
</Script>
<Script src="../../Library/JavaScript/Rfq/ezQCS.js"></Script>
</head>
<body>
<Form name="myForm" method="post">
	
<input type=hidden name='flag' 	value=''>
<input type=hidden name='QcfNumber' 	value='<%=QCFNo%>'>


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
		String temp="";

		for ( int i = 0 ; i < count; i++ )
		{
			
		        String line = outTable.getLine(i);
		        
                        if (line.length() == 257)
                                line = line.substring(1,line.length()-1);
                        else
                                line = line.substring(1,line.length());
                                
                        line = line.replaceAll("<td","<td align=right");        
                        out.print(line);
                        
                        temp=temp+line;	        	
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
	if(count>0)	
	{
		buttonName.add("Print");   
		buttonMethod.add("qcfPrint()");
		//buttonName.add("Download");   
		//buttonMethod.add("qcfDownload()");
	}
	
	if("N".equals(qcfStatus))
	{
	
		buttonName.add("Vendor Selection");
		buttonMethod.add("selectVendor(\"SEL\")");

		buttonName.add("Requote");   
		buttonMethod.add("reQuote()");
        }
        else
        {
		buttonName.add("View Selection");
		buttonMethod.add("selectVendor(\"VIEW\")");
	}
	buttonName.add("Back");   
	buttonMethod.add("history.go(-1)");
	
	out.println(getButtonStr(buttonName,buttonMethod));
%>
</Div>
<Div id="ButtonsDiv1" align=center style="visibility:hidden;width:100%;">    
<Table border=0 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 ><Tr><Th>Please wait .Your Request is being Processed ...</Th></Tr></Table>
</Div>
 <Div id="MenuSol"></Div>  
</Form>
</body>
</html>

