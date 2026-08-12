package com.ezc.aragenPR.webapp.model.vendorreg;

import java.io.Serializable;
import java.util.Objects;

public class UserDefKeyValueId implements Serializable {

    private static final long serialVersionUID = 1L;

    private String userId;
    private String sysKey;
    private String key;
    private String value;

    public UserDefKeyValueId() {
    }

    public UserDefKeyValueId(String userId, String sysKey, String key, String value) {
        this.userId = userId;
        this.sysKey = sysKey;
        this.key = key;
        this.value = value;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof UserDefKeyValueId other)) return false;
        return Objects.equals(userId, other.userId)
                && Objects.equals(sysKey, other.sysKey)
                && Objects.equals(key, other.key)
                && Objects.equals(value, other.value);
    }

    @Override
    public int hashCode() {
        return Objects.hash(userId, sysKey, key, value);
    }
}
