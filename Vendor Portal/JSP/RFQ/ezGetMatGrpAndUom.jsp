<%@ page import ="ezc.sapconnection.*,com.sap.mw.jco.*,com.sap.mw.jco.JCO" %>
<%

	JCO.Function function = null;
	JCO.Client client = null;
	
	String material = request.getParameter("material");
	String matGrp="",matUom="",valPrice="",matDesc="";
	if(material!=null)
	{
		try
		{
			int mat = Integer.parseInt(material);
			material = "000000000000000000"+material;
			material = material.substring((material.length()-18),material.length());
		}catch(Exception e){}	
	}

	
	try
	{

		function = EzSAPHandler.getFunction("BAPI_MATERIAL_GET_DETAIL");
		client = EzSAPHandler.getSAPConnection();
		JCO.ParameterList sapPreProc = function.getImportParameterList();

		sapPreProc.setValue(material, "MATERIAL");
		
		try
		{
			client.execute(function);
		}catch(Exception e){
			System.out.println("Exception while executing RFC call BAPI_MATERIAL_GET_DETAIL"+e);
		}			

		JCO.ParameterList expParam = function.getExportParameterList();
		JCO.Structure matDetSt = expParam.getStructure("MATERIAL_GENERAL_DATA");
		JCO.Structure matValData = expParam.getStructure("MATERIALVALUATIONDATA");
		matGrp   = (String)matDetSt.getValue("MATL_GROUP");
		matUom   = (String)matDetSt.getValue("BASE_UOM");
		valPrice = (String)matValData.getValue("MOVING_PR");
		matDesc  = (String)matDetSt.getValue("MATL_DESC");
		
		if("PAK".equals(matUom))matUom="PAC";
		if("MLW".equals(matUom))matUom="MLI";
		if("BOT".equals(matUom))matUom="BT";
		if("CF".equals(matUom))matUom="CFU";
		if("GM1".equals(matUom))matUom="GML";
		if("GW".equals(matUom))matUom="GAI";
		if("IN1".equals(matUom))matUom="IN";
		if("KAN".equals(matUom))matUom="CAN";
		if("KAR".equals(matUom))matUom="CAR";
		if("KGW".equals(matUom))matUom="KAI";
		if("KI".equals(matUom))matUom="CRT";
		if("KWK".equals(matUom))matUom="KIK";
		if("LE".equals(matUom))matUom="AU";
		if("MLW".equals(matUom))matUom="MLI";
		if("PCT".equals(matUom))matUom="PRC";
		if("TB".equals(matUom))matUom="TUB";
		if("TH".equals(matUom))matUom="TS";

	}
	catch(Exception e1)
	{
		System.out.println("Exception while preparing RFC call BAPI_MATERIAL_GET_DETAIL"+e1);
	}
	finally
	{
		if (client!=null)
		{
			System.out.println("R E L E A S I N G   C L I E N T .... ");
			JCO.releaseClient(client);
			client = null;
			function=null;
		}
	}

	out.println(matGrp+"¥"+matUom+"¥"+matDesc+"¥"+material+"¥"+valPrice);
	
	//out.println("MG¥EA¥10");
%> 