<%
	String crDateStr	=	"1900-01-01 00:00:00";
	String vendCrDat	=	"20210131";
		
	try{
		crDateStr = vendCrDat.substring(0,4)+"-"+vendCrDat.substring(4,6)+"-"+vendCrDat.substring(6,8);
	}catch(Exception e){}
	
	out.println(":::crDateStr:::::"+crDateStr);
%>