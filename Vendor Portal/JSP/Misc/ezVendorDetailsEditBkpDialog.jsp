<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*,java.util.*" %>		
<%@ include file="iVendorDetails.jsp" %>


<%
//out.println("<<<"+key+"<<<"+value+"<<<"+value);
%>

<%  
	String usrId	=	"xyz";  
	
	String vendCode = request.getParameter("vendCode");
	String compCode = request.getParameter("compCode");
	String serBased = request.getParameter("serBased");
	String venName  = request.getParameter("venName");
	String corLoc   = request.getParameter("corLoc");
	String grBased  = request.getParameter("grBased");
	String procGrp  = request.getParameter("procGrp");
	
	String titleSel = request.getParameter("titleSel");
	String name1    = request.getParameter("name1");
	String name2 	= request.getParameter("name2");
	String addr1 	= request.getParameter("addr1");
	String addr2 	= request.getParameter("addr2");
	String street	 = request.getParameter("street");
	String city 	= request.getParameter("city");
	String state 	= request.getParameter("state");
	String country	= request.getParameter("country");
	String district = request.getParameter("district");
	String pin 	= request.getParameter("pin");
	String landline = request.getParameter("landline");
	String mobile	= request.getParameter("mobile");
	String fax 	= request.getParameter("fax");
	String email 	= request.getParameter("email");
	String contPers1= request.getParameter("contPers1");
	String contPers2= request.getParameter("contPers2");
	
	String vat   	= request.getParameter("vat");
	String cst   	= request.getParameter("cst");
	String pan   	= request.getParameter("pan");
	String servTax  = request.getParameter("servTax");
	String eccNo   	= request.getParameter("eccNo");
	String excRegNo = request.getParameter("excRegNo");
	String rangeSel = request.getParameter("rangeSel");
	String exDiv   	= request.getParameter("exDiv");
	String commi   	= request.getParameter("commi");
	String minIndi 	= request.getParameter("minIndi");
	
	String bankCountry = request.getParameter("bankCountry");
	String bankName    = request.getParameter("bankName");
	String bankRegion  = request.getParameter("bankRegion");
	String bankStreet  = request.getParameter("bankStreet");
	String bankCity    = request.getParameter("bankCity");
	String bankBranch  = request.getParameter("bankBranch");
	String bankIFSCCode= request.getParameter("bankIFSCCode");
	String bankACCode  = request.getParameter("bankACCode");
	String bankCurrency= request.getParameter("bankCurrency");
	
	String pTerms 	   = request.getParameter("pTerms");
	String paymMethod  = request.getParameter("paymMethod");
	String creatDate   = request.getParameter("creatDate");
	String houseBank   = request.getParameter("houseBank");
	String schemaGroup = request.getParameter("schemaGroup");
	
%>
<%@ include file="ezHeader.jsp"%> 
<Html>
<Head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<link rel="stylesheet" href="library/fancybox2/jquery.fancybox.css" type="text/css" media="screen" /> 
<link rel="stylesheet" href="../../Library/JavaScript/jquery-ui-1.12.1.custom/jquery-ui.css">
<link rel="stylesheet" href="../../Library/JavaScript/jquery-ui-1.12.1.custom/style.css">
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



</style>
  
</Head>

  
  <!-- Content Wrapper. Contains page content -->
        <Div class="content-wrapper">
          <!-- Content Header (Page header) -->
          <section class="content-header">
            <h4>
              Vendor Details
            </h4>
          </section>
  
          <!-- Main content -->  
          <section class="content"> 
	<Body>          
        <form method="post"  name="myForm">
<input type="hidden" name="attachFlag" value ="N" >
<input type="hidden" name="attachDocDesc" value ="" >	
<input type="hidden" name="attachFileTime" value ="" >	
<input type="hidden" name="attachDocFiles" value ="" >	


<div id="dialog-editDetails" title="Confirmation" style="display:none"></Div>

	

