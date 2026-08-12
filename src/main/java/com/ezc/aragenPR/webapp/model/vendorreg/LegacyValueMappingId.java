package com.ezc.aragenPR.webapp.model.vendorreg;

import java.io.Serializable;
import java.util.Objects;

public class LegacyValueMappingId implements Serializable {

    private static final long serialVersionUID = 1L;

    private String mapType;
    private String value1;
    private String value2;

    public LegacyValueMappingId() {
    }

    public LegacyValueMappingId(String mapType, String value1, String value2) {
        this.mapType = mapType;
        this.value1 = value1;
        this.value2 = value2;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof LegacyValueMappingId other)) return false;
        return Objects.equals(mapType, other.mapType)
                && Objects.equals(value1, other.value1)
                && Objects.equals(value2, other.value2);
    }

    @Override
    public int hashCode() {
        return Objects.hash(mapType, value1, value2);
    }
}
