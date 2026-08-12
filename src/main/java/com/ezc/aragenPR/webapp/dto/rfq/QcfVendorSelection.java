package com.ezc.aragenPR.webapp.dto.rfq;

import java.util.List;

public record QcfVendorSelection(String rfqNo, boolean selected, List<QcfLineQtyInput> items) {
}
