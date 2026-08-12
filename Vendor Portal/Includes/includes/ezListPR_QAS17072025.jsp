<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>   
<%@ include file="../Misc/ezHeader.jsp"%>          
<%@page import="java.util.*"%>   
<%@ include file="../../../Includes/JSPs/Misc/iblockcontrol.jsp" %>  
<%@ include file="../../../Includes/Lib/ezGetDateFormat.jsp" %>
<%@include file="../../../Includes/JSPs/Rfq/iSelectFields.jsp"%>   
<%@ include file="../../../Includes/JSPs/Rfq/iListPR.jsp" %>  
<%@ include file="../../../../EzVendor/Includes/JSPs/Labels/iListPR_Labels.jsp"%> 
<style>
.table>tbody>tr>td, .table>tbody>tr>th, .table>tfoot>tr>td, .table>tfoot>tr>th, .table>thead>tr>td, .table>thead>tr>th {

    line-height: inherit !important;
}
th
{	
    color: white;
    background: #325786;
	
}
div.tooltip
{
    word-wrap:  break-word;
}
</style>
<%!	
	Date convertStringToDate(String dateStr)
	{
		Date conDateObj = null;
		if(dateStr != null && dateStr.length() > 9)
		{
		    ezc.ezcommon.EzLog4j.log("dateStr::" + dateStr, "I");
		    int dd = Integer.parseInt(dateStr.substring(0, 2));
		    int mm = Integer.parseInt(dateStr.substring(3, 5));
		    int yy = Integer.parseInt(dateStr.substring(6, 10));
		    GregorianCalendar g = new GregorianCalendar(yy, mm - 1, dd);
		    conDateObj = g.getTime();
		    ezc.ezcommon.EzLog4j.log("conDateObj::" + conDateObj, "I");
		}
		return conDateObj;
	}
%>
<% 
	String display_header = "List Of Purchase Requisitions"; 
	if(Status.equals("R"))
		display_header = "List Of Released Purchase Requisitions";   
	else if(Status.equals("U"))
		display_header = "List Of Unreleased Purchase Requisitions";               
		
	//out.println("Status=="+Status); 
	String prsSel 	= 	request.getParameter("prsSel");
	//out.println("prsSel=="+prsSel);
	String rfqStat=request.getParameter("rfqStat");
	ezc.ezcommon.EzLog4j.log("rfqStat>>>>" + rfqStat, "I");
	
	String frmBack=request.getParameter("frmBack");
	//out.println("frmBack=="+frmBack);
	String chkdIndx="";
%> 
<!-- Content Wrapper. Contains page content --> 
<div class="content-wrapper">
<!-- Content Header (Page header) -->
<section class="content-header">
   <h1>
      <%=display_header%>
   </h1> 
</section>
<!-- Main content -->  
<section class="invoice">
<form  name="myForm" method="post">   
<input type=hidden name="purchaseHidden">
<input type=hidden name="puReqTot">
<input type=hidden name="puReqTotChk">
<input type=hidden name="qcfPrev">
<input type ="hidden" name="reasons" value ="">       
 
