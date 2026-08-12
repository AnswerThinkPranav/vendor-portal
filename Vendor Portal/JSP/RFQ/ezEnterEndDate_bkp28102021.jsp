<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>   
<%@ include file="../Misc/ezHeader.jsp"%> 
<%@include file="../../../Includes/JSPs/Rfq/iSelectFields.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iReadRFCTable.jsp"%>
<link rel="stylesheet" href="../../../../EzCommon/Library/plugins/timepicker/bootstrap-timepicker.min.css">
<%@ include file="../../../Includes/JSPs/Rfq/iListCollectiveRFQByMatWithoutBean.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iGetVendorDesc.jsp"%>      
<style>
.table>tbody>tr>td, .table>tbody>tr>th, .table>tfoot>tr>td, .table>tfoot>tr>th, .table>thead>tr>td, .table>thead>tr>th {

line-height: inherit !important;
}
th
{	
    color: white;
    background: #325786;
	
}
.zui-wrapper {
    position: relative;
}
.zui-scroller {

    overflow-x: scroll;
    overflow-y: visible;
    padding-bottom: 5px;
    
       width: auto;
   
}
.table .zui-sticky-col {
    border-left: solid 1px #DDEFEF;
    border-right: solid 1px #DDEFEF;
    left: 22px;
    position: absolute;
    top: auto;
    width: 120px;
}
.fullwidth{
	width: 100%;
	margin-left:0;
	margin-right:0;
	padding-left:0;
	padding-right:0;
	display: block;
	
}
</style>
<%!      
	public String checkNull(String str) 
	{ 
		String retStr = "";
		 
		if(str == null || "null".equals(str) || "".equals(str))  
			retStr = "";
		else
			retStr = str;    
			
		return retStr;	
	}
%>

<%
	
	ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate(); 
	
	String qtnEndDate	= request.getParameter("qtnEndDate");
	String rows		= request.getParameter("rows");
	String plant 		= request.getParameter("plant");
	//out.println("plant>>>>>>"+plant);
	String material 	= request.getParameter("material");
	if("NA".equals(material.trim()))
		material="";
	String uom1 		= request.getParameter("uom");
	String qty 		= request.getParameter("quantity");
	String Comments		= request.getParameter("commentText");
	String prno		= request.getParameter("reqNo");
	String itmNo		= request.getParameter("prItmNo");
	//String selectedVendors[]= request.getParameterValues("selChk");
	String allSelVendors	= request.getParameter("allSelVendors");
	String selectedVendors[]= allSelVendors.split("##");
	String purchReq		= request.getParameter("purchReq1");
	String comment		= request.getParameter("comment"); 
	String flag		= request.getParameter("flag"); 
	String qcfPrev		=request.getParameter("qcfPrev");
	ezc.ezcommon.EzLog4j.log("flag::::::::"+purchReq,"I");
	ezc.ezcommon.EzLog4j.log("qcfPrev::::::::"+qcfPrev,"I");
	
	int purLength  = purGrpObj.getRowCount();
	int pOrgLength = purOrgObj.getRowCount();
	int ccLength   = ccObj.getRowCount();
	int pmntLen   = pmntObj.getRowCount();
	int incoLen   = incoObj.getRowCount();	
	
	if("".equals(comment) || comment==null || "null".equals(comment)) comment="";
	
	
	if(qtnEndDate == null || "null".equals(qtnEndDate) || "".equals(qtnEndDate))
		qtnEndDate = "";
		
	if(rows == null || "null".equals(rows) || "".equals(rows))
		rows = "1";
		
	int vendorsCount = 0;
	int selectedPRsCnt = 0;
	
	if(selectedVendors!=null)
	{
		vendorsCount	= selectedVendors.length;	
	}
	
	ezc.ezcommon.EzLog4j.log("purchReq::::::::"+purchReq,"I");
	String selectedPRs[] = request.getParameterValues("purchReq");	
	
	if(selectedPRs!=null)
	{
		selectedPRsCnt	= selectedPRs.length;	
	} 
	ezc.ezcommon.EzLog4j.log("selectedVendors in preview::::::::"+selectedVendors[0],"I");
	out.println("selectedPRsCnt"+selectedPRsCnt);
	java.util.Hashtable  prHT = new java.util.Hashtable();
	java.util.Hashtable  prQtyHT = new java.util.Hashtable();
	java.util.Hashtable  prNumHT = new java.util.Hashtable();
	
	for(int i=0;i<selectedPRsCnt;i++)
	{
	
		ezc.ezcommon.EzLog4j.log("check2::::::::","I");
		//ezc.ezcommon.EzLog4j.log("check22::::::::"+selectedPRs[0],"I");
		
		ezc.ezbasicutil.EzStringTokenizer EzToken = new ezc.ezbasicutil.EzStringTokenizer(selectedPRs[i],"$$");
		java.util.Vector Tokens = EzToken.getTokens();

			
			String tempPr	= (String)Tokens.elementAt(6);
			String prNo	= tempPr.replace("$","");
			ezc.ezcommon.EzLog4j.log("check33::::::::","I");
			String prItem	= (String)Tokens.elementAt(7);
			ezc.ezcommon.EzLog4j.log("check4::::::::","I");
			String matNo	= (String)Tokens.elementAt(0);	
			if("NA".equals(matNo))
				matNo="";
				
			
			String plant1	= (String)Tokens.elementAt(1);	
			String qty1	= (String)Tokens.elementAt(3);	
			String uom	= (String)Tokens.elementAt(4);
			String desc	= (String)Tokens.elementAt(5);	
			
			String purGrp	= (String)Tokens.elementAt(8);
			String itmText	= checkNull((String)Tokens.elementAt(9));
			String poText	= checkNull((String)Tokens.elementAt(10));
			String prDocType	= checkNull((String)Tokens.elementAt(12));
			String delivDate= (String)Tokens.elementAt(2);
	    		
	    		String lastSubDate= (String)Tokens.elementAt(12);
	    		String accCat = "";
	    		try
	    		{
	    			accCat=(String)Tokens.elementAt(13);
	    		}
	    		catch(Exception e)
	    		{
	    			accCat= "";
	    		}	    		
	    		String itemCat= "";
	    		try
	    		{
	    			itemCat=(String)Tokens.elementAt(14);
	    		}
	    		catch(Exception e)
	    		{
	    			itemCat= "";
	    		}
			String pckgNo = "";
	    		try
	    		{
	    			pckgNo=(String)Tokens.elementAt(15);
	    		}
	    		catch(Exception e)
	    		{
	    			pckgNo= "";
	    		}	    		
	    			    		
	    		String valType="";
	    		String vendFixed="";
	    		String currency=(String)Tokens.elementAt(16);
	    		String matGrp=(String)Tokens.elementAt(17);
	    		String createdBy=(String)Tokens.elementAt(18);
	    		
	    		
	    		if(prHT.containsKey(matNo) && !"D".equals(itemCat))
	    		{
	    			double clubQty = Double.parseDouble(qty1)+ Double.parseDouble((String)prQtyHT.get(matNo));
	    			String clubPrs = prNo+"-"+prItem+"/"+(String)prNumHT.get(matNo);
	    			prQtyHT.put(matNo,clubQty+"");
	    			prNumHT.put(matNo,clubPrs);
	    			
	    			prHT.put(matNo, matNo+"$$"+plant1+"$$"+delivDate+"$$"+clubQty+"$$"+uom+"$$"+desc+"$$"+clubPrs+"$$"+prItem+"$$"+valType+"$$"+itmText+"$$"+poText+"$$"+vendFixed+"$$"+prDocType+"$$"+accCat+"$$"+itemCat+"$$"+pckgNo+"$$"+currency+"$$"+matGrp+"$$"+createdBy);
	    		}	
	    		else
			{	
				if("D".equals(itemCat) && "".equals(matNo) || "K".equals(accCat) && "".equals(matNo))
				{
					matNo = "SM"+i;
					prHT.put(matNo, matNo+"$$"+plant1+"$$"+delivDate+"$$"+qty1+"$$"+uom+"$$"+desc+"$$"+(prNo+"-"+prItem)+"$$"+prItem+"$$"+valType+"$$"+itmText+"$$"+poText+"$$"+vendFixed+"$$"+prDocType+"$$"+accCat+"$$"+itemCat+"$$"+pckgNo+"$$"+currency+"$$"+matGrp+"$$"+createdBy);
				}
				else
				{
					prQtyHT.put(matNo,qty1);
					prNumHT.put(matNo,prNo+"-"+prItem);
					prHT.put(matNo, matNo+"$$"+plant1+"$$"+delivDate+"$$"+qty1+"$$"+uom+"$$"+desc+"$$"+(prNo+"-"+prItem)+"$$"+prItem+"$$"+valType+"$$"+itmText+"$$"+poText+"$$"+vendFixed+"$$"+prDocType+"$$"+accCat+"$$"+itemCat+"$$"+pckgNo+"$$"+currency+"$$"+matGrp+"$$"+createdBy);
				}	
			}	
	 }	
	
	
	
