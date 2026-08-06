<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*,java.util.*" %>	 	
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>  
 <%@ page import ="ezc.ezparam.*,java.util.*,ezc.ezutil.*,ezc.ezvendorapp.params.*,ezc.ezpurchase.params.*,ezc.messaging.params.*,ezc.ezpreprocurement.params.*,java.text.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="AppManager" class="ezc.ezvendorapp.client.EzVendorAppManager" scope="session" />  
<%@ include file="ezGetUserAuthDefaults.jsp"%>           
<%   
	ezc.ezcommon.EzLog4j.log("Debug:::::::LE:::::00","I");
	if("3".equals(userType))   
		response.sendRedirect("ezWelcome_New.jsp"); 
	if("4".equals(userType)) 
		response.sendRedirect("ezWelcomeTempUser.jsp"); 	   

	session.removeValue("SOLDTO"); 
	session.removeValue("PORTAL_TYPE"); 
	session.removeValue("Vendor");  
%>
<%@ include file="ezWelcomePageCounts.jsp"%>
<%@ include file="ezHeader.jsp"%>      
<%! 
	public String checkNull(String value)
	{
		if(value==null || "null".equals(value.trim()))value="";
		value=value.trim();
		
		return value;
	}
%>

<Head>   
<style>
.form-control {
    background-color: #101317;
} 
.box.box-success {
    border-top-color: #00a65a ;
}
.box-header{
background-color: #f5aa39;
}
.small-box p {
    font-size: 13px;
}
</style> 
<div class="content-wrapper">
	<section class="content-header">   
		 <h4>       
			Dashboard
		</h4> 
    	</section>
	<!-- Main content -->
    	<section class="content"> 
    	<Body>    
        <form method="post"  name="myForm">
        <!-- Small boxes (Stat box) -->     
        <div class="row">	
<%
	if("PP".equals(userRole) || "BY".equals(userRole))
	{
%>	
	<div class="col-lg-4 col-xs-6"> 
		<div class="info-box">
			<div class="inner">
				<div class="small-box bg-aqua">
					<h4 style="height: 60px;padding-top: 30px;font-size: 18px;">&nbsp;&nbsp;<%=toActRFQsCnt%></h4> 
					<p>
						&nbsp;Domestic RFQ(s)To Act&nbsp;&nbsp;<br>&nbsp;
					</p>
					<div class="icon">
						<i class="fa  fa-newspaper-o" style="font-size: 70px;margin-top: 15px"></i>
					</div>                     
					<a href="../RFQ/ezListRFQs.jsp?type=Act&rfqType=DOM" class="small-box-footer">			
						More info 
						<i class="fa fa-arrow-circle-right"></i> 
					</a>   					 
				</div> 
			</div> 
		</div>
	</div>
	
	<div class="col-lg-4 col-xs-6"> 
		<div class="info-box">
			<div class="inner">
				<div class="small-box bg-aqua">
					<h4 style="height: 60px;padding-top: 30px;font-size: 18px;">&nbsp;&nbsp;<%=toActImpRFQsCnt%></h4> 
					<p>
						&nbsp;Import RFQ(s)To Act&nbsp;&nbsp;<br>&nbsp;
					</p>
					<div class="icon">
						<i class="fa  fa-newspaper-o" style="font-size: 70px;margin-top: 15px"></i>
					</div>                     
					<a href="../RFQ/ezListRFQs.jsp?type=Act&rfqType=IMP" class="small-box-footer">			
						More info 
						<i class="fa fa-arrow-circle-right"></i> 
					</a>   					 
				</div> 
			</div> 
		</div>
	</div>	
<%
	}
	ezc.ezcommon.EzLog4j.log("Debug:::::::LE:::::11","I");
