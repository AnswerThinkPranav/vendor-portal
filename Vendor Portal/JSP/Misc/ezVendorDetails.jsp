<%@ page import="ezc.ezmisc.params.*,ezc.vendorprofile.params.*,ezc.ezparam.*,java.util.*,java.text.*" %>		
<jsp:useBean id="vendorprofile" class="ezc.vendorprofile.client.EzVendorProfileManager" scope="session"></jsp:useBean>
<%@ include file="ezGetVendSAPDetails.jsp"%>
<%@ include file="iVendorDetails.jsp" %>
<%@ include file="ezCommonMethods.jsp" %>
<%@ include file="ezGetUserAuthDefaults.jsp"%> 

    
<%  					//out.println("::CLIENT::"+CLIENT+"::::"+ADDRNUMBER+"::::"+PERSNUMBER+"::::"+DATE_FROM+"::::"+CONSNUMBER+"::::"+SMTP_ADDR+"::::"+SMTP_SRCH);	 

	String usrId	=	"xyz";
	String vendUser	= 	(String)Session.getUserId();
	//out.println("::::::::::::::userDefCompCode::::::::::::"+userDefCompCode);
	
		ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(true);
		ezc.vendorprofile.params.EziVendorGeneralDataParams generalParams= new ezc.vendorprofile.params.EziVendorGeneralDataParams();
		ezc.vendorprofile.params.EziVendorProfileKeyParams keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();
		EziVendorKeyParamsTable keyTableParams = new EziVendorKeyParamsTable();

		keyParams.setKey("GetGeneralData");
		keyTableParams.appendRow(keyParams);
		mainParams.setLocalStore("Y");

		generalParams.setStatus("OPEN");
		//generalParams.setVendor(vendUser);	
String selVendorTemp="0000000000"+(String)Session.getUserId();
		selVendorTemp=selVendorTemp.substring(((String)Session.getUserId()).length(),selVendorTemp.length());
	generalParams.setVendor((String)Session.getUserId()+"','"+selVendorTemp);
	
		mainParams.setObject(generalParams);
		mainParams.setObject(keyTableParams);
		Session.prepareParams(mainParams);

		ReturnObjFromRetrieve vendorGeneralData =null;
		int vendorGeneralDataCnt=0;
		try{
		 vendorGeneralData=(ReturnObjFromRetrieve)vendorprofile.ezGetDetails(mainParams);
		 vendorGeneralData=((ReturnObjFromRetrieve)vendorGeneralData.getObject("GetGeneralData"));
		 if(vendorGeneralData!=null)vendorGeneralDataCnt=vendorGeneralData.getRowCount();
		 //out.println(vendorGeneralDataCnt+":::::::::::::vendorGeneralDataCnt");
		 }
		 catch(Exception e){}	
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
       
          <h5>
            <B>Self Service > View/Change Profile</B>
           
 <%
 		Vector orgList_V = new Vector();
		if(orgListRetObj!=null)
		{
			session.putValue("orgListRetObj",orgListRetObj);
			for(int k=0;k<orgListRetObj.getRowCount();k++)
			{
				
				
				EKORG = checkNull(orgListRetObj.getFieldValueString(k,"PURORG"));
				WEBRE = checkNull(orgListRetObj.getFieldValueString(k,"GRBASED"));
				LEBRE = checkNull(orgListRetObj.getFieldValueString(k,"SERBASED"));
				WAERS = checkNull(orgListRetObj.getFieldValueString(k,"CURRRENCY"));
				//out.println("EKORG<>"+EKORG+"<>"+WEBRE+"<>"+LEBRE+"<>"+WAERS);
				orgList_V.add(EKORG);

			}	
				//out.println("EKORG<>"+orgListRetObj.getRowCount());
		}
%>
	

	            	
	      
          </h5>
        </section>

        <!-- Main content -->  
        <section class="content">  
        <Body>
        <form method="post"  name="myForm">
	

