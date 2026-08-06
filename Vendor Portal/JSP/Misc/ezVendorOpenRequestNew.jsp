<%@ include file="../../../Includes/Lib/DateFunctions.jsp"%>
<%@ page import = "java.text.*"%> 
<%@ page import = "java.util.Date"%>  
<%@ page import = "ezc.ezutil.FormatDate"%>
<%@ include file="../Misc/ezCommonMethods.jsp"%> 
<%@ include file="ezGetUserAuthDefaults.jsp"%> 
<%@ include file="../Misc/ezHeader.jsp"%> 
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"/>
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>
<Html>
<link rel="stylesheet" type="text/css" href="../../Library/jquery/jquery-ui-1.12.1.custom/jquery-ui.css">
<link rel="stylesheet" href="../Misc/library/fancybox2/jquery.fancybox.css" type="text/css" media="screen" />
<Head>
<meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
<%
	String cat                     = request.getParameter("cat");	
%>

	
<style>

.dashBoxHeader
{
	background-color: #3C8DBC;
	color: azure;
    	font-weight: bold;
}
.pinBoxHeader
{
	    float: right;
}
tr
{
	height: 39px;
}
input
{
	    border: none;
}

.my-error-class {
    float:none;
    color:red;
    display: block;
    padding-left: .5em;
   vertical-align: top; 
}

</style>


</Head>

<!-- Content Wrapper. Contains page content -->
      <Div class="content-wrapper">      
<section class="content">
   <form method="post" action="" name='myForm' id='myForm'>
      <div class="row">           

   <%String Name = (String)session.getValue("EZC_PORTAL_USER_ID");  %>
     <%		
     	ReturnObjFromRetrieve retQuery	=  null;
     	int    QueryCnt	=  0;
     	soldTo = Integer.parseInt(soldTo)+"";
     	ezc.ezparam.EzcParams mainParams	= new ezc.ezparam.EzcParams(false);
     	EziMiscParams miscParams		= new EziMiscParams();
     	
     	if(cat!=null)
     	{        
     		miscParams.setQuery("select * from ezc_vend_general_data where EVGD_VENDOR in ('"+soldTo+"','0000"+soldTo+"')and EVGD_STATUS='CLOSED'");	
     	}
     	else
     	{
     		miscParams.setQuery("select * from ezc_vend_general_data where EVGD_VENDOR in ('"+soldTo+"','0000"+soldTo+"') and EVGD_STATUS='CLOSED'");
     	
     	}
     	mainParams.setLocalStore("Y");
     	mainParams.setObject(miscParams);
     	Session.prepareParams(mainParams);
     	try
     	{		
     		retQuery=(ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);
     	}
     	catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Employee List in iGetEmpListForMgr.jsp:::::"+e,"I");}
     	if(retQuery!=null)
     		QueryCnt=retQuery.getRowCount();     			
%>

</div>

<% 	
 	if(QueryCnt>0)
   	{
	
	String display_header ="";	
		display_header = "Closed Request List";
%>
<%
	  String trBGColor = "Bgcolor=\"#f39c12\"  style=\"color:black\"";
	  String altRowColor = "style=\"background-color:#c9e0ff\""; 
%> 
<Script>
	function setMessageVisible()
	{
		var divVal = document.getElementById("ButtonDiv");
		if(divVal == null)
		 	alert("divVal is null !!!!");
		else
		divVal.style.visibility="hidden";
		document.getElementById("EzButtonsMsg").style.visibility="visible";
	}
</Script>	

       <h5>
             <B> <%=display_header%> </B>
             <!--<small>Optional description</small>-->
    </h5>
      <div class="box box-primary">
      <div class="box-body table-responsive no-padding">
      
	 <%//@ include file="../Misc/ezSubHeader.jsp"%> 			    
 	<Table border="1" align="center" valign=middle width="95%" cellpadding=0 cellspacing=0 class=welcomecell> 	
	</Table>             
	<table id="" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
		<thead>
		<Tr <%=trBGColor%>>
			<Th width="6%" filter="false">Doc Id</Th>
			<Th width="10%" filter="false">Vendor</Th>
			<Th width="20%" filter="false">Vendor Type</Th>
			<Th width="8%" filter-type='ddl'>Status</Th>
			<Th width="8%" filter="false">Name</Th>						
			<Th width="8%" filter="false">Modified Date</Th>
		</Tr>
		</thead>
		
		<tbody>   
	<%
		for (int i=0;i<QueryCnt;i++) 
		{
	%>	   <Tr>			
			<Td width="6%" align="center"><%=retQuery.getFieldValueString(i,"EVGD_DOC_ID")%></Td>
			<Td width="10%" align="left"><%=retQuery.getFieldValueString(i,"EVGD_VENDOR")%></Td>
			<Td width="20%" align="center"><%=retQuery.getFieldValueString(i,"EVGD_VEND_TYPE")%></Td>
			<Td width="8%" align="center"><%=retQuery.getFieldValueString(i,"EVGD_STATUS")%></Td>
			<Td width="8%" align="center"><%=retQuery.getFieldValueString(i,"EVGD_NAME1")%></Td>
			<Td width="8%" align="center"><%=retQuery.getFieldValueString(i,"EVGD_MODIFIED_ON").substring(0,10)%></Td>
		  </tr>
	<%
		}
	%>

		</tbody>
	</Table>
        </div>
     </div>
<%
	}
%>
	<input type="hidden" name="cat" id="cat">
  </form>
  </Body>
  </section>
</div>
<script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>
<script src="../../Library/jquery/jquery-validation-1.16.0/dist/jquery.validate.min.js"></script>
<script src="../../Library/jquery/jquery-validation-1.16.0/dist/additional-methods.min.js"></script>
  
 <script type="text/javascript">
 function funGo()
 {

}
 function funSubmit()
 {
   var category	=document.myForm.category.value;
 
	{
	document.myForm.action="ezSaveVendorQuery.jsp";
	document.myForm.submit();
	}
	
 }
</html>
<%//@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter1.jsp"%> 
<%@ include file="../Misc/ezDataTableScript.jsp"%>
