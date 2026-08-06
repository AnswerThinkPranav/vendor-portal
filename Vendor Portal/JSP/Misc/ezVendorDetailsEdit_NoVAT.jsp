<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*,java.util.*" %>		
<%@ include file="iVendorDetails.jsp" %>
<%@ include file="ezCommonMethods.jsp" %>
<%@ include file="ezGetUserAuthDefaults.jsp"%> 
<jsp:useBean id="esManager" class="ezc.client.EzSystemConfigManager" scope="session"/>
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<%
//out.println("<<<"+key+"<<<"+value+"<<<"+value);
%>
<%
try{
session.removeValue("ATTACHEDFILES");
}catch(Exception e){}
%>
<%  

	ReturnObjFromRetrieve orgList= (ReturnObjFromRetrieve)session.getValue("orgListRetObj");
	
	Vector orgList_V = new Vector();
	if(orgList!=null)
	{
		for(int i=0;i<orgList.getRowCount();i++)
		{
			String orgCode = orgList.getFieldValueString(i,"PURORG");
			orgList_V.add(orgCode);
		}
	}
	
	Hashtable stateHT= new Hashtable();
	String usrId	=	"xyz";
	String selected="";
	String titleSelArr[] = {"Mr.","M/S.","Ms.", "Company", "Mr. and Mrs." };
	
	String vendCode = checkNull(request.getParameter("vendCode"));
	String compCode = checkNull(request.getParameter("compCode"));
	String serBased = checkNull(request.getParameter("serBased"));
	String venName  = checkNull(request.getParameter("venName"));
	String corLoc   = checkNull(request.getParameter("corLoc"));
	String grBased  = checkNull(request.getParameter("grBased"));
	String procGrp  = checkNull(request.getParameter("procGrp"));
	
	String titleSel = checkNull(request.getParameter("titleSel"));
	String name1    = checkNull(request.getParameter("name1"));
	String name2 	= checkNull(request.getParameter("name2"));
	String addr1 	= checkNull(request.getParameter("addr1"));
	String addr2 	= checkNull(request.getParameter("addr2"));
	String street	= checkNull(request.getParameter("street"));
	String city 	= checkNull(request.getParameter("city"));
	String state 	= checkNull(request.getParameter("state"));
	String country	= checkNull(request.getParameter("country"));
	String district = checkNull(request.getParameter("district"));
	String pin 	= checkNull(request.getParameter("pin"));
	String landline = checkNull(request.getParameter("landline"));
	String mobile	= checkNull(request.getParameter("mobile"));
	String fax 	= checkNull(request.getParameter("fax"));
	String email 	= checkNull(request.getParameter("email"));
	String email2 	= checkNull(request.getParameter("email2"));
	String contPers1= checkNull(request.getParameter("contPers1"));
	String contPers2= checkNull(request.getParameter("contPers2"));
	String vat   	= checkNull(request.getParameter("vat"));
	String cst   	= checkNull(request.getParameter("cst"));
	String pan   	= checkNull(request.getParameter("pan"));
	String servTax  = checkNull(request.getParameter("servTax"));
	String eccNo   	= checkNull(request.getParameter("eccNo"));
	String excRegNo = checkNull(request.getParameter("excRegNo"));
	String rangeSel = checkNull(request.getParameter("rangeSel"));
	String exDiv   	= checkNull(request.getParameter("exDiv"));
	String commi   	= checkNull(request.getParameter("commi"));
	String minIndi 	= checkNull(request.getParameter("minIndi"));
	String gst 	= checkNull(request.getParameter("gst"));
	String classification 	= checkNull(request.getParameter("classification"));
	
	String bankCountry[] = request.getParameterValues("bankCountry");
	String bankIndex[] = request.getParameterValues("bankIndex");
	String bankName[]    = request.getParameterValues("bankName");
	String bankRegion[]  = request.getParameterValues("bankRegion");
	String bankStreet[]  = request.getParameterValues("bankStreet");
	String bankCity[]    = request.getParameterValues("bankCity");
	String bankBranch[]  = request.getParameterValues("bankBranch");
	String bankIFSCCode[]= request.getParameterValues("bankIFSCCode");
	String bankACCode[]  = request.getParameterValues("bankACCode");
	String bankCurrency[]= request.getParameterValues("bankCurrency");
	String bankKey[]= request.getParameterValues("bankKey");
	
	String pTerms 	   = checkNull(request.getParameter("pTerms"));
	String paymMethod  = checkNull(request.getParameter("paymMethod"));
	String creatDate   = checkNull(request.getParameter("creatDate"));
	String houseBank   = checkNull(request.getParameter("houseBank"));
	String schemaGroup = checkNull(request.getParameter("schemaGroup"));
	
	ReturnObjFromRetrieve retsyskey=null;
	int sysRows = 0;
	
	String sys_key = null;
	EzcSysConfigParams sparams = new EzcSysConfigParams();
	EzcSysConfigNKParams snkparams = new EzcSysConfigNKParams();
	snkparams.setLanguage("EN");
	sparams.setObject(snkparams);
	Session.prepareParams(sparams);
	try{
		retsyskey = (ReturnObjFromRetrieve)esManager.getPurchaseAreas(sparams);
		sysRows = retsyskey.getRowCount();
	}catch(Exception e){}		     
%>			     
<%@ include file="ezHeader.jsp"%> 
<Html>
<Head>
<meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
<link rel="stylesheet" type="text/css" href="../../Library/jquery/jquery-ui-1.12.1.custom/jquery-ui.css">
<link rel="stylesheet" href="../Misc/library/fancybox2/jquery.fancybox.css" type="text/css" media="screen" />


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
th
{
	font-size:small;
}
td
{
	font-size:small;
}
.my-error-class {
    float:none;
    color:red;
    padding-left: .5em;
    padding-top: .2em;
   vertical-align: top; 
}
.ui-draggable .ui-dialog-titlebar {
    background: #f39c12;
}


</style>

</Head>

  <Body>          
        <form method="post"  name="myForm" id="myForm">
  <!-- Content Wrapper. Contains page content -->
        <Div class="content-wrapper">
          <!-- Content Header (Page header) -->
          <section class="content-header">
            <h4>
              Vendor Details  </h4><br>
             <B><Font size=4 color=BLACK>Location</Font></B>
              
              &nbsp;&nbsp;&nbsp;&nbsp;
              <%
              if ( sysRows > 0 )
	      	{
	      		//out.println("orglist::"+orgList_V);
	      %>
	              	<select name="SystemKey" name="SystemKey" style="width:25%" id=FullListBox >
	              	<option value="">-----------Select Location-----------</option>
		<%
			retsyskey.sort(new String[]{"ESKD_SYS_KEY_DESC"},true);
			for ( int i = 0 ; i < sysRows ; i++ )
			{
				String val = (String)(retsyskey.getFieldValue(i,"ESKD_SYS_KEY"));
				String checkFlag = (String)retsyskey.getFieldValue(i,"ESKD_SUPP_CUST_FLAG");
				String syskeyDesc = (String)(retsyskey.getFieldValue(i,"ESKD_SYS_KEY_DESC"));				
				String descCode = syskeyDesc.substring(syskeyDesc.length()-5,syskeyDesc.length()-1);
				
				if(!orgList_V.contains(descCode)) continue;
				
				val = val.toUpperCase();
				val = val.trim();
		%>
				<option value="<%=val%>" Selected><%=syskeyDesc%></option>
		<%
			}
		%>	
			</select>
		<%
		}
		%>
          
          </section>
  
          <!-- Main content -->  
          <section class="content"> 
	