%>

<%@ include file="../../../Includes/JSPs/Misc/iShowCal.jsp"%>
<%
	String reqDate = request.getParameter("reqDate");
	String matDescTemp = request.getParameter("matDesc");
	List<String> purOrgList = Arrays.asList(userPurOrgsStr.split("','"));
%>
<script>
function funOnload()
{
   document.myForm.qtnEndDate.value = "<%=qtnEndDate%>";	
}

function closeWin()
{
	var rfqItemObj  = document.myForm.rfqItem;
	var len = rfqItemObj.length;
	//alert("len>>>"+len);
	if(document.myForm.rfqType.value=="")
	{
		alert("Please Select RFQ Type")
		document.myForm.rfqType.focus()
		return;
	}	
	if(document.myForm.purGroup.value=="")
	{
		alert("Please Select Purchase Group")
		document.myForm.purGroup.focus()
		return;
	}
	if(document.myForm.qtnEndDate.value=="")
	{
		alert("Please Enter Quotation End Date")
		document.myForm.qtnEndDate.focus()
		return;
	}	
	var endDate 	= document.myForm.qtnEndDate.value;
	//alert("endDate>>"+endDate);
	
	a=endDate.split("/"); 	
	var enDate = new Date(a[2],(a[1]-1),a[0])
	//alert("enDate111>>"+enDate);
	var toDate  = new Date();
	//alert("toDate>>"+toDate);
	
	var endTime	= document.myForm.qtnEndTime.value;
	//alert("endTime>>"+endTime);
	var chkDate= endDate.concat(" ",endTime);
	//alert("chkDate>>"+chkDate);	
	var b=chkDate.split("/");
	var tempDt = b[1]+"/"+b[0]+"/"+b[2];
	var tempDt1 = new Date(tempDt)
	//alert("tempDt1>>>"+tempDt1)	
	
	

	if(tempDt1 <= toDate)
	{
		alert("Quotation End date must greater than Today's Date and Time");
		return;
	}
	if(isNaN(len))
	{
		var rfqItemNo = document.myForm.rfqItem.value;	
		var reqDate 	= eval("document.myForm.matDelDate"+rfqItemNo).value;
		b=reqDate.split("/");
		var reDate = new Date(b[2],(b[1]-1),b[0]);
	
		if(reDate < toDate)	
		{
			alert("Delivery date must greater than Today's date");
			return;
		}
		if(reDate <= enDate)	
		{
			alert("Quotation End date must be less than the Del.Date");
			return;
		}
		
		var itmText=eval("document.myForm.itmText"+0).value;
		if(itmText.length>2000)
		{
			alert("Please enter Item Text of 2000 characters only");
			return;
		}
		var poText=eval("document.myForm.poText"+0).value;
		if(itmText.length>2000)
		{
			alert("Please enter PO Text of 2000 characters only");
			return;
		}
					
	}
	else
	{
		//alert("len>>>>"+len);
		for(var i=0;i<len;i++)
		{
			var rfqItemNo = document.myForm.rfqItem[i].value;
			var reqDate   = eval("document.myForm.matDelDate"+rfqItemNo).value;
			
			b=reqDate.split("/");
			var reDate = new Date(b[2],(b[1]-1),b[0]);

			if(reDate < toDate)	
			{
				alert("Delivery date must greater than Today's date");
				return;
			}
			if(reDate <= enDate)	
			{
				alert("Quotation End date must be less than the Del.Date");
				return;
			}
			
			var itmText=eval("document.myForm.itmText"+i).value;
			if(itmText.length>2000)
			{
				alert("Please enter Item Text of 2000 characters only for line item "+((i+1)*10));
				return;
			}
			var poText=eval("document.myForm.poText"+i).value;
			if(itmText.length>2000)
			{
				alert("Please enter PO Text of 2000 characters only for line item "+((i+1)*10));
				return;
			}			

		}	

	}
	/*if (document.myForm.PaymentTerms.value=="")
	{
		alert("Please Select Payment terms from the List."); 
		document.myForm.PaymentTerms.focus()
		return false;
	}	
	if (document.myForm.IncoTerms.value=="")
	{
		alert("Please Select Inco Terms from the List.");
		document.myForm.IncoTerms.focus()
		return false;
	}	*/
	/*if(document.myForm.comment.value=="")
	{
		alert("Please Enter Comments");
		document.myForm.comment.focus()
		return;
	}*/	

	var comments = document.myForm.comment.value 
	var collNo   = document.myForm.collNo.value
	//alert("collNo*******"+collNo);
	var delivDate   = document.myForm.matDelDate0.value
	var matDesc	= document.myForm.matDesc.value
	fillEntryWindow(document.myForm.qtnEndDate.value+'##'+comments+'##'+collNo+'##'+delivDate+'##'+matDesc); 
	

}
function showAttach(str)
{
	var rows = document.querySelector('textarea').value.split("\n").length;
	rows = rows+1;
	document.myForm.rows.value=rows;
	
}
function funAttach()
{
	$('iframe').attr("src","ezAttachFileNew.jsp");   
	$('#woModal').modal({show:true});
	//attach=window.open("ezAttachFileNew.jsp","UserWindow1","width=450,height=350,left=350,top=120,resizable=yes,scrollbars=no,toolbar=no,menubar=no,status=no");
	//var filestring=document.myForm.attachs.value;
	//attach=window.open("ezAttachFile.jsp?filestring="+filestring,"UserWindow1","width=450,height=350,left=150,top=100,resizable=no,scrollbars=yes,toolbar=no,menubar=no");
}
function fillEntryWindow(entryWindow)
{
	//alert(entryWindow);
	var entryWindowValues = entryWindow.split('##');
	document.myForm.qtnEndDate.value=entryWindowValues[0];  
	document.myForm.commentText.value=entryWindowValues[1];
	document.myForm.collNo.value=entryWindowValues[2];
	//alert("collNO>>>>"+document.myForm.collNo.value);
	document.myForm.delivDate.value=entryWindowValues[3];
	document.myForm.matDesc.value=entryWindowValues[4];  
	if(confirm("Are you sure you want to create RFQ(s)?"))
	{	
		document.myForm.action="ezCreateRFQ.jsp"; 
		document.myForm.submit(); 
	}	
}
function  funDateShow()
{
	if(document.myForm.colRfqDt != null)
	{
		if(!(isNaN(document.myForm.colRfqDt.length)))
		{
			var selVal = document.myForm.collNo[document.myForm.collNo.selectedIndex].value;
			if(selVal!="")
			{	
				document.getElementById("imgId").style.visibility = "hidden";
				document.myForm.qtnEndDate.value = document.myForm.colRfqDt[parseInt(document.myForm.collNo.selectedIndex)-1].value;
			}
			else
			{
				document.getElementById("imgId").style.visibility = "visible";
				document.myForm.qtnEndDate.value = "";
			}
		}
		else
		{
			if(selVal!="")
			{	
				document.getElementById("imgId").style.visibility = "hidden";
				document.myForm.qtnEndDate.value = document.myForm.colRfqDt.value;
			}
			else
			{
				document.getElementById("imgId").style.visibility = "visible";
				document.myForm.qtnEndDate.value = "";
			}
		}
	}	
}
function winClose()
{
	window.returnValue = "Cancel";
	window.close();

}
function funBack()
{
	document.myForm.action="ezVendorViewList.jsp";
	document.myForm.submit(); 
}
function funBack1()
{
	history.go(-1);
}
</script>
</head>
<body onLoad="funOnload()">
<form name="myForm" method="post" >
<input type="hidden" name="flag" value="<%=flag%>">
<input type="hidden" name="qcfPrev" value="<%=qcfPrev%>">
<%
	int retObjCnt = 0;
	if(myRet!=null)
		retObjCnt = myRet.getRowCount(); 
		
