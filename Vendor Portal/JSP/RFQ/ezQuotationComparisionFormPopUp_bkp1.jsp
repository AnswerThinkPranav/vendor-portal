<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@page import="java.util.*,ezc.ezparam.*"%>
<%@ include file="../Misc/ezCommonMethods.jsp"%>
<%@ page import ="ezc.ezpreprocurement.params.*,ezc.ezparam.*,java.util.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<jsp:useBean id="rfqManager" class="ezc.ezpreprocurement.client.EzPreProcurementManager" />
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" />
<%@ page import="ezc.ezmisc.params.*,java.text.*" %>
<%
	String docId = checkNull(request.getParameter("docId"));

	Hashtable taxesHT =  new Hashtable();
	taxesHT.put("CGST","Central GST");
	taxesHT.put("SGST","State GST");
	taxesHT.put("IGST","Integrated GST");
	taxesHT.put("UGST","Union Territories GST");
	

	String usersList="";
	ArrayList userIdAL=new ArrayList();
	ReturnObjFromRetrieve UserNamesRetObj=null;
	int userNameCount=0;
	
	EzcParams 		ezparams	= new EzcParams(true);
	EziRFQHeaderTable	rfqHeaderTable	= new EziRFQHeaderTable();
	EziRFQDetailsTable  	rfqDetailsTable	= new EziRFQDetailsTable();
	EzRFQConditionsTable 	rfqCondTable 	= new EzRFQConditionsTable();
	
	EzoRFQHeaderParams    qcfDetailsRet 	= null;
	ReturnObjFromRetrieve rfqHeaderRet 	= null;
	ReturnObjFromRetrieve itemsRetObj 	= null;
	ReturnObjFromRetrieve rfqConditionsRet 	= null;
	
	int qcfDetailsRetCnt 	= 0;
	int rfqHeaderRetCnt 	= 0;
	int itemsRetObjCnt 	= 0;
	int rfqConditionsRetCnt = 0;
	
	EziRFQHeaderParams  inputParams = new EziRFQHeaderParams();

	inputParams.setCollectiveRFQNo(docId);
	inputParams.setStatus("Y");

	ezparams.setLocalStore("Y");
	ezparams.setObject(inputParams);
	Session.prepareParams(ezparams);
	
	try{
		qcfDetailsRet = (EzoRFQHeaderParams)rfqManager.ezGetRFQDetails(ezparams);
	}
	catch(Exception e){
		ezc.ezcommon.EzLog4j.log("Error while getting QCF Details :::::::::"+e,"E");
	}
	
	rfqHeaderRet 		= (ReturnObjFromRetrieve)qcfDetailsRet.getRFQHeader();
	itemsRetObj 		= (ReturnObjFromRetrieve)qcfDetailsRet.getRFQDetails();
	rfqConditionsRet 	= (ReturnObjFromRetrieve)qcfDetailsRet.getRFQConditions();
//out.println(itemsRetObj.toEzcString());
//out.println(rfqConditionsRet.toEzcString());

	if(rfqHeaderRet!=null)
		rfqHeaderRetCnt    = rfqHeaderRet.getRowCount();
	if(itemsRetObj!=null)
		itemsRetObjCnt   = itemsRetObj.getRowCount();
	if(rfqConditionsRet!=null)
		rfqConditionsRetCnt= rfqConditionsRet.getRowCount();

Hashtable vendorsHT =  new Hashtable();

