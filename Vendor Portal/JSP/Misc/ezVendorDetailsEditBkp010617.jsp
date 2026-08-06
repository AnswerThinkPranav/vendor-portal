<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*,java.util.*" %>		
<%@ include file="iVendorDetails.jsp" %>


<%
//out.println("<<<"+key+"<<<"+value+"<<<"+value);
%>

<%  

	Hashtable stateHT= new Hashtable();
	String usrId	=	"xyz";
	String selected="";
	String titleSelArr[] = {"Mr.", "Ms.", "Company", "Mr. and Mrs." };
	
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
	String gst 	= request.getParameter("gst");
	
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
<Script src="../../Library/JavaScript/Script/popup.js"></Script> 
<Script src="../../Library/JavaScript/Script/jquery-1.8.3.js"></Script> 
<link rel="stylesheet" type="text/css" href="../../Library/JavaScript/Script/formalize.css">
<script type="text/javascript" src="../../Library/JavaScript/Script/jquery.formalize.js"></script>
<script type="text/javascript" src="../../Library/JavaScript/Script/jquery.validate.js"></script>

<!--Stylesheets-->

<link rel="stylesheet" type="text/css" href="../../Library/JavaScript/Script/jquery-ui-1.8.23.custom" />
<link rel="stylesheet" type="text/css" href="../../Library/JavaScript/Script/jquery.qtip.min-latest.css" />
<link rel="stylesheet" href="https://jqueryvalidation.org/files/demo/site-demos.css">
<!--JavaScript - Might want to move these to the footer of the page to prevent blocking-->
<script type="text/javascript" src="../../Library/JavaScript/Script/jquery.qtip.min-latest.js"></script>

<script type="text/javascript">
function funSubmit()
   {
   	var vendCode	=document.myForm.vendCode.value;
   	var compCode	=document.myForm.compCode.value;
   	//var serBased	=document.myForm.serBased.value;
   	var venName  	= document.myForm.venName.value;
   	var grBased  	= document.myForm.grBased.value;   	
   	//var procGrp  	= document.myForm.procGrp.value;
   	
   	//var titleSel  	= document.myForm.titleSel.value;
   	var name1  	= document.myForm.name1.value;
   	var name2  	= document.myForm.name2.value;
   	var addr1  	= document.myForm.addr1.value;
   	var addr2  	= document.myForm.addr2.value;
   	var street 	= document.myForm.street.value;
   	var city  	= document.myForm.city.value;
   	//var state  	= document.myForm.state.value;
   	var country  	= document.myForm.country.value;
   	//var district  	= document.myForm.district.value;
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
	var gst  	= document.myForm.gst.value;

	var bankCountry   = document.myForm.bankCountry.value;
   	var bankName  	  = document.myForm.bankName.value;
   	var bankRegion    = document.myForm.bankRegion.value;
   	var bankStreet    = document.myForm.bankStreet.value;
   	var bankCity      = document.myForm.bankCity.value;
   	var bankBranch 	  = document.myForm.bankBranch.value;
   	var bankIFSCCode  = document.myForm.bankIFSCCode.value;
   	var bankACCode 	  = document.myForm.bankACCode.value;
   	var bankCurrency  = document.myForm.bankCurrency.value;

   	/*if((contPers1.length)>8 || isNaN(contPers1.value))
   	{
   		document.getElementById("contPers1Msg").style.display="block";
		document.myForm.contPers1.focus();
		return false;
   	}
   	
   	
	else if (!(/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(myForm.email.value)))  
	{
		document.getElementById("emailMsg").style.display="block";
		document.myForm.email.focus();
		return false;
	}  */
	
	
	var attachType= document.myForm.attachType.value;

	var changedStatutoryDetails="";
	var vat_old  	= document.myForm.vat_old.value;
	var cst_old  	= document.myForm.cst_old.value;
	var pan_old  	= document.myForm.pan_old.value;
	var servTax_old 	= document.myForm.servTax_old.value;
	var eccNo_old  	= document.myForm.eccNo_old.value;
	var excRegNo_old 	= document.myForm.excRegNo_old.value;
	var rangeSel_old  	= document.myForm.rangeSel_old.value;
	var exDiv_old  	= document.myForm.exDiv_old.value;
	var commi_old  	= document.myForm.commi_old.value;
	var minIndi_old  	= document.myForm.minIndi_old.value;
	var gst_old  	= document.myForm.gst_old.value;
	
	if(vat_old!=vat || cst_old!=cst || gst_old!=gst || minIndi_old!=minIndi || commi_old!=commi || exDiv_old!=exDiv || rangeSel_old!=rangeSel || excRegNo_old!=excRegNo || eccNo_old!=eccNo || servTax_old!=servTax || pan_old!=pan)
	{
		changedStatutoryDetails="STATUTORY";
	}
	/*if(changedStatutoryDetails!="" && attachType.indexOf(changedStatutoryDetails)<0)
	{
		alert("As Statutory details are changed please upload respective files");
		return;			
	}*/
	
	var changedBankDetails="";
	var bankCountry_old   = document.myForm.bankCountry_old.value;
	var bankName_old  	  = document.myForm.bankName_old.value;
	var bankRegion_old    = document.myForm.bankRegion_old.value;
	var bankStreet_old    = document.myForm.bankStreet_old.value;
	var bankCity_old      = document.myForm.bankCity_old.value;
	var bankBranch_old 	  = document.myForm.bankBranch_old.value;
	var bankIFSCCode_old  = document.myForm.bankIFSCCode_old.value;
	var bankACCode_old 	  = document.myForm.bankACCode_old.value;
   	var bankCurrency_old  = document.myForm.bankCurrency_old.value;
   	
   	
   	if(bankCurrency_old!=bankCurrency || bankACCode_old!=bankACCode || bankBranch_old!=bankBranch || bankIFSCCode_old!=bankIFSCCode || bankCountry_old!=bankCountry || bankName_old!=bankName || bankRegion_old!=bankRegion || bankStreet_old!=bankStreet || bankCity_old!=bankCity)
	{
		changedBankDetails=bankACCode_old;
	}
	
	
	/*if(changedBankDetails!="" && attachType.indexOf(changedBankDetails)<0)
	{
		alert("As bank AC code :"+changedBankDetails+" details are changed please upload respective files");
		return;
		
	}*/
	
	{	
		$( "#dialog-editDetails" ).dialog("option", "title", "Disclaimer");
		$( "#dialog-editDetails" ).dialog('open').text("Any changes made on portal will reflect post verification by company.");
	} 
 
   }
   
