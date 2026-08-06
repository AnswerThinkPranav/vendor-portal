<%@ page import="ezc.ezparam.*,java.util.*" %>
<%@ page contentType="application/json;charset=UTF-8" %>
<%
response.setContentType("application/json;charset=UTF-8");

// Include the HashMaps from ezCountryHT.jsp
%>
<%@ include file="ezCountryHT.jsp"%>
<%

org.json.JSONObject jsonResp = new org.json.JSONObject();
org.json.JSONObject fieldMetadata = new org.json.JSONObject();

try {
    // Title options
    org.json.JSONArray titleOpts = new org.json.JSONArray();
    titleOpts.put(new org.json.JSONObject().put("value", "").put("text", "--select--"));
    titleOpts.put(new org.json.JSONObject().put("value", "Company").put("text", "Company"));
    titleOpts.put(new org.json.JSONObject().put("value", "Mr.").put("text", "Mr."));
    titleOpts.put(new org.json.JSONObject().put("value", "Ms.").put("text", "Ms."));
    titleOpts.put(new org.json.JSONObject().put("value", "Mr. and Mrs.").put("text", "Mr. and Mrs."));
    titleOpts.put(new org.json.JSONObject().put("value", "Physician").put("text", "Physician"));
    fieldMetadata.put("title", new org.json.JSONObject().put("type", "select").put("label", "Title").put("options", titleOpts));

    // Country options from cuntLHM
    org.json.JSONArray countryOpts = new org.json.JSONArray();
    countryOpts.put(new org.json.JSONObject().put("value", "").put("text", "--Select Country--"));
    Set countrySet = cuntLHM.entrySet();
    Iterator countryIter = countrySet.iterator();
    while(countryIter.hasNext()) {
        Map.Entry me = (Map.Entry)countryIter.next();
        countryOpts.put(new org.json.JSONObject().put("value", me.getKey()).put("text", ((String)me.getValue()).trim()));
    }
    fieldMetadata.put("country", new org.json.JSONObject().put("type", "select").put("label", "Country").put("options", countryOpts));

    // State options (from ezVendReg.jsp)
    org.json.JSONArray stateOpts = new org.json.JSONArray();
    stateOpts.put(new org.json.JSONObject().put("value", "").put("text", "--Select State--"));
    stateOpts.put(new org.json.JSONObject().put("value", "01").put("text", "Andra Pradesh"));
    stateOpts.put(new org.json.JSONObject().put("value", "02").put("text", "Arunachal Pradesh"));
    stateOpts.put(new org.json.JSONObject().put("value", "03").put("text", "Assam"));
    stateOpts.put(new org.json.JSONObject().put("value", "04").put("text", "Bihar"));
    stateOpts.put(new org.json.JSONObject().put("value", "05").put("text", "Goa"));
    stateOpts.put(new org.json.JSONObject().put("value", "06").put("text", "Gujarat"));
    stateOpts.put(new org.json.JSONObject().put("value", "07").put("text", "Haryana"));
    stateOpts.put(new org.json.JSONObject().put("value", "08").put("text", "Himachal Pradesh"));
    stateOpts.put(new org.json.JSONObject().put("value", "09").put("text", "Jammu and Kashmir"));
    stateOpts.put(new org.json.JSONObject().put("value", "10").put("text", "Karnataka"));
    stateOpts.put(new org.json.JSONObject().put("value", "11").put("text", "Kerala"));
    stateOpts.put(new org.json.JSONObject().put("value", "12").put("text", "Madhya Pradesh"));
    stateOpts.put(new org.json.JSONObject().put("value", "13").put("text", "Maharashtra"));
    stateOpts.put(new org.json.JSONObject().put("value", "14").put("text", "Manipur"));
    stateOpts.put(new org.json.JSONObject().put("value", "15").put("text", "Megalaya"));
    stateOpts.put(new org.json.JSONObject().put("value", "16").put("text", "Mizoram"));
    stateOpts.put(new org.json.JSONObject().put("value", "17").put("text", "Nagaland"));
    stateOpts.put(new org.json.JSONObject().put("value", "18").put("text", "Orissa"));
    stateOpts.put(new org.json.JSONObject().put("value", "19").put("text", "Punjab"));
    stateOpts.put(new org.json.JSONObject().put("value", "20").put("text", "Rajasthan"));
    stateOpts.put(new org.json.JSONObject().put("value", "21").put("text", "Sikkim"));
    stateOpts.put(new org.json.JSONObject().put("value", "22").put("text", "Tamil Nadu"));
    stateOpts.put(new org.json.JSONObject().put("value", "23").put("text", "Tripura"));
    stateOpts.put(new org.json.JSONObject().put("value", "24").put("text", "Uttar Pradesh"));
    stateOpts.put(new org.json.JSONObject().put("value", "25").put("text", "West Bengal"));
    stateOpts.put(new org.json.JSONObject().put("value", "26").put("text", "Andaman and Nico"));
    stateOpts.put(new org.json.JSONObject().put("value", "27").put("text", "Chandigarh"));
    stateOpts.put(new org.json.JSONObject().put("value", "28").put("text", "Dadra und Nagar Hav."));
    stateOpts.put(new org.json.JSONObject().put("value", "29").put("text", "Daman und Diu"));
    stateOpts.put(new org.json.JSONObject().put("value", "30").put("text", "Delhi"));
    stateOpts.put(new org.json.JSONObject().put("value", "31").put("text", "Lakshadweep"));
    stateOpts.put(new org.json.JSONObject().put("value", "32").put("text", "Pondicherry"));
    stateOpts.put(new org.json.JSONObject().put("value", "33").put("text", "Chhaattisgarh"));
    stateOpts.put(new org.json.JSONObject().put("value", "34").put("text", "Jharkhand"));
    stateOpts.put(new org.json.JSONObject().put("value", "35").put("text", "Uttarakhand"));
    stateOpts.put(new org.json.JSONObject().put("value", "36").put("text", "Telangana"));
    stateOpts.put(new org.json.JSONObject().put("value", "AN").put("text", "Andhra Pradesh"));
    stateOpts.put(new org.json.JSONObject().put("value", "ND").put("text", "New Delhi"));
    fieldMetadata.put("state", new org.json.JSONObject().put("type", "select").put("label", "State").put("options", stateOpts));

    // Payment Terms from pymTermsHt
    org.json.JSONArray pmntOpts = new org.json.JSONArray();
    pmntOpts.put(new org.json.JSONObject().put("value", "").put("text", "--Select Payment terms--"));
    Set pmntSet = pymTermsHt.entrySet();
    Iterator pmntIter = pmntSet.iterator();
    while(pmntIter.hasNext()) {
        Map.Entry me = (Map.Entry)pmntIter.next();
        pmntOpts.put(new org.json.JSONObject().put("value", me.getKey()).put("text", me.getKey() + " - " + me.getValue()));
    }
    fieldMetadata.put("paymntTerms", new org.json.JSONObject().put("type", "select").put("label", "Payment Terms").put("options", pmntOpts));

    // MSME Type from msmeTypeHM
    org.json.JSONArray msmeOpts = new org.json.JSONArray();
    Set msmeSet = msmeTypeHM.entrySet();
    Iterator msmeIter = msmeSet.iterator();
    while(msmeIter.hasNext()) {
        Map.Entry me = (Map.Entry)msmeIter.next();
        msmeOpts.put(new org.json.JSONObject().put("value", me.getKey()).put("text", me.getValue()));
    }
    fieldMetadata.put("msme_Type", new org.json.JSONObject().put("type", "radio").put("label", "Status of Vendor (MSME)").put("options", msmeOpts));

    // Type of Organization from constTypeHT
    org.json.JSONArray orgOpts = new org.json.JSONArray();
    Set orgSet = constTypeHT.entrySet();
    Iterator orgIter = orgSet.iterator();
    while(orgIter.hasNext()) {
        Map.Entry me = (Map.Entry)orgIter.next();
        orgOpts.put(new org.json.JSONObject().put("value", me.getKey()).put("text", me.getValue()));
    }
    fieldMetadata.put("typeOfOrg", new org.json.JSONObject().put("type", "radio").put("label", "Type of Entity/Organization").put("options", orgOpts));

    // Business Status from busStatusHM
    org.json.JSONArray busOpts = new org.json.JSONArray();
    Set busSet = busStatusHM.entrySet();
    Iterator busIter = busSet.iterator();
    while(busIter.hasNext()) {
        Map.Entry me = (Map.Entry)busIter.next();
        busOpts.put(new org.json.JSONObject().put("value", me.getKey()).put("text", me.getValue()));
    }
    fieldMetadata.put("bus_Status", new org.json.JSONObject().put("type", "radio").put("label", "Business Status of Vendor").put("options", busOpts));

    // E-Invoice
    org.json.JSONArray eInvOpts = new org.json.JSONArray();
    eInvOpts.put(new org.json.JSONObject().put("value", "Y").put("text", "Yes"));
    eInvOpts.put(new org.json.JSONObject().put("value", "N").put("text", "No"));
    fieldMetadata.put("e_Invoice", new org.json.JSONObject().put("type", "radio").put("label", "E-Invoicing").put("options", eInvOpts));

    // Vendor JGL
    org.json.JSONArray jglOpts = new org.json.JSONArray();
    jglOpts.put(new org.json.JSONObject().put("value", "Y").put("text", "Yes"));
    jglOpts.put(new org.json.JSONObject().put("value", "N").put("text", "No"));
    fieldMetadata.put("vend_Jgl", new org.json.JSONObject().put("type", "radio").put("label", "Is Supplier Currently Created with Other Jubilant Entities").put("options", jglOpts));

    // GST Type (from gstTypeHt)
    org.json.JSONArray gstTypeOptsArr = new org.json.JSONArray();
    Set gstTypeSet = gstTypeHt.entrySet();
    Iterator gstTypeIter = gstTypeSet.iterator();
    while(gstTypeIter.hasNext()) {
        Map.Entry me = (Map.Entry)gstTypeIter.next();
        gstTypeOptsArr.put(new org.json.JSONObject().put("value", me.getKey()).put("text", me.getValue()));
    }
    fieldMetadata.put("gstType", new org.json.JSONObject().put("type", "radio").put("label", "GST Type").put("options", gstTypeOptsArr));

    // Supplier Type from supTypeHM
    org.json.JSONArray supOpts = new org.json.JSONArray();
    Set supSet = supTypeHM.entrySet();
    Iterator supIter = supSet.iterator();
    while(supIter.hasNext()) {
        Map.Entry me = (Map.Entry)supIter.next();
        supOpts.put(new org.json.JSONObject().put("value", me.getKey()).put("text", me.getValue()));
    }
    fieldMetadata.put("supType", new org.json.JSONObject().put("type", "checkbox").put("label", "Type of Supplier").put("options", supOpts));

    // Vendor Type from vendorTypeHM
    org.json.JSONArray vendTypeOpts = new org.json.JSONArray();
    Set vendSet = vendorTypeHM.entrySet();
    Iterator vendIter = vendSet.iterator();
    while(vendIter.hasNext()) {
        Map.Entry me = (Map.Entry)vendIter.next();
        vendTypeOpts.put(new org.json.JSONObject().put("value", me.getKey()).put("text", me.getValue()));
    }
    fieldMetadata.put("vendorType", new org.json.JSONObject().put("type", "checkbox").put("label", "Vendor Type").put("options", vendTypeOpts));

    // Text fields
    fieldMetadata.put("vendName", new org.json.JSONObject().put("type", "text").put("label", "Vendor Name"));
    fieldMetadata.put("searchTerm", new org.json.JSONObject().put("type", "text").put("label", "Search Term"));
    fieldMetadata.put("addrsLine1", new org.json.JSONObject().put("type", "text").put("label", "Address Line 1"));
    fieldMetadata.put("addrsLine2", new org.json.JSONObject().put("type", "text").put("label", "Address Line 2"));
    fieldMetadata.put("addrsLine3", new org.json.JSONObject().put("type", "text").put("label", "Address Line 3"));
    fieldMetadata.put("addrsLine4", new org.json.JSONObject().put("type", "text").put("label", "Address Line 4"));
    fieldMetadata.put("addrsLine5", new org.json.JSONObject().put("type", "text").put("label", "Address Line 5"));
    fieldMetadata.put("districtName", new org.json.JSONObject().put("type", "text").put("label", "District"));
    fieldMetadata.put("city", new org.json.JSONObject().put("type", "text").put("label", "City"));
    fieldMetadata.put("postalCode", new org.json.JSONObject().put("type", "text").put("label", "Postal Code"));
    fieldMetadata.put("phoneNum", new org.json.JSONObject().put("type", "text").put("label", "Phone Number"));
    fieldMetadata.put("altPhoneNum", new org.json.JSONObject().put("type", "text").put("label", "Alternate Phone Number"));
    fieldMetadata.put("mobNum", new org.json.JSONObject().put("type", "text").put("label", "Mobile Number"));
    fieldMetadata.put("altMobNum", new org.json.JSONObject().put("type", "text").put("label", "Alternate Mobile Number"));
    fieldMetadata.put("fax", new org.json.JSONObject().put("type", "text").put("label", "Fax"));
    fieldMetadata.put("email_1", new org.json.JSONObject().put("type", "text").put("label", "Email Address-1"));
    fieldMetadata.put("email_2", new org.json.JSONObject().put("type", "text").put("label", "Email Address-2"));
    fieldMetadata.put("PAN_Number", new org.json.JSONObject().put("type", "text").put("label", "PAN Number"));
    fieldMetadata.put("PAN_Name", new org.json.JSONObject().put("type", "text").put("label", "PAN Name"));
    fieldMetadata.put("GST_Number", new org.json.JSONObject().put("type", "text").put("label", "GST Number"));
    fieldMetadata.put("gst_Number", new org.json.JSONObject().put("type", "text").put("label", "GST Number"));
    fieldMetadata.put("msme_Udyog_AdhrNo", new org.json.JSONObject().put("type", "text").put("label", "MSME Registration Number"));
    fieldMetadata.put("TAN_Number", new org.json.JSONObject().put("type", "text").put("label", "TAN Number"));
    fieldMetadata.put("CIN_Number", new org.json.JSONObject().put("type", "text").put("label", "CIN Number"));
    fieldMetadata.put("othCompType", new org.json.JSONObject().put("type", "text").put("label", "Other Company Type"));
    fieldMetadata.put("othSupType", new org.json.JSONObject().put("type", "text").put("label", "Other Supplier Type"));
    fieldMetadata.put("vend_Unit", new org.json.JSONObject().put("type", "text").put("label", "Business Unit"));
    fieldMetadata.put("vend_Dtls", new org.json.JSONObject().put("type", "text").put("label", "Vendor Details"));
    fieldMetadata.put("sitePerson", new org.json.JSONObject().put("type", "text").put("label", "Site Visit Person"));
    fieldMetadata.put("siteViDt", new org.json.JSONObject().put("type", "text").put("label", "Site Visit Date"));

    jsonResp.put("status", "success");
    jsonResp.put("fieldMetadata", fieldMetadata);

} catch(Exception e) {
    jsonResp.put("status", "error");
    jsonResp.put("message", e.getMessage());
    java.io.StringWriter sw = new java.io.StringWriter();
    e.printStackTrace(new java.io.PrintWriter(sw));
    jsonResp.put("stack", sw.toString());
}

out.print(jsonResp.toString());
%>