for(int i=0;i<rfqHeaderRetCnt;i++)
{
	String soldToDB = checkNull(rfqHeaderRet.getFieldValueString(i,"ERH_SOLD_TO"));
	String rfqNo 	= checkNull(rfqHeaderRet.getFieldValueString(i,"ERH_RFQ_NO"));
	/*try{
		soldToDB = Integer.parseInt(soldToDB)+""
	}catch(Exception e){}*/
	String vendorStr="";
		try{
		vendorStr=Integer.parseInt(soldToDB)+"";
		}catch(Exception e){vendorStr= rfqHeaderRet.getFieldValueString(i,"ERH_SOLD_TO");}

			if(!userIdAL.contains(vendorStr))								
				userIdAL.add(vendorStr);
	
	vendorsHT.put(soldToDB,rfqNo);
}
	for(int i=0;i<userIdAL.size();i++)
	{
		if("".equals(usersList))
			usersList=(String)userIdAL.get(i);
		else
			usersList=usersList+"','"+(String)userIdAL.get(i);
				
	}
	try{
	ezc.ezparam.EzcParams mainParams	= new ezc.ezparam.EzcParams(false);
	EziMiscParams miscParams 		= new EziMiscParams();


	miscParams.setQuery("SELECT EU_ID,EU_FIRST_NAME,EU_LAST_NAME FROM EZC_USERS WHERE EU_ID IN ('"+usersList+"')");

	mainParams.setObject(miscParams);
	mainParams.setLocalStore("Y");
	Session.prepareParams(mainParams);
	UserNamesRetObj = (ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);

	if(UserNamesRetObj!=null)
	userNameCount = UserNamesRetObj.getRowCount();
	}catch(Exception e){System.out.println(e);}
	
	
ArrayList priceAL= new ArrayList();
ArrayList materialAL= new ArrayList();
Hashtable vendorPriceHT =  new Hashtable();
Hashtable vendorPriceALHT =  new Hashtable();
//out.println(itemsRetObj.toEzcString());
//itemsRetObj.sort(new String[]{"ERD_LINE_NO"},true);
//out.println(itemsRetObj.toEzcString());
ReturnObjFromRetrieve itemsRetObjTemp= new ReturnObjFromRetrieve(new String[]{"ERD_MATERIAL","ERD_RFQ_NO","ERD_LINE_NO","ERD_PRICE","ERD_NEG_PRICE"});
int itemsRetObjTempCnt=0;
for(int i=0;i<itemsRetObjCnt;i++)
{
	String matNumber	= checkNull(itemsRetObj.getFieldValueString(i,"ERD_MATERIAL"));
	String rfqDB  		= checkNull(itemsRetObj.getFieldValueString(i,"ERD_RFQ_NO"));
	String price 		= checkNullNum(itemsRetObj.getFieldValueString(i,"ERD_PRICE"));
	String revisedPrice 	= checkNullNum(itemsRetObj.getFieldValueString(i,"ERD_NEG_PRICE"));
	String lineNo 		= checkNullNum(itemsRetObj.getFieldValueString(i,"ERD_LINE_NO"));
	
	itemsRetObjTemp.setFieldValue("ERD_MATERIAL",matNumber);
	itemsRetObjTemp.setFieldValue("ERD_RFQ_NO",rfqDB);
	itemsRetObjTemp.setFieldValue("ERD_LINE_NO",lineNo);
	itemsRetObjTemp.setFieldValue("ERD_PRICE",price);
	itemsRetObjTemp.setFieldValue("ERD_NEG_PRICE",revisedPrice);
	itemsRetObjTemp.addRow();
}
if(itemsRetObjTemp!=null)
{
itemsRetObjTempCnt=itemsRetObjTemp.getRowCount();
itemsRetObjTemp.sort(new String[]{"ERD_LINE_NO"},false);
}
for(int i=0;i<itemsRetObjTempCnt;i++)
{
	String matNumber	= checkNull(itemsRetObjTemp.getFieldValueString(i,"ERD_MATERIAL"));
	String rfqDB  		= checkNull(itemsRetObjTemp.getFieldValueString(i,"ERD_RFQ_NO"));
	String price 		= checkNullNum(itemsRetObjTemp.getFieldValueString(i,"ERD_PRICE"));
	String revisedPrice 	= checkNullNum(itemsRetObjTemp.getFieldValueString(i,"ERD_NEG_PRICE"));
	
	if(Float.parseFloat(revisedPrice)==0)revisedPrice=price;
	
	if(!materialAL.contains(matNumber))
	{
		materialAL.add(matNumber);
		priceAL= new ArrayList();
	}
	priceAL.add(new java.math.BigDecimal(revisedPrice));
	Collections.sort(priceAL);
	
	vendorPriceHT.put(matNumber+rfqDB,price+"#"+revisedPrice);
	vendorPriceALHT.put(matNumber,priceAL);
}
//out.println(vendorPriceALHT);