<input type="hidden" name="attachFlag" value ="N" >
<input type="hidden" name="attachDocDesc" value ="" >	
<input type="hidden" name="attachFileTime" value ="" >	
<input type="hidden" name="attachDocFiles" value ="" >	
<input type="hidden" name="attachType" value ="" >	
<input type="hidden" name="changedValues" id="changedValues" value="">	

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
					<Th align=left>Vendor Code</Th>
					<Td colspan="4">
						<Input  type="text"   name="vendCode" id="vendCode" value="<%=Integer.parseInt(vendCode)%>"  maxlength="10" readonly disabled>
						<Input  type="hidden"   name="vendCode_old" id="vendCode_old" value="<%=Integer.parseInt(vendCode)%>" >
						
					</Td>
					
					<Th align=right>Company Code</Th>
					<Td colspan="4">
						<Input  type="text"   name="compCode" id="compCode" value="<%=compCode%>"  maxlength="4" disabled>
						<Input  type="hidden"   name="compCode_old" id="compCode_old" value="<%=compCode%>" >
					</Td>
					<!--<Th align=right>Service Based</Th>
					<Td colspan="4">
						<Input  type="text"   name="serBased" id="serBased" value="<%=serBased%>"  maxlength="1"
						<Input  type="hidden"   name="serBased_old" id="serBased_old" value="<%=serBased%>" >
						
					</Td>-->
					<!--<Th>ServAgntProcGrp</Th>
					<Td colspan="4">
						<select name="procGrp" id="procGrp" >
							<option value="<%=procGrp%>" selected><%=procGrp%></option>
						</select>					
															
					</Td>-->
					<Th align=left>Vendor Name</Th>
					<Td colspan="4">
						<Input  type="text"   name="venName" id="venName" value="<%=venName%>"  maxlength="35" disabled>
						<Input  type="hidden"   name="venName_old" id="venName_old" value="<%=venName%>"> 											
					</Td>
				</Tr>				
				<Tr>
					
					<!--<Th align=right>Coromandel Location</Th>
					<Td colspan="4">
						<Input  type="text"   name="corLoc" id="corLoc" value="<%=corLoc%>"  maxlength="4">
						
					</Td>-->
					<Th align=right>Service Based</Th>
					<Td colspan="4">
						<Input  type="radio"   name="serBased" id="serBased" value="Y"  maxlength="1" <%=("X".equals(serBased)) ? "CHECKED" : ""%>>&nbsp;Yes &nbsp;&nbsp;&nbsp;
						<Input  type="radio"   name="serBased" id="serBased" value="N"  maxlength="1" <%=("".equals(serBased)) ? "CHECKED" : ""%>>&nbsp;No
						
						<Input  type="hidden"   name="serBased_old" id="serBased_old" value="<%=("".equals(serBased)) ? "N" : "Y"%>" >
					</Td>
					<Th align=right>GR Based</Th>
					<Td colspan="4">
						<Input  type="radio"   name="grBased" id="grBased" value="Y"  maxlength="1" <%=("X".equals(grBased)) ? "CHECKED" : ""%>>&nbsp;Yes &nbsp;&nbsp;&nbsp;
						<Input  type="radio"   name="grBased" id="grBased" value="N"  maxlength="1" <%=("".equals(grBased)) ? "CHECKED" : ""%>>&nbsp;No
						<Input  type="hidden"   name="grBased_old" id="grBased_old" value="<%=("".equals(grBased)) ? "N" : "Y"%>" >					
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
					<Th>Title</Th>
					<Td colspan="4">
					<Input  type="text"   name="titleSel" id="titleSel" value="<%=titleSel%>"  maxlength="35" disabled>
					<Input  type="hidden"   name="titleSel_old" id="titleSel_old" value="<%=titleSel%>" >
						<!--<select name="titleSel" id="titleSel" >
						<option value="" >---select title---</option>
						<%
						//out.println(titleSel+":::::titleSel:::::");
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
							
							
						</select>-->					
						
					</Td>
					<Th>Name1</Th>
					<Td colspan="4">
						<Input  type="text"   name="name1" id="name1" value="<%=name1%>"  maxlength="35" readonly disabled>
						<Input  type="hidden"   name="name1_old" id="name1_old" value="<%=name1%>" >
						
					</Td>
					<Th>Name2</Th>
					<Td colspan="4">
						<Input  type="text"   name="name2" id="name2" value="<%=name2%>"  maxlength="35" readonly disabled>
						<Input  type="hidden"   name="name2_old" id="name2_old" value="<%=name2%>">
					</Td>
				</Tr>
				
				<Tr>
					<Th>Addr1 / H.No</Th>
					<Td colspan="4">
						<Input  type="text"   name="addr1" id="addr1" value="<%=addr1%>"  maxlength="35">
						<Input  type="hidden"   name="addr1_old" id="addr1_old" value="<%=addr1%>" >
					</Td>

					<Th>Addr2</Th>
					<Td colspan="4">
						<Input  type="text"   name="addr2" id="addr2" value="<%=addr2%>"  maxlength="35">
						<Input  type="hidden"   name="addr2_old" id="addr2_old" value="<%=addr2%>">
					</Td>
					<Th>Street</Th>
					<Td colspan="4">
						<Input  type="text"   name="street" id="street" value="<%=street%>"  maxlength="60">
						<Input  type="hidden"   name="street_old" id="street_old" value="<%=street%>">
					</Td>
				</Tr>
				<Tr>
					
					<Th>City</Th>
					<Td colspan="4">
						<Input  type="text"   name="city" id="city" value="<%=city%>"  maxlength="35">
						<Input  type="hidden"   name="city_old" id="city_old" value="<%=city%>">
					</Td>
					<Th>State</Th>
				
					<Td colspan="4">
					<Input  type="hidden"   name="state_old" id="state_old" value="<%=state%>">
					<select  name="state" id="state">
					<option value="" ><-------Select state-------></option>
					<%
					for (int i=0;i<StateCnt;i++) 
					{
						selected="";
						 statekey = retState.getFieldValueString(i,"EMKV_VALUE");
						  statevalue = retState.getFieldValueString(i,"EMKV_VALUE1");
						
						if(state.equals(statekey))
							selected="selected";							
				
					%>
							<option value="<%=statekey%>" <%=selected%> ><%=statevalue%>--<%=statekey%></option>
					<%
						
					}
					%>
					</select>					
						
						
					</Td>
					<Th>Country</Th>
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
						<Input  type="hidden"  name="country_old" id="country_old" value="IN">
					</Td>
				</Tr>
				<Tr>
					<Th>District</Th>
					<Td colspan="4">
						<!--<select  name="district" id="district">
							<option value="<%=district%>" selected><%=district%></option>
						</select>	-->				
						<Input  type="text"   name="district" id="district" value="<%=district%>"  maxlength="35">
						<Input  type="hidden"   name="district_old" id="district_old" value="<%=district%>">
					</Td>
					
					<Th>PinCode</Th>
					<Td colspan="4">
						<Input  type="text"   name="pin" id="pin" value="<%=pin%>"  maxlength="6">
						<Input  type="hidden"   name="pin_old" id="pin_old" value="<%=pin%>">
					</Td>
					</Tr>
					<Tr>
					<Th>Landline</Th>
					<Td colspan="4">
						<Input  type="text"   name="landline" id="landline" value="<%=landline%>"  maxlength="16">
						<Input  type="hidden"   name="landline_old" id="landline_old" value="<%=landline%>">
					</Td>
					<Th>Mobile</Th>
					<Td colspan="4">
						<Input  type="text"   name="mobile" id="mobile" value="<%=mobile%>"  maxlength="16">
						<Input  type="hidden"   name="mobile_old" id="mobile_old" value="<%=mobile%>">
					</Td>
					<Th>FAX</Th>
					<Td colspan="4">
						<Input  type="text"   name="fax" id="fax" value="<%=fax%>"  maxlength="31">
						<Input  type="hidden"   name="fax_old" id="fax_old" value="<%=fax%>">
					</Td>
				</Tr>
				<Tr>
					
					<Th>EMail</Th>
					<Td colspan="4">
						<Input  type="text"   name="email" id="email" value="<%=email%>"  maxlength="241">
						<Input  type="hidden"   name="email_old" id="email_old" value="<%=email%>">
						<p id="emailMsg" style="display:none"><font color="red">Please enter valid Email Id</font></p>
					</Td>
					<Th>EMail 2</Th>
					<Td colspan="4">
					<Input  type="text"   name="email2" id="email2" value="<%=email2%>"  maxlength="241">
					<Input  type="hidden"   name="email2_old" id="email2_old" value="<%=email2%>" >
					<p id="emailMsg" style="display:none"><font color="red">Please enter valid Email Id</font></p>
					</Td>
					
					
				</Tr>
				<Tr>
				<Th>
					Contact Person 1
					</Th>
					<Td colspan="4">
					<Input  type="text"   name="contPers1" id="contPers1" value="<%=contPers1%>"  maxlength="35">
					<Input  type="hidden"   name="contPers1_old" id="contPers1_old" value="<%=contPers1%>" >
					<p id="contPers1Msg" style="display:none"><font color="red">Contact person 1 length should not exceed 10</font></p>
					</Td>
					<Th>
						Contact Person 2
					</Th>
					<Td colspan="4">
					<Input  type="text"   name="contPers2" id="contPers2" value="<%=contPers2%>"  maxlength="35">
					<Input  type="hidden"   name="contPers2_old" id="contPers2_old" value="<%=contPers2%>" >
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
		VAT
		</Th>
		<Td colspan="4">
		<Input  type="text"   name="vat" id="vat" value="<%=vat%>"  maxlength="40">
		<Input  type="hidden" name="vat_old" id="vat_old" value="<%=vat%>"  >
		</Td>
		<Th>
		CST
		</Th>
		<Td colspan="4">
		<Input  type="text"   name="cst" id="cst" value="<%=cst%>"  maxlength="40">
		<Input  type="hidden" name="cst_old" id="cst_old" value="<%=cst%>" >
		
		</Td>
		<Th>
		PAN<font size="2" color="red"></font>
		</Th>
		<Td colspan="4">
		<Input  type="text"   name="pan" id="pan" value="<%=pan%>"  maxlength="10" >
		<Input  type="hidden" name="pan_old" id="pan_old" value="<%=pan%>" >
		</Td>
		</Tr>

		<Tr><Th>
		Service Tax
		</Th>
		<Td colspan="4">
		<Input  type="text"   name="servTax" id="servTax" value="<%=servTax%>"  maxlength="40">
		<Input  type="hidden" name="servTax_old" id="servTax_old" value="<%=servTax%>" >
		</Td>
		<Th>
		ECC No
		</Th>
		<Td colspan="4">
		<Input  type="text"   name="eccNo" id="eccNo" value="<%=eccNo%>"  maxlength="40">
		<Input  type="hidden" name="eccNo_old" id="eccNo_old" value="<%=eccNo%>" >
		</Td>
		<Th>
		EXC. Reg No
		</Th>
		<Td colspan="4">
		<Input  type="text"   name="excRegNo" id="excRegNo" value="<%=excRegNo%>"  maxlength="40">
		<Input  type="hidden" name="excRegNo_old" id="excRegNo_old" value="<%=excRegNo%>"  >
		</Td>
		</Tr>
		<Tr>	

		<Th>
		EX. Range
		</Th>
		<Td colspan="4">
		<input type="hidden"  name="rangeSel_old" id="rangeSel_old" value="<%=rangeSel%>">
		<input type="text" name="rangeSel" id="rangeSel" value="<%=rangeSel%>">					
		
		</Td>
		<Th>
		EX Division
		</Th>
		<Td colspan="4">
		<Input  type="text"   name="exDiv" id="exDiv" value="<%=exDiv%>"  maxlength="60">
		<Input  type="hidden" name="exDiv_old" id="exDiv_old" value="<%=exDiv%>"  >
		</Td>
		<Th>
		COMMI
		</Th>
		<Td colspan="4">
		<Input  type="text"   name="commi" id="commi" value="<%=commi%>"  maxlength="60">
		<Input  type="hidden" name="commi_old" id="commi_old" value="<%=commi%>"  >
		</Td>
		</Tr>
		<Tr>
				
		
				<Th>
				Category
				</Th>
				<Td colspan="4">
				<input type="hidden"  name="minIndi_old" id="minIndi_old" value="<%=minIndi%>">
				<select  name="minIndi" id="minIndi">
				<option value="" ><--------Select Category--------></option>
				<%
				for (int i=0;i<MinIndCnt;i++) 
				{
					selected="";
					 MinIndkey = checkNull(retMinInd.getFieldValueString(i,"EMKV_KEY"));
					 MinIndvalue = checkNull(retMinInd.getFieldValueString(i,"EMKV_VALUE"));

					if(minIndi.equals(MinIndkey))
						selected="selected";							

				%>
						<option value="<%=MinIndkey%>" <%=selected%> ><%=MinIndvalue%>--<%=MinIndkey%></option>
				<%

				}
				%>
					</select>
				<!--<select  name="minIndi" id="minIndi">
		
				<option value="<%=minIndi%>" selected><%=minIndi%></option>
		
				</select>					-->
				
		
				</Td>
				
				<Th>
					GSTIN
					</Th>
					<Td colspan="4">
					<Input  type="text"   name="gst" id="gst" value="<%=gst%>"  maxlength="15" onchange="funGst()">
					<Input  type="hidden" name="gst_old" id="gst_old" value="<%=gst%>"  >
				</Td>
				<Th>
					Classification
					</Th>
				<%
					String[] selOpts = {"01##Registered","02##Not Registered","03##Compounding Scheme","04##PSU/Government Organization"};
				%>	
					
					<Td colspan="4">
					<select  name="classification" id="classification">							
					<option value="" ><-----Select Classification-----></option>
				<%					
					for(int i=0;i<selOpts.length;i++)
					{
						String val0 = selOpts[i].split("##")[0];
						String val1 = selOpts[i].split("##")[1];
						String val2 = val0+"-"+val1;
						
						if(classification.equals(val0))
							selected="selected";
						else
							selected="";
				%>
						<option value="<%=val0%>" <%=selected%>><%=val1%></option>
				<%
					}
				%>
					</select>
					<!--<Input  type="text"   name="classification" id="classification" value="<%=classification%>"  maxlength="4">-->
					<Input  type="hidden" name="classification_old" id="classification_old" value=""  >					
				</Td>				
		</Tr>
		<Tr>
				<Th>
					Certification Date<font size="2" color="red"></font>
					</Th>
				<Td colspan="4">
					<!--<Input  type="text"   name="cDate" id="cDate" value="<%=creatDate%>"  maxlength="10">&nbsp;<%=getDateImage("cDate")%>-->
					<input class="form-control input-sm" type="text" value=""  name="cDate" id="cDate"  >
					<span><Font color=#ff0000 size=1><B>* In case of micro, small and medium enterprises.</B></Font></span> 
					<Input  type="hidden" name="cDate_old" id="cDate_old" value="<%=creatDate%>"  >
				</Td>
				<Td>
					<label for="cDate" class="input-group-addon btn"> <img src='../../../../EzCommon/JavaScript/Calendar/Themes/icons/calendar7.gif' style='cursor:hand' id='butt"+field+"' border='none' valign='center'></label>  
				</Td>
		</Tr>
		</TBody>               

		</Table>
		</Div>
		<!-- /.table-responsive -->
		</Div>       
		</Div>


