<%@ page import = "ezc.ezcommon.*" %>
<%@ page import = "ezc.ezparam.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%
	String index = request.getParameter("myIndex");
	String selPlant = request.getParameter("selPlant");
	String SAP = request.getParameter("SAP");

%>
<Html>
<Head>
<base target="_self">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
<link rel="stylesheet" href="../../../../EzCommon/Library/dist/css/AdminLTE.min.css">
<link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/bootstrap.min.css">
<script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>
<script src="../../../../EzCommon/Library/plugins/jQueryUI/jquery-ui.min.js"></script>
<script src="../../../../EzCommon/Library/bootstrap/js/bootstrap.min.js"></script>
<style>
th
{
	    background-color: #3c8dbc;
	    color:white;
}
button
{
	margin-left:2px;
}
</style>
<Script src="../../Library/JavaScript/ezTrim.js"></Script>

<script>
	function search1()
	{
		
		if(!document.myForm.sapSearchType[0].checked && !document.myForm.sapSearchType[1].checked)
		{
			alert('Please select SAP search type')
			return
		}

		if(document.myForm.sapSearchType[0].checked && document.myForm.sapMatNo.value=='')
		{
			alert('Please enter material')
			document.myForm.sapMatNo.focus()
			return
		}
		if(document.myForm.sapSearchType[1].checked && document.myForm.sapMatDesc.value=='')
		{
			alert('Please enter material description')
			document.myForm.sapMatDesc.focus()
			return
		}

		if(document.myForm.sapSearchType[0].checked)
		{
			var url = "ezReturnableContainerMtrlSearch.jsp?matCode="+document.myForm.sapMatNo.value+"&myIndex=<%=index%>&searchType=CODE&matDesc=NA&selPlant="+"<%=selPlant%>";
			document.myForm.action=url
			document.myForm.submit()
			
		}
		else if(document.myForm.sapSearchType[1].checked)
		{
			var url = "ezReturnableContainerMtrlSearch.jsp?matCode="+document.myForm.sapMatNo.value+"&myIndex=<%=index%>&searchType=DESC&matDesc="+document.myForm.sapMatDesc.value+"&selPlant="+"<%=selPlant%>";
			document.myForm.action=url
			document.myForm.submit()
			
		}
	}

	function selectDef1(type,val)
	{
		if(type=='SAP')
		{
			if(val=='MAT')
			{
				document.myForm.sapSearchType[0].checked = true
			}
			else if(val=='DES')
			{
				document.myForm.sapSearchType[1].checked = true
			}
		
		}
	}
	function KeySubmit()
	{
		if (event.keyCode==13 && '<%=SAP%>'=='Y')
		{
			search1()
		}
	}	
</script>
</head>

<body>
<form name="myForm" method="post">
<input type="hidden" name="index" value="<%=index%>">
<input type="hidden" name="SAP" value="<%=SAP%>">

<!-- Content Wrapper. Contains page content -->
      <div class="content-wrapper" style="margin-left: 0px !important;">
        <!-- Content Header (Page header) -->
        <section class="content-header">
          <h1>
            Material Search
          </h1>
        </section>

        <!-- Main content -->
        <section class="content">
        <div class="row">
	<div class="col-md-12 col-xs-12">
	<div class="box box-primary">
	<div class="box-body">
	<table class="table table-bordered" id="ezRCItemTab1">
	<Tr>
		<Th width="10%" align="right"><input type="radio" name="sapSearchType" value="MAT" ></Th>
		<Th width="40%" align="right">Material</Th>
		<Td width="50%"><input type="text" name="sapMatNo" class="InputBox" size="14" maxlength="18" value="" onFocus="selectDef1('SAP','MAT')" onKeyPress="KeySubmit()"></Td>
	</Tr>
	<Tr>
		<Th width="10%" align="right"><input type="radio" name="sapSearchType" value="DES" ></Th>
		<Th width="40%" align="right">Description</Th>
		<Td width="50%"><input type="text" name="sapMatDesc" class="InputBox" size="14" maxlength="18" value="" onFocus="selectDef1('SAP','DES')" onKeyPress="KeySubmit()"></Td>
	</Tr>
</Table>
<div style="margin-top:2%;margin-bottom:2%">
	<button type="button" class="btn btn-primary pull-right" onclick="window.parent.closeIframe()"><i class="fa fa-remove"></i>&nbsp;Close</button>
	<button type="button"  class="btn btn-primary pull-right" onclick="search1()"><i class="fa fa-search-plus"></i>&nbsp;Search</button>
</div>
</div></div></div></div>
        </section><!-- /.content -->
      </div><!-- /.content-wrapper --> 
      		
</form>
</Body>
</Html>
