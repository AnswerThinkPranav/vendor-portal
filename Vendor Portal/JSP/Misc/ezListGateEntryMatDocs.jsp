<%//@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/Lib/ezGetDateFormat.jsp" %>           
<%@ page import="java.text.DateFormat,java.text.SimpleDateFormat"%>
<%@ include file="../../../Includes/Jsps/Misc/iListGateEntryMatDocs.jsp"%>      
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@ include file="../Misc/ezJQueryScript.jsp" %>
<Html> 
<Head>     
<Script src="../../Library/JavaScript/ezTrim.js"></Script>
<Script>
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
		
		document.myForm.action = "ezListGateEntryMatDocs.jsp";
		document.myForm.submit(); 
	}	
</Script>
</head>

<Body scroll=no>
<form method="post" name="myForm">
<input type="hidden" id="status" value="">

<%
	String display_header = "List of Gate Entry Material Docs";
%>
	
	<%@ include file="../Misc/ezDisplayHeader.jsp" %>

	<Div style="position:absolute;top:10%;width:100%;left:0%;overflow:auto;height:80%">
	<Table class="data-table" id="example" width='100%' border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>
	<Thead>
	<Tr>
			<th align="center" width="10%">Vendor Ref. No.</th> 	
			<th align="center" width="10%">Material Doc No.</th>
			<th align="center" width="10%">Posted On</th>
			<th align="center" width="10%">PO No.</th>
			<th align="center" width="10%">Material Code</th>
			<th align="center" width="20%">Material Desc.</th>
			<th align="center" width="5%">UOM</th>
			<th align="center" width="10%">Qty</th>
			<th align="center" width="10%">Truck No.</th>
	</Tr>
	</Thead>
	<TBody>		        

<%	
	SimpleDateFormat fromFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S"); 
	DateFormat toFormat = new SimpleDateFormat("dd-MMM-yyyy"); 
  	java.util.Date  dt=new java.util.Date();  
  	int index=0;
	String postDate="",appDate="",ackStatus="",matDocNo="",poNum="",poItemNo="",materialCode="",materialDesc="",UOM="",Qty="",inspecLot="",status="",matPo="",vendRefNo="",truckNo="";
	for(int i=0;i<gateEntryDocsRetObjCnt;i++)    
	 {
	 	 vendRefNo	=checkNull(gateEntryDocsRetObj.getFieldValueString(i,"REF_DOC"));   
		 matDocNo	=checkNull(gateEntryDocsRetObj.getFieldValueString(i,"MATDOCNO"));
		 poNum		=checkNull(gateEntryDocsRetObj.getFieldValueString(i,"PONUM"));
		 poItemNo 	=checkNull(gateEntryDocsRetObj.getFieldValueString(i,"POITEMNO"));
		 materialCode	=checkNull(gateEntryDocsRetObj.getFieldValueString(i,"MATCODE"));
		 materialDesc	=checkNull(gateEntryDocsRetObj.getFieldValueString(i,"MATDESC"));
		 UOM		=checkNull(gateEntryDocsRetObj.getFieldValueString(i,"UOM"));
		 Qty		=checkNull(gateEntryDocsRetObj.getFieldValueString(i,"QTY"));
		 postDate	=checkNull(gateEntryDocsRetObj.getFieldValueString(i,"POSTDATE"));
		 appDate	=checkNull(gateEntryDocsRetObj.getFieldValueString(i,"APPDATE"));
		 truckNo	=checkNull(gateEntryDocsRetObj.getFieldValueString(i,"TRUCK_NO"));
		 
		 		 
%>
		<Tr>
			<td align="left width="10%">&nbsp;<%=vendRefNo%></td>
			<td align="center" width="10%"><%=matDocNo%></td>
			<td align="center" width="10%"><%=postDate%> </td>
			<td align="center" width="10%"><%=poNum%></td>
			<td align="center" width="10%"><%=materialCode%></td>
			<td align="left" width="20%">&nbsp;<%=materialDesc%></td>
			<td align="center" width="5%"><%=UOM%></td>
			<td align=right width="10%"><%=Qty%>&nbsp;</td>
			<td align="left" width="10%">&nbsp;<%=truckNo%></td>
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
 
