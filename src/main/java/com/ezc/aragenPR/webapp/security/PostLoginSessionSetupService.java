package com.ezc.aragenPR.webapp.security;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.ezc.aragenPR.webapp.model.user.UserDefaults;
import com.ezc.aragenPR.webapp.model.user.UserType;
import com.ezc.aragenPR.webapp.model.user.Users;
import com.ezc.aragenPR.webapp.repository.user.UserRepository;

import jakarta.servlet.http.HttpSession;

/**
 * Reproduces the legacy ezDesclaimerConfirm.jsp post-login setup (usertype, defaults,
 * vendor/business-partner link) as a single structured HttpSession attribute, and stamps
 * EU_LAST_LOGIN_TIME/EU_LAST_LOGIN_DATE for legacy parity. Does NOT implement the
 * EU_TYPE-based dashboard redirect (buyer vs. vendor vs. temp-vendor landing) - both
 * usertypes continue to land on the existing /dashboard/index page.
 */
@Component
public class PostLoginSessionSetupService {

	private static final Logger log = LoggerFactory.getLogger(PostLoginSessionSetupService.class);

	public static final String SESSION_ATTRIBUTE = "userSessionContext";

	private static final String KEY_COMPCODE = "COMPCODE";
	private static final String KEY_ALLOW_RFQ = "ALLOW_RFQ";
	private static final String KEY_ALLOW_REG = "ALLOW_REG";
	private static final String KEY_PP_WF_GRP = "PP_WF_GRP";
	private static final String KEY_SOLDTOPARTY = "SOLDTOPARTY";

	@Autowired
	private UserRepository userRepository;

	public void populate(HttpSession session, Users user) {
		Map<String, String> defaults = toDefaultsMap(user.getUserDefaults());

		log.info("[LOGIN-DEBUG] userId={} raw EZC_USER_DEFAULTS rows ({} total):", user.getUserId(), defaults.size());
		defaults.forEach((key, value) -> log.info("[LOGIN-DEBUG]   {} = {}", key, value));

		UserSessionContext ctx = new UserSessionContext();
		ctx.setUserType(user.getUserType());
		ctx.setBusinessPartner(user.getVendorCode());
		ctx.setCompCode(defaults.get(KEY_COMPCODE));

		if (UserType.VENDOR_TEMP == UserType.fromCode(user.getUserType())) {
			ctx.setAllowRfq(defaults.get(KEY_ALLOW_RFQ));
			ctx.setAllowReg(defaults.get(KEY_ALLOW_REG));
			ctx.setPpWfGrp(defaults.get(KEY_PP_WF_GRP));
			ctx.setSoldTo(defaults.get(KEY_SOLDTOPARTY));
		}

		session.setAttribute(SESSION_ATTRIBUTE, ctx);
		log.info("[LOGIN-DEBUG] userId={} session attribute '{}' = {}", user.getUserId(), SESSION_ATTRIBUTE, ctx);

		stampLastLogin(user);
	}

	private Map<String, String> toDefaultsMap(Set<UserDefaults> userDefaults) {
		if (userDefaults == null) {
			return Map.of();
		}
		return userDefaults.stream()
				.filter(d -> d.getKey() != null && d.getValue() != null)
				.collect(Collectors.toMap(UserDefaults::getKey, UserDefaults::getValue, (a, b) -> a));
	}

	private void stampLastLogin(Users user) {
		Date now = new Date();
		user.setLastLoginDate(new SimpleDateFormat("dd-MM-yyyy").format(now));
		user.setLastLoginTime(new SimpleDateFormat("HH:mm:ss").format(now));
		userRepository.save(user);
	}
}
