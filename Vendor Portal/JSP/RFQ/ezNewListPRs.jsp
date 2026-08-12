<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ page import="java.util.*,java.text.*" %>
<%@ page import = "ezc.ezutil.FormatDate"%>
<%@ include file="../../../Includes/Lib/DateFunctions.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iEzDateConvertion.jsp" %>
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>

<%
	String Status 	= request.getParameter("Status");
	String matNo 	= request.getParameter("matNo");
	String plant 	= request.getParameter("selplant");
	String fromDate = request.getParameter("fromDate");
	String toDate 	= request.getParameter("toDate");
	//Status = "R";
	
	String header  = "PR - Item,Created Date,Release Date,Delivery Date,Material,Description,Plant,Quantity,UOM";
	String widths  = "12,12,12,12,10,21,7,9,5";
	String colTyps = "ro,ro,ro,ro,ro,ro,ro,ro,ro";
	String aligns  = "center,center,center,center,center,center,center,right,center";
	String colSort = "str,date,date,date,str,str,str,int,str";
	
	String reqUrl  = "";
	String selAllChk = "<input style='cursor:hand' type=checkbox name=checkAll onclick='selectCheckAll()'  alt='Select/Deselect All'>";
	
	if("R".equals(Status) ){
		header  = selAllChk+",PR - Item,Created Date,Release Date,Delivery Date,Material,Description,Plant,Quantity,UOM";
		widths  = "4,12,11,11,11,10,20,7,9,5";
		colTyps = "ro,ro,ro,ro,ro,ro,ro,ro,ro,ro";
		aligns  = "center,center,center,center,center,center,center,center,right,center";
		colSort = "str,str,date,date,date,str,str,str,int,str";
	}	
	
	reqUrl = "Status="+Status+"&matNo="+matNo+"&selplant="+plant+"&fromDate="+fromDate+"&toDate="+toDate;
	//////out.println(searchFlag+"----"+showGrid);
%>
<html>
<head>
<Script src="../../Library/JavaScript/Trim.js"></Script>
<Script src="../../Library/JavaScript/Rfq/ezListPR.js"></Script>
<script src="../../Library/JavaScript/ezConvertDates.js"></Script>
<link rel="STYLESHEET" type="text/css" href="../../../../EzCommon/JavaScript/Grid/dhtmlXGrid.css">
<Script src="../../../../EzCommon/JavaScript/Grid/dhtmlXCommon.js"></Script>
<Script src="../../../../EzCommon/JavaScript/Grid/dhtmlXGridCell.js"></Script>
<Script src="../../../../EzCommon/JavaScript/Grid/dhtmlXGrid.js"></Script>

<Script>
	function doOnLoad()
	{
		mygrid = null;
		mygrid = new dhtmlXGridObject('gridbox');
		mygrid.imgURL = "../../../../EzCommon/Images/Grid/";
		mygrid.setHeader("<%=header%>");
		mygrid.setNoHeader(false)
		mygrid.setInitWidthsP("<%=widths%>")
		mygrid.setColAlign("<%=aligns%>")
		mygrid.setColTypes("<%=colTyps%>");
		mygrid.setColSorting("<%=colSort%>")
		mygrid.setStyle('background-Color:#000000;font-weight:600;',"","","")
		mygrid.enableBuffering(50);
		mygrid.init();
			mygrid.loadXML("ezListPRsGrid.jsp?<%=reqUrl%>");
	}
	function checkVal(stat)
	{
		var selectedLength = 0
		var checkObj = document.myForm.chk1
		var reqData = "";
		if(checkObj != null)
		{
			var checkLength = checkObj.length;
			var reqData = "";
			if(isNaN(checkLength))
			{
				if(document.myForm.chk1.checked)
				{
					reqData = document.myForm.chk1.value;
					selectedLength++;
				}	
			}
			else
			{
				for(i=0;i<checkLength;i++)
				{
					if(document.myForm.chk1[i].checked)
					{
						reqData += document.myForm.chk1[i].value+"µ";
						selectedLength++;
					}	
				}
			}	
		}
	
		if(selectedLength == 0)
		{
			if(stat=='NA')
				alert("");
			else
				alert("");
		}
		else
		{
			/*
			document.myForm.poData.value = reqData;
			if(stat=='NA')
				document.myForm.action="ezSendReminders.jsp";
			else if(stat=='REL')
				document.myForm.action="ezReleasePurchaseOrder.jsp";
			else
				document.myForm.action="ezReleaseOrders.jsp";
			setMessageVisible();
			document.myForm.submit();	
			*/
		}
		
		
	}
	
	
		
