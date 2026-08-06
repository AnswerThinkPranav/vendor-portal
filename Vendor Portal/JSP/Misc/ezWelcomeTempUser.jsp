<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*,java.util.*,ezc.ezpreprocurement.params.*" %>
<%//@ include file="iVendorDetails.jsp" %>
<%//@ include file="../../Library/Globals/errorPagePath.jsp"%>            
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>     
<%// @include file="../../../Includes/JSPs/Labels/iSBUWelcome_Labels.jsp"%>  
<%@ page import ="ezc.ezparam.*,java.util.*,ezc.ezutil.*,ezc.ezvendorapp.params.*,ezc.ezpurchase.params.*,ezc.messaging.params.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="AppManager" class="ezc.ezvendorapp.client.EzVendorAppManager" scope="session" />
<jsp:useBean id="miscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"></jsp:useBean>
<jsp:useBean id="rfqManager" class="ezc.ezpreprocurement.client.EzPreProcurementManager" />
<%@ include file="ezGetUserAuthDefaults.jsp"%>  
<%@ include file="ezWelcomePageCounts.jsp"%>    
<%@ include file="ezNACompCodeMap.jsp"%>
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
.small-box p {
    font-size: 13px;
}
</style> 
</head>
 <!-- Content Wrapper. Contains page content -->
 
<div class="content-wrapper">
<!-- Content Header (Page header) -->
<section class="content-header">
 <h4>       
	Dashboard 
	</h4> 
</section>
      
    <!-- Main content --> 
<section class="content"> 
<Body>    
<form method="post"  name="myForm">

<div class="row">
<%
		if("INITIATED".equals(vendRegSts)|| "RESUBMITTED".equals(vendRegSts))
			vendRegSts = "COMPLETE REGISTRATION";
		else if("SUBMITTED".equals(vendRegSts))
			vendRegSts = "REGISTRATION UNDER APPROVAL";
		else if("REJECTED".equals(vendRegSts))
			vendRegSts = "REGISTRATION REJECTED";
		else
			vendRegSts = "REGISTRATION APPROVED";
			
	if("4".equals(v_UserType))
	{
		if("Y".equals((String)session.getValue("ALLOW_RFQ")))
		{
%>	
		<div class="col-lg-3 col-xs-6"> 
				<div class="info-box">
					<div class="inner">
						<div class="small-box bg-aqua">
							<h4 style="height: 60px;padding-top: 30px;font-size: 18px;">&nbsp;&nbsp;<%=toBeQuotedRFQsCnt%></h4>
							<p>
								&nbsp;RFQ(s)To Quote&nbsp;&nbsp;<br>&nbsp;
							</p>
							<div class="icon">
								<i class="fa  fa-newspaper-o" style="font-size: 70px;margin-top: 15px"></i>
							</div>                     
							<a href="../RFQ/ezListRFQs.jsp?type=New" class="small-box-footer">			
								More info 
								<i class="fa fa-arrow-circle-right"></i>
							</a>   					 
						</div>
					</div>
				</div>
		</div>
		<div class="col-lg-3 col-xs-6"> 
			<div class="info-box">
				<div class="inner">
					<div class="small-box bg-aqua">
						<h4 style="height: 60px;padding-top: 30px;font-size: 18px;">&nbsp;&nbsp;<%=toBeReQuotedRFQsCnt%></h4>
						<p>
							&nbsp;RFQ(s)To Requote&nbsp;&nbsp;<br>&nbsp;
						</p>
						<div class="icon">
							<i class="fa  fa-newspaper-o" style="font-size: 70px;margin-top: 15px"></i>
						</div>                     
						<a href="../RFQ/ezListRFQs.jsp?type=Req" class="small-box-footer">			
							More info 
							<i class="fa fa-arrow-circle-right"></i>
						</a>   					 
					</div>
				</div>
			</div> 
		</div>
		<!--Auction start-->
		<div class="col-lg-3 col-xs-6"> 
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
		<!-- Auction end--> 
<%
		}
		if("Y".equals((String)session.getValue("ALLOW_REG")))
		{ 
%>		
			<div class="col-lg-3 col-xs-6">
				<div class="info-box">
					<div class="inner">     
						<div class="small-box bg-aqua">
							<h4 style="height: 60px;padding-top: 30px;font-size: 18px;">&nbsp;&nbsp;</h4>
							<p>
								&nbsp; <%=vendRegSts%> <br>&nbsp;
							</p>  
							<div class="icon">
								<i class="fa  fa-file-text-o" style="font-size: 70px;"></i>
							</div>
<% 
			
			ezc.ezcommon.EzLog4j.log("::::naCompHt:::"+naCompHt,"I");
			ezc.ezcommon.EzLog4j.log("::::compCode:::"+compCode,"I");
			
		
			if(!naCompHt.contains(compCode)) 
			{			
				if("IN".equals(vendType) && ("4410".equals(plant) || ("4480".equals(plant)))) 
				{ 
%>					
					<a href="../Misc/ezImpVendReg.jsp" class="small-box-footer">	
					
<%
				} 
				else if("IN".equals(vendType))
				{			
				
%>
					<a href="../Misc/ezVendReg.jsp?type=ToQuote" class="small-box-footer">
					
<%
				}
				else
				{			

%>
					<a href="../Misc/ezImpVendReg.jsp?type=ToQuote" class="small-box-footer">

<%
				}
			}
			else
			{
%>
					<a href="../Misc/ezNAVendReg.jsp?type=ToQuote" class="small-box-footer">
<%
			}
%>
						Click Here 
						<i class="fa fa-arrow-circle-right"></i>
					</a>			
				</div>
				</div>          
				</div>
				</div>		
<%
		}		
	}
	else
	{	

%>
	<div class="col-lg-3 col-xs-6">
		<div class="info-box">
			<div class="inner">     
				<div class="small-box bg-aqua">
					<h4 style="height: 60px;padding-top: 30px;font-size: 18px;">&nbsp;&nbsp;</h4>
					<p>
						&nbsp; <%=vendRegSts%> <br>&nbsp;
					</p>
					<div class="icon">
						<i class="fa  fa-file-text-o" style="font-size: 70px;"></i>
					</div>
<%
	if("IN".equals(vendType))
	{ 
%>					
					<!-- <a href="../Misc/ezVendReg.jsp?type=ToQuote" class="small-box-footer">	-->
					 <a href="../Misc/ezPageRedirect.jsp?type=ToQuote" class="small-box-footer">
<%
	}
	else
	{
%>
					<a href="../Misc/ezImpVendReg.jsp?type=ToQuote" class="small-box-footer">
<%
	}
%>
						Click Here 
						<i class="fa fa-arrow-circle-right"></i>
					</a>			
				</div>
			</div>          
		</div>
	</div>
	
<%
	}
