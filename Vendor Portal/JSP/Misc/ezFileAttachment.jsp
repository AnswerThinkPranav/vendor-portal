<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@page import="java.util.*"%>
<%
String bankACCode = request.getParameter("bankACCode");
//out.println(bankACCode+":::::::bankACCode::::::::::::");
if(bankACCode==null || "null".equals(bankACCode))bankACCode="";
String bankACCodeArrTemp[] = null;

String bankACCodeArr[] =new String[2];
//out.println(bankACCode);
int bankACCodeArrTempLen=0,bankACCodeArrLen=0;
try{
	bankACCodeArrTemp=bankACCode.split("¥");
	bankACCodeArrTempLen=bankACCodeArrTemp.length;
	if(bankACCodeArrTempLen>0) bankACCodeArr = new String[bankACCodeArrTempLen+2];

	for(int k=0;k<bankACCodeArrTempLen;k++)
	{
		bankACCodeArr[k]=bankACCodeArrTemp[k];		
	}

}catch(Exception e){}
bankACCodeArr[bankACCodeArrTempLen]="STATUTORY-";
bankACCodeArr[bankACCodeArrTempLen+1]="GENERAL-";
bankACCodeArrLen=bankACCodeArr.length;
%>
<!DOCTYPE html>
<html lang="en">
  <head>
 <!-- Bootstrap 3.3.5 -->
    <link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/datepicker.css">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/font-awesome.min.css">
    <!-- Ionicons -->
    <link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/ionicons.min.css">
    
    <!-- Theme style --> 
    <link rel="stylesheet" href="../../../../EzCommon/Library/dist/css/AdminLTE.min.css">
    <!-- AdminLTE Skins. We have chosen the skin-blue for this starter
          page. However, you can choose any other skin. Make sure you
          apply the skin class to the body tag so the changes take effect.
    -->
    <link rel="stylesheet" href="../../../../EzCommon/Library/dist/css/skins/skin-yellow.min.css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
  <style>
.fileUpload {
	position: relative;
	overflow: hidden;
	margin: 1px;
}
.fileUpload input.upload {
	position: absolute;
	top: 0;
	right: 0;
	margin: 0;
	padding: 0;
	font-size: 20px;
	cursor: pointer;
	opacity: 0;
	filter: alpha(opacity=0);
	float:none;
}

.filename {
	width:250px;
	float:right;
}
</style>
<script src="../../Library/JavaScript/ezTrim.js"></script>