<%  
	if(myRetCount==0)
	{
%>
<div class="row">
   <!-- left column -->
   <div class="col-md-12 col-xs-12">
	<div class="alert alert-danger">
		<p>No Purchase Requisitions exist to List</p>
	</div>
		<button type="button" class="btn btn-primary pull-right" onclick="funBack()"><i class="fa fa-arrow-left"></i>&nbsp;Go Back</button>
	</div>
	</div>

<%
	}
	else
	{
%>
 <div class="row">
   <!-- left column -->
   <div class="col-md-12 col-xs-12">
   <!-- general form elements -->
   <div class="box box-primary">
         <div class="box-body table-responsive no-padding"> 
               <table id="example" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
	<thead>  
      <tr>
<%
  	if(Status.equals("R")){
%>
      		<th align="center" width="3%">&nbsp;</th>  
<%
	}
%>
		<th align="center"><%=PR_No_L%></th> 
		<th align="center"><%=line_No_L%></th>
		<th align="center"><%=mat_Grp_L%></th>
		<th align="center"><%=created_Date_L%></th>
		<th align="center"><%=changed_On_L%></th>
				
		<th align="center" ><%=acc_Cat_L%><br>Cat</th>      
		<th align="center"><%=PR_item_L%><br>Cat</th>  
		<th align="center"><%=material_L%></th>
		<th align="center"><%=PR_desc_L%></th>

		<th align="center"><%=PR_Qty_L%></th>
		<th align="center">Per</th>
		<th align="center"><%=UOM_L%></th>
		<th align="center"><%=unit_Price_L%></th>
		<th align="center"><%=tot_Val_L%></th>
		<th align="center"><%=Currency_L%></th>
		<th align="center"><%=del_Date_L%></th>
		<!--<th align="center">Released Date</th>-->
		<th align="center"><%=plants_L%></th>
		<th align="center"><%=pur_Grp_L%></th>
		<th align="center"><%=item_Text_L%></th>
		<th align="center"><%=PO_Text_L%></th>		
		<th align="center"><%=requested_By_L%></th>
		<th align="center"><%=created_By_L%></th>        
		<!--<th align="center">MRP Controller</th>-->
		<!--<th align="center">Fixed Vendor</th>-->
		<th align="center"><%=Ammended_L%></th>
		<th align="center"><%=rfq_Status_L%></th>
       </tr>
 </thead>
 <tbody>
 <%
	boolean showStr = false;
	String  rfqStatus="";
	ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate();
	String  reqno="",item="",material="",myMatDesc="",poText="",poTextDisp="",itemText="",itemTextDisp="",version="";
	String prnditm="";
	String selPrNo="",selItemNo="";
	String chkd="";
	int prsSelLen=0;
	int rfqLinesCnt=0;
	String qryRfq="";
	ezc.ezparam.ReturnObjFromRetrieve rfqObj	  =	null;
	
	try
	{
		prsSelLen=prsSel.split("___").length;
		//out.println("prsSelLen1=="+prsSelLen);
	}
	catch(Exception e){}
	//out.println("prsSelLen2=="+myRet.toEzcString());
	
	for(int i=0;i<myRetCount;i++)
	{
		chkd="";
		try
		{
			reqno=""+Long.parseLong(myRet.getFieldValueString(i,"REQNO"));
		}
		catch(Exception e)
		{
			reqno=myRet.getFieldValueString(i,"REQNO");
		}
		try
		{
			item=""+Long.parseLong(myRet.getFieldValueString(i,"ITEM"));
		}
		catch(Exception e)
		{	
			item=myRet.getFieldValueString(i,"ITEM");
		}
		try
		{
			material=""+Long.parseLong(myRet.getFieldValueString(i,"MATERIAL"));
		}
		catch(Exception e)
		{
			material=myRet.getFieldValueString(i,"MATERIAL");
		}

		String searchKey=myRet.getFieldValueString(i,"REQNO")+"¥"+myRet.getFieldValueString(i,"ITEM");	
		ezc.ezcommon.EzLog4j.log("searchKey:::::::::::::::"+searchKey,"I");
		ezc.ezcommon.EzLog4j.log("prTreeSet:::::::::::::::"+prTreeSet,"I");
		
		if(prTreeSet.contains(searchKey))
		{
			ezc.ezparam.EzcParams qcfParams = new ezc.ezparam.EzcParams(false);
			ezc.misctransactions.client.EzMiscTransactionsManager qcfMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
			ezc.misctransactions.params.EzMiscTable qcfTable = new ezc.misctransactions.params.EzMiscTable();
			ezc.misctransactions.params.EzMiscTableRow qcfTableRow = new ezc.misctransactions.params.EzMiscTableRow();

			qryRfq="SELECT DISTINCT(ERH_STATUS) FROM EZC_RFQ_HEADER,EZC_RFQ_DETAILS WHERE ERH_STATUS NOT IN ('Y','S') AND ERH_RFQ_NO=ERD_RFQ_NO AND ERD_RFQ_NO IN(SELECT ERD_RFQ_NO FROM EZC_RFQ_DETAILS WHERE ERD_EXT1='"+searchKey+"')" ;

			ezc.ezcommon.EzLog4j.log("** qryRfq"+qryRfq,"I");

			qcfTableRow.setQuery(qryRfq);
			qcfTable.appendRow(qcfTableRow);
			qcfParams.setLocalStore("Y");
			qcfParams.setObject(qcfTable);
			Session.prepareParams(qcfParams);

			try
			{
				rfqObj=(ezc.ezparam.ReturnObjFromRetrieve)qcfMgr.ezGetMiscTransactions(qcfParams);

			}	 
			catch(Exception e)
			{
				out.println("Exception in getting PR List>>>>>"+e);
			}	
			ezc.ezcommon.EzLog4j.log("rfqObj iin PR LIST>>>>"+rfqObj.toEzcString(),"I");
			
			
				if(rfqObj!=null)
					rfqLinesCnt=rfqObj.getRowCount();
					
				if(rfqLinesCnt==0)
					continue;
		}
		
		if(prTreeSet.contains(searchKey)) 
		{
			showStr = true;
			rfqStatus="Yes";
		}	
		else
		{
			showStr = false;
			rfqStatus="No";
		}
		ezc.ezcommon.EzLog4j.log("rfqStat:::::::::::::::"+rfqStat,"I");
		ezc.ezcommon.EzLog4j.log("showStr:::::::::::::::"+showStr,"I");
		ezc.ezcommon.EzLog4j.log("rfqStatus:::::::::::::::"+rfqStatus,"I");
		if("Y".equals(rfqStat))
		{
			if(!showStr)
				continue;
			
		}
		if("N".equals(rfqStat))
		{
			if(showStr)
				continue;
			
		}		
		
		if("0".equals(item))
		{
			continue;
		}
		String itemCat1 = myRet.getFieldValueString(i,"ITEM_CAT");
		if("0".equals(itemCat1))  
		{
			itemCat1 = "";
		}
		if("7".equals(itemCat1))   
		{
			itemCat1 = "U";
		}
		if("9".equals(itemCat1))  
		{
			itemCat1 = "D";
		}
		String pckgNo= "";
		boolean chkSer= false;
		if(servCnt>0)
		{
			if(mySer.find("SERVPCKGNO",myRet.getFieldValueString(i,"PCKG_NO")))
			{
				pckgNo=myRet.getFieldValueString(i,"PCKG_NO");
				chkSer= true;
			}
		}	
				
%>
		<!--<Tr style="<%=showStr?"background-color:#efdbe7":""%>">-->
<%
		if(showStr)
		{
%>		
			<Tr style="<%=showStr?"background-color:#efdbe7":""%>">
<%
		}
		else if(chkSer)
		{
%>
			<Tr style="background-color:#e4ff00">
<%		
		}
		else
		{
%>
			<Tr>
<%
		}
		String styleTemp="",prColor="";
		if(Status.equals("R")) 
		{ 
			for(int k=0;k<prsSelLen;k++)
			{
				prnditm=prsSel.split("___")[k];
				selPrNo=prnditm.split("_")[0];
				selPrNo=Long.parseLong(selPrNo)+"";
				selItemNo=prnditm.split("_")[1];
				selItemNo=Integer.parseInt(selItemNo)+"";
				//out.println("selPrNo=="+selPrNo+"==reqno=="+reqno+"==selItemNo=="+selItemNo+"==item=="+item);
				if(selPrNo.equals(reqno) && selItemNo.equals(item))
				{
					chkd="checked";
					chkdIndx=chkdIndx+"##"+i+""; 
				}
			}
			if(chkdIndx.startsWith("##"))chkdIndx=chkdIndx.substring(2);

			myMatDesc = myRet.getFieldValueString(i,"DESCRIPTION");
			myMatDesc=myMatDesc.replace('\'','`');
			myMatDesc=myMatDesc.replace('\"','`');
			
			poText=checkNull(myRet.getFieldValueString(i,"PO_TXT"));
					
			poText=poText.replaceAll("'","`");
			poText = poText.replaceAll("\"", "`"); 
			poText = poText.replaceAll("$", "");
			poText = poText.replaceAll("&", "&amp;");
			poText = poText.replaceAll("<", "&lt;");
			poText = poText.trim();
			
			if(poText.length()>40)
				poTextDisp= poText.substring(0,40)+"...";
			else
				poTextDisp= poText;			
			
			itemText = checkNull(myRet.getFieldValueString(i,"ITEM_TXT")); 
			itemText=itemText.replaceAll("'","`");
			itemText = itemText.replaceAll("\"", "`");
			itemText = itemText.replaceAll("$", "");
			itemText = itemText.replaceAll("&", "&amp;");
			itemText = itemText.replaceAll("<", "&lt;");
			itemText = itemText.trim();
			//out.println("itemTextLength"+itemText.length());
			if(itemText.length()>40)
				itemTextDisp= itemText.substring(0,40)+"...";
			else
				itemTextDisp= itemText;
				
			version = checkNull(myRet.getFieldValueString(i,"VERSION"));
			
			if(!"".equals(version))
				version= "V"+Integer.parseInt(version)+"";
					
		
			String tempVal= myRet.getFieldValueString(i,"MATERIAL")+"$$"+myRet.getFieldValueString(i,"PLANT")+"$$"+fd.getStringFromDate((Date)myRet.getFieldValue(i,"DELIV_DATE"),".",ezc.ezutil.FormatDate.DDMMYYYY)+"$$"+myRet.getFieldValueString(i,"QUANTITY")+"$$"+myRet.getFieldValueString(i,"UNIT")+"$$"+myMatDesc+"$$"+myRet.getFieldValueString(i,"REQNO")+"$$"+myRet.getFieldValueString(i,"ITEM")+"$$"+myRet.getFieldValueString(i,"PUR_GRP")+"$$"+itemText+"$$"+poText+"$$"+myRet.getFieldValueString(i,"FIXED_VEND")+"$$"+myRet.getFieldValueString(i,"DOC_TYPE")+"$$"+myRet.getFieldValueString(i,"ACCTASSCAT")+"$$"+itemCat1+"$$"+pckgNo+"$$"+myRet.getFieldValueString(i,"CURRENCY")+"$$"+myRet.getFieldValueString(i,"MAT_GRP")+"$$"+checkNull(myRet.getFieldValueString(i,"CREATED_BY")+"$$"+fd.getStringFromDate((Date)myRet.getFieldValue(i,"LAST_RESUB"),".",ezc.ezutil.FormatDate.DDMMYYYY)+"$$"+myRet.getFieldValueString(i,"PRICE_UNIT"));
			
			
%>
			<td align="center" width="3%"><input onclick="onChgChk(this,'<%=i%>')" type="checkbox" <%=chkd%> name="purchReq"  value='<%=tempVal%>'></td> 
			<input type="hidden" name="index_<%=i%>" value="<%=tempVal%>">
<%
		}
		if(chkSer)
		{		
%>
			<td><a href="javascript:openService('<%=reqno%>','<%=item%>','<%=pckgNo%>')"> <%=checkNull(reqno)%></a></td>  
<%
		}
		else
		{
%>
		<td><%=checkNull(reqno)%></td> 
<%
		}
%>		
		<td align="center"><%=checkNull(item)%></td>
		<td align="left"><%=(String)matHash.get(checkNull(myRet.getFieldValueString(i,"MAT_GRP")))%>[<%=checkNull(myRet.getFieldValueString(i,"MAT_GRP"))%>]</td>		
		<td align="center">
		
		<span style="display:none;"><%=fd.getStringFromDate((Date)myRet.getFieldValue(i,"REQDATE"),"",ezc.ezutil.FormatDate.MMDDYYYY)%></span>
		<%=fd.getStringFromDate((Date)myRet.getFieldValue(i,"REQDATE"),".",ezc.ezutil.FormatDate.DDMMYYYY)%></td>
		<td align="center"><%=fd.getStringFromDate((Date)myRet.getFieldValue(i,"LAST_RESUB"),".",ezc.ezutil.FormatDate.DDMMYYYY)%></td>
		
		<td align="left"><%=checkNull(myRet.getFieldValueString(i,"ACCTASSCAT"))%></td>         
		<td align="left"><%=checkNull(itemCat1)%></td>
		<td align="left"><%=checkNull(material)%></td>
		<!--<td align="left"><input type=text size=25 value="<%=myRet.getFieldValueString(i,"DESCRIPTION")%>" title="<%=myRet.getFieldValueString(i,"DESCRIPTION")%>" class="tx"  readonly></td>-->
		<td align="left"><%=checkNull(myRet.getFieldValueString(i,"DESCRIPTION"))%></td> 

		<td align="right"><%=checkNull(myRet.getFieldValueString(i,"QUANTITY"))%></td>
		<td align="right"><%=checkNull(myRet.getFieldValueString(i,"PRICE_UNIT"))%></td>
		<td align="center"><%=checkNull(myRet.getFieldValueString(i,"UNIT"))%></td>
		<td align="right"><%=checkNull(myRet.getFieldValueString(i,"UNIT_PRICE"))%></td> 
		<td align="right"><%=checkNull(myRet.getFieldValueString(i,"TOT_VAL"))%></td> 
		<td align="center"><%=checkNull(myRet.getFieldValueString(i,"CURRENCY"))%></td> 
		
		<td align="center"><%=fd.getStringFromDate((Date)myRet.getFieldValue(i,"DELIV_DATE"),".",ezc.ezutil.FormatDate.DDMMYYYY)%></td>
		<!--<td align="center"><%=fd.getStringFromDate((Date)myRet.getFieldValue(i,"REL_DATE"),".",ezc.ezutil.FormatDate.DDMMYYYY)%></td>-->

		<td align="center"><%=checkNull(myRet.getFieldValueString(i,"PLANT"))%></td>
		<td align="center"><%=checkNull(myRet.getFieldValueString(i,"PUR_GRP"))%></td>
		<td align="left"><a href="#" data-toggle="tooltip" title="<%=itemText%>"><%=itemTextDisp%></a></td> 
		<td align="left"><a href="#" data-toggle="tooltip" title="<%=poText%>"><%=poTextDisp%></a></td> 		
		<td align="center"><%=checkNull(myRet.getFieldValueString(i,"REQ_BY"))%></td> 
		<td align="center"><%=checkNull(myRet.getFieldValueString(i,"CREATED_BY"))%></td>
		<!--<td align="center"><%=checkNull(myRet.getFieldValueString(i,"MRP_CONTR"))%></td>  -->
		<!--<td align="center"><%=checkNull(myRet.getFieldValueString(i,"FIXED_VEND"))%></td>-->
		<td align="center"><%=version%></td>
		<td align="center"><%=rfqStatus%></td>
		 
		</Tr>
<%
	}
%>
</tbody>
               </table>
            </div>
         </div>
         </div>
         </div>
         <!-- Your Page Content Here -->
<%/*
	if(showStr)
	{
%>
		<div class="callout callout-info">
			<p>RFQ Created For this PR</p>
		</div>
<%
	}
*/
%>
		<div class="row no-print">
		<div class="col-xs-12">
		<i class="fa fa-square" style="color:#efdbe7"></i>&nbsp;&nbsp;<%=rfq_Created_L%>&nbsp;&nbsp;	
		<i class="fa fa-square" style="color:#e4ff00"></i>&nbsp;&nbsp;<%=ser_PR_L%>	
<%
		if(Status.equals("R"))
		{
				
%>
		
		<button type="button" class="btn btn-primary pull-right" onclick="funBack()" style="margin-right: 5px;"><i class="fa fa-arrow-left"></i><%=go_Back_L%></button>
		<!--<button type="button" class="btn btn-primary pull-right" onclick="ClosePR()" style="margin-right: 5px;"><i class="fa fa-remove"></i> Close</button>-->
		<button type="button" class="btn btn-primary pull-right" onclick="vendorList()" style="margin-right: 5px;"><i class="fa fa-check"></i><%=get_Sources_L%></button>
		
<%
		}
		else  
		{
%>
			<button type="button" class="btn btn-primary pull-right" onclick="funBack()" style="margin-right: 5px;"><i class="fa fa-arrow-left"></i> Go Back</button>
<%
		}
%>
		</div>
		</div>   

<% 
}
%>
	