%>

<!DOCTYPE html>
<html lang="en">
  <head>
      <script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>

 <!-- Bootstrap 3.3.5 -->
    <link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/datepicker.css">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/font-awesome.min.css">
    <!-- Ionicons -->
    <link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/ionicons.min.css">
    
    <!-- Theme style --> 
    <link rel="stylesheet" href="../../../../EzCommon/Library/dist/css/AdminLTE.min.css">
    <!-- AdminLTE Skins. We have chosen the skin-blue for this starter
          page. However, you can choose any other skin. Make sure you
          apply the skin class to the body tag so the changes take effect.
    -->
    <link rel="stylesheet" href="../../../../EzCommon/Library/dist/css/skins/skin-yellow.min.css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
<style>
th{
background-color: '#f39c12 !important'
}
</style>
<script>
function funSubmit()
{
	var chkObj = document.myForm.rank;
	var chkLen = chkObj.length;
	var checkedCnt=0;
	if(isNaN(chkLen))
	{
		if(chkObj.checked)checkedCnt=checkedCnt+1;
	}else{
	
	for(i=0;i<chkLen;i++)
	{
		if(chkObj[i].checked)checkedCnt=checkedCnt+1;
	}
	}
	
	if(checkedCnt==0)
	{
		alert("Please select atleast one vendor");
		return false;
	}
	$.confirm({
		    title: 'Confirm!',
		    content: 'Are you sure to submit ComparisionForm?',
		    buttons: {
		        YES:{
		        btnClass: 'btn-success',
		        action:function () {
			       document.myForm.action="ezSaveQuotationComparisionForm.jsp";
				document.myForm.submit();
		        }
		        },
		        NO: {
		           btnClass: 'btn-danger',
			   action:function () {
			 //  funAction("NO");
			   //    $.alert('caNCEL!');
		       	   }
		        }
		        
		    }
		});	
	
}
</script>
</head>
<body >
<Form name="myForm">
<input type="hidden" name="docId" value="<%=docId%>"> 

<div class="container" >

