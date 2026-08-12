<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<% 
	String display_header="Create Purchase Requisitions";
	//String noDataStatement =(String)session.getValue("Vendor")+detNotAvaiLabel_L;
%>
<html>
<head>
	<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
	<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>
	<Script>
		var tabHeadWidth=90
		var tabHeight="80%"
	</Script>
	<Script src="../../Library/JavaScript/ezTabScroll.js"></Script>
	<Script>
		function searchForMaterial(i)
		{
			document.myForm.searchStr.value = document.myForm.matNo[i].value;
			var matValue = document.myForm.matNo[i].value;
			matValue = matValue.substring(0,matValue.indexOf("*"));

			if(isNaN(matValue))
			{
				searchMatByDesc();					
			}	
			else	
			{
				searchMatByNumber();			
			}

		}
		
		
		function checkEntry()
		{
			var matNo1=document.myForm.matNo;
			var len=matNo1.length;
			var myStatus=false;
			for(i=0;i<len;i++){
				if(matNo1[i].value!=""){
					myStatus=true;
					break;
				}
				
			}
			return myStatus;
		}
		
		function funChk()
		{
		  
		  
		  
		 if(checkEntry())
		 {
		   
			var i;
			
			var matNo=document.myForm.matNo;
		   
		  for(i=0;i<matNo.length;i++)
		  {
		   	
		   	if(document.myForm.matNo[i].value !="")
		   	{
				 if(document.myForm.matDesc[i].value =="" || document.myForm.matDesc[i].value=="null")
				 {
				     alert("Please Enter Material Description in the "+parseInt(i+1)+" line item")
				     document.myForm.matDesc[i].focus()
				     break;
				 }
				else if(document.myForm.uom[i].value =="" || document.myForm.uom[i].value=="null")
				{
				     alert("Please Enter Material UOM in the "+parseInt(i+1)+" line item")
				     document.myForm.uom[i].focus()
				     break;
				 }
				else if(document.myForm.plant[i].value =="" || document.myForm.plant[i].value=="null")
				 {
				     alert("Please Enter Plant Code in the "+parseInt(i+1)+" line item")
				     document.myForm.plant[i].focus()
				     break;
				 }
				else if(document.myForm.matqty[i].value =="" || document.myForm.matqty[i].value=="null")
				 {
				     alert("Please Enter Material Quantity in the "+parseInt(i+1)+" line item")
				     document.myForm.matqty[i].focus()
				     break;
				 }
				
				
		   	  }
		     } 
		 }
		   	
		   else
		   {
		        alert("Please enter at least one Material code")
		        document.myForm.matNo[0].focus()
	           }
	          
	       }
	       
	       function verifyQty(field,index)
	       {
	       
	       	var fValue=field.value
	       	if(isNaN(fValue) && fValue!=""){
	       		alert("Please enter valid quantity");
	       		field.value="";
	       		field.focus();
	       	 }
	       
	      }
	      
	      
		function searchMatByNumber()
		{	
			var plzMatNum_L = 'Please Enter Material Number';
			var matNo		= document.myForm.searchStr.value; 
			var searchFlagObj	= document.myForm.searchFlag
			var searchFlag

			if(searchFlagObj!=null)
				searchFlag = document.myForm.searchFlag.value;
			else
				searchFlag = "Y";
			if(matNo=="")
			{
				alert(plzMatNum_L);
				return;
			}		
			var url="../RFQ/ezNewListMaterials.jsp?matCode="+matNo+"&searchFlag="+searchFlag;
			newWindow=window.open(url,"ReportWin","width=700,height=500,left=20,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
		}
		function searchMatByDesc()
		{			
			var matDesc 		= document.myForm.searchStr.value; 
			var searchFlagObj	= document.myForm.searchFlag
			var searchFlag
				
			if(searchFlagObj!=null)
				searchFlag = document.myForm.searchFlag.value;
			else
				searchFlag = "Y";
					
				if(matDesc=="")
				{
					alert(plzMatDesc_L);
					return;
				}
			
			var url="../RFQ/ezSearchMaterial.jsp?matDesc="+matDesc+"&searchFlag="+searchFlag;
			newWindow=window.open(url,"ReportWin","width=700,height=500,left=100,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
		}
		
		function funUpload()
		{
		
			if(funChk())
			{
			     
			     buttonsSpan	  = document.getElementById("EzButtonsSpan")
			     buttonsMsgSpan	  = document.getElementById("EzButtonsMsgSpan")
			     if(buttonsSpan!=null){
				buttonsSpan.style.display	= "none"
				buttonsMsgSpan.style.display	= "block"
		     		}
		     	
				document.myForm.action="ezCreatePRChk.jsp";
				document.myForm.submit();
			}
		}
		
		
	</Script>
	
</head>
<body bgcolor="#FFFFF7" onLoad="scrollInit()" onResize="scrollInit()"  scroll=no>
<form name=myForm action="" method="POST">
<%@ include file="../Misc/ezDisplayHeader.jsp" %>
<br>
<DIV id="theads">
	<Table id="tabHead" width="90%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
		<Tr> 
			<th width="20%">Material Code</th>
			<th width="30%">Description</th>
			<th width="10%">UOM</th>
			<th width="12%">Plant</th>
			<th width="15%">Net  Qty</th>
			<th width="13%">Deliv. Date</th>
		</Tr>
	</Table>
</Div>
<DIV id="InnerBox1Div" style="overflow:auto;position:absolute;width:90%;height:80%;left:2%">
		<TABLE id="InnerBox1Tab" width="100%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
<%
		for(int i=0;i<10;i++){		
%>		
			<Tr>
				<td width="20%">
					<input type="text" class="InputBox"  style="width:85%"  name="matNo"  maxlength="20" size="20" value="">&nbsp;
					<img src="../../Images/Others/find.gif" alt ='' style="cursor:hand" height="13" onClick="javascript:searchForMaterial('<%=i%>')"></img>
				</td>
				<td width="30%"><input type="text" class="InputBox"  style="width:100%"  name="matDesc"  maxlength="20" size="20" value=""></td>
				<td width="10%"><input type="text" class="InputBox"  style="width:100%"  name="uom"      maxlength="20" size="20" value=""></td>
				<td width="12%"><input type="text" class="InputBox"  style="width:100%"  name="plant"    maxlength="20" size="20" value="" ></td>
				<td width="15%"><input type="text" class="InputBox"  style="width:100%"  name="matqty"   maxlength="20" size="20" value="" onBlur="verifyQty(this,'<%=i%>')"></td>
				<td width="13%" align="right" >
					<input type="text" class=InputBox  style="width:82%;valign:top" name="delvdate"  value="" size=12 readonly onfocus=this.blur()>
					<%=getDateImage("delvdate")%>
				</td>
			</Tr>
<%
		}
%>
		</TABLE>
</DIV>	

<Div id="image" align="center" style='Position:Absolute;visibility:visible;Left:10%;WIDTH:80%;height:70%;Top:85%'>
	<Table align="center">
		<tr align="center">
			<td class=blankcell align="center">
			<span id="EzButtonsSpan" >
<%
			buttonName = new ArrayList();
			buttonMethod = new ArrayList();

			buttonName.add("Create");
			buttonMethod.add("funUpload()");

			out.println(getButtonStr(buttonName,buttonMethod));
%>
			</span>
			<span id="EzButtonsMsgSpan" style="display:none">
			<Table align=center>
			<Tr>
				<Td >Your request is being processed... Please wait</Td>
			</Tr>
			</Table>
			</span>
		</Td>
		</Tr>
	</Table>
</Div>






<input type="hidden" name="matNum" value="N">
<input type="hidden" name="searchFlag" value="Y">
<input type="hidden" name="searchStr" value="">
<Div id="MenuSol"></Div>
</form>
</body>
</html>
