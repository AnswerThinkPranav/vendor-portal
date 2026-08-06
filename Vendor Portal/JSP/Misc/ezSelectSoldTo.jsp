<%@ include file="../../../Vendor2/Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iSelectSoldTo.jsp"%>
<%@ include file="../Misc/ezCommonMethods.jsp" %>

	<div class="modal fade" id="pleaseWaitDialog">
		 <div class="modal-dialog" style="padding-top: 15%;">
   		<div class="modal-content" style="background: transparent;">
		<div class="modal-body">
		    <img src="../img/loading.gif" style="margin-left:55%;"/>
		</div> 
		</div>
		</div>
	</div>
    <!-- REQUIRED JS SCRIPTS -->

    <!-- jQuery 2.1.4 -->
    <script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>
    <script src="../../../../EzCommon/Library/plugins/jQueryUI/jquery-ui.min.js"></script>
    
    <!-- Bootstrap 3.3.5 -->
    <script src="../../../../EzCommon/Library/bootstrap/js/bootstrap.min.js"></script>
    <!-- AdminLTE App -->
    <script src="../../../../EzCommon/Library/js/datepicker.js"></script>
    <script src="../../../../EzCommon/Library/js/alert_confirm.js"></script>
    <script src="../../../../EzCommon/Library/dist/js/app.min.js"></script>
    



<html>   
<head>     
	<title><%=(String)session.getValue("TITLE")%></title>
<script>
	function funWait()
	{
		$('#pleaseWaitDialog').modal('show');
	}
	funWait();
</script>	
</head>
<body>
<TABLE cellSpacing=0 cellPadding=0 width="100%" align=center border=0 >
<TR>
	<TD>
		<IMG src="../../../../EzCommon/Images/Banner/ezc_logo.jpg" border=0>
	</TD>
	<TD>
		<IMG src="../../../../EzCommon/Images/Banner/banner_ext.jpg" border=0>
	</TD>
</TR>
</TABLE>

<%
	if((soldtoRows >=1)&& (catareaRows >=1))
	{
		//retsoldto.sort(new String[]{"ECA_NAME"},true);
		
		String soldTo 		= retsoldto.getFieldValueString(0,"EC_ERP_CUST_NO");
		String vendorName 	= retsoldto.getFieldValueString(0,"ECA_NAME");
		PurManager.setPurAreaAndVendor(catalog_area,soldTo);
		session.putValue("SOLDTO",soldTo.trim());
		session.putValue("Vendor",retsoldto.getFieldValueString(0,"ECA_NAME"));
	}	
		
		String purGrp  	   = (String)Session.getUserPreference("PURGROUP");
		session.putValue("SYSKEY",catalog_area);
		session.putValue("Catalog",retcatarea.getFieldValueString(0,SYSTEM_KEY_DESCRIPTION));

		if(purGrp!=null){
			purGrp=(purGrp.toUpperCase()).trim();
		}	
		session.putValue("USERDEFPURGRP",purGrp);
		//session.putValue("POP_UP","N");
		
		String offlineDoc=(String)session.getValue("offlineDoc");
		out.print("offlineDoc:::"+offlineDoc);
		if(offlineDoc != null && !"null".equals(offlineDoc)  && !"".equals(offlineDoc))
		{
			ReturnObjFromRetrieve linkRet = (ReturnObjFromRetrieve)ezMiscSelect(Session,"SELECT ELC_USER,ELC_ID,ELC_DOC_TYPE,ELC_DOC_ID FROM EZC_LINK_CONTROLLER WHERE UPPER(ELC_ID)='"+offlineDoc+"'");
			out.print(linkRet.toEzcString());
			String linkUserId=linkRet.getFieldValueString(0,"ELC_USER").trim();
			String linkDocType=linkRet.getFieldValueString(0,"ELC_DOC_TYPE").trim();
			String linkDocId=linkRet.getFieldValueString(0,"ELC_DOC_ID").trim();
			if(linkUserId.equals(Session.getUserId()))
			{
				if("AUCTION".equals(linkDocType))
					response.sendRedirect("../Request/ezAuctionReport.jsp?auctionId="+linkDocId);
				else if("AUCTBID".equals(linkDocType))
					response.sendRedirect("../Request/ezCurrentAuctionDetails.jsp?auctionId="+linkDocId);	
			}
		}
		
		if("3".equals(userType))
			response.sendRedirect("../Misc/ezRedirect.jsp");  
		else if("2".equals(userType))
			response.sendRedirect("../Misc/ezBuyerWelcome.jsp");  
			
	/*} 
	else 
	{
		String noDataStatement = "";
		if (catareaRows == 0)
			noDataStatement = "Purchase Areas not configured";
		else if (soldtoRows ==0)
			noDataStatement = "Vendors not configured"; 
%>
		 <%@ include file="ezDisplayNoData.jsp"%>
<%		
	}*/
%>
<Div id="MenuSol"></Div>
</body>
</html> 

