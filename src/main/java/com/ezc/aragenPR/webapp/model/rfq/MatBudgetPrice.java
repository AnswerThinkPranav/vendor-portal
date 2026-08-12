package com.ezc.aragenPR.webapp.model.rfq;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Table;

import lombok.Data;

/** Mirrors the legacy Vendor Portal EZC_MAT_BUDGET_PRICE table (see db.sql) - the "Budget Price" column on the Quotation Comparison Form. */
@Entity
@Table(name = "ezc_mat_budget_price")
@IdClass(MatBudgetPriceId.class)
@Data
public class MatBudgetPrice {

    @Id
    @Column(name = "EMBP_FIN_YEAR", length = 8)
    private String finYear;

    @Id
    @Column(name = "EMBP_MONTH", length = 2)
    private String month;

    @Id
    @Column(name = "EMBP_PLANT", length = 4)
    private String plant;

    @Id
    @Column(name = "EMBP_MATERIAL", length = 40)
    private String material;

    @Column(name = "EMBP_BASIC_PRICE", length = 15)
    private String basicPrice;

    @Column(name = "EMBP_LANDED_PRICE", length = 15)
    private String landedPrice;
}
