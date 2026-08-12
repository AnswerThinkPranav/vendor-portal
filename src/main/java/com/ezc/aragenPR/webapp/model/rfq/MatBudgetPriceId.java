package com.ezc.aragenPR.webapp.model.rfq;

import java.io.Serializable;
import java.util.Objects;

public class MatBudgetPriceId implements Serializable {

    private static final long serialVersionUID = 1L;

    private String finYear;
    private String month;
    private String plant;
    private String material;

    public MatBudgetPriceId() {
    }

    public MatBudgetPriceId(String finYear, String month, String plant, String material) {
        this.finYear = finYear;
        this.month = month;
        this.plant = plant;
        this.material = material;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof MatBudgetPriceId other)) return false;
        return Objects.equals(finYear, other.finYear) && Objects.equals(month, other.month)
                && Objects.equals(plant, other.plant) && Objects.equals(material, other.material);
    }

    @Override
    public int hashCode() {
        return Objects.hash(finYear, month, plant, material);
    }
}