<script>
function funAddRow(tableID) 
{   

	var indexLen = "";
	if(document.myForm.index!=null)
	indexLen = document.myForm.index.length;
	if(isNaN(indexLen))indexLen=1;
	//alert(amountLen)	
	
	var tabObj		= document.getElementById(tableID)
	var rowItems 		= tabObj.getElementsByTagName("tr");
	var rowCountValue 	= rowItems.length;	
	
	//alert("rowCountValue:::"+rowCountValue)
	
	
	var index=0;
	 for(var i=0;i<indexLen;i++)
	{	//alert("i::::"+i);
		
		if(isNaN(document.myForm.index.length))
		index = document.myForm.index.value
		else
		index = document.myForm.index[i].value	

	
		if(eval("document.myForm.Desc"+index)!=undefined)
		{
			//alert("in if:::"+eval("document.myForm.Desc"+index).value);
			if(eval("document.myForm.Desc"+index).value  == "")
			{
				alert("Please select Description for line "+ (parseFloat(i)+1));
				eval("document.myForm.Desc"+index).focus();
				return;
			}			
		}		
		if(eval("document.myForm.Attachment"+index)!=undefined)
		{
			if(eval("document.myForm.Attachment"+index).value  == "")
			{
				alert("Please  Attach file for "+eval("document.myForm.Desc"+index).value);
				return;
			}	
			
		}
		
		
				
		
	}	
	
	
	//alert("index:value::"+(parseFloat(index)+1))
	var table = document.getElementById(tableID);      
	var rowCount = table.rows.length;
	//rowCount = (parseFloat(index)+1);
	var row = table.insertRow(rowCount);       
	
	
	var cell1 = row.insertCell(0);      
	 var cell1Val='<input type="hidden" name="index" value="'+(parseFloat(index)+1)+'"><select name="attachmentType'+(parseFloat(index)+1)+'" id="attachmentType'+(parseFloat(index)+1)+'">';

	//var cell2 = row.insertCell(1);      
 	//cell2.innerHTML ='<input type="text" name="Desc'+(parseFloat(index)+1)+'"   value="" onBlur="funBlur(\''+(parseFloat(index)+1)+'\')" /><input type="hidden" name="path'+(parseFloat(index)+1)+'" value="" /><input type="hidden" name="AttachTime'+(parseFloat(index)+1)+'" value="" />';
 	
 	var cell2 = row.insertCell(1);      
	cell2.innerHTML ='<input type="hidden" name="Desc'+(parseFloat(index)+1)+'"   value="NA"  /><input type="hidden" name="path'+(parseFloat(index)+1)+'" value="" /><input type="hidden" name="AttachTime'+(parseFloat(index)+1)+'" value="" /><div class="fileUpload btn btn-info"><span>Upload</span> <input type="file" name="AttachmentFile'+(parseFloat(index)+1)+'" value=""  onChange="funChange(\''+(parseFloat(index)+1)+'\')" class="upload" /></div><a href="javascript:openUploadDoc('+(parseFloat(index)+1)+')"><input type="text"  name="Attachment'+(parseFloat(index)+1)+'" placeholder="Choose File" disabled="disabled" style="width:250px;float:right;margin-left:-90px;"/></a>';
	
	<%
	for(int j=0;j<bankACCodeArrLen;j++)
	{
		String selected="";
		String key = bankACCodeArr[j];
		String value = bankACCodeArr[j];
		//out.println(bankACCodeArr[j]);
		try{
		key = bankACCodeArr[j].split("-")[0] ;
		}catch(Exception e){}
		try{
		value="("+bankACCodeArr[j].split("-")[1]+")";
		}catch(Exception e){value="";
		
		}
		if("-".equals(key.trim()))continue;
	%>
		cell1Val=cell1Val+'<option value="<%=key%>" <%=selected%>><%=key%><%=value%></option>';
	<%
	}
	%>
	cell1.innerHTML=cell1Val+"</select>";
	
	var cell3 = row.insertCell(2);   
	cell3.innerHTML = '<a href="Javascript:deleteRow(\''+(parseFloat(index)+1)+'\')" style="background-color:white"><i class="fa fa-trash-o fa-lg"></i></a>';  	
	
	
}
function deleteRow(index) 
{        
	
	var flag = confirm("Please confirm to remove row::"+(parseInt(index)+1));
	
	if(flag)
	{
		var indexval ;
	
	
	try
	{     
		var table = document.getElementById("dataTab");  
		var rowCount = table.rows.length;
		/*if(rowCount<=2)
		{
			alert("All rows can not be deleted");
			return;
		}*/
		for(var i=0; i<rowCount; i++) 
		{          
		
			
			if(isNaN(document.myForm.index.length))
			indexval = document.myForm.index.value ;
			else
			indexval = document.myForm.index[i].value ;
			
			 if(indexval == index) 
			{             
				table.deleteRow(i+1); 
				break;
			}    
		}
    
	}
	catch(e) 
	{    
		alert(e); 
	}   
	}
} 
function funAttach()
{
	window.parent.document.myForm.attachFlag.value="Y";
//alert(window.parent.document.myForm.attachType.value);
	var indexLen = "0";
	
	if(document.myForm.index!=null)
	indexLen = document.myForm.index.length;
	
	if(window.parent.document.getElementById("uploaddocs")!=undefined)
	window.parent.document.getElementById("uploaddocs").innerHTML="Uploaded Docs";
	
	var attachmentTypeStr="",descriptionStr="",attachFilesStr="",attachFileTimeStr="";
	
	if(isNaN(indexLen))indexLen=1;
	
	for(i=0;i<indexLen;i++)
	{
		if(isNaN(document.myForm.index.length))
		index = document.myForm.index.value
		else
		index = document.myForm.index[i].value
		
	//	alert(index);
	//	alert(eval("document.myForm.attachmentType"+index).value);
		if(eval("document.myForm.attachmentType"+index)!=undefined)
		{
			
			if(attachmentTypeStr=="")
			attachmentTypeStr = eval("document.myForm.attachmentType"+index).value;
			else
			attachmentTypeStr = attachmentTypeStr+"¥"+eval("document.myForm.attachmentType"+index).value;

					//alert(attachmentTypeStr+":::::::attachmentTypeStr::::::::");
		}
		if(eval("document.myForm.Desc"+index)!=undefined)
		{
			if(eval("document.myForm.Desc"+index).value  == "")
			{
				alert("Please select Description for line "+ (parseFloat(i)+1));
				eval("document.myForm.Desc"+index).focus();
				return;
			}		
			
			if(descriptionStr=="")
			descriptionStr = eval("document.myForm.Desc"+index).value;
			else
			descriptionStr = descriptionStr+"¥"+eval("document.myForm.Desc"+index).value;
			
			if(attachFileTimeStr=="")
			attachFileTimeStr = eval("document.myForm.AttachTime"+index).value;
			else
			attachFileTimeStr = attachFileTimeStr+"¥"+eval("document.myForm.AttachTime"+index).value;
			
		}
		
		if(eval("document.myForm.Attachment"+index)!=undefined)
		{
			if(eval("document.myForm.Attachment"+index).value  == "")
			{
				alert("Please  Attach file for "+eval("document.myForm.Desc"+index).value);
				return;
			}
			
			
			if(attachFilesStr=="")
			attachFilesStr = eval("document.myForm.Attachment"+index).value;
			else
			attachFilesStr = attachFilesStr+"¥"+eval("document.myForm.Attachment"+index).value;
		}
	}
	//alert(":::::attachmentTypeStr::::"+attachmentTypeStr);

	window.parent.document.myForm.attachDocDesc.value  = descriptionStr;
	window.parent.document.myForm.attachDocFiles.value = attachFilesStr;
	window.parent.document.myForm.attachFileTime.value = attachFileTimeStr;
	window.parent.document.myForm.attachType.value = attachmentTypeStr;
	
	document.myForm.action="ezAttachDocs.jsp";
	document.myForm.submit();
	
}
function funChange(index)
{
	document.myForm.currIndex.value=index;
	//eval("document.myForm.path"+index).value=eval("document.myForm.AttachmentFile"+index).value;
	
	
	var attachFile =eval("document.myForm.AttachmentFile"+index).value;
	var tempAttachFile="";
	var lastindex = attachFile.lastIndexOf("\\");

	if(lastindex>=0)
	{
		tempAttachFile = attachFile.substring(lastindex+1,attachFile.length);
	}
	
	tempAttachFile=tempAttachFile.replace("'","`");
	tempAttachFile=tempAttachFile.replace("&","AND");
	tempAttachFile=tempAttachFile.replace(",","");
	tempAttachFile=tempAttachFile.replace("%","PER");
	
	
	eval("document.myForm.path"+index).value=tempAttachFile;
	eval("document.myForm.Attachment"+index).value=tempAttachFile;


	var d = new Date();
	var n = d.getTime();
	
	eval("document.myForm.AttachTime"+index).value=n;
	
	var filePath	= eval("document.myForm.Attachment"+index).value;
	var dotPosition= filePath.lastIndexOf('.');
	var fileExtension=filePath.substring(dotPosition+1,filePath.length);
	//alert(fileExtension);
	if(!((fileExtension=="xls")||(fileExtension=="xlsx")||(fileExtension=="jpeg")||(fileExtension=="jpg")||(fileExtension=="png") ||(fileExtension=="pdf")))
	{
	alert("Please attach files of type .xls,.xlsx and .pdf only");
	eval("document.myForm.Attachment"+index).value="";
	return;
	}
	
	document.getElementById("loadingMsg").style.display="block";
	document.getElementById("UploadDiv").style.display="none";
	document.getElementById("UploadDiv1").style.display="none";
	document.myForm.action="ezUploadFile1.jsp";
	document.myForm.submit();
	
	

}
function funBlur(index)
{
	var enteredDesc = eval("document.myForm.Desc"+index).value;
	
	var indexLen = document.myForm.index.length;
	if(isNaN(indexLen))indexLen=1;
	
	var cnt=0;

	for(j=0;j<indexLen;j++)
	{
	
		if(isNaN(document.myForm.index.length))
		index = document.myForm.index.value
		else
		index = document.myForm.index[j].value	

		descStr = eval("document.myForm.Desc"+index).value;
		
		
		if(enteredDesc!="" && enteredDesc==descStr)
		{
			cnt =cnt+1;
		}
		
		if(cnt>1)
		{
			alert("Description should be unique");
			eval("document.myForm.Desc"+index).value="";
			return;
			break;
		}
	}
	
	


}
function openUploadDoc(index)
{

	document.myForm.action="../Invoice/ezFileDownload.jsp?AttachTime="+eval("document.myForm.AttachTime"+index).value+"&fileName="+eval("document.myForm.Attachment"+index).value;
	document.myForm.submit();
}
</script>
<style>
th{
background-color: '#f39c12 !important'
}
</style>
</head>
<body >
<Form name="myForm" ENCTYPE="multipart/form-data" method="POST" >
<input type="hidden" name="currIndex" value="" />
<input type="hidden" name="bankACCode" value="<%=bankACCode%>" />

