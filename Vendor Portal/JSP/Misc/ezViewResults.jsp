<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@ include file="../../../Includes/Jsps/Misc/iViewResult.jsp"%>         
<Html>
<Head>
<Script>
</Script>
</Head>
<Body>
<Form name='myForm'>
<%	
	String display_header = "Results ";
%>
	<%@ include file="../Misc/ezDisplayHeader.jsp" %>

	<Table width='100%' border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>
	<Tr>
			<th align="center" width="10%">Inspection Lot</th>
			<th align="center" width="10%">Inspection Characteristic</th>
			<th align="center" width="10%">Measurement</th>
			<th align="center" width="10%">Value</th>
			<th align="center" width="10%">Result</th>
			<th align="center" width="10%">Status</th>
			
			
	</Tr>
<%  
		for(int i=0;i<requirmentROCount;i++)      
		{
		
			for(int j=0;j<resultsROCount;j++)
			{
			
				if(CharRequirementsRetObj.getFieldValueString(i,"ITEMNO").equals(ResultsRetObj.getFieldValueString(j,"ITEMNUM")))
				{
				String backGroundColor = "";
				String qty = ResultsRetObj.getFieldValueString(i,"QTY");
				String sta=ResultsRetObj.getFieldValueString(i,"STAT"),staMsg="";
				
				String measure=CharRequirementsRetObj.getFieldValueString(i,"MEAS_UNIT");
				String measureValue=CharRequirementsRetObj.getFieldValueString(i,"MEAS_VALUE");
				
				if("A".equals(sta))
					staMsg="Accepted";
				if("R".equals(sta))
				{
					staMsg="Rejected"; 
					backGroundColor = "style=\"background-color:FF3300\"";
				}	
				if("F".equals(sta))
					staMsg="Failed";    	
				
					
%>
			<Tr>

			<td align="center" width="10%" <%=backGroundColor%>><%=ResultsRetObj.getFieldValueString(j,"INLOT")%></td>
			<td align="left" width="10%" <%=backGroundColor%>><%=CharRequirementsRetObj.getFieldValueString(i,"MATDESC")%></td>
			<td align="center" width="10%" <%=backGroundColor%>><%=measure%></td>
			<td align="center" width="10%" <%=backGroundColor%>><%=measureValue%></td>
			<td align="center" width="10%" <%=backGroundColor%>><%=qty%></td>
			<td align="center" width="10%" <%=backGroundColor%>><%=staMsg%></td>
			</Tr>       
<%
				}   
			}
		}
%>		  
			
	
	</Table>

<Div id="MenuSol"></Div> 
<Div id="ButtonDiv" align=center style="position:absolute;top:85%;visibility:visible;width:100%">
<center>
<table border=0 cellspacing=3 cellpadding=5 class=buttonTable><tr><td nowrap class='TDCmdBtnOff' onMouseDown='changeClass(this,"TDCmdBtnDown")' onMouseUp='changeClass(this,"TDCmdBtnUp")' onMouseOver='changeClass(this,"TDCmdBtnUp")' onMouseOut='changeClass(this,"TDCmdBtnOff")' onClick='javascript:window.close()' valign=top title = 'Click here to Ok'>&nbsp;&nbsp;&nbsp;&nbsp;Ok &nbsp;&nbsp;&nbsp;&nbsp;</td></TR></TABLE>

</center>
</Div>

</Form>
</Body>
</Html>                                  