<%
		String 	venCompCode =(String)session.getValue("COMPCODE");
		//out.print("venCompCode::"+venCompCode);
		String [] compCodeArr = null;
		if(venCompCode!=null && !"null".equals(venCompCode) && !"".equals(venCompCode))
			compCodeArr = venCompCode.split(",");
		String selCompCode = request.getParameter("selCompCode");
		if(selCompCode == null || "null".equals(selCompCode) || "".equals(selCompCode))
			selCompCode = "CFL"; 
		else if(compCodeArr != null && compCodeArr.length == 1)
			selCompCode = compCodeArr[0];
		boolean selCompFlg = false;
		java.util.Hashtable compCodeDesc = new java.util.Hashtable();
		compCodeDesc.put("CFL","Coromandel Interntl Ltd.");
		//out.print("selCompCode:::"+selCompCode);
		//out.print("venCompCode::"+venCompCode);
%>