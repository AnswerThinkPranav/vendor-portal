 
       <div id='loadingmessage' style='position:absolute;bottom:250px;left:500px;display:none'>
       		  <img src='../Invoice/gcloading.gif'/>
       		  <p><b>Your Request is being processed.Please wait....</b></p>
       	</div> 
       	
       <script type="text/javascript">
       document.getElementById("loadingmessage").style.display="block";         
	</script>
       
      
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*,java.util.*" %>   
<%//@ include file="iVendorDetails.jsp" %>             
<%@ include file="../../Library/Globals/errorPagePath.jsp"%>                   
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>     
<%//@ include file="../../../Includes/JSPs/Labels/iSBUWelcome_Labels.jsp"%>   
<%@ page import ="ezc.ezparam.*,java.util.*,ezc.ezutil.*,ezc.ezvendorapp.params.*,ezc.ezpurchase.params.*,ezc.messaging.params.*,ezc.ezpreprocurement.params.*,java.text.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="AppManager" class="ezc.ezvendorapp.client.EzVendorAppManager" scope="session" />
<jsp:useBean id="miscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"></jsp:useBean>
<%@ include file="ezGetUserAuthDefaults.jsp"%>            
  
<%	  
	
	
	java.util.Calendar footerCalObj = java.util.Calendar.getInstance();
	int footerYear = footerCalObj.get(Calendar.YEAR);
	
	//out.println(":::::::footerYear::::::::::;"+footerYear);
	
	if(request.getParameter("vendFromBuyerView")==null && "2".equals(userType))
		response.sendRedirect("ezBuyerWelcome.jsp");
	if("4".equals(userType))
		response.sendRedirect("ezWelcomeTempUser.jsp");		

	if(request.getParameter("vendFromBuyerView")!=null) 
		session.putValue("SOLDTO",request.getParameter("vendFromBuyerView"));
	if(request.getParameter("vendFromBuyerView")!=null) 
		session.putValue("Vendor",request.getParameter("vendNameFromBuyerView"));	
		//out.println("::::::"+session.getValue("Vendor"));

	if("2".equals(userType))
	{
		session.putValue("PORTAL_TYPE","VENDOR");
		portaType   = (String)session.getValue("PORTAL_TYPE");
	}	
%>  
<%@ include file="ezGetVendSAPDetails.jsp"%>
<%
	String namee=NAME1+" "+NAME2;
	//out.println(":::::::::::"+abc.toLowerCase());
	namee=namee.toLowerCase();
	String eemail=SMTP_ADDR;
	eemail=eemail.toLowerCase(); 
	
	//out.println(":::::::NAMEV:::::;"+NAMEV);
	//out.println(":::::::NAME1ConInfo:::::;"+NAME1ConInfo);
	   
%> 
<%  
	 if(!"".equals(SPERQ))      
	{
		//out.println("SPERQ:::"+SPERQ);
		response.sendRedirect("../../../../../ezBlockedUser.jsp");
		return;  
	}
%>   
<%@ include file="ezWelcomePageCounts.jsp"%>        
<%@ include file="ezHeader.jsp"%>    
<%@ include file="../Confirmations/ezGetConfAlerts.jsp"%> 

<%  
		
	String portalEmail	= (String)session.getValue("EMAIL_ID");
	portalEmail		=  portalEmail.toLowerCase();
	
	int retListCnt=0; 	  
	String user	 = (String)Session.getUserId();	 
	String vc	 = LIFNR;
	String mob	 = TELF2;	
	
%>
<%
	Date todaysDate = new Date();		
	Format formatterer = new SimpleDateFormat("yyyy-MM-dd"); 
	String dateStr = formatterer.format(todaysDate);
	//out.println(dateStr+"SPERQ:::"+dateStr);
	
	ReturnObjFromRetrieve retNews	=  null;
	int    NewsCnt	=  0;
	ezc.ezparam.EzcParams mainParams_n	= new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams_n		= new EziMiscParams();
	miscParams_n.setQuery("select * from EZC_NEWS >='"+dateStr+"'");
	mainParams_n.setLocalStore("Y");
	mainParams_n.setObject(miscParams_n);
	Session.prepareParams(mainParams_n);
	try
	{		
		retNews=(ReturnObjFromRetrieve)miscManager.ezSelect(mainParams_n);
	}
	catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Employee List in iGetEmpListForMgr.jsp:::::"+e,"I");}
	if(retNews!=null)
		NewsCnt=retNews.getRowCount();
		String news 	= retNews.getFieldValueString(0,"EZN_TEXT");
		//out.println(news+"SPERQ:::"+NewsCnt);
