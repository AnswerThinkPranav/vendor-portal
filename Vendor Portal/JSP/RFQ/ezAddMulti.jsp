<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<Html>
<Head>
<base target="_self">
<!--<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">-->
<link rel="stylesheet" href="../../../../EzCommon/Library/dist/css/AdminLTE.min.css">
<link rel="stylesheet" href="../../../../EzCommon/Library/bootstrap/css/bootstrap.min.css">
<script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>
<script src="../../../../EzCommon/Library/plugins/jQueryUI/jquery-ui.min.js"></script>
<script src="../../../../EzCommon/Library/bootstrap/js/bootstrap.min.js"></script>
<script>
var parentObj="";
var docObj="";



function funClose()
{
	window.parent.closeModal();
}
function funAddLine(nameVal)
{
	var tabObj		= document.getElementById("example")
	var rowItems 		= tabObj.getElementsByTagName("tr");
	var rowCountValue 	= rowItems.length;
	
		
	
	
	eleAlign = new Array();
	eleVal   = new Array();

	eleAlign[0] = "center";
	
	eleVal[0] ='<input type="text" class="form-control input-sm" name="'+nameVal+'" id="'+nameVal+'_'+(rowCountValue-1)+'" value="">';
	
	var rowId = tabObj.insertRow(rowCountValue);
	for(i=0; i<eleVal.length;i++){
		var cell0=rowId.insertCell(i);
		cell0.align = eleAlign[i];
		cell0.innerHTML =eleVal[i];
	}
}
function funOk(nameVal)
{
	var fieldObj = eval("document.myForm."+nameVal);
	var purReqVal;
	for(var i=0; i<fieldObj.length; i++)
	{
		if(fieldObj[i].value!='')
		{
			if(!purReqVal)
			{
				purReqVal = fieldObj[i].value;
			}
			else
			{
				purReqVal = purReqVal+","+ fieldObj[i].value;
			}
		}
		
	}
	if(!purReqVal)
	{
		alert("Please fill in the fields!");
		return false;
	}
	eval("parent.document.myForm."+nameVal).value=purReqVal;
	window.parent.closeModal();
}

</script>
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
</head>
<%
	String nameVal=request.getParameter("nameVal"); 
	String headVal=request.getParameter("headVal");
	String fieldVal =request.getParameter("fieldVal");
	//out.println(nameVal);
	java.util.ArrayList fieldValAL = new java.util.ArrayList();
	if(fieldVal!=null && !"".equals(fieldVal))
	{	
		if(fieldVal.contains(","))
		{
			java.util.StringTokenizer fieldValST =new java.util.StringTokenizer(fieldVal, ",");
			while( fieldValST.hasMoreTokens() )
			{
				fieldValAL.add(fieldValST.nextToken());
			}
		}
		else
		{
			fieldValAL.add(fieldVal);
		}
		
			
	}
%>

<body scroll=no>
<form name="myForm">
<!-- Content Wrapper. Contains page content -->
      <div class="content-wrapper" style="margin-left: 0px !important;">
        <!-- Content Header (Page header) -->
        <section class="content-header">
          <h1>
           Add Multiple <%=headVal%>
          </h1>
        </section>

        <!-- Main content -->
        <section class="content">
        <div class="row">
	
	<div class="box box-primary">
	<div class="box-body">
	<table id="example" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%" style="width: 55%;margin-left: auto;margin-right:auto;">
	<thead>
		<tr>
			<th><%=headVal%></th>
		</tr>
	</thead>
	<tbody>
<%
		int loopLength=5;
		if(fieldValAL.size()>0)
		{
			loopLength=fieldValAL.size();
		}
		String alValue="";
		//out.println(fieldValAL);
		for(int i=0; i<loopLength; i++)
		{
			alValue="";
			if(!fieldValAL.isEmpty() && fieldValAL.get(i)!=null) 
			{
				alValue= (String)fieldValAL.get(i);
			}
			

%>

			<tr>
				<td>
					<input type="text" class="form-control input-sm"   id="<%=nameVal%>_<%=i%>" name="<%=nameVal%>" value="<%=alValue%>" maxlength="10">
				</td>
			</tr>
<%
		}

%>
	</tbody>

	</table>

	
</div>
</div>
</div>
<table width="90%">
<tr><td class="blankcell"><hr></td>
<tr><td class="blankcell">
<div class="col-xs-12" align="center">
		<button type="button" onclick="funOk('<%=nameVal%>')" class="btn btn-primary " style="left: 50%;"> OK</button>
		<button type="button" onclick="funAddLine('<%=nameVal%>')" class="btn btn-primary " style="left: 50%;"> Add Line</button>
		<button type="button" onclick="funClose()" class="btn btn-primary " style="left: 50%;"> Close</button>

		</div>
</td>
<tr><td class="blankcell"><hr></td>
</tr></table>

</form>
  </section><!-- /.content -->
      </div><!-- /.content-wrapper --> 
      

</Body>
</Html>
