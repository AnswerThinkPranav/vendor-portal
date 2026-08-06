package com.ezc.aragenPR.webapp.model.user;

import java.io.Serializable;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinColumns;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import lombok.AllArgsConstructor;
import lombok.Data;
import com.ezc.aragenPR.webapp.model.user.UserDefaultsKey;
import com.ezc.aragenPR.webapp.model.user.Users;

@Entity
@Table(name="EZC_USER_DEFAULTS")
@Data
@AllArgsConstructor
@IdClass(UserDefaultsKey.class)
public class UserDefaults implements Serializable{


	/**
	 *
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name="EUD_USER_ID",length=10)
	private String userId;

	@Id
	@Column(name="EUD_KEY",length=16)
	private String key;

	@ManyToOne
    @JoinColumns({
            @JoinColumn(name="EUD_USER_ID", referencedColumnName="EU_ID",insertable = false,updatable = false),
    })

    private Users users;


	@Column(name="EUD_VALUE",length=500)
	private String value;

	/** Fixed constant - Aragen only targets one downstream system, unlike the legacy multi-SAP-system routing. */
	@Column(name="EUD_SYS_KEY",length=18)
	private String sysKey = "DEFAULT";

	@Column(name="EUD_CUST_NO",length=10)
	private String custNo;

	@Column(name="EUD_DEFAULT_FLAG",length=1)
	private String defaultFlag;

	@Column(name="EUD_IS_USERA_KEY",length=1)
	private String isUserAKey;

	public UserDefaults() {


	}

	}