%>

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
<!-- Content Header (Page header) -->
<section class="content-header">
   <h1>
      Enter RFQ Details
   </h1>
</section>
<!-- Main content -->  
<section class="invoice">
<form name="myForm" method="post">
<div id="woModal" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog">
      <div class="modal-content">
         <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <iframe src="" width="100%" height="200" frameborder="0" allowtransparency="true"></iframe>
         </div>
      </div>
   </div>
</div>
<div id="woModal1" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog modal-lg">
      <div class="modal-content">
         <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <iframe src="" width="100%" height="200" frameborder="0" allowtransparency="true"></iframe>
         </div>
      </div>
   </div>
</div>	      

<%
			for(int i=0;i<retObjCnt;i++)
			{
				String valDate = "";
				java.util.Date valDateObj = (java.util.Date)myRet.getFieldValue(i,"VALID_UPTO");
				if(valDate!=null)
				     valDate = fd.getStringFromDate(valDateObj,".",ezc.ezutil.FormatDate.DDMMYYYY);
				     
%>			
				<input type="hidden" name="colRfqDt" value='<%=valDate%>'>
<%
			}
	String selPurGrp = request.getParameter("purGrp");
%>
	<input type="hidden" name="reqFrom" value="InviteGrp">
	<input type="hidden" name="rows" value="">
        <div class="row">
 	<div class="col-md-12 col-xs-12">
 	<div class="box box-primary">
 	<div class="box-body">
 	<table class="table table-bordered" >
	<tr>
		<Th align="left" >RFQ Type </Th>
		<Td colspan='2'>
			<select name="rfqType" id="rfqType" class="form-control" style="width:90% !important" > 
				<option value="">Select Type</option>
				<option value="DOM" selected>Domestic</option>	
				<option value="IMP">Import</option>
				<!--<option value="SEZ">SEZ</option>-->
				
			</select>	
		</Td>	
		<Th align="left" >Purchase Group </Th>
		<Td colspan='2'>
			
			<select name="purGroup" id="purGroup" class="form-control select2" style="width:100% !important">
			<option value="">Select Purchase Group</option>
			
			<!--<input class="form-control  input-sm" type="text" name="purGroup" id="purGroup" value="<%=(String)request.getParameter("purGrp")%>" readonly>-->			
