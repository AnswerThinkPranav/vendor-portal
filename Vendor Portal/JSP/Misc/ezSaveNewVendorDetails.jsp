
<%
String SystemKey = request.getParameter("SystemKey");

String titleSel = request.getParameter("titleSel");
String state = request.getParameter("state");

String minIndi = request.getParameter("minIndi");
String classification = request.getParameter("classification");

String bankRegion[]  = request.getParameterValues("bankRegion");
String bankName[]  	= request.getParameterValues("bankName");
for(int i=0; i<bankRegion.length; i++)
{
	out.println(bankRegion[i]+bankName[i]);
}


out.println(SystemKey+"::"+titleSel+"::"+state+"::"+minIndi+"::"+classification+"::");

%>
