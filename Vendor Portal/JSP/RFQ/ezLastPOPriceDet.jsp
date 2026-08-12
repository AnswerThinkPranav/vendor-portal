<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />  
<%@ page import="java.io.*,java.util.*" %>
<%@ include file="../../../Includes/Lib/ezGetDateFormat.jsp"%> 
<%@ page import="ezc.ezcommon.*,java.text.*,ezc.ezparam.*" %>
<%@ include file="../../../Includes/JSPs/Misc/iLoginBanner.jsp" %>   
<%@page import="ezc.sapconnection.*, com.sap.conn.jco.JCoDestination, com.sap.conn.jco.JCoFunction, com.sap.conn.jco.JCoParameterList,com.sap.conn.jco.JCoStructure,com.sap.conn.jco.JCoTable"%>
        
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge"> 
    <title>Jubilant</title>
    <!-- Tell the browser to be responsive to screen width -->
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    
    <meta http-equiv="cache-control" content="max-age=0" />
    <meta http-equiv="cache-control" content="no-cache" />
    <meta http-equiv="expires" content="0" />
    <meta http-equiv="expires" content="Tue, 01 Jan 1990 12:00:00 GMT" />

    <!-- Bootstrap 3.3.5 --> 
    <link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/datepicker.css">
    <!--<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/fixedheader/3.1.2/css/fixedHeader.dataTables.min.css">-->
    <!-- Font Awesome -->
    <!--<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">-->
    <link rel="stylesheet" href="../Library/bootstrap/css/font-awesome.min.css">
    <!-- Ionicons -->
    <!--<link rel="stylesheet" href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css">->
    <link rel="stylesheet" href="../Library/bootstrap/css/ionicons.min.css">
    <!-- Theme style --> 
    <link rel="stylesheet" href="../../../../EzCommon/Library/dist/css/AdminLTE.min.css">
    <!-- AdminLTE Skins. We have chosen the skin-blue for this starter
          page. However, you can choose any other skin. Make sure you
          apply the skin class to the body tag so the changes take effect.
    -->
    <link rel="stylesheet" href="../../../../EzCommon/Library/dist/css/skins/skin-blue.min.css">
    <link rel="stylesheet" href="../../../../EzCommon/Library/dist/css/skins/fuzzycomplete.css">
    <!-- Select2 -->
    <link rel="stylesheet" href="../../../../EzCommon/Library/plugins/select2/select2.min.css">
    <link rel="stylesheet" href="../../../../EzCommon/Library/plugins/iCheck/all.css">
    <link rel="stylesheet" href="../../../../EzCommon/Library/plugins/pace/pacetopline.css">
    <!--datatables css-->
	<link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.responsive.min.css">
	<link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.tableTools.css">	
	<link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/jQuery-Validation/css/validationEngine.jquery.css">
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <!--<script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script> -->
    <![endif]-->
    <style>
	.tx 
	{ 
		    border:0px;
	}
	th
	{
		    background-color: #3c8dbc;
		    color:white;
	}
	button
	{
		margin-left:2px;
	}
