<%@ page import="ezc.otp.params.*,ezc.ezparam.*,java.util.*" %>	
<%@ page import="ezc.ezmisc.params.*,java.io.*,java.nio.channels.*" %>
<jsp:useBean id="miscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"></jsp:useBean>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="otpManager" class="ezc.otp.client.EzOTPManager" scope="session"></jsp:useBean>
<%
String otpStr=request.getParameter("otp");
String vendor=request.getParameter("vendor");

boolean isValidOTP=false;
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(true);
	EziOTPParams otpParams = new EziOTPParams();

	otpParams.setUserId(vendor);
	otpParams.setOtp(otpStr);
	otpParams.setOtpFor("VENDOR_PROFILE_EDIT");

	mainParams.setLocalStore("Y");			
	mainParams.setObject(otpParams);	
	Session.prepareParams(mainParams);
	
	try{
		ReturnObjFromRetrieve otpRetObj=(ReturnObjFromRetrieve)otpManager.ezVerifyOTP(mainParams);
				
		if(otpRetObj!=null)
		{
			String dbOTP = otpRetObj.getFieldValueString(0,"ESO_OTP");

			if(dbOTP==null || "null".equals(dbOTP))dbOTP="";
			dbOTP=dbOTP.trim();

			ezc.ezcommon.EzLog4j.log(otpStr+"::::otpStr::::dbOTP:::"+dbOTP,"I");
			if(dbOTP.equals(otpStr))
			isValidOTP=true;
		}
	}catch(Exception e){}
	
	/*String qry="SELECT * FROM EZC_SMS_OTP WHERE ESO_USER_ID IN ('"+vendor+"')  AND ESO_OTP_FOR IN ('VENDOR_PROFILE_EDIT') AND NOW() <= ESO_VALID_TO ORDER BY ESO_VALID_TO DESC" ;
	
		mainParams = new ezc.ezparam.EzcParams(true);
		EziMiscParams miscParams = new EziMiscParams();
		miscParams.setQuery(qry);
		mainParams.setObject(miscParams);	
		Session.prepareParams(mainParams);
	
		try{
		ReturnObjFromRetrieve otpRetObj=(ReturnObjFromRetrieve)miscManager.ezSelect(mainParams);
		
		if(otpRetObj!=null)
		{
			String dbOTP = otpRetObj.getFieldValueString(0,"ESO_OTP");
			
			if(dbOTP==null || "null".equals(dbOTP))dbOTP="";
			dbOTP=dbOTP.trim();
			
			ezc.ezcommon.EzLog4j.log(otpStr+"::::otpStr::::dbOTP:::"+dbOTP,"I");
			if(dbOTP.equals(otpStr))
			isValidOTP=true;
		}
}catch(Exception e){}*/

out.println("1$"+isValidOTP+"$2");
%>