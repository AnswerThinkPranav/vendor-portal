package com.ezc.aragenPR.webapp.model.user;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;


import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import com.ezc.aragenPR.webapp.model.shared.Auditable;
import com.ezc.aragenPR.webapp.model.user.Roles;
import com.ezc.aragenPR.webapp.model.user.UserDefaults;
import com.ezc.aragenPR.webapp.model.user.UserPrivilege;


@Entity
@Table(name="EZC_USERS")
public class Users extends Auditable<String> {

	/**
	 * Natural key shared with the legacy Vendor Portal schema (EU_ID) - login
	 * username and primary key are the same value. This field must stay named
	 * "userId" (not "id") so Spring Data derived queries like findByUserId(...)
	 * and JPQL paths like "b.userId" resolve against a real mapped attribute;
	 * getId()/setId() below simply delegate to it for callers using that name.
	 */
	@Id
	@Column(name="EU_ID", length=10)
	private String userId;

	@Column(name="EU_DELETION_FLAG", length=1)
	private String deletionFlag = "N";

	@Column(name="EU_FIRST_NAME", length=60)
	private String firstName;

	@Column(name="EU_MIDDLE_INITIAL", length=3)
	private String middleInitial;

	@Column(name="EU_LAST_NAME", length=60)
	private String lastName;

	@Column(name="EU_EMAIL", length=200)
	private String email;

	@Column(name="EU_PASSWORD", length=512)
	private String password;

	@Column(name="IS_ENABLED")
	private boolean enabled;

	@Column(name="MUST_CHANGE_PASSWORD")
	private boolean mustChangePassword;

	/** 2=internal/buyer, 3=vendor w/ SAP code, 4=vendor w/ temp code - see UserType. */
	@Column(name="EU_TYPE")
	private Integer userType;

	@Column(name="EUG_ID")
	private Integer userGroupId;

	@Column(name="EU_IS_BUILT_IN_USER", length=1)
	private String isBuiltInUser;

	@Column(name="EU_CURRENT_NUMBER")
	private Long currentNumber;

	@Column(name="EU_CONTACT_NO", length=15)
	private String contactNo;

	@Column(name="EU_LAST_LOGIN_TIME", length=20)
	private String lastLoginTime;

	@Column(name="EU_LAST_LOGIN_DATE", length=10)
	private String lastLoginDate;

	 @ManyToMany(fetch = FetchType.EAGER)
	 @JoinTable(name = "users_roles", joinColumns =
	 			@JoinColumn(name = "user_id", referencedColumnName = "EU_ID"),
	 			inverseJoinColumns = @JoinColumn(name = "role_id", referencedColumnName = "id	")
	 )
	 private Collection<Roles> roles;

	@ManyToMany(fetch = FetchType.EAGER)
	@JoinTable(name = "user_privileges",
			joinColumns = @JoinColumn(name = "user_id", referencedColumnName = "EU_ID"),
			inverseJoinColumns = @JoinColumn(name = "privilege_id", referencedColumnName = "prv_id"))
	private Set<UserPrivilege> privileges = new HashSet<>();

	public Set<UserPrivilege> getPrivileges() {
		return privileges;
	}

	public void setPrivileges(Set<UserPrivilege> privileges) {
		this.privileges = privileges;
	}

	 @OneToMany(mappedBy="users",cascade = CascadeType.ALL,fetch = FetchType.EAGER)
	    private Set<UserDefaults> userDefaults;



		public Set<UserDefaults> getUserDefaults() {
		return userDefaults;
	}

	public void setUserDefaults(Set<UserDefaults> userDefaults) {
		this.userDefaults = userDefaults;
	}

		public Users() {
	    }

	public Collection<Roles> getRoles() {
		return roles;
	}

	public void setRoles(Collection<Roles> roles) {
		this.roles = roles;
	}

	public String getId() {
		return userId;
	}

	public void setId(String id) {
		this.userId = id;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getDeletionFlag() {
		return deletionFlag;
	}

	public void setDeletionFlag(String deletionFlag) {
		this.deletionFlag = deletionFlag;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getMiddleInitial() {
		return middleInitial;
	}

	public void setMiddleInitial(String middleInitial) {
		this.middleInitial = middleInitial;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public boolean isEnabled() {
		return enabled;
	}

	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}

	public boolean isMustChangePassword() {
		return mustChangePassword;
	}

	public void setMustChangePassword(boolean mustChangePassword) {
		this.mustChangePassword = mustChangePassword;
	}

	public Integer getUserType() {
		return userType;
	}

	public void setUserType(Integer userType) {
		this.userType = userType;
	}

	public Integer getUserGroupId() {
		return userGroupId;
	}

	public void setUserGroupId(Integer userGroupId) {
		this.userGroupId = userGroupId;
	}

	public String getIsBuiltInUser() {
		return isBuiltInUser;
	}

	public void setIsBuiltInUser(String isBuiltInUser) {
		this.isBuiltInUser = isBuiltInUser;
	}

	public Long getCurrentNumber() {
		return currentNumber;
	}

	public void setCurrentNumber(Long currentNumber) {
		this.currentNumber = currentNumber;
	}

	public String getContactNo() {
		return contactNo;
	}

	public void setContactNo(String contactNo) {
		this.contactNo = contactNo;
	}

	public String getLastLoginTime() {
		return lastLoginTime;
	}

	public void setLastLoginTime(String lastLoginTime) {
		this.lastLoginTime = lastLoginTime;
	}

	public String getLastLoginDate() {
		return lastLoginDate;
	}

	public void setLastLoginDate(String lastLoginDate) {
		this.lastLoginDate = lastLoginDate;
	}

	@Column(name="EU_BUSINESS_PARTNER", length=10)
	private String vendorCode;
	public String getVendorCode() {
		return vendorCode;
	}
	public void setVendorCode(String vendorCode) {
		this.vendorCode = vendorCode;
	}
	@Override
	public String toString() {
		return "Users [id=" + userId + ", firstName=" + firstName + ", lastName=" + lastName
				+ ", email=" + email + ", enabled=" + enabled + ", userType=" + userType + "]";
	}

	public Users(String userId, String firstName, String lastName, String email, String password, boolean enabled) {
		super();
		this.userId = userId;
		this.firstName = firstName;
		this.lastName = lastName;
		this.email = email;
		this.password = password;
		this.enabled = enabled;
	}
}
