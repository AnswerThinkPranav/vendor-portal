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

String selQuery = "SELECT *, (SELECT GROUP_CONCAT(B.EU_ID) FROM EZC_WF_WORKGROUP_USERS A, EZC_USERS B WHERE A.EWWU_USER = B.EU_ID AND A.EWWU_GROUP = EWPC_GROUP AND A.EWWU_USER IN (SELECT EUDKV_USER_ID FROM EZC_USER_DEF_KEY_VALUES WHERE EUDKV_KEY = 'CATEGORY' AND EUDKV_VALUE = '"+plant+"#"+category+"') GROUP BY A.EWWU_GROUP) AS USER_IDS, (SELECT GROUP_CONCAT(B.EU_FIRST_NAME) FROM EZC_WF_WORKGROUP_USERS A, EZC_USERS B WHERE A.EWWU_USER = B.EU_ID AND A.EWWU_GROUP = EWPC_GROUP AND A.EWWU_USER IN (SELECT EUDKV_USER_ID FROM EZC_USER_DEF_KEY_VALUES WHERE EUDKV_KEY = 'CATEGORY' AND EUDKV_VALUE = '"+plant+"#"+category+"') GROUP BY A.EWWU_GROUP) AS USER_NAMES FROM EZC_WF_PRICING_CONDITIONS WHERE EWPC_TEMPLATE IN (SELECT EWKM_TEMPLATE FROM EZC_WF_KEY_MAP WHERE EWKM_COMP_CODE = '"+compCode+"' AND EWKM_PLANT = '"+plant+"' AND EWKM_CATEGORY = '"+category+"' AND EWKM_DOC_TYPE = '"+docType+"') ORDER BY EWPC_LEVEL";
miscParams.setQuery(selQuery);
ezc.ezcommon.EzLog4j.log("ezUpdateWorkflows.jsp selQuery:::::::::::::::::::::::::::::" + selQuery,"I");
mainParams.setLocalStore("Y");
mainParams.setObject(miscParams);
Session.prepareParams(mainParams);
try {
    retObjWFTemp = (ReturnObjFromRetrieve) ezMiscManager.ezSelect(mainParams);
} catch(Exception e) {}

if (retObjWFTemp != null)
    retObjWFTempCnt = retObjWFTemp.getRowCount();
%>

<html>
<head>
  <script src="../../Library/JavaScript/ezTrim.js"></script>
  <!-- Select2 -->
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
    .new-rowww-highlight{
    	background-color: #e8f5e9;
    }
    
  </style>
  <script type="text/javascript" src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>
  <script type="text/javascript">

