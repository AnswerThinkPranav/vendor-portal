<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>   
<%@ include file="../Misc/ezCommonMethods.jsp"%> 
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@include file="../../../Includes/JSPs/Misc/iSelectFieldsForWF.jsp"%>  
<%@ include file="../Misc/ezHeader.jsp"%>

<%@ page import ="java.util.*,java.nio.file.*,java.io.*,ezc.ezutil.*,ezc.ezpreprocurement.params.*,ezc.ezparam.*,java.math.*" %>
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" scope="page"/>
<%@ page import="ezc.ezmisc.params.*,ezc.ezparam.*" %>


<%
	String plantforqry = request.getParameter("vPlant");
	String matforqry = request.getParameter("vMaterial");
	String docTypeforqry = request.getParameter("vdocType");

	String purGrpQry = request.getParameter("purGrp");  
	String matGrpQry = request.getParameter("matGrp"); 
	String matTypeQuery = request.getParameter("matTypeselection");
	String depQry = request.getParameter("dep");

	EzcParams mainParams1 = new EzcParams(false);
	EziMiscParams miscParams = new EziMiscParams();

	StringBuilder qryForDef = new StringBuilder();
	boolean whereStarted = false;


	if (plantforqry != null && !"".equals(plantforqry) && !"null".equalsIgnoreCase(plantforqry) && !"ALL".equalsIgnoreCase(plantforqry)) {
	    qryForDef.append(" where EWKM_PLANT='").append(plantforqry).append("' ");
	    whereStarted = true;
	} else {
	    plantforqry = "ALL";
	}


	if (matGrpQry != null && !"".equals(matGrpQry) && !"null".equalsIgnoreCase(matGrpQry) && !"ALL".equalsIgnoreCase(matGrpQry)) {
	    qryForDef.append(whereStarted ? "AND " : "where ");
	    qryForDef.append("EWKM_CATEGORY='").append(matGrpQry).append("' ");
	    whereStarted = true;
	} else {
	    matGrpQry = "ALL";
	}


	if (docTypeforqry != null && !"".equals(docTypeforqry) && !"null".equalsIgnoreCase(docTypeforqry) && !"ALL".equalsIgnoreCase(docTypeforqry)) {
	    qryForDef.append(whereStarted ? "AND " : "where ");
	    qryForDef.append("EWKM_DOC_TYPE='").append(docTypeforqry).append("' ");
	    whereStarted = true;
	} else {
	    docTypeforqry = "ALL";
	}

	String selQuery = "SELECT EWKM_DOC_TYPE, EWKM_COMP_CODE, EWKM_PLANT, EWKM_CATEGORY, EWKM_TEMPLATE FROM EZC_WF_KEY_MAP " + qryForDef.toString();
	ezc.ezcommon.EzLog4j.log("select query when clicked on GO::::::::::::"+selQuery,"I");
	miscParams.setQuery(selQuery);
	mainParams1.setLocalStore("Y");
	mainParams1.setObject(miscParams);
	Session.prepareParams(mainParams1);

	ReturnObjFromRetrieve retObjWFTemp = null;
	int retObjWFTempCnt = 0;

	try {
	    retObjWFTemp = (ReturnObjFromRetrieve) ezMiscManager.ezSelect(mainParams1);
	} catch(Exception e) {
	    out.println("<p style='color:red;'>Error executing query: " + e.getMessage() + "</p>");
	}

	if (retObjWFTemp != null)
	    retObjWFTempCnt = retObjWFTemp.getRowCount();

	int purLength  = purGrpObj.getRowCount();
	int plantLen   = plantObj.getRowCount(); 
	int matCatLen  = matlCatObj.getRowCount();
%>
<Html>
<Head>
<Script src="../../Library/JavaScript/ezTrim.js" ></script>

</Head>
<style>
	.select2-container--default .select2-selection--multiple {
	    height: 40px;
	    width: 220px;
	    border-radius: 0px;
	} 
</style>
<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
<!-- Content Header (Page header) -->
<section class="content-header">
   <h1>
     Users List
   </h1>
</section>
<!-- Main content -->  
<section class="content">
   <div class="row">
   <!-- left column -->
   <div class="col-md-12 col-xs-12">
   <!-- general form elements -->
   <div class="box box-primary">
      <!-- /.box-header -->