<div class="row">
	<div class="box">
		<div class="box-header">
		<h4>Quotation Comparision Form</h4>
		</div>
	
		<div class="box-body">
			<table class="table" border=1 style="font-size:12px">
			<thead>
			<tr style="background-color:palegreen">
			<th colspan=5 style="text-align:left">Name of the party</th>
			<%
			Enumeration suppIds  = vendorsHT.keys();
			while(suppIds.hasMoreElements())
			{
				String vendorCode 	= (String)suppIds.nextElement();
				String supplierdata 	= (String)vendorsHT.get(vendorCode);
				String vendorName="";
				
				int vendindex=-1;
				
				if(UserNamesRetObj!=null)
				{
					vendindex=UserNamesRetObj.getRowId("EU_ID",Integer.parseInt(vendorCode)+"");
					if(vendindex>=0)
					vendorName=checkNull(UserNamesRetObj.getFieldValueString(vendindex,"EU_FIRST_NAME"))+" "+checkNull(UserNamesRetObj.getFieldValueString(vendindex,"EU_LAST_NAME"));
					else	 vendorName=vendorCode;
				
				}
			%>
				<th colspan=4 style="text-align:center"><%=vendorName%></th>
			<%
			}
			%>
			</tr>
			<tr style="background-color:palegreen">
			<th colspan=5 style="text-align:left">Make</th>
			<%
			suppIds  = vendorsHT.keys();
			while(suppIds.hasMoreElements())
			{
				String vendorCode 	= (String)suppIds.nextElement();
				
				
				String vendorName="";
								
				int vendindex=-1;

				if(UserNamesRetObj!=null)
				{
					vendindex=UserNamesRetObj.getRowId("EU_ID",Integer.parseInt(vendorCode)+"");
					if(vendindex>=0)
					vendorName=checkNull(UserNamesRetObj.getFieldValueString(vendindex,"EU_FIRST_NAME"));
					else	 vendorName=vendorCode;		
				}
			%>
			<th colspan=2 style="text-align:center"><%=vendorName%></th>
			<th colspan=2 style="text-align:center"><%=vendorName%></th>
			<%
			}
			%>
			</tr>
			<tr style="background-color:palegreen">
				<th colspan=5 style="text-align:left">Quotation Ref.No. & Date</th>
			<%
				suppIds  = vendorsHT.keys();
				while(suppIds.hasMoreElements())
				{
					String vendorCode 	= (String)suppIds.nextElement();
					String supplierdata 	= (String)vendorsHT.get(vendorCode);
				%>
				<th colspan=2 style="text-align:center"><%=supplierdata%></th>
				<th colspan=2 style="text-align:center"><%=supplierdata%></th>
				<%
				}
				%>
			</tr>
			<tr style="background-color:khaki">
				<th rowspan=2  style="text-align:center">S.No.</th>
				<th rowspan=2  style="text-align:center">TAG NO</th>
				<th rowspan=2  style="text-align:center">Description</th>
				<th rowspan=2  style="text-align:center">UoM</th>
				<th rowspan=2  style="text-align:center">Qty</th>
				<%
				suppIds  = vendorsHT.keys();
				while(suppIds.hasMoreElements())
				{
				String vendorCode 	= (String)suppIds.nextElement();
				%>
					<th colspan=2 style="text-align:center">Quoted Price</th>
					<th colspan=2 style="text-align:center">Revised</th>
				<%
				}
				%>
			</tr>
			<tr style="background-color:khaki">
				<%
				suppIds  = vendorsHT.keys();
				while(suppIds.hasMoreElements())
				{
				String vendorCode 	= (String)suppIds.nextElement();
				%>
					<th style="text-align:center">Rate<br>Rs./UOM </th>
					<th style="text-align:center">Total<br>Amount Rs.</th>
					<th style="text-align:center">Rate<br>Rs./UOM </th>
					<th style="text-align:center">Total<br>Amount Rs.</th>
				<%
				}
				%>
			</tr>
			</thead>
			<tbody>
			<%
				Enumeration vendorPriceEnum  = vendorPriceALHT.keys();
				
				while(vendorPriceEnum.hasMoreElements())
				{
					String matNumber 	= (String)vendorPriceEnum.nextElement();
				
					//String matNumber= checkNull(itemsRetObj.getFieldValueString(i,"ERD_MATERIAL"));
					int itemIndex=-1;
					itemIndex = itemsRetObj.getRowId("ERD_MATERIAL",matNumber);
					String desc 	= checkNull(itemsRetObj.getFieldValueString(itemIndex,"ERD_MATERIAL_DESC"));
					String uom 	= checkNull(itemsRetObj.getFieldValueString(itemIndex,"ERD_UOM"));
					String qty 	= checkNull(itemsRetObj.getFieldValueString(itemIndex,"ERD_QUANTITY"));
					String lineNo 	= checkNull(itemsRetObj.getFieldValueString(itemIndex,"ERD_LINE_NO"));
					//out.println(itemIndex+":::::"+lineNo);
			%>
				<tr>
					<td style="text-align:center" rowspan=2><%=lineNo%>&nbsp;</td>
					<td style="text-align:center" rowspan=2><%=Integer.parseInt(matNumber)%>&nbsp;</td>
					<td style="text-align:center;width:25%" rowspan=2><%=desc%>&nbsp;</td>
					<td style="text-align:center" rowspan=2><%=uom%>&nbsp;</td>
					<td style="text-align:center" rowspan=2><%=qty%>&nbsp;</td>
					<%
						suppIds  = vendorsHT.keys();
						while(suppIds.hasMoreElements())
						{
							String vendorCode 	= (String)suppIds.nextElement();
							String rfq 	= (String)vendorsHT.get(vendorCode);
							
							java.math.BigDecimal quotedPriceBD = new java.math.BigDecimal(((String)vendorPriceHT.get(matNumber+rfq)).split("#")[0]);
							java.math.BigDecimal revisedPriceBD= new java.math.BigDecimal(((String)vendorPriceHT.get(matNumber+rfq)).split("#")[1]);
							
							java.math.BigDecimal quotedAmountBD = quotedPriceBD.multiply(new java.math.BigDecimal(qty));
							java.math.BigDecimal revisedAmountBD= revisedPriceBD.multiply(new java.math.BigDecimal(qty));
							
						%>
							<td style="text-align:center"><%=quotedPriceBD%>&nbsp;</td>
							<td style="text-align:center"><%=quotedAmountBD%>&nbsp;</td>
							<td style="text-align:center"><%=revisedPriceBD%>&nbsp; </td>
							<td style="text-align:center"><%=revisedAmountBD%>&nbsp;</td>
						<%
						}
					%>
				</tr>
				<tr>
					
					<%
					suppIds  = vendorsHT.keys();
					while(suppIds.hasMoreElements())
					{
					String vendorCode 	= (String)suppIds.nextElement();
					
					String rfq 	= (String)vendorsHT.get(vendorCode);
					
					priceAL = (ArrayList)vendorPriceALHT.get(matNumber);
												
					java.math.BigDecimal quotedPrice = new java.math.BigDecimal(((String)vendorPriceHT.get(matNumber+rfq)).split("#")[0]);
					java.math.BigDecimal revisedPrice= new java.math.BigDecimal(((String)vendorPriceHT.get(matNumber+rfq)).split("#")[1]);

					String rankStr="",vendorCodeStr="";

					try{
						vendorCodeStr=(Integer.parseInt(vendorCode))+"";
					}catch(Exception e){}
					try{
						rankStr=(priceAL.indexOf(revisedPrice))+"";

						if(Integer.parseInt(rankStr)>=0)rankStr=(Integer.parseInt(rankStr)+1)+"";
					}catch(Exception e){}

					%>
						<td style="text-align:center" colspan=4><b>Rank:<%=rankStr%></b>&nbsp;&nbsp;&nbsp;<input type="checkbox" name="rank" value="<%=vendorCodeStr+"#"+desc%>"><input type="hidden" name="participatedVendors" value="<%=vendorCodeStr+"#"+desc+"#"+rfq%>">&nbsp;</td>
					<%
					}
					%>
				</tr>
			
			<%
			
				}
			%>
				<tr>
					<td>&nbsp;</td>
					<td style="text-align:left" colspan=2>&nbsp;Ex works Price</td>
					<td>&nbsp;</td>
					<td>1&nbsp;</td>
					<%
					suppIds  = vendorsHT.keys();
					while(suppIds.hasMoreElements())
					{
					String vendorCode 	= (String)suppIds.nextElement();
					%>
						<td style="text-align:center">&nbsp;</td>
						<td style="text-align:center">&nbsp;</td>
						<td style="text-align:center">&nbsp; </td>
						<td style="text-align:center">&nbsp;</td>
					<%
					}
					%>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td style="text-align:left" colspan=2>&nbsp;Discount</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<%
					suppIds  = vendorsHT.keys();
					while(suppIds.hasMoreElements())
					{
					String vendorCode 	= (String)suppIds.nextElement();
					%>
						<td style="text-align:center">&nbsp;</td>
						<td style="text-align:center">&nbsp;</td>
						<td style="text-align:center">&nbsp; </td>
						<td style="text-align:center">&nbsp;</td>
					<%
					}
					%>
				</tr>
				<tr>
					<td style="text-align:center">&nbsp;</td>
					<td style="text-align:center" colspan=2>&nbsp;</td>
					<td style="text-align:center">&nbsp; </td>
					<td style="text-align:center">&nbsp;</td>
					<%
					suppIds  = vendorsHT.keys();
					while(suppIds.hasMoreElements())
					{
					String vendorCode 	= (String)suppIds.nextElement();
					%>
						<td style="text-align:center">&nbsp;</td>
						<td style="text-align:center">&nbsp;</td>
						<td style="text-align:center">&nbsp; </td>
						<td style="text-align:center">&nbsp;</td>
					<%
					}
					%>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td style="text-align:left" colspan=2>&nbsp;Packing & Forwarding</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<%
					suppIds  = vendorsHT.keys();
					while(suppIds.hasMoreElements())
					{
					String vendorCode 	= (String)suppIds.nextElement();
					%>
						<td style="text-align:center">&nbsp;</td>
						<td style="text-align:center">&nbsp;</td>
						<td style="text-align:center">&nbsp; </td>
						<td style="text-align:center">&nbsp;</td>
					<%
					}
					%>
				</tr>	
				<tr>
					<td style="text-align:center">&nbsp;</td>
					<td style="text-align:center" colspan=2>&nbsp;</td>
					<td style="text-align:center">&nbsp; </td>
					<td style="text-align:center">&nbsp;</td>
					<%
					suppIds  = vendorsHT.keys();
					while(suppIds.hasMoreElements())
					{
					String vendorCode 	= (String)suppIds.nextElement();
					%>
						<td style="text-align:center">&nbsp;</td>
						<td style="text-align:center">&nbsp;</td>
						<td style="text-align:center">&nbsp; </td>
						<td style="text-align:center">&nbsp;</td>
					<%
					}
					%>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td style="text-align:left" colspan=2>&nbsp;GST</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<%
					suppIds  = vendorsHT.keys();
					while(suppIds.hasMoreElements())
					{
					String vendorCode 	= (String)suppIds.nextElement();
					%>
						<td style="text-align:center">&nbsp;</td>
						<td style="text-align:center">&nbsp;</td>
						<td style="text-align:center">&nbsp; </td>
						<td style="text-align:center">&nbsp;</td>
					<%
					}
					%>
				</tr>
				<tr>
					<td style="text-align:center">&nbsp;</td>
					<td style="text-align:center" colspan=2>&nbsp;</td>
					<td style="text-align:center">&nbsp; </td>
					<td style="text-align:center">&nbsp;</td>
					<%
					suppIds  = vendorsHT.keys();
					while(suppIds.hasMoreElements())
					{
					String vendorCode 	= (String)suppIds.nextElement();
					%>
						<td style="text-align:center">&nbsp;</td>
						<td style="text-align:center">&nbsp;</td>
						<td style="text-align:center">&nbsp; </td>
						<td style="text-align:center">&nbsp;</td>
					<%
					}
					%>
				</tr>				
				<tr>
					<td>&nbsp;</td>
					<td style="text-align:left" colspan=2>&nbsp;Freight & Transit Ins (Estd)</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<%
					suppIds  = vendorsHT.keys();
					while(suppIds.hasMoreElements())
					{
					String vendorCode 	= (String)suppIds.nextElement();
					%>
						<td style="text-align:center">&nbsp;</td>
						<td style="text-align:center">&nbsp;</td>
						<td style="text-align:center">&nbsp; </td>
						<td style="text-align:center">&nbsp;</td>
					<%
					}
					%>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td style="text-align:left" colspan=2>&nbsp;Landed Cost</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<%
					suppIds  = vendorsHT.keys();
					while(suppIds.hasMoreElements())
					{
					String vendorCode 	= (String)suppIds.nextElement();
					String quotedPrice="1";
					String revisedPrice="1";
					
					%>
						<td style="text-align:center">&nbsp;</td>
						<td style="text-align:center">&nbsp;</td>
						<td style="text-align:center">&nbsp; </td>
						<td style="text-align:center">&nbsp;</td>
					<%
					}
					%>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td style="text-align:left" colspan=2>&nbsp;Price Basis:</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<%
					suppIds  = vendorsHT.keys();
					while(suppIds.hasMoreElements())
					{
					String vendorCode 	= (String)suppIds.nextElement();
					%>
						<td style="text-align:center" colspan=2>&nbsp;</td>
						<td style="text-align:center" colspan=2>&nbsp;</td>
					<%
					}
					%>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td style="text-align:left" colspan=2>&nbsp;Payment Terms:</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<%
					suppIds  = vendorsHT.keys();
					while(suppIds.hasMoreElements())
					{
					String vendorCode 	= (String)suppIds.nextElement();
					String paymentTerms="";
					int index =-1;
					if(rfqHeaderRetCnt>0)
					{
						index=rfqHeaderRet.getRowId("ERH_SOLD_TO",vendorCode);
						
						paymentTerms=checkNull(rfqHeaderRet.getFieldValueString(index,"ERH_PAYMENT_TERMS"));
					}
					%>
						<td style="text-align:center" colspan=2><%=paymentTerms%>&nbsp;</td>
						<td style="text-align:center" colspan=2><%=paymentTerms%>&nbsp;</td>
					<%
					}
					%>
				</tr>