<%
String bankIndexStr="";
String bankListStr="";
	if(bankCountry!=null)
	{
		for(int k=0;k<bankCountry.length;k++)
		{
			if("".equals(bankListStr))
			bankListStr=bankACCode[k]+"-"+bankName[k];
			else
			bankListStr=bankListStr+"¥"+bankACCode[k]+"-"+bankName[k];
			
			bankIndexStr=bankIndex[k];
		
%>
<input type="hidden" name="bankIndex" value="<%=bankIndexStr%>">
			<Div class="box box-info collapsed-box">            
			<Div class="box-header">
				<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i><B>&nbsp;&nbsp;<Font size=2 color=BLACK>BANK (<%=bankACCode[k]%>)</Font></B></button>                		    
				
				
		       </Div>
		      <Div class="box-body" style="display: block;">
		      <Div class="table-responsive" id="wf"> 
		      
			<Table class="table no-margin" id="wfw">



			<TBody><Tr>
			<Th>
				Country
			</Th>
			<Td colspan="4">
			<input type="hidden" name="bankKey" value="<%=bankKey[k]%>">
			India--<%=bankCountry[k]%>
			<input type="hidden" name="bankCountry_old" value="<%=bankCountry[k]%>">
			<input type="hidden" name="bankCountry" id="bankCountry" value="<%=bankCountry[k]%>">
			</Td>
			<Th class="control-label" for="inputEmail">
				Bank Name
			</Th>
			<Td class="controls" colspan="4">
			<Input  type="text"   name="bankName" id="bankName" value="<%=bankName[k]%>"  maxlength="60">
			<input type="hidden" name="bankName_old" value="<%=bankName[k]%>">
			</Td>
			<Th>
				State
			</Th>
			<Td colspan="4">
			<select  name="bankRegion" id="bankRegion">
			<option value="" ><----Select Region----></option>
			<%
			for (int i=0;i<StateCnt;i++) 
			{
				selected="";
				 statekey = checkNull(retState.getFieldValueString(i,"EMKV_VALUE"));
				  statevalue = checkNull(retState.getFieldValueString(i,"EMKV_VALUE1"));
				/*stateHT.put(statekey,statevalue);
				//out.println("<<<"+statekey+"<<<<<<"+stateHT.get(statekey));


				String bnkreg =(String)stateHT.get(statekey);
				if(bnkreg==null || "null".equals(bnkreg))bnkreg="";
				bnkreg = bnkreg.trim();*/
				if(bankRegion[k].equals(statekey))
					selected="selected";
				
			%>
					<option value="<%=statekey%>" <%=selected%>><%=statevalue%>--<%=statekey%></option>
			<%
				
			}
			%>
			</select>
			<input type="hidden" name="bankRegion_old" value="<%=bankRegion[k]%>">
			</Td>
			
			</Tr>

			<Tr><Th>
				Street
			 </Th>
			<Td colspan="4">
			<Input  type="text"   name="bankStreet" id="bankStreet" value="<%=bankStreet[k]%>"  maxlength="35">
			<input type="hidden" name="bankStreet_old" value="<%=bankStreet[k]%>">
			</Td>
			<Th>
				City
			</Th>
			<Td colspan="4">
			<Input  type="text"   name="bankCity" id="bankCity" value="<%=bankCity[k]%>"  maxlength="35">
			<input type="hidden" name="bankCity_old" value="<%=bankCity[k]%>">
			</Td>
			<Th>
				Branch
			</Th>
			<Td colspan="4">
			<Input  type="text"   name="bankBranch" id="bankBranch" value="<%=bankBranch[k]%>"  maxlength="40">
			<input type="hidden" name="bankBranch_old" value="<%=bankBranch[k]%>">
			</Td>
			</Tr>
			<Tr>
			<Th>
				IFSC Code
			</Th>
			<Td colspan="4">
			<Input  type="text"   name="bankIFSCCode" id="bankIFSCCode" value="<%=bankIFSCCode[k]%>"  maxlength="11">
			<input type="hidden" name="bankIFSCCode_old" value="<%=bankIFSCCode[k]%>">
			</Td>

			
			<Th>
				Account Number
			</Th>
			<Td colspan="4">
			<Input  type="text"   name="bankACCode" id="bankACCode" value="<%=bankACCode[k]%>"  maxlength="18">
			<input type="hidden" name="bankACCode_old" value="<%=bankACCode[k]%>">
			</Td>
			<Th>
				Currency
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
<%
		}
	}
