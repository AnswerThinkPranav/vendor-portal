<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ page import="java.util.*" %>

<%@ include file="../../../Includes/JSPs/Misc/iNewQcfQueries.jsp" %> 

<html>
<style>
 .datatable-scroll{
 	overflow-x:auto;
 	overflow-y:visible;
 
 }
.dataTables_filter{

margin-right:150px;
}
.dataTables_length{
margin-left:140px;
}
.dataTables_paginate{
margin-right:150px;

}
.dataTables_info{
margin-left:140px;
}
.hide
{
display:none;
}
</style>
<head>
<script>
	var tabHeadWidth=95
	var tabHeight="65%"
</script>
<Script src="../../Library/JavaScript/ezTabScroll.js"></Script>
<Script src="../../Library/JavaScript/Misc/ezNewQcfQueries.js"></Script>
<Title>Queries List -- Powered by EzCommerce India(An Answerthink Company)</Title>

<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<Script>
function SAPView(num)
{
	var url="../Rfq/ezQCFSAPPrint.jsp?qcfNumber="+num;
	var sapWindow=window.open(url,"newwin","width=850,height=650,left=20,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
}
function funShowDetails1(url,type,vendorNo,docNo,Syskey)
{
	var fullUrl=url+"?type="+type+"&vendorNo="+vendorNo+"&PurchaseOrder="+docNo+"&Syskey="+Syskey+"&SYSTEM_KEY="+Syskey;
	var sapWindow=window.open(fullUrl,"newwin","width=850,height=650,left=20,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
}
function funShowDetails2(url,viewType,docNo,docType)
{
	var dType="";
	var dTemp=docType;
	if(dTemp=='CON')dType='agmtNo';
	else if(dTemp=='CONV')dType='docNum';
	else if(dTemp=='WOD')dType='docId';
	var fullUrl=url+"?type="+viewType+"&"+dType+"="+docNo+"&toClose=Y";
	var sapWindow=window.open(fullUrl,"newwin","width=850,height=650,left=20,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
}
</Script>
</head>
<body onLoad="scrollInit()" onresize="scrollInit()" scroll=no>
<form name="myForm">
<input type=hidden name='QcfNumber'>
<input type=hidden name='qcsCommentNo'>
<input type=hidden name='Type'>
<%
	String display_header = "";
	
	if(!"Y".equals(offlinex))
	{
%>
		<%@ include file="../Misc/ezDisplayHeader.jsp"%>
<%
		
	}
	out.println("<BR>");
	if(qcsRetCnt>0)
	{
	
			
			/*
			Vector grtypes = new Vector();
			grtypes.addElement("date");
			
			
			EzGlobal.setColTypes(grtypes);
			//EzGlobal.setDateFormat("MM.dd.yyyy hh:mm");
	
			Vector grColNames = new Vector();
			grColNames.addElement("QCF_DATE");
			EzGlobal.setColNames(grColNames);
	
			globalRet = EzGlobal.getGlobal(qcsRet);*/
	

	
%>
		<Div id="theads">
			<!--<Table  id="tabHead"  width="95%" align=center border=<%=border%> borderColorDark=#ffffff borderColorLight=#006666 cellPadding=5 cellSpacing=1>-->
			<table id="tabHead" width="80%" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 class="table table-hover table-condensed" >
		<thead>
				<Tr>
					<Th width="8%" align="left">Doc No&nbsp;&nbsp;<a href="#"><span class="glyphicon glyphicon-sort"></span></a></Th>
					<Th width="18%" align="left">Sent By&nbsp;&nbsp;<a href="#"><span class="glyphicon glyphicon-sort"></span></a></Th>
					<Th width="12%" align="left">Sent On&nbsp;&nbsp;<a href="#"><span class="glyphicon glyphicon-sort"></span></a></Th>
					<Th width="53%" align="left" >Query&nbsp;&nbsp;<a href="#"><span class="glyphicon glyphicon-sort"></span></a></Th>
					<Th width="9%" align="center">Reply&nbsp;&nbsp;<a href="#"><span class="glyphicon glyphicon-sort"></span></a></Th>
				</Tr>
		</thead>
			<!--</Table>
		</Div>
		<DIV id="InnerBox1Div" style="overflow:auto;position:absolute;width:95%;height:57%;left:2%">
		<Table id="InnerBox1Tab" align=center width=100%  border=0 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=5 cellSpacing=1 >-->
		<tbody>
<%	
			java.util.Hashtable collSyskey=new java.util.Hashtable();
			
			String docNo = "",docType="",vendorNo="";
			for(int i=0;i<qcsRetCnt;i++)
			{
				docNo = qcsRet.getFieldValueString(i,"EQC_CODE");
				//out.println("docNo::"+docNo);
				docType = qcsRet.getFieldValueString(i,"EQC_EXT2");
				//out.println("docType::"+docType);
				//vendorNo = qcsRet.getFieldValueString(i,"SOLD_TO");
				
				//collSyskey.put(docNo.trim(),qcsRet.getFieldValueString(i,"SYSKEY"));
				
				String requiDate=qcsRet.getFieldValueString(i,"EQC_DATE");
				//out.println("requiDate"+requiDate);
				String requiDat="";
				requiDat=requiDate.substring(6,10)+requiDate.substring(3,5)+requiDate.substring(0,2);
				//out.println("requiDate"+requiDat);
%>
				<Tr>
					<Td width="8%"><%=docNo%></Td>
					<Td width="18%"><%=getUserName(Session,qcsRet.getFieldValueString(i,"EQC_USER"),"U",(String)session.getValue("SYSKEY"))%></Td>
					<Td width="12%"><span id="datehid" hidden="hidden"><%=requiDat%></span><%=qcsRet.getFieldValueString(i,"EQC_DATE")%></Td>
					<Td width="53%"><%=qcsRet.getFieldValueString(i,"EQC_COMMENTS")%></Td>
					<Td align="center" width="9%"><a href="JavaScript:funOpenReplyWin('<%=qcsRet.getFieldValueString(i,"EQC_CODE")%>','<%=qcsRet.getFieldValueString(i,"EQC_COMMENT_NO")%>','<%=qcsRet.getFieldValueString(i,"EQC_DEST_USER")%>','<%=qcsRet.getFieldValueString(i,"EQC_USER")%>','<%=replaceString((replaceString(qcsRet.getFieldValueString(i,"EQC_COMMENTS"),"\"","``")),"'","`")%>','<%=qcsRet.getFieldValueString(i,"EQC_DATE")%>','<%=docType%>','<%=qcsRet.getFieldValueString(i,"SYSKEY")%>')" title="Click To Reply For This Query"><Font color="red">Submit</Font></a></Td>
					
					
									
				</Tr>
		
<%
			}
			//session.putValue("COLLSYSKEY",collSyskey);
%>
			</tbody>
			</Table>
		</Div>	
<%
	}
	else
	{
		if(!"Y".equals(offlinex))
		{
%>
			<DIV align="center" style="position:absolute;overflow:auto;width:100%;height:40%;top:40%">		
			<Table align="center" style="width:40%" border=0 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=1>				
				<Tr>
					<Th>No New Queries.</Th>
				</Tr>	
			</Table>
			</Div>
<DIV align="center" style="position:absolute;overflow:auto;width:100%;height:40%;top:90%">		
	<button type="button" class="btn btn-primary" onclick="javascript:history.go(-1)" ><i class="fa fa-backward"></i>&nbsp;Back</button>
</Div>
<%
		}
		else
		{
			response.sendRedirect("../Misc/ezOfflineMessage.jsp?MESSAGE=No Queries posted to you&DEFAULT_PAGE=EMPTY");
		}
	}
