<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ page import="java.util.*" %>
<%@ include file="../../../Includes/Jsps/Misc/iblockcontrol.jsp" %>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/JSPs/Misc/iNewQcfQueries.jsp" %>
<html>
<head>
<script>
	var tabHeadWidth=95
	var tabHeight="65%"
</script>
<Script src="../../Library/JavaScript/ezTabScroll.js"></Script>
<Script src="../../Library/JavaScript/Misc/ezNewQcfQueries.js"></Script>
<Title>Queries List -- Powered by EzCommerce India(An The Hackett Group Company)</Title>

<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<Script>
function SAPView(num)
{
	var url="../RFQ/ezQCFSAPPrint.jsp?qcfNumber="+num;
	var sapWindow=window.open(url,"newwin","width=850,height=650,left=20,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
}
</Script>
</head>
<body onLoad="scrollInit()" onresize="scrollInit()" scroll=no>
<form name="myForm">
<input type=hidden name='QcfNumber'>
<input type=hidden name='qcsCommentNo'>
<input type=hidden name='Type'>
<%
	String display_header = "Queries";
	if(!"Y".equals(offlinex))
	{
%>
		<%@ include file="../Misc/ezDisplayHeader.jsp"%>
<%
		
	}
	out.println("<BR>");
	if(qcsRetCnt>0)
	{
%>
		<Div id="theads">
			<Table  id="tabHead"  width="95%" align=center border=<%=border%> borderColorDark=#ffffff borderColorLight=#006666 cellPadding=5 cellSpacing=0>
				<Tr>
					<Th width="8%" align="left">Doc No</Th>
					<Th width="18%" align="left">Sent By</Th>
					<Th width="12%" align="left">Sent On</Th>
					<Th width="53%" align="left" colspan=2>Query</Th>
					<Th width="9%" align="center" colspan=2>Reply</Th>
				</Tr>
			</Table>
		</Div>
		<DIV id="InnerBox1Div" style="overflow:auto;position:absolute;width:95%;height:57%;left:2%">
		<Table id="InnerBox1Tab" align=center width=100%  border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=5 cellSpacing=1 >
<%	
			String docNo = "",docType="",vendorNo="";
			for(int i=0;i<qcsRetCnt;i++)
			{
				docNo = qcsRet.getFieldValueString(i,"QCF_CODE");
				docType = qcsRet.getFieldValueString(i,"QCF_EXT2");
				vendorNo = qcsRet.getFieldValueString(i,"SOLD_TO");
%>
				<Tr>
<%
					if("QCF".equals(docType))
					{
%>
						<Td width="8%"><a href='javascript:SAPView("<%=docNo%>")'><%=docNo%></a></Td>
<%
					}
					else if("PO".equals(docType))
					{
						if("Y".equals(offlinex))
						{
%>
							<Td width="8%"><a href='../Purorder/ezBlockedOfflinePoLineitems.jsp?type=QUERY_DETAILS&vendorNo=<%=vendorNo%>&PurchaseOrder=<%=docNo%>&Syskey=<%=qcsRet.getFieldValueString(i,"SYSKEY")%>'><%=docNo%></a></Td>
<%
						}
						else
						{
%>
							<Td width="8%"><a href='../Purorder/ezBlockedPoLineitems.jsp?type=QUERY_DETAILS&vendorNo=<%=vendorNo%>&PurchaseOrder=<%=docNo%>&Syskey=<%=qcsRet.getFieldValueString(i,"SYSKEY")%>'><%=docNo%></a></Td>
<%						
						}
					}
					else if("CON".equals(docType))
					{
						if("Y".equals(offlinex))
						{
%>
							<Td width="8%"><a href='../Rfq/ezGetOfflineAgrmtDetails.jsp?viewType=QUERY_DETAILS&agmtNo=<%=docNo%>'><%=docNo%></a></Td>
<%
						}
						else
						{
%>
							<Td width="8%"><a href='../Rfq/ezGetAgrmtDetails.jsp?viewType=QUERY_DETAILS&agmtNo=<%=docNo%>'><%=docNo%></a></Td>
<%						
						}
					}
%>					
					<Td width="18%"><%=getUserName(Session,qcsRet.getFieldValueString(i,"QCF_USER"),"U",(String)session.getValue("SYSKEY"))%></Td>
					<Td width="12%"><%=globalRet.getFieldValueString(i,"QCF_DATE")%></Td>
					<Td width="53%"><%=qcsRet.getFieldValueString(i,"QCF_COMMENTS")%></Td>
					<Td align="center" width=8%><a href="JavaScript:funOpenReplyWin('<%=qcsRet.getFieldValueString(i,"QCF_CODE")%>','<%=qcsRet.getFieldValueString(i,"QCF_COMMENT_NO")%>','<%=qcsRet.getFieldValueString(i,"QCF_DEST_USER")%>','<%=qcsRet.getFieldValueString(i,"QCF_USER")%>','<%=replaceString((replaceString(qcsRet.getFieldValueString(i,"QCF_COMMENTS"),"\"","``")),"'","`")%>','<%=qcsRet.getFieldValueString(i,"QCF_DATE")%>','<%=docType%>','<%=qcsRet.getFieldValueString(i,"SYSKEY")%>')" title="Click To Reply For This Query"><Font color="red">Submit</Font></a></Td>
				</Tr>
		
<%
			}
%>
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
			<Table align="center" style="width:40%" border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=1>				
				<Tr>
					<Th>No New Queries.</Th>
				</Tr>	
			</Table>
			</Div>
<DIV align="center" style="position:absolute;overflow:auto;width:100%;height:40%;top:90%">		
<%
	        buttonName.add("Back");   
	        buttonMethod.add("back()");
	        out.println(getButtonStr(buttonName,buttonMethod));
%>
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
</html>
