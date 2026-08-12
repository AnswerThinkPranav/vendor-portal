package com.ezc.aragenPR.webapp.model.rfq;

import java.io.Serializable;
import java.util.Objects;

public class RfqPrId implements Serializable {

    private static final long serialVersionUID = 1L;

    private String qcfNo;
    private String rfqLineNo;
    private String prNo;
    private String prItem;

    public RfqPrId() {
    }

    public RfqPrId(String qcfNo, String rfqLineNo, String prNo, String prItem) {
        this.qcfNo = qcfNo;
        this.rfqLineNo = rfqLineNo;
        this.prNo = prNo;
        this.prItem = prItem;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof RfqPrId other)) return false;
        return Objects.equals(qcfNo, other.qcfNo)
                && Objects.equals(rfqLineNo, other.rfqLineNo)
                && Objects.equals(prNo, other.prNo)
                && Objects.equals(prItem, other.prItem);
    }

    @Override
    public int hashCode() {
        return Objects.hash(qcfNo, rfqLineNo, prNo, prItem);
    }
}