%>			

<input type="hidden" name="bankIndex" value="<%=(Integer.parseInt(bankIndexStr)+1)+""%>">

<Div class="box box-info collapsed-box">            
			<Div class="box-header">
				<button type="button" class="btn btn-box-tool" data-widget="collapse"><input type='button'  value='Add Bank' id='editButton' /><B>&nbsp;&nbsp;<Font size=2 color=BLACK>BANK </Font></B></button>                		    
		       </Div>
		      <Div class="box-body" style="display: none;">
		      <Div class="table-responsive" id="wf"> 
		      
			<Table class="table no-margin" id="wfw">



			<TBody><Tr>
			<Th>
				Country
			</Th>
			<Td colspan="4">
			<input type="hidden" name="bankKey" value="">
			India
			<input type="hidden" name="bankCountry_old" value="">
			<input type="hidden" name="bankCountry" id="bankCountry" value="">
			</Td>
			<Th class="control-label" for="inputEmail">
				Bank Name
			</Th>
			<Td class="controls" colspan="4">
			<Input  type="text"   name="bankName" id="bankName" value=""  maxlength="60">
			<input type="hidden" name="bankName_old" value="">
			</Td>
			<Th>
				State
			</Th>
			<Td colspan="4">
			<select  name="bankRegion" id="bankRegion">
			<option value="" ><----Select Region----></option>
			<%
			for (int i=0;i<StateCnt;i++) 
			{				
				 statekey = checkNull(retState.getFieldValueString(i,"EMKV_VALUE"));
				  statevalue = checkNull(retState.getFieldValueString(i,"EMKV_VALUE1"));		
			%>
					<option value="<%=statekey%>" <%=selected%>><%=statevalue%>--<%=statekey%></option>
			<%
				
			}
			%>
			</select>
			<input type="hidden" name="bankRegion_old" value="">
			</Td>
			
			</Tr>

			<Tr><Th>
				Street
			 </Th>
			<Td colspan="4">
			<Input  type="text"   name="bankStreet" id="bankStreet" value=""  maxlength="35">
			<input type="hidden" name="bankStreet_old" value="">
			</Td>
			<Th>
				City
			</Th>
			<Td colspan="4">
			<Input  type="text"   name="bankCity" id="bankCity" value=""  maxlength="35">
			<input type="hidden" name="bankCity_old" value="">
			</Td>
			<Th>
				Branch
			</Th>
			<Td colspan="4">
			<Input  type="text"   name="bankBranch" id="bankBranch" value=""  maxlength="40">
			<input type="hidden" name="bankBranch_old" value="">
			</Td>
			</Tr>
			<Tr>
			<Th>
				IFSC Code
			</Th>
			<Td colspan="4">
			<Input  type="text"   name="bankIFSCCode" id="bankIFSCCode" value=""  maxlength="11">
			<input type="hidden" name="bankIFSCCode_old" value="">
			</Td>

			
			<Th>
				Account Number
			</Th>
			<Td colspan="4">
			<Input  type="text"   name="bankACCode" id="bankACCode" value=""  maxlength="18">
			<input type="hidden" name="bankACCode_old" value="">
			</Td>
			<Th>
				Currency
			</Th>
			<Td>Rupee-- INR
			
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

	<Div class="box box-info collapsed-box">            
<Div class="box-header">
 <Div class="table-responsivee">
<Div class="ans" id="WFTabb'>
</Div>
</Div>
</Div>
</Div>	
  		<div class="form-group">
	                  <h5>&nbsp;&nbsp;&nbsp;&nbsp<B>COMMENTS</B></h5>
	                  <textarea class="form-control" rows="5" placeholder="Enter Comments" name="comments" id="comments" required></textarea>
               </div>