<div class="container" >
<br />
<div class="row" id="UploadDiv">
	<div class="span10 offset1">
		<table class="table table-hover table-condensed table-bordered display" id="dataTab" >
			<thead>
				<tr>
					<th style="text-align:center;background-color: #f39c12 !important">Attachment Type</th>
					<!--<th style="text-align:center;background-color: #f39c12 !important">Description</th>-->
					<th style="text-align:center;background-color: #f39c12 !important">Attachment</th>
					<!--<th style="background-color: #f39c12 !important"><a href='Javascript:funAddRow("dataTab")'><font color="white">[+]</font></a>&nbsp;</th>-->
					<th style="text-align:center;background-color: #f39c12 !important">&nbsp;</th>
				</tr>
			</thead>
			<tbody>
<%
Hashtable attachFilesHT = null;
	
if(session.getValue("ATTACHEDFILES")!=null)
attachFilesHT = (Hashtable)session.getValue("ATTACHEDFILES");
//out.println(attachFilesHT);

if(attachFilesHT!=null && attachFilesHT.size()>0)
{
	Enumeration enumeration = attachFilesHT.keys();
	int i=0;
	
	Vector v = new Vector(attachFilesHT.keySet());
	Collections.sort(v);
	Iterator it = v.iterator();
	while (it.hasNext()) 
	{ 
			
   		String attachFilekey=(String)it.next();//(String) enumeration.nextElement();
		   		
		   String attachFileValue = (String)attachFilesHT.get(attachFilekey);//(String)attachFilesHT.get(attachFilekey);
   		String fileTime="",fileName="",attachedFileDesc="",attachmentTypeStr="";
   		
   		if(attachFileValue.indexOf("_")>=0)
		{
   			fileTime = attachFileValue.substring(0,attachFileValue.indexOf("_"));
   			String nameWithDesc = attachFileValue.substring(attachFileValue.indexOf("_")+1,attachFileValue.length());
			//out.println(nameWithDesc);
			try{
			fileName = nameWithDesc.split("¥")[0];
			}catch(Exception e){}
			try{
			attachedFileDesc = nameWithDesc.split("¥")[1];
			}catch(Exception e){}
			try{
			attachmentTypeStr = nameWithDesc.split("¥")[2];
			}catch(Exception e){}
		}else
   		attachedFileDesc=attachFileValue;
   		
   		if("".equals(attachedFileDesc))attachedFileDesc="NA";
%>   		
   		
		<tr>
			<td><input type="hidden" name="index" value="<%=i%>" />
				<select name="attachmentType<%=i%>" id="attachmentType<%=i%>">
				<%
				for(int j=0;j<bankACCodeArrLen;j++)
				{
					String selected="";
					
					String key = bankACCodeArr[j];
					String value = bankACCodeArr[j];
					try{
					key = bankACCodeArr[j].split("-")[0] ;
					}catch(Exception e){}
					try{
					value="("+bankACCodeArr[j].split("-")[1]+")";
					}catch(Exception e){value="";
					
					}
					
					if("-".equals(key.trim()))continue;
					if(attachmentTypeStr.equals(key))selected="selected";
					
					
				%>
				<option value="<%=key%>" <%=selected%>><%=key%><%=value%></option>
				<%
				}
				%>

				</select>
			</td>
			<!--<td ><input type="text" name="Desc<%=i%>" value="<%=attachedFileDesc%>" onBlur="funBlur('<%=i%>')" />
			</td>-->
			<td style="width:50%">
			<input type="hidden" name="Desc<%=i%>" value="<%=attachedFileDesc%>"  />
			<input type="hidden" name="path<%=i%>" value="<%=fileName%>" /><input type="hidden" name="AttachTime<%=i%>" value="<%=fileTime%>" />
				<div class="fileUpload btn btn-info">
				    <span>Upload</span>
				   <input type="file" name="AttachmentFile<%=i%>" value="" size="" onChange="funChange(<%=attachFilekey%>)" class="upload" />
				</div>
				<a href="javascript:openUploadDoc('<%=i%>')"><input type="text" name="Attachment<%=i%>" placeholder="Choose File" disabled="disabled"  value="<%=fileName%>"  style="width:250px;float:right;margin-left:-90px;"/></a>
															
			</td>
			
			<td ><a href="Javascript:deleteRow(<%=i%>)" style="background-color:white"><i class="fa fa-trash-o fa-lg"></i></a></td>

		</tr>   
<%		
		i = i+1;
   		 
	}
}else{
%>

			
				<tr>
					<td><input type="hidden" name="index" value="0" />
						<select name="attachmentType0" id="attachmentType0">
						<%
						for(int j=0;j<bankACCodeArrLen;j++)
						{
							String selected="";
												
							String key = bankACCodeArr[j];
							String value = bankACCodeArr[j];
							out.println(bankACCodeArr[j]);
							try{
							key = bankACCodeArr[j].split("-")[0] ;
							}catch(Exception e){}
							try{
							value="("+bankACCodeArr[j].split("-")[1]+")";
							}catch(Exception e){value="";
							
							}
								if("-".equals(key.trim()))continue;				
												
					%>
							<option value="<%=key%>" <%=selected%>><%=key%><%=value%></option>
						<%
						}
						%>

						</select>
					</td>
					<!--<td ><input type="text" name="Desc0" value="" onBlur="funBlur('0')" />
					</td>-->
					
					<td style="width:50%">
					<input type="hidden" name="Desc0" value="NA"  />
					<input type="hidden" name="path0" value="" /><input type="hidden" name="AttachTime0" value="" />
					<div class="fileUpload btn btn-info">
					    <span>Upload</span>
					   <input type="file" name="AttachmentFile0" value=""  onChange="funChange(0)" class="upload" />
					</div>
					<a href="javascript:openUploadDoc('0')"><input type="text" name="Attachment0" placeholder="Choose File" disabled="disabled"  style="width:250px;float:right;margin-left:-90px;"/></a>
														
										
					</td>
					
					<td ><a href="Javascript:deleteRow(0)" style="background-color:white"><i class="fa fa-trash-o fa-lg"></i></a></td>
					
				</tr>
<%
}
%>				
			</tbody>
		</table>
	</div>
</div>
<div class="row">

	<center><div class="span3 offset5" id="UploadDiv1">
		<a href="javascript:funAttach()" class="btn btn-info" >Done</a>
		<a href="Javascript:funAddRow('dataTab')" class="btn btn-info" >Add More Lines</a>
		<a href="javascript:parent.$.fancybox.close();" class="btn btn-info" >Cancel</a>
		
	</div></center>
	
	<div class="span12" id="loadingMsg" style="display:none;">
	<br /><br /><br /><br />
		<h3>Please wait... While the document is being uploaded</h3>	
	</div>
</div>

</div>

</form>

</body>
</html>

