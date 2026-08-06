<%--*************************************************************************************
       /* Copyright Notice ===================================================
	* This file contains proprietary information of The Hackett Group Ind Ltd.
	* Copying or reproduction without prior written approval is prohibited.
	* Copyright (c) 2005-2026 =====================================*/
		Author: System Generated
		Team:   EzcSuite
		Date:   01/04/2026
		Purpose: Delete RFQ Line Item and Renumber Remaining Items
**************************************************************************************--%>

<%@ page import="java.util.*,ezc.ezutil.*,ezc.ezpreprocurement.params.*,ezc.ezparam.*,ezc.ezcommon.*,ezc.misctransactions.params.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%
ezc.ezcommon.EzLog4j.log("===== BEG Line Item Deletion =====", "I");
	ezc.misctransactions.client.EzMiscTransactionsManager quoteMgr = new ezc.misctransactions.client.EzMiscTransactionsManager();
	ezc.ezpreprocurement.client.EzPreProcurementManager rfqMgr = new ezc.ezpreprocurement.client.EzPreProcurementManager();
	
	EzcParams ezcparams = new ezc.ezparam.EzcParams(false);
	EzMiscTable quoteTable = null;
	EzMiscTableRow quoteTableRow = null;
	EziAuditTrailTable auditTable = new EziAuditTrailTable();
	EziAuditTrailTableRow auditRow = null;
	
	String purchOrg = (String)Session.getUserPreference("PURORG");
	String purGrp = (String)Session.getUserPreference("PURGROUP");
	
	String finalRetMsg = "";
	String qcfNo = request.getParameter("qcfNo");
	String lineNo = request.getParameter("lineNo");
	String action = request.getParameter("action");
	
	ezc.ezparam.ReturnObjFromRetrieve retrieveObj = null;
	
	// Process deletion
	if("remove".equals(action) && qcfNo != null && lineNo != null && 
	   !qcfNo.trim().isEmpty() && !lineNo.trim().isEmpty()) {
		
		ezc.ezcommon.EzLog4j.log("===== Start Line Item Deletion =====", "I");
		ezc.ezcommon.EzLog4j.log("QCF: " + qcfNo + ", Line: " + lineNo + ", User: " + Session.getUserId(), "I");
		
		try {
			// Step 1: Get all line items
			String qryGetLines = "SELECT DISTINCT ERD_LINE_NO FROM EZC_RFQ_DETAILS " +
								"WHERE ERD_RFQ_NO IN (SELECT ERH_RFQ_NO FROM EZC_RFQ_HEADER " +
								"WHERE ERH_COLLETIVE_RFQ_NO='" + qcfNo + "') " +
								"ORDER BY CAST(ERD_LINE_NO AS UNSIGNED)";
			
			ezc.ezcommon.EzLog4j.log("Fetching line items", "I");
			
			ezcparams = new EzcParams(false);
			quoteTable = new EzMiscTable();
			quoteTableRow = new EzMiscTableRow();
			quoteTableRow.setQuery(qryGetLines);
			quoteTable.appendRow(quoteTableRow);
			ezcparams.setLocalStore("Y");
			ezcparams.setObject(quoteTable);
			Session.prepareParams(ezcparams);
			
			retrieveObj = (ezc.ezparam.ReturnObjFromRetrieve)quoteMgr.ezGetMiscTransactions(ezcparams);
			
			java.util.Vector<String> lineVector = new java.util.Vector<String>();
			for(int i = 0; i < retrieveObj.getRowCount(); i++) {
				lineVector.addElement(retrieveObj.getFieldValueString(i, "ERD_LINE_NO"));
			}
			
			ezc.ezcommon.EzLog4j.log("Total line items: " + lineVector.size(), "I");
			
			// Validate line exists
			if(!lineVector.contains(lineNo)) {
				throw new Exception("Line item " + lineNo + " not found in QCF " + qcfNo);
			}
			
			// Step 2: Get RFQ numbers
			String qryGetRfqNos = "SELECT ERH_RFQ_NO FROM EZC_RFQ_HEADER WHERE ERH_COLLETIVE_RFQ_NO='" + qcfNo + "'";
			ezc.ezcommon.EzLog4j.log("Fetching RFQ numbers", "I");
			
			ezcparams = new EzcParams(false);
			quoteTable = new EzMiscTable();
			quoteTableRow = new EzMiscTableRow();
			quoteTableRow.setQuery(qryGetRfqNos);
			quoteTable.appendRow(quoteTableRow);
			ezcparams.setLocalStore("Y");
			ezcparams.setObject(quoteTable);
			Session.prepareParams(ezcparams);
			
			retrieveObj = (ezc.ezparam.ReturnObjFromRetrieve)quoteMgr.ezGetMiscTransactions(ezcparams);
			
			if(retrieveObj.getRowCount() == 0) {
				throw new Exception("No RFQ records found for QCF: " + qcfNo);
			}
			
			java.util.Vector<String> rfqVector = new java.util.Vector<String>();
			for(int i = 0; i < retrieveObj.getRowCount(); i++) {
				rfqVector.addElement(retrieveObj.getFieldValueString(i, "ERH_RFQ_NO"));
			}
			
			StringBuilder rfqNoList = new StringBuilder();
			for(int i = 0; i < rfqVector.size(); i++) {
				if(i > 0) rfqNoList.append(",");
				rfqNoList.append("'").append(rfqVector.get(i)).append("'");
			}
			String rfqNos = rfqNoList.toString();
			ezc.ezcommon.EzLog4j.log("RFQ Numbers: " + rfqNos, "I");
			
			// Step 3: Delete from all tables
			ezc.ezcommon.EzLog4j.log("===== Starting Deletion =====", "I");
			
			boolean deletionSuccess = false;
			
			// Delete from EZC_RFQ_DETAILS (main table - critical)
			try {
				String qryDelete1 = "DELETE FROM EZC_RFQ_DETAILS WHERE ERD_RFQ_NO IN (" + rfqNos + ") AND ERD_LINE_NO='" + lineNo + "'";
				ezc.ezcommon.EzLog4j.log("Executing: " + qryDelete1, "I");
				
				ezcparams = new EzcParams(false);
				quoteTable = new EzMiscTable();
				quoteTableRow = new EzMiscTableRow();
				quoteTableRow.setQuery(qryDelete1);
				quoteTable.appendRow(quoteTableRow);
				ezcparams.setLocalStore("Y");
				ezcparams.setObject(quoteTable);
				Session.prepareParams(ezcparams);
				quoteMgr.ezSaveMiscTransactions(ezcparams);
				
				deletionSuccess = true;
				ezc.ezcommon.EzLog4j.log("[SUCCESS] Deleted from EZC_RFQ_DETAILS", "I");
			} catch(Exception e1) {
				if(e1.getMessage() != null && e1.getMessage().contains("0 >= 0")) {
					throw new Exception("Failed to delete line item - possible constraint violation");
				}
				throw new Exception("Cannot delete line item: " + e1.getMessage());
			}
			
			// Delete from optional tables
			String[] optionalTables = {
				"DELETE FROM EZC_RFQ_ITEM_CONDITIONS WHERE ERIC_RFQ_NO IN (" + rfqNos + ") AND ERIC_LINE_NO='" + lineNo + "'",
				"DELETE FROM EZC_RFQ_QUOTE_HISTORY WHERE ERQH_RFQ_NO IN (" + rfqNos + ") AND ERQH_LINE_NO='" + lineNo + "'",
				"DELETE FROM EZC_RFQ_PRS WHERE ERP_QCF_NO='" + qcfNo + "' AND ERP_RFQ_LINE_NO='" + lineNo + "'"
			};
			
			String[] tableNames = {"EZC_RFQ_ITEM_CONDITIONS", "EZC_RFQ_QUOTE_HISTORY", "EZC_RFQ_PRS"};
			
			for(int t = 0; t < optionalTables.length; t++) {
				try {
					ezcparams = new EzcParams(false);
					quoteTable = new EzMiscTable();
					quoteTableRow = new EzMiscTableRow();
					quoteTableRow.setQuery(optionalTables[t]);
					quoteTable.appendRow(quoteTableRow);
					ezcparams.setLocalStore("Y");
					ezcparams.setObject(quoteTable);
					Session.prepareParams(ezcparams);
					quoteMgr.ezSaveMiscTransactions(ezcparams);
					ezc.ezcommon.EzLog4j.log("[SUCCESS] Deleted from " + tableNames[t], "I");
				} catch(Exception e) {
					if(e.getMessage() != null && e.getMessage().contains("0 >= 0")) {
						ezc.ezcommon.EzLog4j.log("[INFO] No records in " + tableNames[t], "I");
					} else {
						ezc.ezcommon.EzLog4j.log("[WARNING] Error deleting from " + tableNames[t] + ": " + e.getMessage(), "W");
					}
				}
			}
			
			// Step 4: Renumber remaining lines
			ezc.ezcommon.EzLog4j.log("===== Starting Renumbering =====", "I");
			
			int deletedLineNum = Integer.parseInt(lineNo);
			int linesRenumbered = 0;
			
			for(int i = 0; i < lineVector.size(); i++) {
				String currentLine = lineVector.get(i);
				int currentLineNum = Integer.parseInt(currentLine);
				
				if(currentLineNum > deletedLineNum) {
					String newLineNo = String.valueOf(currentLineNum - 10);
					ezc.ezcommon.EzLog4j.log("Renumbering line " + currentLine + " to " + newLineNo, "I");
					
					boolean renumbered = false;
					
					// Update EZC_RFQ_DETAILS (main table)
					try {
						String qryUpdate = "UPDATE EZC_RFQ_DETAILS SET ERD_LINE_NO='" + newLineNo + "' " +
										  "WHERE ERD_RFQ_NO IN (" + rfqNos + ") AND ERD_LINE_NO='" + currentLine + "'";
						
						ezcparams = new EzcParams(false);
						quoteTable = new EzMiscTable();
						quoteTableRow = new EzMiscTableRow();
						quoteTableRow.setQuery(qryUpdate);
						quoteTable.appendRow(quoteTableRow);
						ezcparams.setLocalStore("Y");
						ezcparams.setObject(quoteTable);
						Session.prepareParams(ezcparams);
						quoteMgr.ezSaveMiscTransactions(ezcparams);
						
						renumbered = true;
						ezc.ezcommon.EzLog4j.log("[SUCCESS] Renumbered EZC_RFQ_DETAILS", "I");
					} catch(Exception e) {
						if(e.getMessage() == null || !e.getMessage().contains("0 >= 0")) {
							ezc.ezcommon.EzLog4j.log("[ERROR] Failed to renumber line " + currentLine, "E");
						}
						continue;
					}
					
					// Update optional tables
					String[] updateQueries = {
						"UPDATE EZC_RFQ_ITEM_CONDITIONS SET ERIC_LINE_NO='" + newLineNo + "' WHERE ERIC_RFQ_NO IN (" + rfqNos + ") AND ERIC_LINE_NO='" + currentLine + "'",
						"UPDATE EZC_RFQ_QUOTE_HISTORY SET ERQH_LINE_NO='" + newLineNo + "' WHERE ERQH_RFQ_NO IN (" + rfqNos + ") AND ERQH_LINE_NO='" + currentLine + "'",
						"UPDATE EZC_RFQ_PRS SET ERP_RFQ_LINE_NO='" + newLineNo + "' WHERE ERP_QCF_NO='" + qcfNo + "' AND ERP_RFQ_LINE_NO='" + currentLine + "'"
					};
					
					for(int u = 0; u < updateQueries.length; u++) {
						try {
							ezcparams = new EzcParams(false);
							quoteTable = new EzMiscTable();
							quoteTableRow = new EzMiscTableRow();
							quoteTableRow.setQuery(updateQueries[u]);
							quoteTable.appendRow(quoteTableRow);
							ezcparams.setLocalStore("Y");
							ezcparams.setObject(quoteTable);
							Session.prepareParams(ezcparams);
							quoteMgr.ezSaveMiscTransactions(ezcparams);
						} catch(Exception e) {
							// Ignore "0 >= 0" errors for optional tables
						}
					}
					
					if(renumbered) {
						linesRenumbered++;
					}
				}
			}
			
			ezc.ezcommon.EzLog4j.log("Total lines renumbered: " + linesRenumbered, "I");
			
			// Step 5: Add Audit Trail
			try {
				auditRow = new EziAuditTrailTableRow();
				auditRow.setDocId(qcfNo);
				auditRow.setDocType("AN");
				auditRow.setDocCategory("D");
				auditRow.setUserName(Session.getUserId());
				auditRow.setFMName("LINE_ITEM_DELETE");
				auditRow.setIPAddress(request.getRemoteAddr());
				auditRow.setPurOrg(purchOrg);
				auditRow.setPurGrp(purGrp);
				auditRow.setComments("Line item " + lineNo + " deleted. " + linesRenumbered + " items renumbered.");
				auditRow.setChangeInd("D");
				auditTable.appendRow(auditRow);
				
				ezcparams = new EzcParams(false);
				ezcparams.setObject(auditTable);
				Session.prepareParams(ezcparams);
				rfqMgr.ezAddAuditTrail(ezcparams);
				
				ezc.ezcommon.EzLog4j.log("Audit trail created", "I");
			} catch(Exception eAudit) {
				ezc.ezcommon.EzLog4j.log("Audit trail creation failed: " + eAudit.getMessage(), "W");
			}
			
			finalRetMsg = "Line Item " + lineNo + " Deleted Successfully from QCF " + qcfNo + ". " + 
						 linesRenumbered + " line item(s) renumbered.";
			
			ezc.ezcommon.EzLog4j.log("===== Deletion Completed Successfully =====", "I");
			
		} catch(Exception e) {
			finalRetMsg = "Error in Line Item Deletion: " + e.getMessage();
			ezc.ezcommon.EzLog4j.log("===== Deletion Failed =====", "E");
			ezc.ezcommon.EzLog4j.log("Error: " + e.getMessage(), "E");
			e.printStackTrace();
		}
	}
