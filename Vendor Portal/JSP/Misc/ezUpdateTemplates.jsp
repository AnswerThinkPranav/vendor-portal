<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>
<%@ include file="../Misc/ezCommonMethods.jsp"%>
<%@ include file="../Misc/ezHeader.jsp"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ page import="java.util.*,java.nio.file.*,java.io.*,ezc.ezutil.*,ezc.ezpreprocurement.params.*,ezc.ezparam.*,java.math.*" %>
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" scope="page"/>
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>

<%
	String compCode = request.getParameter("compCode");
	String plant = request.getParameter("plant");
	String category = request.getParameter("category");
	String docType = request.getParameter("docType");
	String template = request.getParameter("template");

	EzcParams mainParams = new EzcParams(false);
	EziMiscParams miscParams = new EziMiscParams();

	int retObjWFTempCnt = 0;
	ReturnObjFromRetrieve retObjWFTemp = null;

	String selQuery = "SELECT EWPC_LEVEL,EWPC_ROLE,EWPC_GROUP,EWPC_QCF_FLAG,EWPC_QCF_RELEASE FROM EZC_WF_PRICING_CONDITIONS WHERE EWPC_TEMPLATE='"+ template +"' ORDER BY EWPC_LEVEL";
	miscParams.setQuery(selQuery);
	ezc.ezcommon.EzLog4j.log("ezUpdateWorkflows.jsp selQuery:::::::::::::::::::::::::::::" + selQuery,"I");
	mainParams.setLocalStore("Y");
	mainParams.setObject(miscParams);
	Session.prepareParams(mainParams);
	try {
		retObjWFTemp = (ReturnObjFromRetrieve) ezMiscManager.ezSelect(mainParams);
	}catch(Exception e){
	}

	if (retObjWFTemp != null)
		retObjWFTempCnt = retObjWFTemp.getRowCount();
%>

