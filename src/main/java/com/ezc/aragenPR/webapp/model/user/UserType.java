package com.ezc.aragenPR.webapp.model.user;

/**
 * Mirrors the legacy Vendor Portal EU_TYPE codes on EZC_USERS.
 * Not JPA-mapped - Users.userType stays a plain Integer to avoid converter
 * complexity for a single-digit legacy column; this is a lookup helper only.
 */
public enum UserType {

	BUYER(2),
	VENDOR_SAP(3),
	VENDOR_TEMP(4);

	private final int code;

	UserType(int code) {
		this.code = code;
	}

	public int getCode() {
		return code;
	}

	public static UserType fromCode(Integer code) {
		if (code == null) {
			return null;
		}
		for (UserType type : values()) {
			if (type.code == code) {
				return type;
			}
		}
		return null;
	}
}
