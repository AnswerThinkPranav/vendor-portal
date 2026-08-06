<%@ page isELIgnored="true" %>
<%@ page language="java" import="java.util.*" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Update Vendor Details</title>
  <%--
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
  --%>
   <link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/bootstrap.min.css">
   <link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/datepicker.css">
  <link rel="stylesheet" type="text/css" href="../../../../../EzCommon/Library/dataTables/dataTables.bootstrap.min.css">
  <link rel="stylesheet" type="text/css" href="../../../../../EzCommon/Library/dataTables/dataTables.responsive.min.css">
  <link rel="stylesheet" type="text/css" href="../../../../../EzCommon/Library/dataTables/dataTables.tableTools.css">
  <link rel="stylesheet" type="text/css" href="../../../../../EzCommon/Library/jQuery-Validation/css/validationEngine.jquery.css">
  <!-- Select2 for searchable dropdowns -->
  <link rel="stylesheet" href="../../../../EzCommon/Library/plugins/select2/select2.min.css">
  <style>
    body {
      font-family: -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif,"Apple Color Emoji","Segoe UI Emoji","Segoe UI Symbol";
      background: #ecf0f5;
      margin: 0;
      padding: 0;
    }

    .content-wrapper {
      background: #ecf0f5;
      padding: 15px;
      min-height: 100vh;
    }

    .content-header {
      padding: 15px 0.5rem;
      margin-bottom: 20px;
    }

    .content-header h1 {
      margin: 0;
      font-size: 24px;
      color: #333;
      font-weight: 400;
    }

    .box {
      background: #fff;
      border-top: 3px solid #d2d6de;
      margin-bottom: 10px;
      box-shadow: 0 1px 1px rgba(0,0,0,0.1);
    }

    .box.box-primary {
      border-top-color: #3c8dbc;
    }

    .box-header {
      color: #444;
      display: block;
      padding: 8px 10px;
      position: relative;
      border-bottom: 1px solid #f4f4f4;
    }

    .box-header.with-border {
      border-bottom: 1px solid #f4f4f4;
    }

    .box-title {
      display: inline-block;
      font-size: 16px;
      margin: 0;
      line-height: 1;
      font-weight: 400;
    }

    .box-body {
      padding: 10px;
    }

    .table {
      width: 100%;
      max-width: 100%;
      margin-bottom: 10px;
      background-color: transparent;
      border-collapse: collapse;
    }

    .table > thead > tr > th,
    .table > tbody > tr > th,
    .table > thead > tr > td,
    .table > tbody > tr > td {
      padding: 6px 8px;
      line-height: 1.42857143;
      vertical-align: top;
      border-top: 1px solid #ddd;
    }

    .table > thead > tr > th {
      vertical-align: bottom;
      border-bottom: 2px solid #ddd;
      font-weight: 600;
      background-color: #f9f9f9;
      text-align: left;
    }

    .table-bordered {
      border: 1px solid #ddd;
    }

    .table-bordered > thead > tr > th,
    .table-bordered > tbody > tr > th,
    .table-bordered > thead > tr > td,
    .table-bordered > tbody > tr > td {
      border: 1px solid #ddd;
    }

    th {
      font-family: -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif,"Apple Color Emoji","Segoe UI Emoji","Segoe UI Symbol";
      font-weight: 500;
      font-size: 13px;
      line-height: 1.6 !important;
      text-align: left;
    }

    td {
      font-family: -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif,"Apple Color Emoji","Segoe UI Emoji","Segoe UI Symbol";
      font-weight: 500;
      font-size: 13px;
      line-height: 1.4 !important;
    }

    .form-control {
      display: block;
      width: 100%;
      height: 34px;
      padding: 6px 12px;
      font-size: 14px;
      line-height: 1.42857143;
      color: #555;
      background-color: #fff;
      background-image: none;
      border: 1px solid #ccc;
      border-radius: 0px;
      box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
      transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
    }

    .form-control:focus {
      border-color: #66afe9;
      outline: 0;
      box-shadow: inset 0 1px 1px rgba(0,0,0,.075), 0 0 8px rgba(102,175,233,.6);
    }

    .btn {
      display: inline-block;
      padding: 6px 12px;
      margin-bottom: 0;
      font-size: 14px;
      font-weight: 400;
      line-height: 1.42857143;
      text-align: center;
      white-space: nowrap;
      vertical-align: middle;
      cursor: pointer;
      border: 1px solid transparent;
      border-radius: 0px;
      user-select: none;
    }

    .btn-primary {
      color: #fff;
      background-color: #3c8dbc;
      border-color: #367fa9;
    }

    .btn-primary:hover {
      background-color: #367fa9;
      border-color: #204d74;
    }

    .btn-success {
      color: #fff;
      background-color: #00a65a;
      border-color: #008d4c;
    }

    .btn-success:hover {
      background-color: #008d4c;
      border-color: #007a43;
    }

    .btn-danger {
      color: #fff;
      background-color: #dd4b39;
      border-color: #d73925;
    }

    .btn-sm {
      padding: 5px 10px;
      font-size: 12px;
      line-height: 1.5;
      border-radius: 0px;
    }

    .btn-outline-primary {
      color: #3c8dbc;
      background-color: transparent;
      border-color: #3c8dbc;
    }

    .btn-outline-primary:hover {
      color: #fff;
      background-color: #3c8dbc;
      border-color: #3c8dbc;
    }

    .alert {
      padding: 15px;
      margin-bottom: 20px;
      border: 1px solid transparent;
      border-radius: 0px;
    }

    .alert-success {
      color: #3c763d;
      background-color: #dff0d8;
      border-color: #d6e9c6;
    }

    .alert-danger,
    .alert-error {
      color: #a94442;
      background-color: #f2dede;
      border-color: #ebccd1;
    }

    .alert-info {
      color: #31708f;
      background-color: #d9edf7;
      border-color: #bce8f1;
    }

    .current-value-display {
      background-color: #fff3cd;
      padding: 8px 12px;
      border-radius: 0px;
      border: 1px solid #ffeeba;
      display: block;
      font-weight: 500;
    }

    .radio-option,
    .checkbox-option {
      display: block;
      margin-bottom: 8px;
      font-weight: normal;
    }

    .radio-option label,
    .checkbox-option label {
      font-weight: normal;
      cursor: pointer;
      margin-bottom: 0;
    }

    .radio-option input,
    .checkbox-option input {
      margin-right: 8px;
      margin-top: 4px;
    }

    .file-upload-area {
      border: 2px dashed #3c8dbc;
      padding: 15px;
      text-align: center;
      background: #f9f9f9;
      cursor: pointer;
      margin-top: 10px;
      position: relative;
      min-height: 50px;
    }

    .file-upload-area:hover {
      background: #f0f0f0;
      border-color: #367fa9;
    }

    #fileInput {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      opacity: 0;
      cursor: pointer;
      z-index: 1;
    }

    .attachment-item {
      padding: 10px;
      border: 1px solid #ddd;
      margin-bottom: 10px;
      background: #f9f9f9;
      overflow: hidden;
    }

    .attachment-item > div:first-child {
      float: left;
      width: 70%;
    }

    .attachment-item > div:last-child {
      float: right;
      text-align: right;
    }

    .attachment-item:after {
      content: "";
      display: table;
      clear: both;
    }

    .text-muted {
      color: #777;
    }

    hr {
      margin-top: 10px;
      margin-bottom: 10px;
      border: 0;
      border-top: 1px solid #eee;
    }

    h4 {
      margin-top: 10px;
      margin-bottom: 8px;
      font-size: 15px;
      font-weight: 500;
    }

    /* Select2 Styles - Fixed for proper appearance */
 /*  .select2-container--default .select2-selection--single {
      border: 1px solid #ccc;
      border-radius: 0px;
      height: 34px;
      background-color: #fff;
      padding: 6px 12px;
    }

    .select2-container {
      width: 100% !important;
      z-index: 999;
    }

    .select2-container--default .select2-selection--single .select2-selection__rendered {
      line-height: 20px;
      color: #555;
      padding-left: 0;
      padding-right: 0;
    }

    .select2-container--default .select2-selection--single .select2-selection__arrow {
      height: 32px;
      right: 1px;
      top: 1px;
    }

    .select2-container--default .select2-selection--single .select2-selection__arrow b {
      border-color: #888 transparent transparent transparent;
      border-style: solid;
      border-width: 5px 4px 0 4px;
      height: 0;
      left: 50%;
      margin-left: -4px;
      margin-top: -2px;
      position: absolute;
      top: 50%;
      width: 0;
    }

    .select2-dropdown {
      border: 1px solid #ccc;
      border-radius: 0px;
      background-color: #fff;
      z-index: 9999;
    }

    .select2-results {
      background-color: #fff;
    }

    .select2-results__option {
      padding: 6px 12px;
      background-color: #fff;
    }

    .select2-results__option--highlighted {
      background-color: #3c8dbc !important;
      color: #fff !important;
    }

    .select2-results__option[aria-selected=true] {
      background-color: #ddd;
    }

    .select2-search--dropdown {
      padding: 4px;
      background-color: #fff;
    }

    .select2-search--dropdown .select2-search__field {
      border: 1px solid #ccc;
      padding: 4px 6px;
      background-color: #fff;
    }

    /* CRITICAL: Hide original select when Select2 is active */
    .select2-hidden-accessible {
      border: 0 !important;
      clip: rect(0 0 0 0) !important;
      height: 1px !important;
      margin: -1px !important;
      overflow: hidden !important;
      padding: 0 !important;
      position: absolute !important;
      width: 1px !important;
      display: none !important;
    }

    /* Ensure Select2 container displays properly */
    .select2-container--default.select2-container--open .select2-selection--single {
      border-color: #3c8dbc;
    }

    .select2-container--default.select2-container--focus .select2-selection--single {
      border-color: #3c8dbc;
      outline: 0;
    } */
    
       .select2-container--default .select2-selection--single {
             border: 1px solid #d2d6de ;
             border-radius: 0px;
         }
         .select2-container
         {
         	width: 100% !important;
         }
         .select2-container--default .select2-selection--single .select2-selection__rendered {
             line-height: 24px;
    	}
    

    .mb-3 {
      margin-bottom: 15px;
    }

    .mt-2 {
      margin-top: 10px;
    }
  </style>