</Script>
<Script>
	var showTotalDiv = false
	var selAtlOnePoBl_L = 'OK';
	
	function formEvents()
	{
		var selectedLength = 0
		var checkObj = document.myForm.chk1
		if(checkObj != null)
		{
			var checkLength = checkObj.length;
			if(isNaN(checkLength))
			{
				if(document.myForm.chk1.checked)
					selectedLength++;
			}
			else
			{
				for(i=0;i<checkLength;i++)
				{
					if(document.myForm.chk1[i].checked)
						selectedLength++;
				}
			}	
		}
		if(selectedLength == 0)
		{
			alert(selAtlOnePoBl_L)
		}
		else
		{
			setMessageVisible();
			document.myForm.action="ezBlockPurchaseOrder.jsp";
			document.myForm.submit();
		}	
	}
	
	

	
	/* FOR DATE SELECTION AND TO LOAD DEFAULT DATES */
	
	
	
	function ezSubmit(){
		if(document.myForm.showGrid!=null)
			document.myForm.showGrid.value = "Y";
		
		//document.myForm.action = "ezListPOs.jsp";
		//document.myForm.submit();
	}
	
	/* END */
</Script>

</head>
<body onLoad="doOnLoad();" scroll=no>
<form name="myForm" method="post" >
<input type="hidden" name="chkField">
<input type="hidden" name ="chkbox">
<input type="hidden" name=selAllImg value="0">

<%	
	//String clickString = "onclick='ezSubmit()'";
	String noDataStatement = "No Purchase Requisitions List Exist";
	String display_header = "List Of Purchase Requisitions";
	if(Status.equals("R")){
		display_header = "List Of Released Purchase Requisitions";
		noDataStatement = "No Released Purchase Requisitions List Exist";
	}	
	else if(Status.equals("U")){
		display_header = "List Of Unreleased Purchase Requisitions";
		noDataStatement = "No Unreleased Purchase Requisitions List Exist";
	}	
%>		
	<%@ include file="../Misc/ezDisplayHeader.jsp" %>
	<%@ include file="../Misc/ezDisplayGrid.jsp" %>		

<Div id="ButtonDiv" style="position:absolute;top:95%;width:100%;visibility:hidden">
	<center>
<%
		buttonName = new java.util.ArrayList();
		buttonMethod = new java.util.ArrayList();
			
		buttonName.add("Back");
		buttonMethod.add("navigateBack(\"../Misc/ezSBUWelcome.jsp\")");

		buttonName.add("GetSources");
		buttonMethod.add("vendorList()");

		buttonName.add("Close");
		buttonMethod.add("ClosePR()");
	
		out.println(getButtonStr(buttonName,buttonMethod));
%>
	</center>
</Div>
<%@ include file="../Misc/backButton.jsp" %>
<%@ include file="../Misc/AddMessage.jsp" %>
<input type=hidden name="purchaseHidden">
<input type ="hidden" name="reasons" value ="">
<input type=hidden name="backChk" value="PRS">	
<input type="hidden" name="Status" value="<%=Status%>">
<input type="hidden" name="matNo" value="<%=matNo%>">
<input type="hidden" name="selplant" value="<%=plant%>">
<input type="hidden" name="fromDate" value="<%=fromDate%>">
<input type="hidden" name="toDate" value="<%=toDate%>">


</form>
<Div id="MenuSol"></Div>
</body>
</html>