<tr>
					<td>&nbsp;</td>
					<td style="text-align:left" colspan=2>&nbsp;Delivery Period:</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<%
					suppIds  = vendorsHT.keys();
					while(suppIds.hasMoreElements())
					{
					String vendorCode 	= (String)suppIds.nextElement();
					String deliveryPeriod="";
					int index =-1;
					if(rfqHeaderRetCnt>0)
					{
						index=rfqHeaderRet.getRowId("ERH_SOLD_TO",vendorCode);
						
						deliveryPeriod=checkNull(rfqHeaderRet.getFieldValueString(index,"ERH_DELV_PERIOD"));
					}
						
					%>
						<td style="text-align:center" colspan=2><%=deliveryPeriod%>&nbsp;</td>
						<td style="text-align:center" colspan=2><%=deliveryPeriod%>&nbsp;</td>
					<%
					}
					%>
				</tr>
<tr>
					<td>&nbsp;</td>
					<td style="text-align:left" colspan=2>&nbsp;Guarantee Period</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<%
					suppIds  = vendorsHT.keys();
					while(suppIds.hasMoreElements())
					{
					String vendorCode 	= (String)suppIds.nextElement();
					String guaranteePeriod="";
					int index =-1;
					if(rfqHeaderRetCnt>0)
					{
						index=rfqHeaderRet.getRowId("ERH_SOLD_TO",vendorCode);

						guaranteePeriod=checkNull(rfqHeaderRet.getFieldValueString(index,"ERH_GUARANTEE_PERIOD"));
					}
					
					%>
						<td style="text-align:center" colspan=2><%=guaranteePeriod%>&nbsp;</td>
						<td style="text-align:center" colspan=2><%=guaranteePeriod%>&nbsp;</td>
					<%
					}
					%>
				</tr>	