</head>
<body>
<div class="content-wrapper">
  <!-- Content Header (Page header) -->
  <section class="content-header">
    <h1>Update Vendor Details</h1>
  </section>

  <!-- Main content -->
  <section class="content">
    <div class="row">
      <!-- left column -->
      <div class="col-md-12">
        <!-- general form elements -->
        <div class="box box-primary">
          <div class="box-header with-border">
            <h3 class="box-title">Vendor Information Update</h3>
          </div>

          <div class="box-body">
            <div id="msgDiv"></div>

            <table class="table table-bordered">
              <tr>
                <th align="left" width="20%">Doc ID <font color="red">*</font></th>
                <td>
                  <div style="display: flex; gap: 8px;">
                    <input id="docIdInput" class="form-control" placeholder="Enter Doc ID" style="width: 300px;">
                    <button class="btn btn-primary" onclick="loadDocFields()">Load</button>
                  </div>
                </td>
              </tr>
            </table>

            <div id="detailsSection" style="display:none;">
              <table class="table table-bordered">
                <tr>
                  <th align="left" width="20%">Select Field to Update</th>
                  <td>
                    <select id="fieldSelect" class="form-control select2">
                      <option value="">-- Select Field --</option>
                    </select>
                  </td>
                </tr>
              </table>

              <div id="fieldUpdateSection" style="display:none;">
                <table class="table table-bordered">
                  <thead>
                    <tr>
                      <th width="25%">Field Name</th>
                      <th width="35%">Current Value</th>
                      <th width="40%">New Value</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td id="selectedFieldName"></td>
                      <td id="currentValueCell"></td>
                      <td id="newValueCell"></td>
                    </tr>
                  </tbody>
                </table>
                <button class="btn btn-success" onclick="updateFieldValue()">Save Changes</button>
              </div>

              <hr/>

              <table class="table table-bordered">
                <tr>
                  <th align="left" width="20%">Attachment Type</th>
                  <td>
                    <select id="attachmentType" class="form-control select2">
                      <option value="">-- Select Attachment Type --</option>
                      <option value="VENDREGPAN">PAN Document (VENDREGPAN)</option>
                      <option value="VENDREGGST">GST Document (VENDREGGST)</option>
                      <option value="VENDREGMSME">MSME Document (VENDREGMSME)</option>
                      <option value="VENDREGCHEQ">Cancelled Cheque (VENDREGCHEQ)</option>
                      <option value="VENDREGMAND">Mandatory Document (VENDREGMAND)</option>
                      <option value="VNRH">VNRH Documents (VNRH)</option>
                    </select>
                  </td>
                </tr>
              </table>

              <div style="margin-top: 15px;">
                <h4 style="margin-bottom: 10px;">Existing Attachments</h4>
                <div id="attachmentList"></div>
              </div>

              <div id="fileUploadArea" class="file-upload-area">
                <span><i class="fa fa-upload"></i> Click or drop file here to upload</span>
                <input id="fileInput" type="file">
              </div>

              <button id="uploadBtn" class="btn btn-success mt-2" disabled onclick="uploadAttachment()">
                <i class="fa fa-upload"></i> Upload
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</div>