<Div class="row">
	<Div class=" col-md-12 col-sm-12 col-xs-12"> 
		<Div class="box box-info collapsed-box">
			<Div class="box-header ">
				<h5>&nbsp;&nbsp;&nbsp;&nbsp<B>BASIC DETAILS</B></h5>
				<Div class="box-tools pull-right">
					<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i></button>                
				</Div>
			</Div>
			<Div class="box-body" style="display: block;">
				<Div class="table-responsive">
				<Table class="table no-margin">
				<TBody>
				
				<Tr>
					<Th align=left>Vendor Code<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input  type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=Integer.parseInt(vendCode)%>"  maxlength="10" readonly disabled>
						
					</Td>
					
					<Th align=right>Company Code<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input  type="text" style="text-transform: uppercase;" name="compCode" id="compCode" value="<%=compCode%>"  maxlength="4">
						
					</Td>
					<!--<Th align=right>Service Based<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input  type="text" style="text-transform: uppercase;" name="serBased" id="serBased" value="<%=serBased%>"  maxlength="1">
						
					</Td>-->
					<Th>ServAgntProcGrp<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<select name="procGrp" id="procGrp">
							<option value="<%=procGrp%>" selected><%=procGrp%></option>
						</select>					
															
					</Td>
				</Tr>				
				<Tr>
					<Th align=left>Vendor Name<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input  type="text" style="text-transform: uppercase;" name="venName" id="venName" value="<%=venName%>"  maxlength="35">
						
					</Td>
					<!--<Th align=right>Coromandel Location<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input  type="text" style="text-transform: uppercase;" name="corLoc" id="corLoc" value="<%=corLoc%>"  maxlength="4">
						
					</Td>-->
					<Th align=right>Service Based<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input  type="text" style="text-transform: uppercase;" name="serBased" id="serBased" value="<%=serBased%>"  maxlength="1">

					</Td>
					<Th align=right>GR Based<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input  type="text" style="text-transform: uppercase;" name="grBased" id="grBased" value="<%=grBased%>"  maxlength="1">
						
					</Td>
				</Tr>
				
				
				</TBody>               
				</Table>
				</Div>
			<!-- /.table-responsive -->
			</Div>       
		</Div>

		<Div class="box box-info collapsed-box">
			<Div class="box-header ">
			<h5>&nbsp;&nbsp;&nbsp;&nbsp<B>CONTACT DETAILS</B></h5>
			<Div class="box-tools pull-right">
				<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i></button>                
			</Div>
			</Div>
			<Div class="box-body" style="display: block;">
			<Div class="table-responsive">
			<Table class="table no-margin">
			<TBody>
				<Tr>
					<Th>Title<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<select name="titleSel" id="titleSel">
							<option value="<%=titleSel%>" selected><%=titleSel%></option>
							
						</select>					
						
					</Td>
					<Th>Name1<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input  type="text" style="text-transform: uppercase;" name="name1" id="name1" value="<%=name1%>"  maxlength="35" readonly disabled>
						
					</Td>
					<Th>Name2<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input  type="text" style="text-transform: uppercase;" name="name2" id="name2" value="<%=name2%>"  maxlength="35" readonly disabled>
						
					</Td>
				</Tr>
				
				<Tr>
					<Th>Addr1 / H.No<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input  type="text" style="text-transform: uppercase;" name="addr1" id="addr1" value="<%=addr1%>"  maxlength="10">
						
					</Td>

					<Th>Addr2<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input  type="text" style="text-transform: uppercase;" name="addr2" id="addr2" value="<%=addr2%>"  maxlength="10">
						
					</Td>
					<Th>Street<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input  type="text" style="text-transform: uppercase;" name="street" id="street" value="<%=street%>"  maxlength="60">
						
					</Td>
				</Tr>
				<Tr>
					
					<Th>City<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input  type="text" style="text-transform: uppercase;" name="city" id="city" value="<%=city%>"  maxlength="35">
						
					</Td>
					<Th>State<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<select  name="state" id="state">
							<option value="<%=state%>" selected><%=state%></state>
						</select>					
						
					</Td>
					<Th>Country<font size="2" color="red">*</font></Th>
					<Td>India
						<!--<select  name="country" id="country"  >
				<%		for (int i=0;i<CountryCnt;i++) 
						{
								 key = retCountry.getFieldValueString(i,"EMKV_KEY");
								 value = retCountry.getFieldValueString(i,"EMKV_VALUE");
								 
								//out.println("<<<"+key+"<<<"+value1+"<<<"+value);
 				%>
							<option value="<%=key%>" selected><%=value%></option>
				<%
						}
				%>
						</select>-->					
						<Input  type="hidden"  name="country" id="country" value="IN">
						
					</Td>
				</Tr>
				<Tr>
					<Th>District<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<select  name="district" id="district">
							<option value="<%=district%>" selected><%=district%></option>
						</select>					
						
					</Td>
					
					<Th>PIN<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input  type="text" style="text-transform: uppercase;" name="pin" id="pin" value="<%=pin%>"  maxlength="10">
						
					</Td>
					</Tr>
					<Tr>
					<Th>Landline<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input  type="text" style="text-transform: uppercase;" name="landline" id="landline" value="<%=landline%>"  maxlength="16">
						
					</Td>
					<Th>Mobile<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input  type="text" style="text-transform: uppercase;" name="mobile" id="mobile" value="<%=mobile%>"  maxlength="16">
						
					</Td>
					<Th>FAX<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input  type="text" style="text-transform: uppercase;" name="fax" id="fax" value="<%=fax%>"  maxlength="31">
						
					</Td>
				</Tr>
				<Tr>
					
					<Th>EMail<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input  type="text" style="text-transform: uppercase;" name="email" id="email" value="<%=email%>"  maxlength="241">
						
					</Td>
					<Th>
					Contact Person 1<font size="2" color="red">*</font>
					</Th>
					<Td colspan="4">
					<Input  type="text" style="text-transform: uppercase;" name="contPers1" id="contPers1" value="<%=contPers1%>"  maxlength="10">
					
					</Td>
					<Th>
						Contact Person 2<font size="2" color="red">*</font>
					</Th>
					<Td colspan="4">
					<Input  type="text" style="text-transform: uppercase;" name="contPers2" id="contPers2" value="<%=contPers2%>"  maxlength="10">
					
			</Td>
					
				</Tr>
				
			</TBody>               
			</Table>
			</Div>
			<!-- /.table-responsive -->
			</Div>       
		</Div>            

		<Div class="box box-info collapsed-box">
		<Div class="box-header ">
		<h5>&nbsp;&nbsp;&nbsp;&nbsp<B>STATUTORY</B></h5>
		<Div class="box-tools pull-right">
		<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i>
		</button>                
		</Div>
		</Div>
		<Div class="box-body" style="display: block;">
		<Div class="table-responsive">
		<Table class="table no-margin">
		<TBody><Tr>
		<Th>
		VAT<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<Input  type="text" style="text-transform: uppercase;" name="vat" id="vat" value="<%=vat%>"  maxlength="40">
		
		</Td>
		<Th>
		CST<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<Input  type="text" style="text-transform: uppercase;" name="cst" id="cst" value="<%=cst%>"  maxlength="40">
		
		</Td>
		<Th>
		PAN<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<Input  type="text" style="text-transform: uppercase;" name="pan" id="pan" value="<%=pan%>"  maxlength="40">
		
		</Td>
		</Tr>

		<Tr><Th>
		Service Tax<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<Input  type="text" style="text-transform: uppercase;" name="servTax" id="servTax" value="<%=servTax%>"  maxlength="40">
		
		</Td>
		<Th>
		ECC No<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<Input  type="text" style="text-transform: uppercase;" name="eccNo" id="eccNo" value="<%=eccNo%>"  maxlength="40">
		
		</Td>
		<Th>
		EXC. Reg No<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<Input  type="text" style="text-transform: uppercase;" name="excRegNo" id="excRegNo" value="<%=excRegNo%>"  maxlength="40">
		
		</Td>
		</Tr>
		<Tr>	

		<Th>
		EX. Range<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<select  name="rangeSel" id="rangeSel">
		<option value="<%=state%>" selected><%=state%></option>
		</select>					
		
		</Td>
		<Th>
		EX Division<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<Input  type="text" style="text-transform: uppercase;" name="exDiv" id="exDiv" value="<%=exDiv%>"  maxlength="60">
		
		</Td>
		<Th>
		COMMI<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<Input  type="text" style="text-transform: uppercase;" name="commi" id="commi" value="<%=commi%>"  maxlength="60">
		
		</Td>
		</Tr>
		<Tr>
				
		
				<Th>
				Minority INDI<font size="2" color="red">*</font>
				</Th>
				<Td>
		
				<select  name="minIndi" id="minIndi">
		
				<option value="<%=minIndi%>" selected><%=minIndi%></option>
		
				</select>					
				
		
				</Td>
		</Tr>
		</TBody>               

		</Table>
		</Div>
		<!-- /.table-responsive -->
		</Div>       
		</Div>



			<Div class="box box-info collapsed-box">            
			<Div class="box-header">
						    <h5>&nbsp;&nbsp;&nbsp;&nbsp<B>BANK</B></h5>
						    <Div class="box-tools pull-right">
								    <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i>
								    </button>                   
				      </Div>
				       </Div>
					    <Div class="box-body" style="display: block;">
				      <Div class="table-responsive">
					<Table class="table no-margin">



			<TBody><Tr>
			<Th>
				Country<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input  type="text" style="text-transform: uppercase;" name="bankCountry" id="bankCountry" value="<%=bankCountry%>"  maxlength="3">
			
			</Td>
			<Th>
				Bank Name<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input  type="text" style="text-transform: uppercase;" name="bankName" id="bankName" value="<%=bankName%>"  maxlength="60">
			
			</Td>
			<Th>
				Region<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input  type="text" style="text-transform: uppercase;" name="bankRegion" id="bankRegion" value="<%=bankRegion%>"  maxlength="3">
			
			</Td>
			
			</Tr>

			<Tr><Th>
				Street<font size="2" color="red">*</font>
			 </Th>
			<Td colspan="4">
			<Input  type="text" style="text-transform: uppercase;" name="bankStreet" id="bankStreet" value="<%=bankStreet%>"  maxlength="35">
			
			</Td>
			<Th>
				City<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input  type="text" style="text-transform: uppercase;" name="bankCity" id="bankCity" value="<%=bankCity%>"  maxlength="35">
			
			</Td>
			<Th>
				Branch<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input  type="text" style="text-transform: uppercase;" name="bankBranch" id="bankBranch" value="<%=bankBranch%>"  maxlength="40">
			
			</Td>
			</Tr>
			<Tr>
			<Th>
				IFSC Code<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input  type="text" style="text-transform: uppercase;" name="bankIFSCCode" id="bankIFSCCode" value="<%=bankIFSCCode%>"  maxlength="11">
			
			</Td>

			
			<Th>
				AC Code<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input  type="text" style="text-transform: uppercase;" name="bankACCode" id="bankACCode" value="<%=bankACCode%>"  maxlength="15">
			
			</Td>
			<Th>
				Currency<font size="2" color="red">*</font>
			</Th>
			<Td>	
			<select  name="bankCurrency" id="bankCurrency" readonly disabled>	
			<%	for (int i=0;i<CurrCnt;i++) 
				{
						 currkey = retCurrency.getFieldValueString(i,"EMKV_KEY");
						 currvalue = retCurrency.getFieldValueString(i,"EMKV_VALUE");

						//out.println("<<<"+key+"<<<"+value1+"<<<"+value);
 			%>					
				<option value="<%=currkey%>" selected><%=currvalue%></option>			
			<%
				}
			%>	
			</select>					
			
			
			</Td>

							 </Tr>
							 </TBody>


					</Table>
				      </Div>
				      <!-- /.table-responsive -->
				    </Div>         		

						    </Div>
						    <!-- /.box-header -->

			<Div class="box box-info collapsed-box">            
			<Div class="box-header">
						    <h5>&nbsp;&nbsp;&nbsp;&nbsp<B>PAYMENT DETAILS</B></h5>
						    <Div class="box-tools pull-right">
								    <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i>
								    </button>                   
				      </Div>
				       </Div>
					    <Div class="box-body" style="display: block;">
				      <Div class="table-responsive">
					<Table class="table no-margin">



			<TBody>

			
			<Tr>
			<Th>
				P Terms<font size="2" color="red">*</font>
			</Th>
			<Td colspan="8">

			<select  name="pTerms" id="pTerms">
			<%	for (int i=0;i<PayCnt;i++) 
				{
						 pkey = retPay.getFieldValueString(i,"EMKV_KEY");
						 pvalue = retPay.getFieldValueString(i,"EMKV_VALUE");

						//out.println("<<<"+key+"<<<"+value1+"<<<"+value);
						if(pvalue=="" || "null".equals(pvalue) || "".equals(pvalue))continue;
 			%>
				<option value="<%=pkey%>" selected><%=pvalue%></option>
			<%
				}
			%>	

			</select>					
			

			</Td>	

			<Th>
				Payment Method<font size="2" color="red">*</font>
			</Th>
			<Td colspan="8">
			<Input  type="text" style="text-transform: uppercase;" name="paymMethod" id="paymMethod" value="<%=paymMethod%>"  maxlength="10">
			
			</Td>
			</Tr>
			<Tr>
			<Th>
				House Bank<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input  type="text" style="text-transform: uppercase;" name="houseBank" id="houseBank" value="<%=houseBank%>"  maxlength="5">
			
			</Td>

			<Th>
				Schema Group<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">

			<select  name="schemaGroup" id="schemaGroup">
			<%	for (int i=0;i<SchemaCnt;i++) 
				{
						 schemakey = retSchema.getFieldValueString(i,"EMKV_KEY");
						schemavalue = retSchema.getFieldValueString(i,"EMKV_VALUE");

						//out.println("<<<"+key+"<<<"+value1+"<<<"+value);
				
 			%>
				<option value="<%=schemakey%>" selected><%=schemavalue%></option>
			<%
				}
			%>
			</select>		 			
			

			</Td>	
			<Th>
				Creation Date<font size="2" color="red">*</font>
			 </Th>
			<Td colspan="4">
			<Input  type="text" style="text-transform: uppercase;" name="creatDate" id="creatDate" value="<%=creatDate%>" >
			
			</Td>			

			</Tr>
			
			</TBody>
			</Table>
		</Div>
		<!-- /.table-responsive -->
	</Div>  
	