<Div class="row">
	<Div class=" col-md-12 col-sm-12 col-xs-12"> 
		<Div class="box box-info collapsed-box">
			<Div class="box-header ">
				<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i><B>&nbsp;&nbsp;<Font size=2 color=BLACK>BASIC DETAILS</Font></B></button>                
			</Div>
			<Div class="box-body" style="display: block;">
				<Div class="table-responsive">
				<Table class="table no-margin">
				<TBody style="font-size: 12px;">
				<Tr>
					<Th align=right style="padding-top: 10px;line-height: inherit;">Vendor Code</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="vendCode" id="vendCode" value="<%=LIFNR%>"  >
					</Td>
					
					<!--<Th align=right>Service Based</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="serBased" id="serBased" value="<%=LEBRE%>"  >
					</Td>-->
					<!--<Th>ServAgntProcGrp</Th>
					<Td colspan="4">
					<Input readonly  type="text" style="text-transform: uppercase;" name="procGrp" id="procGrp" value="<%=DLGRP%>"  >																				
					</Td>-->
					<Th align=right style="padding-top: 15px;">Vendor Name</Th>
					<Td colspan="4" style="padding-top: 15px;">
					<Input readonly  type="hidden" style="text-transform: uppercase;" name="venName" id="venName" value="<%=NAME1+NAME2%>"  ><%=NAME1+NAME2%>
					
					</Td> 
				</Tr>				
				<Tr>
					<Th align=right style="padding-top: 10px;line-height: inherit;">Company Code</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="compCode" id="compCode" value="<%=BUKRS%>"  >
					</Td>
					<Th align=right style="padding-top: 15px;">Service Based</Th>
					<Td colspan="4" style="padding-top: 15px;">
					<%
					String srvBasedStr="No";
					if("X".equals(LEBRE))
					{
					srvBasedStr="Yes";
					}
					%>
					<%=srvBasedStr%>
						<Input readonly  type="hidden" style="text-transform: uppercase;" name="serBased" id="serBased" value="<%=LEBRE%>"  maxlength="1">
					</Td>					
					<!--<Th align=right>Coromandel Location</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="corLoc" id="corLoc" value="<%=EKORG%>"  maxlength="4">

					</Td>-->
					<Th align=right style="padding-top: 15px;">GR Based</Th>
					<Td colspan="4" style="padding-top: 15px;">
					<%
					String grBasedStr="No";
					if("X".equals(WEBRE))
					{
					grBasedStr="Yes";
					}
					%>
					<%=grBasedStr%>
						<Input readonly  type="hidden" style="text-transform: uppercase;" name="grBased" id="grBased" value="<%=WEBRE%>"  maxlength="1">

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
			<TBody style="font-size: 12px;">
				<Tr>
					<Th align=right style="padding-top: 10px;line-height: inherit;">Title</Th>
					<Td colspan="4">
					<Input readonly  type="text" style="text-transform: uppercase;"  value="<%=ANRED%>"  maxlength="4">
						<!--<select disabled name="titleSel" id="titleSel">
							<option value="<%=ANRED%>" selected><%=ANRED%></option>
							<option value="mrs.">mrs.</option>
							<option value="m/s">m/s</option>
						</select>					-->

					</Td>
					<Th align=right style="padding-top: 10px;line-height: inherit;">Name1</Th>
					<Td colspan="4" style="padding-top: 15px;">
						<Input readonly  type="hidden" style="text-transform: uppercase;" name="name1" id="name1" value="<%=NAME1%>"  maxlength="35"><%=NAME1%>

					</Td>
					<Th align=right style="padding-top: 10px;line-height: inherit;">Name2</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="name2" id="name2" value="<%=NAME2%>"  maxlength="35">
											
					</Td>
				</Tr>
				
				<Tr>
					<Th align=right style="padding-top: 10px;line-height: inherit;">Addr1 / H.No</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="addr1" id="addr1" value="<%=NAME3%>"  maxlength="10">

					</Td>

					<Th align=right style="padding-top: 10px;line-height: inherit;">Addr2</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="addr2" id="addr2" value="<%=NAME4%>"  maxlength="10">

					</Td>
					<Th align=right style="padding-top: 10px;line-height: inherit;">Street</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="street" id="street" value="<%=STRAS%>"  maxlength="60">
											
					</Td>
				</Tr>
				<Tr>
					
					<Th align=right style="padding-top: 10px;line-height: inherit;">City</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="city" id="city" value="<%=ORT01%>"  maxlength="35">

					</Td>
					<Th align=right style="padding-top: 10px;line-height: inherit;">State</Th>
					<Td colspan="4">
			<%	java.util.Hashtable stateHT = new java.util.Hashtable();
				statevalue="";					  
				  for (int i=0;i<StateCnt;i++) 
				{
					 statekey = checkNull(retState.getFieldValueString(i,"EMKV_VALUE"));
					 
					 if(statekey.equals(REGIO))
					 {
					 statevalue = retState.getFieldValueString(i,"EMKV_VALUE1");
					 statevalue = statevalue.trim();
					 break;
					 }

				}
						
			%>					
			<%=statevalue%>--
					<Input readonly  type="text" style="text-transform: uppercase;" name="state" id="state" value="<%=REGIO%>"  maxlength="2">
						<!--<select disabled  name="state" id="state">
							<option value="<%=REGIO%>" selected><%=REGIO%></option>
						</select>					-->

					</Td>
					<Th align=right style="padding-top: 10px;line-height: inherit;">Country</Th>
					<Td  colspan="4">
				<%	java.util.Hashtable cntryHT = new java.util.Hashtable();
																		  
					  for (int i=0;i<CountryCnt;i++) 
					{
							 key = checkNull(retCountry.getFieldValueString(i,"EMKV_KEY"));
							 value = checkNull(retCountry.getFieldValueString(i,"EMKV_VALUE"));
							cntryHT.put(key,value);
							//out.println("<<<"+key+"<<<<<<"+cntryHT.get(key));
					}
							
							String cntry =checkNull((String)cntryHT.get(LAND1));
							cntry = cntry.trim();
							//out.println(cntry+"<<<"+key+"<<<<<<"+cntryHT.get(LAND1));
			%>
						
			
						
					<%=cntry%>--	
					<Input readonly  type="text" style="text-transform: uppercase;" name="country" id="country" value="<%=LAND1%>"  maxlength="2">
						<!--<select disabled  name="country" id="country">	
							<option value="<%=LAND1%>" selected><%=LAND1%></option>
						</select>					-->

					</Td>
				</Tr>
				<Tr>
					<Th align=right style="padding-top: 10px;line-height: inherit;">District</Th>
					<Td colspan="4">
					<Input readonly  type="text" style="text-transform: uppercase;" name="district" id="district" value="<%=ORT02%>"  maxlength="20">
						<!--<select disabled  name="district" id="district">
							<option value="<%=ORT02%>" selected><%=ORT02%></option>
						</select>					-->

					</Td>

					<Th align=right style="padding-top: 10px;line-height: inherit;">PinCode</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="pin" id="pin" value="<%=PSTLZ%>"  maxlength="10">

					</Td>
					</Tr>
					<Tr>
					<Th align=right style="padding-top: 10px;line-height: inherit;">Landline</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="landline" id="landline" value="<%=TELF1%>"  maxlength="16">

					</Td>
					<Th align=right style="padding-top: 10px;line-height: inherit;">Mobile</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="mobile" id="mobile" value="<%=TELF2%>"  maxlength="16">
 
					</Td>
					<Th align=right style="padding-top: 10px;line-height: inherit;">Fax</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="fax" id="fax" value="<%=TELFX%>"  maxlength="31">
											
					</Td>
				</Tr>
				 <Tr>
					<Th align=right style="padding-top: 10px;line-height: inherit;">EMail</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="email" id="email" value="<%=SMTP_ADDR%>"  maxlength="241">
					</Td>
					<Th align=right style="padding-top: 10px;line-height: inherit;">EMail 2</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="email2" id="email2" value=""  maxlength="241">
					</Td>					
					
				</Tr>
				<Tr>
					<Th align=right style="padding-top: 10px;line-height: inherit;">Contact Person 1</Th>
					<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="contPers1" id="contPers1" value="<%=NAMEV%>"  maxlength="10">
					</Td>
					<Th align=right style="padding-top: 10px;line-height: inherit;">Contact Person 2</Th>
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
			<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i><B>&nbsp;&nbsp;<Font size=2 color=BLACK>STATUTORY</Font></B></button>                
		</Div>
		<Div class="box-body" style="display: block;">
		<Div class="table-responsive">
		<Table class="table no-margin">
		<TBody style="font-size: 12px;">			
				<Th align=right style="padding-top: 10px;line-height: inherit;">PAN</Th>
				<Td colspan="4">
						<Input readonly  type="text" style="text-transform: uppercase;" name="pan" id="pan" value="<%=J_1IPANNO%>"  maxlength="15">
				</Td>
				<Th align=right style="padding-top: 10px;line-height: inherit;">GSTIN</Th>
				<Td colspan="4">
					<Input readonly  type="text" style="text-transform: uppercase;" name="gst" id="gst" value="<%=checkNull(GSTIN)%>"  maxlength="40">
				</Td>

				<Th align=right style="padding-top: 10px;line-height: inherit;">Classification</Th>
				<Td colspan="4">
					<Input type = 'hidden' name="classification" id="classification" value="<%=CLASSIF%>"  maxlength="2">
					<Input readonly  type="text" style="text-transform: uppercase;" name="classification" id="classification" value="<%=checkNull(CLASSIF_DESC)+"--"+checkNull(CLASSIF)%>"  maxlength="2">
				</Td>	
				
			</Tr>			
			<Tr>
				<Th align=right style="padding-top: 10px;line-height: inherit;">Category</Th>
				<Td colspan="4">
			<%	java.util.Hashtable minIndHT = new java.util.Hashtable();
																		  
				 for (int i=0;i<MinIndCnt;i++) 
				{

					 MinIndkey = checkNull(retMinInd.getFieldValueString(i,"EMKV_KEY"));
					 MinIndvalue = checkNull(retMinInd.getFieldValueString(i,"EMKV_VALUE"));
						minIndHT.put(MinIndkey,MinIndvalue);
						//out.println("<<<"+key+"<<<<<<"+minIndHT.get(MinIndkey));
				}

						String minInd =checkNull((String)minIndHT.get(MINDK));
						minInd = minInd.trim();
						//out.println(minInd+"<<<"+key+"<<<<<<"+minIndHT.get(LAND1));
			%>
			<%=minInd%>--
				<Input readonly  type="text" style="text-transform: uppercase;" name="minIndi" id="minIndi" value="<%=MINDK%>"  maxlength="2">
					<!--<select disabled  name="minIndi" id="minIndi">
						<option value="G001" selected><%=MINDK%></option>
					</select>					-->
				</Td>
							
			
				<Th align=right style="padding-top: 10px;line-height: inherit;">
					Certification Date
				 </Th>
				<Td colspan="4">
				<Input readonly  type="text" style="text-transform: uppercase;" name="creatDate" id="creatDate" value="<%=CERDTStr%>" >
				
				</Td>
		</Tr>
		</TBody>               

		</Table>
		</Div>
		<!-- /.table-responsive -->
		</Div>       
		</Div>