</style>
    
  <%!
  	public String checkNull(String value){
  		if(value==null || "null".equals(value.trim()))value="0.00";   		
  		return value.trim();
  	}  					  
  %>   
  <% 
  		ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate();
		String mat=request.getParameter("mat");
		mat ="000000000000000000"+mat;
		mat =mat.substring(mat.length()-18);		
		
		String purOrg=request.getParameter("purOrg");
		String plant=request.getParameter("plant");
		ezc.ezcommon.EzLog4j.log("purOrg in LAST PO"+purOrg,"I");
		ezc.ezcommon.EzLog4j.log("plant in LAST PO "+plant,"I");
		//To fetch last PO price			
		java.math.BigDecimal netPR=new java.math.BigDecimal(0);
		JCoFunction function =null;	
		String logonSite = (String)session.getValue("SITE");
		
		SimpleDateFormat parser = new SimpleDateFormat("EEE MMM d HH:mm:ss zzz yyyy");
		SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/YYYY");
	
			JCoDestination destination = EzSAPHandler.getDestination(logonSite+"~999");	
			function = EzSAPHandler.getJCoFunction(destination,"Z_EZ_GET_LAST_PO_PRICE");
	
			JCoParameterList sapPreProc = function.getImportParameterList();
			sapPreProc.setValue("PUR_ORG",purOrg);
	
			JCoParameterList sapTabParam= function.getTableParameterList();
			JCoTable poItemTable = sapTabParam.getTable("POITEMS");
	
			poItemTable.appendRow();
			poItemTable.setValue("MATNR",mat);
	
			try
			{
				function.execute(destination);
			}catch(Exception qe){
				ezc.ezcommon.EzLog4j.log("Exception in Z_EZ_GET_LAST_PO_PRICE FM Exectution:::::::::::::::"+qe,"I");
			}	
	
	
			int poCnt =0;
			ArrayList items =null;
			JCoTable sapPoList = function.getTableParameterList().getTable("POITEMS"); 
			poCnt 	= 	sapPoList.getNumRows();
			ezc.ezcommon.EzLog4j.log("poCntin POPUP:::::::::::::::"+poCnt,"I");
			ezc.ezparam.ReturnObjFromRetrieve myRet= null;
			

			
	
			if(poCnt > 0)
			{
				myRet= new ReturnObjFromRetrieve(new String[]{"VENDOR","VENDNAME","PLANT","MATERIAL","PONUM","CREATED_ON","UOM","CURRENCY","QTY","NETPR"});
	
			try 
			{		
				do
				{
					String chkStr = (String)sapPoList.getValue("EBELN");
					//if(chkStr.startsWith("6"))
					 	//continue;
					myRet.setFieldValue("VENDOR", sapPoList.getValue("LIFNR"));		
					myRet.setFieldValue("VENDNAME",sapPoList.getValue("NAME1"));		
					myRet.setFieldValue("PLANT",sapPoList.getValue("WERKS"));
					myRet.setFieldValue("MATERIAL",sapPoList.getValue("MATNR"));
					myRet.setFieldValue("PONUM",sapPoList.getValue("EBELN"));
					myRet.setFieldValue("CREATED_ON",sapPoList.getValue("AEDAT"));
					ezc.ezcommon.EzLog4j.log("AEDAT:::::::::::::::"+sapPoList.getValue("AEDAT"),"I");
					myRet.setFieldValue("UOM",sapPoList.getValue("MEINS"));
					myRet.setFieldValue("CURRENCY",sapPoList.getValue("WAERS"));
					myRet.setFieldValue("QTY",sapPoList.getValue("MENGE"));
					myRet.setFieldValue("NETPR",sapPoList.getValue("NETPR"));
					myRet.addRow();
	
	

				  		
				  }while(sapPoList.nextRow());
				  		
				  //out.println("myRet"+myRet.toEzcString());
	
			}
		catch (Exception e) {}
		}
  %>
  <html>
  <head>
	<%@ include file="../Misc/ezPopUpIncludes.jsp"%> 
  </head>	
  <Script type="text/javascript" src="../Common/JavaScript/ezTrim.js"></Script>
  <!--datatables css-->
  <link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.bootstrap.min.css">
  <link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.responsive.min.css">
  <link rel="stylesheet" type="text/css" href="../../../../EzCommon/Library/dataTables/dataTables.tableTools.css">
 <!-- Content Wrapper. Contains page content -->
<form method="post" name="myForm">
    <div class="container" style="margin-left:20px;">
        <div class="row">
            <div>
                <span style="color:rgba(219, 143, 29, 0.808);">
                    <h4><B>LAST PO DETAILS FOR MATERIAL : <%=mat%></B></h4>
                </span>
             </div>
         </div>
         <div class="row">
         <div class="col-md-12 col-xs-24">
	 	<div class="box box-primary">
	  		<div class="box-body">
 				  <table id="example" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
               
				   <thead>
				   	<th>DOC DATE</th>
					<th>VENDOR</th>
					<th>NAME</th>
					<th>PLANT</th>
					<th>MATERIAL</th>
					<th>PO NUM</th>
					<th>QUANTITY</th>
					<th>PRICE</th>
				   </thead>
				   <tbody>
