<%@ page import="ezc.ezutil.*" %>
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<%@ page import = "java.io.*,java.util.*,java.math.*,java.text.SimpleDateFormat,java.text.ParseException, javax.servlet.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import ="ezc.sapconnection.*,com.sap.mw.jco.*,com.sap.mw.jco.JCO" %>
<%@ page import = "javax.servlet.http.*" %>
<%@ page import = "org.apache.commons.fileupload.*" %>
<%@ page import = "org.apache.commons.fileupload.disk.*" %>
<%@ page import = "org.apache.commons.fileupload.servlet.*" %>
<%@ page import = "org.apache.commons.io.output.*" %> 
<%@ page import="org.apache.poi.xssf.usermodel.*"%>                
<%@ page import="org.apache.poi.ss.usermodel.Cell"%>            
<%@ page import="org.apache.poi.ss.usermodel.Row"%>
<%@ page import="org.apache.poi.ss.usermodel.Sheet"%> 
<%@ page import="org.apache.poi.xssf.usermodel.XSSFCell"%>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFRow"%>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFSheet"%>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFWorkbook"%> 
<%@ page import="org.apache.poi.ss.usermodel.*,org.apache.poi.ss.util.RegionUtil"%>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFColor,org.apache.poi.ss.util.CellRangeAddress"%>
<%@ page import="javax.xml.parsers.*,org.w3c.dom.*,javax.xml.transform.*,javax.xml.transform.dom.DOMSource,java.io.FileOutputStream,javax.xml.transform.stream.StreamResult" %>
<%!	

	public String checkNull(String value)   
	{ 
		if(value==null || "null".equals(value.trim()))value="";  
		return value.trim(); 
	}
	public String convertDateObjToStringForm(java.util.Date inputDate)
	{
		java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd-MM-yyyy");
		String stringObj = "";
		try {
			stringObj = sdf.format(inputDate);

		} catch (Exception e) {

		}
		return stringObj;

	}
	public String getCellValue(String fileExt,Iterator cellIter) 
	{
		String celValue = "";
		if(cellIter.hasNext())
		{
			if("xlsx".equals(fileExt))
			{
					XSSFCell myCellX = (XSSFCell) cellIter.next();
					
					if(myCellX.getCellTypeEnum() == CellType.NUMERIC) 
					{
							celValue=new BigDecimal(myCellX.getNumericCellValue())+"";
							//System.out.print("Integer:::"+celValue);
					}
					else if(myCellX.getCellTypeEnum() == CellType.STRING) 
					{
							celValue=myCellX.getStringCellValue()+"";
							//System.out.print("String:::"+celValue);
					}
					else
					{
							celValue=myCellX.getStringCellValue()+"";
					}
			}
			else
			{ 
					HSSFCell myCellH = (HSSFCell) cellIter.next();
					
					if(myCellH.getCellTypeEnum() == CellType.NUMERIC) 
					{
							celValue=myCellH.getNumericCellValue()+"";
							//System.out.print("Integer:::"+celValue);
					}
					else if(myCellH.getCellTypeEnum() == CellType.STRING) 
					{
							celValue=myCellH.getStringCellValue()+"";
							//System.out.print("String:::"+celValue);
					}else{
							celValue=myCellH.getStringCellValue()+"";
					}
			}
			if(celValue == null || "null".equals(celValue.trim()) || "".equals(celValue.trim()))
					celValue ="";
		} 
		return celValue;
	}
	public String getCellValue2(String fileExt,Iterator cellIter) 
	{
		String celValue = "";
		DataFormatter formatter = new DataFormatter();
		if(cellIter.hasNext())
		{
			if("xlsx".equals(fileExt))
			{
					XSSFCell myCellX = (XSSFCell) cellIter.next();

					
					celValue=formatter.formatCellValue(myCellX);
					
					
			}
			else
			{ 
					HSSFCell myCellH = (HSSFCell) cellIter.next();

					celValue=formatter.formatCellValue(myCellH);
					
			}
			if(celValue == null || "null".equals(celValue.trim()) || "".equals(celValue.trim()))
					celValue ="";
		} 
		return celValue;
	}

	public ReturnObjFromRetrieve readExcel(InputStream uploadedInputStream,String fileExt,Hashtable<String,String> htHeaderCol)
	{
			XSSFWorkbook wbX        = null;
			HSSFWorkbook wbH       = null;
			HSSFSheet mySheetH    = null;
			XSSFSheet mySheetX     = null;
			Iterator rowIter = null;
			//String fileExt       = "xlsx";
			String vendNum="";
			ReturnObjFromRetrieve retObj= new ReturnObjFromRetrieve();
				
			try {
					if("xlsx".equals(fileExt))
					{
						wbX                = new XSSFWorkbook(uploadedInputStream);
						mySheetX           = wbX.getSheetAt(0);
						rowIter 	   = mySheetX.rowIterator();		
					}
					else
					{
						wbH                = new HSSFWorkbook(uploadedInputStream);
						mySheetH           = wbH.getSheetAt(0);
						rowIter 	   = mySheetH.rowIterator();		
					}
							

			} catch (Exception e) {
					e.printStackTrace();
			}
			
			int firstRow=0;
			int colNo=0;
			int noOfCols = 0;
			try{
					HSSFRow myRowH          = null;
					XSSFRow myRowX           = null;
					DataFormatter df = new DataFormatter();
					while (rowIter.hasNext()) 
					{
							if("xlsx".equals(fileExt))
									myRowX              = (XSSFRow) rowIter.next();
							else
									myRowH              = (HSSFRow) rowIter.next();
							
							
							Iterator cellIter = null;
							if("xlsx".equals(fileExt))
									cellIter = myRowX.cellIterator();
							else
									cellIter = myRowH.cellIterator();
							
							
							
							if(firstRow==0)
							{



									boolean endLoop = true;
									while(endLoop)
									{
											String colName = getCellValue(fileExt,cellIter);
											ezc.ezcommon.EzLog4j.log("COLNAME>>>>>>>>>>"+colName,"I"); 
											if(colName != null && !"".equals(colName))
											{
													colName = colName.trim();
													colName = colName.toUpperCase();
													ezc.ezcommon.EzLog4j.log("COLNAME-OLD>>>>>>"+colName,"I"); 
													ezc.ezcommon.EzLog4j.log("COLNAME-NEW>>>>>>>"+htHeaderCol.get(colName),"I"); 
													if(htHeaderCol.containsKey(colName))
														colName = htHeaderCol.get(colName);
													
													retObj.addColumn(colName);
													noOfCols++;
											}
											else{
													endLoop=false;
											}
									}


									firstRow++;
							}
							else
							{	ezc.ezcommon.EzLog4j.log("noOfCols>>>>>>>>"+noOfCols,"I");	
									for(int i=0;i<noOfCols;i++)
									{
											
											String colValue = "";//getCellValue(fileExt,cellIter);
											if("xlsx".equals(fileExt))
											{
													XSSFCell myCellX = (XSSFCell) myRowX.getCell(i);
													
													if(myCellX != null)
													{
															/*if(myCellX.getCellTypeEnum() == CellType.NUMERIC) 
															{
																	colValue=new BigDecimal(myCellX.getNumericCellValue())+"";
																	System.out.print("Integer:::"+colValue);
															}
															else if(myCellX.getCellTypeEnum() == CellType.STRING) 
															{
																	colValue=myCellX.getStringCellValue()+"";
																	System.out.print("String:::"+colValue);
															}
															else */
															if(myCellX.getCellTypeEnum() == CellType.NUMERIC) 
															{
																if(DateUtil.isCellDateFormatted(myCellX))
																{

																	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
																	colValue =  sdf.format(myCellX.getDateCellValue());
																	ezc.ezcommon.EzLog4j.log("COLVALUE>>>>>>>>>>>>"+colValue+"<<index>2>"+i,"I"); 

																}
																else
																{
																	colValue= df.formatCellValue(myCellX);//myCellX.getStringCellValue()+"";
																}
															}
															else
															{
																	colValue= df.formatCellValue(myCellX);//myCellX.getStringCellValue()+"";
															}
													}

											}
											else
											{
													HSSFCell myCellH = (HSSFCell) myRowH.getCell(i);
													ezc.ezcommon.EzLog4j.log("myCellH value>>>>>>>>>>>>"+myCellH+"<<index>>>"+i,"I"); 
													if(myCellH != null)
													{
															/*if(myCellH.getCellTypeEnum() == CellType.NUMERIC) 
															{
																	colValue=myCellH.getNumericCellValue()+"";

																	System.out.print("Integer:::"+colValue);
															}
															else if(myCellH.getCellTypeEnum() == CellType.STRING) 
															{
																	colValue=myCellH.getStringCellValue()+"";
																	System.out.print("String:::"+colValue);
															}
															else */
															
															if(myCellH.getCellTypeEnum() == CellType.NUMERIC) 
															{
																if(HSSFDateUtil.isCellDateFormatted(myCellH))
																{
																	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
																	colValue =  sdf.format(myCellH.getDateCellValue());

																}
																else
																{
																	colValue=df.formatCellValue(myCellH);//myCellH.getStringCellValue()+"";
																}
															}
															else
															{
																	colValue=df.formatCellValue(myCellH);//myCellH.getStringCellValue()+"";
															}
													}
													
											}
											try{
											retObj.setFieldValue(i, colValue);
											}catch(Exception e){ezc.ezcommon.EzLog4j.log("Exception>>>>>>>>>>"+e,"I");}
											
											
											
									}
									
									
									retObj.addRow();
									ezc.ezcommon.EzLog4j.log("row added>>>>>>>>>>>>"+retObj.toEzcString(),"I");

							}
							
							
					}
			}
			catch(Exception Ex)
			{
					System.out.println(Ex+":::Exception:::");
			
			}
			finally
			{
					try
					{
							uploadedInputStream.close();
					}
					catch(Exception ex){}
			} 
			//out.println("::::retObj"+retObj.toEzcString());
			//ezc.ezcommon.EzLog4j.log("ret Obj>>>>>>>>>>"+retObj.toEzcString(),"I");
			return retObj;
	}