<%
	if(bankListRetObj!=null)
	{
		//for(int k=0;k<bankListRetObj.getRowCount();k++)
		for(int k=0;k<1;k++)
		{
			String keyStr = checkNull(bankListRetObj.getFieldValueString(k,"KEY"));
			BANKN = checkNull(bankListRetObj.getFieldValueString(k,"ACCOUNT_CODE"));
			
			int index = bankAddrRetObj.getRowId("KEY",keyStr);
			
			if(index>=0)
			{
				BANKL = checkNull(bankAddrRetObj.getFieldValueString(index,"KEY"));
				BANKS = checkNull(bankAddrRetObj.getFieldValueString(index,"COUNTRY"));
				BANKA = checkNull(bankAddrRetObj.getFieldValueString(index,"BANK_NAME"));
				PROVZ = checkNull(bankAddrRetObj.getFieldValueString(index,"REGION"));
				STRASBank = checkNull(bankAddrRetObj.getFieldValueString(index,"STREET"));
				ORT01Bank = checkNull(bankAddrRetObj.getFieldValueString(index,"CITY"));
				BRNCH = checkNull(bankAddrRetObj.getFieldValueString(index,"BRANCH"));
				BKREF = checkNull(bankAddrRetObj.getFieldValueString(index,"IFSC"));
				WAERS = checkNull(bankAddrRetObj.getFieldValueString(index,"CURRENCY"));

			}
%>
<input type="hidden" name="bankIndex" value="<%=k+1%>">
			<Div class="box box-info collapsed-box">    
			<Div class="box-header ">
				<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i><B>&nbsp;&nbsp;<Font size=2 color=BLACK>BANK (<%=BANKN%>)</Font></B></button>                
			</Div>	  
					    <Div class="box-body" style="display: block;">
				      <Div class="table-responsive">
					<Table class="table no-margin">



			<TBody style="font-size: 12px;"><Tr>
			<Th align=right style="padding-top: 10px;line-height: inherit;">
				Country
			</Th>
			<Td colspan="4">
			<%
				String bnkcntry =(String)cntryHT.get(BANKS);
				if(bnkcntry==null || "null".equals(bnkcntry))bnkcntry="";
				bnkcntry=bnkcntry.trim();
			%>
			<%=bnkcntry%>--
			<Input readonly  type="text" style="text-transform: uppercase;" name="bankCountry" id="bankCountry" value="<%=BANKS%>"  maxlength="3">
			<input type="hidden" name="bankKey" value="<%=keyStr%>">
			</Td>
			<Th align=right style="padding-top: 10px;line-height: inherit;">
				Bank Name
			</Th>
			<Td colspan="4">
			<Input readonly  type="text" style="text-transform: uppercase;" name="bankName" id="bankName" value="<%=BANKA%>"  maxlength="60">

			</Td>
			<Th align=right style="padding-top: 10px;line-height: inherit;">
				State
			</Th>
			<Td colspan="4">
<%
			statevalue="";
			for (int i=0;i<StateCnt;i++)
			 {
			 	statekey = retState.getFieldValueString(i,"EMKV_VALUE");
			 	if(statekey.equals(PROVZ))
			 	{
			 	statevalue = retState.getFieldValueString(i,"EMKV_VALUE1");
				break;
				}
			 }
%>
			 <%=statevalue%>--
			<Input readonly  type="text" style="text-transform: uppercase;" name="bankRegion" id="bankRegion" value="<%=PROVZ%>"  maxlength="3">

			</Td>

			</Tr>

			<Tr><Th align=right style="padding-top: 10px;line-height: inherit;">
				Street
			 </Th>
			<Td colspan="4">
			<Input readonly  type="text" style="text-transform: uppercase;" name="bankStreet" id="bankStreet" value="<%=STRASBank%>"  maxlength="35">

			</Td>
			<Th align=right style="padding-top: 10px;line-height: inherit;">
				City
			</Th>
			<Td colspan="4">
			<Input readonly  type="text" style="text-transform: uppercase;" name="bankCity" id="bankCity" value="<%=ORT01Bank%>"  maxlength="35">

			</Td>
			<Th align=right style="padding-top: 10px;line-height: inherit;">
				Branch
			</Th>
			<Td colspan="4">
			<Input readonly  type="text" style="text-transform: uppercase;" name="bankBranch" id="bankBranch" value="<%=BRNCH%>"  maxlength="40">

			</Td>
			</Tr>
			<Tr>
			<Th align=right style="padding-top: 10px;line-height: inherit;">
				IFSC Code
			</Th>
			<Td colspan="4">
			<Input readonly  type="text" style="text-transform: uppercase;" name="bankIFSCCode" id="bankIFSCCode" value="<%=BKREF%>"  maxlength="11">

			</Td>


			<Th align=right style="padding-top: 10px;line-height: inherit;">
				Account Number
			</Th>
			<Td colspan="4">
			<Input readonly  type="text" style="text-transform: uppercase;" name="bankACCode" id="bankACCode" value="<%=BANKN%>"  maxlength="15">

			</Td>
			<Th align=right style="padding-top: 10px;line-height: inherit;">
				Currency
			</Th>
			<Td colspan="4">	
			<%	java.util.Hashtable currHT = new java.util.Hashtable();							  
					  for (int i=0;i<CurrCnt;i++) 
					{
							 currkey = retCurrency.getFieldValueString(i,"EMKV_KEY");
							 currvalue = retCurrency.getFieldValueString(i,"EMKV_VALUE");
							currHT.put(currkey,currvalue);
							//out.println("<<<"+currkey+"<<<<<<"+currHT.get(currkey));
					}
							
							String curr =(String)currHT.get(WAERS);
							curr = curr.trim();
							//out.println(curr+"<<<"+currkey+"<<<<<<"+currHT.get(WAERS));
			%>
			<%=curr%>--
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
<%
		}
	}