%>	
	
	<div class="col-lg-4 col-xs-6"> 
			<div class="info-box"> 
				<div class="inner">
					<div class="small-box bg-aqua">
						<h4 style="height: 60px;padding-top: 30px;font-size: 18px;">&nbsp;&nbsp;<%=toBeApprQCFs%></h4>
						<p>
							&nbsp;QCF(s)Pending For Approval&nbsp;&nbsp;<br>&nbsp;
						</p>
						<div class="icon">
							<i class="fa  fa-newspaper-o" style="font-size: 70px;margin-top: 15px"></i>
						</div>                     
						<a href="../RFQ/ezQCSList.jsp?type=Act" class="small-box-footer">			
							More info 
							<i class="fa fa-arrow-circle-right"></i>
						</a>   					 
					</div>
				</div>
			</div>
	</div>	
<%
	
	if("PP".equals(userRole) || "BY".equals(userRole) )
	{
%>
	<div class="col-lg-4 col-xs-6"> 
		<div class="info-box"> 
			<div class="inner">
				<div class="small-box bg-aqua">
					<h4 style="height: 60px;padding-top: 30px;font-size: 18px;">&nbsp;&nbsp;<%=toBePOCreate%></h4>
					<p>
						&nbsp;QCF(s)Pending For PO Creation&nbsp;&nbsp;<br>&nbsp;
					</p>
					<div class="icon">
						<i class="fa  fa-newspaper-o" style="font-size: 70px;margin-top: 15px"></i>
					</div>                     
					<a href="../RFQ/ezQCSList.jsp?type=POPend" class="small-box-footer">			
						More info 
						<i class="fa fa-arrow-circle-right"></i>
					</a>   					 
				</div>
			</div>
		</div>
	</div>
<%
	}
%>
	<div class="col-lg-4 col-xs-6"> 
			<div class="info-box"> 
				<div class="inner">
					<div class="small-box bg-aqua">
						<h4 style="height: 60px;padding-top: 30px;font-size: 18px;">&nbsp;&nbsp;<%=toBeApprAuctions%></h4>
						<p>
							&nbsp;Auctions(s)Pending For Approval&nbsp;&nbsp;<br>&nbsp;
						</p>
						<div class="icon">
							<i class="fa  fa-newspaper-o" style="font-size: 70px;margin-top: 15px"></i>
						</div>                     
						<a href="../Request/ezAuctionList.jsp?type=Act" class="small-box-footer">			
							More info 
							<i class="fa fa-arrow-circle-right"></i>
						</a>   					 
					</div>
				</div>
			</div>
	</div>
	<div class="col-lg-4 col-xs-6"> 
		<div class="info-box"> 
			<div class="inner">
				<div class="small-box bg-aqua">
					<h4 style="height: 60px;padding-top: 30px;font-size: 18px;">&nbsp;&nbsp;<%=toBeApprPOs%></h4>
					<p>
						&nbsp;PO's(s)Pending For Approval&nbsp;&nbsp;<br>&nbsp;
					</p>
					<div class="icon">
						<i class="fa  fa-newspaper-o" style="font-size: 70px;margin-top: 15px"></i>
					</div>                     
					<a href="../Purorder/ezSubmittedPOs.jsp?type=Act" class="small-box-footer">			
						More info 
						<i class="fa fa-arrow-circle-right"></i>
					</a>   					 
				</div>
			</div>
		</div>
	</div>
	<div class="col-lg-4 col-xs-6"> 
			<div class="info-box"> 
				<div class="inner">
					<div class="small-box bg-aqua">
						<h4 style="height: 60px;padding-top: 30px;font-size: 18px;">&nbsp;&nbsp;<%=currentVendAuctions%></h4>
						<p>
							&nbsp;Live Auction(s)&nbsp;&nbsp;<br>&nbsp;
						</p>
						<div class="icon">
							<i class="fa  fa-newspaper-o" style="font-size: 70px;margin-top: 15px"></i>
						</div>                     
						<a href="../Request/ezListActiveAuctions.jsp" class="small-box-footer">			
							More info 
							<i class="fa fa-arrow-circle-right"></i>
						</a>   					 
					</div>
				</div>
			</div>
	</div>
	<div class="col-lg-4 col-xs-6"> 
			<div class="info-box"> 
				<div class="inner">
					<div class="small-box bg-aqua">
						<h4 style="height: 60px;padding-top: 30px;font-size: 18px;">&nbsp;&nbsp;<%=toBeApprVNRs%></h4>
						<p>
							&nbsp;Domestic Vendor(s) Pending For Approval&nbsp;&nbsp;<br>&nbsp;
						</p>
						<div class="icon">
							<i class="fa  fa-newspaper-o" style="font-size: 70px;margin-top: 15px"></i>
						</div>                     
						<a href="../Misc/ezVNRList.jsp?type=Act&venType=IN" class="small-box-footer">			
							More info 
							<i class="fa fa-arrow-circle-right"></i>
						</a>   					 
					</div>
				</div>
			</div>
	</div>	
	<div class="col-lg-4 col-xs-6"> 
			<div class="info-box"> 
				<div class="inner">
					<div class="small-box bg-aqua">
						<h4 style="height: 60px;padding-top: 30px;font-size: 18px;">&nbsp;&nbsp;<%=toBeApprImpVNRs%></h4>
						<p>
							&nbsp;Import Vendor(s) Pending For Approval&nbsp;&nbsp;<br>&nbsp;
						</p>
						<div class="icon">
							<i class="fa  fa-newspaper-o" style="font-size: 70px;margin-top: 15px"></i>
						</div>                     
						<a href="../Misc/ezVNRList.jsp?type=Act&venType=IM" class="small-box-footer">			
							More info 
							<i class="fa fa-arrow-circle-right"></i>
						</a>   					 
					</div>
				</div>
			</div>
	</div>		