%> 

<%
	ReturnObjFromRetrieve budgetExcel = null;
	String isValidate = request.getParameter("isValidate");
	boolean showError = false;
	String errTabStr="",displayErrMsg="none",dispMsg="";
 
   Hashtable<String,String> htHeaderCol = new Hashtable<String,String>();

	 htHeaderCol.put("S.NO","S.NO"); 	
	 htHeaderCol.put("Item Code","Item Code"); 
	 htHeaderCol.put("Description","Description"); 
	 htHeaderCol.put("UOM","UOM"); 
	 htHeaderCol.put("Currency","Currency"); 
	 htHeaderCol.put("Budget Rate FY23","Budget Rate FY23"); 
	  	 
   File file ;
   int maxFileSize = 5000 * 1024;
   int maxMemSize = 5000 * 1024;
   ServletContext context = pageContext.getServletContext();
   String filePath = context.getInitParameter("file-upload");

   // Verify the content type
   String contentType = request.getContentType();
   ezc.ezcommon.EzLog4j.log(":::::::content type:::::::"+contentType,"I");    
	if("".equals(contentType) || "null".equals(contentType) || null == contentType)
	contentType ="";
   if ((contentType.indexOf("multipart/form-data") >= 0)) {
      DiskFileItemFactory factory = new DiskFileItemFactory(); 
      // maximum size that will be stored in memory
      factory.setSizeThreshold(maxMemSize);

      // Location to save data that is larger than maxMemSize.
      factory.setRepository(new File("c:\\temp"));

      // Create a new file upload handler
      ServletFileUpload upload = new ServletFileUpload(factory);

      // maximum file size to be uploaded.
      upload.setSizeMax( maxFileSize );

      try { 
	 // Parse the request to get file items.
	 List fileItems = upload.parseRequest(request);

	 // Process the uploaded file items
	 Iterator i = fileItems.iterator();



	 while ( i.hasNext () ) {
	    FileItem fi = (FileItem)i.next();
	    if ( !fi.isFormField () ) {
	       // Get the uploaded file parameters
	       String fieldName = fi.getFieldName();
	       String fileName = fi.getName(); 
	       boolean isInMemory = fi.isInMemory();
	       String fileExt = "";
	       int e = fieldName.lastIndexOf('.');
	       if (e > 0) {
		   fileExt = fieldName.substring(e+1);
		}
		//out.println(fieldName); 
	       long sizeInBytes = fi.getSize(); 
		budgetExcel = readExcel(fi.getInputStream(),fileExt,htHeaderCol);
		ezc.ezcommon.EzLog4j.log(":::::::ret excel:::::::"+budgetExcel.toEzcString(),"I"); 
	       //out.print(budgetExcel.toEzcString());
	    }
	 }

      } catch(Exception ex) {
	 System.out.println(ex);
      }
   } else { 

   }
   int maxCommId = 9000;
   String maxCnt="";
  /*************************GET MAX ID FOR CLRDAHBOARD**********************************/
	ReturnObjFromRetrieve  budPriceRet=null;
	ezc.ezparam.EzcParams mainParamsbudPrice = new ezc.ezparam.EzcParams(false); 				
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgrbudPrice = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTablebudPrice = new ezc.misctransactions.params.EzMiscTable();

	ezc.misctransactions.params.EzMiscTableRow miscTableRowbudPrice = new ezc.misctransactions.params.EzMiscTableRow();
	miscTableRowbudPrice.setQuery("select * from ezc_mat_budget_price");
	miscTablebudPrice.appendRow(miscTableRowbudPrice);	
	mainParamsbudPrice.setLocalStore("Y");
	mainParamsbudPrice.setObject(miscTablebudPrice);
	Session.prepareParams(mainParamsbudPrice);
	try
	{
	budPriceRet=(ReturnObjFromRetrieve)miscMgrbudPrice.ezGetMiscTransactions(mainParamsbudPrice);
	ezc.ezcommon.EzLog4j.log(":::::::ret excel:::::::"+budgetExcel.toEzcString(),"I"); 

	}
	catch(Exception e)
	{
	ezc.ezcommon.EzLog4j.log("::Exception:while getting data:"+e,"E");
	}
	
