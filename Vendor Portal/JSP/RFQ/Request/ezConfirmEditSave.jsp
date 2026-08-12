<html>
<head>
	<title> -- Powered by EzCommerce Inc</title>
	<%@ include file="../../../Includes/Lib/AddButtonDir.jsp"%>
<script>


function setBack()
{
	document.location.replace("ezListAuctionRequests.jsp?type=Main");
}
</script>
</head>
<body  scroll=no>
<form method="post"  name="ezForm">
<%
	String auctionid=request.getParameter("auctionid");
%>
<br>
<br>
<br>
<br>
<table align=center border="0" cellpadding="0" class="displayheaderback" cellspacing="0" width="60%">
<tr>
    <td  align="center"><font size=2>Auction No:</font><font color="red"><%=auctionid%></font> has Been Approved Successfully</font></td>
</tr>
</table>
<br><br>
<table align=center border="0" cellpadding="0" class="displayheaderback" cellspacing="0" width="100%">
<tr>
<td class="blankcell" align="center">
<img src="../../Images/Buttons/<%=ButtonDir%>/ok1.gif" style="cursor:hand"  border=0 onClick='JavaScript:setBack()'>
</td>

</table>
<Div id="MenuSol"></Div>
</form></body>
</html>