%>	
<Div id="MenuSol">
</Div>	
</form>
</body>
<link rel="stylesheet" href="../Mobile/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="../Mobile/font-awesome/4.5.0/css/font-awesome.min.css">
<link type="text/css" href="../Mobile/library/css/jquery.dataTables.css" rel="stylesheet" media="all">
<link rel="stylesheet" type="text/css" href="//cdn.jsdelivr.net/bootstrap.daterangepicker/1/daterangepicker-bs3.css" />
<script src="../Mobile/plugins/jQuery/jQuery-2.1.4.min.js"></script>
<script type="text/javascript" src="../Mobile/library/jquery-ui-1.10.4/js/jquery-ui-1.10.4.custom.js"></script>
<script type="text/javascript" src="../Mobile/library/js/jquery.dataTables.js"></script>
<script src="../Mobile/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="//cdn.jsdelivr.net/momentjs/2.9.0/moment.min.js"></script>
<script type="text/javascript" src="//cdn.jsdelivr.net/bootstrap.daterangepicker/1/daterangepicker.js"></script>
<script>
$(document).ready( function () {
   

//alert($('#tabHead').DataTable().page.len());
  var table = $('#tabHead').DataTable({
 
		//"bStateSave": true,
		"order":[[2,'desc']],
		"lengthMenu":[[10,25,50,-1],[10,25,50,"All"]],
		 "bScrollCollapse":true,
		// "sScrollY":100//$('#tabHead tbody tr').length>25?300:""
		 //  "scrollX":false
		 	
		 // "iDisplayLength":25

 
		
	});
	// alert("count"+table.page.len());
} );
</script>
</html>