<%
			//out.println("::::gv_PurGrpVect::::::"+gv_PurGrpVect);
			String proj="PROJECTS";
			//out.println("<option value="+proj+">"+proj+"->"+proj+"</option>");	
			for(int j=0;j<purLength;j++)
			{							    
				String purGrpFlg= "";
				if(selPurGrp.equals(purGrpObj.getFieldValueString(j,"VALUE1")))
					purGrpFlg = "selected";
				//out.println("purGrpObj>>"+purGrpObj.getFieldValueString(j,"EMKV_KEY").trim());
				//if(gv_PurGrpVect.contains(purGrpObj.getFieldValueString(j,"EMKV_KEY").trim()))
				
				//if(purGrpHT.containsKey(purGrpObj.getFieldValueString(j,"EMKV_KEY").trim()))
				{
					out.println("<option "+purGrpFlg+" value="+purGrpObj.getFieldValueString(j,"VALUE1").trim()+">"+purGrpObj.getFieldValueString(j,"VALUE1").trim()+"->"+purGrpObj.getFieldValueString(j,"VALUE2")+"</option>");
				}
				//else
					//continue;
				
			}
%>		
			</select>
			
 		</Td>
<%
		//TO Fetch Purchase Org  and Company Code  based on Plant
		String logonSite = (String)session.getValue("SITE");
		String [] outputFeilds = null;
		String [] queryValues = null;
		
		queryValues =new String[]{"WERKS EQ '"+plant+"'"}; 
		outputFeilds =new String[]{"EKORG"};
		
		ReturnObjFromRetrieve retPOrg = readRFCTable(logonSite,"T024W",outputFeilds,queryValues);
		String selPOrg = retPOrg.getFieldValueString(0,"EKORG");
		ezc.ezcommon.EzLog4j.log("::selPOrg:::"+selPOrg,"I");		
		
		queryValues =new String[]{"BWKEY EQ '"+plant+"'"}; 		
		outputFeilds =new String[]{"BUKRS"};
		
		ReturnObjFromRetrieve retCC = readRFCTable(logonSite,"T001K",outputFeilds,queryValues);
		String selCC = retCC.getFieldValueString(0,"BUKRS");
		ezc.ezcommon.EzLog4j.log("::selCC:::"+selCC,"I");	
%> 		
		
		
		<Th align="left" >Purchase Org </Th>
			
		<Td colspan='2'>
			
			<select name="purOrg" id="purOrg" class="form-control" style="width:90% !important" >  
<%
				for(int j=0;j<pOrgLength;j++)
				{
					String purOrgFlg= "selected";
					if(selPOrg.equals(purOrgObj.getFieldValueString(j,"EMKV_KEY")))
						out.println("<option "+purOrgFlg+" value="+purOrgObj.getFieldValueString(j,"EMKV_KEY").trim()+">"+purOrgObj.getFieldValueString(j,"EMKV_KEY").trim()+"->"+purOrgObj.getFieldValueString(j,"EMKV_VALUE")+"</option>");
					//else	
						//out.println("<option value="+purOrgObj.getFieldValueString(j,"EMKV_KEY").trim()+">"+purOrgObj.getFieldValueString(j,"EMKV_KEY").trim()+"->"+purOrgObj.getFieldValueString(j,"EMKV_VALUE")+"</option>");
				}
%>				
			</select>
		</Td>
		</tr>
		<tr>
		<Th align="left" >Company Code </Th>
		<Td colspan='4'>
			
			<select name="compCode" id="compCode" class="form-control" style="width:100% !important" >  
<%
				for(int j=0;j<ccLength;j++)
				{
					String ccFlg= "selected";
					if(selCC.equals(ccObj.getFieldValueString(j,"EMKV_KEY")))
						out.println("<option "+ccFlg+" value="+ccObj.getFieldValueString(j,"EMKV_KEY").trim()+">"+ccObj.getFieldValueString(j,"EMKV_KEY").trim()+"->"+ccObj.getFieldValueString(j,"EMKV_VALUE")+"</option>");
					//else	
						//out.println("<option  value="+ccObj.getFieldValueString(j,"EMKV_KEY").trim()+">"+ccObj.getFieldValueString(j,"EMKV_KEY").trim()+"->"+ccObj.getFieldValueString(j,"EMKV_VALUE")+"</option>");
				}