<%
				  for(int j=0;j<myRet.getRowCount();j++)
				  {
					Date date = parser.parse(myRet.getFieldValueString(j,"CREATED_ON"));
					String formattedDate = formatter.format(date);	
					String poQty = myRet.getFieldValueString(j,"QTY");
					String poQtyStr=new java.math.BigDecimal(poQty).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
					String poVend = "";
					try
					{
						poVend =Integer.parseInt(myRet.getFieldValueString(j,"VENDOR"))+"";
					}
					catch(Exception e)
					{
						poVend = "";
					}
					if("".equals(poVend))
						continue;
%>
				    <tr>
				    	<td><%=formattedDate%></td>
				    	<td><%=poVend%></td>
					<td><%=myRet.getFieldValueString(j,"VENDNAME")%></td>
					<td align="center"><%=myRet.getFieldValueString(j,"PLANT")%></td>
				    	<td><%=Long.parseLong(myRet.getFieldValueString(j,"MATERIAL"))%></td>
				    	<td><%=myRet.getFieldValueString(j,"PONUM")%></td>
					<td align="center"><%=poQtyStr%></td>
					<td><%=checkNull(myRet.getFieldValueString(j,"NETPR"))%></td>
				    </tr>
		
<%
				  }
%>				

				</table>
               		</div>
               	</div>	
            </div>
        </div>
        <div class="row" align="right">
            <button type="button" class="btn btn-primary" onclick="funClose()">CLOSE</button>
          
        </div>
    </div>
</form>  
 
      
 
  
     <script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>
     <script src="../../../../EzCommon/Library/plugins/jQueryUI/jquery-ui.min.js"></script>
     <script src="../../../../EzCommon/Library/plugins/jQuery/jquery.form.js"></script>
     <script src="../../../../EzCommon/Library/plugins/select2/select2.full.min.js"></script>
     <script src="../../../../EzCommon/Library/plugins/iCheck/icheck.min.js"></script>
     <script src="../../../../EzCommon/Library/plugins/fuse/dist/fuse.js"></script>
     <script src="../../../../EzCommon/Library/dist/js/fuzzycomplete.js"></script>
      
     <!-- Bootstrap 3.3.5 -->
     <script src="../../../../EzCommon/Library/bootstrap/js/bootstrap.min.js"></script>
     <!-- AdminLTE App --> 
     <script src="../../../../EzCommon/Library/js/datepicker.js"></script>
     <script src="../../../../EzCommon/Library/js/alert_confirm.js?2"></script>
     <script src="../../../../EzCommon/Library/dist/js/app.min.js?2"></script>
 	<script src="../../../../EzCommon/Library/dataTables/ZeroClipboard.js"></script>
 	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/jquery.dataTables.min.js"></script>
 	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/dataTables.bootstrap.min.js"></script>
 	<!--<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/dataTables.responsive.min.js"></script>-->
 	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/dataTables.tableTools.js"></script>	
 	<!--datatables download -->
 	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/plugins/datatables/extensions/download/dataTables.buttons.min.js"></script>	
 	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/plugins/datatables/extensions/download/buttons.flash.min.js"></script>	
 	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/plugins/datatables/extensions/download/jszip.min.js"></script>	
 	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/plugins/datatables/extensions/download/vfs_fonts.js"></script>	
 	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/plugins/datatables/extensions/download/buttons.html5.min.js"></script>	
 	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/plugins/datatables/extensions/download/buttons.print.min.js"></script>	
 
 	<!--end-->
 	<script src="../../../../EzCommon/Library/plugins/pace/pace.min.js"></script>
     
          <script src="../../../../EzCommon/Library/jQuery-Validation/js/jquery.validationEngine.js" type="text/javascript" charset="utf-8"></script>
          <script src="../../../../EzCommon/Library/jQuery-Validation/js/jquery.validationEngine-en.js" type="text/javascript" charset="utf-8"></script>
  <script>
  $(document).ready( function () {
  	   	
  	       $('#example').dataTable( {
  	       "order":[[4,"desc"]],
  	       "bInfo": false,
  	       "bPaginate": false,
  	       "bAutoWidth": false ,
  	   	"lengthMenu": [[10, 20, -1], [10, 20, 'All']]
  	      
  	   	
  	   	
  	       } );
   } );
   function funClose()
   {
   
           parent.$.fancybox.close();
   }
   </script>
</body>
</html>
	