%>
<%!
	public String checkNull(String value)
	{
		if(value==null || "null".equals(value.trim()))value="";
		value=value.trim();		
		return value; 
	}	   
%>  
<%//@ include file="../../../Includes/JSPs/Purorder/iPOSyncFromSAP.jsp"%>  
<%//@ include file="../../../Includes/JSPs/Rfq/iRFQSync.jsp" %>     
<%//@ include file="../../../Includes/JSPs/Misc/iSBUWelcome.jsp" %>
<%//@ include file="ezGetVendBalance.jsp" %>
<%//@ include file="ezVendorPOsSynchForFirstTime.jsp" %>

<script>
	function funRedirect()  
	{
		alert("1");
		document.myForm.action="ezBlockedUser.jsp";
		document.myForm.submit();
	} 
</script>
<Head>     
<style>
	.form-control 
	{ 
		background-color: #101317;        
	} 
	body
	{
		color: #000000;
		// font-weight: bold;
	}
	a
	{
		color: #000000;
	} 
	.info-box-number 
	{     
		font-weight: bold; 
		font-size: 15px;
	}
	.info-box-text 
	{   
		font-weight: bold;
		font-size: 13px;
	}
	.box.box-success
	{
		border-top-color: lightseagreen ;
	}
	.box-header
	{
		background-color: whitesmoke;
	}
	.table>tbody>tr>td, .table>tbody>tr>th, .table>tfoot>tr>td, .table>tfoot>tr>th, .table>thead>tr>td, .table>thead>tr>th 
	{
		font-family: Verdana, Geneva, sans-serif;
		text-transform: capitalize;
		font-size: small;
	}
	h1, h2, h3, h4, h5, h6, .h1, .h2, .h3, .h4, .h5, .h6 
	{
		font-family: Verdana, Geneva, sans-serif;
	}
	body {    
		font-family: Verdana, Geneva, sans-serif;   
		overflow-x: hidden;
		overflow-y: auto;
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
      <!-- Small boxes (Stat box) -->     
      <div class="row">
	<!--<div class="col-lg-3 col-xs-6">
	
		<div class="info-box">
			<div class="inner">       
				<div class="small-box bg-aqua">
					<h4 style="height: 60px;padding-top: 30px;font-size: 18px;">&nbsp;&nbsp;<%=toBeAckPOsCount%></h4>
					<p>
						&nbsp;PO's To Be Acknowledged<br>&nbsp;
					</p>
					<div class="icon">
						<i class="fa  fa-file-text-o" style="font-size: 70px;margin-top: 15px"></i>
					</div>            
					<a href="../Purorder/ezListAcknowledgedPOs.jsp?FROM=MENU&type=NotAcknowledged&selVendor=null" class="small-box-footer">
						More info 
						<i class="fa fa-arrow-circle-right"></i>
					</a>		 
				</div>
			</div>		
		</div>      
	</div> -->
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
	<!--<div class="col-lg-3 col-xs-6"> 
			<div class="info-box"> 
				<div class="inner">
					<div class="small-box bg-aqua">
						<h4 style="height: 60px;padding-top: 30px;font-size: 18px;">&nbsp;&nbsp;<%=toBeActPrdPO%></h4>
						<p>
							&nbsp;PO(s)Pending For Plan&nbsp;&nbsp;<br>&nbsp;
						</p>
						<div class="icon">
							<i class="fa  fa-newspaper-o" style="font-size: 70px;margin-top: 15px"></i>
						</div>                     
						<a href="../Prdplan/ezPOPrdPlanList.jsp?docStatus=N" class="small-box-footer">			
							More info 
							<i class="fa fa-arrow-circle-right"></i>
						</a>   					 
					</div>
				</div>
			</div>
	</div>
-->
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
	
</div>
      <!-- /.row -->

		<!-- Main row -->
		<div class="row">
		<!-- Left col -->
		<section class="col-lg-6 connectedSortable">
		<!-- Chat box -->
			<div class="box box-success">
				<div class="box-header  with-border" >
					<h5 class="box-title"><B>&nbsp;&nbsp NEWS</B></h5>
				</div>
					<div class="box-body chat" id="chat-box">
					<p class="message">	 <marquee scrollamount="2" direction="up" loop="true">
					<center> <font color="#FF6600" size=2"><strong> WELCOME <br>
					TO <br>
					<!--JGL<br>-->
					VENDOR PORTAL<br>
					<%=checkNull(news)%>
					</strong></font></center>
				</marquee></p>
					
					</div>
					</div>
					
					
					
					
					
					
			</div>
		</section>
		<!-- /.Left col -->
 		
		</div>
		<!-- /.row (main row) -->
		</section>
		<!-- /.content -->
  </div>
  <!-- /.content-wrapper -->		

<%//@ include file="../Admin/ezNews.jsp"%>
	
<script>
 document.getElementById("loadingmessage").style.display="none";       
function funMobileEmail()
{
	$.confirm({
		title: 'Enter Email and Mobile',
		content: '<table class="table"><tr><th>Email Id:</th><td><input type="text" name="emaill" id="emaill"  placeholder="Email Id"  autofocus></td></tr><tr><th>Mobile:</th><td><input type="text" name="mobilee" id="mobilee"  placeholder="Mobile Number"></td></tr></table>',
		buttons: {
			DONE:{
				btnClass: 'btn-success',		
				action:function () {
					var emaill=document.getElementById("emaill").value;
					var mobilee=document.getElementById("mobilee").value;								
					if(emaill=="")
					{
						alert("Please enter email Id.");
						document.getElementById("emaill").focus();
						return false;					
					}
					var x=document.getElementById("emaill").value;
					var atpos=x.indexOf("@");
					var dotpos=x.lastIndexOf(".");
					if (atpos<1 || dotpos<atpos+2 || dotpos+2>=x.length)
					{
						alert("Not a valid e-mail address");
						return false;
					}
					if(mobilee=="")
					{
						alert("Please enter mobile number.");
						document.getElementById("mobilee").focus();
						return false;
					}
					
					if (document.getElementById("mobilee").value.length>10 ||document.getElementById("mobilee").value.length<10)
					{
						alert("enter 10 digit mobile number");
						return false;
					}
					//document.myForm.emaill.value=emaill;
					//document.myForm.mobilee.value=mobilee;
					document.myForm.action="ezMailPhoneUpdate.jsp?emaill="+emaill+"&mobilee="+mobilee;
					document.myForm.submit();
				}
			},
			CANCEL: {
			   btnClass: 'btn-danger',
			   action:function () {

			   }
			}
		}
	});
	
}
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
<script>
function funEDIT()
{
	var Url="ezOTPGeneration.jsp?vendor=<%=LIFNR%>&mobile=<%=TELF2%>";
		$.fancybox.open({

		href : Url,
		type : 'iframe',
		padding : 5,
		width:'35%', 
		height:'250px',
		autoSize : false, 
		closeBtn : true,
		helpers     : { 
				overlay : {closeClick: false}
		 }
	});

	//var titleSel= document.myForm.titleSel.value;
	//document.myForm.action="ezVendorDetailsEdit.jsp";
	//document.myForm.submit();
		
}	
function funSubmit()
{
	document.myForm.action="ezVendorDetailsEdit.jsp";
	document.myForm.submit();
}
</script>
        </section><!-- /.content -->
      </Div><!-- /.content-wrapper -->  
<%@ include file="ezFooter.jsp"%>           
      
<link rel="stylesheet" href="library/fancybox2/jquery.fancybox.css" type="text/css" media="screen" />  
<script type="text/javascript" src="library/fancybox2/jquery.fancybox.js"></script>
<script type="text/javascript" src="library/fancybox2/jquery.fancybox.pack.js"></script>
<link rel="stylesheet" href="../../../../EzCommon/Library/plugins/jQuery/confirm.css" type="text/css" media="screen" />  
<script src="../../../../EzCommon/Library/plugins/jQuery/confirm.min.js"></script>
    