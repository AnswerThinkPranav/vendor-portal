<%@ include file="../../Library/Globals/errorPagePath.jsp"%>  
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ page import = "ezc.ezparam.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"/>
<jsp:useBean id="UserManager" class="ezc.client.EzUserAdminManager" scope="session" />

<%
	ReturnObjFromRetrieve retUsers  = null;
	int retUsersCnt = 0;
	
	EzcUserParams uparams= new EzcUserParams();
	Session.prepareParams(uparams);	
	EzcUserNKParams ezcUserNKParams = new EzcUserNKParams();
	ezcUserNKParams.setLanguage("EN");
	ezcUserNKParams.setSys_Key("999000') AND EU_CHANGED_BY IN ('"+Session.getUserId());
	uparams.createContainer();
	uparams.setObject(ezcUserNKParams);
	retUsers =	(ReturnObjFromRetrieve)UserManager.getUsersForSalesArea(uparams);
	
	if(retUsers!=null)
		retUsersCnt = retUsers.getRowCount();
		
	//out.println(":::retUsers:::"+retUsers.toEzcString());
	
	java.util.Vector rfqAuthVndrs = new java.util.Vector();
	java.util.Vector regAuthVndrs = new java.util.Vector();
	
	ReturnObjFromRetrieve retUserDefs  = null;
	int retUserDefsCnt = 0;
	String query	= "SELECT EUD_USER_ID,EUD_KEY,EUD_VALUE FROM EZC_USER_DEFAULTS WHERE EUD_USER_ID IN (SELECT A.EU_ID FROM EZC_USERS A, EZC_BUSS_PARTNER_AREAS B WHERE A.EU_ID = B.EBPA_USER_ID AND  LTRIM(RTRIM(B.EBPA_SYS_KEY)) IN ('999000') AND EU_CHANGED_BY IN ('"+Session.getUserId()+"')) AND EUD_KEY IN ('ALLOW_RFQ','ALLOW_REG')";

	ezc.ezmisc.client.EzMiscManager miscManager = new ezc.ezmisc.client.EzMiscManager();
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(true);
	ezc.ezmisc.params.EziMiscParams miscParams = new ezc.ezmisc.params.EziMiscParams();
	miscParams.setQuery(query);
	mainParams.setObject(miscParams);	
	Session.prepareParams(mainParams);
	try
	{
		retUserDefs = (ReturnObjFromRetrieve)miscManager.ezSelect(mainParams);
	}
	catch(Exception e){}
	
	if(retUserDefs!=null)
		retUserDefsCnt = retUserDefs.getRowCount();
	
	for(int v=0;v<retUserDefsCnt;v++)
	{
		if("ALLOW_RFQ".equals(retUserDefs.getFieldValueString(v,"EUD_KEY")) && "Y".equals(retUserDefs.getFieldValueString(v,"EUD_VALUE")))
			rfqAuthVndrs.addElement(retUserDefs.getFieldValueString(v,"EUD_USER_ID"));
		if("ALLOW_REG".equals(retUserDefs.getFieldValueString(v,"EUD_KEY")) && "Y".equals(retUserDefs.getFieldValueString(v,"EUD_VALUE")))
			regAuthVndrs.addElement(retUserDefs.getFieldValueString(v,"EUD_USER_ID"));		
	}
%>		

<%@ include file="ezGetUserAuthDefaults.jsp"%> 
<%@ include file="../Misc/ezHeader.jsp"%> 

<html>
<head>
<script>

</Script>
</head> 

<body scroll=no>
<form name="myForm" method="post">
<input type='hidden' name='ShipId' value=''>
<input type='hidden' name='docId' value=''>
<input type='hidden' name='ponum' value=''>
<input type='hidden' name='orderBase' value='po'>

<%	
	String display_header	= "Temporary Users > List"; 
