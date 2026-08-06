<%  
	String message          = request.getParameter("MESSAGE");
	String defaultPage 	= request.getParameter("DEFAULT_PAGE");
	String display_header	= "";
	java.util.Hashtable fileHash = new java.util.Hashtable();
	fileHash.put("QCF","../Rfq/ezOfflineWFListQcfs.jsp?Type=N");
	fileHash.put("PO" ,"../Purorder/ezListOfflineBlockedPOs.jsp");
	fileHash.put("CON","../Purorder/ezListOfflineBlockedContracts.jsp?type=Contract");
	fileHash.put("QUERY","../Misc/ezNewQcfQueries.jsp");
%>
<Html>
<Head>
	<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
	
	<Script>
		function funOK()
		{
			location.href='<%=(String)fileHash.get(defaultPage)%>'
		}
		function reLoad(action,listEmpty)
		{
			if(action == 'Y' && "<%=defaultPage%>" != "EMPTY")
			{
				funOK()
			}	
			else
			{
				setTimeout("reLoad('Y','<%=defaultPage%>')",1000);
			}

		}		
	</script>    
</Head>
<Body onLoad="reLoad('N','<%=defaultPage%>')">
<Form>
<%//@ include file="../../../Offline/JSPs/ezOfflineDisplayHeader.jsp"%>
<Div style="position:absolute;top:45%;width:100%;visibility:visible">
<TABLE id="tabHead" width="60%" align=center border=0 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=5 cellSpacing=1 >
  <Tr align="center" valign="middle">
    <Th><BR><%=message%><BR>&nbsp;</Th>
  </Tr>
</Table>
</Div>

<%
	if(!"EMPTY".equals(defaultPage))
	{
%>
		<Div style="position:absolute;top:90%;width:100%;visibility:visible">
    		<Center>
    		
<%  
		//butNames.add("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ok&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");  
		//butActions.add("funOK()");
		//out.println(getButtons(butNames,butActions));	
		//butNames.clear();
		//butActions.clear();
%> 		
    		</Center>
		</Div>
		
<%
	}
%>
</Form>
<Div id="MenuSol"></Div>
</Body>
</Html>