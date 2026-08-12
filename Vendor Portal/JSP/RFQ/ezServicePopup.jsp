<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />   
<%@ page import="java.io.*,java.util.*,java.math.*" %>
<%@page import="java.sql.*" %>
<%@ page import="ezc.ezcommon.*,java.text.*,ezc.ezparam.*" %>
<%//@ include file="../../../Includes/JSPs/Misc/iLoginBanner.jsp" %>   
<%!
  	public String checkNull(String value){
  		if(value==null || "null".equals(value.trim()))value="";   		
  		return value.trim();
  	}  					  
%>   
<% 
  		ezc.ezutil.FormatDate fd = new ezc.ezutil.FormatDate();
		String req=checkNull(request.getParameter("req"));
		String item=checkNull(request.getParameter("item"));
		String pckgNo=checkNull(request.getParameter("pckgNo"));
		
		ezc.ezparam.ReturnObjFromRetrieve sesServObj= (ezc.ezparam.ReturnObjFromRetrieve)session.getValue("SERVOBJ");
		//ezc.ezcommon.EzLog4j.log("sesServObj:::::::::::::::"+sesServObj.toEzcString(),"I");
		
		int retObjCount=0;
		if(sesServObj!=null)
			retObjCount= sesServObj.getRowCount();		
%>
<head>
	<%@ include file="../Misc/ezPopUpIncludes.jsp"%> 
  </head>
<div id="woModal" class="modal fade" tabindex="-1" role="dialog">
   <div class="modal-dialog">
      <div class="modal-content">
         <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <iframe src="" width="100%" height="220" frameborder="0" allowtransparency="true"></iframe>
         </div>
      </div>
   </div>
</div>
<form method="post" name="myForm">
    <div class="container">
        <div class="row">
            <div>
               <span style="color:rgba(219, 143, 29, 0.808);">
		<h4><B>Service(s) for PR :<span style="color:cornflowerblue;"><%=req%></span> with Item :<span style="color:cornflowerblue;"> <%=Long.parseLong(item)%></span></B></h4>
		</span>
             </div>
         </div>
         <div class="row">
         <div>
	 	<div class="box box-primary">
	  		<div class="box-body">
 				  <table id="example" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
               				<tbody>
						<tr>
							<th>Line</th>
							<th>Service No</th>
							<th>Short Text</th>
							<!--<th>Service Text</th>
							<th>Line Text</th> -->
							<th>Quantity</th>
							<th>UOM</th>
							<th>Gross price</th>
							<!--<th>Currency</th>-->
							<th>Net Value</th>
							
						</tr>
<%
		String  servText="",lineText="";
		for(int i=0;i<retObjCount;i++)
		{	
			String servActive="";
			String lineActive="";
			
			servText=checkNull(sesServObj.getFieldValueString(i,"SERVITEMTXT"));
			ezc.ezcommon.EzLog4j.log("servText:::::::::::::::"+servText,"I");
			servText = servText.replaceAll("'","`");
			servText = servText.replaceAll("\"", "`");
			servText = servText.replaceAll("$", "");
			servText = servText.replaceAll("&", "�");
			servText = servText.replaceAll("<", "&lt;");
			servText = servText.replaceAll("#", "");
			servText = servText.replaceAll("\\(", "");
			servText = servText.replaceAll("\\)", "");
			servText = servText.replaceAll("=", "");			
			servText = servText.trim();
			
			lineText=checkNull(sesServObj.getFieldValueString(i,"SERVLINETXT"));
			lineText = lineText.replaceAll("'","`");
			lineText = lineText.replaceAll("\"", "`");
			lineText = lineText.replaceAll("$", "");
			lineText = lineText.replaceAll("&", "�");
			lineText = lineText.replaceAll("<", "&lt;");
			lineText = lineText.replaceAll("#", "");
			lineText = lineText.replaceAll("\\(", "");
			lineText = lineText.replaceAll("\\)", "");
			lineText = lineText.replaceAll("=", ""); 
			lineText = lineText.trim();			

			
			servActive="color:blue";
			lineActive="color:blue";
			
			if(servText!=null && !"null".equals(servText) && !"".equals(servText) && servText!="")
				servActive="color:orange";
				
			if(lineText!=null && !"null".equals(lineText) && !"".equals(lineText) && lineText!="")
				lineActive="color:orange";
				
			if(pckgNo.equals(sesServObj.getFieldValueString(i,"SERVPCKGNO")))
			{
			
				String servLine = Integer.parseInt(sesServObj.getFieldValueString(i,"EXTLINE"))+"";
				String servAct  = (sesServObj.getFieldValueString(i,"SERVACT"))+"";
				String serUOM  = (sesServObj.getFieldValueString(i,"SERVUOM"))+"";
				if("LE".equals(serUOM))
					serUOM = "AU";
%>			
			
						<tr>
							<td align="center"><%=servLine%></td>
							<td align="center"><%=servAct%></td>
							<td align="center"><%=sesServObj.getFieldValueString(i,"SERVTXT")%></td>
							<!--<td align="center"><a href="javascript:openItemDet('<%=servAct%>','<%=servLine%>','<%=servAct%>','<%=servText%>','S')"> <span style="<%=servActive%>" class="glyphicon glyphicon-new-window"></span> </a></td> 
							<td align="center"><a href="javascript:openItemDet('<%=servAct%>','<%=servLine%>','<%=servAct%>','<%=lineText%>','S')"> <span style="<%=lineActive%>" class="glyphicon glyphicon-new-window"></span> </a></td> -->
							<td align="center"><%=new BigDecimal(sesServObj.getFieldValueString(i,"SERVQTY")).setScale(2,java.math.BigDecimal.ROUND_UP)%></td>
							<td align="center"><%=serUOM%></td>
							<td align="center"><%=new BigDecimal(sesServObj.getFieldValueString(i,"GRPRICE")).setScale(2,java.math.BigDecimal.ROUND_UP)%></td>
							
							<!--<td><%=sesServObj.getFieldValueString(i,"SERVUOM")%></td>-->
							<td align="center"><%=new BigDecimal(sesServObj.getFieldValueString(i,"NETVAL")).setScale(2,java.math.BigDecimal.ROUND_UP)%></td>
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
        </div>
        <div class="row" align="right" >
            <button type="button" class="btn btn-primary" onclick="funClose()">CLOSE</button>
          
        </div>
    </div>
</form>  
 
      
 
  <script>
  $(document).ready( function () {
  	   	
  	       $('#example').dataTable( {
  	       "order":[[4,"desc"]],
  	       "bInfo": false,
  	       "bPaginate": false,
  	       "bAutoWidth": false ,
  	   	"lengthMenu": [[10, 20, -1], [10, 20, 'All']]
  	      
  	   	
  	   	
  	       } );
   } );
   function funClose()
   {
   
           window.parent.$('#woModal1').modal('hide');
           window.parent.$('#woModal2').modal('hide');
           parent.$.fancybox.close();
   }
   function openItemDet(req,item,mat,text,type)
   { 
   	var url="ezItemTextPopup.jsp?req="+req+"&item="+item+"&mat="+mat+"&text="+text+"&type="+type;      

		$('iframe').attr("src",url);
		

		$('#woModal').modal({show:true});
		$('.modal-dialog').draggable({
				    handle: ".modal-body"        
  		});   		
   
   }    
   </script>
</body>
</html>
	