</Div>
  <div class="form-group">
	                  <label>Comments <font color = red>*</font></label>
	                  <textarea class="form-control" rows="5" placeholder="Enter Comments" name="comments" id="comments" onkeypress="return funtextareaval()"></textarea>
               </div>
<input type="hidden" name="vendCode" id="vendCode" value="<%=vendCode%>" />
<input type="hidden" name="name1" id="name1" value="<%=name1%>" />
<input type="hidden" name="name2" id="name2" value="<%=name2%>" />
<input type="hidden" name="country" id="country" value="<%=key%>" />
<input type="hidden" name="bankCurrency" id="bankCurrency" value="<%=currkey%>" />

<!-- /.box-header -->	
<Div class="col-xs-12 col-md-12" style="padding-right:3px;padding-left:37%">
	<button type="button" class="btn btn-primary" onclick="funBack()">Back</button>
	<button type="button" class="btn btn-primary" onclick="funUpload()">UPLOAD DOCS</button> 
	<button type="button" class="btn btn-primary" onclick="funSubmit()">Submit</button>
</Div>	
	

		

<%//@ include file="../Admin/ezNews.jsp"%>
</form>
</Body>
	

	
        </section><!-- /.content -->
      </Div><!-- /.content-wrapper -->  
      
      



  
<script src="../../Library/JavaScript/jquery-ui-1.12.1.custom/jquery-js.js"></script>
<script src="../../Library/JavaScript/jquery-ui-1.12.1.custom/jquery-ui.js"></script>