function funBack() 
{
	document.myForm.action="ezVendorDetails.jsp";
	document.myForm.submit();
}

$(function() { 
		
	 $( "#dialog-editDetails" ).dialog({
	 	
		autoOpen: false,
		resizable: true,
		height:200,
		width:400,
		modal: true,
		buttons: {
			
			"Agree": function() {
				$( this ).dialog( "close" );
				document.myForm.action="ezSaveVendorDetails.jsp";
				document.myForm.submit();
			},
			"Disagree": function() {
				$( this ).dialog( "close" );
			}
		}
	});
	
});
</script>	

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
.ui-draggable .ui-dialog-titlebar {
    background: #f39c12;
}

</style>
<link rel="stylesheet" href="../../Library/JavaScript/jquery-ui-1.12.1.custom/jquery-ui.css">

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
<input type="hidden" name="attachType" value ="" >	


<div id="dialog-editDetails" title="Confirmation" style="display:none"></Div>

	

<Div class="row">
	<Div class=" col-md-12 col-sm-12 col-xs-12"> 
		<Div class="box box-info collapsed-box">
			<Div class="box-header ">
				<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i><B>&nbsp;&nbsp;<Font size=2 color=BLACK>BASIC DETAILS</Font></B></button>                
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
						<Input  type="text" style="text-transform: uppercase;" name="compCode" id="compCode" value="<%=compCode%>"  maxlength="4" disabled>
						
					</Td>
					<!--<Th align=right>Service Based<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input  type="text" style="text-transform: uppercase;" name="serBased" id="serBased" value="<%=serBased%>"  maxlength="1">
						
					</Td>-->
					<!--<Th>ServAgntProcGrp<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<select name="procGrp" id="procGrp" >
							<option value="<%=procGrp%>" selected><%=procGrp%></option>
						</select>					
															
					</Td>-->
					<Th align=left>Vendor Name<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<Input  type="text" style="text-transform: uppercase;" name="venName" id="venName" value="<%=venName%>"  maxlength="35" disabled>
											
					</Td>
				</Tr>				
				<Tr>
					
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
						<Input  type="radio" style="text-transform: uppercase;" name="grBased" id="grBased" value="Y"  maxlength="1" checked>&nbsp;Yes &nbsp;&nbsp;&nbsp;
						<Input  type="radio" style="text-transform: uppercase;" name="grBased" id="grBased" value="N"  maxlength="1">&nbsp;No
											
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
				<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i><B>&nbsp;&nbsp;<Font size=2 color=BLACK>CONTACT DETAILS</Font></B></button>                
			</Div>
			<Div class="box-body" style="display: block;">
			<Div class="table-responsive">
			<Table class="table no-margin">
			<TBody>
				<Tr>
					<Th>Title<font size="2" color="red">*</font></Th>
					<Td colspan="4">
						<select name="titleSel" id="titleSel">
						<%
						for(int i=0; i<titleSelArr.length; i++)
						{
							if(titleSel.equals(titleSelArr[i]))
							{
								selected="selected";
						%>
							<option value="<%=titleSelArr[i]%>" <%=selected%>><%=titleSelArr[i]%></option>
						<%
							}else
							{
								selected="";
						%>
							<option value="<%=titleSelArr[i]%>" <%=selected%>><%=titleSelArr[i]%></option>
						<%
							}
						}
						%>
							
							
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
					<%
					for (int i=0;i<StateCnt;i++) 
					{
						 statekey = retState.getFieldValueString(i,"EMKV_VALUE");
						  statevalue = retState.getFieldValueString(i,"EMKV_VALUE1");
						stateHT.put(statekey,statevalue);
						//out.println("<<<"+statekey+"<<<<<<"+stateHT.get(statekey));
						
						
						String statef =(String)stateHT.get(statekey);
						statef = statef.trim();
						//out.println(state+"<<<"+statekey+"<<<<<<"+stateHT.get(state));
						if(state.equals(statekey))
						{
							selected="selected";
						//out.println("::::::"+"TN".equals(statekey));
							
					%>		
							<option value="<%=statekey%>" <%=selected%> ><%=statef%>--<%=statekey%></option>
					<%	}else
						{
							selected="";
					%>
							<option value="<%=statekey%>" <%=selected%> ><%=statef%>--<%=statekey%></option>
					<%
						}
					}
					%>
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
						<p id="emailMsg" style="display:none"><font color="red">Please enter valid Email Id</font></p
					</Td>
					<Th>
					Contact Person 1<font size="2" color="red">*</font>
					</Th>
					<Td colspan="4">
					<Input  type="text" style="text-transform: uppercase;" name="contPers1" id="contPers1" value="<%=contPers1%>"  maxlength="10">
					<p id="contPers1Msg" style="display:none"><font color="red">Contact person 1 length should not exceed 10</font></p>
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
			<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i><B>&nbsp;&nbsp;<Font size=2 color=BLACK>STATUTORY</Font></B></button>                
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
		<Input  type="hidden" name="vat_old" id="vat_old" value="<%=vat%>"  >
		</Td>
		<Th>
		CST<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<Input  type="text" style="text-transform: uppercase;" name="cst" id="cst" value="<%=cst%>"  maxlength="40">
		<Input  type="hidden" name="cst_old" id="cst_old" value="<%=cst%>" >
		
		</Td>
		<Th>
		PAN<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<Input  type="text" style="text-transform: uppercase;" name="pan" id="pan" value="<%=pan%>"  maxlength="40">
		<Input  type="hidden" name="pan_old" id="pan_old" value="<%=pan%>" >
		</Td>
		</Tr>

		<Tr><Th>
		Service Tax<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<Input  type="text" style="text-transform: uppercase;" name="servTax" id="servTax" value="<%=servTax%>"  maxlength="40">
		<Input  type="hidden" name="servTax_old" id="servTax_old" value="<%=servTax%>" >
		</Td>
		<Th>
		ECC No<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<Input  type="text" style="text-transform: uppercase;" name="eccNo" id="eccNo" value="<%=eccNo%>"  maxlength="40">
		<Input  type="hidden" name="eccNo_old" id="eccNo_old" value="<%=eccNo%>" >
		</Td>
		<Th>
		EXC. Reg No<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<Input  type="text" style="text-transform: uppercase;" name="excRegNo" id="excRegNo" value="<%=excRegNo%>"  maxlength="40">
		<Input  type="hidden" name="excRegNo_old" id="excRegNo_old" value="<%=excRegNo%>"  >
		</Td>
		</Tr>
		<Tr>	

		<Th>
		EX. Range<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<input type="hidden"  name="rangeSel_old" id="rangeSel_old" value="<%=state%>">
		<select  name="rangeSel" id="rangeSel">
		<option value="<%=state%>" selected><%=state%></option>
		</select>					
		
		</Td>
		<Th>
		EX Division<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<Input  type="text" style="text-transform: uppercase;" name="exDiv" id="exDiv" value="<%=exDiv%>"  maxlength="60">
		<Input  type="hidden" name="exDiv_old" id="exDiv_old" value="<%=exDiv%>"  >
		</Td>
		<Th>
		COMMI<font size="2" color="red">*</font>
		</Th>
		<Td colspan="4">
		<Input  type="text" style="text-transform: uppercase;" name="commi" id="commi" value="<%=commi%>"  maxlength="60">
		<Input  type="hidden" name="commi_old" id="commi_old" value="<%=commi%>"  >
		</Td>
		</Tr>
		<Tr>
				
		
				<Th>
				Minority INDI<font size="2" color="red">*</font>
				</Th>
				<Td colspan="4">
				<input type="hidden"  name="minIndi_old" id="minIndi_old" value="<%=minIndi%>">
				<select  name="minIndi" id="minIndi">
		
				<option value="<%=minIndi%>" selected><%=minIndi%></option>
		
				</select>					
				
		
				</Td>
				
				<Th>
					GST<font size="2" color="red">*</font>
					</Th>
					<Td colspan="4">
					<Input  type="text" style="text-transform: uppercase;" name="gst" id="gst" value="<%=gst%>"  maxlength="4">
					<Input  type="hidden" name="gst_old" id="gst_old" value="<%=gst%>"  >
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
				<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i><B>&nbsp;&nbsp;<Font size=2 color=BLACK>BANK (<%=bankACCode%>)</Font></B></button>                		    
		       </Div>
			    <Div class="box-body" style="display: block;">
		      <Div class="table-responsive">
			<Table class="table no-margin">



			<TBody><Tr>
			<Th>
				Country<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			India--<%=bankCountry%>
			<input type="hidden" name="bankCountry_old" value="<%=bankCountry%>">
			<input type="hidden" name="bankCountry" id="bankCountry" value="<%=bankCountry%>">
			</Td>
			<Th>
				Bank Name<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input  type="text" style="text-transform: uppercase;" name="bankName" id="bankName" value="<%=bankName%>"  maxlength="60">
			<input type="hidden" name="bankName_old" value="<%=bankName%>">
			</Td>
			<Th>
				Region<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<select  name="bankRegion" id="bankRegion">
			<%
			for (int i=0;i<StateCnt;i++) 
			{
				 statekey = retState.getFieldValueString(i,"EMKV_VALUE");
				  statevalue = retState.getFieldValueString(i,"EMKV_VALUE1");
				stateHT.put(statekey,statevalue);
				//out.println("<<<"+statekey+"<<<<<<"+stateHT.get(statekey));


				String bnkreg =(String)stateHT.get(statekey);
				if(bnkreg==null || "null".equals(bnkreg))bnkreg="";
				bnkreg = bnkreg.trim();
				if(bankRegion.equals(statekey))
				{
					selected="selected";
				
			%>
			<!--<Input  type="text" style="text-transform: uppercase;" name="bankRegion" id="bankRegion" value="<%=bankRegion%>"  maxlength="3">-->
			<option value="<%=statekey%>" <%=selected%>><%=bnkreg%>--<%=statekey%></option>
			<%
				}else
				{
					selected="";
			%>
					<option value="<%=statekey%>" <%=selected%>><%=bnkreg%>--<%=statekey%></option>
			<%
				}
			}
			%>
			</select>
			<input type="hidden" name="bankRegion_old" value="<%=statekey%>">
			</Td>
			
			</Tr>

			<Tr><Th>
				Street<font size="2" color="red">*</font>
			 </Th>
			<Td colspan="4">
			<Input  type="text" style="text-transform: uppercase;" name="bankStreet" id="bankStreet" value="<%=bankStreet%>"  maxlength="35">
			<input type="hidden" name="bankStreet_old" value="<%=bankStreet%>">
			</Td>
			<Th>
				City<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input  type="text" style="text-transform: uppercase;" name="bankCity" id="bankCity" value="<%=bankCity%>"  maxlength="35">
			<input type="hidden" name="bankCity_old" value="<%=bankCity%>">
			</Td>
			<Th>
				Branch<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input  type="text" style="text-transform: uppercase;" name="bankBranch" id="bankBranch" value="<%=bankBranch%>"  maxlength="40">
			<input type="hidden" name="bankBranch_old" value="<%=bankBranch%>">
			</Td>
			</Tr>
			<Tr>
			<Th>
				IFSC Code<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input  type="text" style="text-transform: uppercase;" name="bankIFSCCode" id="bankIFSCCode" value="<%=bankIFSCCode%>"  maxlength="11">
			<input type="hidden" name="bankIFSCCode_old" value="<%=bankIFSCCode%>">
			</Td>

			
			<Th>
				AC Code<font size="2" color="red">*</font>
			</Th>
			<Td colspan="4">
			<Input  type="text" style="text-transform: uppercase;" name="bankACCode" id="bankACCode" value="<%=bankACCode%>"  maxlength="15">
			<input type="hidden" name="bankACCode_old" value="<%=bankACCode%>">
			</Td>
			<Th>
				Currency<font size="2" color="red">*</font>
			</Th>
			<Td>Rupee-- INR
			<!--<select  name="bankCurrency" id="bankCurrency">	
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
			</select>					-->
			<Input  type="hidden"  name="bankCurrency" id="bankCurrency" value="INR">
			<Input  type="hidden"  name="bankCurrency_old" id="bankCurrency_old" value="INR">
			
			</Td>

							 </Tr>
							 </TBody>


					</Table>
				      </Div>
				      <!-- /.table-responsive -->
				    </Div>         		

						    </Div>
						    <!-- /.box-header -->

		
  		<div class="form-group">
	                  <label>Comments <font color = red>*</font></label>
	                  <textarea class="form-control" rows="5" placeholder="Enter Comments" name="comments" id="comments"></textarea>
               </div>