<Body scroll=no>
<Form name="myForm" method="post">
	<table class="table table-striped" style="margin-bottom: 1%;"> 
		<Tr>
			
			<!--<Td>
				<label for="vendor">Vendor</label>   
				  <div >
					  
				  </div>
			</Td> -->
		
		<Th>Plant</Th>
					
		<Td style="width: 100px;">
		    <select name="vPlant" id="vPlant" class="form-control select2" style="width:100% !important">
			<option value="ALL" selected>ALL</option>
			<% 
			 for (int k = 0; k < plantLen; k++) {
			   if (gv_PlantVect.contains(plantObj.getFieldValueString(k, "EP_PLANT").trim())) {
			%>
			    <option value="<%= plantObj.getFieldValueString(k, "EP_PLANT").trim()%>">
				<%= plantObj.getFieldValueString(k, "EP_PLANT").trim()%>-><%= plantObj.getFieldValueString(k, "EP_NAME1") %>
			    </option>
			<% 
			    }
			} 
			%>
		    </select>
		</Td>
		
		<!--<Th>Pur Grp</Th>-->
		    <%
		    // Declare and initialize purGrpFromBack
		    //String purGrpFromBack = request.getParameter("purGrpFromBack");
		    //if (purGrpFromBack == null || "null".equals(purGrpFromBack)) purGrpFromBack = "";
		    %>

			<!--<Td style="width: 100px;">
			    <select name="purGrp" id="purGrp" class="form-control select2" style="width:100% !important">
				<option value="ALL" selected>ALL</option>-->
				<% 
				//for (int j = 0; j < purLength; j++) {
				    //if (gv_PGrpVectAll.contains(purGrpObj.getFieldValueString(j, "VALUE1").trim())) {
				%>
				    <%--<option value="<%= purGrpObj.getFieldValueString(j, "VALUE1").trim() %>">
					<%= purGrpObj.getFieldValueString(j, "VALUE1").trim() %>-><%= purGrpObj.getFieldValueString(j, "VALUE2") %>
				    </option>--%>
				<% 
				   // }
				//} 
				%>
			    <!--</select>
		</Td>-->



		<Th>Mat Category</Th>
		    <%
		    // Declare and initialize purGrpFromBack
		    //String purGrpFromBack = request.getParameter("purGrpFromBack");
		   // if (purGrpFromBack == null || "null".equals(purGrpFromBack)) purGrpFromBack = "";
		    %>

		<Td style="width: 100px;">
			    <select name="matGrp" id="matGrp" class="form-control select2" style="width:100% !important">
				<option value="ALL" selected>ALL</option>
				<% 
				for (int j = 0; j < matCatLen; j++) {
				    
				%>
				    <option value="<%= matlCatObj.getFieldValueString(j, "EWKM_CATEGORY").trim() %>">
					<%= matlCatObj.getFieldValueString(j, "EWKM_CATEGORY") %>
				    </option>
				<% 
				    
				} 
				%>
			    </select>
		</Td>
		<!--<th>Mat Type</th>
			<td style="width: 100px;">  	
			  <div class="input-group">
				 <select name="matTypeselection" id="matTypeselection" class="form-control input-sm" >
				 	<option value="ALL" selected>ALL</option>
					<option value="NBM">NBM</option> 
					<option value="BOM">BOM</option>
				 </select>
			  </div>
		</Td>
		<th>DEP</th>
			<td style="width: 100px;">  	
			  <div class="input-group">
				 <select name="dep" id="dep" class="form-control input-sm" >
				 	<option value="ALL" selected>ALL</option>	
					<option value="NCP">NCP</option> 
					<option value="CPT">CPT</option>
				 </select>
			  </div>
		</Td>-->
		<th>DOC TYPE</th>
					<td style="width: 100px;">  	
					  <div class="input-group">
						 <select name="vdocType" id="vdocType" class="form-control input-sm" >
						 	<option value="ALL" selected>ALL</option>
						 	<option value="VNR">VNR</option>	
							<option value="QCF">QCF</option> 
							<option value="PR_PO">PR-PO</option>
						 </select>
					  </div>
		</Td>


			<Td>
				<button type="button" class="btn btn-primary pull-right" onclick='ezSubmit()' style="margin-right: 5px;">Go <i class="fa fa-paper-plane"></i></button>
  			</Td>
		</Tr>

		</Table>
