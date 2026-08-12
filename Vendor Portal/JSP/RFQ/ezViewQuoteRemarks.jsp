<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@page import="ezc.ezutil.*"%>
<html>
<%
	String ReQuote="N";
	String ext3Type = request.getParameter("ext3Type");
	String rfqVend=request.getParameter("rfqVendor");
	String UserType = (String)session.getValue("UserType");
	Hashtable vendorsHT=(Hashtable)session.getValue("VENDORHT");
	String vendorName = (String)vendorsHT.get(rfqVend.trim());
	String frmWeltype = request.getParameter("type");
	String poNum=request.getParameter("PurchaseOrder");
	String OrderDate=request.getParameter("OrderDate");
	
	if(vendorName==null || "null".equals(vendorName)) vendorName="";
	if(frmWeltype!=null && !("null".equals(frmWeltype)) && "New".equals(frmWeltype) )
		ext3Type="ToBeQuote";
		
%>
</Head>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<Script>
var tabHeadWidth="96%"
var tabHeight="65%"


 function addDocuments()
  {
  	var docs = document.myForm.attachDocs.value;
  	//alert("docsdocsdocs	"+docs)
	attach=window.open("../Attachments/ezAttachmentFile.jsp?attachDocs="+docs,"UserWindow","width=550,height=550,left=250,top=100,resizable=yes,scrollbars=no,toolbar=no,menubar=no,status=no");
  }
  function Requote()
  {
  	document.myForm.action ='ezSendToReQuote.jsp';
	document.myForm.submit();
   }

</Script>
<script src="../../Library/JavaScript/ezTabScroll.js"></Script>
</head>

<body bgcolor="#FFFFF7" onLoad="scrollInit('SHOWTOT')" onResize="scrollInit('SHOWTOT')">
<form  name="myForm" method="post">
<input type="hidden" name="attachDocs" value ="" >	
<input type="hidden" name="attachFlag" value ="N">
<input type="hidden" name="Rfqno" value='<%=poNum%>'>
<input type="hidden" name="rfqVend" value='<%=rfqVend%>'>

<%		
		
		
		
	
		//ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate();
		//String OrderDate = fd.getStringFromDate(ordDate,(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")));
		String display_header	= "RFQ Details";
				
%>

<%@ include file="../Misc/ezDisplayHeader.jsp" %>
<Div id='inputDiv' style='position:relative;align:center;top:2%;width:100%;'>
<Table width="60%" border="0" cellspacing="0" cellpadding="0" align=center valign=center>
<Tr>
	<Td height="5" style="background-color:'#F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"></Td>
	<Td height="5" style="background-color:'#F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"><img width="1" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"></Td>
	<Td height="5" style="background-color:'#F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"></Td>
</Tr>
<Tr>
	<Td width="5" style="background-color:'#F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"><img width="5" height="1" src="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"></Td>
	<Td style="background-color:'#F3F3F3'" valign=middle>
		<Table border="0" align="center" valign=middle width="100%" class=welcomecell>
			<Tr>
				<Td style="background-color:'#F3F3F3';" align='center'>
					<font size=2><B>Vendor&nbsp;:&nbsp;</B><%=vendorName%></font>
				</Td>
				<Td style="background-color:'#F3F3F3';" align='center'>
					<font size=2><B>RFQ&nbsp;:&nbsp;</B><%=Long.parseLong(poNum)%></font>
				</Td>

				<Td style="background-color:'#F3F3F3';" align='center'>
					<font size=2><B>RFQ Date&nbsp;:&nbsp;</B><%=OrderDate%></font>
				</Td>
			</Tr>
		</Table>
	</Td>
	<Td width="5" style="background-color:'#F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e3.gif"><img width="5" height="1" src="Cb_e3.gif"></Td>
</Tr>
<Tr>
	<Td width="5" style="background-color:'#F3F3F3'" height="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c3.gif"><img width="5" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c3.gif"></Td>
	<Td height="5" style="background-color:'#F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e4.gif"><img width="1" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_e4.gif"></Td>
	<Td width="5" style="background-color:'#F3F3F3'" height="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c4.gif"><img width="5" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c4.gif"></Td>
</Tr>
</Table>
</Div>			
<br><br>
<Div id='inputDiv' style='position:relative;align:center;top:9	%;width:100%;'>
	<table id="tabHead" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0  >
	<Tr>
	<Th align="left">Please Enter Remarks:</Th>
	</Tr>
	<Tr>
	<Td>
	<textarea name="Remarks" rows=10 cols="60"></textarea>
	</td>
	</Tr>
	</table>
</Div>
<Div id="ButtonDiv" style="position:absolute;top:90%;width:100%;visibility:visible">
		<center>
		<Span id="EzButtonsSpan" >
		<%
			buttonName = new java.util.ArrayList();
			buttonMethod = new java.util.ArrayList();
			
			buttonName.add("Add Documents");
			buttonMethod.add("addDocuments()");
						
			buttonName.add("Clear");
			buttonMethod.add("document.myForm.reset()");
			
			if(("Quoted".equals(ext3Type))&&("2".equals(UserType)))
			{
			buttonName.add("Requote");
			buttonMethod.add("Requote()");
			}
			
			
			out.println(getButtonStr(buttonName,buttonMethod));
				
		%>
		</Span>
		 
		<Span id="EzButtonsMsgSpan" style="display:none">
			<Table align=center>
				<Tr>
					<Td >Your request is being processed... Please wait</Td>
				</Tr>
			</Table>
		</Span>
		</center>
	</div>
</form>
<Div id="MenuSol"></Div>
</body>
</html>