function addRow(rowKey) {
    var currentRow = document.getElementById("tr" + rowKey);
    if (!currentRow) {
        console.error("Row not found for key:", rowKey);
        return;
    }

    var step = currentRow.getAttribute("data-step");
    var condition = currentRow.querySelector("td:nth-child(4)").innerText.trim();
    var price = currentRow.querySelector("td:nth-child(5)").innerText.trim();
    var userId = document.getElementById("userId" + rowKey).value;
    var timestamp = new Date().getTime();
    var newRowId = step + "_" + timestamp;

    var newRow = document.createElement("tr");
    newRow.id = "tr" + newRowId;
    newRow.setAttribute("data-step", step);
    newRow.classList.add("new-rowww-highlight"); 

    newRow.innerHTML =
        '<td>' + step + '</td>' +
        '<td id="tdParticipant' + newRowId + '">' +
            '<input type="hidden" name="WFParticipant' + newRowId + '" id="WFParticipantHidden' + newRowId + '" value="">' +
        '</td>' +
        '<td><input type="text" name="WFParticipantName' + newRowId + '" id="WFParticipantName' + newRowId + '" readonly></td>' +
        '<td id="PriceCondId' + newRowId + '">' + condition + '</td>' +
        '<td>' + price + '</td>' +
        '<td class="centerText">' +
            '<div id="edit' + newRowId + '" style="display:none;">' +
                '&nbsp;<a href="javascript: editRow(\'' + newRowId + '\')"><i class="fa fa-edit fa-lg"></i></a>' +
                '&nbsp;<a href="javascript: deleteRow(\'' + newRowId + '\')"><i class="fa fa-trash-o fa-lg"></i></a>' +
                '&nbsp;<a href="javascript: addRow(\'' + newRowId + '\')"><i class="fa fa-plus-square-o fa-lg"></i></a>' +
            '</div>' +
            '<div id="save' + newRowId + '" style="display:flex; justify-content: center; gap: 4px;">' +
                '&nbsp;<a href="javascript: saveRow(\'' + newRowId + '\')"><i class="fa fa-save fa-lg"></i></a>' +
                '&nbsp;<a href="javascript: deleteRow(\'' + newRowId + '\')"><i class="fa fa-trash-o fa-lg"></i></a>' +
            '</div>' +
        '</td>';

    currentRow.parentNode.insertBefore(newRow, currentRow.nextSibling);

    var xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function () {
        if (xmlhttp.readyState === 4) {
            var td = document.getElementById("tdParticipant" + newRowId);
            if (xmlhttp.status === 200) {
                var response = xmlhttp.responseText.trim();
                if (response === "ERROR" || response === "") {
                    td.innerText = "Error loading users.";
                    return;
                }

                var users = response.split("|");
                var select = document.createElement("select");
                select.name = "WFParticipantSelect" + newRowId;
                select.id = "WFParticipantSelect" + newRowId;

                var defaultOption = document.createElement("option");
                defaultOption.value = "";
                defaultOption.text = "-- Select Participant --";
                select.appendChild(defaultOption);

                //prevent step duplication in dropdown
                var existingUsersInStep = [];
                var allRows = document.querySelectorAll("tr[data-step='" + step + "']");
                allRows.forEach(function (row) {
                    var idInput = row.querySelector("input[id^='userId']");
                    if (idInput) {
                        existingUsersInStep.push(idInput.value.trim());
                    }
                });

                users.forEach(function (entry) {
                    var match = entry.match(/^(.+?)\s+\[(.+)\]$/);
                    if (match) {
                        var uid = match[1];
                        var uname = match[2];

                        //  Skip if user is already assigned to this step
                        if (existingUsersInStep.includes(uid)) return;

                        var option = document.createElement("option");
                        option.value = uid;
                        option.text = entry;
                        option.setAttribute("data-name", uname);
                        select.appendChild(option);
                    }
                });

                select.className= "form-control select2";
                td.appendChild(select);
                $(select).select2();

                if (select.options.length > 1) {
                    select.selectedIndex = 1;
                    var selectedName = select.options[1].getAttribute("data-name");
                    document.getElementById("WFParticipantName" + newRowId).value = selectedName;
                    document.getElementById("WFParticipantHidden" + newRowId).value = select.value;
                }

                select.addEventListener("change", function () {
                    var selectedName = this.options[this.selectedIndex].getAttribute("data-name");
                    document.getElementById("WFParticipantName" + newRowId).value = selectedName;
                    document.getElementById("WFParticipantHidden" + newRowId).value = this.value;
                });
                

            } else {
                td.innerText = "AJAX error loading users.";
            }
        }
    };

    if (userId) {
        xmlhttp.open("GET", "ezGetUsersByRole.jsp?userId=" + encodeURIComponent(userId), true);
        xmlhttp.send();
    } else {
        document.getElementById("tdParticipant" + newRowId).innerText = "No userId found.";
    }
}