<%
	ezc.ezcommon.EzLog4j.log("Debug:::::::LE:::::22","I");
	if("VAR".equals(userRole))
	{
%>	
	<div class="col-lg-4 col-xs-6"> 
			<div class="info-box"> 
				<div class="inner">
					<div class="small-box bg-aqua">
						<h4 style="height: 60px;padding-top: 30px;font-size: 18px;">&nbsp;&nbsp;<%=toBeSAPVNRs%></h4>
						<p>
							&nbsp;Vendor(s) Pending For Creation&nbsp;&nbsp;<br>&nbsp;
						</p>
						<div class="icon">
							<i class="fa  fa-newspaper-o" style="font-size: 70px;margin-top: 15px"></i>
						</div>                     
						<a href="../Misc/ezVNRList.jsp?type=Apr" class="small-box-footer">			
							More info 
							<i class="fa fa-arrow-circle-right"></i>
						</a>   					 
					</div>
				</div>
			</div>
	</div>		
<%
	}
	//if("PP".equals(userRole))
	//{
%>
	<div class="col-lg-4 col-xs-6"> 
			<div class="info-box">
				<div class="inner"> 
					<div class="small-box bg-aqua">
						<h4 style="height: 60px;padding-top: 30px;font-size: 18px;">&nbsp;&nbsp;<%=toBeActQrys%></h4> 
						<p>
							&nbsp;Pending Query(s)&nbsp;&nbsp;<br>&nbsp;
						</p>
						<div class="icon">
							<i class="fa  fa-newspaper-o" style="font-size: 70px;margin-top: 15px"></i>
						</div>                     
						<a href="ezListQueries.jsp" class="small-box-footer">			
							More info 
							<i class="fa fa-arrow-circle-right"></i>
						</a>   					 
					</div>
				</div>
			</div>
		</div>
<%
	//}
%>	

