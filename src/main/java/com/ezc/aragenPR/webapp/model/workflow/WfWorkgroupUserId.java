package com.ezc.aragenPR.webapp.model.workflow;

import java.io.Serializable;
import java.util.Objects;

public class WfWorkgroupUserId implements Serializable {

    private static final long serialVersionUID = 1L;

    private String group;
    private String user;
    private String sysKey;

    public WfWorkgroupUserId() {
    }

    public WfWorkgroupUserId(String group, String user, String sysKey) {
        this.group = group;
        this.user = user;
        this.sysKey = sysKey;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof WfWorkgroupUserId other)) return false;
        return Objects.equals(group, other.group) && Objects.equals(user, other.user) && Objects.equals(sysKey, other.sysKey);
    }

    @Override
    public int hashCode() {
        return Objects.hash(group, user, sysKey);
    }
}