<html>
<head>
	<script src="../../Library/JavaScript/ezTrim.js"></script>
	<link rel="stylesheet" href="../../../../EzCommon/Library/plugins/select2/select2.min.css">
	<link rel="stylesheet" href="../../../../EzCommon/Library/plugins/pace/pacetopline.css">
	<link rel="stylesheet" href="../../../../EzCommon/Library/plugins/jQueryUI/jquery-ui.css">
	<style>
	th, td {
		padding: 6px;
		text-align: center;
	}
	table {
		border-collapse: collapse;
	}
	
	.editable-cell {
		padding: 0;
	}
	
	.editable-input {
		width: 100%;
		box-sizing: border-box;
		border: 1px solid #ccc;
		padding: 5px;
		background-color: #f5f5f5;
		text-align: center;
		height: 34px;
	}
	
	.actions-container {
		display: flex;
		justify-content: center;
		gap: 4px;
	}
	</style>
	<script type="text/javascript" src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>
	<script type="text/javascript">

	var originalValues = {};
	var totalRows = <%= retObjWFTempCnt %>;

	function editRow(rowKey) {
		var currentRow = document.getElementById("tr" + rowKey);
		if (!currentRow) {
			console.error("Row not found for key:", rowKey);
			return;
		}

		var isEditing = document.querySelector('.editing-row');
		if (isEditing) {
			alert("Please save or cancel changes on the current row before editing another.");
			return;
		}

		currentRow.classList.add('editing-row');
		
		var valueCell = currentRow.querySelector("td:nth-child(5)");
		var originalValue = valueCell.innerText.trim();
		originalValues[rowKey] = {
			value: originalValue
		};

		var valueInputHTML = '<input type="text" class="editable-input" id="valueInput' + rowKey + '" value="' + originalValue + '">';
		valueCell.innerHTML = valueInputHTML;
		valueCell.classList.add('editable-cell');
		
		var editButtonDiv = document.getElementById("edit" + rowKey);
		var saveButtonDiv = document.getElementById("save" + rowKey);
		
		if (editButtonDiv) {
			editButtonDiv.style.display = 'none'; 
		}
		if (saveButtonDiv) {
			saveButtonDiv.style.display = 'flex'; 
		}
	}
	
	function validateAndSaveRow(rowKey) {
		var currentRow = document.getElementById("tr" + rowKey);
		var newValue = parseFloat(document.getElementById("valueInput" + rowKey).value.trim());

		if (isNaN(newValue)) {
			alert("Please enter a valid numeric value.");
			document.getElementById("valueInput" + rowKey).focus();
			return;
		}
		
		var isFirstRow = (parseInt(rowKey) === 0);
		var isLastRow = (parseInt(rowKey) === totalRows - 1);
		
		var prevRow = document.getElementById("tr" + (parseInt(rowKey) - 1));
		var nextRow = document.getElementById("tr" + (parseInt(rowKey) + 1));
		
		var prevValue = prevRow ? parseFloat(prevRow.querySelector("td:nth-child(5)").innerText.trim()) : -Infinity;
		var nextValue = nextRow ? parseFloat(nextRow.querySelector("td:nth-child(5)").innerText.trim()) : Infinity;
		alert("Inside save row");
		if (isFirstRow) {
		    if (nextRow && newValue >= nextValue) {
		        alert("For the first row, the value must be less than the next row's value (" + nextValue + ").");
		        document.getElementById("valueInput" + rowKey).focus();
		        return;
		    }
		} else if (isLastRow) {
		    if (prevRow && newValue <= prevValue) {
		        alert("For the last row, the value must be greater than the previous row's value (" + prevValue + ").");
		        document.getElementById("valueInput" + rowKey).focus();
		        return;
		    }
		} else { // In between rows
		    if (newValue <= prevValue || newValue >= nextValue) {
		        alert("The value must be between the previous row's value (" + prevValue + ") and the next row's value (" + nextValue + ").");
		        document.getElementById("valueInput" + rowKey).focus();
		        return;
		    }
		}

		saveRow(rowKey);
	}

	function saveRow(rowKey) {
		var currentRow = document.getElementById("tr" + rowKey);
		var level = currentRow.getAttribute("data-step");
		var template = "<%= template %>";
		var condition = currentRow.querySelector("td:nth-child(4)").innerText.trim();
		var newValue = document.getElementById("valueInput' + rowKey + '").value.trim();

		if (!confirm("Are you sure you want to update this workflow step?")) {
			return;
		}

		var xmlhttp = new XMLHttpRequest();
		xmlhttp.onreadystatechange = function () {
			if (xmlhttp.readyState === 4) {
				if (xmlhttp.status === 200) {
					var response = xmlhttp.responseText.trim();
					if (response === "SUCCESS") {
						alert("Template Saved successfully.");
						location.reload(); 
					} else {
						alert("Save failed: " + response);
						cancelEdit(rowKey, false); 
					}
				} else {
					alert("AJAX error while saving: " + xmlhttp.status);
					cancelEdit(rowKey, false); 
				}
			}
		};

		var url = "ezUpdateTemplateConditions.jsp?template=" + encodeURIComponent(template) + "&level=" + encodeURIComponent(level) + "&condition=" + encodeURIComponent(condition) + "&value=" + encodeURIComponent(newValue);
		
		xmlhttp.open("POST", url, true);
		xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
		xmlhttp.send();
	}

	function cancelEdit(rowKey, showConfirm = true) {
		if (showConfirm && !confirm("Are you sure you want to cancel? Your changes will be lost.")) {
			return;
		}
		
		var currentRow = document.getElementById("tr" + rowKey);
		if (!currentRow) return;

		var original = originalValues[rowKey];
		if (!original) return;
		
		var valueCell = currentRow.querySelector("td:nth-child(5)");
		
		valueCell.innerHTML = original.value;
		
		valueCell.classList.remove('editable-cell');

		var editButtonDiv = document.getElementById("edit" + rowKey);
		var saveButtonDiv = document.getElementById("save" + rowKey);
		
		if (editButtonDiv) {
			editButtonDiv.style.display = 'block'; 
		}
		if (saveButtonDiv) {
			saveButtonDiv.style.display = 'none'; 
		}

		currentRow.classList.remove('editing-row');
		
		delete originalValues[rowKey];
		location.reload();
	}
	
	</script>