/*********************************************************************************************/	
 


<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
<!-- Content Header (Page header) --> 
<section class="content-header">
   <h1>
      BUDGET PRICE
   </h1>
</section>
<!-- Main content -->  
<section class="content">
<form name="myForm" id="formID" method="post" >
<input type="hidden" name="isValidate" value="N">
<%
	
	
	if(budgetExcel!=null && budgetExcel.getRowCount()>0)
	{
	ezc.ezcommon.EzLog4j.log(":::::::budgetExcel>>:::::::"+budgetExcel.toEzcString(),"I");
	ezc.ezcommon.EzLog4j.log(":::::::budgetExcel>>:::::::"+budgetExcel.getRowCount(),"I");
%>
   <div class="row">
   <!-- left column -->
   <div class="col-md-12 col-xs-12">
   <!-- general form elements -->
  <div class="box box-default">
  <div class="box-body table-responsive no-padding">
  <div class="box-body">
  
  <div style="Height: 460px;overflow: scroll;">
  	<table id="example" class="table table-bordered" >
	<thead>
		<tr>
			<th>S.NO</th>
			<th>Item Code</th>
			<th>Description</th>
			<th>UOM</th>
			<th>Currency</th>
			<th>Budget Rate FY23</th>
			
		</tr>
	</thead>
	<tbody> 
<% 
	//out.println("::::retObj"+budgetExcel.toEzcString());
	SimpleDateFormat simpleDateFormat = new SimpleDateFormat("dd-MM-yyyy");
	Date date = new Date();
	String BP_S.NO="",BP_ITEMCODE="",BP_DESCRIPTION="",BP_UOM="",BP_CURRENCY="",BP_BUDGET RATE FY23="";
	for(int i=0; i<budPriceRet.getRowCount(); i++)
	{ 
	
		BP_S.NO				=checkNull(budPriceRet.getFieldValueString(i,"S.NO"));
		BP_ITEM_CODE			=checkNull(budPriceRet.getFieldValueString(i,"ITEM CODE"));
		BP_DESCRIPTION			=checkNull(budPriceRet.getFieldValueString(i,"DESCRIPTION"));
		BP_UOM 				=checkNull(budPriceRet.getFieldValueString(i,"UOM"));
		BP_CURRENCY  			=checkNull(budPriceRet.getFieldValueString(i,"CURRENCY"));
		BP_BUDGET_RATE_FY23		=checkNull(budPriceRet.getFieldValueString(i,"BUDGET RATE FY23"));
		

%>   
		<tr>     
		
			<td><input type="text" name="sNo" id="sNo<%=i%>" class="validate[required] form-control" value="<%=BP_S.NO%>"  /></td>	
			<td><input type="text" name="uom" id="uom<%=i%>" style="width:100px;"  class="validate[required] form-control" value="<%=BP_ITEM_CODE%>"  /></td>	
			<td><input type="text" name="currency" id="currency<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=BP_DESCRIPTION%>"  /></td>	
			<td><input type="text" name="itemCode" id="itemCode<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=BP_UOM%>"  /></td>	
			<td><input type="text" name="desc" id="desc<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=BP_CURRENCY%>"  /></td>	
			<td><input type="text" name="bdgtRate" id="bdgtRate<%=i%>" class="validate[required] form-control" style="width:100px;" value="<%=BP_BUDGET_RATE_FY23%>"  /></td>	

		</tr>
<%
		
	} 
%>
	</tbody>
	</table>
	</DIV>
	</div>

	</div>
	</div>
	<!-- Your Page Content Here -->
	</div>
	</div><!--row-->
	<br>
	
	
	
	<!-- Table row -->
	<div class="row" id="validErrorMsgDiv" style="display:<%=displayErrMsg%>">
	   <div class="col-xs-12">
	      <div class="alert alert-info alert-dismissible">
	         <i class="icon fa fa-info"></i><span id="validErrorMsg"><%=dispMsg%></span>
	      </div>
	   </div>
	</div>
	</br>

  
  
  
	<div class="row" >
		<div class="col-xs-12" align="center">
			<button type="button" class="btn btn-primary" onclick="funBack()"><span class="glyphicon glyphicon-backward"></span> Back </button>  &nbsp;
			<!--<button type="button" class="btn btn-primary" onclick="funValidate()" ><span class="glyphicon glyphicon-info-sign"></span> Validate </button>  &nbsp;-->
			<button type="button" class="btn btn-primary" onclick="funSubmit()" id="saveData"  ><span class="glyphicon glyphicon-forward" ></span> Submit </button>  &nbsp;
			
		</div>
	</div>
<%
	}