function deleteRow(index) {
    var userId = document.getElementById("WFParticipantHidden" + index)?.value 
              || document.getElementById("userId" + index)?.value 
              || "";
    var plant = "<%= plant %>";
    var category = "<%= category %>";

    if (!userId) {
        alert("Unable to determine user ID for deletion.");
        return;
    }

    var row = document.getElementById("tr" + index);
    if (!row) {
        alert("Row not found for deletion.");
        return;
    }

    //Check if only one user is at the step
    var step = row.getAttribute("data-step");
    var allRows = document.querySelectorAll("tr[data-step='" + step + "']");
    if (allRows.length <= 1) {
        alert("At least one user is required at each level.");
        return;
    }

    var confirmDelete = confirm("Are you sure to remove this user from the workflow?");
    if (!confirmDelete) return;

    var xmlhttp;
    if (window.XMLHttpRequest) {
        xmlhttp = new XMLHttpRequest();
    } else {
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }

    xmlhttp.onreadystatechange = function () {
        if (xmlhttp.readyState === 4) {
            if (xmlhttp.status === 200) {
                var response = xmlhttp.responseText.trim();
                if (response === "SUCCESS") {
                    alert("User removed successfully.");
                    location.reload();
                    if (row) row.remove();
                } else {
                    alert("Deletion failed: " + response);
                }
            } else {
                alert("AJAX error during deletion. Status: " + xmlhttp.status);
            }
        }
    };

    var url = "ezDeleteWorkflowUser.jsp?plant=" + encodeURIComponent(plant)
            + "&category=" + encodeURIComponent(category)
            + "&userId=" + encodeURIComponent(userId);

    xmlhttp.open("POST", url, true);
    xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xmlhttp.send();
}
function saveRow(index) {
    var userId = document.getElementById("WFParticipantHidden" + index)?.value || "";
    var plant = "<%= plant %>";
    var category = "<%= category %>";

    if (!userId) {
        alert("Please select a participant before saving.");
        return;
    }
    
    if(!confirm("Are you sure to add user to WF?")){
    	return;
    }

    var xmlhttp;
    if (window.XMLHttpRequest) {
        // Modern browsers
        xmlhttp = new XMLHttpRequest();
    } else {
        // Older IE
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }

    xmlhttp.onreadystatechange = function () {
        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
            var response = xmlhttp.responseText.trim();
            console.log("Save Response: " + response);
            if (response === "SUCCESS") {
                alert("Saved successfully.");
                location.reload();
                document.getElementById("edit" + index).style.display = "block";
                document.getElementById("save" + index).style.display = "none";
            } else {
                alert("Save failed: " + response);
            }
        } else if (xmlhttp.readyState == 4 && xmlhttp.status != 200) {
            alert("AJAX error while saving: " + xmlhttp.status);
        }
    };

    var url = "ezUpdateWorkflowCondition.jsp?plant=" + encodeURIComponent(plant)
            + "&category=" + encodeURIComponent(category)
            + "&userId=" + encodeURIComponent(userId);

    xmlhttp.open("POST", url, true);
    xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xmlhttp.send();
}
  </script>
</head>