</head>

<body scroll="no" style="display:flex;flex-direction:column; min-height:100vh; margin:0;">
<div style="flex : 1;">
<form name="myForm" method="post">

<input type="hidden" name="oldParticipant" value="">
  <div class="content-wrapper">
    <section class="content-header">
      <h1>Workflow Template</h1>
    </section>

    <section class="content">
      <div class="row">
        <div class="col-md-12 col-xs-12">
          <div class="box box-primary">
	    
	    <br>
            <br>
            <table id="tabHead" width="50%" align="center" border="1" cellpadding="2" cellspacing="0">
              <tr><th>Company Code</th><td><%=compCode%></td><th>Doc Type</th><td><%=docType%></td></tr>
              <tr><th>Plant</th><td><%=plant%></td><th>Category</th><td><%=category%></td></tr>
              <tr><th>Template</th><td><%=template%></td></tr>
            </table>

            <br>
            <br>
            <br>
            <table id="workflowTable" width="95%" align="center" border="1" cellpadding="2" cellspacing="0">
              <thead>
                <tr style="background-color:#3c8dbc; color:white;">
                  <th>Step</th>
                  <th>Role</th>
                  <th>User Group</th>
                  <th>Condition</th>
                  <th>Value</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
              <%
                if (retObjWFTemp != null) {
                    for (int i = 0; i < retObjWFTempCnt; i++) {
                        String step = retObjWFTemp.getFieldValueString(i, "EWPC_LEVEL");
                        String role = retObjWFTemp.getFieldValueString(i, "EWPC_ROLE");
                        String group = retObjWFTemp.getFieldValueString(i, "EWPC_GROUP");
                        String condition = retObjWFTemp.getFieldValueString(i, "EWPC_QCF_FLAG");
                        String price = retObjWFTemp.getFieldValueString(i, "EWPC_QCF_RELEASE");
              %>
              <tr id="tr<%= i%>" data-step="<%= step %>">
                <td><%= step %></td>
                <td><%= role %></td>
                <td><%= group %></td>
                
                <td id="PriceCondId<%=i%>"><%= condition %></td>
                <td><%= price %></td>
                
                <td class="centerText">
                	<div id="edit<%=i%>" class="actions-container">
                  		&nbsp;<a href="javascript: editRow('<%=i%>')"><i class="fa fa-edit fa-lg"></i></a>
                  	</div>
                  	<div id="save<%=i%>" class="actions-container" style="display:none">
				&nbsp;<a href="javascript: validateAndSaveRow('<%=i%>')"><i class="fa fa-save fa-lg" style="color:green;"></i></a>
				&nbsp;<a href="javascript: cancelEdit('<%=i%>')"><i class="fa fa-times-circle fa-lg" style="color:red;"></i></a>
                  	</div>
                </td>
              </tr>
              <%
                    }
                }
              %>
              </tbody>
            </table>

          </div>
        </div>
      </div>
    </section>
  </div>
</form>
</div>
<%@ include file="../Misc/ezFooter.jsp"%>
</body>
</html>
<script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script> 
<script src="../../../../EzCommon/Library/plugins/jQueryUI/jquery-ui.min.js"></script>
<script src="../../../../EzCommon/Library/plugins/select2/select2.full.min.js"></script>

<script src="../../../../EzCommon/Library/bootstrap/js/bootstrap.min.js"></script>

<script src="../../../../EzCommon/Library/plugins/pace/pace.min.js"></script>
<script src="../../../../EzCommon/Library/jQuery-Validation/js/jquery.validationEngine.js" type="text/javascript" charset="utf-8"></script>
 <script src="../../../../EzCommon/Library/jQuery-Validation/js/jquery.validationEngine-en.js" type="text/javascript" charset="utf-8"></script>
<script src="../../../../EzCommon/Library/jquery-ui-1.10.4/js/jquery-ui-1.10.4.custom.js"></script>