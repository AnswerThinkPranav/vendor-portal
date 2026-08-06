<div class="box box-success">
						<div class="box-header  with-border" >
							<h3 class="box-title"><B>&nbsp;&nbsp Alerts</B></h3>
						</div>

						<div class="box-body chat" id="chat-box">
						<%
						if("3".equals(userType))
						{
							if(getConfirmationAlertsRetObjCnt>0)
							{
								for(int i=0 ;i<getConfirmationAlertsRetObjCnt;i++)
								{
									String dispText = "Confirm Your A/C statement period from ";
									String confId 	= getConfirmationAlertsRetObj.getFieldValueString(i,"EASCH_ID");
									String remarks 	= getConfirmationAlertsRetObj.getFieldValueString(i,"EASCH_REMARKS");
									String fromDateAlert	= getDateForDateObj((java.util.Date)getConfirmationAlertsRetObj.getFieldValue(i,"EASCH_FROM"));
									String toDateAlert 	= getDateForDateObj((java.util.Date)getConfirmationAlertsRetObj.getFieldValue(i,"EASCH_TO"));

									dispText 	= dispText+fromDateAlert+" to "+toDateAlert;
							%>

									<p class="message">
									<img src="arrow.gif" alt="More Info">
									<a href="../Confirmations/ezGetAccStmtToConfirm.jsp?confId=<%=confId%>&fromDateAlert=<%=fromDateAlert%>&toDateAlert=<%=toDateAlert%>"><%=dispText%>
									</p>
							<%

							}
							%>
							<div>
							<p class="message">
							<img src="arrow.gif" alt="More Info">
							<a href="ezVendorDetails.jsp">Click here to update GSTIN
							</p>
							</div>
							<%
							}

							if(vendConformationRetObjCnt==0)
							{
							%>
								<div id="venConf">
								<p class="message">
								<img src="arrow.gif" alt="More Info">
								<a id="complexConfirm" href="javascript:funConfirmVendProfile();">Confirm Is your profile correctly capturing your details?
								</p>
								</div>
							<%
							}

						}
						%>

							<br><br><br><br><br>
						</div>
			</div>









<input type="hidden" name="vendCode" id="vendCode" value="<%=LIFNR%>" />
<input type="hidden" name="compCode" id="compCode" value="<%=BUKRS%>" />
<input type="hidden" name="serBased" id="serBased" value="<%=LEBRE%>" />
<input type="hidden" name="procGrp" id="procGrp" value="<%=DLGRP%>" />
<input type="hidden" name="venName" id="venName" value="<%=NAME1+NAME2%>" />
<input type="hidden" name="grBased" id="grBased" value="<%=WEBRE%>" />
<input type="hidden" name="name1" id="name1" value="<%=NAME1%>" />
<input type="hidden" name="name2" id="name2" value="<%=NAME2%>" />
<input type="hidden" name="addr1" id="addr1" value="<%=NAME3%>" />
<input type="hidden" name="addr2" id="addr2" value="<%=NAME4%>" />
<input type="hidden" name="street" id="street" value="<%=STRAS%>" />
<input type="hidden" name="city" id="city" value="<%=ORT01%>" />
<input type="hidden" name="state" id="state" value="<%=REGIO%>" />
<input type="hidden" name="country" id="country" value="<%=LAND1%>" />
<input type="hidden" name="district" id="district" value="<%=ORT02%>" />
<input type="hidden" name="pin" id="pin" value="<%=PSTLZ%>" />
<input type="hidden" name="landline" id="landline" value="<%=TELF2%>" />
<input type="hidden" name="mobile" id="mobile" value="<%=TELF1%>" />
<input type="hidden" name="fax" id="fax" value="<%=TELFX%>" />
<input type="hidden" name="email" id="email" value="<%=SMTP_ADDR%>" />
<input type="hidden" name="contPers1" id="contPers1" value="<%=NAMEV%>" />
<input type="hidden" name="contPers2" id="contPers2" value="<%=NAME1ConInfo%>" />
<input type="hidden" name="vat" id="vat" value="<%=STCEG%>" />
<input type="hidden" name="cst" id="cst" value="<%=J_1ICSTNO%>" />
<input type="hidden" name="pan" id="pan" value="<%=J_1IPANNO%>" />
<input type="hidden" name="servTax" id="servTax" value="<%=J_1ISERN%>" />
<input type="hidden" name="eccNo" id="eccNo" value="<%=J_1IEXCD%>" />
<input type="hidden" name="excRegNo" id="excRegNo" value="<%=J_1IEXRN%>" />
<input type="hidden" name="rangeSel" id="rangeSel" value="<%=J_1IEXRG%>" />
<input type="hidden" name="exDiv" id="exDiv" value="<%=J_1IEXDI%>" />
<input type="hidden" name="commi" id="commi" value="<%=J_1IEXCO%>" />
<input type="hidden" name="minIndi" id="minIndi" value="<%=MINDK%>" />
<input type="hidden" name="gst" id="gst" value="" />
<input type="hidden" name="classification" id="classification" value="" />
<input type="hidden" name="bankCountry" id="bankCountry" value="<%=BANKS%>" />
<input type="hidden" name="bankName" id="bankName" value="<%=BANKA%>" />
<input type="hidden" name="bankRegion" id="bankRegion" value="<%=PROVZ%>" />
<input type="hidden" name="bankStreet" id="bankStreet" value="<%=STRASBank%>" />
<input type="hidden" name="bankCity" id="bankCity" value="<%=ORT01Bank%>" />
<input type="hidden" name="bankBranch" id="bankBranch" value="<%=BRNCH%>" />
<input type="hidden" name="bankIFSCCode" id="bankIFSCCode" value="<%=BKREF%>" />
<input type="hidden" name="bankACCode" id="bankACCode" value="<%=BANKN%>" />
<input type="hidden" name="bankCurrency" id="bankCurrency" value="<%=WAERS%>" />
<input type="hidden" name="pTerms" id="pTerms" value="<%=ZTERMComp%>" />
<input type="hidden" name="paymMethod" id="paymMethod" value="<%=ZWELS%>" />
<input type="hidden" name="creatDate" id="creatDate" value="<%=CERDT%>" />
<input type="hidden" name="houseBank" id="houseBank" value="<%=HBKID%>" />
<input type="hidden" name="schemaGroup" id="schemaGroup" value="<%=KALSK%>" />
<input type="hidden" name="titleSel" id="titleSel" value="<%=ANRED%>" />