package com.ezc.aragenPR.webapp.model.rfq;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Objects;

public class RfqItemConditionId implements Serializable {

    private static final long serialVersionUID = 1L;

    private String vendor;
    private String rfqNo;
    private BigDecimal lineNo;
    private String taxCode;
    private String seqNo;

    public RfqItemConditionId() {
    }

    public RfqItemConditionId(String vendor, String rfqNo, BigDecimal lineNo, String taxCode, String seqNo) {
        this.vendor = vendor;
        this.rfqNo = rfqNo;
        this.lineNo = lineNo;
        this.taxCode = taxCode;
        this.seqNo = seqNo;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof RfqItemConditionId other)) return false;
        return Objects.equals(vendor, other.vendor)
                && Objects.equals(rfqNo, other.rfqNo)
                && Objects.equals(lineNo, other.lineNo)
                && Objects.equals(taxCode, other.taxCode)
                && Objects.equals(seqNo, other.seqNo);
    }

    @Override
    public int hashCode() {
        return Objects.hash(vendor, rfqNo, lineNo, taxCode, seqNo);
    }
}