<script>
function funSubmit()
   {
   	var vendCode	=document.myForm.vendCode.value.length;
   	var compCode	=document.myForm.compCode.value.length;
   	var serBased	=document.myForm.serBased;
   	var venName  	= document.myForm.venName.value;
   	//var corLoc  	= document.myForm.corLoc.value;   	
   	var grBased  	= document.myForm.grBased.value;   	
   	var procGrp  	= document.myForm.procGrp.value;
   	
   	var titleSel  	= document.myForm.titleSel.value;
   	var name1  	= document.myForm.name1.value;
   	var name2  	= document.myForm.name2.value;
   	var addr1  	= document.myForm.addr1.value;
   	var addr2  	= document.myForm.addr2.value;
   	var street 	= document.myForm.street.value;
   	var city  	= document.myForm.city.value;
   	var state  	= document.myForm.state.value;
   	var country  	= document.myForm.country.value;
   	var district  	= document.myForm.district.value;
	var pin  	= document.myForm.pin.value;
	var landline  	= document.myForm.landline.value;
	var mobile  	= document.myForm.mobile.value;
	var fax  	= document.myForm.fax.value;
	var email  	= document.myForm.email.value;
	var contPers1  	= document.myForm.contPers1.value;
	var contPers2  	= document.myForm.contPers2.value;
	   	
	var vat  	= document.myForm.vat.value;
   	var cst  	= document.myForm.cst.value;
   	var pan  	= document.myForm.pan.value;
	var servTax 	= document.myForm.servTax.value;
	var eccNo  	= document.myForm.eccNo.value;
	var excRegNo 	= document.myForm.excRegNo.value;
	var rangeSel  	= document.myForm.rangeSel.value;
	var exDiv  	= document.myForm.exDiv.value;
	var commi  	= document.myForm.commi.value;
	var minIndi  	= document.myForm.minIndi.value;

	var bankCountry   = document.myForm.bankCountry.value;
   	var bankName  	  = document.myForm.bankName.value;
   	var bankRegion    = document.myForm.bankRegion.value;
   	var bankStreet    = document.myForm.bankStreet.value;
   	var bankCity      = document.myForm.bankCity.value;
   	var bankBranch 	  = document.myForm.bankBranch.value;
   	var bankIFSCCode  = document.myForm.bankIFSCCode.value;
   	var bankACCode 	  = document.myForm.bankACCode.value;
   	var bankCurrency  = document.myForm.bankCurrency.value;
   	
   	var pTerms 	 = document.myForm.pTerms.value;
   	var paymMethod   = document.myForm.paymMethod.value;
   	var creatDate    = document.myForm.creatDate.value;
   	var houseBank    = document.myForm.houseBank.value;
   	var schemaGroup  = document.myForm.schemaGroup.value;  	
   	
   	var count=0;
   	
	
	{	
		$( "#dialog-editDetails" ).dialog("option", "title", "Disclaimer");
		$( "#dialog-editDetails" ).dialog('open').text("Disclaimer Text here.");
	} 
 
   }
   
