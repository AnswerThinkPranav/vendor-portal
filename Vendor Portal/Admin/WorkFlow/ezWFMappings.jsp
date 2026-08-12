 <jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
 <%@ page language="java" errorPage="../Misc/ezErrorDisplay.jsp"%>
 <%@ page import="java.util.*" %>
 <%@ page import ="ezc.ezparam.*,java.util.*,java.text.*,java.nio.file.*" %> 
 

  <%@ include file="../../../Includes/Lib/AddButtonDir.jsp"%> 
 <%@ page import="ezc.ezmisc.params.*" %>

<html> 
<head>

<%		 
	
	
	int retObjWFCnt = 0;
		
	ezc.ezparam.ReturnObjFromRetrieve retObjWFMap = new ezc.ezparam.ReturnObjFromRetrieve();
	ezc.ezparam.EzcParams wfParams = new ezc.ezparam.EzcParams(false); 
	ezc.misctransactions.client.EzMiscTransactionsManager wfMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable wfMap = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow wfMapRow = new ezc.misctransactions.params.EzMiscTableRow();
	wfMapRow.setQuery("SELECT * FROM ezc_wf_defaults_map");
	wfMap.appendRow(wfMapRow);
	wfParams.setLocalStore("Y");
	wfParams.setObject(wfMap);
	Session.prepareParams(wfParams); 
 
	try{
		retObjWFMap=(ezc.ezparam.ReturnObjFromRetrieve)wfMgr.ezGetMiscTransactions(wfParams);
	}catch(Exception e){
		ezc.ezcommon.EzLog4j.log("Exception in getting ezc_wf_defaults_map:::::::","E");
	}

	if(retObjWFMap!=null && retObjWFMap.getRowCount()>0)
		retObjWFCnt = retObjWFMap.getRowCount(); 
		
	//Getting plants from DB
	String plantValues="";
	int plantCnt = 0;
			
	ezc.ezparam.ReturnObjFromRetrieve plantObj = new ezc.ezparam.ReturnObjFromRetrieve();
	ezc.ezparam.EzcParams plantParams = new ezc.ezparam.EzcParams(false); 
	ezc.misctransactions.client.EzMiscTransactionsManager plantMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable plantTab = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow plantRow = new ezc.misctransactions.params.EzMiscTableRow();
	plantRow.setQuery("SELECT * FROM EZC_PLANTS");
	plantTab.appendRow(plantRow);
	plantParams.setLocalStore("Y");
	plantParams.setObject(plantTab);
	Session.prepareParams(plantParams); 

	try{
		plantObj=(ezc.ezparam.ReturnObjFromRetrieve)plantMgr.ezGetMiscTransactions(plantParams);
	}catch(Exception e){
		ezc.ezcommon.EzLog4j.log("Exception in getting ezc_wf_defaults_map:::::::","E");
	}

	if(plantObj!=null)
		plantCnt = plantObj.getRowCount();
		
	for(int i=0;i<plantCnt;i++)
	{
		plantValues += "<option value='"+plantObj.getFieldValueString(i,"EP_PLANT")+"'>"+plantObj.getFieldValueString(i,"EP_PLANT")+"-"+plantObj.getFieldValueString(i,"EP_NAME1")+"</option>";
	}
	
	String catValues="";
	int catCnt = 0;

	ezc.ezparam.ReturnObjFromRetrieve catObj = new ezc.ezparam.ReturnObjFromRetrieve();
	ezc.ezparam.EzcParams catParams = new ezc.ezparam.EzcParams(false); 
	ezc.misctransactions.client.EzMiscTransactionsManager catMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.misctransactions.params.EzMiscTable catTab = new ezc.misctransactions.params.EzMiscTable();
	ezc.misctransactions.params.EzMiscTableRow catRow = new ezc.misctransactions.params.EzMiscTableRow();
	catRow.setQuery("select * from ezc_value_mapping where MAP_TYPE='CATEGORY'");
	catTab.appendRow(catRow);
	catParams.setLocalStore("Y");
	catParams.setObject(catTab);
	Session.prepareParams(catParams); 

	try{
		catObj=(ezc.ezparam.ReturnObjFromRetrieve)catMgr.ezGetMiscTransactions(catParams);
	}catch(Exception e){
		ezc.ezcommon.EzLog4j.log("Exception in getting ezc_wf_defaults_map:::::::","E");
	}

	if(catObj!=null)
		catCnt = catObj.getRowCount();

	for(int j=0;j<catCnt;j++)
	{
		catValues += "<option value='"+catObj.getFieldValueString(j,"VALUE1")+"'>"+catObj.getFieldValueString(j,"VALUE1")+"-"+catObj.getFieldValueString(j,"VALUE2")+"</option>";
	}
		
