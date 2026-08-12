<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ page buffer="none" %>
<%@ include file="../../../Includes/JSPs/RFQ/iSAPQCFReport.jsp"%>
<%@include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%
if("B".equals(exeType))
{
	ReturnObjFromRetrieve objNo=(ReturnObjFromRetrieve)bexec.getObject("EXECINFO");
	String autoNo = objNo.getFieldValueString(0,"EXECNO");
	response.sendRedirect("ezDisplay.jsp?autoNo="+autoNo);
}else
{
javax.servlet.ServletOutputStream sos=null;
try
{

	int count = outTable.getRowCount();
        sos=response.getOutputStream();
	if ( outTable != null )
	{
		for ( int i = 0 ; i < count; i++ )
		{
		        String line = outTable.getLine(i);
                        if (line.length() == 257)
                                line = line.substring(1,line.length()-1);
                        else
                                line = line.substring(1,line.length());
	        	sos.write(line.getBytes());
		}
	}
	
        sos.close();


}catch(Exception e)
{
	out.println("<br><br><br><br><Table width=65% align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0 ><Tr>");
	out.println("<Th class=displayheader>"+ "There Is No Vendor Invoice Report"+ "</Th>");
	out.println("</Tr></Table>");

}
}
%>

<Div id="MenuSol" style="width:0%;height:0%;visibility:hidden">&nbsp;</Div>