<%
	if("PNEGI".equals(Session.getUserId()) || "AKUMARI".equals(Session.getUserId()) || "AANITHA".equals(Session.getUserId()) || "DSINGH3".equals(Session.getUserId()) || "FRAJPUT".equals(Session.getUserId()))
	{
%>
		<center><a href="../Misc/ezGetVendUserMail.jsp"><Font color='RED'><B>Click here to update Vendor E-Mail</B></Font></a></center><Br>
		<center><a href="../MasterData/ezListSAPVendors.jsp"><Font color='RED'><B>Click here to Create Portal Login for Vendor</B></Font></a></center><Br>
		<center><a href="../RFQ/ezPrStatus.jsp"><Font color='RED'><B>Click here to Check for PR Status</B></Font></a></center><Br>
		<center><a href="../Misc/ezUsersList.jsp"><Font color='RED'><B>Click here to Send Login Credentials</B></Font></a></center><Br>
		<center><a href="../RFQ/ezPaymentTerms.jsp"><Font color='RED'><B>Click here to Add Payment Terms</B></Font></a></center><Br>
		<center><a href="../RFQ/ezDeliveryDateUpdate.jsp"><Font color='RED'><B>Click here to update QCF Delivery Date</B></Font></a></center><Br>
<%
	}
	if("PNEGI".equals(Session.getUserId()))
	{
%>
		<center><a href="../RFQ/ezUpdateWorkflows.jsp"><Font color='RED'><B>Click here to update Workflows</B></Font></a></center><Br>
<%
	}
	if("USINGH1".equals(Session.getUserId()) || "RAVIH".equals(Session.getUserId()) || "KASHISH".equals(Session.getUserId()) || "MSIKARWAR".equals(Session.getUserId()) || "AKUMAR24".equals(Session.getUserId()) || "NITHINSR".equals(Session.getUserId()))
	{
%>
		<center><a href="../Misc/ezGetVendUserMail.jsp"><Font color='RED'><B>Click here to update Vendor E-Mail</B></Font></a></center><Br>
<%
	}
	ezc.ezcommon.EzLog4j.log("Debug:::::::LE:::::33","I");
%>
      <!-- /.row -->
<!--	<div class="col-lg-4 col-xs-6"> 
			<div class="info-box">
				<div class="inner"> 
					<div class="small-box bg-aqua">
						<h4 style="height: 60px;padding-top: 30px;font-size: 18px;">&nbsp;&nbsp;<%=toActVendCnt%></h4> 
						<p>
							&nbsp;PENDING ACTION(s)&nbsp; FOR REGISTRATION &nbsp;&nbsp;<br>&nbsp;
						</p>
						<div class="icon">
							<i class="fa  fa-newspaper-o" style="font-size: 70px;margin-top: 15px"></i>
						</div>                     
						<a href="ezListVendReg.jsp?statusSel=SUBMITTED&type=Act&menuItem=vendReg" class="small-box-footer">			
							More info 
							<i class="fa fa-arrow-circle-right"></i>
						</a>   					 
					</div>
				</div>				
		</div>
		</div>
-->		
		
		<!--<div class="row">
			<section class="col-lg-6 connectedSortable">
				<div class="box box-success">
					<div class="box-header  with-border" >
						<h3 class="box-title"><B>&nbsp;&nbsp News</B></h3>
					</div>
					<div class="box-body chat" id="chat-box">
					<p class="message">	 
					<marquee scrollamount="2" direction="up" loop="true">
						<center> 
						<font color="PURPLE">
						<strong> WELCOME <br>
						TO <br>
						JUBULANT<br>
						VENDOR PORTAL
						</strong></font></center>
					</marquee>
					</p>
					</div>												
				</div>
		</section>
		<!-- /.Left col -->
 		
		</div>
		<!-- /.row (main row) -->
		</section>
		<!-- /.content -->
		
	</div>	
  </div> -->
  <!-- /.content-wrapper -->  
<%@ include file="ezFooter.jsp"%>
<%
ezc.ezcommon.EzLog4j.log("Debug:::::::LE:::::44","I");
%>