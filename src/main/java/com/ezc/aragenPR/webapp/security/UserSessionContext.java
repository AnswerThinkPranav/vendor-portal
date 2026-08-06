package com.ezc.aragenPR.webapp.security;

import java.io.Serializable;

/**
 * Post-login session state, replacing the legacy ezDesclaimerConfirm.jsp's dozens of
 * scattered session.setAttribute(...) calls with one structured object stored under a
 * single HttpSession attribute. See PostLoginSessionSetupService for how this is built.
 */
public class UserSessionContext implements Serializable {

	private static final long serialVersionUID = 1L;

	private Integer userType;
	private String businessPartner;
	private String compCode;

	// Only populated for userType == VENDOR_TEMP (legacy EU_TYPE "4"), mirroring
	// ezDesclaimerConfirm.jsp's type-4-only branch.
	private String allowRfq;
	private String allowReg;
	private String ppWfGrp;
	private String soldTo;

	public Integer getUserType() {
		return userType;
	}

	public void setUserType(Integer userType) {
		this.userType = userType;
	}

	public String getBusinessPartner() {
		return businessPartner;
	}

	public void setBusinessPartner(String businessPartner) {
		this.businessPartner = businessPartner;
	}

	public String getCompCode() {
		return compCode;
	}

	public void setCompCode(String compCode) {
		this.compCode = compCode;
	}

	public String getAllowRfq() {
		return allowRfq;
	}

	public void setAllowRfq(String allowRfq) {
		this.allowRfq = allowRfq;
	}

	public String getAllowReg() {
		return allowReg;
	}

	public void setAllowReg(String allowReg) {
		this.allowReg = allowReg;
	}

	public String getPpWfGrp() {
		return ppWfGrp;
	}

	public void setPpWfGrp(String ppWfGrp) {
		this.ppWfGrp = ppWfGrp;
	}

	public String getSoldTo() {
		return soldTo;
	}

	public void setSoldTo(String soldTo) {
		this.soldTo = soldTo;
	}

	@Override
	public String toString() {
		return "UserSessionContext [userType=" + userType + ", businessPartner=" + businessPartner
				+ ", compCode=" + compCode + ", allowRfq=" + allowRfq + ", allowReg=" + allowReg
				+ ", ppWfGrp=" + ppWfGrp + ", soldTo=" + soldTo + "]";
	}
}