<br>
	<DIV id="theads">
	<table id="example" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" border=1>
	<thead>
	<Tr>
		<Th>Comp Code</Th>
		<Th>Doc Type</Th>
		<Th>Plant</Th>
		<!--<Th>Pur Grp</Th>-->
		<Th>Category</Th>
		<!--<Th>Mat Type</Th>-->
		<!--<Th>Department</Th>-->
		<Th>Template</Th>
		<Th>WorkFlow Users</Th>
				
	</Tr>
	</thead>
                  <tbody>
	<%
		for(int i=0;i<retObjWFTempCnt;i++)
		{
			String template = retObjWFTemp.getFieldValueString(i,"EWKM_TEMPLATE");
			String compCode = retObjWFTemp.getFieldValueString(i,"EWKM_COMP_CODE");
			String plant	= retObjWFTemp.getFieldValueString(i,"EWKM_PLANT");
			//String purGrp	= retObjWFTemp.getFieldValueString(i,"EWKM_PUR_GRP");
			String category	= retObjWFTemp.getFieldValueString(i,"EWKM_CATEGORY");
			String docType	= retObjWFTemp.getFieldValueString(i,"EWKM_DOC_TYPE");
			//String matType	= retObjWFTemp.getFieldValueString(i,"EWKM_MAT_TYPE");
			//String dept 	= retObjWFTemp.getFieldValueString(i,"EWKM_DEPT");
	%>	 
	        <tr>
			<Td><%=retObjWFTemp.getFieldValueString(i,"EWKM_COMP_CODE")%></Td>	
			<Td><%=retObjWFTemp.getFieldValueString(i,"EWKM_DOC_TYPE")%></Td>	
			<Td><%=retObjWFTemp.getFieldValueString(i,"EWKM_PLANT")%></Td>	
			<!--<Td><%=retObjWFTemp.getFieldValueString(i,"EWKM_PUR_GRP")%></Td>-->	
			<Td><%=retObjWFTemp.getFieldValueString(i,"EWKM_CATEGORY")%></Td>	
			<!--<Td><%=retObjWFTemp.getFieldValueString(i,"EWKM_MAT_TYPE")%></Td>-->	
			<!--<Td><%=retObjWFTemp.getFieldValueString(i,"EWKM_DEPT")%></Td>-->	
			<Td><a href="ezGetWFSteps.jsp?template=<%=template%>"><%=template%></a></Td>	
			<%--<Td><a href="ezWFUsers.jsp?compCode=<%=compCode%>&category=<%=category%>&plant=<%=plant%>&purGrp=<%=purGrp%>&docType=<%=docType%>&matType=<%=matType%>&dept=<%=dept%>&template=<%=template%>">Workflow Users</a></Td>--%>
			<Td><a href="ezUpdateWorkflows.jsp?compCode=<%=compCode%>&category=<%=category%>&plant=<%=plant%>&docType=<%=docType%>&template=<%=template%>">Workflow Users</a></Td>	
		</tr>
	<%
	 
	 	}
	%> 	
	</tbody>
	        </table>
        </div>
</Form>	
</Body>
</section>
<!-- /.content -->
</div><!-- /.content-wrapper --> 

<%@ include file="../Misc/ezFooter.jsp"%>
<%@ include file="../Misc/ezDataTableScript.jsp"%>
<Script>
 $(document).ready( function () {
      
       $("#purGrp").val("<%=purGrpQry%>");
       $("#vPlant").val("<%=plantforqry%>"); 
       $("#matGrp").val("<%=matGrpQry%>");
       $("#vdocType").val("<%= docTypeforqry %>");
       $("#matTypeselection").val("<%=matTypeQuery%>");
       $("#dep").val("<%=depQry%>");
       
   
       
    } );
function ezSubmit() {
	    //alert("Inside ezSubmit::::::::::::::::");
	    //var purGrpValue = document.getElementById("purGrp").value;
	    var plantValue = document.getElementById("vPlant").value;
	    var materialValue = document.getElementById("matGrp").value;
	    
	    var docType = document.getElementById("vdocType").value;
	    document.myForm.action = "ezGetWFTemplates.jsp?vPlant=" + plantValue + "&vMaterial=" + materialValue + "&vdocType=" + docType;
	    document.myForm.submit();
	    //alert("After submit");
	}
</script>