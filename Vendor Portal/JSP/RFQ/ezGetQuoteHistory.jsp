<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />   
<jsp:useBean id="UManager" class="ezc.client.EzUserAdminManager" scope="session" />
<%@ page import = "ezc.ezcommon.*" %>
<%@ page import = "ezc.ezparam.*" %>
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<%! 
	private String checkNull(String str){ 
		if("null".equals(str) ||str==null)
		str="";
		return str.trim();
	}
%>
<%
	java.util.Hashtable hashDisc = new java.util.Hashtable();
	hashDisc.put("P","Discount % on Basic");
	hashDisc.put("Q","Discount/Qty");
	hashDisc.put("V","Discount(Value)");
	hashDisc.put("","N/A");
	
	java.util.Hashtable hashDiscDisp = new java.util.Hashtable();
	hashDiscDisp.put("P","%");
	hashDiscDisp.put("Q","/Qty");
	hashDiscDisp.put("V","Value");
	hashDiscDisp.put("","NA");	
	
	java.util.Hashtable hashPKFW = new java.util.Hashtable();
	hashPKFW.put("P","Pkg&Fwd chrgs(%)");
	hashPKFW.put("Q","Pkg&Fwd/Qty");
	hashPKFW.put("V","Pkg&Fwd chrg-value");
	hashPKFW.put("","N/A");
	
	java.util.Hashtable hashFRT = new java.util.Hashtable();
	hashFRT.put("P","Freight(%)");
	hashFRT.put("Q","Freight/Qty");
	hashFRT.put("V","Freight(Value)");
	hashFRT.put("","N/A");
%>

<%

	String rfqNo=request.getParameter("rfqNo");
	String lineNO=request.getParameter("lineNO");
	//out.println(selplant+"selplant");
	ezc.ezparam.ReturnObjFromRetrieve plantObj	  =	null;
	ezc.ezparam.ReturnObjFromRetrieve quoteHisObj	  =	null;
	ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate();
	
	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false);
		
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTable = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRow = new ezc.misctransactions.params.EzMiscTableRow();
	
	//String qry="SELECT * FROM EZC_RFQ_QUOTE_HISTORY  WHERE ERQH_RFQ_NO='"+rfqNo+"' and ERQH_LINE_NO='"+lineNO+"' and ERQH_COUNTER='1' order by ERQH_COUNTER desc";
	//String qry="SELECT * FROM EZC_RFQ_QUOTE_HISTORY,EZC_RFQ_DETAILS  WHERE ERQH_RFQ_NO=ERD_RFQ_NO AND ERQH_RFQ_NO='"+rfqNo+"' and ERQH_LINE_NO='"+lineNO+"' order by ERQH_COUNTER ";
	String qry="SELECT * FROM EZC_RFQ_QUOTE_HISTORY,EZC_RFQ_DETAILS  WHERE ERQH_RFQ_NO=ERD_RFQ_NO AND ERQH_LINE_NO=ERD_LINE_NO AND ERQH_RFQ_NO='"+rfqNo+"' and ERQH_LINE_NO='"+lineNO+"' order by ERQH_COUNTER ";
	//out.println(qry);
	miscTableRow.setQuery(qry);
	miscTable.appendRow(miscTableRow);
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscTable);
	Session.prepareParams(mainParams);	
	try
	{
		quoteHisObj=(ezc.ezparam.ReturnObjFromRetrieve)miscMgr.ezGetMiscTransactions(mainParams);

	}
	catch(Exception e)
	{
			//out.println("Exception in getting Item Category List:::::"+e);
	}
	
%>
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

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
    <!-- Ionicons -->
    <link rel="stylesheet" href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css">
    <!-- Theme style --> 
    <link rel="stylesheet" href="../../../../EzCommon/Library/dist/css/AdminLTE.min.css">
    <!-- AdminLTE Skins. We have chosen the skin-blue for this starter
          page. However, you can choose any other skin. Make sure you
          apply the skin class to the body tag so the changes take effect.
    -->
    <link rel="stylesheet" href="../../../../EzCommon/Library/dist/css/skins/skin-blue.min.css">
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
        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>-->
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
</head>

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
<form name="myForm" method="post">
    <div class="container" style="margin-left:20px;">
        <div class="row">
            <div>
                <span style="color:rgba(219, 143, 29, 0.808);">
                    <h5><B>Quote History of RFQ:  <%=rfqNo%> with Item:  <%=lineNO%></B></h5>
                </span>
             </div>
         </div>

         <div class="row">
         <div class="col-md-12 col-xs-24">
	 	<div class="box box-primary">
	  		<div class="box-body">
 				  <table id="example" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">	
		<thead>
		<Tr>
			<th>S.No</th>
			<th>Material</th>
			<th>Qty</th>
			<th>Price</th>
			<th>Total</th>
			<th>Discount</th>
			<th>Discount Value</th>
			<th>Supply Price</th> 
		</Tr> 
		</thead>
		<tbody>
		<tr>

