package com.ezc.aragenPR.webapp.dto.rfq;

import java.util.List;

/** Response envelope matching the jQuery DataTables server-side processing contract. */
public record VendorDataTablePage(int draw, long recordsTotal, long recordsFiltered, List<VendorOption> data) {
}