<script src="../../../../../EzCommon/Library/plugins/jQuery/jQuery-3.5.1.min.js"></script>
<script src="../../../../../EzCommon/Library/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" language="javascript" src="../../../../../EzCommon/Library/dataTables/dataTables.bootstrap.min.js"></script>
<!-- Select2 for searchable dropdowns -->
<script src="../../../../../EzCommon/Library/plugins/select2/select2.full.min.js"></script>
<link rel="stylesheet" href="../../../../../EzCommon/Library/plugins/select2/select2.min.css">


<script>
let allFields = {};
let attachments = [];
let currentFieldName = '';
let FIELD_METADATA = {};

// Field Label Mapping - Maps database field names to user-friendly labels
// This ensures clear display names in the field selection dropdown
const FIELD_LABELS = {
  // Basic Information
  "title": "Title",
  "vendName": "Vendor Name",
  "searchTerm": "Search Term",
  "careOf_Name": "Care Of Name",

  // Address Information
  "addrsLine1": "Address Line 1",
  "addrsLine2": "Address Line 2",
  "addrsLine3": "Address Line 3",
  "addrsLine4": "Address Line 4",
  "addrsLine5": "Address Line 5",
  "districtName": "District",
  "city": "City",
  "state": "State",
  "postalCode": "Postal Code / ZIP Code",
  "country": "Country",

  // Contact Information
  "phoneNum": "Phone Number",
  "altPhoneNum": "Alternate Phone Number",
  "mobNum": "Mobile Number",
  "altMobNum": "Alternate Mobile Number",
  "fax": "Fax Number",
  "email_1": "Email Address 1",
  "email_2": "Email Address 2",

  // Commercial Information
  "typeOfOrg": "Type of Entity / Organization",
  "othCompType": "Other Company Type",
  "supType": "Type of Supplier",
  "othSupType": "Other Supplier Type",
  "vendorType": "Type of Vendor",
  "purOrdCurr": "Purchase Order Currency",
  "INCO_Terms": "Incoterms (Delivery Terms)",

  // Tax & Legal Information
  "PAN_Number": "PAN Number",
  "PAN_Name": "Legal Name (as per PAN)",
  "PAN_Attach": "PAN Document Required",
  "gstVendorClas": "GST Vendor Classification",
  "gst_Number": "GST Number / GSTIN",
  "gstType": "GST Registration Type",
  "TAN_Number": "TAN Number",
  "CIN_Number": "CIN Number (Corporate Identification)",

  // Financial Information
  "msme_Type": "MSME Status of Vendor",
  "msme_Udyog_AdhrNo": "MSME / Udyog Aadhaar Number",
  "paymntTerms": "Payment Terms",
  "bus_Status": "Business Status of Vendor",
  "e_Invoice": "E-Invoicing Applicable",
  "vend_Jgl": "Supplier Created with Other Jubilant Entities",
  "vend_Unit": "Jubilant Business Unit",
  "vend_Trans": "Previous Transaction with Jubilant",
  "vend_Dtls": "Vendor Transaction Details",
  "vend_Site": "Site Visit Conducted",
  "sitePerson": "Site Visit - Person Name",
  "siteViDt": "Site Visit Date",

  // Bank Information
  "bankName": "Bank Name",
  "bankBranch": "Bank Branch",
  "bankAccNum": "Bank Account Number",
  "bankIFSC": "IFSC Code",
  "bankAccType": "Bank Account Type",
  "bankSwift": "SWIFT Code",
  "chequeNo": "Cancelled Cheque Number",

  // Withholding Tax
  "whTaxType": "Withholding Tax Type",
  "whTaxCode": "Withholding Tax Code",

  // Reconciliation
  "recType": "Reconciliation Account Type",
  "reconAccount": "Reconciliation Account",
  "pmntMode": "Payment Mode",

  // Contact Person Details (Dynamic - Pattern based)
  "contactName_": "Contact Person Name",
  "contactTitle_": "Contact Person Title",
  "contactDesig_": "Contact Person Designation",
  "contactDept_": "Contact Person Department",
  "contactPhone_": "Contact Person Phone",
  "contactEmail_": "Contact Person Email",

  // Other Fields
  "regNum": "Registration Number",
  "regDate": "Registration Date",
  "compCode": "Company Code",
  "purOrg": "Purchasing Organization",
  "venWFPlant": "Plant",
  "venWFCategory": "Category"
};

