<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*,java.util.*" %>		
<%@ include file="iVendorDetails.jsp" %>
<%@ include file="ezCommonMethods.jsp" %>
<%@ include file="ezGetUserAuthDefaults.jsp"%> 
<jsp:useBean id="esManager" class="ezc.client.EzSystemConfigManager" scope="session"/>
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
<%
//out.println("<<<<<<<<<"+soldTo);
%>
<%
try{
session.removeValue("ATTACHEDFILES");
}catch(Exception e){}
%>
<%  

String vendCode = (String)Session.getUserId();//checkNull(request.getParameter("vendCode"));
	String compCode = checkNull(request.getParameter("compCode"));
	String serBased = checkNull(request.getParameter("serBased"));
	String venName  = checkNull(request.getParameter("venName"));
	String corLoc   = checkNull(request.getParameter("corLoc"));
	String grBased  = checkNull(request.getParameter("grBased"));
	String procGrp  = checkNull(request.getParameter("procGrp"));
	
	String titleSel = checkNull(request.getParameter("titleSel"));
	out.println("titleSel:::"+titleSel);
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
	
	/*String bankCountry[] = request.getParameterValues("bankCountry");
	String bankName[]    = request.getParameterValues("bankName");
	String bankRegion[]  = request.getParameterValues("bankRegion");
	String bankStreet[]  = request.getParameterValues("bankStreet");
	String bankCity[]    = request.getParameterValues("bankCity");
	String bankBranch[]  = request.getParameterValues("bankBranch");
	String bankIFSCCode[]= request.getParameterValues("bankIFSCCode");
	String bankACCode[]  = request.getParameterValues("bankACCode");
	String bankCurrency[]= request.getParameterValues("bankCurrency");
	String bankKey[]= request.getParameterValues("bankKey");*/
	
	String pTerms 	   = checkNull(request.getParameter("pTerms"));
	String paymMethod  = checkNull(request.getParameter("paymMethod"));
	String creatDate   = checkNull(request.getParameter("creatDate"));
	String houseBank   = checkNull(request.getParameter("houseBank"));
	String schemaGroup = checkNull(request.getParameter("schemaGroup"));
	
	Hashtable stateHT= new Hashtable();
	String usrId	=	"xyz";
	String selected="";
	String titleSelArr[] = {"Mr.","M/S.","Ms.", "Company", "Mr. and Mrs." };
	
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
 <%	
     	ReturnObjFromRetrieve retQuery	=  null;
     	int    QueryCnt	=  0;
     	
     	 mainParams	= new EzcParams(false);
     	 miscParams		= new EziMiscParams();
        	String id =(String)session.getValue("EZC_PORTAL_USER_ID")      	;
     		miscParams.setQuery("select EVGD_ADDR_NR from ezc_vend_general_data where  EVGD_VENDOR='"+id+"'");
        	
     	mainParams.setLocalStore("Y");
     	mainParams.setObject(miscParams);
     	Session.prepareParams(mainParams);
     	try
     	{		
     		retQuery=(ReturnObjFromRetrieve)ezMiscManager.ezSelect(mainParams);
     	}
     	catch(Exception e){ezc.ezcommon.EzLog4j.log("::::Error Occured While Getting Employee List in iGetEmpListForMgr.jsp:::::"+e,"I");}
     	if(retQuery!=null)
     		QueryCnt=retQuery.getRowCount(); 
     		
     		String area=retQuery.getFieldValueString(0,"EVGD_ADDR_NR");//out.println("::::::::"+QueryCnt);
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
              Vendor Details</h4>
              <br>
             <B><Font size=4 color=BLACK>Location</Font></B>
              &nbsp;&nbsp;&nbsp;&nbsp;  
              
            
            <%
	                  if ( sysRows > 0 )
	    	      	{
	    	      		//out.println("orglist::"+orgList_V);
	    	      %>
	    	              	<select name="SystemKey" name="SystemKey" style="width:25%" id=FullListBox >
	    	              
	    		<%
	    			retsyskey.sort(new String[]{"ESKD_SYS_KEY_DESC"},true);
	    			for ( int i = 0 ; i < sysRows ; i++ )
	    			{
	    				String val = (String)(retsyskey.getFieldValue(i,"ESKD_SYS_KEY"));
	    				String checkFlag = (String)retsyskey.getFieldValue(i,"ESKD_SUPP_CUST_FLAG");
	    				String syskeyDesc = (String)(retsyskey.getFieldValue(i,"ESKD_SYS_KEY_DESC"));				
	    				String descCode = syskeyDesc.substring(syskeyDesc.length()-5,syskeyDesc.length()-1);
	    				
	    				if(!area.contains(descCode)) continue;
	    				
	    				val = val.toUpperCase();
	    				val = val.trim();
	    		%>
	    				<option value="<%=val%>"><%=syskeyDesc%></option>
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
<div id="dialog-disclaimar" title="Confirmation" style="display:none"></Div>
<Div class="row">
	<Div class=" col-md-12 col-sm-12 col-xs-12"> 	
		<Div class="box box-info ">            
	       			<Div class="box-header">
	       				    <h5>&nbsp;&nbsp;&nbsp;&nbsp<B><Font size=2 color=BLACK>PURPOSE</Font></B></h5>
	       		       </Div>
	       	        
	       			<div class="form-group">
	       				  <textarea class="form-control" rows="1" placeholder="Enter Purpose" name="purpose" id="purpose" ></textarea>
	       		       </div>
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
					<Th>Title<font size="2" color="red"></font></Th>
					<Td colspan="4">
					
						<select name="titleSel" id="titleSel" >
						<option value="" >---select title---</option>
						<%
						//out.println(titleSel+":::::titleSel:::::");
						for(int i=0; i<titleSelArr.length; i++)
						{							
						%>
							<option value="<%=titleSelArr[i]%>"><%=titleSelArr[i]%></option>						
						<%							
						}
						%>
							
							
						</select>			
						
					</Td>
					<Th>Name1<font size="2" color="red"></font></Th>
					<Td colspan="4">
						<Input  type="text"   name="name1" id="name1" value=""  maxlength="35"  >
						
					</Td>
					<Th>Name2<font size="2" color="red"></font></Th>
					<Td colspan="4">
						<Input  type="text"   name="name2" id="name2" value=""  maxlength="35"  >
						
					</Td>
				</Tr>
				
				<Tr>
					<Th>Addr1 / H.No<font size="2" color="red"></font></Th>
					<Td colspan="4">
						<Input  type="text"   name="addr1" id="addr1" value=""  maxlength="35">
						
					</Td>

					<Th>Addr2<font size="2" color="red"></font></Th>
					<Td colspan="4">
						<Input  type="text"   name="addr2" id="addr2" value=""  maxlength="35">
						
					</Td>
					<Th>Street<font size="2" color="red"></font></Th>
					<Td colspan="4">
						<Input  type="text"   name="street" id="street" value=""  maxlength="60">
						
					</Td>
				</Tr>
				<Tr>
					
					<Th>City<font size="2" color="red"></font></Th>
					<Td colspan="4">
						<Input  type="text"   name="city" id="city" value=""  maxlength="35">
						
					</Td>
					<Th>State<font size="2" color="red"></font></Th>
				
					<Td colspan="4">
					<select  name="state" id="state">
					<option value="" >--------Select state-------</option>
					<%
					for (int i=0;i<StateCnt;i++) 
					{
						 statekey = retState.getFieldValueString(i,"EMKV_VALUE");
						  statevalue = retState.getFieldValueString(i,"EMKV_VALUE1");
				
					%>
							<option value="<%=statekey%>"><%=statevalue%>--<%=statekey%></option>
					<%
						
					}
					%>
					</select>					
						
						
					</Td>
					<Th>Country<font size="2" color="red"></font></Th>
					<Td>India
						<!--<select  name="country" id="country"  >
				<%		for (int i=0;i<CountryCnt;i++) 
						{
								 key = retCountry.getFieldValueString(i,"EMKV_KEY");
								 value = retCountry.getFieldValueString(i,"EMKV_VALUE");
								 
								//out.println("<<<"+key+"<<<"+value1+"<<<"+value);
 				%>
							<option value="<%=key%>"><%=value%></option>
				<%
						}
				%>
						</select>-->					
						<Input  type="hidden"  name="country" id="country" value="IN">
						
					</Td>
				</Tr>
				<Tr>
					<Th>District<font size="2" color="red"></font></Th>
					<Td colspan="4">
									
						<Input  type="text"   name="district" id="district" value=""  maxlength="35">
					</Td>
					
					<Th>PinCode<font size="2" color="red"></font></Th>
					<Td colspan="4">
						<Input  type="text"   name="pin" id="pin" value=""  maxlength="6">
						
					</Td>
					</Tr>
					<Tr>
					<Th>Landline<font size="2" color="red"></font></Th>
					<Td colspan="4">
						<Input  type="text"   name="landline" id="landline" value=""  maxlength="16">
						
					</Td>
					<Th>Mobile<font size="2" color="red"></font></Th>
					<Td colspan="4">
						<Input  type="text"   name="mobile" id="mobile" value=""  maxlength="16">
						
					</Td>
					<Th>FAX<font size="2" color="red"></font></Th>
					<Td colspan="4">
						<Input  type="text"   name="fax" id="fax" value=""  maxlength="31">
						
					</Td>
				</Tr>
				<Tr>
					
					<Th>EMail<font size="2" color="red"></font></Th>
					<Td colspan="4">
						<Input  type="text"   name="email" id="email" value=""  maxlength="241">
					</Td>
					<Th>EMail 2<font size="2" color="red"></font></Th>
					<Td colspan="4">
					<Input  type="text"   name="email2" id="email2" value=""  maxlength="241">
					</Td>
					
					
				</Tr>
				<Tr>
				<Th>
					Contact Person 1<font size="2" color="red"></font>
					</Th>
					<Td colspan="4">
					<Input  type="text"   name="contPers1" id="contPers1" value=""  maxlength="35">
					</Td>
					<Th>
						Contact Person 2<font size="2" color="red"></font>
					</Th>
					<Td colspan="4">
					<Input  type="text"   name="contPers2" id="contPers2" value=""  maxlength="35">
					
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
		VAT<font size="2" color="red"></font>
		</Th>
		<Td colspan="4">
		<Input  type="text"   name="vat" id="vat" value=""  maxlength="40">
		</Td>
		<Th>
		CST<font size="2" color="red"></font>
		</Th>
		<Td colspan="4">
		<Input  type="text"   name="cst" id="cst" value=""  maxlength="40">
		
		</Td>
		<Th>
		PAN<font size="2" color="red"></font>
		</Th>
		<Td colspan="4">
		<Input  type="text"   name="pan" id="pan" value=""  maxlength="10" >
		</Td>
		</Tr>

		<Tr><Th>
		Service Tax<font size="2" color="red"></font>
		</Th>
		<Td colspan="4">
		<Input  type="text"   name="servTax" id="servTax" value=""  maxlength="40">
		</Td>
		<Th>
		ECC No<font size="2" color="red"></font>
		</Th>
		<Td colspan="4">
		<Input  type="text"   name="eccNo" id="eccNo" value=""  maxlength="40">
		</Td>
		<Th>
		EXC. Reg No<font size="2" color="red"></font>
		</Th>
		<Td colspan="4">
		<Input  type="text"   name="excRegNo" id="excRegNo" value=""  maxlength="40">
		</Td>
		</Tr>
		<Tr>	

		<Th>
		EX. Range<font size="2" color="red"></font>
		</Th>
		<Td colspan="4">
		<input type="text" name="rangeSel" id="rangeSel" value="">							
		</Td>
		<Th>
		EX Division<font size="2" color="red"></font>
		</Th>
		<Td colspan="4">
		<Input  type="text"   name="exDiv" id="exDiv" value=""  maxlength="60">
		</Td>
		<Th>
		COMMI<font size="2" color="red"></font>
		</Th>
		<Td colspan="4">
		<Input  type="text"   name="commi" id="commi" value=""  maxlength="60">
		</Td>
		</Tr>
		<Tr>
				
		
				<Th>
				Category<font size="2" color="red"></font>
				</Th>
				<Td colspan="4">
				<select  name="minIndi" id="minIndi">
				<option value="" >--------Select Category--------</option>
				<%
				for (int i=0;i<MinIndCnt;i++) 
				{
					 MinIndkey = checkNull(retMinInd.getFieldValueString(i,"EMKV_KEY"));
					 MinIndvalue = checkNull(retMinInd.getFieldValueString(i,"EMKV_VALUE"));

					
				%>
						<option value="<%=MinIndkey%>"  ><%=MinIndvalue%>--<%=MinIndkey%></option>

				<%

				}
				%>
					</select>
		
				</Td>
				
				<Th>
					GSTIN<font size="2" color="red"></font>
					</Th>
					<Td colspan="4">
					<Input  type="text"   name="gst" id="gst" value=""  maxlength="15" onchange="funGst()">
				</Td>
				<Th>
					Classification<font size="2" color="red"></font>
					</Th>
				<%
					String[] selOpts = {"01#Registered","02#Not Registered","03#Compounding Scheme","04#PSU/Government Organization"};
				%>	
					
					<Td colspan="4">
					<select  name="classification" id="classification">							
					<option value="" >-----Select Classification-----</option>
				<%					
					for(int i=0;i<selOpts.length;i++)
					{
						String val0 = selOpts[i].split("#")[0];
						String val1 = selOpts[i].split("#")[1];
						
				%>
						<option value="<%=val0%>"><%=val1%></option>
				<%
					}
				%>
					</select>
				</Td>				
		</Tr>
		<Tr>
			<Th>
				Certification Date<font size="2" color="red"></font>
				</Th>
			<Td colspan="4">
				<!--<Input  type="text"   name="cDate" id="cDate" value=""  maxlength="10">&nbsp;<%=getDateImage("cDate")%>-->
				<input class="form-control input-sm" type="text" value=""  name="cDate" id="cDate"  >
				<span><Font color=#ff0000 size=1><B>* In case of micro, small and medium enterprises.</B></Font></span> 
			</Td>
			<Td>
				<label for="cDate" class="input-group-addon btn"> <img src='../../../../EzCommon/JavaScript/Calendar/Themes/icons/calendar7.gif' style='cursor:hand' id='butt"+field+"' border='none' valign='center'></label>  
					
			</Td>
			</Tr>			
		</Tr>
		</TBody>               

		</Table>
		</Div>
		<!-- /.table-responsive -->
		</Div>       
		</Div>

		<input type="hidden" name="bankIndex" value="1">				    
		<Div class="box box-info collapsed-box">            
		<Div class="box-header">
			<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i><B>&nbsp;&nbsp;<Font size=2 color=BLACK>BANK</Font></B></button>                		    


	       </Div>
	      <Div class="box-body" style="display: block;">
	      <Div class="table-responsive" id="wf"> 

		<Table class="table no-margin" id="wfw">



		<TBody><Tr>
		<Th>
			Country<font size="2" color="red"></font>
		</Th>
		<Td colspan="4">
		India
		</Td>
		<Input  type="hidden"   name="bankCountry" id="bankCountry" value="IN">
		<Th class="control-label" for="inputEmail">
			Bank Name<font size="2" color="red"></font>
		</Th>
		<Td class="controls" colspan="4">
		<Input  type="text"   name="bankName" id="bankName" value="" >
		</Td>
		<Th>
			State<font size="2" color="red"></font>
		</Th>
		<Td colspan="4">
		<select  name="bankRegion" id="bankRegion">
		<option value="" >----Select Region----</option>
		<%
		for (int i=0;i<StateCnt;i++) 
		{
			 statekey = checkNull(retState.getFieldValueString(i,"EMKV_VALUE"));
			  statevalue = checkNull(retState.getFieldValueString(i,"EMKV_VALUE1"));
			/*stateHT.put(statekey,statevalue);
			//out.println("<<<"+statekey+"<<<<<<"+stateHT.get(statekey));


			String bnkreg =(String)stateHT.get(statekey);
			if(bnkreg==null || "null".equals(bnkreg))bnkreg="";
			bnkreg = bnkreg.trim();*/
			

		%>
				<option value="<%=statekey%>"><%=statevalue%>--<%=statekey%></option>
		<%

		}
		%>
		</select>
		</Td>

		</Tr>

		<Tr><Th>
			Street<font size="2" color="red"></font>
		 </Th>
		<Td colspan="4">
		<Input  type="text"   name="bankStreet" id="bankStreet" value=""  maxlength="35">
		</Td>
		<Th>
			City<font size="2" color="red"></font>
		</Th>
		<Td colspan="4">
		<Input  type="text"   name="bankCity" id="bankCity" value=""  maxlength="35">
		</Td>
		<Th>
			Branch<font size="2" color="red"></font>
		</Th>
		<Td colspan="4">
		<Input  type="text"   name="bankBranch" id="bankBranch" value=""  maxlength="40">
		</Td>
		</Tr>
		<Tr>
		<Th>
			IFSC Code<font size="2" color="red"></font>
		</Th>
		<Td colspan="4">
		<Input  type="text"   name="bankIFSCCode" id="bankIFSCCode" value=""  maxlength="11">
		</Td>


		<Th>
			Account Number<font size="2" color="red"></font>
		</Th>
		<Td colspan="4">
		<Input  type="text"   name="bankACCode" id="bankACCode" value=""  maxlength="18">
		</Td>
		<Th>
			Currency<font size="2" color="red"></font>
		</Th>
		<Td>Rupee-- INR
		<!--<select  name="bankCurrency" id="bankCurrency">	
		<%	for (int i=0;i<CurrCnt;i++) 
			{
					 currkey = retCurrency.getFieldValueString(i,"EMKV_KEY");
					 currvalue = retCurrency.getFieldValueString(i,"EMKV_VALUE");

					//out.println("<<<"+key+"<<<"+value1+"<<<"+value);
		%>					
			<option value="<%=currkey%>"><%=currvalue%></option>			
		<%
			}
		%>	
		</select>					-->

		</Td>
		<Input  type="hidden"   name="bankCurrency" id="bankCurrency" value="INR"  >
						 </Tr>
						 </TBody>


				</Table>
			      </Div>
			      <!-- /.table-responsive -->
			    </Div>         		

					    </Div>
					    <!-- /.box-header -->


<input type="hidden" name="bankIndex" value="2">
<Div class="box box-info collapsed-box">            
		<Div class="box-header">
			<button type="button" class="btn btn-box-tool" data-widget="collapse"><input type='button'  value='Add Bank' id='editButton' /><B>&nbsp;&nbsp;<Font size=2 color=BLACK>BANK </Font></B></button>                		    



	       </Div>
	      <Div class="box-body" style="display: none;">
	      <Div class="table-responsive" id="wf"> 

		<Table class="table no-margin" id="wfw">



		<TBody><Tr>
		<Th>
			Country<font size="2" color="red"></font>
		</Th>
		<Td colspan="4">
		<input type="hidden" name="bankKey" value="">
		India
		</Td>
		<Input  type="hidden"   name="bankCountry" id="bankCountry" value="">
		<Th class="control-label" for="inputEmail">
			Bank Name<font size="2" color="red"></font>
		</Th>
		<Td class="controls" colspan="4">
		<Input  type="text"   name="bankName" id="bankName" value="" maxlength="60">
		</Td>
		<Th>
			State<font size="2" color="red"></font>
		</Th>
		<Td colspan="4">
		<select  name="bankRegion" id="bankRegion">
		<option value="" >----Select Region----</option>
		<%
		for (int i=0;i<StateCnt;i++) 
		{				
			 statekey = checkNull(retState.getFieldValueString(i,"EMKV_VALUE"));
			  statevalue = checkNull(retState.getFieldValueString(i,"EMKV_VALUE1"));		
		%>
				<option value="<%=statekey%>" ><%=statevalue%>--<%=statekey%></option>
		<%

		}
		%>
		</select>
		</Td>

		</Tr>

		<Tr><Th>
			Street<font size="2" color="red"></font>
		 </Th>
		<Td colspan="4">
		<Input  type="text"   name="bankStreet" id="bankStreet" value=""  maxlength="35">
		</Td>
		<Th>
			City<font size="2" color="red"></font>
		</Th>
		<Td colspan="4">
		<Input  type="text"   name="bankCity" id="bankCity" value=""  maxlength="35">
		</Td>
		<Th>
			Branch<font size="2" color="red"></font>
		</Th>
		<Td colspan="4">
		<Input  type="text"   name="bankBranch" id="bankBranch" value=""  maxlength="40">
		</Td>
		</Tr>
		<Tr>
		<Th>
			IFSC Code<font size="2" color="red"></font>
		</Th>
		<Td colspan="4">
		<Input  type="text"   name="bankIFSCCode" id="bankIFSCCode" value=""  maxlength="11">
		</Td>


		<Th>
			Account Number<font size="2" color="red"></font>
		</Th>
		<Td colspan="4">
		<Input  type="text"   name="bankACCode" id="bankACCode" value=""  maxlength="18">
		</Td>
		<Th>
			Currency<font size="2" color="red"></font>
		</Th>
		<Td>Rupee-- INR


		</Td>
		<Input  type="hidden"   name="bankCurrency" id="bankCurrency" value="INR"  >
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
	                  <textarea class="form-control" rows="5" placeholder="Enter Comments" name="comments" id="comments"></textarea>
               </div>


<!-- /.box-header -->	
<Div class="col-xs-12 col-md-12" style="padding-right:3px;padding-left:37%">
<Input  type="checkbox"   name="termc" id="termc" value="N"  maxlength="1">&nbsp;Please accept <a onclick="termsc()"><u>Terms and Conditions</u></a> before submitting the details.</input><br><br>
<div class="errorTxt"></div>
</Div>

<Div class="col-xs-12 col-md-12 col-md-offset-5 col-xs-offset-6 " >
	<!--<input type='button' class="btn btn-primary" value='Add Bank' id='addButton' />-->
	<button type="button" class="btn btn-primary" onclick="funBack()">Back</button>
	<button type="button" class="btn btn-primary" id="uploaddocs" onclick="funUpload()">Upload Docs</button> 
	<button type="button" class="btn btn-primary" onclick="funSubmit()">Submit</button>
</Div>	
	

<input type="hidden" name="vendCode" id="vendCode" value="<%=vendCode%>" />
<input type="hidden" name="bankKey" id="bankKey" value="1"/>
<input type="hidden" name="vendType" id="vendType" value="NEW" />
<!--<input type="hidden" name="compCode" id="compCode" value="CFL" />	
<input type="hidden" name="vendType" id="vendType" value="NEW" />	
<input type="hidden" name="venName" id="venName" value="new" />	
<input type="hidden" name="serBased" id="serBased" value="1" />	
<input type="hidden" name="grBased" id="grBased" value="1" />	-->

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
	/*var vendCode	=document.myForm.vendCode.value;
   	var compCode	=document.myForm.compCode.value;
   	var vendType	=document.myForm.vendType.value;
   	var serBased	=document.myForm.serBased.value;
   	var venName  	= document.myForm.venName.value;
   	var grBased  	= document.myForm.grBased.value; */  	
   	//var procGrp  	= document.myForm.procGrp.value;
   	
   	var titleSel  	= document.myForm.titleSel.value;
   	var name1  	= document.myForm.name1.value;
   	var name2  	= document.myForm.name2.value;
   	var addr1  	= document.myForm.addr1.value;
   	var addr2  	= document.myForm.addr2.value;
   	var street 	= document.myForm.street.value;
   	var city  	= document.myForm.city.value;
   	//var state  	= document.myForm.state.value;
   	var country  	= document.myForm.country.value;
   	var district  	= document.myForm.district.value;
	var pin  	= document.myForm.pin.value;
	
	var mobile  	= document.myForm.mobile.value;
	
	var email  	= document.myForm.email.value;
	var email2  	= document.myForm.email2.value;
	var contPers1  	= document.myForm.contPers1.value;
	var contPers2  	= document.myForm.contPers2.value;
	var attachType= document.myForm.attachType.value;
	var changedStatutoryDetails="";   	
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
	if(""!=vat || ""!=cst || ""!=gst || ""!=minIndi || ""!=commi || ""!=exDiv || ""!=rangeSel || ""!=excRegNo || ""!=eccNo || ""!=servTax || ""!=pan)
	{
		changedStatutoryDetails="STATUTORY";
	}
	if(changedStatutoryDetails!="" && attachType.indexOf(changedStatutoryDetails)<0)
	{
		alert("As Statutory details are entered please upload respective files");
		return;			
	}
	var bankObj = document.myForm.bankCountry;
	var bankObjLen = bankObj.length;
	var changedBankDetails="";
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
	if(""!=bankName || ""!=bankRegion || ""!=bankStreet || ""!=bankCity || ""!=bankBranch || ""!=bankIFSCCode || ""!=bankACCode )
		{
			changedBankDetails=bankACCode;
		}
		if(changedBankDetails!="" && attachType.indexOf(changedBankDetails)<0)
		{
			alert("As Bank details are entered please upload respective files");
			i=bankObjLen;
					return;		
	}
	}
	
	var termc	=document.myForm.termc.value;
	
	var attachType= document.myForm.attachType.value;
   
   
	if (!$("#myForm").valid()) 
	{
		return false;
	}
	else{	
		$( "#dialog-disclaimar" ).dialog("option", "title", "Disclaimer");
		$( "#dialog-disclaimar" ).dialog('open').text("Any changes made on portal will reflect post verification by company.");
	} 
 
}
   
