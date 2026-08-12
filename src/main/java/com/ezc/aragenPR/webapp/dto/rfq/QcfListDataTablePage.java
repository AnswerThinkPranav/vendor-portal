package com.ezc.aragenPR.webapp.dto.rfq;

import java.util.List;

public record QcfListDataTablePage(int draw, long recordsTotal, long recordsFiltered, List<QcfListRow> data) {
}