<input type=hidden name="backChk" value="PRS">	


<input type="hidden" name="Status" value="<%=Status%>">
<input type="hidden" name="matNo" value="">
<input type="hidden" name="selplant" value="">
<input type="hidden" name="fromDate" value="<%=fromDate%>">         
<input type="hidden" name="toDate" value="<%=toDate%>">
<input type="hidden" name="concatString">

<!--For Back Button selected list in previous page-->
<input type="hidden" name="purGrpFromBack" value="<%=purGrp%>">       
<!--End of For Back Button selected list in previous page-->

</form>
</section>
<!-- /.content -->
</div><!-- /.content-wrapper --> 
<div id="woModal" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog">
      <div class="modal-content">
         <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <iframe src="" width="100%" height="220" frameborder="0" allowtransparency="true"></iframe>
         </div>
      </div>
   </div>
</div>
<div id="woModal2" class="modal " tabindex="-1" role="dialog">
   <div class="modal-dialog modal-lg">
      <div class="modal-content" style="width: 100%;">
         <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <iframe src="" width="100%" height="200" frameborder="0" allowtransparency="true"></iframe>
         </div>
      </div>
   </div>
</div>
</body>
<%@ include file="../Misc/ezSubFooter.jsp"%>
<%@ include file="../Misc/ezFooter.jsp"%> 
<%@ include file="../Misc/ezDataTableScript.jsp"%>
<!--<script src="../../../../EzCommon/Library/jquery-ui-1.10.4/js/jquery-ui-1.10.4.custom.js"></script>-->
<link rel="stylesheet" type="text/css" href="../../Library/jquery/jquery-ui-1.12.1.custom/jquery-ui.css">
<link rel="stylesheet" href="../Misc/library/fancybox2/jquery.fancybox.css" type="text/css" media="screen" />
<script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.js"></script>
<script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.pack.js"></script>
	<Script src="../../Library/JavaScript/ezTrim.js"></Script>
	<Script>
		var tabHeadWidth = 90;
		var tabHeight="65%";
		if(screen.width==800) 
		{
			tabHeight="57%";
		}
		 
		function funBack()
		{
			 
			document.myForm.action="ezPrePRList.jsp?Status=R";	
			document.myForm.submit();
		}
		
		var chkVal = [];
		var valArr = [];
		function removeA(arr) {
		    var what, a = arguments, L = a.length, ax;
		    while (L > 1 && arr.length) {
			what = a[--L];
			while ((ax= arr.indexOf(what)) !== -1) {
			    arr.splice(ax, 1);
			}
		    }
		    return arr;
		}
		
		function onChgChk(x,ind)
		{              
			//console.log("oncheck::"+x);
			//console.log("oncheck::"+ind);
			//var chkField = document.myForm.purchReq[ind]
			//alert(x.value);
			if(x.checked)
			{
				chkVal.push(ind);
				valArr[ind]=x.value;
			}
			else
				removeA(chkVal,ind);
			//alert(valArr.length);
			//console.log(valArr);
		}
		
		function funLoad()
		{
			//alert("Hi Onload");
			var frmBack='<%=frmBack%>';
			if(frmBack=="Y")
			{
				var indexes='<%=chkdIndx%>';
				//alert("indexes=="+indexes);
				var indVal="";
				var indLen=0;
				if(indexes.lastIndexOf("##")!=-1)indLen=indexes.split("##").length;
				else indLen=1;
				//alert("indLen=="+indLen);
				if(indLen==1)
				{
					indVal=indexes;
					var chkValOnChange= eval("document.myForm.purchReq["+indVal+"]");
					//console.log("onload::"+indVal);
					//console.log("onload::"+chkValOnChange);
					onChgChk(chkValOnChange,indVal);
				}
				else
				{
					for(var i=0;i<indLen;i++)
					{
						indVal=indexes.split("##")[i];
						var chkValOnChange= eval("document.myForm.purchReq["+indVal+"]");
						//console.log("onload::"+indVal);
						//console.log("onload::"+chkValOnChange);
						onChgChk(chkValOnChange,indVal);
					}
				}
			}
		}
		
		function vendorList() 
		{
			
			//alert("Get Sources>>>");
			var chkObj 	= document.myForm.purchReq;
			
			var matArray = new Array();
			var chkValue="";
			//alert("chkVal.length=="+chkVal.length);
			
			if(chkVal.length == 0)
			{
				alert('<%=select_one_PR_JS_L%>');
				return;
			}
			
			for (e=0;e<chkVal.length;e++) 
			{
				try
				{
					var temChk = parseInt(chkVal[e]);
					chkValue+=valArr[temChk]+"##";
					//alert(chkValue);
					document.myForm.concatString.value=chkValue;
				}catch(e)
				{
					//alert(e);
				}
			}
			var puReqTot;
			var puReqTotChk;
			//alert("chkValue"+chkValue+"con"+document.myForm.concatString.value);
			var mainToken	= chkValue.split("##");
			var tokensLen	= mainToken.length-1;
			
		
			var material;
			var plant;
			var delDate;
			var qty	= 0;
			var uom;
			var matDesc;
			var prno;
			var itmno;
			var valtype;
			var docType;
			var accCat;
			var itemCat;
			var pckgNo;
			var currency;
			var matGrp;
			var createdBy;
			var relDate;
			var orderUnit;
			
			//alert("tokensLen"+tokensLen);
			if(!isNaN(tokensLen))
			{
			
				var childToken	= mainToken[0].split("$$");
				material	= childToken[0];
				plant		= childToken[1];
				qty		= childToken[3];
				delDate		= childToken[2];
				uom		= childToken[4];
				matDesc		= childToken[5];
				prno		= childToken[6];
				itmno		= childToken[7];
				valtype		= childToken[8];
				itmTx		= childToken[9];
				poTx		= childToken[10];
				vendFixed	= childToken[11];
				docType		= childToken[12];
				accCat		= childToken[13];
				itemCat		= childToken[14];
				pckgNo		= childToken[15];				
				currency	= childToken[16];
				matGrp		= childToken[17];
				createdBy	= childToken[18];
				relDate		= childToken[19];
				orderUnit	= childToken[20];
				a=delDate.split(".");
				var mm = parseInt(a[1],10)-1;
				var dlvrDate  = new Date(a[2],mm,a[0]);
				
				//alert("mainToken[0]"+mainToken[0]);
				//alert("material>>>"+material);
				if(material=="")
					material="NA";
				matArray[0]  = 	material;
				document.myForm.purchReq.value		= material+"$$"+plant+"$$"+delDate+"$$"+qty+"$$"+uom+"$$"+matDesc+"$$"+prno+"$$"+itmno+"$$"+valtype+"$$"+itmTx+"$$"+poTx+"$$"+vendFixed+"$$"+docType+"$$"+accCat+"$$"+itemCat+"$$"+pckgNo+"$$"+currency+"$$"+matGrp+"$$"+createdBy+"$$"+relDate+"$$"+orderUnit;
				puReqTot=material+"$$"+plant+"$$"+delDate+"$$"+qty+"$$"+uom+"$$"+matDesc+"$$"+prno+"$$"+itmno+"$$"+valtype+"$$"+itmTx+"$$"+poTx+"$$"+vendFixed+"$$"+docType+"$$"+accCat+"$$"+itemCat+"$$"+pckgNo+"$$"+currency+"$$"+matGrp+"$$"+createdBy+"$$"+relDate+"$$"+orderUnit;
				puReqTotChk=prno+"¥"+itmno+"¥"+material+"¥"+plant+"¥"+qty;
				
				for(j=1;j<tokensLen;j++)
				{
					//alert(mainToken[j]+"mainToken");
					var childToken	= mainToken[j].split("$$");
		
					var material1	= childToken[0];
					if(material1=="")
						material1="NA";
					var plant1	= childToken[1];
					var qty1	= childToken[3];
					var delDate1	= childToken[2];
					var uom1	= childToken[4];
					var matDesc1	= childToken[5];
					var prno1	= childToken[6];
					var itmno1	= childToken[7];
					var valtype1	= childToken[8];
					var itmTx1	= childToken[9];
					var poTx1	= childToken[10];
					var vendFixed1	= childToken[11];
					var docType1	= childToken[12];
					var accCat1	= childToken[13];
					var itemCat1	= childToken[14];
					var pckgNo1	= childToken[15];					
					var currency1	= childToken[16];					
					var matGrp1	= childToken[17];
					var createdBy1	= childToken[18];
					var relDate1	= childToken[19];
					var orderUnit1	= childToken[20];
					b=delDate1.split(".");
					var mm1 = parseInt(b[1],10)-1;
					var cmprDate  = new Date(b[2],mm1,b[0]);
					
					if((itemCat=="D" && itemCat1!="D") || (itemCat!="D" && itemCat1=="D"))
					{
						alert('<%=supply_ser_RFQ_JS_L%>');
						return;
					}
					
					/* if(!matArray.includes(material1))	
						matArray[j]     = material1;
					else
						qty = parseInt(qty)+parseInt(qty1);	*/				
					
					if(dlvrDate<cmprDate)
					{
						delDate = delDate1; 
					}
					//alert(delDate);
					
					if(funTrim(plant) != funTrim(plant1))
					{
						alert('<%=sel_Same_Plant_JS_L%>');
						return;
					}
					
			
					/*if(funTrim(material) == funTrim(material1))
					{
			
						if(funTrim(plant) == funTrim(plant1))
						{
							qty = parseInt(qty)+parseInt(qty1);
							prno = prno+"/"+prno1;
							itmno= itmno+"/"+itmno1;
							
						}
						else
						{
							alert("Please select material with same Plant to get Vendors");
							return;
						}
						
					}*/					
				
				document.myForm.purchReq.value = material1+"$$"+plant1+"$$"+delDate1+"$$"+qty1+"$$"+uom1+"$$"+matDesc1+"$$"+prno+"$$"+itmno1+"$$"+valtype1+"$$"+itmTx1+"$$"+poTx1+"$$"+vendFixed1+"$$"+docType1+"$$"+accCat1+"$$"+itemCat1+"$$"+pckgNo1+"$$"+currency1+"$$"+matGrp1+"$$"+createdBy1+"$$"+relDate1+"$$"+orderUnit1;
				puReqTot=puReqTot+"#RFQ#"+material1+"$$"+plant1+"$$"+delDate1+"$$"+qty1+"$$"+uom1+"$$"+matDesc1+"$$"+prno1+"$$"+itmno1+"$$"+valtype1+"$$"+itmTx1+"$$"+poTx1+"$$"+vendFixed1+"$$"+docType1+"$$"+accCat1+"$$"+itemCat1+"$$"+pckgNo1+"$$"+currency1+"$$"+matGrp1+"$$"+createdBy1+"$$"+relDate1+"$$"+orderUnit1;
				puReqTotChk=puReqTotChk+"__"+prno1+"¥"+itmno1+"¥"+material1+"¥"+plant1+"¥"+qty1;
				
				//alert("material1>>>"+material1);
				/*
				if(matArray.includes(material1))
				{
					qty = parseInt(qty)+parseInt(qty1);
					prno = prno+"/"+prno1;
					//itmno= itmno+"__"+itmno1;
					
					if(matArray.length == 1)
					{
						//puReqTot= material1+"$$"+plant1+"$$"+delDate1+"$$"+qty+"$$"+uom1+"$$"+matDesc1+"$$"+prno+"$$"+itmno1+"$$"+valtype1+"$$"+itmTx1+"$$"+poTx1+"$$"+vendFixed1+"$$"+docType1+"$$"+accCat1+"$$"+itemCat1+"$$"+pckgNo1+"$$"+currency1+"$$"+matGrp1+"$$"+createdBy1;
						//alert("material1"+material1);
					}
					else
					{
						//alert("puReqTot>>"+puReqTot);
						puReqTot=puReqTot+"#RFQ#"+material1+"$$"+plant1+"$$"+delDate1+"$$"+qty+"$$"+uom1+"$$"+matDesc1+"$$"+prno+"$$"+itmno1+"$$"+valtype1+"$$"+itmTx1+"$$"+poTx1+"$$"+vendFixed1+"$$"+docType1+"$$"+accCat1+"$$"+itemCat1+"$$"+pckgNo1+"$$"+currency1+"$$"+matGrp1+"$$"+createdBy1;
					}
				}	
				else
				{
					matArray[j]     = material1;
					puReqTot=puReqTot+"#RFQ#"+material1+"$$"+plant1+"$$"+delDate1+"$$"+qty1+"$$"+uom1+"$$"+matDesc1+"$$"+prno1+"$$"+itmno1+"$$"+valtype1+"$$"+itmTx1+"$$"+poTx1+"$$"+vendFixed1+"$$"+docType1+"$$"+accCat1+"$$"+itemCat1+"$$"+pckgNo1+"$$"+currency1+"$$"+matGrp1+"$$"+createdBy1;
				} */	
				
				
				}	
			}
			
			buttonsSpan	  = document.getElementById("EzButtonsSpan")
			buttonsMsgSpan	  = document.getElementById("EzButtonsMsgSpan")  
			if(buttonsSpan!=null)
			{
			     buttonsSpan.style.display		= "none"
			     buttonsMsgSpan.style.display	= "block"
		     	}
		     	
			document.myForm.puReqTot.value=puReqTot;
			document.myForm.purchaseHidden.value	= material+"$$"+plant+"$$"+delDate+"$$"+qty+"$$"+uom+"$$"+matDesc+"$$"+prno+"$$"+itmno+"$$"+valtype+"$$"+itmTx+"$$"+poTx+"$$"+vendFixed+"$$"+docType+"$$"+accCat+"$$"+itemCat+"$$"+pckgNo+"$$"+currency+"$$"+matGrp+"$$"+createdBy+"$$"+relDate;

			//alert("document.myForm.purchReq.value>>>>"+document.myForm.purchReq.value);
			//alert("document.myForm.purchaseHidden.value"+document.myForm.purchaseHidden.value);		     	
			//alert("document.myForm.puReqTot.value"+document.myForm.puReqTot.value);		     	
		     	
			//alert("puReqTotChk>>"+puReqTotChk); 
			puReqTotChk = puReqTotChk.replace("¥","#");
			/*
			$.ajax({
			    url: 'ezQCFCheck.jsp', 
			    data: { "puReqTotChk":puReqTotChk},
			    type: 'POST',
			    success: function(result) {
			      result=$.trim(result);  
			      if(result !='')
			      {
				if(confirm("QCF:"+result +" already generated against the seleccted PR(s)"))
				{
					document.myForm.qcfPrev.value=result;

					document.myForm.action	= "ezVendorViewList.jsp";
					document.myForm.submit();
				}

			      }
			      else
			      {
					document.myForm.action = "ezVendorViewList.jsp";
					document.myForm.submit();				
			      }			      
			    },
			    error: function()
			    {
			    	alert("error::");
			    }
			});*/
			document.myForm.action = "ezVendorViewList.jsp";
			document.myForm.submit();	
			
			
			

}
</Script>