%> 
 
<body scroll=no>

<form name="myForm" id="myForm" method="post">
<input type="hidden" name="actFlag" value="">
<input type="hidden" name="mapDept" value="">
<input type="hidden" name="mapPlant" value="">
<input type="hidden" name="mapKey" value="">
<input type="hidden" name="mapVal" value="">

<div class="box-body table-responsive no-padding">
	<div class="box-body">
		<table id="example" class="table table-bordered" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2  cellspacing="0" width="75%">

			<thead>
			<tr>
			<th>Select</th> 
			<th>Department</th>
			<th>Plant</th>
			<th>Key</th>
			<th>Value</th>
			</tr>
			</thead>

			<tbody>
			<%
				if(retObjWFMap!=null && retObjWFCnt>0)
				{
					for(int itr=0;itr<retObjWFCnt;itr++)
					{
						String mapDept = retObjWFMap.getFieldValueString(itr,"EWDM_DEPT").trim();
						String mapPlant = retObjWFMap.getFieldValueString(itr,"EWDM_PLANT").trim();
						String mapKey = retObjWFMap.getFieldValueString(itr,"EWDM_KEY").trim();
						String mapVal = retObjWFMap.getFieldValueString(itr,"EWDM_VALUE").trim();

			%>
						<tr>
							<td align="center"><input type='radio' name='mapChk' id='mapChk' value='<%=mapDept%>' onclick="enblBox('<%=itr%>','<%=mapDept%>')"></td>
							<td><input type='text' name='mapDeptBox' id='mapDeptBox' value='<%=mapDept%>' disabled></td>
							<td><input type='text' name='mapPlantBox' id='mapPlantBox' value='<%=mapPlant%>' disabled></td>
							<td><input type='text'  name='mapKeyBox' id='mapKeyBox' value='<%=mapKey%>' disabled></td>
							<td><input type='text'  name='mapValBox' id='mapValBox' value='<%=mapVal%>' disabled></td>
						</tr>
						
						
			<%
					}	
				}
			%>	
				</tbody>
			</table>
			<br>
			<center>						

				<button type="button"  onclick="funAddmap('SHOW')">&nbsp;Add</button>&nbsp;	
				
				<%if(retObjWFMap!=null && retObjWFCnt>0){%>		
					<button type="button"  onclick="funAddmap('DEL')">&nbsp;Delete</button>&nbsp;
					<button type="button"  onclick="funAddmap('UPD')">&nbsp;Update</button>&nbsp;
				<%}%>
			</center>
			<br>
			<div class="box-body" style="width: fit-content; display:none;" id="SHOWDIV">
			<table class="table table-bordered" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2  cellspacing="0" width="75%">
			<tr>
				<th>CATAGORY</th>
				
				<td>
									
					<select name='chngMapDept' id='chngMapDept'>
					<option value="">select Catagory</option>
					<%=catValues%>
					</select>
				</td>
				<th>PLANT</th>
				<td>
					
					<select name='chngMapPlant' id='chngMapPlant'>
					<option value="">select plant</option>
					<%=plantValues%>
					</select>
				</td>
				<th>KEY</th>
				<td><input type='text' size='30' maxlength='100' name='chngMapKey' id='chngMapKey' value='PURGRP'>	</td>
				<th>VALUE</th>
				<td><input type='text' size='30' maxlength='100' name='chngMapVal' id='chngMapVal' value=''></td>
				<td><button type="button"  onclick="funAddmap('ADD')" align="center">&nbsp;Save</button>&nbsp;</td>							
			</tr>

			</table>
			<br>
			</div>

			<br>	

			</div>
		</div>
	</div>
