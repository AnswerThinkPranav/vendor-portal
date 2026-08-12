<%!
 public static String removeZero(String str) 
    { 
        // Count leading zeros 
        int i = 0; 
        while (i < str.length() && str.charAt(i) == '0') 
            i++; 
  
        // Convert str into StringBuffer as Strings 
        // are immutable. 
        StringBuffer sb = new StringBuffer(str); 
  
        // The  StringBuffer replace function removes 
        // i characters from given index (0 here) 
        sb.replace(0, i, ""); 
  
        return sb.toString();  // return in String 
    } 
%> 
<%
	int rCount = 0;//sapvendRet.getRowCount();   
	ezc.ezcommon.EzLog4j.log("rCount>>"+rCount,"I"); 
	Vector Vendor=new Vector();
	Vector Name=new Vector();
	sapvendRet.sort(new String[]{"ECA_NAME"},true);
	//out.println(sapvendRet.toEzcString());
	for(int i=0;i<rCount;i++)
	{
		if(!Vendor.contains((String) sapvendRet.getFieldValue(i,"EC_ERP_CUST_NO")))
		{
			String ven = ((String) sapvendRet.getFieldValue(i,"EC_ERP_CUST_NO")).trim(); 
			Vendor.addElement(ven);
			Name.addElement((String) sapvendRet.getFieldValue(i,"ECA_NAME"));
		}
	}
	int vendCnt=0;
	ReturnObjFromRetrieve vendGenDataObj=null;
	ezc.misctransactions.client.EzMiscTransactionsManager miscMgrVend = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable miscTableVend = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow miscTableRowVend = new ezc.misctransactions.params.EzMiscTableRow();
	ezc.ezparam.EzcParams mainParamsVend = new ezc.ezparam.EzcParams(false);
	//miscTableRowVend.setQuery("select * from ezc_vend_gen_data");
	//miscTableRowVend.setQuery("SELECT EU_ID,EU_FIRST_NAME,EU_EMAIL,EU_CONTACT_NO,EVGD_CITY FROM EZC_USERS,EZC_VEND_GEN_DATA WHERE EU_ID=EVGD_VENDOR AND EU_ID IN(SELECT EUA_USER_ID FROM EZC_USER_AUTH WHERE EUA_AUTH_KEY='RFQ_QUOTE')");
	//miscTableRowVend.setQuery("SELECT EU_ID,EU_FIRST_NAME,EU_EMAIL,EU_CONTACT_NO,EVGD_CITY FROM EZC_USERS,EZC_VEND_GEN_DATA WHERE EU_ID=EVGD_VENDOR AND EU_ID IN(SELECT EUA_USER_ID FROM EZC_USER_AUTH WHERE EUA_AUTH_KEY='RFQ_QUOTE')");
	miscTableRowVend.setQuery("SELECT EU_ID,EU_FIRST_NAME,EU_EMAIL,EU_CONTACT_NO FROM EZC_USERS WHERE EU_TYPE='3' AND EU_ID NOT IN('EZCADMIN') AND EU_ID IN (SELECT EUD_USER_ID FROM EZC_USER_DEFAULTS WHERE EUD_SYS_KEY IN ('"+userSyskeysStr+"'))");
	//miscTableRowVend.setQuery("SELECT EU_ID,EUD_VALUE ,EU_FIRST_NAME,EU_EMAIL FROM EZC_USERS,EZC_USER_DEFAULTS WHERE EU_ID = EUD_USER_ID AND EUD_KEY='USERROLE' AND EUD_VALUE='TV'");
	
	
	miscTableVend.appendRow(miscTableRowVend);
	mainParamsVend.setLocalStore("Y");
	mainParamsVend.setObject(miscTableVend);
	Session.prepareParams(mainParamsVend);

	try
	{
		vendGenDataObj=(ezc.ezparam.ReturnObjFromRetrieve)miscMgrVend.ezGetMiscTransactions(mainParamsVend);

	}
	catch(Exception e)
	{
		out.println("Exception in getting Vendor List>>>>>"+e);
	}
	if(vendGenDataObj!=null)
		vendCnt=vendGenDataObj.getRowCount();
	vendGenDataObj.sort(new String[]{"EU_FIRST_NAME"},true);	

%>
<div class="row">
   <!-- left column -->
   <div class="col-md-12 col-xs-12">
<%


	if(vendCnt==0)
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

   <!-- general form elements -->
   <div class="box box-primary">
         <div id="tab11" class="box-body table-responsive no-padding" style="display: block;max-height: 400px;"> 
	       <input class="form-control pull-right" id="myInput" type="text" placeholder="Search.." style="width: 50%;margin: 2px;">	
               <table id="myTable" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%" height="100%">
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
	String	vendor1="";
	String  vCode="";
	String	vName="";
	String	city="";
	String	phoneNO="";
	String 	emailID="";
 	String 	selectedVendors[]= request.getParameterValues("selChk");
 	
 	for(int i=0;i<vendCnt;i++)
	{	
		int index = vendCnt+i;
		vCode = vendGenDataObj.getFieldValueString(i,"EU_ID"); 
		try{
			vendor1 = Long.parseLong(vCode)+"";
			vendor1 = "0000000000"+vendor1;
			vendor1 = vendor1.substring(vendor1.length()-10,vendor1.length());
		}catch(Exception e){
			vendor1 = vCode; 
		}		
		vName   = vendGenDataObj.getFieldValueString(i,"EU_FIRST_NAME");
		city	= "HYD"; //hardcode for Testing
		phoneNO	= vendGenDataObj.getFieldValueString(i,"EU_CONTACT_NO");
		emailID	= vendGenDataObj.getFieldValueString(i,"EU_EMAIL");
		if("null".equals(city) || "".equals(city) ||  city==null)city="";
		if("null".equals(emailID) || "".equals(emailID) ||  emailID==null)emailID="";
		String concatString = "-#"+vendor1+"#"+vName+"#"+"A"+"#"+qty;
		String checked="";
		if(selectedVendors!=null)
		{
			for(int al=0; al<selectedVendors.length; al++)
			{
				if(selectedVendors[al].equals(concatString)) 
				{
					checked="checked";
					chkdIndx=chkdIndx+"##"+i+"";
				}
				
			}
			if(chkdIndx.startsWith("##"))chkdIndx=chkdIndx.substring(2);
		}
		//if(fixedVendHT.containsKey(sapvendRet.getFieldValueString(i,"EC_ERP_CUST_NO")))checked="checked";
%>
		<tr>
			<td align="center"><input onclick="onChgChk(this,'<%=i%>','S')" type="checkbox" name="selChk" value='<%=concatString%>' <%=checked%>></td>
			
			<!--<td align="center" width="5%"><input onclick="onChgChk(this,'<%=index%>','S')" type="checkbox" name="chk1" value=""></td>-->
			<!--<input type="hidden" name="concatString1" value="" >
			<input type=hidden name='qtyTxt' value='<%=qty%>'>-->
			<td align="left" width="10%"><%=vCode%></td>
        		<td align="left" width="30%"><%=vName%>&nbsp;</td>
        		<!--<td align="left" width="15%"><%=checkNull(city)%>&nbsp;</td>
        		<td align="left" width="15%"><%=checkNull(phoneNO)%>&nbsp;</td> -->
        		<td align="left" width="25%"><%=checkNull(emailID)%>&nbsp;</td>
        		<!--<td align="left" width="20%">TBD</td>-->
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



