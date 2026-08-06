<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*,java.util.*" %>		
<%@ include file="ezTestJCo3.jsp"%>

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
	
</script>
</Head>
<!-- Content Wrapper. Contains page content -->
      <Div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
          <h4>
            <B>Vendor Details</B>
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
				<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i><B>&nbsp;&nbsp;<Font size=2 color=BLACK>BASIC DETAILS</Font></B></button>                
			</Div>
			<Div class="box-body" style="display: none;">
				<Div class="table-responsive">
				<Table class="table no-margin">
				<TBody>
				<Tr>
					<Th align=left>Vendor Code<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=LIFNR%>"  maxlength="10" required>
					</Td>
					<Th align=right>Company Code<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="compCode" id="compCode" value="<%=BUKRS%>"  maxlength="4">
					</Td>
					<!--<Th align=right>Service Based<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="serBased" id="serBased" value="<%=LEBRE%>"  maxlength="1">
					</Td>-->
					<Th>ServAgntProcGrp<font size="2" color="red">*</font></Th>
					<Td colspan="4">
					<Input readonly  type="text" style="text-transform: uppercase;" name="procGrp" id="procGrp" value="<%=DLGRP%>"  maxlength="3">																				
					</Td>
				</Tr>				
				<Tr>
					<Th align=left>Vendor Name<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="venName" id="venName" value="<%=NAME1+NAME2%>"  maxlength="35">

					</Td>
					<Th align=right>Service Based<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="serBased" id="serBased" value="<%=LEBRE%>"  maxlength="1">
					</Td>					
					<!--<Th align=right>Coromandel Location<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="corLoc" id="corLoc" value="<%=EKORG%>"  maxlength="4">

					</Td>-->
					<Th align=right>GR Based<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="grBased" id="grBased" value="Y"  maxlength="1">

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
				<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i><B>&nbsp;&nbsp;<Font size=2 color=BLACK>CONTACT DETAILS</Font></B></button>                
			</Div>
			
			<Div class="box-body" style="display: none;">
			<Div class="table-responsive">
			<Table class="table no-margin">
			<TBody>
				<Tr>
					<Th>Title<font size="2" color="red">*</font></Th>
					<Td colspan="4">
					<Input readonly  type="text" style="text-transform: uppercase;"  value="<%=ANRED%>"  maxlength="4">
						<!--<select disabled name="titleSel" id="titleSel">
							<option value="<%=ANRED%>" selected><%=ANRED%></option>
							<option value="mrs.">mrs.</option>
							<option value="m/s">m/s</option>
						</select>					-->

					</Td>
					<Th>Name1<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="name1" id="name1" value="<%=NAME1%>"  maxlength="35">

					</Td>
					<Th>Name2<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="name2" id="name2" value="<%=NAME2%>"  maxlength="35">
											
					</Td>
				</Tr>
				
				<Tr>
					<Th>Addr1 / H.No<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="addr1" id="addr1" value="<%=NAME3%>"  maxlength="10">

					</Td>

					<Th>Addr2<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="addr2" id="addr2" value="<%=NAME4%>"  maxlength="10">

					</Td>
					<Th>Street<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="street" id="street" value="<%=STRAS%>"  maxlength="60">
											
					</Td>
				</Tr>
				<Tr>
					
					<Th>City<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="city" id="city" value="<%=ORT01%>"  maxlength="35">

					</Td>
					<Th>State<font size="2" color="red">*</font></Th>
					<Td colspan="4">
					<Input readonly  type="text" style="text-transform: uppercase;" name="state" id="state" value="<%=REGIO%>"  maxlength="2">
						<!--<select disabled  name="state" id="state">
							<option value="<%=REGIO%>" selected><%=REGIO%></option>
						</select>					-->

					</Td>
					<Th>Country<font size="2" color="red">*</font></Th>
					<Td>
					<Input readonly  type="text" style="text-transform: uppercase;" name="country" id="country" value="<%=LAND1%>"  maxlength="2">
						<!--<select disabled  name="country" id="country">	
							<option value="<%=LAND1%>" selected><%=LAND1%></option>
						</select>					-->

					</Td>
				</Tr>
				<Tr>
					<Th>District<font size="2" color="red">*</font></Th>
					<Td colspan="4">
					<Input readonly  type="text" style="text-transform: uppercase;" name="district" id="district" value="<%=ORT02%>"  maxlength="20">
						<!--<select disabled  name="district" id="district">
							<option value="<%=ORT02%>" selected><%=ORT02%></option>
						</select>					-->

					</Td>

					<Th>Pin<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="pin" id="pin" value="<%=PSTLZ%>"  maxlength="10">

					</Td>
					</Tr>
					<Tr>
					<Th>Landline<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="landline" id="landline" value="<%=TELF2%>"  maxlength="16">

					</Td>
					<Th>Mobile<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="mobile" id="mobile" value="<%=TELF1%>"  maxlength="16">

					</Td>
					<Th>Fax<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="fax" id="fax" value="<%=TELFX%>"  maxlength="31">
											
					</Td>
				</Tr>
				 <Tr>
					<Th>EMail<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="email" id="email" value="<%=SMTP_ADDR%>"  maxlength="241">
					</Td>
					<Th>Contact Person 1<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="contPers1" id="contPers1" value="<%=NAMEV%>"  maxlength="10">
					</Td>
					<Th>Contact Person 2<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="contPers2" id="contPers2" value="<%=NAME1ConInfo%>"  maxlength="10">
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
			<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i><B>&nbsp;&nbsp;<Font size=2 color=BLACK>STATUTORY</Font></B></button>                
		</Div>
		<Div class="box-body" style="display: none;">
		<Div class="table-responsive">
		<Table class="table no-margin">
		<TBody>
			<Tr>
				<Th>VAT<font size="2" color="red">*</font></Th>
				<Td colspan="4">
					<Input readonly  type="text" style="text-transform: uppercase;" name="vat" id="vat" value="<%=STCEG%>"  maxlength="40">
				</Td>
				<Th>CST<font size="2" color="red">*</font></Th>
				<Td colspan="4">
					<Input readonly  type="text" style="text-transform: uppercase;" name="cst" id="cst" value="<%=J_1ICSTNO%>"  maxlength="40">
				</Td>
				<Th>PAN<font size="2" color="red">*</font></Th>
				<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="pan" id="pan" value="<%=J_1IPANNO%>"  maxlength="40">
				</Td>
			</Tr>

			<Tr>
				<Th>Service Tax<font size="2" color="red">*</font></Th>
				<Td colspan="4">
					<Input readonly  type="text" style="text-transform: uppercase;" name="servTax" id="servTax" value="<%=J_1ISERN%>"  maxlength="40">
				</Td>
				<Th>Ecc No<font size="2" color="red">*</font></Th>
				<Td colspan="4">
					<Input readonly  type="text" style="text-transform: uppercase;" name="eccNo" id="eccNo" value="<%=J_1IEXCD%>"  maxlength="40">
				</Td>
				<Th>Exc. Reg No<font size="2" color="red">*</font></Th>
				<Td colspan="4">
					<Input readonly  type="text" style="text-transform: uppercase;" name="excRegNo" id="excRegNo" value="<%=J_1IEXRN%>"  maxlength="40">
				</Td>
			</Tr>
			<Tr>	
				<Th>Ex. Range<font size="2" color="red">*</font></Th>
				<Td colspan="4">
				<Input readonly  type="text" style="text-transform: uppercase;" name="rangeSel" id="rangeSel" value="<%=J_1IEXRG%>"  maxlength="10">
					<!--<select disabled  name="rangeSel" id="rangeSel">
						<option value="<%=J_1IEXRG%>" selected><%=J_1IEXRG%></option>
					</select>					-->
				</Td>
				<Th>Ex Division<font size="2" color="red">*</font></Th>
				<Td colspan="4">
					<Input readonly  type="text" style="text-transform: uppercase;" name="exDiv" id="exDiv" value="<%=J_1IEXDI%>"  maxlength="60">
				</Td>
				<Th>CommI<font size="2" color="red">*</font></Th>
				<Td colspan="4">
					<Input readonly  type="text" style="text-transform: uppercase;" name="commi" id="commi" value="<%=J_1IEXCO%>"  maxlength="60">
				</Td>
			</Tr>
			<Tr>
				<Th>Minority Indi<font size="2" color="red">*</font></Th>
				<Td>
				<Input readonly  type="text" style="text-transform: uppercase;" name="minIndi" id="minIndi" value="<%=MINDK%>"  maxlength="2">
					<!--<select disabled  name="minIndi" id="minIndi">
						<option value="G001" selected><%=MINDK%></option>
					</select>					-->
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
				<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i><B>&nbsp;&nbsp;<Font size=2 color=BLACK>BANK</Font></B></button>                
			</Div>	  
					    <Div class="box-body" style="display: none;">
				      <Div class="table-responsive">
					<Table class="table no-margin">



			<TBody><Tr>
			<Th>
				Country<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input readonly  type="text" style="text-transform: uppercase;" name="bankCountry" id="bankCountry" value="<%=BANKS%>"  maxlength="3">

			</Td>
			<Th>
				Bank Name<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input readonly  type="text" style="text-transform: uppercase;" name="bankName" id="bankName" value="<%=BANKA%>"  maxlength="60">

			</Td>
			<Th>
				Region<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input readonly  type="text" style="text-transform: uppercase;" name="bankRegion" id="bankRegion" value="<%=PROVZ%>"  maxlength="3">

			</Td>

			</Tr>

			<Tr><Th>
				Street<font size="2" color="red">*</font>
			 </Th>
			<Td colspan="4">
			<Input readonly  type="text" style="text-transform: uppercase;" name="bankStreet" id="bankStreet" value="<%=STRASBank%>"  maxlength="35">

			</Td>
			<Th>
				City<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input readonly  type="text" style="text-transform: uppercase;" name="bankCity" id="bankCity" value="<%=ORT01Bank%>"  maxlength="35">

			</Td>
			<Th>
				Branch<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input readonly  type="text" style="text-transform: uppercase;" name="bankBranch" id="bankBranch" value="<%=BRNCH%>"  maxlength="40">

			</Td>
			</Tr>
			<Tr>
			<Th>
				IFSC Code<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input readonly  type="text" style="text-transform: uppercase;" name="bankIFSCCode" id="bankIFSCCode" value="<%=BKREF%>"  maxlength="11">

			</Td>


			<Th>
				AC Code<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input readonly  type="text" style="text-transform: uppercase;" name="bankACCode" id="bankACCode" value="<%=BANKN%>"  maxlength="15">

			</Td>
			<Th>
				Currency<font size="2" color="red">*</font>
			</Th>
			<Td>	
			<Input readonly  type="text" style="text-transform: uppercase;" name="bankCurrency" id="bankCurrency" value="<%=WAERS%>"  maxlength="3">
			<!--<select disabled  name="bankCurrency" id="bankCurrency">			
				<option value="<%=WAERS%>" selected><%=WAERS%></option>		
			</select>	-->				


			</Td>

			 </Tr>
			 </TBody>


			</Table>
				      </Div>
				      <!-- /.table-responsive -->
				    </Div>         		

						    </Div>
						    <!-- /.box-header -->

			<!--<Div class="box box-info collapsed-box">            
			<Div class="box-header ">
				<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i><B>&nbsp;&nbsp;<Font size=2 color=BLACK>PAYMENT DETAILS</Font></B></button>                
			</Div>	       
					    <Div class="box-body" style="display: none;">
				      <Div class="table-responsive">
					<Table class="table no-margin">



			<TBody>

			
			<Tr>
				<Th>
					P Terms<font size="2" color="red">*</font>
				</Th>
				<Td colspan="4">
					<Input readonly  type="text" style="text-transform: uppercase;" name="pTerms" id="pTerms" value="<%=ZTERMComp%>"  maxlength="4">
				<!--<select disabled  name="pTerms" id="pTerms">

					<option value="<%=ZTERMComp%>" selected><%=ZTERMComp%></option>

				</select>-->					


				</Td>	

				<Th>
					Payment Method<font size="2" color="red">*</font>
				</Th>
				<Td colspan="4">
				<Input readonly  type="text" style="text-transform: uppercase;" name="paymMethod" id="paymMethod" value="<%=ZWELS%>"  maxlength="10">

				</Td>
				<Th>
					Creation Date<font size="2" color="red">*</font>
				 </Th>
				<Td colspan="4">
				<Input readonly  type="text" style="text-transform: uppercase;" name="creatDate" id="creatDate" value="<%=CERDT%>" >

				</Td>


			 </Tr>
			<Tr>
				<Th>
					House Bank<font size="2" color="red">*</font>
				</Th>
				<Td colspan="4">
				<Input readonly  type="text" style="text-transform: uppercase;" name="houseBank" id="houseBank" value="<%=HBKID%>"  maxlength="5">

				</Td>

				<Th>
					Schema Group<font size="2" color="red">*</font>
				</Th>
				<Td>
					<Input readonly  type="text" style="text-transform: uppercase;" name="schemaGroup" id="schemaGroup" value="<%=KALSK%>"  maxlength="2">
				<!--<select disabled name="schemaGroup" id="schemaGroup">

					<option value="<%=KALSK%>" selected=""><%=KALSK%></option>

				</select>					-->


				</Td>					

			</Tr>
			
			</TBody>
			</Table>
		</Div>
		<!-- /.table-responsive -->
	</Div>         		
</Div>-->
<!-- /.box-header -->	
<Div class="col-xs-12 col-md-12" style="padding-right:3px;padding-left:49%">
	<button type="button" class="btn btn-primary" onclick="funEDIT()">EDIT DETAILS</button> 
</Div>	
<input type="hidden" name="titleSel" id="titleSel" value="<%=ANRED%>" />	
<script>
function funEDIT()
{
 	var titleSel= document.myForm.titleSel.value;
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
  