%>					

			</select>
			
		</Td>
	
	

 		<input type="hidden" name="collNo" class="form-control"/>
     		<Th align="left" >Quotation End Date </Th>
 		<Td colspan='4'>
 			<div class="input-group">
 				  <input class="form-control input-sm" type="text" name="qtnEndDate" id="qtnEndDate" value=""  readonly="">
 				  <label for="qtnEndDate" class="input-group-addon btn"><span class="glyphicon glyphicon-calendar"></span></label>  
 			 </div>
 		</Td>
 		<input type="hidden" name="qtnEndTime"  value="23:59"> 
 		<!--<Td colspan='2'>
 			
 			 <div class="bootstrap-timepicker">
						 <div class="form-group">	
						    <div class="input-group">
						     <input type="text" name="qtnEndTime" class="form-control timepicker" value="23:59"> 
						     <div class="input-group-addon">
						       <i class="fa fa-clock-o"></i>
						     </div>
						   </div>
						   
						 </div>
						
              		 </div>
                  </Td> -->
                      		 

	</tr>
	<tr>
	<!--<Th align="left" colspan='1'>LD Clause</Th>
	<Td colspan='7'><input class="form-control input-sm" type="text" name="ldClause" id="ldClause" value=""></Td>
	</tr> -->
<%
	if(!"null".equals(qcfPrev) && qcfPrev!=null && !"".equals(qcfPrev) && qcfPrev!="") 
	{
%>
	<tr>
	<Th align="left" colspan='3'>QCF No</Th>
	<Td colspan='5'><%=qcfPrev%></Td>
	</tr>
<%
	}
%>	
	
	<!--<tr>
	<Th align="left" colspan='2'>Payment Terms</Th>
	<Td colspan='5'>
			<select name=PaymentTerms class="form-control select2" style="width:100% !important">
			<option value="">Select Payment Terms</option>
<%
			/*for(int j=0;j<pmntLen;j++)
			{
				out.println("<option value="+pmntObj.getFieldValueString(j,"EMKV_KEY").trim()+">"+pmntObj.getFieldValueString(j,"EMKV_KEY").trim()+"->"+pmntObj.getFieldValueString(j,"EMKV_VALUE")+"</option>");
			}*/
%>					

 	 		</select>
			
	</td>
	</tr>
	<tr>
	<Th align="left" colspan='2'>Inco Terms</Th>
	<Td colspan='6'>
			<select name=IncoTerms class="form-control select2" style="width:100% !important">
			<option value="">Select Inco Terms</option>
<%
			/*for(int j=0;j<incoLen;j++)
			{
				out.println("<option value="+incoObj.getFieldValueString(j,"EMKV_KEY").trim()+">"+incoObj.getFieldValueString(j,"EMKV_KEY").trim()+"->"+incoObj.getFieldValueString(j,"EMKV_VALUE")+"</option>");
			}*/
%>					

 	 		</select>
			
	</td>
	</tr>	-->
	
  </Table>
  
   <input type="hidden" name="commentText" value="">
    <input type="hidden" name="delivDate" value="">
     <input type="hidden" name="matDesc" value="<%=matDescTemp%>"> 
   
 </div></div></div></div>
	  <h4>
		    Vendors
	  </h4>
        	<div class="row">
		<div class="col-md-12 col-xs-12">
		<div class="box box-primary">
		<div class="box-body">
		<table class="table table-bordered" id="example">  
	    	
    	<tr>
    		<Th width="50%" align="left"> Vendor</Th>
		<Th  width="50%" align="left"> Vendor Name</Th>
	</tr>
	
<%
	for(int i=0;i<vendorsCount;i++)
	{
		ezc.ezbasicutil.EzStringTokenizer EzToken = new ezc.ezbasicutil.EzStringTokenizer(selectedVendors[i],"#");
		java.util.Vector Tokens = EzToken.getTokens();
		
		//out.println("selectedVendors:::"+selectedVendors[i]);
		
		String vendorStr = (String)Tokens.elementAt(1);	 
		//String vName = (String)Tokens.elementAt(2);	
		
		String vendName = (String)Tokens.elementAt(4);//(String)venodorsHT.get(vendorStr); 
		if(vendName==null || "null".equals(vendName) || "".equals(vendName))
			vendName = "Not Synchronized";
%>
		<tr>
			<Td align="center"> <%=vendorStr%> </td>
			<Td align="center"> <%=vendName%> </td>

		</tr>
		<input type="hidden" name="selChk" value='<%=selectedVendors[i]%>'>
<%
	}
%>
		</table>
		</div>
		</div>
		</div>
		</div>
	 <h4>
		 Items
	 </h4>	
	 <div class="row">
			<div class="col-md-12 col-xs-12">
			<div class="box box-primary">
			<div class="box-body">
			<div class="zui-wrapper">
			<div class="zui-scroller">			
		
		<table class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
		    	
	    	<tr>
			<Th align="left"> Item</Th>
			<Th align="left"> Material </Th>
	    		<Th align="left"> Description</Th>
	    		<Th align="left"> Quantity</Th>
	    		<th>Per</th>
	    		<Th align="left"> UOM</Th>
	    		<Th align="left"> Plant </Th>
	    		<Th align="left"> Deliv. Date </Th>
	    		<Th align="left"> Remarks</Th>
	    		<!--<Th align="left"> Specification</Th>-->
	    		<Th align="left"> Warranty</Th>
			<Th align="center">Item Text</th>
	    		<Th align="center">PO Text</th>	    		
	    		<Th align="left"> PR No</Th>
	    	</tr>	