<input type="hidden" name="vendCode" id="vendCode" value="<%=vendCode%>" />
<input type="hidden" name="venName" id="venName" value="<%=venName%>" />
<input type="hidden" name="name1" id="name1" value="<%=name1%>" />
<input type="hidden" name="name2" id="name2" value="<%=name2%>" />
<input type="hidden" name="country" id="country" value="<%=key%>" />


<!-- /.box-header -->	
<Div class="col-xs-12 col-md-12" style="padding-right:3px;padding-left:37%">
	<button type="button" class="btn btn-primary" onclick="funBack()">Back</button>
	<button type="button" class="btn btn-primary" onclick="funUpload('<%=bankACCode%>')">UPLOAD DOCS</button> 
	<button type="button" class="btn btn-primary" onclick="funSubmit()">Submit</button>
</Div>	
	

		

<%//@ include file="../Admin/ezNews.jsp"%>
</form>
</Body>
	

	
        </section><!-- /.content -->
      </Div><!-- /.content-wrapper -->  
      

</Html>

<script>
function funUpload(bankACCode)
{
	var Url="ezFileAttachment.jsp?bankACCode="+bankACCode+"-<%=bankName%>";
		$.fancybox.open({

		href : Url,
		type : 'iframe',
		padding : 5,
		width:'60%',
		height:'450px',
		autoSize : false,
		closeBtn : true,
		helpers     : { 
				overlay : {closeClick: false}
		 }
	});
	
}

</script>
<%@ include file="ezFooter.jsp"%> 
<link rel="stylesheet" href="library/fancybox2/jquery.fancybox.css" type="text/css" media="screen" />  
 <script type="text/javascript" src="library/fancybox2/jquery.fancybox.js"></script>
<script type="text/javascript" src="library/fancybox2/jquery.fancybox.pack.js"></script>


	