// Initialize on page load
$(document).ready(function() {
  loadFieldMetadata(function() {
    // Metadata loaded - Select2 will be initialized when dropdowns are populated
  });

  // Ensure attachment dropdown is initialized ONCE on page load (it has static options)
  setTimeout(function() {
    const attachSel = $("#attachmentType");
    if (attachSel.length > 0 && !attachSel.hasClass('select2-hidden-accessible')) {
      attachSel.select2({
        placeholder: "-- Select Attachment Type --",
        allowClear: true,
        width: '100%'
      });
    }
  }, 500);
});

function initializeSelect2ForElement(element) {
  // Safe initialization for a single element
  const $el = $(element);
  if ($el.length === 0) return; // Element doesn't exist

  // Destroy if already initialized
  if ($el.hasClass('select2-hidden-accessible')) {
    $el.select2('destroy');
  }

  // Initialize fresh
  const placeholder = $el.attr('id') === 'fieldSelect' ? "-- Select Field --" :
                     $el.attr('id') === 'attachmentType' ? "-- Select Attachment Type --" :
                     "-- Select --";

  $el.select2({
    placeholder: placeholder,
    allowClear: true,
    width: '100%'
  });
}

function initializeSelect2() {
  // Initialize Select2 for all dropdowns with class 'select2' that aren't already initialized
  $('.select2').each(function() {
    if (!$(this).hasClass('select2-hidden-accessible')) {
      $(this).select2({
        placeholder: $(this).attr('id') === 'fieldSelect' ? "-- Select Field --" : "-- Select --",
        allowClear: true,
        width: '100%'
      });
    }
  });

  // Remove default title attribute on hover (from ezVendReg)
  $('.select2-selection__rendered').hover(function () {
    $(this).removeAttr('title');
  });
}

// Load field metadata from server (dynamically fetched from ezCountryHT.jsp and HashMaps)
function loadFieldMetadata(callback) {
  $.get("getFieldMetadata.jsp", function(res){
    try {
      if(typeof res === 'string') res = JSON.parse(res);
      if(res.status === 'success') {
        FIELD_METADATA = res.fieldMetadata;
        if(callback) callback();
      } else {
        showMessage("Error loading field metadata", "error");
      }
    } catch(e){
      console.error("Error parsing metadata:", e);
      showMessage("Error loading field configuration", "error");
    }
  }).fail(function(){
    showMessage("Failed to load field configuration", "error");
  });
}

// Get user-friendly label for a field
function getFieldLabel(fieldName) {
  // Check exact match first
  if (FIELD_LABELS[fieldName]) {
    return FIELD_LABELS[fieldName];
  }

  // Check pattern-based matches (for dynamic fields like contactName_1, contactName_2, etc.)
  for (let pattern in FIELD_LABELS) {
    if (pattern.endsWith('_') && fieldName.startsWith(pattern)) {
      let suffix = fieldName.substring(pattern.length);
      return FIELD_LABELS[pattern] + ' ' + suffix;
    }
  }

  // If metadata has a label, use it
  if (FIELD_METADATA[fieldName] && FIELD_METADATA[fieldName].label) {
    return FIELD_METADATA[fieldName].label;
  }

  // Fallback: Convert camelCase/snake_case to Title Case
  return fieldName
    .replace(/_/g, ' ')
    .replace(/([A-Z])/g, ' $1')
    .replace(/^./, str => str.toUpperCase())
    .trim();
}

