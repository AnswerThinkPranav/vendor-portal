package com.ezc.aragenPR.webapp.service.rfq;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

import com.ezc.aragenPR.webapp.dto.rfq.QcfCommentEntry;
import com.ezc.aragenPR.webapp.dto.rfq.QcfCompareForm;
import com.ezc.aragenPR.webapp.dto.rfq.QcfCompareItem;
import com.ezc.aragenPR.webapp.dto.rfq.QcfCompareLineRow;
import com.ezc.aragenPR.webapp.dto.rfq.QcfCompareVendor;
import com.ezc.aragenPR.webapp.dto.rfq.QcfVendorLineCell;
import com.ezc.aragenPR.webapp.dto.rfq.QcfLineQtyInput;
import com.ezc.aragenPR.webapp.dto.rfq.QcfListDataTablePage;
import com.ezc.aragenPR.webapp.dto.rfq.QcfListRow;
import com.ezc.aragenPR.webapp.dto.rfq.QcfSummaryProjection;
import com.ezc.aragenPR.webapp.dto.rfq.QcfVendorSelection;
import com.ezc.aragenPR.webapp.dto.rfq.QcsSummaryProjection;
import com.ezc.aragenPR.webapp.dto.rfq.QuoteConditionInput;
import com.ezc.aragenPR.webapp.dto.rfq.SubmitQcfRequest;
import com.ezc.aragenPR.webapp.model.rfq.DocumentComment;
import com.ezc.aragenPR.webapp.model.rfq.RfqDetail;
import com.ezc.aragenPR.webapp.model.rfq.RfqHeader;
import com.ezc.aragenPR.webapp.model.rfq.RfqItemCondition;
import com.ezc.aragenPR.webapp.model.user.Users;
import com.ezc.aragenPR.webapp.model.workflow.WfDocHistoryHeader;
import com.ezc.aragenPR.webapp.repository.rfq.DocumentCommentRepository;
import com.ezc.aragenPR.webapp.repository.rfq.MatBudgetPriceRepository;
import com.ezc.aragenPR.webapp.repository.rfq.RfqDetailRepository;
import com.ezc.aragenPR.webapp.repository.rfq.RfqHeaderRepository;
import com.ezc.aragenPR.webapp.repository.rfq.RfqItemConditionRepository;
import com.ezc.aragenPR.webapp.repository.user.UserRepository;
import com.ezc.aragenPR.webapp.repository.workflow.WfDocHistoryHeaderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class QcfServiceImpl implements IQcfService {

    private static final DateTimeFormatter DMY = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final DateTimeFormatter DMY_TIME = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");

    @Autowired
    private RfqHeaderRepository rfqHeaderRepository;

    @Autowired
    private RfqDetailRepository rfqDetailRepository;

    @Autowired
    private RfqItemConditionRepository rfqItemConditionRepository;

    @Autowired
    private MatBudgetPriceRepository matBudgetPriceRepository;

    @Autowired
    private WfDocHistoryHeaderRepository wfDocHistoryHeaderRepository;

    @Autowired
    private DocumentCommentRepository documentCommentRepository;

    @Autowired
    private UserRepository userRepository;

    // --- QCF List (ezListQcfs.jsp) ---

    @Override
    public QcfListDataTablePage getQcfList(Users buyer, String type, String rfqType, int draw, int start, int length) {
        String safeRfqType = (rfqType == null || rfqType.isBlank()) ? "DOM" : rfqType;
        boolean submitted = "Sub".equalsIgnoreCase(type);
        List<QcfSummaryProjection> rows = submitted
                ? rfqHeaderRepository.findSubmittedQcfs(safeRfqType, buyer.getUserId())
                : rfqHeaderRepository.findNewQcfs(safeRfqType, buyer.getUserId());

        List<QcfListRow> data = rows.stream().map(r -> toListRow(r, submitted)).toList();
        return paginate(data, draw, start, length);
    }

    private QcfListRow toListRow(QcfSummaryProjection r, boolean submitted) {
        String qcfTitle = r.getQcfTitle();
        if (qcfTitle == null || qcfTitle.isBlank() || "N".equals(qcfTitle)) {
            qcfTitle = r.getQcfNo();
        }
        String status = submitted ? "Submitted" : "New";
        String color = submitted ? "#2abb1894" : "#f2f540e0";
        return new QcfListRow(
                r.getQcfNo(), qcfTitle, nullToEmpty(r.getPlant()), nullToEmpty(r.getCreatedBy()),
                r.getRfqDate() == null ? "" : r.getRfqDate().format(DMY),
                r.getValidUpto() == null ? "" : r.getValidUpto().format(DMY),
                r.getNoOfVendors() == null ? 0 : r.getNoOfVendors(),
                r.getForBuyerApproval() == null ? 0 : r.getForBuyerApproval(),
                status, color, "0.00");
    }

    // --- QCS List (ezQCSList.jsp) ---

    @Override
    public QcfListDataTablePage getQcsList(Users buyer, String wfStatus, int draw, int start, int length) {
        String safeStatus = (wfStatus == null || wfStatus.isBlank()) ? "ALL" : wfStatus;
        List<QcsSummaryProjection> rows = wfDocHistoryHeaderRepository.findQcsList(buyer.getUserId(), safeStatus);
        List<QcfListRow> data = rows.stream().map(this::toQcsRow).toList();
        return paginate(data, draw, start, length);
    }

    private QcfListRow toQcsRow(QcsSummaryProjection r) {
        String qcfTitle = r.getQcfTitle();
        if (qcfTitle == null || qcfTitle.isBlank() || "N".equals(qcfTitle)) {
            qcfTitle = r.getQcfNo();
        }
        String color = "SUBMITTED".equalsIgnoreCase(r.getWfStatus()) ? "#2abb1894" : "#eef1f6";
        return new QcfListRow(
                r.getQcfNo(), qcfTitle, nullToEmpty(r.getPlant()), nullToEmpty(r.getBuyer()),
                "", r.getModifiedOn() == null ? "" : r.getModifiedOn().format(DMY),
                r.getNoOfVendors() == null ? 0 : r.getNoOfVendors(),
                r.getForBuyerApproval() == null ? 0 : r.getForBuyerApproval(),
                nullToEmpty(r.getWfStatus()), color,
                r.getDocValue() == null ? "0.00" : r.getDocValue().setScale(2, RoundingMode.HALF_UP).toPlainString());
    }

    private QcfListDataTablePage paginate(List<QcfListRow> all, int draw, int start, int length) {
        int pageSize = length > 0 ? length : 10;
        int from = Math.min(Math.max(start, 0), all.size());
        int to = Math.min(from + pageSize, all.size());
        return new QcfListDataTablePage(draw, all.size(), all.size(), all.subList(from, to));
    }

    // --- Quotation Comparison Form (ezQuotationComparisionForm.jsp) ---

    @Override
    public QcfCompareForm getCompareForm(String qcfNo, String type, Users buyer) {
        List<RfqHeader> headers = new ArrayList<>(rfqHeaderRepository.findByCollectiveRfqNo(qcfNo));
        headers.sort(Comparator.comparing(RfqHeader::getRfqNo));

        String qcfTitle = headers.isEmpty() ? qcfNo : headers.get(0).getQcfTitle();
        if (qcfTitle == null || qcfTitle.isBlank() || "N".equals(qcfTitle)) {
            qcfTitle = qcfNo;
        }
        String rfqType = headers.isEmpty() ? "DOM" : headers.get(0).getRfqType();

        Set<String> vendorIds = headers.stream().map(RfqHeader::getSoldTo).filter(Objects::nonNull).collect(Collectors.toSet());
        Map<String, Users> vendorsById = lookupVendorsById(vendorIds);

        List<QcfCompareVendor> vendors = headers.stream().map(h -> toCompareVendor(h, vendorsById)).toList();
        boolean anyPending = headers.stream().anyMatch(h -> "N".equals(h.getStatus()) || "R".equals(h.getStatus()));

        List<QcfCommentEntry> commentHistory = documentCommentRepository.findByDocIdAndDocTypeOrderByDateAsc(qcfNo, "QCF")
                .stream()
                .map(this::toCommentEntry)
                .toList();

        List<QcfCompareLineRow> lineRows = buildLineRows(vendors);

        return new QcfCompareForm(qcfNo, qcfTitle, rfqType, !anyPending, vendors, lineRows, commentHistory);
    }

    /**
     * Merges every vendor's line items into one shared row per line number - SR No/Material/
     * Description/Qty/Per/UOM/Budget Price/Last PO Price are identical across vendors (same
     * underlying PR line, sent to every vendor on this QCF) so they're taken from whichever
     * vendor has that line first; Rate/Total/Qty Recommended stay per-vendor. Matches by line
     * number (not list position) so a vendor missing a line doesn't misalign the row.
     */
    private List<QcfCompareLineRow> buildLineRows(List<QcfCompareVendor> vendors) {
        Map<String, QcfCompareItem> firstSeenByLine = new LinkedHashMap<>();
        List<Map<String, QcfCompareItem>> itemsByLinePerVendor = new ArrayList<>();

        for (QcfCompareVendor vendor : vendors) {
            Map<String, QcfCompareItem> byLine = new HashMap<>();
            for (QcfCompareItem item : vendor.items()) {
                byLine.put(item.lineNo(), item);
                firstSeenByLine.putIfAbsent(item.lineNo(), item);
            }
            itemsByLinePerVendor.add(byLine);
        }

        List<QcfCompareLineRow> rows = new ArrayList<>();
        for (Map.Entry<String, QcfCompareItem> entry : firstSeenByLine.entrySet()) {
            String lineNo = entry.getKey();
            QcfCompareItem shared = entry.getValue();

            List<QcfVendorLineCell> vendorCells = new ArrayList<>();
            for (int i = 0; i < vendors.size(); i++) {
                QcfCompareVendor vendor = vendors.get(i);
                QcfCompareItem item = itemsByLinePerVendor.get(i).get(lineNo);
                vendorCells.add(item == null
                        ? new QcfVendorLineCell(vendor.rfqNo(), "0.00", "0.00", "0", vendor.alreadySubmitted())
                        : new QcfVendorLineCell(vendor.rfqNo(), item.rate(), item.totalAmount(), item.qtyRecommended(), vendor.alreadySubmitted()));
            }

            rows.add(new QcfCompareLineRow(lineNo, shared.material(), shared.materialDesc(), shared.qty(),
                    shared.perQty(), shared.uom(), shared.budgetPrice(), shared.lastPoPrice(), vendorCells));
        }
        return rows;
    }

    private QcfCommentEntry toCommentEntry(DocumentComment c) {
        Users user = c.getUserId() == null ? null : userRepository.findByUserId(c.getUserId());
        String fullName = user == null ? ""
                : ((user.getFirstName() == null ? "" : user.getFirstName()) + " " + (user.getLastName() == null ? "" : user.getLastName())).trim();
        String label = fullName.isEmpty() ? nullToEmpty(c.getUserId()) : (c.getUserId() + "[" + fullName + "]");
        return new QcfCommentEntry(label, c.getDate() == null ? "" : c.getDate().format(DMY_TIME), c.getComments());
    }

    private QcfCompareVendor toCompareVendor(RfqHeader h, Map<String, Users> vendorsById) {
        List<RfqDetail> details = new ArrayList<>(rfqDetailRepository.findByRfqNo(h.getRfqNo()));
        details.sort(Comparator.comparing(RfqDetail::getLineNo));

        Map<String, Map<String, RfqItemCondition>> condByLine = groupConditionsByLine(h.getRfqNo(), h.getSoldTo());

        LocalDate rfqDate = h.getRfqDate() == null ? LocalDate.now() : h.getRfqDate().toLocalDate();
        String finYear = finYear(rfqDate);
        String monthStr = String.format("%02d", rfqDate.getMonthValue());

        BigDecimal vendorTotal = BigDecimal.ZERO;
        List<QcfCompareItem> items = new ArrayList<>();
        for (RfqDetail d : details) {
            String lineNo = stripDecimal(d.getLineNo());
            Map<String, RfqItemCondition> lineConds = condByLine.getOrDefault(lineNo, Map.of());

            QuoteConditionInput disc = toConditionInput(lineConds.get("DISC"));
            QuoteConditionInput pkfw = toConditionInput(lineConds.get("PKFW"));
            QuoteConditionInput frt = toConditionInput(lineConds.get("FRT"));
            BigDecimal gst = lineConds.containsKey("TAX") ? parseBD(lineConds.get("TAX").getTaxValue()) : BigDecimal.ZERO;

            RfqConditionCalculator.LineCalc calc = RfqConditionCalculator.calculateDomestic(
                    d.getQuantity(), parseBD(d.getOrderUnit()), d.getPrice(), disc, pkfw, frt, gst);
            vendorTotal = vendorTotal.add(calc.grossValue());

            String budgetPrice = lookupBudgetPrice(finYear, monthStr, d.getPlant(), d.getMaterial());
            String qtyRecommended = d.getPoQty() != null
                    ? d.getPoQty().stripTrailingZeros().toPlainString()
                    : (d.getQuantity() == null ? "0" : d.getQuantity().stripTrailingZeros().toPlainString());

            items.add(new QcfCompareItem(
                    lineNo, normalizeMaterial(d.getMaterial()), d.getMaterialDesc(),
                    d.getQuantity() == null ? "" : d.getQuantity().setScale(3, RoundingMode.HALF_UP).toPlainString(),
                    (d.getOrderUnit() == null || d.getOrderUnit().isBlank()) ? "1" : d.getOrderUnit(),
                    "LE".equals(d.getUom()) ? "AU" : d.getUom(),
                    budgetPrice,
                    "0.00",
                    d.getPrice() == null ? "0.00" : d.getPrice().stripTrailingZeros().toPlainString(),
                    calc.grossValue().toPlainString(),
                    qtyRecommended));
        }

        Users vendor = h.getSoldTo() == null ? null : vendorsById.get(h.getSoldTo());
        String vendorLabel = vendor == null ? nullToEmpty(h.getSoldTo()) : displayName(vendor);

        return new QcfCompareVendor(h.getRfqNo(), h.getSoldTo(), vendorLabel, h.getPaymentTerms(), h.getIncoTerms1(),
                "S".equals(h.getStatus()), items, vendorTotal.setScale(2, RoundingMode.HALF_UP).toPlainString());
    }

    private Map<String, Map<String, RfqItemCondition>> groupConditionsByLine(String rfqNo, String vendor) {
        Map<String, Map<String, RfqItemCondition>> byLine = new HashMap<>();
        for (RfqItemCondition c : rfqItemConditionRepository.findByRfqNoAndVendor(rfqNo, vendor)) {
            byLine.computeIfAbsent(stripDecimal(c.getLineNo()), k -> new HashMap<>()).put(c.getTaxCode(), c);
        }
        return byLine;
    }

    private QuoteConditionInput toConditionInput(RfqItemCondition c) {
        return c == null ? null : new QuoteConditionInput(c.getTaxType(), parseBD(c.getTaxValue()));
    }

    private BigDecimal parseBD(String s) {
        if (s == null || s.isBlank()) {
            return BigDecimal.ZERO;
        }
        try {
            return new BigDecimal(s.trim());
        } catch (NumberFormatException e) {
            return BigDecimal.ZERO;
        }
    }

    /** SAP fiscal year runs April-March, e.g. 8 Aug 2026 -> "FY-26-27" - matches EZC_MAT_BUDGET_PRICE.EMBP_FIN_YEAR. */
    private String finYear(LocalDate date) {
        int startYear = date.getMonthValue() >= 4 ? date.getYear() : date.getYear() - 1;
        return String.format("FY-%02d-%02d", startYear % 100, (startYear + 1) % 100);
    }

    private String lookupBudgetPrice(String finYear, String month, String plant, String material) {
        if (plant == null || material == null) {
            return "0.00";
        }
        return matBudgetPriceRepository.findByFinYearAndMonthAndPlantAndMaterial(finYear, month, plant, material)
                .map(b -> b.getBasicPrice() == null || b.getBasicPrice().isBlank() ? "0.00" : b.getBasicPrice())
                .orElse("0.00");
    }

    // --- Submit (ezSaveQuotationComparisionForm.jsp / ezSaveQCFWF.jsp) ---

    @Override
    @Transactional
    public void submitQcf(String qcfNo, SubmitQcfRequest request, Users buyer) {
        LocalDateTime now = LocalDateTime.now();
        List<QcfVendorSelection> selections = request.selections() == null ? List.of() : request.selections();

        List<RfqHeader> selectedHeaders = new ArrayList<>();
        BigDecimal docVal = BigDecimal.ZERO;

        for (QcfVendorSelection sel : selections) {
            if (!sel.selected()) {
                continue;
            }
            RfqHeader header = rfqHeaderRepository.findById(sel.rfqNo()).orElse(null);
            if (header == null) {
                continue;
            }

            List<RfqDetail> details = rfqDetailRepository.findByRfqNo(sel.rfqNo());
            Map<String, Map<String, RfqItemCondition>> condByLine = groupConditionsByLine(sel.rfqNo(), header.getSoldTo());
            Map<String, BigDecimal> qtyByLine = sel.items() == null ? Map.of()
                    : sel.items().stream().collect(Collectors.toMap(QcfLineQtyInput::lineNo,
                            i -> i.qtyRecommended() == null ? BigDecimal.ZERO : i.qtyRecommended()));

            BigDecimal vendorTotal = BigDecimal.ZERO;
            for (RfqDetail d : details) {
                String lineNo = stripDecimal(d.getLineNo());
                BigDecimal originalQty = d.getQuantity() == null ? BigDecimal.ZERO : d.getQuantity();
                BigDecimal qtyRec = qtyByLine.getOrDefault(lineNo, originalQty);

                d.setPoQty(qtyRec);
                rfqDetailRepository.save(d);

                Map<String, RfqItemCondition> lineConds = condByLine.getOrDefault(lineNo, Map.of());
                QuoteConditionInput disc = toConditionInput(lineConds.get("DISC"));
                QuoteConditionInput pkfw = toConditionInput(lineConds.get("PKFW"));
                QuoteConditionInput frt = toConditionInput(lineConds.get("FRT"));
                BigDecimal gst = lineConds.containsKey("TAX") ? parseBD(lineConds.get("TAX").getTaxValue()) : BigDecimal.ZERO;

                // Recommended value for this line applies the vendor's already-quoted rate/conditions
                // to the recommended qty rather than the originally-quoted qty (buyers may split
                // quantity across multiple vendors here).
                RfqConditionCalculator.LineCalc calc = RfqConditionCalculator.calculateDomestic(
                        qtyRec, parseBD(d.getOrderUnit()), d.getPrice(), disc, pkfw, frt, gst);
                vendorTotal = vendorTotal.add(calc.grossValue());
            }

            header.setStatus("S");
            header.setModifiedBy(buyer.getUserId());
            header.setModifiedOn(now);
            header.setRecValue(vendorTotal.setScale(2, RoundingMode.HALF_UP));
            selectedHeaders.add(header);
            docVal = docVal.add(vendorTotal);
        }

        if (selectedHeaders.isEmpty()) {
            throw new IllegalArgumentException("Please select at least one vendor to recommend.");
        }

        BigDecimal roundedDocVal = docVal.setScale(2, RoundingMode.HALF_UP);
        for (RfqHeader header : selectedHeaders) {
            header.setFinalValue(roundedDocVal);
            rfqHeaderRepository.save(header);
        }

        WfDocHistoryHeader wf = wfDocHistoryHeaderRepository.findByAuthKeyAndDocId("QCF", qcfNo)
                .orElseGet(WfDocHistoryHeader::new);
        boolean isNew = wf.getAuthKey() == null;
        wf.setAuthKey("QCF");
        wf.setDocId(qcfNo);
        wf.setSysKey("ARAGEN");
        wf.setWfStatus("SUBMITTED");
        wf.setCurrentStep(BigDecimal.ONE);
        if (isNew) {
            wf.setCreatedBy(buyer.getUserId());
            wf.setCreatedOn(now);
        }
        wf.setModifiedBy(buyer.getUserId());
        wf.setModifiedOn(now);
        wfDocHistoryHeaderRepository.save(wf);

        if (request.comments() != null && !request.comments().isBlank()) {
            DocumentComment comment = new DocumentComment();
            comment.setDocId(qcfNo);
            comment.setDocType("QCF");
            comment.setComments(request.comments());
            comment.setUserId(buyer.getUserId());
            comment.setDate(now);
            documentCommentRepository.save(comment);
        }
    }

    // --- shared display/lookup helpers (mirrors RfqServiceImpl's private helpers) ---

    private String stripDecimal(BigDecimal v) {
        return v == null ? "" : v.stripTrailingZeros().toBigInteger().toString();
    }

    private String normalizeMaterial(String material) {
        if (material == null) {
            return "";
        }
        try {
            return String.valueOf(Long.parseLong(material.trim()));
        } catch (NumberFormatException e) {
            return material;
        }
    }

    private String nullToEmpty(String s) {
        return s == null ? "" : s;
    }

    private String displayName(Users u) {
        String n = ((u.getFirstName() == null ? "" : u.getFirstName()) + " " + (u.getLastName() == null ? "" : u.getLastName())).trim();
        return n.isEmpty() ? u.getUserId() : n.toUpperCase();
    }

    /** ERH_SOLD_TO is zero-padded to 10 chars; EZC_USERS.EU_ID is stored unpadded - see RfqServiceImpl.lookupVendorsById. */
    private Map<String, Users> lookupVendorsById(Set<String> soldToIds) {
        if (soldToIds.isEmpty()) {
            return Map.of();
        }
        Map<String, String> strippedToOriginal = new LinkedHashMap<>();
        for (String id : soldToIds) {
            strippedToOriginal.put(stripLeadingZeros(id), id);
        }
        Set<String> lookupIds = new java.util.HashSet<>(strippedToOriginal.keySet());
        lookupIds.addAll(soldToIds);

        Map<String, Users> result = new HashMap<>();
        for (Users u : userRepository.findAllById(lookupIds)) {
            String original = strippedToOriginal.get(u.getUserId());
            if (original != null) {
                result.put(original, u);
            }
            if (soldToIds.contains(u.getUserId())) {
                result.put(u.getUserId(), u);
            }
        }
        return result;
    }

    private String stripLeadingZeros(String id) {
        if (id == null) {
            return null;
        }
        try {
            return String.valueOf(Long.parseLong(id.trim()));
        } catch (NumberFormatException e) {
            return id;
        }
    }
}
