package com.ezc.aragenPR.webapp.dto.vendorreg;

import java.util.List;

/** Response envelope matching the jQuery DataTables server-side processing contract. */
public record VendorListDataTablePage(int draw, long recordsTotal, long recordsFiltered, List<VendorListRow> data) {
}
