<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@page import="ezc.ezutil.*"%>
<%@ include file="../../../Includes/JSPs/Rfq/iSendToReQuote.jsp" %>
<Html>
<Head>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<Script>
function funOK(url)
{
//alert("hi");
document.myForm.action=url;
document.myForm.submit();

} 
</Script>
	<script language="Javascript1.2">
		am = "This function is disabled!";
		bV  = parseInt(navigator.appVersion)
		bNS = navigator.appName=="Netscape"
		bIE = navigator.appName=="Microsoft Internet Explorer"
		function nrc(e) 
		{
		   if (bNS && e.which > 1)
		   {
		      alert(am)
		      return false
		   } 
		   else if (bIE && (event.button >1)) 
		   {
		     alert(am)
		     return false;
		   }
		}
		document.onmousedown = nrc;
		if (document.layers) window.captureEvents(Event.MOUSEDOWN);
		if (bNS && bV<5) window.onmousedown = nrc;
	</Script>		
 
</head>

<body>
<form  name="myForm" method="post"  oncontextmenu="return false;">

<br> 
<br>
<br>  
<br>

<TABLE  width="50%" align=center border=0 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=5 cellSpacing=1 >
  <tr align="center" valign="middle">
    <th width=60%>RFQ No:<%=rfqNO%> has been sent for Requote Successfully</th>
  </tr>
</tr>
</Table>
<div style="position:absolute;top:45%;left:48%;visibility:visible">
<%
	
      buttonName.add("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Ok &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");   
      buttonMethod.add("funOK(\"../Misc/ezSBUWelcome.jsp\")");

      out.println(getButtonStr(buttonName,buttonMethod));
      
	if(statusReQuote)
	{
      		String mailRFQ = request.getParameter("RfqNo");
      		String stmtIdKey = "GET_VENDOR_EMAIL,"+rfqVend;
      		String msgSubject = "RFQ Re-Quote";
      		String ccMailIds  = "";
      		String msgText = "RFQ "+mailRFQ+" has been send for Re-Quote.<BR> Please login to portal to Re-Quote.";
%>	
		<%@ include file="../../../Vendor2/JSPs/Misc/ezSendMail.jsp" %>
<%
	}
%>
</div>
</form>
<Div id="MenuSol"></Div>
</body>
</html>