<input type="hidden" name="vendCode" id="vendCode" value="<%=vendCode%>" />
<input type="hidden" name="vendType" id="vendType" value="SAP" />
<input type="hidden" name="venName" id="venName" value="<%=venName%>" />
<input type="hidden" name="titleSel" id="titleSel" value="<%=titleSel%>" />
<!--<input type="hidden" name="name1" id="name1" value="<%=name1%>" />
<input type="hidden" name="name2" id="name2" value="<%=name2%>" />-->
<input type="hidden" name="country" id="country" value="<%=key%>" />
<input type="hidden" name="nextParticipant" value="">


<!-- /.box-header -->	
<Div class="col-xs-12 col-md-12" style="padding-right:3px;padding-left:37%">
<Input  type="checkbox"   name="termc" id="termc" value="N"  maxlength="1" required>&nbsp;Please accept <a onclick="termsc()"><u>Terms and Conditions</u></a> before submitting the details.</input><br><br>
<div class="errorTxt" style="display:none"></div>
</Div>
<Div class="col-xs-12 col-md-12 col-md-offset-5 col-xs-offset-6 " >
	<!--<input type='button' class="btn btn-primary" value='Add Bank' id='addButton' />-->
	<!--<button type="button" class="btn btn-primary" onclick="funBack()">Back</button>-->
	<button type="button" class="btn btn-primary" id="uploaddocs" onclick="funUpload('<%=bankListStr%>')">Upload Docs</button> 
	<button type="button" class="btn btn-primary" onclick="funSubmit()">Submit</button>
</Div>	
	

		

</form>
</Body>
	

	
        </section><!-- /.content -->
      </Div><!-- /.content-wrapper -->  
<script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>
<script src="../../Library/jquery/jquery-validation-1.16.0/dist/jquery.validate.min.js"></script>
<script src="../../Library/jquery/jquery-validation-1.16.0/dist/additional-methods.min.js"></script>
<script src="../../Library/jquery/jquery-ui-1.12.1.custom/jquery-ui.js"></script>


<script type="text/javascript">
$(document).ready(function () {

           $("#addButton").click(function () {
                if( ($('.ans').length+1) > 2) {
                    alert("Only 2 control-group allowed");
                    return false;
                }
                var id = ($('.table-responsive').length + 1).toString();
                $('.table-responsivee').append('<div class="ans" id="WFTabb' + id + '"><div class="ans" id="WFTabb' + id + '"><div class="ans" id="WFTabb' + id + '"><tr><Th>Country' + id + '&nbsp;&nbsp;&nbsp;</th><Td colspan="4"><input type="text" id="bankName' + id + '" placeholder="Country">&nbsp;&nbsp;&nbsp;</Td>  <Th>BankName' + id + '&nbsp;&nbsp;&nbsp;</th><td colspan="4"><input type="text" id="bankName' + id + '" placeholder="Name">&nbsp;&nbsp;&nbsp;</td> <Th>State' + id + '&nbsp;&nbsp;&nbsp;</th><td colspan="4"><input type="text" id="bankName' + id + '" placeholder="state">&nbsp;&nbsp;&nbsp;</td></tr></div></div><br><tr><Th>Street' + id + ' &nbsp;&nbsp;&nbsp;</th><td colspan="4"><input type="text" id="bankName' + id + '" placeholder="street">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><Th>City' + id + '&nbsp;&nbsp;&nbsp;</th><td colspan="4"><input type="text" id="bankName' + id + '" placeholder="City">&nbsp;&nbsp;&nbsp;</td><Th>branch' + id + '&nbsp;&nbsp;&nbsp;</th><td colspan="4"><input type="text" id="bankName' + id + '" placeholder="branch">&nbsp;&nbsp;&nbsp;</td></tr></div><br><tr><Th>IFSC' + id + '&nbsp;&nbsp;&nbsp;</th><td colspan="4"><input type="text" id="bankName' + id + '" placeholder="ifsc">&nbsp;&nbsp;&nbsp;</td><Th>Ac No' + id + '&nbsp;&nbsp;&nbsp;</th><td colspan="4"><input type="text" id="bankName' + id + '" placeholder="Ac no">&nbsp;&nbsp;&nbsp;</td><Th>Currency' + id + '&nbsp;&nbsp;&nbsp;</th><td colspan="4"><input type="text" id="bankName' + id + '" placeholder="Currency">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>');
            });
                });
      
