package com.ezc.aragenPR.webapp.model.rfq;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Objects;

public class RfqDetailId implements Serializable {

    private static final long serialVersionUID = 1L;

    private String rfqNo;
    private BigDecimal lineNo;
    private BigDecimal counter;

    public RfqDetailId() {
    }

    public RfqDetailId(String rfqNo, BigDecimal lineNo, BigDecimal counter) {
        this.rfqNo = rfqNo;
        this.lineNo = lineNo;
        this.counter = counter;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof RfqDetailId other)) return false;
        return Objects.equals(rfqNo, other.rfqNo)
                && Objects.equals(lineNo, other.lineNo)
                && Objects.equals(counter, other.counter);
    }

    @Override
    public int hashCode() {
        return Objects.hash(rfqNo, lineNo, counter);
    }
}
