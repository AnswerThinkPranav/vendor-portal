package com.ezc.aragenPR.webapp.model.rfq;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Objects;

public class RfqQuoteHistoryId implements Serializable {

    private static final long serialVersionUID = 1L;

    private String vendor;
    private String rfqNo;
    private BigDecimal lineNo;
    private BigDecimal counter;
    private String condCode;
    private String seqNo;

    public RfqQuoteHistoryId() {
    }

    public RfqQuoteHistoryId(String vendor, String rfqNo, BigDecimal lineNo, BigDecimal counter,
                              String condCode, String seqNo) {
        this.vendor = vendor;
        this.rfqNo = rfqNo;
        this.lineNo = lineNo;
        this.counter = counter;
        this.condCode = condCode;
        this.seqNo = seqNo;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof RfqQuoteHistoryId other)) return false;
        return Objects.equals(vendor, other.vendor)
                && Objects.equals(rfqNo, other.rfqNo)
                && Objects.equals(lineNo, other.lineNo)
                && Objects.equals(counter, other.counter)
                && Objects.equals(condCode, other.condCode)
                && Objects.equals(seqNo, other.seqNo);
    }

    @Override
    public int hashCode() {
        return Objects.hash(vendor, rfqNo, lineNo, counter, condCode, seqNo);
    }
}
