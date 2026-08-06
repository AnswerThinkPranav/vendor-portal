<meta http-equiv="content-type" content="text/html; charset=utf-8">
                <link rel="shortcut icon" type="image/ico" href="http://www.sprymedia.co.uk/media/images/favicon.ico">

                <title>TableTools example</title>
                <style type="text/css" title="currentStyle">
                                @import "../../../../EzCommon/media1/css/demo_page.css";
                               
                                @import "../../../../EzCommon/media1/css/jquery-ui-1.8.4.custom.css";
                                @import "../../../../EzCommon/media1/css/TableTools_JUI.css";
                                @import "../../Library/Styles/demo_table_jui.css";
                                @import "../../Library/Styles/jquery-ui-1.7.2.custom.css";
                                
                                
                </style>
                <script type="text/javascript" charset="utf-8" src="../../../../EzCommon/media1/js/jquery.js"></script>
                <script type="text/javascript" charset="utf-8" src="../../../../EzCommon/media1/js/jquery.dataTables.js"></script>
                <script type="text/javascript" charset="utf-8" src="../../../../EzCommon/media1/js/ZeroClipboard.js"></script>
                <script type="text/javascript" charset="utf-8" src="../../../../EzCommon/media1/js/TableTools.js"></script>
                <script type="text/javascript" charset="utf-8">
                                
			$(document).ready( function () {
					oTable = $('#example').dataTable( {
						"bJQueryUI": true,
						"sPaginationType": "full_numbers",
						"sDom": '<"H"Tfr>t<"F"ip>',
						"oTableTools": {
							"sSwfPath": "../../../../EzCommon/media1/swf/copy_csv_xls_pdf.swf",
							"aButtons": [
									{
											"sExtends":    "xls",
											"sButtonText": "Download as Excel",
											"sTitle": "My title", // Excel file name
											"sToolTip": "Save as Excel"

									},
									{
											"sExtends":    "pdf",
											"sButtonText": "Download as PDF",
											"sTitle": "My title",
											"sToolTip": "Save as PDF"

									}

											]
									}
				} );
			} );
               
               
               
               
               
                </script>
