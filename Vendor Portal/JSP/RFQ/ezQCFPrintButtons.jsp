<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<html>
<head>
<script>
function doPoPrint()
{
	parent.frames[0].focus();
	parent.frames[0].print();
	close();
}

</script>
</head>
<body>
<form>

<center>

<%	
			buttonName = new java.util.ArrayList();
			buttonMethod = new java.util.ArrayList();

			buttonName.add("Print");
			buttonMethod.add("doPoPrint()");
			buttonName.add("close");
			buttonMethod.add("parent.close()");
			buttonName.add("Save As");
			buttonMethod.add("parent.frames[0].document.execCommand(\"SaveAs\",\"0\",\"ezQCF.htm\")");
           		out.println(getButtonStr(buttonName,buttonMethod));

%>
</center>

</form>
</body>
</html>