<%
	String quotPrice="";
	String condTaxCode="";
	String discType="";
	String condDisc="";
	String PKFWType="";
	String condPKFW="";
	String FRTType="";
	String condFRT="";
	String GSTType="";
	String condGST="";
	
	double totVal = 0.0;
	double discVal = 0.0;
	double discTotVal = 0.0;
	double PKFWVal = 0.0;
	double FRTVal = 0.0;
	double GSTVal = 0.0;
	double sPrice = 0.0;
	double grossVal = 0.0;		

	String totValStr="0";
	String discValStr="0";
	String discTotValStr="0";
	String PKFWValStr="0";
	String FRTValStr="0";
	String GSTValStr="0";
	String sPriceStr = "0";
	String grossValStr = "0";	
	
	ArrayList rfqCounter = new ArrayList();
	int prevCnt=0;
	//out.println("quoteHisObj"+quoteHisObj.getRowCount());
	for(int m=0;m<quoteHisObj.getRowCount();m++)
	{
		
		String rfqNum = quoteHisObj.getFieldValueString(m,"ERQH_RFQ_NO");
		String lineNo = quoteHisObj.getFieldValueString(m,"ERQH_LINE_NO");
		String counter = quoteHisObj.getFieldValueString(m,"ERQH_COUNTER");
		String myQty = quoteHisObj.getFieldValueString(m,"ERQH_EXT1");

		/*if(rfqCounter.contains(rfqNum+"$$"+lineNo+"$$"+counter))
			continue;
		else
			rfqCounter.add(rfqNum+"$$"+lineNo+"$$"+counter); */
		try
		{
			//myQty = (Double.parseDouble(myQty)*1000)+"";
			myQty  = new java.math.BigDecimal(myQty).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
		}	
		catch(Exception e){}
		
		
		
		
		int chkCounter=Integer.parseInt(counter);
		//if(prevCnt==0)
			//prevCnt=chkCounter;
		ezc.ezcommon.EzLog4j.log("prevCntoutZZZZZ>>>>>>> "+prevCnt,"I");
		ezc.ezcommon.EzLog4j.log("chkCounterout>>>>>>> "+chkCounter,"I");
		ezc.ezcommon.EzLog4j.log("condTaxCode>>>>>>> "+quoteHisObj.getFieldValueString(m,"ERQH_COND_CODE"),"I");
		ezc.ezcommon.EzLog4j.log("condValue>>>>>>> "+quoteHisObj.getFieldValueString(m,"ERQH_COND_VALUE"),"I");

		/*if(chkCounter==prevCnt )
		{
			ezc.ezcommon.EzLog4j.log("prevCntoutin>>>>>>> "+prevCnt,"I");
			ezc.ezcommon.EzLog4j.log("chkCounteroutin>>>>>>> "+chkCounter,"I");
			
		}*/

					
		quotPrice=quoteHisObj.getFieldValueString(m,"ERQH_EXT2");
		condTaxCode=quoteHisObj.getFieldValueString(m,"ERQH_COND_CODE");
		//out.println("condTaxCode=="+condTaxCode+"index=="+m);
		if(!"DISC".equals(condTaxCode) || "null".equals(condTaxCode) || condTaxCode==null) 
			continue;
		


			if("DISC".equals(condTaxCode))
			{
				discType=quoteHisObj.getFieldValueString(m,"ERQH_COND_TYPE");
				condDisc=quoteHisObj.getFieldValueString(m,"ERQH_COND_VALUE");
			}
			
			if("PKFW".equals(condTaxCode))
			{
				PKFWType=quoteHisObj.getFieldValueString(m,"ERQH_COND_TYPE");
				condPKFW=quoteHisObj.getFieldValueString(m,"ERQH_COND_VALUE");
			}
			if("FRT".equals(condTaxCode))
			{
				FRTType=quoteHisObj.getFieldValueString(m,"ERQH_COND_TYPE");
				condFRT=quoteHisObj.getFieldValueString(m,"ERQH_COND_VALUE");
			}
			if("TAX".equals(condTaxCode))
			{
				GSTType=quoteHisObj.getFieldValueString(m,"ERQH_COND_TYPE");
				condGST=quoteHisObj.getFieldValueString(m,"ERQH_COND_VALUE");
			}

			try
			{
				quotPrice  = new java.math.BigDecimal(quotPrice).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			}
			catch(Exception e){}		
			try
			{
				totVal= (Double.parseDouble(myQty) * Double.parseDouble(quotPrice));
				totValStr  = new java.math.BigDecimal(totVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			}
			catch(Exception e)
			{
				totVal = 00.0;
			}
			try
			{
				if("P".equals(discType))
					discVal= totVal * Double.parseDouble(condDisc)/100;
				else if("Q".equals(discType))
					discVal= Double.parseDouble(condDisc) * Double.parseDouble(myQty);
				else if("V".equals(discType))
					discVal= Double.parseDouble(condDisc);			

				discValStr  = new java.math.BigDecimal(discVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			}
			catch(Exception e)
			{
				discVal = 00.0;
			}
			try
			{
				if("P".equals(PKFWType))
					PKFWVal= (totVal-discVal) * Double.parseDouble(condPKFW)/100;
				else if("Q".equals(PKFWType))
					PKFWVal= Double.parseDouble(condPKFW) * Double.parseDouble(myQty);
				else if("V".equals(PKFWType))
					PKFWVal= Double.parseDouble(condPKFW);	

				PKFWValStr  = new java.math.BigDecimal(PKFWVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			}
			catch(Exception e)
			{ 
				PKFWVal = 00.0;  
			}	
			if("".equals(condFRT) || "null".equals(condFRT) || condFRT==null) 
				condFRT = "0"; 			
			try
			{
				if("P".equals(FRTType))
					FRTVal= totVal * Double.parseDouble(condFRT)/100;
				else if("Q".equals(FRTType))
					FRTVal= Double.parseDouble(condFRT) * Double.parseDouble(myQty);
				else if("V".equals(FRTType))
					FRTVal= Double.parseDouble(condFRT);		

				FRTValStr  = new java.math.BigDecimal(FRTVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			}
			catch(Exception e)
			{ 
				FRTVal = 00.0;  
			}		
			try
			{
				//sPrice= totVal-discVal+PKFWVal+FRTVal;
				sPrice= totVal-discVal;
				sPriceStr  = new java.math.BigDecimal(sPrice).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			}
			catch(Exception e)
			{ 
				sPrice = 00.0;  
			}		
			if("".equals(condGST) || "null".equals(condGST) || condGST==null) 
				condGST = "0"; 			
			try
			{
				GSTVal= sPrice * Double.parseDouble(condGST)/100;
				GSTValStr  = new java.math.BigDecimal(GSTVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			}
			catch(Exception e)
			{ 
				GSTVal = 00.0;  
			}					
			try
			{
				grossVal= totVal-discVal+PKFWVal+FRTVal+GSTVal;
				grossValStr  = new java.math.BigDecimal(grossVal).setScale(2,java.math.BigDecimal.ROUND_HALF_UP).toString();
			}
			catch(Exception e)
			{ 
				grossVal = 00.0;  
			}
			String dispMat = "";
			try
			{
				dispMat = Long.parseLong(quoteHisObj.getFieldValueString(m,"ERD_MATERIAL"))+"";
			}catch(Exception e){
			}	
			String dispType="";
			if("P".equals(discType)||"Q".equals(discType)||"V".equals(discType))
				dispType = "("+(String)hashDiscDisp.get(discType)+")";

			
		if(chkCounter!=prevCnt )
		{
	
%>
				<td align="center">R<%=prevCnt%></td>
				<td align="center"><%=dispMat%></td>
				<td align="center"><%=myQty%></td>	
				<td align="center"><%=quotPrice%></td>
				<td align="center"><%=totValStr%></td>
				<td align="center"><%=condDisc%><%=dispType%></td>
				<td align="center"><%=discValStr%></td>
				<td align="center"><%=sPriceStr%></td>
			</tr>
<%
		}	
		prevCnt=chkCounter;
	}
%>	
	</tbody>
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
<script>
$(function() {
$('#nav')
    .stop()
    .animate({'marginRight':'-100px'},1000, function() { $(this).addClass('closed'); });

  function toggleDivs() {
    var $inner = $("#nav");
    var $img = $(".nav-btn img", $inner);

    if ($inner.hasClass('closed')) {
      $inner.animate({ right: "100px" }); 
      $img.attr('alt', 'close');
    } else {
      $inner.animate({ right: 0 });
      $img.attr('alt', 'open');
    }

    $inner.toggleClass('closed');
  }
$(".nav-btn").bind("click", function(){
    toggleDivs();
});

});

function closeWin()   // Tested Code
{
alert("kk");
  window.parent.$('#woModal').modal('hide');

}
function funOk()
{
	window.parent.$('#woModal').modal('hide');	
}
function funClose()
{
	parent.$.fancybox.close();
}


</script>
<script type="text/javascript" class="init">
   $(document).ready( function () {
       $('#example').dataTable( {
        "bAutoWidth": false ,
  	"dom": 'tp',
  	    "lengthMenu": [[5,10, 25, 50, -1], [5,10, 25, 50, "All"]]

   	
   	
       } );
   } );

</script>