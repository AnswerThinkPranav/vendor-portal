<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*,java.util.*" %>		


<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>


<%  
	String usrId	=	"xyz";     	 
%>

  <%@ include file="ezHeader.jsp"%> 
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
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
						<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>
					<Th align=right>Company Code<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
						<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>
					<Th align=right>Service Based<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
						<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>
				</Tr>				
				<Tr>
					<Th align=left>Vendor Name<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
						<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>
					<Th align=right>Coromandel Location<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
						<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>
					<Th align=right>GR Based<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
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
			<Div class="box-body" style="display: block;">
			<Div class="table-responsive">
			<Table class="table no-margin">
			<TBody>
				<Tr>
					<Th>TITLE<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<select disabled="" name="accNo">
							<option value="G001" selected="">G001--&gt;CORO</option>
						</select>					
						<Input type="hidden" name="BASIC_DETAILS" value="accNo">
					</Td>
					<Th>NAME1<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
						<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>
					<Th>NAME2<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
						<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>
				</Tr>
				
				<Tr>
					<Th>ADDR1 / H.No<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
						<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>

					<Th>ADDR2<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
						<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>
					<Th>STREET<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
						<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>
				</Tr>
				<Tr>
					
					<Th>CITY<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
						<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>
					<Th>STATE<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<select disabled="" name="accNo">
							<option value="G001" selected="">G001--&gt;CORO</option>
						</select>					
						<Input type="hidden" name="BASIC_DETAILS" value="accNo">
					</Td>
					<Th>COUNTRY<font size="2" color="red">*</font></Th>
					<Td>
						<select disabled="" name="accNo">	
							<option value="G001" selected="">G001--&gt;CORO</option>
						</select>					
						<Input type="hidden" name="BASIC_DETAILS" value="accNo">
					</Td>
				</Tr>
				<Tr>
					<Th>DISTRICT<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<select disabled="" name="accNo">
							<option value="G001" selected="">G001--&gt;CORO</option>
						</select>					
						<Input type="hidden" name="BASIC_DETAILS" value="accNo">
					</Td>
					
					<Th>PIN<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
						<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>
					</Tr>
					<Tr>
					<Th>LANDLINE<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
						<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>
					<Th>MOBILE<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
						<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>
					<Th>FAX<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
						<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>
				</Tr>
				<Tr>
					
					<Th>EMAIL<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
						<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>
					<Th>
					CONTACT PERSON 1<font size="2" color="red">*</font>
					</Th>
					<Td colspan="4">
					<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
					<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
					</Td>
					<Th>
						CONTACT PERSON 2<font size="2" color="red">*</font>
					</Th>
					<Td colspan="4">
					<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
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
		<Div class="box-body" style="display: block;">
		<Div class="table-responsive">
		<Table class="table no-margin">
		<TBody><Tr>
		<Th>
		VAT<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
		<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
		</Td>
		<Th>
		CST<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
		<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
		</Td>
		<Th>
		PAN<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
		<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
		</Td>
		</Tr>

		<Tr><Th>
		SERVICE TAX<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
		<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
		</Td>
		<Th>
		ECC NO<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
		<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
		</Td>
		<Th>
		EXC. REG NO<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
		<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
		</Td>
		</Tr>
		<Tr>	

		<Th>
		EX. RANGE<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<select disabled="" name="accNo">
		<option value="G001" selected="">G001--&gt;CORO</option>
		</select>					
		<Input type="hidden" name="BASIC_DETAILS" value="accNo">
		</Td>
		<Th>
		EX DIVISION<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
		<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
		</Td>
		<Th>
		COMMI<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
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
					    <Div class="box-body" style="display: block;">
				      <Div class="table-responsive">
					<Table class="table no-margin">



			<TBody><Tr>
			<Th>
				Country<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
			<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
			</Td>
			<Th>
				Bank Name<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
			<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
			</Td>
			<Th>
				REGION<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
			<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
			</Td>
			
			</Tr>

			<Tr><Th>
				Street<font size="2" color="red">*</font>
			 </Th>
			<Td colspan="4">
			<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
			<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
			</Td>
			<Th>
				City<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
			<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
			</Td>
			<Th>
				BRANCH<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
			<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
			</Td>
			</Tr>
			<Tr>
			<Th>
				IFSC Code<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
			<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
			</Td>

			
			<Th>
				AC Code<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
			<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
			</Td>
			<Th>
				CURRENCY<font size="2" color="red">*</font>
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
				P TERMS<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">

			<select disabled="" name="accNo">

				<option value="G001" selected="">G001--&gt;CORO</option>

			</select>					
			<Input type="hidden" name="BASIC_DETAILS" value="accNo">

			</Td>	

			<Th>
				PAYMENT METHOD<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
			<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
			</Td>
			<Th>
				CREATION DATE<font size="2" color="red">*</font>
			 </Th>
			<Td colspan="4">
			<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
			<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
			</Td>


							 </Tr>
			<Tr>
			<Th>
				HOUSE BANK<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input readonly="" type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="1314R0745" onkeypress="return noSpace();" onblur="" maxlength="10">
			<Input type="hidden" name="BASIC_DETAILS" value="vendCode">
			</Td>

			<Th>
				SCHEMA GROUP<font size="2" color="red">*</font>
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
<!-- /.box-header -->	
<Div class="col-xs-12 col-md-12" style="padding-right:3px;padding-left:49%">
	<button type="button" class="btn btn-primary" onclick="funUpload()">UPLOAD DOCS</button> 
</Div>	
	

		

<%//@ include file="../Admin/ezNews.jsp"%>
<link rel="stylesheet" href="../library/fancybox2/jquery.fancybox.css" type="text/css" media="screen" />  
<script type="text/javascript" src="../library/fancybox2/jquery.fancybox.js"></script>
<script type="text/javascript" src="../library/fancybox2/jquery.fancybox.pack.js"></script>
	</form>

	
        </section><!-- /.content -->
      </Div><!-- /.content-wrapper -->  
      <%@ include file="ezFooter.jsp"%>           