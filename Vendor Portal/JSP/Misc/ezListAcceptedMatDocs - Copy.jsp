<%//@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/Lib/ezGetDateFormat.jsp" %>           
<%@ page import="java.text.DateFormat,java.text.SimpleDateFormat,java.util.Hashtable"%>
                     
<% 
	String fromDate = request.getParameter("fDate");
	String toDate   = request.getParameter("tDate");     
	int dateRange = 30;        
%>  
<%@ include file="../../../Includes/Jsps/Misc/iListAcceptedMatDocs.jsp"%> 

<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@ include file="../Misc/ezJQueryScript.jsp" %>
<Html>   
<Head>    
<Script src="../../Library/JavaScript/ezTrim.js"></Script>
<Script>               
	function funAck(ind,doc,poNum,poItemNum,postDate)   
	{
	    	var w = 500;
		var h = 500;
		var left = Number((screen.width/2)-(w/2)); 
		var top = Number((screen.height/2)-(h/2));

	    	var url = "ezAckMatDocument.jsp?doc="+doc+"&ind="+ind+"&poNum="+poNum+"&poItemNum="+poItemNum+"&postDate="+postDate;
		window.open(url,"UserWindow","width=700,height=250, left ="+left+" top ="+top+" resizable=no,help=no,titlebar=no,status=off, menubar = no,minimize=no, locationbar = no scrollbars=yes");
	}
	function ezBack(event)        
	{
		document.location.href = event;
	}
	function ezSubmit()
	{
		var fromDate = document.myForm.FromDate.value;
		var toDate   = document.myForm.ToDate.value;
		
		if(fromDate > toDate)
		{
			alert("From Date should be less than To Date!!");
			return false;
		}
		
		document.myForm.action = "ezListAcceptedMatDocs.jsp";
		document.myForm.submit(); 
	}
	function  viewRejectedMat(docId)
	{
		window.open("ezRejectMatDownload.jsp?docId="+docId+"&dt="+new Date(),"UserWindow","width=500,height=300,left=150,top=100,resizable=yes,scrollbars=yes,toolbar=no,menubar=no");
	}
	function  viewResult(inspLotNo)
	{
		window.open("ezViewResults.jsp?inspLotNo="+inspLotNo,"UserWindow","width=600,height=400,left=150,top=100,resizable=yes,scrollbars=yes,toolbar=no,menubar=no");
	}
	function  uploadCAPA()
	{
		alert("upload capa")
	}
	
</Script>
</head>

<Body scroll=no>
<form method="post" name="myForm">
<input type="hidden" id="status" value="">

<%
	String display_header = "List of Accepted Material Docs";
%>
	
	<%@ include file="../Misc/ezDisplayHeader.jsp" %>

	<Div style="position:absolute;top:10%;width:100%;left:0%;overflow:auto;height:80%">
	<Table class="data-table" id="example" width='100%' border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>
	<Thead>
	<Tr>
			<th align="center" width="10%">Vendor Ref. No.</th>	
			<th align="center" width="10%">Material Doc No.</th>
			<th align="center" width="10%">PO No.</th>  
			<th align="center" width="5%">PO Item No.</th>
			<th align="center" width="10%">Material Code</th>
			<th align="center" width="15%">Material Desc.</th>
			<!--<th align="center" width="5%">UOM</th>--> 
			<th align="center" width="10%"> Qty</th>
			<th align="center" width="15%"> Status</th>
			<th align="center" width="10%"> Results</th>
			
	</Tr>
	</Thead>
	<TBody>		        

<%	
	SimpleDateFormat fromFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S"); 
	DateFormat toFormat = new SimpleDateFormat("dd-MMM-yyyy"); 
  	java.util.Date  dt=new java.util.Date(); 
  	Hashtable htUDType= new Hashtable(); 
  	htUDType.put("A","Accepted");
  	htUDType.put("AC","Accepted with Concession");
  	htUDType.put("AP","Accepted Partially");
  	htUDType.put("AR","Accepted After Rework");
  	htUDType.put("R","Rejected");
  	int index=0;
	String postDate="",appDate="",ackStatus="",matDocNo="",poNum="",poItemNo="",materialCode="",materialDesc="",UOM="",Qty="",inspecLot="",status="",matPo="",udType="",udTypeDesc="",vendRefNo="",inspLotNo="";
	for(int i=0;i<retRejMatDocsObjCnt;i++)    
	 {
	 	 vendRefNo	=checkNull(retRejMatDocsObj.getFieldValueString(i,"REF_DOC"));  
		 matDocNo	=checkNull(retRejMatDocsObj.getFieldValueString(i,"MATDOCNO"));  
		 poNum		=checkNull(retRejMatDocsObj.getFieldValueString(i,"PONUM"));
		 poItemNo 	=checkNull(retRejMatDocsObj.getFieldValueString(i,"POITEMNO"));
		 materialCode	=checkNull(retRejMatDocsObj.getFieldValueString(i,"MATCODE"));
		 materialDesc	=checkNull(retRejMatDocsObj.getFieldValueString(i,"MATDESC"));
		 UOM		=checkNull(retRejMatDocsObj.getFieldValueString(i,"UOM"));
		 Qty		=checkNull(retRejMatDocsObj.getFieldValueString(i,"QTY"));
		 postDate	=checkNull(retRejMatDocsObj.getFieldValueString(i,"POSTDATE"));
		 appDate	=checkNull(retRejMatDocsObj.getFieldValueString(i,"APPDATE"));
		 udType		=retRejMatDocsObj.getFieldValueString(i,"UD_TYPE");
		 udTypeDesc	=checkNull((String)htUDType.get(udType));
		 
		 inspLotNo	=retRejMatDocsObj.getFieldValueString(i,"INSLOT");
		 
		 matPo=matDocNo+"$$"+poItemNo;
		 status="";//(String)ackStat.get(matPo);     
		 
		 		 
%>
		<Tr>
			<td align="center" width="10%"><%=vendRefNo%>&nbsp;</td>
			<td align="center" width="10%"><%=matDocNo%>&nbsp;</td>
			<td align="center" width="10%"><%=poNum%></td>
			<td align="center" width="10%"><%=poItemNo%></td>
			<td align="center" width="10%"><%=materialCode%></td>
			<td align="left" width="15%">&nbsp;&nbsp;&nbsp;<%=materialDesc%></td>
			<!--<td align="center" width="5%"><%=UOM%></td>-->
			<td align="center" width="5%"><%=Qty%></td>
			<td align="center" width="15%"><%=udTypeDesc%></td> 
			<td align="center" width="10%"><a href="JavaScript:viewResult('<%=inspLotNo%>')">Results</a></td>
		</Tr>
	
<%
	index++;
	}
	
%>	

</Tbody>
	</Table>
</Div>	
<%@ include file="ezBackButton.jsp" %>  
</Form>

<Div id='MenuSol'/>
</Body>
</Html>
 

                            