%>
			<!--<Div class="box box-info collapsed-box">            
			<Div class="box-header ">
				<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i><B>&nbsp;&nbsp;<Font size=2 color=BLACK>PAYMENT DETAILS</Font></B></button>                
			</Div>	       
					    <Div class="box-body" style="display: block;">
				      <Div class="table-responsive">
					<Table class="table no-margin">



			<TBody style="font-size: 12px;">

			
			<Tr>
				<Th align=right style="padding-top: 10px;line-height: inherit;">
					P Terms
				</Th>
				<Td colspan="4">
					<Input readonly  type="text" style="text-transform: uppercase;" name="pTerms" id="pTerms" value="<%=ZTERMComp%>"  maxlength="4">
			
				</Td>	

				<Th align=right style="padding-top: 10px;line-height: inherit;">
					Payment Method
				</Th>
				<Td colspan="4">
				<Input readonly  type="text" style="text-transform: uppercase;" name="paymMethod" id="paymMethod" value="<%=ZWELS%>"  maxlength="10">

				</Td>
				<Th align=right style="padding-top: 10px;line-height: inherit;">
					Creation Date
				 </Th>
				<Td colspan="4">
				<Input readonly  type="text" style="text-transform: uppercase;" name="creatDate" id="creatDate" value="<%=CERDT%>" >

				</Td>


			 </Tr>
			<Tr>
				<Th align=right style="padding-top: 10px;line-height: inherit;">
					House Bank
				</Th>
				<Td colspan="4">
				<Input readonly  type="text" style="text-transform: uppercase;" name="houseBank" id="houseBank" value="<%=HBKID%>"  maxlength="5">

				</Td>

				<Th align=right style="padding-top: 10px;line-height: inherit;">
					Schema Group
				</Th>
				<Td>
					<Input readonly  type="text" style="text-transform: uppercase;" name="schemaGroup" id="schemaGroup" value="<%=KALSK%>"  maxlength="2">
				

				</Td>					

			</Tr>
			
			</TBody>
			</Table>
		</Div>
	</Div>         		  
