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
			<th align="center" width="10%"><B>Vendor Ref. No.</B></th>	
			<th align="center" width="8%"><B>GR No.</B></th>
			<th align="center" width="8%"><B>PO No.</B></th>  
			<th align="center" width="8%"><B>Material Code</B></th>
			<th align="center" width="18%"><B>Material Desc</B>.</th>
			<th align="center" width="8%"><B>Doc. Qty</B></th>
			<th align="center" width="8%"><B>Shortage Qty</B></th>
			<th align="center" width="8%"><B>Rejected Qty</B></th>
			<th align="center" width="8%"><B>Approved Qty</B></th>
			<th align="center" width="8%"><B>Status</B></th>
			
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
  	htUDType.put("AD","Accepted Under Deviation");
  	
  	int index=0;
	String postDate="",appDate="",ackStatus="",matDocNo="",poNum="",poItemNo="",materialCode="",materialDesc="",UOM="",docQty="",shortageQty="",inspecLot="",status="",matPo="",udType="",udTypeDesc="",vendRefNo="",inspLotNo="",rejQty="";
	for(int i=0;i<retRejMatDocsObjCnt;i++)    
	 {
		vendRefNo	=checkNull(retRejMatDocsObj.getFieldValueString(i,"REF_DOC"));  
		matDocNo	=checkNull(retRejMatDocsObj.getFieldValueString(i,"MATDOCNO"));  
		poNum		=checkNull(retRejMatDocsObj.getFieldValueString(i,"PONUM"));
		poItemNo 	=checkNull(retRejMatDocsObj.getFieldValueString(i,"POITEMNO"));
		materialCode	=checkNull(retRejMatDocsObj.getFieldValueString(i,"MATCODE"));
		materialDesc	=checkNull(retRejMatDocsObj.getFieldValueString(i,"MATDESC"));
		UOM		=checkNull(retRejMatDocsObj.getFieldValueString(i,"UOM"));
		docQty		=checkNull(retRejMatDocsObj.getFieldValueString(i,"RECEIVED_QTY"));
		shortageQty	=checkNull(retRejMatDocsObj.getFieldValueString(i,"SHORTAGE_QTY"));
		postDate	=checkNull(retRejMatDocsObj.getFieldValueString(i,"POSTDATE"));
		appDate		=checkNull(retRejMatDocsObj.getFieldValueString(i,"APPDATE"));
		udType		=retRejMatDocsObj.getFieldValueString(i,"UD_TYPE");
		udTypeDesc	=checkNull((String)htUDType.get(udType));
		inspLotNo	=retRejMatDocsObj.getFieldValueString(i,"INSLOT");
		
		rejQty		=retRejMatDocsObj.getFieldValueString(i,"REJ_QTY");
		
		String	apprQty = "0";
		
		try{
			apprQty = Double.parseDouble(docQty)- (Double.parseDouble(shortageQty)+Double.parseDouble(rejQty))+"";
		}catch(Exception e){}	
		 
		 matPo=matDocNo+"$$"+poItemNo;
		 status="";//(String)ackStat.get(matPo);     
		 
		 
		 		 
%>
		<Tr>
			<td align="center" width="10%"><%=vendRefNo%>&nbsp;</td>
			<td align="center" width="8%"><%=matDocNo%>&nbsp;</td>
			<td align="center" width="8%"><%=poNum%></td>
			<td align="center" width="8%"><%=materialCode%></td>
			<td align="left" width="18%">&nbsp;<%=materialDesc%></td>
			<td align="right" width="8%"><%=docQty%>&nbsp;</td>
			<td align="right" width="8%"><%=shortageQty%>&nbsp;</td>
			<td align="right" width="8%"><%=rejQty%>&nbsp;</td> 
			<td align="right" width="8%"><%=apprQty%>&nbsp;</td> 
			<td align="center" width="8%"><%=udTypeDesc%></td> 
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
 

                            