<tr>
					<td>&nbsp;</td>
					<td style="text-align:left" colspan=2>&nbsp;Validity of offer</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<%
					suppIds  = vendorsHT.keys();
					while(suppIds.hasMoreElements())
					{
					String vendorCode 	= (String)suppIds.nextElement();
					String quoteValidity="";
					int index =-1;
					if(rfqHeaderRetCnt>0)
					{
						index=rfqHeaderRet.getRowId("ERH_SOLD_TO",vendorCode);
						try{
						quoteValidity=checkNull(rfqHeaderRet.getFieldValueString(index,"ERH_QUOTE_VALIDITY"));
						SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
						Date date = formatter.parse(quoteValidity);
						formatter = new SimpleDateFormat("dd/MM/yyyy");
						quoteValidity = formatter.format(date);
						}catch(Exception e){}
					}

					%>
						<td style="text-align:center" colspan=2><%=quoteValidity%>&nbsp;</td>
						<td style="text-align:center" colspan=2><%=quoteValidity%>&nbsp;</td>
					<%
					}
					%>
				</tr>					
			</tbody>
			</table>
		</div>
	</div>
</div>
<div class="row">

	<center><div class="col-md-11 col-md-offset-1" id="UploadDiv1">
		<a href="javascript:funSubmit()" class="btn btn-info" >Submit</a>
		<a href="javascript:parent.$.fancybox.close();" class="btn btn-info" >Cancel</a>
		
	</div></center>
	
</div>

</div>
</form>

</body>
</html>
 <link rel="stylesheet" href="../../../../EzCommon/Library/plugins/jQuery/confirm.css" type="text/css" media="screen" />  
    <script src="../../../../EzCommon/Library/plugins/jQuery/confirm.min.js"></script>