function funBack() 
{
	document.myForm.action="ezVendorDetails.jsp";
	document.myForm.submit();
}

$(function() { 
		
	 $( "#dialog-disclaimar" ).dialog({
	 
	 	open: function() {
		$(this).closest(".ui-dialog")
		.find(".ui-dialog-titlebar-close")
		.removeClass("ui-dialog-titlebar-close")
		.html("<span class='ui-button-icon-primary ui-icon ui-icon-closethick'></span>");
    		},
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
function funUpload()
{
var bankListStr="";
var bankObj = document.myForm.bankCountry;
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
		 
		$.validator.addMethod("titVal", function() {
			    return $('#titleSel').val() != "";
		}, 'Please select Title');
		$.validator.addMethod("stateVal", function() {
				return $('#state').val() != "";
		}, 'Please select State');
		$("#myForm").validate({
			onfocusout: function (element) {
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
				titleSel: {
					titVal: true
				},
				state: {
					stateVal: true
				},
				name1: {
					required: true
				},
				addr1: {
					required: true
				},
				addr2: {
					required: false
				},
				street: {
					required: true
				},
				contPers1: {
					required: false
				},
				contPers2: {
					required: false
				},
				city: {
					required: true
				},
				district: {
					required: true
				},
				pan: {
					required: true,
					alphanumeric: true
				},
				pin: {
				      required: true,
				      digits: true
    				},
    				landline: {
				      required: false,
				      digits: true
    				},
    				mobile: {
				      required: true,
				      digits: true
    				},
    				fax: {
				      required: false,
				      digits: true
    				},
    				eccNo: {
				      required: false,
				      digits: false
    				},
    				excRegNo: {
				      required: false,
				      digits: false
    				},
    				bankACCode: {
				      required: false,
				      digits: false
    				},
    				email: {
				      required: true,
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
					required: true,
					minlength: 15,
					alphanumeric: true
				},
				termc: {
					required: true,						
				},
				exDiv: {
					required: false
				},
				commi: {
					required: false
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
					required: true,
					alphanumeric: true
				}
			},
			messages: {
				name1: {
					required: "Please Enter Name"
				},
				addr1: {
					required: "Please Enter Address"
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
					required: "Please Enter city"
				},
				district: {
					required: "Please Enter District"
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
					digits: "Please enter only digits"
				},
				excRegNo: {
					required: "Please Enter EXC. Reg No",
					digits: "Please enter only digits"
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
					number: "Please enter Numeric value only"
				},
				cst : {
					required: "Please Enter CST %",
					maxlength: "CST must consist of only 4 characters ",
					number: "Please enter Numeric value only"
				},
				servTax : {
					required: "Please Enter Service Tax",
					maxlength: "Service Tax must consist of only 4 characters ",
					number: "Please enter Numeric value only"
				},
				gst : {
					required: "Please Enter GSTIN.",
					maxlength: "GSTIN must consist of only 15 characters ",
					alphanumeric: "Please Enter only Alphanumeric Characters"
				},
				
				exDiv : {
					required: "Please Enter EX. Division"
				},
				commi : {
					required: "Please Enter Commi."
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