function addRow(index)
{
	var lastIndex = 1;
	var row1= 1;
	var rowIndex = "1";
	
	var ADD="ADD";
	
	var WFKey = "abc"+"ads"+"dg"+"brf";
	//var WFType = "yy";
	
	if(index=="HEAD")
	{
		var Retcount=1;
		if(Retcount!="0")
		document.myForm.nextParticipant.value = document.myForm.bankName.value;
		var WFStep = "0";
	}else{
		if(eval("document.myForm.WFParticipant"+(parseInt(index)+1))!=null)
		document.myForm.nextParticipant.value = eval("document.myForm.WFParticipant"+(parseInt(index)+1)).value;
		var WFStep = eval("document.myForm.WFStep"+index).value;
		rowIndex = (parseInt(row1.rowIndex)+1);
	}
	//if(WFType=="OT")WFType="Other";
	//if(WFType=="ADM")WFType="Admin";

	do {
		WFKey = WFKey.replace("&","§");
	} while(WFKey.indexOf("&") !== -1);
	
	var table = document.getElementById("WFTab");      
	var row = table.insertRow(rowIndex);   
	
	var cell1 = row.insertCell(0);  
	cell1.innerHTML ='<input type="hidden" name="WFStep'+(parseInt(lastIndex)+1)+'" value="'+(parseInt(WFStep)+1)+'" >';

	var cell2 = row.insertCell(1);      
	cell2.innerHTML ='<input type="text" name="bankCountry'+(parseInt(lastIndex)+1)+'" value="" >Country';

	//var cell3 = row.insertCell(2);      
	//cell3.innerHTML ='<input type="text" name="WFParent'+(parseInt(lastIndex)+1)+'" value="" > ';
	
	var cell3 = row.insertCell(2);      
	cell3.innerHTML ='<input type="text" name="bankName'+(parseInt(lastIndex)+1)+'" value="" >BankName';

	var cell4 = row.insertCell(3);    
	cell4.id = 'PriceCondId'+(parseInt(lastIndex)+1);
	cell4.innerHTML ='<select name="bankRegion'+(parseInt(lastIndex)+1)+'" id="bankRegion'+(parseInt(lastIndex)+1)+'"><option value="">Select State</option><option value="LT"><</option><option value="LE"><=</option><option value="GT">></option><option value="GE">>=</option><option value="EQ">=</option><option value="GWA">GWA</option></select>State';
	
	var cell5 = row.insertCell(4);      
	cell5.innerHTML ='<input type="text" name="bankStreet'+(parseInt(lastIndex)+1)+'" value="" > Street';
	
	var cell6 = row.insertCell(5);      
	cell6.innerHTML ='<input type="text" name="bankCity'+(parseInt(lastIndex)+1)+'" value="" > City';
	
	var cell7 = row.insertCell(6);      
	cell7.innerHTML ='<input type="text" name="bankBranch'+(parseInt(lastIndex)+1)+'" value="" > Branch';
	
	var cell8 = row.insertCell(7);      
	cell8.innerHTML ='<input type="text" name="bankIFSCCode'+(parseInt(lastIndex)+1)+'" value="" >IFSCCode';
	
	var cell9 = row.insertCell(8);      
	cell9.innerHTML ='<input type="text" name="bankACCode'+(parseInt(lastIndex)+1)+'" value="" > Acount No';
	
	
	var cell10 = row.insertCell(9);      
	cell10.className="centerText";
	cell10.innerHTML ='<div id="edit'+(parseInt(lastIndex)+1)+'" style="display:none"><a href="javascript:editRow(\''+(parseInt(lastIndex)+1)+'\')"><i class="fa fa-edit fa-lg"></i></a>&nbsp;&nbsp;&nbsp;<a href="javascript:deleteRow(\''+(parseInt(lastIndex)+1)+'\',\''+ADD+'\')"><i class="fa fa-trash-o fa-lg"></i></a>&nbsp;&nbsp;&nbsp;<a href="javascript:addRow(\''+(parseInt(lastIndex)+1)+'\')"><i class="fa fa-plus-square-o fa-lg"></i></a></div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:deleteRow(\''+(parseInt(lastIndex)+1)+'\',\''+ADD+'\')"><i class="fa fa-trash-o fa-lg"></i></a>&nbsp;&nbsp;&nbsp;<a href="javascript:addRow(\''+(parseInt(lastIndex)+1)+'\')"><i class="fa fa-plus-square-o fa-lg"></i></a></div>';
	
	document.myForm.lastIndex.value = parseInt(lastIndex)+1;
 	 	
}
function termsc()
{
	var Url="ezTermsConditon.jsp";
		$.fancybox.open({
		href : Url,
		type : 'iframe',
		padding : 5,
		width:'70%',
		height:'370px',
		autoSize : false,
		closeBtn : true,
		helpers     : { 
				overlay : {closeClick: false}
	 }
	});
}
function funGst()
{
	var gst  	= document.myForm.gst.value;
	if(gst!="")
	{
		document.myForm.classification.selectedIndex = 1;
	}
}
function funSubmit()
   {
   
   var changedValues="";
   var SystemKey	=document.myForm.SystemKey.value;
   
   if(SystemKey=="")
   {
   	alert("Please select Purchase Organization");
   	document.myForm.SystemKey.focus();
   	return false;
   }
   var landline  	= document.myForm.landline.value;
   var landline_old  	= document.myForm.landline_old.value;
   	var pattern =  /^[0-9-]*$/;
   	    if (pattern.test(landline)) {   	               
   	                //return true;
            }else{
            alert("It is not valid landline number.");
            document.myForm.landline.focus();
            return false;
            }
  var fax  	= document.myForm.fax.value;
  var fax_old  	= document.myForm.fax_old.value;
	if (pattern.test(fax)) {   	               
   	                //return true;
            }else{
            alert("It is not valid fax number.");
            document.myForm.fax.focus();
            return false;
            }	
   	  

   	var vendCode	=document.myForm.vendCode.value;
   	var compCode	=document.myForm.compCode.value;
   	var vendType	=document.myForm.vendType.value;
   	var serBased	=document.myForm.serBased.value;
   	var venName  	= document.myForm.venName.value;
   	var grBased  	= document.myForm.grBased.value;   
   	
   	var compCode_old=document.myForm.compCode_old.value;
	var serBased_old=document.myForm.serBased_old.value;
	var venName_old	= document.myForm.venName_old.value;
   	var grBased_old	= document.myForm.grBased_old.value;   
   	
   	//var procGrp  	= document.myForm.procGrp.value;
   	
   	//var titleSel  	= document.myForm.titleSel.value;
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
	var mobile  	= document.myForm.mobile.value;	
	var email  	= document.myForm.email.value;
	var email2  	= document.myForm.email2.value;
	var contPers1  	= document.myForm.contPers1.value;
	var contPers2  	= document.myForm.contPers2.value;
	
	var name1_old  	= document.myForm.name1_old.value;
   	var name2_old  	= document.myForm.name2_old.value;
   	var addr1_old  	= document.myForm.addr1_old.value;
   	var addr2_old  	= document.myForm.addr2_old.value;
   	var street_old  = document.myForm.street_old.value;
   	var city_old  	= document.myForm.city_old.value;
   	var state_old  	= document.myForm.state_old.value;
   	var country_old = document.myForm.country_old.value;
   	var district_old= document.myForm.district_old.value;
	var pin_old  	= document.myForm.pin_old.value;
	var mobile_old  = document.myForm.mobile_old.value;	
	var email_old  	= document.myForm.email_old.value;
	var email2_old  = document.myForm.email2_old.value;
	
	var contPers1_old 	= document.myForm.contPers1_old.value;
	var contPers2_old  	= document.myForm.contPers2_old.value;	
	
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
	var classification  		= document.myForm.classification.value;
	
<%
	for(int i=0;i<selOpts.length;i++)
	{
	 String str2 = selOpts[i].split("##")[1];
	 String str1 = selOpts[i].split("##")[0];
%>
	 var val_2 = "<%=str2%>";
	 var val_1 = "<%=str1%>";
	 if(classification==val_1)
	{
		classification=classification+" "+val_2;
		
	}
<%
	}

%>	
	
	
	//var classdes	  		= fields.split("-")[1];
	
	
	var classification_old  	= document.myForm.classification_old.value;
	var cDate  			= document.myForm.cDate.value;
	var cDate_old  			= document.myForm.cDate_old.value;
	
	var termc	=document.myForm.termc.value;
	
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
	if(changedStatutoryDetails!="" && attachType.indexOf(changedStatutoryDetails)<0)
	{
		alert("As Statutory details are changed please upload respective files");
		return;			
	}
	
	if(serBased!=serBased_old)
	{
		if(serBased=="N")
			serBased="No";
		else
			serBased="Yes";
		changedValues="Servised Based"+"$$"+serBased;
	}
	if(grBased!=grBased_old)
	{
		if(grBased=="N")
			grBased="No";
		else
			grBased="Yes";

		changedValues=changedValues+"##"+"GR Based"+"$$"+grBased;
	}


	if(addr1!=addr1_old)
		changedValues=changedValues+"##"+"Addr1/H.No."+"$$"+addr1;
	if(addr2!=addr2_old)
		changedValues=changedValues+"##"+"Addr2"+"$$"+addr2;		
	if(city!=city_old)
		changedValues=changedValues+"##"+"City"+"$$"+city;
	if(state!=state_old)
		changedValues=changedValues+"##"+"State"+"$$"+state;
	if(district!=district_old)
		changedValues=changedValues+"##"+"district"+"$$"+district;
	if(pin!=pin_old)
		changedValues=changedValues+"##"+"Pin"+"$$"+pin;		
	if(mobile!=mobile_old)
		changedValues=changedValues+"##"+"Mobile"+"$$"+mobile;		
	if(landline!=landline_old)
		changedValues=changedValues+"##"+"Landline"+"$$"+landline;
	if(fax!=fax_old)
		changedValues=changedValues+"##"+"Fax"+"$$"+fax;
	if(email!=email_old)
		changedValues=changedValues+"##"+"Email"+"$$"+email;		
	if(email2!=email2_old)
		changedValues=changedValues+"##"+"Email2"+"$$"+email2;		
	if(contPers1!=contPers1_old)
		changedValues=changedValues+"##"+"Contact Person 1"+"$$"+contPers1;
	if(contPers2!=contPers2_old)
		changedValues=changedValues+"##"+"Contact Person 2"+"$$"+contPers2;


	if(vat!=vat_old)
		changedValues=changedValues+"##"+"Vat"+"$$"+vat;
	if(cst!=cst_old)
		changedValues=changedValues+"##"+"Cst"+"$$"+cst;
	if(pan!=pan_old)
		changedValues=changedValues+"##"+"Pan"+"$$"+pan;
	if(servTax!=servTax_old)
		changedValues=changedValues+"##"+"Service Tax"+"$$"+servTax;
	if(eccNo!=eccNo_old)
		changedValues=changedValues+"##"+"Ecc No"+"$$"+eccNo;
	if(excRegNo!=excRegNo_old)
		changedValues=changedValues+"##"+"EXC. Reg No"+"$$"+excRegNo;
	if(rangeSel!=rangeSel_old)
		changedValues=changedValues+"##"+"EX. Range"+"$$"+rangeSel;
	if(exDiv!=exDiv_old)
		changedValues=changedValues+"##"+"EX. Division"+"$$"+exDiv;	
	if(commi!=commi_old)
		changedValues=changedValues+"##"+"COMMI"+"$$"+commi;	
	if(minIndi!=minIndi_old)
		changedValues=changedValues+"##"+"Category"+"$$"+minIndi;
	if(gst!=gst_old)
		changedValues=changedValues+"##"+"GSTIN"+"$$"+gst;	
	if(classification!=classification_old)
		changedValues=changedValues+"##"+"Classification"+"$$"+classification;	
	if(cDate!=cDate_old)
	changedValues=changedValues+"##"+"Certification Date"+"$$"+cDate;

	
	var bankObj = document.myForm.bankName;
	//alert(bankObj);
	var bankObjLen = bankObj.length;
	//alert(bankObjLen);
	var changedBankDetails="";
	if(isNaN(bankObjLen))
	{	
		var bankCountry   = document.myForm.bankCountry.value;
		var bankName  	  = document.myForm.bankName.value;
		var bankRegion    = document.myForm.bankRegion.value;
		var bankStreet    = document.myForm.bankStreet.value;
		var bankCity      = document.myForm.bankCity.value;
		var bankBranch 	  = document.myForm.bankBranch.value;
		var bankIFSCCode  = document.myForm.bankIFSCCode.value;
		var bankACCode 	  = document.myForm.bankACCode.value;
		var bankCurrency  = document.myForm.bankCurrency.value;
		var bankCountry_old   = document.myForm.bankCountry_old.value;
		var bankName_old  	  = document.myForm.bankName_old.value;
		var bankRegion_old    = document.myForm.bankRegion_old.value;
		var bankStreet_old    = document.myForm.bankStreet_old.value;
		var bankCity_old      = document.myForm.bankCity_old.value;
		var bankBranch_old 	  = document.myForm.bankBranch_old.value;
		var bankIFSCCode_old  = document.myForm.bankIFSCCode_old.value;
		var bankACCode_old 	  = document.myForm.bankACCode_old.value;
		var bankCurrency_old  = document.myForm.bankCurrency_old.value;
		//alert(i+"::1::bankACCode_old:::"+bankACCode_old);
 		//alert(i+"::1::bankACCode:::"+bankACCode);
 		if(bankName!=bankName_old)
			changedValues=changedValues+"##"+"Bank Name"+"$$"+bankName;
		if(bankRegion!=bankRegion_old)
			changedValues=changedValues+"##"+"Bank State"+"$$"+bankRegion;
		if(bankStreet!=bankStreet_old)
			changedValues=changedValues+"##"+"Bank Street"+"$$"+bankStreet;
		if(bankCity!=bankCity_old)
			changedValues=changedValues+"##"+"Bank City"+"$$"+bankCity;
		if(bankBranch!=bankBranch_old)
			changedValues=changedValues+"##"+"Branch"+"$$"+bankBranch;
		if(bankIFSCCode!=bankIFSCCode_old)
			changedValues=changedValues+"##"+"IFSC Code"+"$$"+bankIFSCCode;	
		if(bankACCode!=bankACCode_old)
			changedValues=changedValues+"##"+"Account Number"+"$$"+bankACCode;

		if(bankCurrency_old!=bankCurrency || bankACCode_old!=bankACCode || bankBranch_old!=bankBranch || bankIFSCCode_old!=bankIFSCCode || bankCountry_old!=bankCountry || bankName_old!=bankName || bankRegion_old!=bankRegion || bankStreet_old!=bankStreet || bankCity_old!=bankCity)
		{
			changedBankDetails=bankACCode_old;
		}
	}else{
	
		for(i=0;i<bankObjLen;i++)
		{
			var bankCountry   = document.myForm.bankCountry[i].value;
			var bankName  	  = document.myForm.bankName[i].value;
			var bankRegion    = document.myForm.bankRegion[i].value;
			var bankStreet    = document.myForm.bankStreet[i].value;
			var bankCity      = document.myForm.bankCity[i].value;
			var bankBranch 	  = document.myForm.bankBranch[i].value;
			var bankIFSCCode  = document.myForm.bankIFSCCode[i].value;
			var bankACCode 	  = document.myForm.bankACCode[i].value;
			var bankCurrency  = document.myForm.bankCurrency[i].value;	
			var bankCountry_old   = document.myForm.bankCountry_old[i].value;
			var bankName_old  	  = document.myForm.bankName_old[i].value;
			var bankRegion_old    = document.myForm.bankRegion_old[i].value;
			var bankStreet_old    = document.myForm.bankStreet_old[i].value;
			var bankCity_old      = document.myForm.bankCity_old[i].value;
			var bankBranch_old 	  = document.myForm.bankBranch_old[i].value;
			var bankIFSCCode_old  = document.myForm.bankIFSCCode_old[i].value;
			var bankACCode_old 	  = document.myForm.bankACCode_old[i].value;
			var bankCurrency_old  = document.myForm.bankCurrency_old[i].value;
			//alert(i+"::::bankACCode_old:::"+bankACCode_old);
 			//alert(i+"::::bankACCode:::"+bankACCode);
 			if(bankName!=bankName_old)
				changedValues=changedValues+"##"+"Bank Name["+(i+1)+"]$$"+(bankName);
			if(bankRegion!=bankRegion_old)
				changedValues=changedValues+"##"+"Bank State["+(i+1)+"]$$"+bankRegion;
			if(bankStreet!=bankStreet_old)
				changedValues=changedValues+"##"+"Bank Street["+(i+1)+"]$$"+bankStreet;
			if(bankCity!=bankCity_old)
				changedValues=changedValues+"##"+"Bank City["+(i+1)+"]$$"+bankCity;
			if(bankBranch!=bankBranch_old)
				changedValues=changedValues+"##"+"Branch["+(i+1)+"]$$"+bankBranch;
			if(bankIFSCCode!=bankIFSCCode_old)
				changedValues=changedValues+"##"+"IFSC Code["+(i+1)+"]$$"+bankIFSCCode;	
			if(bankACCode!=bankACCode_old)
				changedValues=changedValues+"##"+"Account Number["+(i+1)+"]$$"+bankACCode;
 			
			if(bankCurrency_old!=bankCurrency || bankACCode_old!=bankACCode || bankBranch_old!=bankBranch || bankIFSCCode_old!=bankIFSCCode || bankCountry_old!=bankCountry || bankName_old!=bankName || bankRegion_old!=bankRegion || bankStreet_old!=bankStreet || bankCity_old!=bankCity)
			{
				if(bankACCode_old=="")
				changedBankDetails=bankACCode;
				else
				changedBankDetails=bankACCode_old;
				
				if(changedBankDetails!="" && attachType.indexOf(changedBankDetails)<0)
				{
					alert("As bank AC code :"+changedBankDetails+" details are changed please upload respective files");
					i=bankObjLen;
					return;
				
				}
				
			}
		}
	}
	var changedValuesChk = changedValues.startsWith("##");
	if(changedValuesChk)
		changedValues = changedValues.substr(2,changedValues.length);
	document.myForm.changedValues.value=changedValues;
	
	if (!$("#myForm").valid()) 
	{
	
		return false;
      	}
	else{	
	
	//	$( "#dialog-editDetails" ).dialog("option", "title", "Disclaimer");
	//	$( "#dialog-editDetails" ).dialog('open').text("Any changes made on portal will reflect post verification by company.");
	
	var Url="ezVendorDisclamier.jsp";
			$.fancybox.open({
			href : Url,
			type : 'iframe',
			padding : 5,
			width:'70%',
			height:'370px',
			autoSize : false,
			closeBtn : true,
			helpers     : { 
					overlay : {closeClick: false}
		 }
	});
	} 
 
   }
   