function funBack() 
{
	document.myForm.action="ezVendorDetails.jsp";
	document.myForm.submit();
}
function funUpload()
		{
			$.fancybox.open({
			
				href : 'ezFileAttachment.jsp',
				type : 'iframe',
				padding : 5,
				width:'60%',
				height:'450px',
				autoSize : false,
				closeBtn : false,
				helpers     : { 
						overlay : {closeClick: true}
				 }
			});
}
$(document).ready(function(){
	$(function() { 
		
   		 $( "#dialog-editDetails" ).dialog({
		 	autoOpen: false,
			resizable: true,
			height:200,
			width:400,
			modal: true,
			buttons: {
				"Disagree": function() {
					$( this ).dialog( "close" );
				},
				"Agree": function() {
					$( this ).dialog( "close" );
					document.generalForm.action="/ezSaveVendorDetails.jsp";
					document.generalForm.submit();
				}
			}
	  	});
		$("#myForm").validate({

			onfocusout: function (element) {
				$(element).valid();
			},
			rules: {
				vendCode: "required",
				compCode: "required",
				serBased: "required",
				venName: {
					required: true,
					minlength: 5
				},
				email: {
					required: true,
					email: true
				}
			},
			messages: {
				vendCode: "Please enter vendor code",
				compCode: "Please enter Company code",
				serBased: "Please enter Service Based",
				venName: {
					required: "Please enter a username",
					minlength: "Your vendor name must consist of at least 5 characters"
				},
				email: "Please enter a valid email address"
			}

		});
	});
});
</script>	

</Html>
<%@ include file="ezFooter.jsp"%> 