package com.ezc.aragenPR.webapp.model.workflow;

import java.io.Serializable;
import java.util.Objects;

public class WfDocHistoryHeaderId implements Serializable {

    private static final long serialVersionUID = 1L;

    private String authKey;
    private String docId;

    public WfDocHistoryHeaderId() {
    }

    public WfDocHistoryHeaderId(String authKey, String docId) {
        this.authKey = authKey;
        this.docId = docId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof WfDocHistoryHeaderId other)) return false;
        return Objects.equals(authKey, other.authKey) && Objects.equals(docId, other.docId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(authKey, docId);
    }
}