<%
	//ezc.ezcommon.EzLog4j.log("check1::::::::"+selectedPRs[0],"I");
	ezc.ezcommon.EzLog4j.log("prHT::::::::"+prHT,"I");
	
	String itmTextDisp="",poTextDisp="";
	
	//for(int i=0;i<selectedPRsCnt;i++)
	Enumeration prKeys = prHT.keys();
	int i=0;
	while(prKeys.hasMoreElements())
	{
		
		String key = (String) prKeys.nextElement();
		
		//ezc.ezcommon.EzLog4j.log("prKeys::::::::"+key,"I");
		ezc.ezbasicutil.EzStringTokenizer EzToken = new ezc.ezbasicutil.EzStringTokenizer((String)prHT.get(key),"$$");
		java.util.Vector Tokens = EzToken.getTokens();

			ezc.ezcommon.EzLog4j.log("check3::::::::","I");
			String tempPr	= (String)Tokens.elementAt(6);
			String prNo	= tempPr.replace("$","");
			ezc.ezcommon.EzLog4j.log("check33::::::::","I");
			String prItem	= (String)Tokens.elementAt(7);
			ezc.ezcommon.EzLog4j.log("check4::::::::","I");
			String matNo	= (String)Tokens.elementAt(0);	
			if("NA".equals(matNo)|| matNo.startsWith("SM"))
				matNo="";
			String plant1	= (String)Tokens.elementAt(1);	
			String qty1	= (String)Tokens.elementAt(3);	
			String uom	= (String)Tokens.elementAt(4);
			String desc	= (String)Tokens.elementAt(5);	
			//desc=desc.replace("\"","");
			String purGrp	= (String)Tokens.elementAt(8);
			String itmText	= checkNull((String)Tokens.elementAt(9));
			String poText	= checkNull((String)Tokens.elementAt(10));
			String prDocType= checkNull((String)Tokens.elementAt(12));
			String delivDate= (String)Tokens.elementAt(2);
	    		delivDate=delivDate.replace('.','/');
	    		
	    		String accCat = "";
	    		try
	    		{
	    			accCat=(String)Tokens.elementAt(13);
	    		}
	    		catch(Exception e)
	    		{
	    			accCat= "";
	    		}	    		
	    		String itemCat= "";
	    		try
	    		{
	    			itemCat=(String)Tokens.elementAt(14);
	    		}
	    		catch(Exception e)
	    		{
	    			itemCat= "";
	    		}
	    		if("D".equals(itemCat))
				matNo="";
	    		String pckgNo = "";
	    		try
	    		{
	    			pckgNo=(String)Tokens.elementAt(15);
	    		}
	    		catch(Exception e)
	    		{
	    			pckgNo= "";
	    		}	    		
	    		ezc.ezcommon.EzLog4j.log("prNo::::::::"+prNo,"I");
	    		ezc.ezcommon.EzLog4j.log("prItem::::::::"+prItem,"I");
	    		ezc.ezcommon.EzLog4j.log("itemCat::::::::"+itemCat,"I");
	    		ezc.ezcommon.EzLog4j.log("pckgNo::::::::"+pckgNo,"I");	    		
	    		try
	    		{
	    			matNo=Long.parseLong(matNo)+"";
	    		}
	    		catch(Exception e)
	    		{
	    			matNo=matNo;
	    		}
	    		
			if(itmText.length()>40)
				itmTextDisp= itmText.substring(0,40)+"...";
			else
				itmTextDisp= itmText;	    		
	    		
			if(poText.length()>40)
				poTextDisp= poText.substring(0,40)+"...";
			else
				poTextDisp= poText;
				
			if("D".equals(itemCat)) 
			{
				matNo="";
					
%>
			<tr style="background-color:#e4ff00">
<%
			}else{
%>			
	    		<tr>
<%
			}
%>	 
			<Td align="center"> <%=((i+1)*10)%></td>
			<!--<Td align="center"> <%=Long.parseLong(prItem)%></td>-->
			<td align="center"> <%=checkNull(matNo)%></td>
			<td align="left"> <%=desc%></td>


			
			
			<Td align="center"> <%=qty1%></td>
			<Td align="center"> <%=uom%></td>
			<td align="center">1<input type="hidden" name="rfqperQty<%=i%>" value="1"></td>
			<Td align="center"><%=plant1%></td>
			<input type=hidden name="rfqItem" value="<%=i%>">	
			<Td align="center"> 
			<input type="hidden" name="refDelDate<%=i%>" id="refDelDate<%=i%>" value="<%=delivDate%>">
			
			<div class="input-group">
				  <input class="form-control input-sm datePickObj" type="text" name="matDelDate<%=i%>" id="matDelDate<%=i%>"  value="<%=delivDate%>" style="width:120px;" readonly="">
				  <label for="matDelDate<%=i%>" class="input-group-addon btn"><span class="glyphicon glyphicon-calendar"></span></label>  
 			 </div>
			</td>
			<td><input type="text" name="remarks<%=i%>"  style="width:120px;" size=9 class="form-control" value='' ></td>
			<!--<td width = "10%">
				<table id="uploadTable<%=((i+1)*10)%>" class="table  table-bordered dt-responsive nowrap" >	
				</table>
				<button type="button"  value="<%=((i+1)*10)%>" class="btn btn-primary uploadDialogBtn" ><i class="fa fa-upload"></i></button>
			</td> -->			
			<td><input type="text" name="warranty<%=i%>"  style="width:120px;" size=9 class="form-control" value='' ></td>
<%
			if("D".equals(itemCat))
			{
%>			
			<td><input type="text" name="itmText<%=i%>" id="itmText<%=i%>" style="width:120px;" size=9 class="form-control" value='<%=itmText%>' ></td>
			<td><input type="text" name="poText<%=i%>" id="poText<%=i%>" style="width:120px;" size=9 class="form-control" value='<%=poText%>' ></td>
<%
			}
			else
			{
%>
			<td align="left"><input type="text" name="itmText<%=i%>" id="itmText<%=i%>" style="width:120px;" size=9 class="form-control" data-toggle="tooltip" title="<%=itmText%>" value="<%=itmText%>" ></td> 
			<td align="left"><input type="text" name="poText<%=i%>" id="poText<%=i%>"  style="width:120px;" size=9 class="form-control" data-toggle="tooltip" title="<%=poText%>"  value="<%=poText%>"></td>
<%			
			}
%>			
			
			
<%
			if("D".equals(itemCat)) 
			{
%>			
				
				<td><a href="javascript:openService('<%=prNo%>','<%=Long.parseLong(prItem)%>','<%=pckgNo%>')"> <%=prNo%></a></td>  
<%				
			}
			else
			{
%>
				<td align="center"> <%=prNo%></td>
<%
			}
%>			
			
			</tr>
<%
		i++;
	}
%>
			</table>
