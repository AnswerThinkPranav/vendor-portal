<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" /> 
<%@ page import ="java.util.*"%>
<%@ page import = "ezc.ezutil.FormatDate"%> 
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>   
<%@ include file="../Misc/ezHeader.jsp"%>  
<%@ include file="../Misc/ezDefaultDate.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCommonMethods.jsp"%> 
<%!
 	private String checkNull(String str)
 	{
 		if("null".equals(str) ||str==null)
 			str="";
 		else
 			str = str.replaceAll("'","`");
 		
 		return str;
 	}
 	private String checkNull_Num(String str)
	 {
		if("null".equals(str) ||str==null || "".equals(str))  
			str="0";
		
		return str;
 	}
%>
<%
	String logonSite = (String)session.getValue("SITE");
	String portalURL = "";
	ResourceBundle sitBundleObj=null;
	try
	{
		sitBundleObj= ResourceBundle.getBundle("Site");
		portalURL=sitBundleObj.getString("PORTAL_URL");
	}
	catch(Exception e)
	{ 
	    
	}
	String docId=request.getParameter("docId");
	String vendName=request.getParameter("vendName");
	String status=request.getParameter("status");
	
	String mailText="",toEmailStr = "",ccEmailStr = "";
	toEmailStr = getTempVendorMail(Session,docId);
	ccEmailStr = getUserMail(Session,(String)Session.getUserId());	
	
	ezc.ezcommon.EzLog4j.log("toEmailStr in Reminder for Temp Vendor>>>**"+toEmailStr,"I");
	ezc.ezcommon.EzLog4j.log("mailText in Reminder for Temp Vendor>>>**"+ccEmailStr,"I");
	
	//MAIL
	String mailSub="Vendor Registration Reminder against docuemnt: "+docId;
	String offlineLink = portalURL+"ezOffline.jsp?JBTE=JBTEID&SITE="+logonSite;
	String spaceCon 	="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";	
	String bgColor = "bgcolor=\"#FFFFFF\"";
	String thBGColor = "style=\"background-color: #015488;color: #FFFFFF;font-family: arial,sans-serif;font-size: 12px\"";
	String tdBGColor = "style=\"background-color: #EDF1F4;\"";	

	if("INITIATED".equals(status))
	{
		mailText="Dear Sir/Madam,<Br><Br>This is a reminder to complete the registration against:"+docId+"  from JGL Ltd.<Br>"; 
		mailText += "Please complete the registration against :"+docId+" with below details.<BR><BR>";
	}
	else if("RESUBMITTED".equals(status))
	{
		mailText="Dear Sir/Madam,<Br><Br>This is a reminder to resubmit the registration against:"+docId+"  from JGL Ltd.<Br>"; 
		mailText += "Please re-submit the registration against :"+docId+" with below details.<BR><BR>";
	}
	mailText +=  "<Table width = \"80%\" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>";
	mailText +=  "<br><Tr "+bgColor+"><Th width= \"50%\" "+thBGColor+"><B>Doc Id</B></Th><Td width= \"50%\" "+tdBGColor+" align=\"center\">"+docId+"</Td></Tr>";	
	mailText +=  "<br><Tr "+bgColor+"><Th width= \"50%\" "+thBGColor+"><B>Vendor Name</B></Th><Td width= \"50%\" "+tdBGColor+" align=\"center\">"+vendName+"</Td></Tr>";	
	mailText +=  "</Table><Br>";
	mailText +=  "<b><a href ="+offlineLink+">Click Here</a>  to login into Vendor Portal\n</b><br><br>";
	mailText +=  "<br>Regards, \n<br><b>" + v_fullName + "(" +Session.getUserId()+").";	
	
	ezc.ezcommon.EzLog4j.log("mailText in Reminder>>>**"+mailText,"I");	
		
	sendMail(Session,toEmailStr,ccEmailStr,"",mailText,mailSub); 
	
		
	
%>