// Legacy FIELD_METADATA object for reference (will be replaced by dynamic data)
const FIELD_METADATA_LEGACY = {
  // Dropdowns
  "title": {
    type: "select",
    label: "Title",
    options: [
      {value: "", text: "--select--"},
      {value: "Company", text: "Company"},
      {value: "Mr.", text: "Mr."},
      {value: "Ms.", text: "Ms."},
      {value: "Mr. and Mrs.", text: "Mr. and Mrs."},
      {value: "Physician", text: "Physician"}
    ]
  },
  "country": {
    type: "select",
    label: "Country",
    options: [
      {value: "", text: "--Select Country--"},
      {value: "IN", text: "India"},
      {value: "US", text: "United States"},
      {value: "GB", text: "United Kingdom"},
      {value: "CN", text: "China"}
      // Add more countries as needed
    ]
  },
  "state": {
    type: "select",
    label: "State",
    options: [
      {value: "", text: "--Select State--"},
      {value: "01", text: "Andra Pradesh"},
      {value: "02", text: "Arunachal Pradesh"},
      {value: "03", text: "Assam"},
      {value: "04", text: "Bihar"},
      {value: "05", text: "Goa"},
      {value: "06", text: "Gujarat"},
      {value: "07", text: "Haryana"},
      {value: "08", text: "Himachal Pradesh"},
      {value: "09", text: "Jammu and Kashmir"},
      {value: "10", text: "Karnataka"},
      {value: "11", text: "Kerala"},
      {value: "12", text: "Madhya Pradesh"},
      {value: "13", text: "Maharashtra"},
      {value: "14", text: "Manipur"},
      {value: "15", text: "Megalaya"},
      {value: "16", text: "Mizoram"},
      {value: "17", text: "Nagaland"},
      {value: "18", text: "Orissa"},
      {value: "19", text: "Punjab"},
      {value: "20", text: "Rajasthan"},
      {value: "21", text: "Sikkim"},
      {value: "22", text: "Tamil Nadu"},
      {value: "23", text: "Tripura"},
      {value: "24", text: "Uttar Pradesh"},
      {value: "25", text: "West Bengal"},
      {value: "26", text: "Andaman and Nico"},
      {value: "27", text: "Chandigarh"},
      {value: "28", text: "Dadra und Nagar Hav."},
      {value: "29", text: "Daman und Diu"},
      {value: "30", text: "Delhi"},
      {value: "31", text: "Lakshadweep"},
      {value: "32", text: "Pondicherry"},
      {value: "33", text: "Chhaattisgarh"},
      {value: "34", text: "Jharkhand"},
      {value: "35", text: "Uttarakhand"},
      {value: "36", text: "Telangana"},
      {value: "AN", text: "Andhra Pradesh"},
      {value: "ND", text: "New Delhi"}
    ]
  },
  "paymntTerms": {
    type: "select",
    label: "Payment Terms",
    options: [
      {value: "", text: "--Select Payment terms--"},
      {value: "Z001", text: "Z001 - Payable Immediately"},
      {value: "Z002", text: "Z002 - Within 7 Days"},
      {value: "Z003", text: "Z003 - Within 14 Days"},
      {value: "Z004", text: "Z004 - Within 30 Days"},
      {value: "Z005", text: "Z005 - Within 45 Days"},
      {value: "Z006", text: "Z006 - Within 60 Days"},
      {value: "Z007", text: "Z007 - Within 90 Days"}
    ]
  },

  // Radio Buttons
  "msme_Type": {
    type: "radio",
    label: "Status of Vendor (MSME)",
    options: [
      {value: "0", text: "Non MSME"},
      {value: "1", text: "Micro"},
      {value: "5", text: "Small"},
      {value: "9", text: "Medium"}
    ]
  },
  "typeOfOrg": {
    type: "radio",
    label: "Type of Entity/Organization",
    options: [
      {value: "0001", text: "Public Limited Company"},
      {value: "0002", text: "Private Limited Company"},
      {value: "0003", text: "Partnership Firm"},
      {value: "0004", text: "Proprietorship Firm"},
      {value: "0005", text: "LLP"},
      {value: "0006", text: "Trust"},
      {value: "0007", text: "Society"},
      {value: "0008", text: "HUF"},
      {value: "OTH", text: "Other"}
    ]
  },
  "bus_Status": {
    type: "radio",
    label: "Business Status of Vendor",
    options: [
      {value: "ACT", text: "Active"},
      {value: "INA", text: "Inactive"},
      {value: "SUS", text: "Suspended"}
    ]
  },
  "e_Invoice": {
    type: "radio",
    label: "E-Invoicing",
    options: [
      {value: "Y", text: "Yes"},
      {value: "N", text: "No"}
    ]
  },
  "vend_Jgl": {
    type: "radio",
    label: "Is Supplier Currently Created with Other Jubilant Entities",
    options: [
      {value: "Y", text: "Yes"},
      {value: "N", text: "No"}
    ]
  },
  "gst_Status": {
    type: "radio",
    label: "GST Status",
    options: [
      {value: "R", text: "Registered"},
      {value: "U", text: "Unregistered"},
      {value: "C", text: "Composition"}
    ]
  },

  // Checkboxes
  "supType": {
    type: "checkbox",
    label: "Type of Supplier",
    options: [
      {value: "DOM", text: "Domestic"},
      {value: "IMP", text: "Import"},
      {value: "SER", text: "Service"},
      {value: "TRD", text: "Trader"},
      {value: "MAN", text: "Manufacturer"},
      {value: "OTH", text: "Other"}
    ]
  },

  // Text Inputs
  "vendName": { type: "text", label: "Vendor Name" },
  "searchTerm": { type: "text", label: "Search Term" },
  "addrsLine1": { type: "text", label: "Address Line 1" },
  "addrsLine2": { type: "text", label: "Address Line 2" },
  "addrsLine3": { type: "text", label: "Address Line 3" },
  "addrsLine4": { type: "text", label: "Address Line 4" },
  "addrsLine5": { type: "text", label: "Address Line 5" },
  "districtName": { type: "text", label: "District" },
  "city": { type: "text", label: "City" },
  "postalCode": { type: "text", label: "Postal Code" },
  "phoneNum": { type: "text", label: "Phone Number" },
  "altPhoneNum": { type: "text", label: "Alternate Phone Number" },
  "mobNum": { type: "text", label: "Mobile Number" },
  "altMobNum": { type: "text", label: "Alternate Mobile Number" },
  "fax": { type: "text", label: "Fax" },
  "email_1": { type: "text", label: "Email Address-1" },
  "email_2": { type: "text", label: "Email Address-2" },
  "PAN_Number": { type: "text", label: "PAN Number" },
  "GST_Number": { type: "text", label: "GST Number" },
  "msme_Udyog_AdhrNo": { type: "text", label: "MSME Registration Number" },
  "CIN_Number": { type: "text", label: "CIN Number" },
  "othCompType": { type: "text", label: "Other Company Type" },
  "othSupType": { type: "text", label: "Other Supplier Type" }
};
// NOTE: Above legacy metadata is now REPLACED by dynamic loading from getFieldMetadata.jsp
// which reads data from ezCountryHT.jsp and the actual HashMaps used in ezVendReg.jsp
// This ensures data consistency between registration and update forms.

