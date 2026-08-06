<%
	if("S".equals(dispMsgType))
	{
%>
		<center>
			<div class="alert alert-success" style="width:<%=divWidth%>">
			<h4><i class="icon fa fa-check"></i> Success</h4>
				<%=dispMessage%>
			</div>
		</center>
<%
	}else if("E".equals(dispMsgType)){
%>
		<center>
			<div class="alert alert-error" style="width:<%=divWidth%>">
			<h4><i class="icon fa fa-check"></i> Failed</h4>
				<%=dispMessage%>
			</div>
		</center>
<% 
	}
%>