%>
</form>
</section>
<!-- /.content -->
</div><!-- /.content-wrapper --> 
<div id="woModal" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog">
      <div class="modal-content">
         <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <iframe src="" width="100%" height="540" frameborder="0" allowtransparency="true"></iframe>
         </div>
      </div>
   </div>
</div>



<script src="../../Library/JavaScript/ezTabScroll.js"></Script>
<script src="../../Library/JavaScript/ezConvertDates.js"></Script>
<script>
		window.closeModal = function(){
		    $('#woModal').modal('hide');
		};
		$('#woModal').on('shown.bs.modal', function () {
		    $(this).find('.modal-dialog').addClass('modal-lg');
});
	</script>
<script>

	/*function funValidate()
	{ 
		if ( $("#formID").validationEngine('validate') )
		{
			//document.myForm.action="ezReadDeliverySchedules.jsp";
			//document.myForm.submit();
			document.getElementById("validErrorMsgDiv").style.display="block"
			document.myForm.isValidate.value="Y";
			document.myForm.action="ezReadCLRData.jsp";
			document.myForm.submit();
		}
		
	}
	
	
	function funSubmit()
	{ 
		if($("#formID").validationEngine('validate'))
		{
			
		
		document.myForm.action="ezSaveCLRExcel.jsp";
		document.myForm.submit();
		}
		
	}
	
	function funHideSubBut()
	{
		document.getElementById("saveData").style.display="none";
		//document.getElementById("saveInvalid").style.display="none";
	}
	function funBack()
	{
		document.myForm.action="ezUploadCertificateMaster.jsp";
		document.myForm.submit();
	}
	
	function showLog(status,msg)
	{
		$('iframe').attr("src","../Misc/ezShowMsg.jsp?msg="+encodeURIComponent(msg)+"&status="+status);
		$('#woModal').modal({show:true});
	}*/
	
	

	
