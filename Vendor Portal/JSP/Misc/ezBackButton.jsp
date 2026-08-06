<Div id="ButtonDiv" style="position:absolute;top:95%;width:80%;visibility:visible">	
<Center>
<%	
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();

	buttonName.add("Back");
	buttonMethod.add("history.go(-1)");
	
	out.println(getButtonStr(buttonName,buttonMethod));
%>
</Center>
</Div>