%>
<html>
<head>
<script>
	function goToList() {
		var qcfVal = document.myForm.qcfNo.value;
		document.myForm.action = "iQuoteRFQDetails.jsp?qcfNo=" + qcfVal + "&type=FromQuote";
		document.myForm.submit();
	}
	
	function confirmDelete() {
		var lineNo = document.getElementById("lineNo").value;
		var qcfNo = document.myForm.qcfNo.value;
		
		if(!lineNo || !qcfNo) {
			alert('Please enter both QCF Number and Line Number');
			return false;
		}
		
		var confirmMsg = 'Are you sure you want to delete Line Item ' + lineNo + ' from QCF ' + qcfNo + '?\n\n';
		confirmMsg += 'This will:\n';
		confirmMsg += '1. Delete the line item from all tables\n';
		confirmMsg += '2. Renumber remaining line items automatically';
		
		return confirm(confirmMsg);
	}
</script>


<style>
	body {
		font-family: Arial, sans-serif;
		background-color: #FFFFF7;
	}
	.message-container {
		width: 70%;
		margin: 20px auto;
		padding: 15px;
		border-radius: 5px;
		text-align: center;
		font-weight: bold;
	}
	.success {
		background-color: #d4edda;
		color: #155724;
		border: 1px solid #c3e6cb;
	}
	.error {
		background-color: #f8d7da;
		color: #721c24;
		border: 1px solid #f5c6cb;
	}
	.form-container {
		width: 60%;
		margin: 30px auto;
		padding: 30px;
		background: white;
		border-radius: 8px;
		box-shadow: 0 2px 10px rgba(0,0,0,0.1);
	}
	table.form-table {
		width: 100%;
		border-collapse: collapse;
	}
	table.form-table td {
		padding: 12px;
	}
	label {
		font-weight: bold;
		color: #333;
	}
	input[type="text"] {
		width: 100%;
		padding: 8px;
		border: 1px solid #ddd;
		border-radius: 4px;
		font-size: 14px;
	}
	.warning-box {
		background-color: #fff3cd;
		color: #856404;
		padding: 15px;
		border-radius: 4px;
		border: 1px solid #ffeaa7;
		margin-top: 20px;
	}