function showMessage(txt, cls='success') {
  let alertClass = 'alert-success';
  if (cls === 'error') alertClass = 'alert-danger';
  if (cls === 'info') alertClass = 'alert-info';

  $("#msgDiv").html('<div class="alert '+alertClass+'" style="margin-top: 10px;">'+txt+'</div>');
  setTimeout(()=>$("#msgDiv").empty(),5000);
}

function loadDocFields() {
  const docId = $("#docIdInput").val().trim();
  if(!docId) return showMessage("Enter Doc ID","error");

  loadSampleAttachments(docId);

  $.post("getUserdetails.jsp", { docId }, function(res){
    try { if(typeof res === 'string') res = JSON.parse(res); } catch(e){}
    if(!res || res.status === "no_data" || Object.keys(res.data || {}).length===0) {
      populateFieldSelect();
      $("#detailsSection").show();
      showMessage("No fields found. You can still manage attachments.","info");
      return;
    }
    allFields = res.data;
    populateFieldSelect();
    $("#detailsSection").show();
    showMessage(Object.keys(allFields).length+" fields loaded","success");
  }).fail(function(xhr){ showMessage("Server error: "+xhr.status,"error"); });
}

function loadSampleAttachments(docId) {
  $.post("getAttachments.jsp", { docId, field: "VENDREGPAN" }, function(res){
    try{ res = JSON.parse(res); }catch(e){}
    if(res && res.attachments && res.attachments.length > 0) {
      showMessage("Found " + res.attachments.length + " attachments","success");
    }
  }).fail(()=>{});
}

function populateFieldSelect() {
  const sel = $("#fieldSelect");

  // Destroy Select2 if it exists
  if (sel.hasClass('select2-hidden-accessible')) {
    sel.select2('destroy');
  }

  // Clear and repopulate options
  sel.empty().append('<option value="">-- Select Field --</option>');

  // Group fields by type for better organization
  const fieldGroups = {
    'Dropdowns': [],
    'Radio Buttons': [],
    'Checkboxes': [],
    'Text Fields': []
  };

  Object.keys(allFields).sort().forEach(fieldName => {
    const metadata = FIELD_METADATA[fieldName];
    const label = getFieldLabel(fieldName);

    if (!metadata) {
      fieldGroups['Text Fields'].push({name: fieldName, label: label});
    } else if (metadata.type === 'select') {
      fieldGroups['Dropdowns'].push({name: fieldName, label: label});
    } else if (metadata.type === 'radio') {
      fieldGroups['Radio Buttons'].push({name: fieldName, label: label});
    } else if (metadata.type === 'checkbox') {
      fieldGroups['Checkboxes'].push({name: fieldName, label: label});
    } else {
      fieldGroups['Text Fields'].push({name: fieldName, label: label});
    }
  });

  // Add optgroups with user-friendly labels
  Object.keys(fieldGroups).forEach(groupName => {
    if (fieldGroups[groupName].length > 0) {
      const optgroup = $('<optgroup>').attr('label', groupName);
      fieldGroups[groupName].forEach(field => {
        // Show user-friendly label
        optgroup.append(`<option value="${field.name}">${field.label}</option>`);
      });
      sel.append(optgroup);
    }
  });

  // Use safe initialization helper
  initializeSelect2ForElement(sel);
}

$("#fieldSelect").on("change", function(){
  const fieldName = $(this).val();
  if(!fieldName){
    $("#fieldUpdateSection").hide();
    return;
  }

  currentFieldName = fieldName;
  renderFieldComparison(fieldName);
  $("#fieldUpdateSection").show();
});

function renderFieldComparison(fieldName) {
  const metadata = FIELD_METADATA[fieldName];
  const currentValue = allFields[fieldName] || "";
  const fieldLabel = getFieldLabel(fieldName);

  $("#selectedFieldName").html(`<strong>${fieldLabel}</strong><br><small class="text-muted">${fieldName}</small>`);

  // Render current value
  $("#currentValueCell").html(renderCurrentValue(fieldName, currentValue, metadata));

  // Render new value input
  $("#newValueCell").html(renderNewValueInput(fieldName, currentValue, metadata));

  // Initialize Select2 ONLY for select elements in the new value cell (if they have the class)
  $("#newValueCell select.select2").each(function() {
    if (!$(this).hasClass('select2-hidden-accessible')) {
      $(this).select2({
        placeholder: "-- Select --",
        allowClear: true,
        width: '100%',
        dropdownParent: $(this).parent() // Ensure dropdown appears in correct location
      });
    }
  });
}

function renderCurrentValue(fieldName, currentValue, metadata) {
  if (!metadata) {
    return `<div class="current-value-display">${currentValue || '<em class="text-muted">Empty</em>'}</div>`;
  }

  if (metadata.type === 'select') {
    const option = metadata.options.find(opt => opt.value === currentValue);
    const displayText = option ? option.text : currentValue;
    return `<div class="current-value-display"><strong>Value:</strong> ${currentValue}<br><strong>Label:</strong> ${displayText}</div>`;
  }

  if (metadata.type === 'radio') {
    const option = metadata.options.find(opt => opt.value === currentValue);
    const displayText = option ? option.text : currentValue;
    return `<div class="current-value-display"><strong>Value:</strong> ${currentValue}<br><strong>Option:</strong> ${displayText}</div>`;
  }

  if (metadata.type === 'checkbox') {
    const values = currentValue.split(',').map(v => v.trim()).filter(v => v);
    let html = '<div class="current-value-display">';
    if (values.length === 0) {
      html += '<em class="text-muted">None selected</em>';
    } else {
      values.forEach(val => {
        const option = metadata.options.find(opt => opt.value === val);
        const displayText = option ? option.text : val;
        html += `<div>âœ“ ${displayText} (${val})</div>`;
      });
    }
    html += '</div>';
    return html;
  }

  return `<div class="current-value-display">${currentValue || '<em class="text-muted">Empty</em>'}</div>`;
}

