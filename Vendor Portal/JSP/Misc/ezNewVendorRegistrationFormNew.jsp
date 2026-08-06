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
	//out.println("titleSel:::"+titleSel);
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
     	
     	ezc.ezparam.EzcParams mainParams	= new ezc.ezparam.EzcParams(false);
     	EziMiscParams miscParams		= new EziMiscParams();
        	String id =(String)session.getValue("EZC_PORTAL_USER_ID")      	;
     		miscParams.setQuery("select * from ezc_vend_general_data where  EVGD_VENDOR='"+id+"'");
        	
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
     		
     		String area=retQuery.getFieldValueString(0,"EVGD_ADDR_NR");//out.println(area+"::::::::"+QueryCnt);
     		String  statenew=retQuery.getFieldValueString(0,"EVGD_STATE");
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
	height: 55px;
}
th
{
	font-size:small;
}
td
{
	font-size:small;
	text-transform: uppercase;
}
.table>tbody>tr>td
{
	line-height: inherit;
}
.table>tbody>tr>th 
{
	line-height: inherit;
}
.my-error-class 
{
	display: block;
	float:none;
	color:red;
	padding-left: .2em;
	padding-top: 0;
	vertical-align: top; 
	font-size:11;
}
.ui-draggable .ui-dialog-titlebar 
{
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
	       				  <textarea class="form-control" rows="1" placeholder="Enter Purpose" name="purpose" id="purpose"  required></textarea>
	       		       </div>
               </Div>	
		<Div class="box box-info collapsed-box">
			<Div class="box-header ">
				<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i><B>&nbsp;&nbsp;<Font size=2 color=BLACK>CONTACT DETAILS</Font></B></button>                
			</Div>
			<Div class="box-body" style="display: block;">
			<Div class="table-responsive">
				<div class="col-md-4">
					<div class="form-group">
						<label for="exampleInputEmail1">Title</label>				
						<select class="form-control" name="titleSel" id="titleSel" >
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
					</div>					
					<div class="form-group">
						<label for="exampleInputEmail1">Addr1 / H.No</label>		
						<Input  type="text" class="form-control" style="text-transform: uppercase;"  name="addr1" id="addr1" value=""  maxlength="35">							
					</div>
					<div class="form-group">
						<label for="exampleInputEmail1">City</label>				
						<Input  type="text" class="form-control" style="text-transform: uppercase;"  name="city" id="city" value="<%=retQuery.getFieldValueString(0,"EVGD_CITY")%>"  maxlength="35">
					</div>
					<div class="form-group">
						<label for="exampleInputEmail1">District</label>				
						<Input  type="text" class="form-control" style="text-transform: uppercase;"  name="district" id="district" value=""  maxlength="35">
					</div>
					<div class="form-group">
						<label for="exampleInputEmail1">Landline</label>				
						<Input  type="text" class="form-control"   name="landline" id="landline" value=""  maxlength="16">
					</div>
					<div class="form-group">
						<label for="exampleInputEmail1">EMail</label>			
						<Input  type="text"  class="form-control"   name="email" id="email" value="<%=retQuery.getFieldValueString(0,"EVGD_EMAIL")%>"  maxlength="241">
						<p id="emailMsg" style="display:none"><font color="red">Please enter valid Email Id</font></p>
					</div>
					<div class="form-group">
						<label for="exampleInputEmail1">Contact Person 1</label>				
						<Input  type="text" class="form-control" style="text-transform: uppercase;"  name="contPers1" id="contPers1" value=""  maxlength="35">
						<p id="contPers1Msg" style="display:none"><font color="red">Contact person 1 length should not exceed 10</font></p>
					</div>	
				</div>

				<div class="col-md-4">
					<div class="form-group">
						<label for="exampleInputEmail1">Name1</label>						
						<Input  type="text" class="form-control" style="text-transform: uppercase;"  name="name1" id="name1" value="<%=retQuery.getFieldValueString(0,"EVGD_NAME1")%>"  maxlength="35"  >
					</div>					
					<div class="form-group">
						<label for="exampleInputEmail1">Addr2</label>		
						<Input  type="text" class="form-control" style="text-transform: uppercase;"   name="addr2" id="addr2" value=""  maxlength="35">
					</div>
					<div class="form-group">
						<label for="exampleInputEmail1">State</label>							
						<select  class="form-control" name="state" id="state" value="<%=statenew%>" disabled>				
							<option value="" >--------Select state-------</option>
							<%
							for (int i=0;i<StateCnt;i++) 
							{
								selected="";
								statekey = retState.getFieldValueString(i,"EMKV_VALUE");
								statevalue = retState.getFieldValueString(i,"EMKV_VALUE1");
								//out.println(statekey+"::::::::"+statenew+"::"+statevalue);
								  if(statenew.equals(statekey))
									selected="selected";

							%>
									<option value="<%=statekey%>" <%=selected%>><%=statevalue%>--<%=statekey%></option>
							<%

							}
							%>
						</select>
						<Input  type="hidden"   name="gstcode" id="gstcode" value="<%=statekey%>">
					</div>					
					<div class="form-group">
						<label for="exampleInputEmail1">PinCode</label>		
						<Input  type="text" class="form-control"   name="pin" id="pin" value=""  maxlength="6">
					</div>
					<div class="form-group">
						<label for="exampleInputEmail1">Mobile</label>		
						<Input  type="text"   class="form-control" name="mobile" id="mobile" value="<%=retQuery.getFieldValueString(0,"EVGD_MOBILE")%>"  maxlength="16">
					</div>					
					<div class="form-group">
						<label for="exampleInputEmail1">EMail 2</label>		
						<Input  type="text" class="form-control"   name="email2" id="email2" value=""  maxlength="241">
						<p id="emailMsg" style="display:none"><font color="red">Please enter valid Email Id</font></p>
					</div>	
					<div class="form-group">
							<label for="exampleInputEmail1">Contact Person 2</label>			
							<Input  type="text" class="form-control" style="text-transform: uppercase;"  name="contPers2" id="contPers2" value=""  maxlength="35">
					</div>	
				</div>

				<div class="col-md-4">
					<div class="form-group">
						<label for="exampleInputEmail1">Name2</label>						
						<Input  type="text" class="form-control" style="text-transform: uppercase;" name="name2" id="name2" value=""  maxlength="35"  >
					</div>					
					<div class="form-group">
						<label for="exampleInputEmail1">Street</label>						
						<Input  type="text" class="form-control" style="text-transform: uppercase;"  name="street" id="street" value=""  maxlength="60">
					</div>
					<div class="form-group">
						<label for="exampleInputEmail1">Country</label>
						<Input  type="text" class="form-control" style="text-transform: uppercase;"  name="country" id="country" placeholder="India" maxlength="60" disabled>
						<Input  type="hidden"  name="country" id="country" value="IN">		
					</div>
					<div class="form-group">
						<label for="exampleInputEmail1">Fax</label>
						<Input  type="text" class="form-control"   name="fax" id="fax" value=""  maxlength="31">		
					</div>	
				</div>
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
				<div class="col-md-4">
					<div class="form-group">
						<label for="exampleInputEmail1">PAN</label>								
						<Input  type="text" class="form-control" style="text-transform: uppercase;"  name="pan" id="pan" value=""  maxlength="10" >
					</div>					
					<div class="form-group">
						<label for="exampleInputEmail1">Category</label>						
						<input type="hidden"  name="minIndi_old" id="minIndi_old" value="<%=minIndi%>">
								<select class="form-control"  name="minIndi" id="minIndi">
								<option value="" >----Select Category----</option>
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
					</div>
				</div>	
				<div class="col-md-4">
					<div class="form-group">
						<label for="exampleInputEmail1">GSTIN</label>				
						<Input  type="text" class="form-control" style="text-transform: uppercase;"  name="gst" id="gst" value=""  maxlength="15" onchange="funGst()">
					</div>	
					<div class="form-group">
						<label for="exampleInputEmail1">Certification Date</label>
						<div class="input-group date">
						 <div class="input-group-addon">
						   <i class="fa fa-calendar"></i>
						   </div>
						<input type="text" class="form-control pull-right" value=""  name="cDate" id="cDate"  >						
		                		</div>
		                		<span><Font color=#ff0000 size=1><B>* In case of micro, small and medium enterprises.</B></Font></span> 
					</div>	
				</div>	
				<div class="col-md-4">
					<div class="form-group">
						<label for="exampleInputEmail1">Classification</label>		
						<%
							String[] selOpts = {"01##Registered","02##Not Registered","03##Compounding Scheme","04##PSU/Government Organization"};
						%>						
						<select class="form-control" name="classification" id="classification">							
							<option value="" >--Select Classification--</option>
						<%					
							for(int i=0;i<selOpts.length;i++)
							{
								String val0 = selOpts[i].split("##")[0];
								String val1 = selOpts[i].split("##")[1];
								
						%>
								<option value="<%=val0%>"><%=val1%></option>
						<%
							}
						%>
							</select>							
					
					</div>		
				</div>
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
				<div class="col-md-4">
					<div class="form-group">
						<label for="exampleInputEmail1">Country</label>				
						<Input  type="text" class="form-control"  style="text-transform: uppercase;" placeholder="India"  maxlength="10" disabled>
						<Input  type="hidden"   name="bankCountry" id="bankCountry" value="IN">
					</div>
					<div class="form-group">
						<label for="exampleInputEmail1">Street</label>
						<Input  type="text"  class="form-control" style="text-transform: uppercase;"  name="bankStreet" id="bankStreet" value=""  maxlength="35">
					</div>				
					<div class="form-group">
						<label for="exampleInputEmail1">IFSC Code</label>
						<Input  type="text"  class="form-control" style="text-transform: uppercase;"  name="bankIFSCCode" id="bankIFSCCode" value=""  maxlength="11">
					</div>
				</div>	

				<div class="col-md-4">
					<div class="form-group">
						<label for="exampleInputEmail1">Bank Name</label>						
						<Input  type="text" class="form-control" style="text-transform: uppercase;"  name="bankName" id="bankName" value="" >		
					</div>
					<div class="form-group">
						<label for="exampleInputEmail1">City</label>		
						<Input  type="text" class="form-control" style="text-transform: uppercase;"  name="bankCity" id="bankCity" value=""  maxlength="35">
					</div>				
					<div class="form-group">
						<label for="exampleInputEmail1">Account Number</label>		
						<Input  type="text"  class="form-control" name="bankACCode" id="bankACCode" value=""  maxlength="18">
					</div>
				</div>

				<div class="col-md-4">
					<div class="form-group">
						<label for="exampleInputEmail1">State</label>
						<select class="form-control" name="bankRegion" id="bankRegion">
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
					</div>
					<div class="form-group">
						<label for="exampleInputEmail1">Branch</label>		
						<Input  type="text" class="form-control" style="text-transform: uppercase;"   name="bankBranch" id="bankBranch" value=""  maxlength="40">		
					</div>				
					<div class="form-group">
						<label for="exampleInputEmail1">Currency</label>	
						<Input  type="text" class="form-control"  style="text-transform: uppercase;" placeholder="Rupee"  maxlength="10" disabled>		
						<Input  type="hidden"   name="bankCurrency" id="bankCurrency" value="INR"  >
					</div>
				</div>
		
			      </Div>
			      <!-- /.table-responsive -->
			    </Div>         		

					    </Div>
					    <!-- /.box-header -->


<!--<input type="hidden" name="bankIndex" value="2">
<Div class="box box-info collapsed-box">            
		<Div class="box-header">
			<button type="button" class="btn btn-box-tool" data-widget="collapse"><input type='button'  value='Add Bank' id='editButton' /><B>&nbsp;&nbsp;<Font size=2 color=BLACK>BANK </Font></B></button>                		    



	       </Div>
	      <Div class="box-body" style="display: none;">
	      <Div class="table-responsive" id="wf"> 
			<div class="col-md-4">
				<div class="form-group">
					<label for="exampleInputEmail1">Country</label>				
					<Input  type="text" class="form-control"  style="text-transform: uppercase;" placeholder="India"  maxlength="10" disabled>
					<Input  type="hidden"   name="bankCountry" id="bankCountry" value="IN">
				</div>
				<div class="form-group">
					<label for="exampleInputEmail1">Street</label>
					<Input  type="text"  class="form-control" style="text-transform: uppercase;"  name="bankStreet" id="bankStreet" value=""  maxlength="35">
				</div>				
				<div class="form-group">
					<label for="exampleInputEmail1">IFSC Code</label>
					<Input  type="text"  class="form-control" style="text-transform: uppercase;"  name="bankIFSCCode" id="bankIFSCCode" value=""  maxlength="11">
				</div>
			</div>	

			<div class="col-md-4">
				<div class="form-group">
					<label for="exampleInputEmail1">Bank Name</label>						
					<Input  type="text" class="form-control" style="text-transform: uppercase;"  name="bankName" id="bankName" value="" >		
				</div>
				<div class="form-group">
					<label for="exampleInputEmail1">City</label>		
					<Input  type="text" class="form-control" style="text-transform: uppercase;"  name="bankCity" id="bankCity" value=""  maxlength="35">
				</div>				
				<div class="form-group">
					<label for="exampleInputEmail1">Account Number</label>		
					<Input  type="text"  class="form-control" name="bankACCode" id="bankACCode" value=""  maxlength="18">
				</div>
			</div>

			<div class="col-md-4">
				<div class="form-group">
					<label for="exampleInputEmail1">State</label>
					<select class="form-control" name="bankRegion" id="bankRegion">
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
				</div>
				<div class="form-group">
					<label for="exampleInputEmail1">Branch</label>		
					<Input  type="text" class="form-control" style="text-transform: uppercase;"   name="bankBranch" id="bankBranch" value=""  maxlength="40">		
				</div>				
				<div class="form-group">
					<label for="exampleInputEmail1">Currency</label>	
					<Input  type="text" class="form-control"  style="text-transform: uppercase;" placeholder="Rupee"  maxlength="10" disabled>		
					<Input  type="hidden"   name="bankCurrency" id="bankCurrency" value="INR"  >
				</div>
			</div>
			      </Div>-->
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


<!-- /.box-header -->	
<Div class="col-xs-12 col-md-12" style="padding-right:3px;padding-left:37%">
<Input  type="checkbox"   name="termc" id="termc" value="N"  maxlength="1" required>&nbsp;Please accept <a href="javascript:onclick=termsc();"><u>Terms and Conditions</u></a> before submitting the details.</input><br><br>
<div class="errorTxt" style="display:none"></div>
</Div>

<Div class="col-xs-12 col-md-12 col-md-offset-5 col-xs-offset-6 " >
	<!--<input type='button' class="btn btn-primary" value='Add Bank' id='addButton' />-->
	<button type="button" class="btn btn-primary" onclick="funBack()">Back</button>
	<button type="button" class="btn btn-primary" id="uploaddocs" onclick="funUpload()">Upload Docs</button> 
	<button type="button" class="btn btn-primary" onclick="funSubmit()">Submit</button>
</Div>	
	

<input type="hidden" name="vendCode" id="vendCode" value="<%=vendCode%>" />
<input type="hidden" name="bankKey" id="bankKey" value="1"/>
<input type="hidden" name="stateh" id="stateh" value="<%=statenew%>" />
<input type="hidden" name="vendType" id="vendType" value="NEW" />
<!--<input type="hidden" name="compCode" id="compCode" value="CFL" />	
<input type="hidden" name="vendType" id="vendType" value="NEW" />	
<input type="hidden" name="venName" id="venName" value="new" />

<input type="hidden" name="serBased" id="serBased" value="1" />	
<input type="hidden" name="grBased" id="grBased" value="1" />	-->
<%
	for (int i=0;i<StateCodeCnt;i++) 
	{			
		  stateCode = checkNull(retStateCode.getFieldValueString(i,"esc_code"));
		//  out.println("::::::::"+stateCode);	
		  if(statenew.equals(stateCode))	
		  {
		    GSTStateCode = checkNull(retStateCode.getFieldValueString(i,"esc_state_code"));
		  	//out.println(stateCode+":::::::::::stateCode:::::::::::"+GSTStateCode);
		  }
		 
	}	  
%>
</form>
</Body>
	

	
        </section><!-- /.content -->
      </Div><!-- /.content-wrapper -->  
<script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>
<script src="../../Library/jquery/jquery-validation-1.16.0/dist/jquery.validate.min.js"></script>
<script src="../../Library/jquery/jquery-validation-1.16.0/dist/additional-methods.min.js"></script>
<script src="../../Library/jquery/jquery-ui-1.12.1.custom/jquery-ui.js"></script>


<script>
function funGst()
{
	var gst  	= document.myForm.gst.value;
	gst		= gst.toUpperCase();
	var pan  	= document.myForm.pan.value;
	pan		= pan.toUpperCase();
	var gststatecode = '<%=GSTStateCode%>'
	var gstCode=gst.substr(0, 2);	
	var res 	= gst.substr(2, 10);
	//alert(gstCode+"::::"+gststatecode);
	if(gstCode!=gststatecode)
		{
		 alert(gstCode+"GST number does not match with PAN"+gststatecode);
	    	 document.myForm.gst.value="";
		}
	  if(pan!=res){
	    alert(pan+"GST number does not match with PAN"+res);
	    document.myForm.gst.value="";
	  }
	if(gst!="" && pan==res)
	{
		document.myForm.classification.selectedIndex = 1;
	}
}
</script>
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
   	var state  	= document.myForm.state.value;
   	//alert(titleSel+":"+state);
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
	
   	var pan  	= document.myForm.pan.value;
	
	
	
	var minIndi  	= document.myForm.minIndi.value;
	var gst  	= document.myForm.gst.value;
	if( ""!=gst || ""!=minIndi ||  ""!=pan)
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
	 $.validator.addMethod("pann", function(value) {
	 return /[a-zA-z]{5}\d{4}[a-zA-Z]{1}/.test(value) 
		}, "Please enter valid PAN");
		
$.validator.addMethod("gstinn", function(value) {
		 return /\d{2}[a-zA-z]{5}\d{4}[a-zA-z]{1}\d{1}[a-zA-z]{1}\d{1}/.test(value) 
			}, "Please enter valid GSTIN");		
		
	$.validator.addMethod("cDate2", function(value) { 
		//alert($('#minIndi').val()+"::::");
			//return !($('#minIndi').val() == "05" || $('#/').val() == "06" || $('#minIndi').val() == "07");
			
if(($('#minIndi').val() == "05" || $('#minIndi').val() == "06" || $('#minIndi').val() == "07"))
	{
		if(document.myForm.cDate.value=="")
		return false;
	}
	return true;			
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
					required: true,
					lettersonly: true 
				},
				pan: {
					required: true,
					alphanumeric: true,
					pann:true
					
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
    				
    				
    				bankACCode: {
				      required: true,
				      digits: true
    				},
    				email: {
				      required: true,
				      email: true
    				},
    				email2: {
				      required: false,
				      email: true
    				},
    				
				
				gst: {
					required: true,
					minlength: 15,
					alphanumeric: true,
					gstinn:true
				},
				termc: {
					required: true,						
				},
				
				cDate: {
					cDate2: true,
					alphanumeric: false
				},
				bankName: {
					required: true
				},
				bankStreet: {
					required: false
				},
				bankCity: {
					required: false,
					lettersonly: false 
				},
				bankBranch: {
					required: true
				},
				bankIFSCCode: {
					required: true,
					alphanumeric: true
				}
			},
			messages: {
				name1: {
					required: "You can't leave this empty"
				},
				addr1: {
					required: "You can't leave this empty"
				},
				
				addr2: {
					required: "You can't leave this empty"
				},
				street: {
					required: "You can't leave this empty"
				},
				contPers1: {
					required: "You can't leave this empty"
				},
				contPers2: {
					required: "You can't leave this empty"
				},
				city: {
					required: "You can't leave this empty",
					lettersonly: "Please enter only alphabets"
				},
				district: {
					required: "You can't leave this empty",
					lettersonly: "Please enter only alphabets"
				},
				pan: {
					required: "Please enter valid PAN",
					alphanumeric: "Please enter only alphanumeric characters"
				},
				pin: {
					required: "Please enter PinCode",
					digits: "Please enter only digits"
				},
				landline: {
					required: "You can't leave this empty",
					digits: "Please enter only digits"
				},
				mobile: {
					required: "You can't leave this empty",
					digits: "Please enter only digits"
				},
				fax: {
					required: "You can't leave this empty",
					digits: "Please enter only digits"
				},
				
				
				bankACCode: {
					required: "You can't leave this empty",
					digits: "Please enter only digits"
				},
				email: {
					required: "You can't leave this empty",
					email: "Please enter valid Email Id."
				},
				email2: {
					required: "You can't leave this empty",
					email: "Please enter valid Email Id."
				},
				
				
				gst : {
					required: "Please enter valid GSTIN.",
					minlength: "GSTIN must consist minimum 15 characters ",
					alphanumeric: "Please enter only alphanumeric characters"
				},
				termc : {
					required: "Please accept Terms and Conditon before submit.",					
				},
				
				cDate: {
					required: "You can't leave this empty",
					alphanumeric: "Please enter only alphanumeric characters"
				},				
				bankName: {
					required: "Please enter bank name"
				},
				bankStreet: {
					required: "Please enter bank street"
				},
				bankCity: {
					required: "Please enter bank city",
					lettersonly: "Please enter only letters"  
				},
				bankBranch: {
					required: "Please enter bank branch"
				},
				bankIFSCCode: {
					required: "Please enter bank IFSC",
					alphanumeric: "Please enter only alphanumeric characters"
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