package com.ezc.aragenPR.webapp.dto.rfq;

import java.util.List;

public record RfqListDataTablePage(int draw, long recordsTotal, long recordsFiltered, List<RfqListRow> data) {
}