<script type="text/javascript" class="init">
   $(document).ready( function () {
   
        funLoad();
      	$('[data-toggle=tooltip]').tooltip();
   
     
       //table.fnSort([[1,"desc"],[2,"asc"],[4,"desc"]])
       table.fnSort([[4,"desc"], [1,"desc"],[2,"asc"]])       ;

        var allPages = table.fnGetNodes()

       	
       	    $('#select').click(function () {
       	        if ($(this).hasClass('allChecked')) {
       	            $(allPages).find('input[type="checkbox"]').prop('checked', false);
       	        //    alert("false");
       	        } else {
       	        //alert("true");
       	            $(allPages).find('input[type="checkbox"]').prop('checked', true);
       	        }
       	        $(this).toggleClass('allChecked');
       	        
    });
   } );
   function openItemDet(req,item,mat,text,type)
   { 
   	var url="ezItemTextPopup.jsp?req="+req+"&item="+item+"&mat="+mat+"&text="+text+"&type="+type;      
   	/*$.fancybox.open({
   		href : url, 
   		type : 'iframe',
   		
   		width:'60%',
   		height:'38%',
   		autoSize : false,
   		closeBtn : false,
   		keys : {
   		    close  : true,
   		},			
   		helpers     : {  
   			overlay : {closeClick: false}  
   			}
   		});*/
		$('iframe').attr("src",url);
		

		$('#woModal').modal({show:true});
		$('.modal-dialog').draggable({
				    handle: ".modal-body"
  		});   		
   
   } 
	function openService(req,item,pckgNo)
	{ 
	var url="ezServicePopup.jsp?req="+req+"&item="+item+"&pckgNo="+pckgNo;       
		$('iframe').attr("src",url);
		$('#woModal2').modal("show");
		$('.modal-dialog').draggable({
				    handle: ".modal-body"
		});   		
	}       
   

   	
</script>


  <%!
       	private String checkNull(String str)
       	{
       		if("null".equals(str) ||str==null)
       		str="";
       		return str;
     	}
   %>
