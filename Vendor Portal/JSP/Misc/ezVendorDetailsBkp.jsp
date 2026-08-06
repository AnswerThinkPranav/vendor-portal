<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*,java.util.*" %>		
<%@ include file="testJco3.jsp"%>

<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>


<%  					//out.println("::CLIENT::"+CLIENT+"::::"+ADDRNUMBER+"::::"+PERSNUMBER+"::::"+DATE_FROM+"::::"+CONSNUMBER+"::::"+SMTP_ADDR+"::::"+SMTP_SRCH);	 

	String usrId	=	"xyz";     	 
%>
  <%@ include file="ezHeader.jsp"%> 

<Html>
<Head>
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
</style>
<script>
	function funUpload()
		{
			$.fancybox.open({
			alert("hi");
				href : 'attachments/ezCRNFileAttach.jsp',
				type : 'iframe',
				padding : 5,
				width:'60%',
				height:'450px',
				autoSize : false,
				closeBtn : false,
				helpers     : { 
						overlay : {closeClick: false}
				 }
			});
}
</script>
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
	

<Div class="row">
	<Div class=" col-md-12 col-sm-12 col-xs-12"> 
		<Div class="box box-info collapsed-box">
			<Div class="box-header ">
				<h5>&nbsp;&nbsp;&nbsp;&nbsp<B>BASIC DETAILS</B></h5>
				<Div class="box-tools pull-right">
					<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i></button>                
				</Div>
			</Div>
			<Div class="box-body" style="display: none;">
				<Div class="table-responsive">
				<Table class="table no-margin">
				<TBody>
				<Tr>
					<Th align=left>Vendor Code<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=LIFNR%>" onkeypress="return noSpace();" onblur="" maxlength="10">
						<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>
					
					<Th align=right>Company Code<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=BUKRS%>" onkeypress="return noSpace();" onblur="" maxlength="10">
						<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>
					<Th align=right>Service Based<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=LEBRE%>" onkeypress="return noSpace();" onblur="" maxlength="10">
						<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>
				</Tr>				
				<Tr>
					<Th align=left>Vendor Name<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=NAME1+NAME2%>" onkeypress="return noSpace();" onblur="" maxlength="10">
						<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>
					<Th align=right>Coromandel Location<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=EKORG%>" onkeypress="return noSpace();" onblur="" maxlength="10">
						<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>
					<Th align=right>GR Based<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="value" onkeypress="return noSpace();" onblur="" maxlength="10">
						<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>
				</Tr>
				
				<tr>
				<Th>ServAgntProcGrp<font size="2" color="red">*</font></Th>
									<Td colspan="4">
										<select disabled="" name="accNo">
											<option value="G001" selected="">G001--&gt;CORO</option>
										</select>					
										<Input type="hidden" name="BASIC_DETAILS" value="accNo">
					</Td>
				</tr>
				
				
				
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
			<Div class="box-body" style="display: none;">
			<Div class="table-responsive">
			<Table class="table no-margin">
			<TBody>
				<Tr>
					<Th>TITLE<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<select disabled="" name="accNo">
							<option value="<%=ANRED%>" selected=""><%=ANRED%></option>
						</select>					
						<Input type="hidden" name="BASIC_DETAILS" value="accNo">
					</Td>
					<Th>NAME1<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=NAME1%>" onkeypress="return noSpace();" onblur="" maxlength="10">
						<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>
					<Th>NAME2<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=NAME2%>" onkeypress="return noSpace();" onblur="" maxlength="10">
						<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>
				</Tr>
				
				<Tr>
					<Th>ADDR1 / H.No<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=NAME3%>" onkeypress="return noSpace();" onblur="" maxlength="10">
						<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>

					<Th>ADDR2<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=NAME4%>" onkeypress="return noSpace();" onblur="" maxlength="10">
						<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>
					<Th>STREET<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=STRAS%>" onkeypress="return noSpace();" onblur="" maxlength="10">
						<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>
				</Tr>
				<Tr>
					
					<Th>CITY<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=ORT01%>" onkeypress="return noSpace();" onblur="" maxlength="10">
						<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>
					<Th>STATE<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<select disabled="" name="accNo">
							<option value="G001" selected=""><%=REGIO%></option>
						</select>					
						<Input type="hidden" name="BASIC_DETAILS" value="accNo">
					</Td>
					<Th>COUNTRY<font size="2" color="red">*</font></Th>
					<Td>
						<select disabled="" name="accNo">	
							<option value="G001" selected=""><%=LAND1%></option>
						</select>					
						<Input type="hidden" name="BASIC_DETAILS" value="accNo">
					</Td>
				</Tr>
				<Tr>
					<Th>DISTRICT<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<select disabled="" name="accNo">
							<option value="G001" selected=""><%=ORT02%></option>
						</select>					
						<Input type="hidden" name="BASIC_DETAILS" value="accNo">
					</Td>
					
					<Th>PIN<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=PSTL2%>" onkeypress="return noSpace();" onblur="" maxlength="10">
						<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>
					</Tr>
					<Tr>
					<Th>LANDLINE<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=TELF1%>" onkeypress="return noSpace();" onblur="" maxlength="10">
						<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>
					<Th>MOBILE<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=TELF2%>" onkeypress="return noSpace();" onblur="" maxlength="10">
						<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>
					<Th>FAX<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=TELFX%>" onkeypress="return noSpace();" onblur="" maxlength="10">
						<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>
				</Tr>
				<Tr>
					
					<Th>EMAIL<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=SMTP_ADDR%>" onkeypress="return noSpace();" onblur="" maxlength="10">
						<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>
					<Th>
					CONTACT PERSON 1<font size="2" color="red">*</font>
					</Th>
					<Td colspan="4">
					<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=NAMEV%>" onkeypress="return noSpace();" onblur="" maxlength="10">
					<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>
					<Th>
						CONTACT PERSON 2<font size="2" color="red">*</font>
					</Th>
					<Td colspan="4">
					<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=NAME1ConInfo%>" onkeypress="return noSpace();" onblur="" maxlength="10">
					<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
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
		<Div class="box-body" style="display: none;">
		<Div class="table-responsive">
		<Table class="table no-margin">
		<TBody><Tr>
		<Th>
		VAT<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=STCEG%>" onkeypress="return noSpace();" onblur="" maxlength="10">
		<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
		</Td>
		<Th>
		CST<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=J_1ICSTNO%>" onkeypress="return noSpace();" onblur="" maxlength="10">
		<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
		</Td>
		<Th>
		PAN<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=J_1IPANNO%>" onkeypress="return noSpace();" onblur="" maxlength="10">
		<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
		</Td>
		</Tr>

		<Tr><Th>
		SERVICE TAX<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=J_1ISERN%>" onkeypress="return noSpace();" onblur="" maxlength="10">
		<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
		</Td>
		<Th>
		ECC NO<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=J_1IEXCD%>" onkeypress="return noSpace();" onblur="" maxlength="10">
		<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
		</Td>
		<Th>
		EXC. REG NO<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=J_1IEXRN%>" onkeypress="return noSpace();" onblur="" maxlength="10">
		<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
		</Td>
		</Tr>
		<Tr>	

		<Th>
		EX. RANGE<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<select disabled="" name="accNo">
		<option value="G001" selected=""><%=J_1IEXRG%></option>
		</select>					
		<Input type="hidden" name="BASIC_DETAILS" value="accNo">
		</Td>
		<Th>
		EX DIVISION<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=J_1IEXDI%>" onkeypress="return noSpace();" onblur="" maxlength="10">
		<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
		</Td>
		<Th>
		COMMI<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=J_1IEXCO%>" onkeypress="return noSpace();" onblur="" maxlength="10">
		<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
		</Td>
		</Tr>
		<Tr>
				
		
				<Th>
				MINORITY INDI<font size="2" color="red">*</font>
				</Th>
				<Td>
		
				<select disabled="" name="accNo">
		
				<option value="G001" selected="">G001--&gt;CORO</option>
		
				</select>					
				<Input type="hidden" name="BASIC_DETAILS" value="accNo">
		
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
					    <Div class="box-body" style="display: none;">
				      <Div class="table-responsive">
					<Table class="table no-margin">



			<TBody><Tr>
			<Th>
				Country<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=BANKS%>" onkeypress="return noSpace();" onblur="" maxlength="10">
			<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
			</Td>
			<Th>
				Bank Name<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=BANKA%>" onkeypress="return noSpace();" onblur="" maxlength="10">
			<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
			</Td>
			<Th>
				REGION<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=PROVZ%>" onkeypress="return noSpace();" onblur="" maxlength="10">
			<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
			</Td>
			
			</Tr>

			<Tr><Th>
				Street<font size="2" color="red">*</font>
			 </Th>
			<Td colspan="4">
			<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=STRAS%>" onkeypress="return noSpace();" onblur="" maxlength="10">
			<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
			</Td>
			<Th>
				City<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=ORT01%>" onkeypress="return noSpace();" onblur="" maxlength="10">
			<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
			</Td>
			<Th>
				BRANCH<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=BRNCH%>" onkeypress="return noSpace();" onblur="" maxlength="10">
			<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
			</Td>
			</Tr>
			<Tr>
			<Th>
				IFSC Code<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=BANKL%>" onkeypress="return noSpace();" onblur="" maxlength="10">
			<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
			</Td>

			
			<Th>
				AC Code<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=BANKN%>" onkeypress="return noSpace();" onblur="" maxlength="10">
			<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
			</Td>
			<Th>
				CURRENCY<font size="2" color="red">*</font>
			</Th>
			<Td>			
			<select disabled="" name="accNo">			
				<option value="<%=WAERS%>" selected=""><%=WAERS%></option>			
			</select>					
			<Input type="hidden" name="BASIC_DETAILS" value="accNo">
			
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
					    <Div class="box-body" style="display: none;">
				      <Div class="table-responsive">
					<Table class="table no-margin">



			<TBody>

			
			<Tr>
			<Th>
				P TERMS<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">

			<select disabled name="accNo">

				<option value="<%=ZTERMComp%>" selected><%=ZTERMComp%></option>

			</select>					
			<Input type="hidden" name="BASIC_DETAILS" value="accNo">

			</Td>	

			<Th>
				PAYMENT METHOD<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=ZWELS%>" onkeypress="return noSpace();" onblur="" maxlength="10">
			<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
			</Td>
			<Th>
				CREATION DATE<font size="2" color="red">*</font>
			 </Th>
			<Td colspan="4">
			<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=CERDT%>" onkeypress="return noSpace();" onblur="" maxlength="10">
			<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
			</Td>


							 </Tr>
			<Tr>
			<Th>
				HOUSE BANK<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=HBKID%>" onkeypress="return noSpace();" onblur="" maxlength="10">
			<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
			</Td>

			<Th>
				SCHEMA GROUP<font size="2" color="red">*</font>
			</Th>
			<Td>

			<select disabled="" name="accNo">

				<option value="<%=KALSK%>" selected=""><%=KALSK%></option>

			</select>					
			<Input type="hidden" name="BASIC_DETAILS" value="accNo">

			</Td>					

			</Tr>
			
			</TBody>
			</Table>
		</Div>
		<!-- /.table-responsive -->
	</Div>         		
</Div>
<!-- /.box-header -->	
<Div class="col-xs-12 col-md-12" style="padding-right:3px;padding-left:49%">
	<button type="button" class="btn btn-primary" onclick="funEDIT()">EDIT DETAILS</button> 
</Div>	
	
<script>
function funEDIT(){
		document.myForm.action="ezVendorDetailsEdit.jsp";
		document.myForm.submit();
		}
</script>
		

<%//@ include file="../Admin/ezNews.jsp"%>
<link rel="stylesheet" href="../library/fancybox2/jquery.fancybox.css" type="text/css" media="screen" />  
<script type="text/javascript" src="../library/fancybox2/jquery.fancybox.js"></script>
<script type="text/javascript" src="../library/fancybox2/jquery.fancybox.pack.js"></script>
	</form>
	</Body>

	
        </section><!-- /.content -->
      </Div><!-- /.content-wrapper --> 
</Html>
      <%@ include file="ezFooter.jsp"%>
  