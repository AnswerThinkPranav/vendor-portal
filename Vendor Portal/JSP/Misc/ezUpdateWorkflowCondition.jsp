<%@ page contentType="text/plain;charset=UTF-8" %>
<%@ page import="ezc.ezmisc.params.*, ezc.ezparam.*, ezc.ezmisc.client.*, ezc.ezcommon.*, java.util.*" %>
<%@ include file="../../Library/Globals/errorPagePath.jsp" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" scope="page" />
<%
	String userId = request.getParameter("userId");
	String plant = request.getParameter("plant");
	String category = request.getParameter("category");

	String wfValue = plant + "#" + category;
	String checkQuery = "SELECT * FROM EZC_USER_DEF_KEY_VALUES WHERE EUDKV_USER_ID = '" + userId + "' AND EUDKV_KEY = 'PLANT' AND EUDKV_VALUE = '" + plant + "'";

	EzcParams checkParams = new EzcParams(false);
	EziMiscParams miscParamsCheck = new EziMiscParams();
	miscParamsCheck.setQuery(checkQuery);
	checkParams.setObject(miscParamsCheck);
	checkParams.setLocalStore("Y");
	Session.prepareParams(checkParams);

	boolean plantExists = false;

	try {
		ReturnObjFromRetrieve checkResult = (ReturnObjFromRetrieve) ezMiscManager.ezSelect(checkParams);
		if (checkResult != null && checkResult.getRowCount() > 0) {
		plantExists = true;
		}
	}catch(Exception e){
		out.print("ERROR");
		return;
	}

	try{
		if(!plantExists){
			String insertPlant = "INSERT INTO EZC_USER_DEF_KEY_VALUES VALUES('" + userId + "','999800','PLANT','" + plant + "',null,null)";
			EzcParams plantParams = new EzcParams(false);
			EziMiscParams miscInsertPlant = new EziMiscParams();
			miscInsertPlant.setQuery(insertPlant);
			plantParams.setObject(miscInsertPlant);
			plantParams.setLocalStore("Y");
			Session.prepareParams(plantParams);
			ezMiscManager.ezUpdate(plantParams);
		}

		String insertCategory = "INSERT INTO EZC_USER_DEF_KEY_VALUES VALUES('" + userId + "','999800','CATEGORY','" + wfValue + "',null,null)";
		EzcParams categoryParams = new EzcParams(false);
		EziMiscParams miscInsertCategory = new EziMiscParams();
		miscInsertCategory.setQuery(insertCategory);
		categoryParams.setObject(miscInsertCategory);
		categoryParams.setLocalStore("Y");
		Session.prepareParams(categoryParams);
		ezMiscManager.ezUpdate(categoryParams);

		out.print("SUCCESS");
	}catch(Exception e){
		out.print("ERROR");
	}
%>