function funBack() 
{
	document.myForm.action="ezVendorDetails.jsp";
	document.myForm.submit();
}

$(function() { 
		
	 $( "#dialog-editDetails" ).dialog({
	 
	 	open: function() {
		$(this).closest(".ui-dialog")
		.find(".ui-dialog-titlebar-close")
		.removeClass("ui-dialog-titlebar-close")
		.html("<span class='ui-button-icon-primary ui-icon ui-icon-closethick'></span>");
    		},
		autoOpen: false,
		resizable: true,
		height:900,
		width:600,
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
function funAgree()
{
document.myForm.action="ezSaveVendorDetails.jsp";
document.myForm.submit();
}
function funUpload(bankACCode)
{
var bankListStr="";
var bankObj = document.myForm.bankCountry_old;
	var bankObjLen = bankObj.length;
	var changedBankDetails="";
	if(isNaN(bankObjLen))
	{	
		var bankName  	  = document.myForm.bankName.value;
		var bankACCode 	  = document.myForm.bankACCode.value;
		bankListStr=bankACCode+"-"+bankName;
	}else{
	
		for(i=0;i<bankObjLen;i++)
		{
			var bankName  	  = document.myForm.bankName[i].value;
			var bankACCode 	  = document.myForm.bankACCode[i].value;
			
			if(bankListStr=="")
			bankListStr=bankACCode+"-"+bankName;
			else
			bankListStr=bankListStr+"¥"+bankACCode+"-"+bankName;

		}
	}
	
bankACCode=bankListStr;
//alert(bankACCode);
			
			
	var Url="ezFileAttachment.jsp?bankACCode="+bankACCode;
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
$(document).ready(function(){
	$(function() { 	
	
	$.validator.addMethod("cDate2", function(value) { 
	//alert($('#minIndi').val()+"::::");
		return !($('#minIndi').val() == "05" || $('#minIndi').val() == "06" || $('#minIndi').val() == "07");
		}, "Enter certification date");
		
	
		
		$("#myForm").validate({
				onfocusout: function (element, event) {
		        if (element.name == "cDate") {
		            $.validator.defaults.onfocusout.call(this, element, event);
		        }
		        else{
				$(element).valid();
				}
		},
			
			errorClass: "my-error-class",
					errorPlacement: function(error, element) {
					    if (element.attr("name") == "termc" )
					        error.insertAfter(".errorTxt");
					    else
					        error.insertAfter(element);
		},
			
			rules: {
				addr1: {
					required: false
				},
				serBased: {
					required: false
				},
				addr2: {
					required: false
				},
				street: {
					required: false
				},
				contPers1: {
					required: false
				},
				contPers2: {
					required: false
				},
				city: {
					required: false,
					lettersonly: true 
				},
				district: {
					required: false,
					lettersonly: true 
				},
				pan: {
					required: true,
					alphanumeric: true
				},
				pin: {
				      required: false,
				      digits: true
    				},
    				landline: {
				      required: false,
				      digits: false
    				},
    				mobile: {
				      required: false,
				      digits: true
    				},
    				fax: {
				      required: false,
				      digits: false
    				},
    				eccNo: {
				      required: false,
				      alphanumeric: true
    				},
    				excRegNo: {
				      required: false,
				      alphanumeric: true
    				},
    				bankACCode: {
				      required: false,
				      digits: false
    				},
    				email: {
				      required: false,
				      email: true
    				},
    				email2: {
				      required: false,
				      email: true
    				},
    				vat: {
					required: false,
					maxlength: 20,
					number: true
				},
				cst: {
					required: false,
					maxlength: 40,
					number: true
					
					
				},
				servTax: {
					required: false,
					maxlength: 40,
					number: true
				},
				gst: {
					required: false,
					minlength: 15,
					alphanumeric: true
				},
				termc: {
					required: true,						
				},
				exDiv: {
					required: false,
					alphanumeric: true
				},
				commi: {
					required: false,
					alphanumeric: true
				},
				rangeSel: {
					required: false,
					alphanumeric: true
				},
				cDate: {
					cDate2: true,
					alphanumeric: false
				},
				bankName: {
					required: false
				},
				bankStreet: {
					required: false
				},
				bankCity: {
					required: false,
					lettersonly: false 
				},
				bankBranch: {
					required: false
				},
				bankIFSCCode: {
					required: false,
					alphanumeric: true
				}
				
			},
			messages: {
				addr1: {
					required: "Please Enter Address"
				},
				serBased: {
					required: "Please Enter Servise Base"
				},
				addr2: {
					required: "Please Enter Address 2"
				},
				street: {
					required: "Please Enter street"
				},
				contPers1: {
					required: "Please Enter Contact Person 1"
				},
				contPers2: {
					required: "Please Enter Contact Person 2"
				},
				city: {
					required: "Please Enter city",
					lettersonly: "Please Enter only Alphabets" 
				},
				district: {
					required: "Please Enter District",
					lettersonly: "Please Enter only Alphabets" 
				},
				pan: {
					required: "Please Enter Pan No",
					alphanumeric: "Please Enter only Alphanumeric Characters"
				},
				pin: {
					required: "Please Enter Pin",
					digits: "Please enter only digits"
				},
				landline: {
					required: "Please Enter Landline No",
					digits: "Please enter only digits"
				},
				mobile: {
					required: "Please Enter Mobile No",
					digits: "Please enter only digits"
				},
				fax: {
					required: "Please Enter Fax",
					digits: "Please enter only digits"
				},
				eccNo: {
					required: "Please Enter Ecc No",
					alphanumeric: "Please Enter only Alphanumeric Characters"
				},
				excRegNo: {
					required: "Please Enter EXC. Reg No",
					alphanumeric: "Please Enter only Alphanumeric Characters"
				},
				bankACCode: {
					required: "Please Enter AC Code",
					digits: "Please enter only digits"
				},
				email: {
					required: "Please Enter Email Id",
					email: "Please enter valid Email Id."
				},
				email2: {
					required: "Please Enter Email Id",
					email: "Please enter valid Email Id."
				},
				vat : {
					required: "Please Enter VAT %",
					maxlength: "VAT must consist of only 4 characters ",
					number: "Please Enter only Numerics only"
				},
				cst : {
					required: "Please Enter CST %",
					maxlength: "CST must consist of only 4 characters ",
					number: "Please Enter only Numerics only"
				},
				servTax : {
					required: "Please Enter Service Tax",
					maxlength: "Service Tax must consist of only 4 characters ",
					number: "Please Enter only Numerics only"
				},
				gst : {
					required: "Please Enter GSTIN.",
					maxlength: "GSTIN must consist of only 15 characters ",
					alphanumeric: "Please Enter only Alphanumeric Characters"
				},
				termc : {
					required: "Please accept Terms and Conditon before submit.",					
				},
				exDiv : {
					required: "Please Enter EX. Division",
					alphanumeric: "Please Enter only Alphanumeric Characters"
				},
				commi : {
					required: "Please Enter Commi.",
					alphanumeric: "Please Enter only Alphanumeric Characters"
				},
				rangeSel : {
					required: "Please Enter EX. Range",
					alphanumeric: "Please Enter only Alphanumeric Characters"
				},
				cDate: {
					required: "Please Enter Certification Date",
					alphanumeric: "Please Enter only Alphanumeric Characters"
				},
				bankName: {
					required: "Please Enter Bank Name"
				},
				bankStreet: {
					required: "Please Enter Bank Street"
				},
				bankCity: {
					required: "Please Enter Bank City",
					lettersonly: "Please Enter only letters"  
				},
				bankBranch: {
					required: "Please Enter Bank Branch"
				},
				bankIFSCCode: {
					required: "Please Enter Bank IFSC code",
					alphanumeric: "Please Enter only Alphanumeric Characters"
				}
			}
		});
	});
	
});
</script>
<script src="../../../../EzCommon/Library/jquery-ui-1.10.4/js/jquery-ui-1.10.4.custom.js"></script>
<script>
	$("#cDate").datepicker({ 
	              	dateFormat: 'dd/mm/yy',
			changeMonth: true,
			changeYear: true
	       });	
</script>

		

</Html>
<%@ include file="ezFooter1.jsp"%> 

 <script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.js"></script>
<script type="text/javascript" src="../Misc/library/fancybox2/jquery.fancybox.pack.js"></script>