%>	
	</div>
      <!-- /.row -->	
</form>
</body>				
</section>		
</div>
  <!-- /.content-wrapper -->		

<%//@ include file="../Admin/ezNews.jsp"%>	
<script>
	function funConfirmVendProfile()
	{
		$.confirm({
		    title: 'Confirm!',
		    content: 'Is your profile correctly capturing your details? If No, please update your profile?',
		    buttons: {
			YES:{
			btnClass: 'btn-success',
			action:function () {
			funAction("YES");
		       //     $.alert('Confirmed!');
			}
			},
			NO: {
			   btnClass: 'btn-danger',
			   action:function () {
			   funAction("NO");
			   //    $.alert('caNCEL!');
			   }
			}

		    }
		});
	}	
	function funAction(flag) 
	{
		// alert("hi");
		       var xmlhttp;
			if (window.XMLHttpRequest)
			  {// code for IE7+, Firefox, Chrome, Opera, Safari
			  xmlhttp=new XMLHttpRequest();
			  }
			else
			  {// code for IE6, IE5
			  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
			  }
			xmlhttp.onreadystatechange=function()
			  {
			   if (xmlhttp.readyState==4 && xmlhttp.status==200)
			   {
				document.getElementById("venConf").style.display="none";
			  }
			  }
		    xmlhttp.open("GET","ezConfirmVendProfile.jsp?flag="+flag);
		    xmlhttp.send();

	}	
</script>
      
<%@ include file="ezFooter.jsp"%>
<link rel="stylesheet" href="library/fancybox2/jquery.fancybox.css" type="text/css" media="screen" />  
<script type="text/javascript" src="library/fancybox2/jquery.fancybox.js"></script>
<script type="text/javascript" src="library/fancybox2/jquery.fancybox.pack.js"></script>
<link rel="stylesheet" href="../../../../EzCommon/Library/plugins/jQuery/confirm.css" type="text/css" media="screen" />  
<script src="../../../../EzCommon/Library/plugins/jQuery/confirm.min.js"></script>
