package com.ezc.aragenPR.webapp.model.workflow;

import java.io.Serializable;
import java.util.Objects;

public class WfPricingConditionId implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer template;
    private Integer level;
    private String role;
    private String group;

    public WfPricingConditionId() {
    }

    public WfPricingConditionId(Integer template, Integer level, String role, String group) {
        this.template = template;
        this.level = level;
        this.role = role;
        this.group = group;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof WfPricingConditionId other)) return false;
        return Objects.equals(template, other.template) && Objects.equals(level, other.level)
                && Objects.equals(role, other.role) && Objects.equals(group, other.group);
    }

    @Override
    public int hashCode() {
        return Objects.hash(template, level, role, group);
    }
}