%>
	<%@ include file="../Misc/ezSubHeader.jsp"%>
	<br>
		<table id="example" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
		<thead>
		<Tr <%=trBGColor%>>
			<th width="10%">User Id</th>
			<th width="25%">Name</th>
			<th width="20%">EMail</th>
			<th width="10%">Contact No.</th>
			<th width="35%">Authorization(s)</th>
			<!--<th width="10%">Valid From</th>
			<th width="10%">Valid To</th>
			<th width="10%">Status</th>-->
		</tr>
		</thead>
		<tbody>		
<%
		String color = "";
		String modeTpt = "";
		String chkRFQ = "";
		String chkREG = "";
		
		for(int i=0;i< retUsersCnt;i++)
		{
			chkRFQ = "";
			chkREG = "";
			
			if(rfqAuthVndrs.contains(retUsers.getFieldValueString(i,"EU_ID")))
				chkRFQ = "checked";
				
			if(regAuthVndrs.contains(retUsers.getFieldValueString(i,"EU_ID")))
				chkREG = "checked";	
				
			
			color = "";
			//if(i%2==0) {color = "style='background-color:#c9e0ff'";}
%>
			<tr>
				<td width="10%" align="center" <%=color%>> <%=retUsers.getFieldValueString(i,"EU_ID")%> </td>	
				<td width="25%" align="left" <%=color%>> <%=retUsers.getFieldValueString(i,"EU_FIRST_NAME")%> </td>	
				<td width="20%" align="left" <%=color%>> <%=retUsers.getFieldValueString(i,"EU_EMAIL")%> </td>	
				<td width="10%" align="center" <%=color%>> <%=retUsers.getFieldValueString(i,"EU_CONTACT_NO")%> </td>
				<td width="10%" align="center" <%=color%>>
				<input type='checkbox' name = 'VenReg<%=retUsers.getFieldValueString(i,"EU_ID")%>' value='Y' <%=chkREG%>>VenReg
				&nbsp; <input type='checkbox' name = 'RFQ<%=retUsers.getFieldValueString(i,"EU_ID")%>' value='Y' <%=chkRFQ%>>RFQ
				&nbsp; <input type='button' value='Update' onClick="funUpdateAuth('<%=retUsers.getFieldValueString(i,"EU_ID")%>')">
				</td>
				
				<!--<td width="10%" align="center" <%=color%>> <%=retUsers.getFieldValueString(i,"EU_CREATED_DATE")%> </td>
				<td width="10%" align="center" <%=color%>> <%=retUsers.getFieldValueString(i,"EU_VALID_TO_DATE")%> </td>
				<td width="10%" align="center" <%=color%>> &nbsp; </td>-->
			</tr>
<%
		}
%>
		</tbody>	
		</table>				
</form>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%>
 <link rel="stylesheet" type="text/css" href="../../Library/jquery/jquery-ui-1.12.1.custom/jquery-ui.css">
 <link rel="stylesheet" href="../Misc/library/fancybox2/jquery.fancybox.css" type="text/css" media="screen" />
 <script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.js"></script>
 <script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.pack.js"></script>
<script>
function funUpdateAuth(tempVendCode)
{
	var venRegAuth = 'N';
	var rfqAuth = 'N';
	
	if(eval('document.myForm.VenReg'+tempVendCode).checked)
		venRegAuth = 'Y';
	if(eval('document.myForm.RFQ'+tempVendCode).checked)
		rfqAuth = 'Y';	
	
	var Url="ezUpdateTempUserAuth.jsp?tempVendCode="+tempVendCode+"&venRegAuth="+venRegAuth+"&rfqAuth="+rfqAuth;
			$.fancybox.open({
			href : Url,
			type : 'iframe',
			padding : 5,
			width:'50%',
			height:'170px',
			autoSize : false,
			closeBtn : true,
			helpers     : { 
					overlay : {closeClick: false}
		 }
		});
}
</script>
<%@ include file="../Misc/ezDataTableScript.jsp"%>