</script>
<script type="text/javascript" class="init">
   $(document).ready( function () {
   $('#example').dataTable( {
   "bPaginate": false,  
           "bInfo": false,  
           "bFilter": false,
           "bAutoWidth": false,
           "aoColumns" : [
               { sWidth: '50px' },
               { sWidth: '200px' },
               { sWidth: '120px' },
               { sWidth: '30px' }
        ] 
       } ); 
<%
   	if(showError)
   	{
%>
		$('#errModal').modal({show:true});
<%
	}
%>
	$("#formID").validationEngine();
 
   }); 
   $("#formID").bind("jqv.field.result", function(event, field, errorFound, prompText) {
     if(errorFound)
     {
        field.removeAttr("readonly");
        //alert(field.attr('id')); 
        
        
     }  
      
  });
  $("#formID").bind("jqv.form.result", function(event, errorFound) {
     if(errorFound)
     {
        //document.getElementById("saveInvalid").style.display="inline-block"; 
	document.getElementById("saveData").style.display="none";
	//document.getElementById("validErrorMsg").innerHTML="Re enter invalid data or press Submit button to post entries by excluding invalid data ";
        
     }
     else
     {
        document.getElementById("saveData").style.display="inline-block";
	//document.getElementById("saveInvalid").style.display="none";
	document.getElementById("validErrorMsg").innerHTML="Press Submit button to post data";
     }
  });
   
	            
		   
</script>