<body scroll="no">
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

            <table id="tabHead" width="50%" align="center" border="1" cellpadding="2" cellspacing="0">
              <tr><th>Company Code</th><td><%=compCode%></td><th>Doc Type</th><td><%=docType%></td></tr>
              <tr><th>Plant</th><td><%=plant%></td><th>Category</th><td><%=category%></td></tr>
            </table>

            <br>
            <table id="workflowTable" width="95%" align="center" border="1" cellpadding="2" cellspacing="0">
              <thead>
                <tr style="background-color:#3c8dbc; color:white;">
                  <th>Step</th>
                  <th>Participant</th>
                  <th>Name</th>
                  <th>Price Condition</th>
                  <th>Price in Rs.</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
              <%
                int rowIndex = 0;
                String rowKey="";
                for (int i = 0; i < retObjWFTempCnt; i++) {
                    String step = retObjWFTemp.getFieldValueString(i, "EWPC_LEVEL");
                    String role = retObjWFTemp.getFieldValueString(i, "EWPC_ROLE");
                    String group = retObjWFTemp.getFieldValueString(i, "EWPC_GROUP");
                    String condition = retObjWFTemp.getFieldValueString(i, "EWPC_QCF_FLAG");
                    String price = retObjWFTemp.getFieldValueString(i, "EWPC_QCF_RELEASE");

                    String userIds = retObjWFTemp.getFieldValueString(i, "USER_IDS");
                    String userNames = retObjWFTemp.getFieldValueString(i, "USER_NAMES");

                    String[] userIdArr = userIds != null ? userIds.split(",") : new String[0];
                    String[] userNameArr = userIds != null ? userNames.split(",") : new String[0];

                    for (int j = 0; j < userIdArr.length; j++) {
                    rowKey = i + "_" + j;
              %>
              <tr id="tr<%= rowKey%>" data-step="<%= step %>">
                <td><%= step %></td>
                <td>
                <input type="hidden" id="userId<%= rowKey %>" value="<%= userIdArr[j].trim() %>" />
                <%= userIdArr[j].trim() %>
                </td>
                <td><input type="text" name="WFParticipantName<%= rowKey %>" value="<%= userNameArr[j].trim()%>" readonly></td>
                <td id="PriceCondId<%=rowKey%>"><%= condition %></td>
                <td><%= price %></td>
                <td class="centerText">
                	<div id="edit<%=rowKey%>">
                		&nbsp;
                  		<a href="javascript: addRow('<%=rowKey%>')"><i class="fa fa-plus-square-o fa-lg"></i></a>
                  		&nbsp;
                  		<a href="javascript: deleteRow('<%=rowKey%>','EDIT')"><i class="fa fa-trash-o fa-lg"></i></a>
                  	</div>
                  	<div id="save<%=rowKey%>" style="display:none">
				&nbsp;
				<a href="javascript: saveRow('<%=rowKey%>')"><i class="fa fa-save fa-lg"></i></a>
				&nbsp;
				<a href="javascript: deleteRow('<%=rowKey%>','EDIT')"><i class="fa fa-trash-o fa-lg"></i></a>

                  	</div>
                </td>
              </tr>
              <%
                      rowIndex++;
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
<%@ include file="../Misc/ezFooter.jsp"%>
</body>
</html>
<!-- jQuery 2.1.4 -->
    <script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script> 
    <script src="../../../../EzCommon/Library/plugins/jQueryUI/jquery-ui.min.js"></script>
    <script src="../../../../EzCommon/Library/plugins/select2/select2.full.min.js"></script>
     
    <!-- Bootstrap 3.3.5 -->
    <script src="../../../../EzCommon/Library/bootstrap/js/bootstrap.min.js"></script>
    <!-- AdminLTE App --> 
    <script src="../../../../EzCommon/Library/dist/js/app.min.js"></script>
	<script src="../../../../EzCommon/Library/dataTables/ZeroClipboard.js"></script>
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/jquery.dataTables.min.js"></script>
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/dataTables.bootstrap.min.js"></script>
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/dataTables.responsive.min.js"></script>
	<script type="text/javascript" language="javascript" src="../../../../EzCommon/Library/dataTables/dataTables.tableTools.js"></script>	
	<script src="../../../../EzCommon/Library/plugins/pace/pace.min.js"></script>
    <!-- Optionally, you can add Slimscroll and FastClick plugins.
         Both of these plugins are recommended to enhance the
         user experience. Slimscroll is required when using the
         fixed layout. -->  
         <script src="../../../../EzCommon/Library/jQuery-Validation/js/jquery.validationEngine.js" type="text/javascript" charset="utf-8"></script>
         <script src="../../../../EzCommon/Library/jQuery-Validation/js/jquery.validationEngine-en.js" type="text/javascript" charset="utf-8"></script>
	<script src="../../../../EzCommon/Library/jquery-ui-1.10.4/js/jquery-ui-1.10.4.custom.js"></script>
