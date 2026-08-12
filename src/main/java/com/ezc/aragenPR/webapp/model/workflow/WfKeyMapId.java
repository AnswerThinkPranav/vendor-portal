package com.ezc.aragenPR.webapp.model.workflow;

import java.io.Serializable;
import java.util.Objects;

public class WfKeyMapId implements Serializable {

    private static final long serialVersionUID = 1L;

    private String docType;
    private String compCode;
    private String plant;
    private String category;

    public WfKeyMapId() {
    }

    public WfKeyMapId(String docType, String compCode, String plant, String category) {
        this.docType = docType;
        this.compCode = compCode;
        this.plant = plant;
        this.category = category;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof WfKeyMapId other)) return false;
        return Objects.equals(docType, other.docType) && Objects.equals(compCode, other.compCode)
                && Objects.equals(plant, other.plant) && Objects.equals(category, other.category);
    }

    @Override
    public int hashCode() {
        return Objects.hash(docType, compCode, plant, category);
    }
}
