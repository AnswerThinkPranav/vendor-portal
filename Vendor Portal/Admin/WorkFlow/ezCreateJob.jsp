<%@ page import="java.util.*"%>
<%
	String duration = request.getParameter("timeSpan");
	
	ezc.ezbasicutil.EzCustomerValuesSync sched = new ezc.ezbasicutil.EzCustomerValuesSync("");

	ezc.ezparam.ReturnObjFromRetrieve myRet=new ezc.ezparam.ReturnObjFromRetrieve(new String[]{"JOBNAME","DURATION"});
	myRet.setFieldValue("JOBNAME","ezCustomerValuesSync_Job");
	myRet.setFieldValue("DURATION",duration);
	myRet.addRow();

	sched.ezScheduleJob(myRet);
	
	response.sendRedirect("ezJobList.jsp");
%>