</div> 		
</div>
</div>
</div>
</div>
</div>
</div>
</form>
<script>	
function enblBox(indx,mapDept)
{

	var radObj = document.myForm.mapChk;
	var deptObj = document.myForm.mapDeptBox;
	var keyObj = document.myForm.mapKeyBox;
	var plantObj = document.myForm.mapPlantBox;
	var valObj = document.myForm.mapValBox;
	
	var mapDept="";
	
	if(radObj.length>1)
	{	
		if(radObj[indx].checked)
		{
			//plantObj[indx].disabled = false;
			//keyObj[indx].disabled = false;
			valObj[indx].disabled = false;
			//plantObj[indx].focus();
		}
			
	}
	else
	{
		
		deptObj.disabled = false;
		keyObj.disabled = false;
		plantObj.disabled = false;
		valObj.disabled = false;
		plantObj.focus();
	}


}
/*
function dsblBox(indx)
{
	var plantObj = document.myForm.mapPlantBox;
	var keyObj = document.myForm.mapKeyBox;
	var valObj = document.myForm.mapValBox;
	var radObj = document.myForm.mapChk;
	
	if(radObj.length>1)
	{
		plantObj[indx].disabled = true;
		keyObj[indx].disabled = true;
		valObj[indx].disabled = true;
	}
	else
	{
		keyObj.disabled = true;
		plantObj.disabled = true;
		valObj.disabled = true;
	}
}
*/
function funAddmap(actFlag)
{
	var alertTxt = "",cnfmTxt="",mapDept="",mapPlant="",indx="",focusObj="",mapKey="",mapVal="";
	if(actFlag=='SHOW')
	{
		document.getElementById("SHOWDIV").style.display = "inline";
	}
	if(actFlag=='ADD')
	{
		mapDept = document.myForm.chngMapDept.value;
		mapPlant = document.myForm.chngMapPlant.value;
		mapKey = document.myForm.chngMapKey.value;
		mapVal = document.myForm.chngMapVal.value;
		
		if(mapDept=='')
		{
			alert("Please Enter the Department");
			document.myForm.chngMapDept.focus();
			return;
		}
		if(mapPlant=='')
		{			
			alert("Please Enter the Plant");
			document.myForm.chngMapPlant.focus();
			return;
		}
		if(mapKey=='')
		{			
			alert("Please Enter the Key");
			document.myForm.chngMapKey.focus();
			return;
		}
		if(mapVal=='')
		{			
			alert("Please Enter the Value");
			document.myForm.chngMapKey.focus();
			return;
		}
		if(mapPlant!='' && mapDept!='' && mapKey!='' && mapVal)
			cnfmTxt = "Are you sure you want to add the Details?";
		
		if(cnfmTxt!='' && confirm(cnfmTxt))
		{
			document.myForm.actFlag.value = actFlag;	

			document.myForm.mapDept.value = mapDept;
			document.myForm.mapPlant.value = mapPlant;
			document.myForm.mapKey.value = mapKey;
			document.myForm.mapVal.value = mapVal;

			document.myForm.action = "ezUpdateWFMapping.jsp";
			document.myForm.submit();	
		}		
	}
	
	if(actFlag=='DEL')
	{
		//alert("actFlag>>>"+actFlag);
		//debugger;
		var radObj = document.myForm.mapChk;
		var deptObj = document.myForm.mapDeptBox;
		
		var plantObj = document.myForm.mapPlantBox;
		var keyObj = document.myForm.mapKeyBox;
		
		var valObj = document.myForm.mapValBox;
		
		
		if(radObj.length>1)
		{
			for(var itr=0;itr<radObj.length;itr++)
			{
				if(radObj[itr].checked)
				{
					mapDept = radObj[itr].value;
					mapPlant = plantObj[itr].value;
					mapKey = keyObj[itr].value;
					
				}
			}
		}
		else
		{
			mapDept = radObj.value;
			mapPlant = plantObj.value;
			mapKey = keyObj.value;
		}
		
		if(mapDept!='')
		{
			cnfmTxt = "Are you sure you want to Delete the Details?";
		}
		else
			alert("Please Select the Data to Delete");
		//alert("actFlag1>>>"+cnfmTxt);
		
		
		if(cnfmTxt!='' && confirm(cnfmTxt))
		{
			document.myForm.actFlag.value = actFlag;
			document.myForm.mapDept.value = mapDept;
			document.myForm.mapPlant.value = mapPlant;
			document.myForm.mapKey.value = mapKey;
			document.myForm.mapVal.value = mapVal;
			
			document.myForm.action = "ezUpdateWFMapping.jsp";
			document.myForm.submit();	
		}
	}
	if(actFlag=='UPD')
	{	
		//alert("actFlag>>>"+actFlag);
		var radObj = document.myForm.mapChk;
		var deptObj = document.myForm.mapDeptBox;
		var plantObj = document.myForm.mapPlantBox;
		var keyObj = document.myForm.mapKeyBox;
		var valObj = document.myForm.mapValBox;
		
		if(radObj.length>1)
		{
			for(itr=0;itr<radObj.length;itr++)
			{
				if(radObj[itr].checked)
				{
					mapChk = radObj[itr].value;
					mapDept = deptObj[itr].value.trim();
					mapPlant = plantObj[itr].value.trim();
					mapKey = keyObj[itr].value.trim();
					mapVal = valObj[itr].value.trim();
					
					if(mapPlant=='')
					{
						alert("Please enter the Plant");
						plantObj[itr].disabled = false;
						plantObj[itr].focus();
					}
					if(keyObj=='')
					{
						alert("Please enter the Key");
						keyObj[itr].disabled = false;
						keyObj[itr].focus();
					}
					if(mapVal=='')
					{
						alert("Please enter the Value");
						valObj[itr].disabled = false;
						valObj[itr].focus();
					}
					if(mapDept=='')
					{
						alert("Please enter the Plant");
						deptObj.focus();
						return;
					}
					
				}			
			}		
		}
		else
		{
			mapChk = radObj.value;
			mapDept = deptObj.value.trim();
			mapPlant = plantObj.value.trim();	
			mapKey = keyObj.value.trim();
			mapVal = valObj.value.trim();
			if(mapPlant=='')
			{
				alert("Please enter the Plant");
				plantObj.focus();
				return;
			}
			if(mapDept=='')
			{
				alert("Please enter the Plant");
				deptObj.focus();
				return;
			}
			if(keyObj=='')
			{
				alert("Please enter the Key");
				keyObj.focus();
				return;
			}
			if(mapVal=='')
			{
				alert("Please enter the Value");
				valObj.disabled = false;
				valObj.focus();
			}
		}	
		
		if(mapChk=='')
		{
			alert("Please select the Department");
			return;	
		}
		
		if(mapPlant!='')		
		{
			
			if(confirm("Are you sure you want to Update the Details?"))
			{
				document.myForm.actFlag.value = actFlag;
				
				document.myForm.mapDept.value = mapDept;
				document.myForm.mapPlant.value = mapPlant;
				document.myForm.mapKey.value = mapKey;
				document.myForm.mapVal.value = mapVal;

				document.myForm.action = "ezUpdateWFMapping.jsp";
				document.myForm.submit();
			}
		
		}
	}
	
}
 

</script>