function renderNewValueInput(fieldName, currentValue, metadata) {
  if (!metadata || metadata.type === 'text') {
    return `<input type="text" id="newValue" class="form-control" value="${currentValue || ''}" placeholder="Enter new value">`;
  }

  if (metadata.type === 'select') {
    let html = '<select id="newValue" class="form-control select2">';
    metadata.options.forEach(opt => {
      const selected = opt.value === currentValue ? 'selected' : '';
      html += `<option value="${opt.value}" ${selected}>${opt.text}</option>`;
    });
    html += '</select>';
    return html;
  }

  if (metadata.type === 'radio') {
    let html = '<div class="radio-group">';
    metadata.options.forEach(opt => {
      const checked = opt.value === currentValue ? 'checked' : '';
      html += `<div class="radio-option">
        <label>
          <input type="radio" name="newValueRadio" value="${opt.value}" ${checked}>
          ${opt.text}
        </label>
      </div>`;
    });
    html += '</div>';
    return html;
  }

  if (metadata.type === 'checkbox') {
    const currentValues = currentValue.split(',').map(v => v.trim()).filter(v => v);
    let html = '<div class="checkbox-group">';
    metadata.options.forEach(opt => {
      const checked = currentValues.includes(opt.value) ? 'checked' : '';
      html += `<div class="checkbox-option">
        <label>
          <input type="checkbox" name="newValueCheckbox" value="${opt.value}" ${checked}>
          ${opt.text}
        </label>
      </div>`;
    });
    html += '</div>';
    return html;
  }

  return `<input type="text" id="newValue" class="form-control" value="${currentValue || ''}">`;
}

function updateFieldValue() {
  const docId = $("#docIdInput").val().trim();
  const fieldName = currentFieldName;

  if (!fieldName) return showMessage("Select a field first","error");

  const metadata = FIELD_METADATA[fieldName];
  let newValue = '';

  if (!metadata || metadata.type === 'text' || metadata.type === 'select') {
    newValue = $("#newValue").val();
  } else if (metadata.type === 'radio') {
    newValue = $("input[name='newValueRadio']:checked").val() || '';
  } else if (metadata.type === 'checkbox') {
    const checkedValues = [];
    $("input[name='newValueCheckbox']:checked").each(function() {
      checkedValues.push($(this).val());
    });
    newValue = checkedValues.join(',');
  }

  $.post("UpdateUserDetailsAjax.jsp", { docId, field: fieldName, value: newValue }, function(res){
    try{ if(typeof res==='string') res=JSON.parse(res); }catch(e){}
    if(res && res.status==="success"){
      allFields[fieldName] = newValue;
      showMessage("Updated successfully","success");
      // Re-render to show updated current value
      renderFieldComparison(fieldName);
    }
    else showMessage(res && res.message ? res.message : "Update failed","error");
  }).fail(()=>showMessage("Update failed","error"));
}

$("#attachmentType").on("change", function(){
  const t = $(this).val();
  $("#uploadBtn").prop("disabled", true);
  if(!t) { $("#attachmentList").html("<p class='text-muted'>Select type</p>"); return; }
  loadAttachments(t);
});

function loadAttachments(docType) {
  const docId = $("#docIdInput").val().trim();
  $.post("getAttachments.jsp", { docId, field: docType }, function(res){
    try{ if(typeof res==='string') res=JSON.parse(res);}catch(e){}
    attachments = res && res.attachments ? res.attachments : [];
    renderAttachments();
  }).fail(()=>showMessage("Error loading attachments","error"));
}


function downloadFile(status, upItemNo, fileName, upDocType) {
  //alert("fileName>>>"+fileName);
  var upDocId = $("#docIdInput").val().trim();
  fileName = encodeURIComponent(fileName);
  window.open("../../../../../EzVendor/Vendor2/JSPs/Inbox/ezDownloadFile.jsp?upDocId=" + upDocId + "&upDocType=" + upDocType + "&upItemNo=" + upItemNo + "&fileName=" + fileName);
}

function renderAttachments(){
  const box = $("#attachmentList").empty();
  if(!attachments || attachments.length===0)
    return box.html("<p class='text-muted'>No attachments found</p>");

  const docId = $("#docIdInput").val().trim();

  attachments.forEach((a, idx)=>{
    const html = `<div class="attachment-item">
      <div><strong>${a.filename}</strong><br><small class="text-muted">${a.uploadDate||''}</small></div>
      <div>
        <a class="btn btn-sm btn-outline-primary" href="#"
           onclick="downloadFile('${a.status||''}', '${a.itemNo}', '${a.filename}', '${a.docType}'); return false;">
           Download</a>

        <button class="btn btn-sm btn-danger"
	  onclick="deleteAttachment(
	      '${a.docType}',
	      '${a.itemNo}',
	      '${a.filename}'
	  )">Delete</button>

      </div>
    </div>`;
    box.append(html);
  });
}
function deleteAttachment(docType, itemNo, fileName) {
    if (!confirm("Are you sure you want to delete this document?")) return;

    const docId = $("#docIdInput").val().trim();

    $.post("deleteAttachmentAjax.jsp", {
        upDocId: docId,
        upDocType: docType,
        upItemNo: itemNo,
        fileName: fileName
    }, function(res){
        if (res.trim() === "true") {

            //  STORE ITEM NO FOR REUSE
            window.reuseItemNo = itemNo;

            showMessage("Deleted successfully", "success");
            loadAttachments($("#attachmentType").val());

            // enable upload button again
            $("#uploadBtn").prop("disabled", false);
        } else {
            showMessage("Failed to delete", "error");
        }
    });
}


