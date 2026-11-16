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
import com.ezc.aragenPR.webapp.dto.rfq.QcfQueryEntry;
import com.ezc.aragenPR.webapp.dto.rfq.QcfSummaryProjection;
import com.ezc.aragenPR.webapp.dto.rfq.QcfVendorSelection;
import com.ezc.aragenPR.webapp.dto.rfq.QcfWorkflowActionRequest;
import com.ezc.aragenPR.webapp.dto.rfq.QcfWorkflowStatus;
import com.ezc.aragenPR.webapp.dto.rfq.QcsSummaryProjection;
import com.ezc.aragenPR.webapp.dto.rfq.QuoteConditionInput;
import com.ezc.aragenPR.webapp.dto.rfq.SubmitQcfRequest;
import com.ezc.aragenPR.webapp.dto.vendorreg.ApprovalHierarchyLevel;
import com.ezc.aragenPR.webapp.dto.vendorreg.AuditTrailEntry;
import com.ezc.aragenPR.webapp.model.rfq.DocumentComment;
import com.ezc.aragenPR.webapp.model.rfq.QcfQuery;
import com.ezc.aragenPR.webapp.model.rfq.RfqDetail;
import com.ezc.aragenPR.webapp.model.rfq.RfqHeader;
import com.ezc.aragenPR.webapp.model.rfq.RfqItemCondition;
import com.ezc.aragenPR.webapp.model.user.Users;
import com.ezc.aragenPR.webapp.model.workflow.WfDocHistoryHeader;
import com.ezc.aragenPR.webapp.model.workflow.WfPricingCondition;
import com.ezc.aragenPR.webapp.repository.rfq.DocumentCommentRepository;
import com.ezc.aragenPR.webapp.repository.rfq.MatBudgetPriceRepository;
import com.ezc.aragenPR.webapp.repository.rfq.QcfQueryRepository;
import com.ezc.aragenPR.webapp.repository.rfq.RfqDetailRepository;
import com.ezc.aragenPR.webapp.repository.rfq.RfqHeaderRepository;
import com.ezc.aragenPR.webapp.repository.rfq.RfqItemConditionRepository;
import com.ezc.aragenPR.webapp.repository.user.UserRepository;
import com.ezc.aragenPR.webapp.repository.workflow.WfAuditTrailRepository;
import com.ezc.aragenPR.webapp.repository.workflow.WfDocHistoryHeaderRepository;
import com.ezc.aragenPR.webapp.repository.workflow.WfPricingConditionRepository;
import com.ezc.aragenPR.webapp.service.workflow.IWorkflowEngineService;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
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

    @Autowired
    private WfPricingConditionRepository wfPricingConditionRepository;

    @Autowired
    private WfAuditTrailRepository wfAuditTrailRepository;

    @Autowired
    private IWorkflowEngineService workflowEngineService;

    @Autowired
    private QcfQueryRepository qcfQueryRepository;

    private static final String WF_DOC_TYPE = "QCF";

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

        List<QcfCommentEntry> commentHistory = documentCommentRepository.findByDocIdAndDocTypeOrderByDateAsc(qcfNo, "QCF")
                .stream()
                .map(this::toCommentEntry)
                .toList();

        List<QcfCompareLineRow> lineRows = buildLineRows(vendors);
        QcfWorkflowStatus workflow = getWorkflowStatus(qcfNo, buyer.getUserId());
        boolean isBuyer = headers.stream().anyMatch(h -> buyer.getUserId().equals(h.getCreatedBy()));

        return new QcfCompareForm(qcfNo, qcfTitle, rfqType, vendors, lineRows, commentHistory, workflow,
                getQueries(qcfNo), hasUnansweredQuery(qcfNo), isBuyer);
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
            // Recommended qty starts at 0 (not the full PR qty) until the buyer actually checks
            // this vendor on the comparison form - see the vendor-checkbox JS in qcf/compare.html,
            // which then auto-fills it client-side with the line's full quantity.
            String qtyRecommended = d.getPoQty() != null ? d.getPoQty().stripTrailingZeros().toPlainString() : "0";

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
        List<QcfVendorSelection> selectedOnly = selections.stream().filter(QcfVendorSelection::selected).toList();

        // Server-side re-check of the same constraint the compare page enforces client-side: a
        // line's recommended quantity, summed across every vendor it's split between, must never
        // exceed that line's original PR quantity - never trust the client alone (see plan item 3).
        Map<String, BigDecimal> originalQtyByLine = new HashMap<>();
        Map<String, BigDecimal> recommendedTotalByLine = new HashMap<>();
        for (QcfVendorSelection sel : selectedOnly) {
            for (RfqDetail d : rfqDetailRepository.findByRfqNo(sel.rfqNo())) {
                originalQtyByLine.putIfAbsent(stripDecimal(d.getLineNo()), d.getQuantity() == null ? BigDecimal.ZERO : d.getQuantity());
            }
            if (sel.items() != null) {
                for (QcfLineQtyInput item : sel.items()) {
                    BigDecimal qty = item.qtyRecommended() == null ? BigDecimal.ZERO : item.qtyRecommended();
                    recommendedTotalByLine.merge(item.lineNo(), qty, BigDecimal::add);
                }
            }
        }
        for (Map.Entry<String, BigDecimal> entry : recommendedTotalByLine.entrySet()) {
            BigDecimal original = originalQtyByLine.getOrDefault(entry.getKey(), BigDecimal.ZERO);
            if (entry.getValue().compareTo(original) > 0) {
                throw new IllegalArgumentException("Line " + entry.getKey() + ": recommended quantity ("
                        + entry.getValue().stripTrailingZeros().toPlainString() + ") exceeds the PR quantity ("
                        + original.stripTrailingZeros().toPlainString() + ").");
            }
        }

        List<RfqHeader> selectedHeaders = new ArrayList<>();
        BigDecimal docVal = BigDecimal.ZERO;

        for (QcfVendorSelection sel : selectedOnly) {
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
                // Recommended qty defaults to 0 (not the full PR qty) when the buyer didn't submit
                // one for this line - matches the compare page starting every line unselected.
                BigDecimal qtyRec = qtyByLine.getOrDefault(lineNo, BigDecimal.ZERO);

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
        RfqHeader routingHeader = selectedHeaders.get(0);
        for (RfqHeader header : selectedHeaders) {
            header.setFinalValue(roundedDocVal);
            rfqHeaderRepository.save(header);
        }

        // Routes through the same generic engine Vendor Registration already uses, rather than the
        // hand-rolled single-step WfDocHistoryHeader row this used to write directly - resolves the
        // real EZC_WF_KEY_MAP template/level for this QCF's (compCode, plant, category) and gets a
        // real WfAuditTrail entry for free.
        var level1 = workflowEngineService.startWorkflow(WF_DOC_TYPE, qcfNo, routingHeader.getCompCode(),
                routingHeader.getPlant(), routingHeader.getCategory(), buyer.getUserId(), request.comments(), roundedDocVal);
        if (level1.isEmpty()) {
            throw new IllegalStateException("No approval workflow is configured for company code " + routingHeader.getCompCode()
                    + ", plant " + routingHeader.getPlant() + ", category " + routingHeader.getCategory() + ".");
        }
        for (RfqHeader header : selectedHeaders) {
            header.setWfStatus("SUBMITTED");
            rfqHeaderRepository.save(header);
        }

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

    // --- Approval workflow (see ezViewDOMQCF.jsp) ---

    @Override
    public QcfWorkflowStatus getWorkflowStatus(String qcfNo, String currentUserId) {
        List<RfqHeader> headers = rfqHeaderRepository.findByCollectiveRfqNo(qcfNo);
        if (headers.isEmpty()) {
            throw new IllegalArgumentException("QCF not found: " + qcfNo);
        }
        RfqHeader first = headers.get(0);
        boolean anyPending = headers.stream().anyMatch(h -> "N".equals(h.getStatus()) || "R".equals(h.getStatus()));

        WfDocHistoryHeader wf = workflowEngineService.getDocHistory(WF_DOC_TYPE, qcfNo);
        if (wf == null) {
            boolean canSubmitToWorkflow = !anyPending;
            return new QcfWorkflowStatus(first.getWfStatus(), null, null, true, false, canSubmitToWorkflow, false);
        }

        // markApproved/reject both blank out nextParticipant on completion - that's a terminal
        // state, not "never submitted", so it must not fall back into the canSubmitToWorkflow path.
        boolean routed = wf.getNextParticipant() != null && !wf.getNextParticipant().isBlank();
        if (!routed) {
            return new QcfWorkflowStatus(wf.getWfStatus(), null, null, true, false, false, "APPROVED".equals(wf.getWfStatus()));
        }

        int currentLevel = wf.getCurrentStep() == null ? 0 : wf.getCurrentStep().intValue();
        boolean isFinal = wf.getTemplateCode() != null
                && workflowEngineService.isFinalLevel(wf.getTemplateCode().intValue(), currentLevel, first.getFinalValue());
        boolean canAct = workflowEngineService.resolveGroupUsers(wf.getNextParticipant(), first.getPlant(), first.getCategory())
                .stream().anyMatch(u -> currentUserId.equals(u.getUserId()));
        boolean approved = "APPROVED".equals(wf.getWfStatus());

        return new QcfWorkflowStatus(wf.getWfStatus(), currentLevel, wf.getNextParticipant(), isFinal, canAct, false, approved);
    }

    @Override
    @Transactional
    public void actOnQcf(String qcfNo, String actorUserId, QcfWorkflowActionRequest request) {
        List<RfqHeader> headers = rfqHeaderRepository.findByCollectiveRfqNo(qcfNo);
        if (headers.isEmpty()) {
            throw new IllegalArgumentException("QCF not found: " + qcfNo);
        }
        RfqHeader first = headers.get(0);

        if (hasUnansweredQuery(qcfNo)) {
            throw new IllegalStateException("Query has not been replied to this QCF. You cannot act on it now.");
        }

        QcfWorkflowStatus status = getWorkflowStatus(qcfNo, actorUserId);
        if (!status.canAct()) {
            throw new IllegalStateException("You are not authorized to act on this QCF at its current level.");
        }

        String newWfStatus;
        switch (request.action()) {
            case QcfWorkflowActionRequest.REJECT -> {
                workflowEngineService.reject(WF_DOC_TYPE, qcfNo, actorUserId, request.comments());
                newWfStatus = "REJECTED";
            }
            case QcfWorkflowActionRequest.FORWARD -> {
                var next = workflowEngineService.forward(WF_DOC_TYPE, qcfNo, first.getPlant(), first.getCategory(),
                        actorUserId, request.comments(), first.getFinalValue());
                if (next.isPresent()) {
                    newWfStatus = "SUBMITTED";
                } else {
                    // No further level configured - unlike Vendor Registration (which still needs a
                    // separate SAP validate/post step), a QCF's final-level Forward completes
                    // approval directly; the buyer's only remaining action is Create PO.
                    workflowEngineService.markApproved(WF_DOC_TYPE, qcfNo, actorUserId, request.comments());
                    newWfStatus = "APPROVED";
                }
            }
            case QcfWorkflowActionRequest.SEND_BACK -> {
                workflowEngineService.sendBack(WF_DOC_TYPE, qcfNo, actorUserId, request.comments());
                // Routing is gone entirely (see IWorkflowEngineService.sendBack) - the buyer's
                // recommended-quantity selections on RfqDetail.poQty are left as-is so they don't
                // have to redo the split from scratch, they just need to re-check/adjust and hit
                // Submit again, which re-routes via startWorkflow same as the first submission.
                newWfStatus = "SENT_BACK";
            }
            default -> throw new IllegalArgumentException("Unknown workflow action: " + request.action());
        }

        // Only the vendor(s) actually recommended/routed (ERH_STATUS="S", set by submitQcf) are
        // part of this workflow - a vendor rejected/requoted earlier and left out of the QCF
        // selection must keep its own status untouched, not get overwritten to REJECTED/APPROVED
        // just because it happens to share this QCF's collectiveRfqNo.
        for (RfqHeader h : headers) {
            if (!"S".equals(h.getStatus())) {
                continue;
            }
            h.setWfStatus(newWfStatus);
            h.setModifiedBy(actorUserId);
            h.setModifiedOn(LocalDateTime.now());
            rfqHeaderRepository.save(h);
        }
    }

    @Override
    public List<ApprovalHierarchyLevel> getApprovalHierarchy(String qcfNo) {
        List<RfqHeader> headers = rfqHeaderRepository.findByCollectiveRfqNo(qcfNo);
        if (headers.isEmpty()) {
            return List.of();
        }
        RfqHeader first = headers.get(0);
        Integer template = workflowEngineService
                .resolveTemplate(WF_DOC_TYPE, first.getCompCode(), first.getPlant(), first.getCategory())
                .orElse(null);
        if (template == null) {
            return List.of();
        }

        List<ApprovalHierarchyLevel> result = new ArrayList<>();
        for (WfPricingCondition level : wfPricingConditionRepository.findByTemplateOrderByLevelAsc(template)) {
            String userStr = workflowEngineService.resolveGroupUsers(level.getGroup(), first.getPlant(), first.getCategory()).stream()
                    .map(this::userIdWithName)
                    .collect(Collectors.joining(", "));
            String type = "GE".equals(level.getConditionFlag()) ? "Approve" : "Submit";
            result.add(new ApprovalHierarchyLevel(level.getLevel(), level.getRole(), userStr, type));
            if ("Approve".equals(type)) {
                break;
            }
        }
        return result;
    }

    private String userIdWithName(Users u) {
        String name = ((u.getFirstName() == null ? "" : u.getFirstName()) + " " + (u.getLastName() == null ? "" : u.getLastName())).trim();
        return name.isEmpty() ? u.getUserId() : u.getUserId() + "[" + name + "]";
    }

    @Override
    public List<AuditTrailEntry> getAuditTrail(String qcfNo) {
        return wfAuditTrailRepository.findByDocIdOrderByDateAsc(qcfNo).stream()
                .map(a -> new AuditTrailEntry(a.getAuditNo(), a.getComments(), a.getDate()))
                .toList();
    }

    // --- Query mechanism (an approver questioning the buyer's recommendation) ---

    @Override
    @Transactional
    public void raiseQuery(String qcfNo, String raisedByUserId, String queryText) {
        // Server-side mirror of the UI gating (canAct) - only the current-level approver may raise
        // a query, matching Vendor Registration's equivalent server-side check.
        QcfWorkflowStatus status = getWorkflowStatus(qcfNo, raisedByUserId);
        if (!status.canAct()) {
            throw new IllegalStateException("You are not authorized to raise a query on this QCF at its current level.");
        }
        QcfQuery query = new QcfQuery();
        query.setQcfNo(qcfNo);
        query.setRaisedBy(raisedByUserId);
        query.setRaisedOn(LocalDateTime.now());
        query.setQueryText(queryText);
        qcfQueryRepository.save(query);
    }

    @Override
    @Transactional
    public void replyToQuery(String qcfNo, String repliedByUserId, String replyText) {
        List<RfqHeader> headers = rfqHeaderRepository.findByCollectiveRfqNo(qcfNo);
        boolean isBuyer = headers.stream().anyMatch(h -> repliedByUserId.equals(h.getCreatedBy()));
        if (!isBuyer) {
            throw new IllegalStateException("Only the buyer who created this QCF can reply to a query on it.");
        }
        QcfQuery query = qcfQueryRepository.findFirstByQcfNoAndRepliedOnIsNullOrderByRaisedOnDesc(qcfNo)
                .orElseThrow(() -> new IllegalStateException("There is no open query on this QCF to reply to."));
        query.setRepliedBy(repliedByUserId);
        query.setRepliedOn(LocalDateTime.now());
        query.setReplyText(replyText);
        qcfQueryRepository.save(query);
    }

    @Override
    public boolean hasUnansweredQuery(String qcfNo) {
        return qcfQueryRepository.existsByQcfNoAndRepliedOnIsNull(qcfNo);
    }

    @Override
    public List<QcfQueryEntry> getQueries(String qcfNo) {
        return qcfQueryRepository.findByQcfNoOrderByRaisedOnDesc(qcfNo).stream()
                .map(q -> new QcfQueryEntry(q.getId(), q.getRaisedBy(), q.getRaisedOn(), q.getQueryText(),
                        q.getRepliedBy(), q.getRepliedOn(), q.getReplyText()))
                .toList();
    }

    // --- Excel export (see ezQuotationComparisionForm.jsp's Excel export) ---

    @Override
    public Workbook exportCompareForm(String qcfNo, Users buyer) {
        QcfCompareForm form = getCompareForm(qcfNo, "New", buyer);
        Workbook wb = new XSSFWorkbook();
        Sheet sheet = wb.createSheet("QCF " + qcfNo);

        CellStyle headerLabelStyle = headerStyle(wb, IndexedColors.LIGHT_CORNFLOWER_BLUE, IndexedColors.WHITE);
        CellStyle headerValueStyle = headerStyle(wb, IndexedColors.PALE_BLUE, IndexedColors.BLACK);
        CellStyle colHeaderStyle = headerStyle(wb, IndexedColors.GREY_40_PERCENT, IndexedColors.WHITE);
        CellStyle totalStyle = headerStyle(wb, IndexedColors.LIGHT_YELLOW, IndexedColors.BLACK);

        int rowIdx = 0;
        rowIdx = writeHeaderRow(sheet, rowIdx, "Name of the Party", form.vendors(), QcfCompareVendor::vendorLabel, headerLabelStyle, headerValueStyle);
        rowIdx = writeHeaderRow(sheet, rowIdx, "Qtn Ref No.", form.vendors(), QcfCompareVendor::rfqNo, headerLabelStyle, headerValueStyle);
        rowIdx = writeHeaderRow(sheet, rowIdx, "Payment Terms", form.vendors(), QcfCompareVendor::paymentTerms, headerLabelStyle, headerValueStyle);
        rowIdx = writeHeaderRow(sheet, rowIdx, "Inco Terms", form.vendors(), QcfCompareVendor::incoTerms1, headerLabelStyle, headerValueStyle);

        Row colHeader = sheet.createRow(rowIdx++);
        String[] fixedCols = {"SR No.", "Material", "Description", "Qty", "Per", "UOM", "Budget Price", "Last PO Price"};
        int col = 0;
        for (String c : fixedCols) {
            setCell(colHeader, col++, c, colHeaderStyle);
        }
        for (QcfCompareVendor v : form.vendors()) {
            setCell(colHeader, col++, "Rate Rs./Per", colHeaderStyle);
            setCell(colHeader, col++, "Total Amount Rs.", colHeaderStyle);
            setCell(colHeader, col++, "Qty Recommended", colHeaderStyle);
        }

        for (QcfCompareLineRow line : form.lineRows()) {
            Row row = sheet.createRow(rowIdx++);
            col = 0;
            setCell(row, col++, line.lineNo(), null);
            setCell(row, col++, line.material(), null);
            setCell(row, col++, line.materialDesc(), null);
            setCell(row, col++, line.qty(), null);
            setCell(row, col++, line.perQty(), null);
            setCell(row, col++, line.uom(), null);
            setCell(row, col++, line.budgetPrice(), null);
            setCell(row, col++, line.lastPoPrice(), null);
            for (QcfVendorLineCell cell : line.vendorCells()) {
                setCell(row, col++, cell.rate(), null);
                setCell(row, col++, cell.totalAmount(), null);
                setCell(row, col++, cell.qtyRecommended(), null);
            }
        }

        Row totalRow = sheet.createRow(rowIdx);
        setCell(totalRow, 0, "Total Cost", totalStyle);
        for (int i = 1; i < fixedCols.length; i++) {
            setCell(totalRow, i, "", totalStyle);
        }
        col = fixedCols.length;
        for (QcfCompareVendor v : form.vendors()) {
            setCell(totalRow, col++, "", totalStyle);
            setCell(totalRow, col++, v.totalAmount(), totalStyle);
            setCell(totalRow, col++, "", totalStyle);
        }

        for (int i = 0; i < col; i++) {
            sheet.autoSizeColumn(i);
        }
        return wb;
    }

    private int writeHeaderRow(Sheet sheet, int rowIdx, String label, List<QcfCompareVendor> vendors,
            java.util.function.Function<QcfCompareVendor, String> valueFn, CellStyle labelStyle, CellStyle valueStyle) {
        Row row = sheet.createRow(rowIdx);
        setCell(row, 0, label, labelStyle);
        int col = 1;
        for (QcfCompareVendor v : vendors) {
            setCell(row, col++, valueFn.apply(v), valueStyle);
        }
        return rowIdx + 1;
    }

    private void setCell(Row row, int col, String value, CellStyle style) {
        Cell cell = row.createCell(col);
        cell.setCellValue(value == null ? "" : value);
        if (style != null) {
            cell.setCellStyle(style);
        }
    }

    private CellStyle headerStyle(Workbook wb, IndexedColors bg, IndexedColors fontColor) {
        CellStyle style = wb.createCellStyle();
        style.setFillForegroundColor(bg.getIndex());
        style.setFillPattern(org.apache.poi.ss.usermodel.FillPatternType.SOLID_FOREGROUND);
        Font font = wb.createFont();
        font.setBold(true);
        font.setColor(fontColor.getIndex());
        style.setFont(font);
        return style;
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
