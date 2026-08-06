<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<Html>
<Head>
<Script>
</Script>
</Head>
<Body>
<Form name='myForm'>
<%	
	String display_header = "Comments";
	String comments=request.getParameter("comments");
	//out.println("comments=="+comments);
%>
	<%@ include file="../Misc/ezDisplayHeader.jsp" %>
	<div >
			<table class="data-table" id="example" width='100%' height='30%' border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>
			<thead>
			<Tr>
			<th align="center" width="15%">Comments</th>
			
			<Td align="center" width="70%">
			<TeaxtArea rows='100' cols='150'><%=comments%>
			</TeaxtArea>
			</TD>
			</Tr>
			</Table>
			</div>
			<br><br><center>
			 
				               
				                <%
				                                buttonName = new java.util.ArrayList();
				                                buttonMethod = new java.util.ArrayList();
				
				                                buttonName.add("Close");
				                                buttonMethod.add("window.close()");
				
				                		
				
				                                out.println(getButtonStr(buttonName,buttonMethod));
				                %>
				              
	              

<Div id="MenuSol"></Div> 

</Form>
</Body>
</Html>