$("#fileInput").on("change", function() {
    if (this.files.length > 0) {
        $("#uploadBtn").prop("disabled", false);
    }
});

$("#fileUploadArea").on("dragover", function(e){
    e.preventDefault();
    $(this).addClass("dragover");
});

$("#fileUploadArea").on("dragleave", function(e){
    e.preventDefault();
    $(this).removeClass("dragover");
});

$("#fileUploadArea").on("drop", function(e){
    e.preventDefault();
    $(this).removeClass("dragover");

    let files = e.originalEvent.dataTransfer.files;
    $("#fileInput")[0].files = files;

    if (files.length > 0) {
        $("#uploadBtn").prop("disabled", false);
    }
});

function uploadAttachment() {
    const file = $("#fileInput")[0].files[0];
    const docId = $("#docIdInput").val().trim();
    const docType = $("#attachmentType").val();

    if (!file) return showMessage("Select file", "error");
    if (!docType) return showMessage("Select attachment type", "error");

    const fd = new FormData();

    //  THESE MUST BE SENT FIRST
    fd.append("docId", docId);
    fd.append("docType", docType);

    //  SEND reuseItemNo ONLY IF EXISTS
    if (window.reuseItemNo && window.reuseItemNo !== "null") {
        fd.append("reuseItemNo", window.reuseItemNo);
    }

    fd.append("file", file);

    $("#uploadBtn").prop("disabled", true).text("Uploading...");

    $.ajax({
        url: "UploadAttachments.jsp",
        type: "POST",
        data: fd,
        enctype: "multipart/form-data",
        cache: false,
        contentType: false,
        processData: false,
        success: function (res) {
            console.log("UPLOAD RESPONSE:", res);

            try { res = JSON.parse(res); } catch (e) {}

            if (res.status === "success") {
                showMessage("Upload complete", "success");

                // reset reuse
                window.reuseItemNo = null;

                loadAttachments(docType);
            } else {
                showMessage(res.message || "Upload failed", "error");
            }

            $("#uploadBtn").prop("disabled", true).text("Upload");
            $("#fileInput").val("");
        },
        error: function (xhr) {
            console.log("UPLOAD ERROR:", xhr.responseText);
            showMessage("Server error during upload", "error");
            $("#uploadBtn").prop("disabled", false).text("Upload");
        }
    });
}


</script>
<script>
               $(document).ajaxSend(function (event, xhr, settings) {
                   if (!settings || !settings.type) return;
               
                   if (settings.type.toUpperCase() === "POST") {
                       var csrfToken = '<%= session.getAttribute("CSRF_TOKEN") %>';
               
                       // ? FormData (file upload / ajaxForm) ? SAFE append
                       if (settings.data instanceof FormData) {
                          settings.data.append("csrfToken", csrfToken);
                           return;
                       }
               
                       // ? URL-encoded string
                       if (typeof settings.data === "string" && settings.data.length > 0) {
                           settings.data += "&csrfToken=" + encodeURIComponent(csrfToken);
                       } 
                       else if (typeof settings.data === "string") {
                           settings.data = "csrfToken=" + encodeURIComponent(csrfToken);
                       }
                   }
               });
               (function (open, send) {
               
                   XMLHttpRequest.prototype.open = function (method, url, async, user, pass) {
                       this._method = method;
                       open.call(this, method, url, async, user, pass);
                   };
               
                   XMLHttpRequest.prototype.send = function (body) {
                       try {
                           if (this._method && this._method.toUpperCase() === "POST") {
                               var csrfToken = '<%= session.getAttribute("CSRF_TOKEN") %>';
               
                               // ? FormData (multipart)
                               if (body instanceof FormData) {
                                  body.append("csrfToken", csrfToken);
                               }
                               // URL-encoded string
                               else if (typeof body === "string") {
                                   body += "&csrfToken=" + encodeURIComponent(csrfToken);
                               }
                               // Do NOT create or overwrite multipart bodies
                           }
                       } catch (e) {
                           console.error("CSRF token append failed", e);
                       }
               
                       send.call(this, body);
                   };
               
               })(XMLHttpRequest.prototype.open, XMLHttpRequest.prototype.send);
               
               (function (originalFetch) {
               
                   window.fetch = function (resource, options = {}) {
                       try {
                           if (options.method && options.method.toUpperCase() === "POST") {
                               var csrfToken = '<%= session.getAttribute("CSRF_TOKEN") %>';
                               options.headers = options.headers || {};
               
                               // ? JSON body
                               if (options.headers["Content-Type"] &&
                                  options.headers["Content-Type"].includes("application/json")) {
               
                                   var bodyObj = options.body ? JSON.parse(options.body) : {};
                                   bodyObj.csrfToken = csrfToken;
                                   options.body = JSON.stringify(bodyObj);
                               }
               
                               // ? URL encoded
                               else if (options.headers["Content-Type"] &&
                                       options.headers["Content-Type"].includes("application/x-www-form-urlencoded")) {
               
                                   var bodyText = options.body ? options.body.toString() : "";
                                   options.body = bodyText +
                                       (bodyText ? "&" : "") +
                                       "csrfToken=" + encodeURIComponent(csrfToken);
                               }
               
                               // ? FormData (multipart / file upload)
                               else if (options.body instanceof FormData) {
                                  options.body.append("csrfToken", csrfToken);
                               }
                           }
                       } catch (e) {
                           console.error("CSRF token injection failed for fetch", e);
                       }
               
                       return originalFetch(resource, options);
                   };
               
               })(window.fetch);
               
               </script>
</body>
</html>