<%
	int rCount1 = 0;//sapvendRet.getRowCount();   
	ezc.ezcommon.EzLog4j.log("rCount1>>"+rCount1,"I"); 
	
	int tempVendCnt=0;
	ReturnObjFromRetrieve tempVendRet=null;
	miscMgrVend = new ezc.misctransactions.client.EzMiscTransactionsManager();
	miscTableVend = new ezc.misctransactions.params.EzMiscTable();
	miscTableRowVend = new ezc.misctransactions.params.EzMiscTableRow();
	mainParamsVend = new ezc.ezparam.EzcParams(false);
	//miscTableRowVend.setQuery("SELECT EU_ID,EUD_VALUE ,EU_FIRST_NAME,EU_EMAIL FROM EZC_USERS,EZC_USER_DEFAULTS WHERE EU_ID = EUD_USER_ID AND EUD_KEY='USERROLE' AND EUD_VALUE='TV'");
	miscTableRowVend.setQuery("SELECT EU_ID,EUD_VALUE ,EU_FIRST_NAME,EU_EMAIL FROM EZC_USERS,EZC_USER_DEFAULTS WHERE EU_ID = EUD_USER_ID AND EUD_KEY='USERROLE' AND EUD_VALUE='TU' AND EUD_USER_ID IN(SELECT EUD_USER_ID FROM EZC_USER_DEFAULTS WHERE EUD_KEY='ALLOW_RFQ' AND EUD_VALUE='Y') AND EU_ID in (SELECT ECFH_DOC_ID FROM EZC_CUSTOMER_FORM_HEADER WHERE ECFH_SAP_CODE = '' OR ECFH_SAP_CODE IS NULL)");
	
	
	miscTableVend.appendRow(miscTableRowVend);
	mainParamsVend.setLocalStore("Y");
	mainParamsVend.setObject(miscTableVend);
	Session.prepareParams(mainParamsVend);

	try
	{
		tempVendRet=(ezc.ezparam.ReturnObjFromRetrieve)miscMgrVend.ezGetMiscTransactions(mainParamsVend);

	}
	catch(Exception e)
	{
		out.println("Exception in getting Vendor List>>>>>"+e);
	}
	if(tempVendRet!=null)
		tempVendCnt=tempVendRet.getRowCount();
	tempVendRet.sort(new String[]{"EU_FIRST_NAME"},true);
	//ezc.ezcommon.EzLog4j.log("tempVendCnt>>_new>>>>>"+tempVendCnt,"I");

%>
<div class="row">
   <!-- left column -->
   <div class="col-md-12 col-xs-12">
<%

	if(tempVendCnt==0)
	{
%>

	<div class="alert alert-danger">
		<Tr>
			<Th>No Vendors exist</th>
		</Tr>
   	</div>
   
<%	}
	else
	{	
%>

   <div class="box box-primary">
         <div id="tab22" class="box-body table-responsive no-padding" style="display: block;max-height: 400px;"> 
	       <input class="form-control pull-right" id="myInput1" type="text" placeholder="Search.." style="width: 50%;margin: 2px;">	
               <table id="myTable1" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%" height="100%">
	<thead> 
        <tr>
        <th align="center" width="5%">&nbsp;</th>
        <th align="center" width="10%"><%=vendor_L%></th>
        <th align="center" width="30%"><%=name_L%></th>
        <!--<th align="center" width="15%">City</th>
        <th align="center" width="15%">Phone NO</th> -->
        <th align="center" width="25%"><%=email_Id_L%></th>
        <!--<th align="center" width="25%">Account Group</th>-->
        </tr>
   </thead>

<tbody>
<%
	String	tmpVend="";
	String  tmpVCode="";
	String	tmpVname="";
	String 	tmpVemail="";
 	String 	selectedVendors[]= request.getParameterValues("selChk");
 	
 	int index = 0;
 	
 	for(int i=0;i<tempVendCnt;i++)
	{	
		//int index = tempVendCnt+i;
		
		if(i==0)
			index= vendCnt;
		else
			index = index+1;
			
		tmpVCode = tempVendRet.getFieldValueString(i,"EU_ID"); 
		try{
			tmpVend = Long.parseLong(tmpVCode)+"";
			tmpVend = "0000000000"+tmpVend;
			tmpVend = tmpVend.substring(tmpVend.length()-10,tmpVend.length());
		}catch(Exception e){
			tmpVend = tmpVCode; 
		}		
		tmpVname   = tempVendRet.getFieldValueString(i,"EU_FIRST_NAME");
		tmpVemail	= tempVendRet.getFieldValueString(i,"EU_EMAIL");
		if("null".equals(tmpVemail) || "".equals(tmpVemail) ||  tmpVemail==null)tmpVemail="";
		String concatString1 = "-#"+tmpVend+"#"+tmpVname+"#"+"A"+"#"+qty;
		String checked1="";
		if(selectedVendors!=null)
		{
			for(int al=0; al<selectedVendors.length; al++)
			{
				if(selectedVendors[al].equals(concatString1)) 
				{
					checked1="checked";
					chkdIndx=chkdIndx+"##"+i+"";
				}
				
			}
			if(chkdIndx.startsWith("##"))chkdIndx=chkdIndx.substring(2);
		}
		//if(fixedVendHT.containsKey(sapvendRet.getFieldValueString(i,"EC_ERP_CUST_NO")))checked1="checked";
%>
		<tr>
			<td align="center"><input onclick="onChgChk(this,'<%=index%>','N')" type="checkbox" name="selChk" value='<%=concatString1%>' <%=checked1%>></td>
			

			<td align="left" width="10%"><%=tmpVCode%></td>
        		<td align="left" width="30%"><%=tmpVname%>&nbsp;</td>
        		<td align="left" width="25%"><%=checkNull(tmpVemail)%>&nbsp;</td>
        		
		</tr>
<%
	}
%>
</tbody>
</table>
</div>
</div>
<% 	} 
%>
</div>
</div>

