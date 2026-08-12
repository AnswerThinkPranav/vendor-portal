<%
	ArrayList<String> poCreateDisable= new ArrayList<String>();
	poCreateDisable.add("CHETHANNS");
	poCreateDisable.add("DHARSHANKP");
	//poCreateDisable.add("NITHINSR");
	poCreateDisable.add("RASHMIHP");
	poCreateDisable.add("SHRINS");
	//poCreateDisable.add("SRIDHARA");
	poCreateDisable.add("RAJESHDR");
	poCreateDisable.add("VJAGADEESH");
	poCreateDisable.add("ANUSHREEP");
	if(poCreateDisable.contains(Session.getUserId()))
		showPOCreate=false;
%>