</style>
</head>
<body bgcolor="#FFFFF7">
<form name="myForm" method="post" action="deleteLineItem.jsp">
<input type="hidden" name="action" value="remove">
<%
	String display_header = "";
%>

<br><br>

<% if(finalRetMsg != null && !finalRetMsg.isEmpty()) { %>
	<div class="message-container <%= finalRetMsg.startsWith("Error") ? "error" : "success" %>">
		<%= finalRetMsg %>
	</div>
	<br>
	<center>
	<%
		butNames.add("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ok&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
		butActions.add("goToList()");
		out.println(getButtons(butNames,butActions));
	%>
	</center>
<% } else { %>
	<div class="form-container">
		<h2 style="text-align: center; color: #333;">Delete RFQ Line Item</h2>
		<br>
		<table class="form-table">
			<tr>
				<td width="30%">
					<label for="qcfNo">QCF Number:</label>
				</td>
				<td>
					<input type="text" id="qcfNo" name="qcfNo" value="<%= qcfNo != null ? qcfNo : "" %>" required>
				</td>
			</tr>
			<tr>
				<td>
					<label for="lineNo">Line Number to Delete:</label>
				</td>
				<td>
					<input type="text" id="lineNo" name="lineNo" value="" placeholder="e.g., 10" required>
				</td>
			</tr>
		</table>
		
		<div class="warning-box">
			<strong>⚠️ Warning:</strong> This action will permanently delete the line item from all related tables 
			and automatically renumber remaining items. This operation cannot be undone.
		</div>
		
		<br><br>
		<center>
		<%
			butNames.add("&nbsp;&nbsp;&nbsp;Delete Line Item&nbsp;&nbsp;&nbsp;");
			butActions.add("confirmDelete()");
			if(qcfNo != null && !qcfNo.isEmpty()) {
				butNames.add("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Cancel&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
				butActions.add("goToList()");
			}
			out.println(getButtons(butNames,butActions));
		%>
		</center>
	</div>
<% } %>

<Div id="MenuSol"></Div>
</form>
</body>
</html>