<%
	for(int h=0;h<selectedPRsCnt;h++)
	{
%>
	<input type="hidden" name="prDetails" value="<%=selectedPRs[h]%>">
<%
	}
%>	
			</div>
			</div>
			</div>
			</div>
			</div>
			</div>
	<h4>
		 Comments
	</h4>	
	<div class="row">
	<div class="col-md-12 col-xs-12">
	<div class="box box-primary">
	<div class="box-body">
		<table class="table table-bordered">
			<td colspan=3><textarea class="form-control" name="comment" placeholder="Enter Comments" rows="2" ><%=comment%></textarea></td>
		</table>
	</div>
	</div>
	</div>
	</div>		
	<h4>
		 Attachment(s)
	</h4>	
	<div class="row">
		<div class="col-md-12 col-xs-12">
			   <!-- general form elements -->
			      <div class="box box-default">
				 <div class="box-body table-responsive no-padding">
				    <div class="box-body">
				       <table id="uploadTableH" class="table  table-bordered dt-responsive nowrap" >	
					<tr>
						<th>File Name</th>
						<th></th>
					</tr>
					<tr id="noDataStatUpload">
						<td>No files attached</td>
					</tr>						
				</table>

				</div>
			      </div>
			    </div>
			    <!-- Your Page Content Here -->
			  </div>
		</div><!--row-->
	 <div class="row">
	 <div class="col-xs-12" align="center">
	 	<button type="button" class="btn btn-primary" onclick="funBack1()" ><i class="fa fa-backward"></i>&nbsp;Back</button>
	 	<button type="button"  value="H" class="btn btn-primary uploadDialogBtn" ><i class="fa fa-upload"></i>&nbsp;Upload Attachments</button>
	 	<button type="button" class="btn btn-primary" onclick="closeWin()" ><i class="fa fa-check"></i>&nbsp;Create RFQ</button>
 	 </div>
 	 </div>
 	 
 	 </section><!-- /.content -->
      	 </div><!-- /.content-wrapper --> 
	<input type="hidden" name="material"   value="<%=material%>">  
	<input type="hidden" name="reqDate"    value="<%=reqDate%>">
	<input type="hidden" name="quantity"   value="<%=qty%>">
	<input type="hidden" name="uom"        value="<%=uom1%>">
	<input type="hidden" name="plant"      value="<%=plant%>">
	<input type="hidden" name="reqNo"      value="<%=prno%>">
	<input type="hidden" name="prItmNo"    value="<%=itmNo%>">
	<input type="hidden" name="purchReq1"  value="<%=purchReq%>">
	<input type="hidden" name="soldTos"  value="<%=request.getParameter("soldTos")%>">
	
<%	
	/************* The following is for storing pr details in db as for knowing RFQ created against PR(s) or not ******************/
	/*
	String purchRequisition[]=request.getParameterValues("purchReq"); 
	int prLen = 0;
	if(purchRequisition!=null)
		prLen = purchRequisition.length;
	
	//out.println(purchRequisition[0]+"kk");
	for(int h=0;h<prLen;h++)
	{
%>		<input type=hidden name="purchReq" value="<%=purchRequisition[h]%>">
<%	}*/
%>
<%
	prKeys = prHT.keys();
	while(prKeys.hasMoreElements())
	{
		String key = (String) prKeys.nextElement();
		String rfqCheck = (String)prHT.get(key);
%>
		<input type=hidden name="purchReq" value="<%=rfqCheck%>">
<%
	}
%>
<input type="hidden" name="matNo" value="<%=request.getParameter("matNo")%>">
<input type="hidden" name="selplant" value="<%=request.getParameter("selplant")%>">
<input type="hidden" name="fromDate" value="<%=request.getParameter("fromDate")%>">
<input type="hidden" name="toDate" value="<%=request.getParameter("toDate")%>">
<input type="hidden" name="purchaseHidden"  value="<%=purchReq%>">

</form>
<div id="uploadMod" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog">
      <form id="uploadForm" action="../Inbox/ezUploadFileTemp.jsp" method="post" enctype="multipart/form-data">
      <div class="modal-content">
      <div class="modal-header">
	      <button type="button" class="close" data-dismiss="modal" aria-label="Close">
		<span aria-hidden="true">×</span></button>
	      <h4 class="modal-title">Attachments</h4>
	</div>
	 <div class="modal-body">	    
	         <fieldset>
			<input type="hidden" id="upDocType" name="upDocType" value="">
			<input type="hidden" id="upDocId" name="upDocId" value="">
			<input type="hidden" id="upItemNo" name="upItemNo" value="">
			<input type="file" id="file" name="file"/>
				<!--<input type="submit" id="uploadbutton" value="upload" />-->
			<div id="loadingInd" style="display:none;margin-left: 25%;">
				<i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i>
				<span class="sr-only">Loading...</span>
			</div>
	         </fieldset>
   		
	 </div>
	 <div class="modal-footer">
	 	<button type="submit" id="uploadbutton" class="btn btn-primary">Upload</button>
	 </div>
      </div>
     </form>
   </div>  
</div> 	 
 
</Body>
</Html>
<%@ include file="../Misc/ezFooter.jsp"%>
<script src="../../../../EzCommon/Library/plugins/timepicker/bootstrap-timepicker.min.js"></script>
<link rel="stylesheet" type="text/css" href="../../Library/jquery/jquery-ui-1.12.1.custom/jquery-ui.css">
<link rel="stylesheet" href="../Misc/library/fancybox2/jquery.fancybox.css" type="text/css" media="screen" />
<script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.js"></script>
<script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.pack.js"></script>
<script src="../../../../EzCommon/Library/jquery.form.js"></script> 
 <script>
		window.closeModal = function(){
		    $('#woModal').modal('hide');
		};
		$('#woModal').on('shown.bs.modal', function () {
		    $(this).find('.modal-dialog').addClass('modal-lg');
});
</script>
 