</Div>-->
<!-- /.box-header --> 

<%
if(vendorGeneralDataCnt>0)
{
%> 
	<Div class="col-xs-12 col-md-9 col-md-offset-3" style="padding-right:3px;">
	<p style="color:red"><B>Request is already opened please close the open request to proceed.</B></p>
	</div>
	<div class="col-xs-12 col-md-7 col-md-offset-5" style="padding-right:3px;">
	<button type="button" class="btn btn-primary" onclick="funEDIT()" disabled>EDIT DETAILS</button>
<%
}
else
{
%>
	<div class="col-xs-12 col-md-7 col-md-offset-5" style="padding-right:3px;">
	<button type="button" class="btn btn-primary" onclick="funEDIT()" disabled>EDIT DETAILS</button>
<%
}
%>
</Div>	
<input type="hidden" name="titleSel" id="titleSel" value="<%=ANRED%>" />	
<script>
function funAlert(){
alert("Request is already opened please close the open request to proceed.");
return false;
}
function funEDIT()
{
	var Url="ezOTPGeneration.jsp?vendor=<%=LIFNR%>&mobile=<%=TELF2%>";
		$.fancybox.open({

		href : Url,
		type : 'iframe',
		padding : 5,
		width:'35%',
		height:'250px',
		autoSize : false,
		closeBtn : true,
		helpers     : { 
				overlay : {closeClick: false}
		 }
	});
	
 	var titleSel= document.myForm.titleSel.value;
 	//document.myForm.action="ezVendorDetailsEdit.jsp";
	//document.myForm.submit();
	
}
function funSubmit()
{
document.myForm.action="ezVendorDetailsEdit.jsp";
//document.myForm.action="ezNewVendorRegistrationFormNew.jsp";
	document.myForm.submit();
}
</script>
		
				</form>
			</Body>
		
			
		        </section><!-- /.content -->
		      </Div><!-- /.content-wrapper --> 
		</Html>
      

<%@ include file="ezFooter.jsp"%> 
<link rel="stylesheet" href="library/fancybox2/jquery.fancybox.css" type="text/css" media="screen" />  
 <script type="text/javascript" src="library/fancybox2/jquery.fancybox.js"></script>
<script type="text/javascript" src="library/fancybox2/jquery.fancybox.pack.js"></script>


  