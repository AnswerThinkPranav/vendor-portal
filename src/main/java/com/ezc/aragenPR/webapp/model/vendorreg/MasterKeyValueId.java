package com.ezc.aragenPR.webapp.model.vendorreg;

import java.io.Serializable;
import java.util.Objects;

public class MasterKeyValueId implements Serializable {

    private static final long serialVersionUID = 1L;

    private String masterType;
    private String key;
    private String value;

    public MasterKeyValueId() {
    }

    public MasterKeyValueId(String masterType, String key, String value) {
        this.masterType = masterType;
        this.key = key;
        this.value = value;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof MasterKeyValueId other)) return false;
        return Objects.equals(masterType, other.masterType)
                && Objects.equals(key, other.key)
                && Objects.equals(value, other.value);
    }

    @Override
    public int hashCode() {
        return Objects.hash(masterType, key, value);
    }
}