<script>
   $(document).ready(function() {
   
   	$('[data-toggle=tooltip]').tooltip();
       //window.history.forward(-1); 
       $(".datePickObj").datepicker({ 
       	format: 'dd/mm/yyyy', 
       });
    
     $("#qtnEndDate").datepicker({ 
           	format: 'dd/mm/yyyy', 
     }).on('changeDate', function(){
           	var qtDate=document.myForm.qtnEndDate.value;
		var count='<%=selectedPRsCnt%>';
		//alert("count"+count);
		b=qtDate.split("/");
		var reDate = new Date(b[2],(b[1]-1),b[0]);

		reDate.setDate(reDate.getDate() + 15);
		var dayDate=reDate.getDate();
		if (dayDate <10)dayDate = '0' + dayDate;
		var dayMon=reDate.getMonth()+1;
		if (dayMon <10)dayMon = '0' + dayMon;
		var finalDate = dayDate+'/'+ dayMon +'/'+reDate.getFullYear();

		//alert("qt"+finalDate);
		for(var k=0;k<count;k++)
		{
			eval("document.myForm.matDelDate"+k).value=finalDate
			       
		}
     });
	    $('.timepicker').timepicker({
	    	 defaultTime: 'value',
	         showInputs: false,
	         showMeridian:false
    		});
    	$('.timepicker').timepicker({
	    defaultTime: 'value',
	    minuteStep: 1,
	    disableFocus: true,
	    template: 'dropdown',
	    showMeridian:false
	});
	
   });
</script>

<script>
$( function() {

$(".sidebar-toggle").trigger("click");
});

 function downloadFile(upItemNo,fileName)
 {
  	var upDocId 	= $('#upDocId').val();
  	var upDocType 	= $('#upDocType').val();
  	window.open("../Inbox/ezFileDownloadEnter.jsp?upDocId="+upDocId+"&upDocType="+upDocType+"&upItemNo="+upItemNo+"&fileName="+fileName);
 }
 function valUploadForm()
 {
 	var upItemNo = $('#upItemNo').val();
 	var fileName = $('#file').val().replace(/C:\\fakepath\\/i, '');
 	var isValid = true;
 	if(fileName == "")
	{
		alert("Please upload file");
		isValid = false;
		return false;
	}
 	$('input[name="fileItem'+upItemNo+'"]').each(function(){
	  if($(this).val() == fileName)
	  {
	  	alert("File already uploaded");
	  	isValid = false;
		return false;
	  }	  
	});
	if(isValid)
	{
		$('#uploadbutton').hide(); 	
       		$('#loadingInd').show();
	}
	return isValid;
 }
 function deleteFile(thisObj,upItemNo,fileName)
 {
 	var upDocId 	= $('#upDocId').val();
 	var upDocType 	= $('#upDocType').val();
 	$.ajax({
	    url: '../Inbox/ezDeleteFileTemp.jsp',
	    data: { upDocId: upDocId, upDocType : upDocType,upItemNo:upItemNo,fileName:fileName},
	    dataType: "json",
	    type: 'POST',
	    success: function(result) {
	      result=$.trim(result);  
	      if(result === 'true')
	      {
	      	$(thisObj).closest("tr").remove();	
	      }
	    }
	});
 }
   $( function() {
     $( ".uploadDialogBtn" ).button().on( "click", function() {
        $("#upItemNo").val($(this).val());
        $("#file").val("");
       $('#uploadMod').modal('show');
       	return false;
     });
     $('#uploadForm').ajaxForm({
     	  beforeSubmit: valUploadForm,	
	  success: function(msg) {
	      $('#uploadbutton').show(); 	
       	      $('#loadingInd').hide();
	      msg=$.trim(msg);
	      //alert(msg);
	      if(msg.split("##")[0] === 'true')
	      {
	      	  $('#noDataStatUpload').hide();
	      	  var upItemNo = $('#upItemNo').val();
	      	  var fileNameTemp = msg.split("##")[1];
	      	   $('#uploadTable'+upItemNo).append('<tr><td align="left" width="95%"><input type="hidden" name="fileItem" value="'+fileNameTemp+'"><a href="javascript:downloadFile(\''+upItemNo+'\',\''+fileNameTemp+'\')">'+fileNameTemp+'</a></td><td width="5%"><span onclick="javascript:deleteFile(this,\''+upItemNo+'\',\''+fileNameTemp+'\')" class="fa fa-trash fa-lg" style="margin-left: 25%;"></span></td></tr>')
	      }
	      //alert("File has been uploaded successfully");
	      $('#uploadMod').modal('hide');
	  },
	  error: function(msg) {
	     $('#uploadbutton').show(); 	
       	     $('#loadingInd').hide();	
	     alert("Couldn't upload file");
	  }
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
		$('#woModal1').modal({show:true});
		$('.modal-dialog').draggable({
			   handle: ".modal-body"
	});   		
	}       
      
     
      
     
     /* function funCalDelDt()
      {
    	  	//alert("DEl>>>");
    	  	var qtDate=document.myForm.qtnEndDate.value;
    	  	var count='<%=selectedPRsCnt%>';
    	  	//alert("count"+count);
    	  	b=qtDate.split("/");
    	  	var reDate = new Date(b[2],(b[1]-1),b[0]);
    	  	
		reDate.setDate(reDate.getDate() + 7);
		var dayDate=reDate.getDate();
		if (dayDate <10)dayDate = '0' + dayDate;
		var dayMon=reDate.getMonth()+1;
		if (dayMon <10)dayMon = '0' + dayMon;
		var finalDate = dayDate+'/'+ dayMon +'/'+reDate.getFullYear();
    	  	
      		//alert("qt"+finalDate);
      		for(var k=0;k<count;k++)
      		{
      		eval("document.myForm.matDelDate"+k).value=finalDate
      		
      		}
      
      
      }*/
      
</script>
	<script type="text/javascript"> 
        function preventBack() { 
            window.history.forward();  
        } 
          
        setTimeout("preventBack()", 0); 
          
        window.onunload = function () { null }; 
</script> 	




