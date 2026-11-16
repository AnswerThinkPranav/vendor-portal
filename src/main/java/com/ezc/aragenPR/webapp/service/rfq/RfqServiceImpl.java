package com.ezc.aragenPR.webapp.service.rfq;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

import com.ezc.aragenPR.webapp.dto.rfq.CreateRfqRequest;
import com.ezc.aragenPR.webapp.dto.rfq.PrLineItem;
import com.ezc.aragenPR.webapp.dto.rfq.PrSearchCriteria;
import com.ezc.aragenPR.webapp.dto.rfq.QuoteConditionInput;
import com.ezc.aragenPR.webapp.dto.rfq.QuoteItemInput;
import com.ezc.aragenPR.webapp.dto.rfq.QuoteLineItemView;
import com.ezc.aragenPR.webapp.dto.rfq.RfqLineItemView;
import com.ezc.aragenPR.webapp.dto.rfq.RfqListDataTablePage;
import com.ezc.aragenPR.webapp.dto.rfq.RfqListRow;
import com.ezc.aragenPR.webapp.dto.rfq.RfqQuoteFormView;
import com.ezc.aragenPR.webapp.dto.rfq.RfqViewDetails;
import com.ezc.aragenPR.webapp.dto.rfq.SubmitQuoteRequest;
import com.ezc.aragenPR.webapp.dto.rfq.VendorDataTablePage;
import com.ezc.aragenPR.webapp.dto.rfq.VendorOption;
import com.ezc.aragenPR.webapp.dto.vendorreg.OptionItem;
import com.ezc.aragenPR.webapp.model.rfq.DocumentComment;
import com.ezc.aragenPR.webapp.model.rfq.RfqDetail;
import com.ezc.aragenPR.webapp.model.rfq.RfqHeader;
import com.ezc.aragenPR.webapp.model.rfq.RfqItemCondition;
import com.ezc.aragenPR.webapp.model.rfq.RfqPr;
import com.ezc.aragenPR.webapp.model.rfq.RfqQuoteHistory;
import com.ezc.aragenPR.webapp.model.user.Users;
import com.ezc.aragenPR.webapp.model.vendorreg.LegacyValueMapping;
import com.ezc.aragenPR.webapp.repository.rfq.DocumentCommentRepository;
import com.ezc.aragenPR.webapp.repository.rfq.RfqDetailRepository;
import com.ezc.aragenPR.webapp.repository.rfq.RfqHeaderRepository;
import com.ezc.aragenPR.webapp.repository.rfq.RfqItemConditionRepository;
import com.ezc.aragenPR.webapp.repository.rfq.RfqPrRepository;
import com.ezc.aragenPR.webapp.repository.rfq.RfqQuoteHistoryRepository;
import com.ezc.aragenPR.webapp.repository.rfq.RfqVendorLookupRepository;
import com.ezc.aragenPR.webapp.repository.user.UserRepository;
import com.ezc.aragenPR.webapp.repository.vendorreg.LegacyValueMappingRepository;
import com.ezc.aragenPR.webapp.repository.vendorreg.MasterKeyValueRepository;
import com.ezc.aragenPR.webapp.repository.vendorreg.PlantRepository;
import jakarta.persistence.criteria.Predicate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class RfqServiceImpl implements IRfqService {

    /** Legacy reads this from the session (SAP system key); this app targets a single system. */
    private static final String SYS_KEY = "ARAGEN";

    /** Matches the legacy fallback in ezCreateRFQ.jsp when EZC_RFQ_HEADER is empty. */
    private static final long RFQ_NO_SEED = 7000000001L;

    @Autowired
    private MasterKeyValueRepository masterKeyValueRepository;

    @Autowired
    private PlantRepository plantRepository;

    @Autowired
    private LegacyValueMappingRepository legacyValueMappingRepository;

    @Autowired
    private ISapPrFetchService sapPrFetchService;

    @Autowired
    private RfqHeaderRepository rfqHeaderRepository;

    @Autowired
    private RfqDetailRepository rfqDetailRepository;

    @Autowired
    private RfqPrRepository rfqPrRepository;

    @Autowired
    private RfqVendorLookupRepository rfqVendorLookupRepository;

    @Autowired
    private DocumentCommentRepository documentCommentRepository;

    @Autowired
    private RfqItemConditionRepository rfqItemConditionRepository;

    @Autowired
    private RfqQuoteHistoryRepository rfqQuoteHistoryRepository;

    @Autowired
    private UserRepository userRepository;

    private static final DateTimeFormatter DMY = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    @Override
    public List<OptionItem> getPurGrpOptions() {
        return legacyValueMappingRepository.findByMapTypeOrderByValue2Asc("PUR_GRP").stream()
                .map(v -> new OptionItem(v.getValue1(), v.getValue1() + "->" + v.getValue2()))
                .toList();
    }

    @Override
    public List<OptionItem> getPlantOptions() {
        return plantRepository.findAllByOrderByPlantAsc().stream()
                .map(p -> new OptionItem(p.getPlant(), p.getPlant() + "->" + p.getName1()))
                .toList();
    }

    @Override
    public List<OptionItem> getDocTypeOptions() {
        return masterKeyValueOptions("DOC_TYPE");
    }

    @Override
    public List<OptionItem> getMatGrpOptions() {
        return masterKeyValueOptions("MATL_GRP");
    }

    @Override
    public List<OptionItem> getAccCatOptions() {
        return masterKeyValueOptions("ACCT_ASN_CAT");
    }

    @Override
    public List<OptionItem> getItemCatOptions() {
        return masterKeyValueOptions("ITEM_CAT");
    }

    private List<OptionItem> masterKeyValueOptions(String masterType) {
        return masterKeyValueRepository.findByMasterTypeOrderByKeyAsc(masterType).stream()
                .map(m -> new OptionItem(m.getKey(), m.getKey() + "->" + m.getValue()))
                .toList();
    }

    @Override
    public List<PrLineItem> searchPurchaseRequisitions(PrSearchCriteria criteria, String buyerUserId) {
        List<PrLineItem> results = sapPrFetchService.fetchPurchaseRequisitions(criteria, buyerUserId);

        List<String> reqNos = results.stream().map(PrLineItem::getReqNo).distinct().toList();
        Set<String> alreadyCreated = new HashSet<>();
        for (RfqPr pr : rfqPrRepository.findByPrNoIn(reqNos)) {
            alreadyCreated.add(pr.getPrNo() + "|" + pr.getPrItem());
        }
        for (PrLineItem pr : results) {
            pr.setRfqAlreadyCreated(alreadyCreated.contains(pr.getReqNo() + "|" + pr.getItem()));
        }

        if ("Y".equals(criteria.getRfqStatus())) {
            return results.stream().filter(PrLineItem::isRfqAlreadyCreated).toList();
        }
        if ("N".equals(criteria.getRfqStatus())) {
            return results.stream().filter(pr -> !pr.isRfqAlreadyCreated()).toList();
        }
        return results;
    }

    @Override
    public List<VendorOption> getSapVendors(String q) {
        return rfqVendorLookupRepository.findSapVendors(q).stream().map(u -> toVendorOption(u, "S")).toList();
    }

    @Override
    public List<VendorOption> getNonSapVendors(String q) {
        return rfqVendorLookupRepository.findNonSapVendors(q).stream().map(u -> toVendorOption(u, "N")).toList();
    }

    @Override
    public VendorDataTablePage getVendorsPage(String type, String q, int draw, int start, int length) {
        String safeQ = q == null ? "" : q.trim();
        int pageSize = length > 0 ? length : 10;
        int pageNumber = pageSize > 0 ? start / pageSize : 0;
        Pageable pageable = PageRequest.of(pageNumber, pageSize);

        boolean nonSap = "N".equalsIgnoreCase(type);
        Page<Users> page = nonSap
                ? rfqVendorLookupRepository.findNonSapVendorsPage(safeQ, pageable)
                : rfqVendorLookupRepository.findSapVendorsPage(safeQ, pageable);

        List<VendorOption> rows = page.getContent().stream()
                .map(u -> toVendorOption(u, nonSap ? "N" : "S"))
                .toList();
        return new VendorDataTablePage(draw, page.getTotalElements(), page.getTotalElements(), rows);
    }

    private VendorOption toVendorOption(Users u, String type) {
        String name = ((u.getFirstName() == null ? "" : u.getFirstName())
                + " " + (u.getLastName() == null ? "" : u.getLastName())).trim();
        return new VendorOption(u.getUserId(), name, u.getEmail(), u.getContactNo(), type);
    }

    @Override
    @Transactional
    public String createRfq(CreateRfqRequest request, String buyerUserId) {
        String qcfNo = resolveQcfNo(request.getExistingQcfNo(), request.getPurGrp());
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime validUpto = request.getQtnEndDate() == null ? null
                : request.getQtnEndDate().atTime(
                        request.getQtnEndTime() == null ? java.time.LocalTime.of(23, 59) : request.getQtnEndTime());

        List<CreateRfqRequest.Item> items = request.getItems() == null ? List.of() : request.getItems();

        // Line numbers are assigned once per PR line (10, 20, 30...) and are identical
        // across every vendor's RFQ, mirroring ezCreateRFQ.jsp's (q+1)*10 scheme.
        LinkedHashMap<Integer, CreateRfqRequest.Item> lineNoToItem = new LinkedHashMap<>();
        int lineCounter = 10;
        for (CreateRfqRequest.Item item : items) {
            lineNoToItem.put(lineCounter, item);
            lineCounter += 10;
        }

        String prSummary = items.stream()
                .map(i -> i.getPrNo() + "-" + i.getPrItem())
                .reduce((a, b) -> a + "," + b)
                .orElse(null);

        // ERH_CATEGORY was never populated by this method - meaning workflow routing by
        // (compCode, plant, category), same scheme Vendor Registration already uses, could never
        // resolve a template for any RFQ. There's no category field collected on this form, so
        // derive one from the first line's material group (EWKM_CATEGORY is varchar(10)).
        String category = items.isEmpty() || items.get(0).getMatGrp() == null ? null
                : items.get(0).getMatGrp().trim().toUpperCase().replaceAll("[^A-Z0-9]", "_")
                        .replaceAll("_+", "_").replaceAll("^_|_$", "");
        if (category != null && category.length() > 10) {
            category = category.substring(0, 10);
        }

        boolean firstVendor = true;
        for (VendorOption vendor : request.getVendors()) {
            String rfqNo = nextRfqNo();

            RfqHeader header = new RfqHeader();
            header.setRfqNo(rfqNo);
            header.setCollectiveRfqNo(qcfNo);
            header.setSysKey(SYS_KEY);
            header.setSoldTo(vendor.id());
            header.setStatus("N");
            header.setRfqDate(now);
            header.setValidUpto(validUpto);
            header.setCreatedBy(buyerUserId);
            header.setCreatedOn(now);
            header.setModifiedBy(buyerUserId);
            header.setModifiedOn(now);
            header.setPurOrg(request.getPurOrg());
            header.setPurGrp(request.getPurGrp());
            header.setVendorType(vendor.type());
            header.setReleaseIndicator("N");
            header.setRankStatus("");
            header.setPrNo(prSummary);
            header.setPlant(request.getPlant());
            header.setCompCode(request.getCompCode());
            header.setCategory(category);
            header.setRfqType(request.getRfqType());
            header.setQcfTitle(request.getQcfTitle());
            rfqHeaderRepository.save(header);

            List<RfqDetail> details = new ArrayList<>();
            for (var entry : lineNoToItem.entrySet()) {
                CreateRfqRequest.Item item = entry.getValue();
                RfqDetail detail = new RfqDetail();
                detail.setRfqNo(rfqNo);
                detail.setLineNo(BigDecimal.valueOf(entry.getKey()));
                detail.setCounter(BigDecimal.ZERO);
                detail.setMaterial(item.getMaterial());
                detail.setMaterialDesc(item.getMaterialDesc());
                detail.setUom(item.getUom());
                // ERD_ORDER_UNIT holds the "Per" quantity denominator for unit pricing on the
                // quote entry page (price is quoted per this many UOM), not the UOM code itself -
                // default to 1 (price per single unit) unless a real per-quantity is supplied.
                detail.setOrderUnit("1");
                detail.setDeliveryDate(item.getDeliveryDate());
                detail.setQuantity(item.getQty());
                detail.setPrCreatedBy(item.getCreatedBy());
                detail.setPrice(BigDecimal.ZERO);
                detail.setRemarks(item.getRemarks());
                detail.setPlant(item.getPlant());
                detail.setAccCategory(item.getAccCat());
                detail.setItemCategory(item.getItemCat());
                detail.setPrNo(item.getPrNo());
                detail.setItemText(item.getItemText());
                detail.setPoText(item.getPoText());
                detail.setCurrency(item.getCurrency());
                detail.setWarranty(item.getWarranty());
                detail.setDocType(item.getDocType());
                detail.setMatGroup(item.getMatGrp());
                details.add(detail);
            }
            rfqDetailRepository.saveAll(details);

            if (firstVendor) {
                List<RfqPr> prLinks = new ArrayList<>();
                for (var entry : lineNoToItem.entrySet()) {
                    CreateRfqRequest.Item item = entry.getValue();
                    if (item.getPrNo() == null || item.getPrNo().isBlank()) {
                        continue;
                    }
                    RfqPr link = new RfqPr();
                    link.setQcfNo(qcfNo);
                    link.setRfqLineNo(String.valueOf(entry.getKey()));
                    link.setPrNo(item.getPrNo());
                    link.setPrItem(item.getPrItem());
                    link.setPrQty(item.getQty());
                    link.setPrOpenQty(item.getQty());
                    link.setPrDelDate(item.getDeliveryDate());
                    link.setPrType(item.getDocType());
                    prLinks.add(link);
                }
                rfqPrRepository.saveAll(prLinks);

                if (request.getComments() != null && !request.getComments().isBlank()) {
                    DocumentComment comment = new DocumentComment();
                    comment.setDocId(rfqNo);
                    comment.setDocType("RFQ");
                    comment.setComments(request.getComments());
                    comment.setUserId(buyerUserId);
                    comment.setDate(now);
                    documentCommentRepository.save(comment);
                }
                firstVendor = false;
            }
        }

        return qcfNo;
    }

    /**
     * Locks the whole table for the duration of this transaction (RfqHeaderRepository.lockMaxRfqNo)
     * so two concurrent "Create RFQ" submissions can never be assigned the same number - the legacy
     * JSP's per-vendor "SELECT MAX(ERH_RFQ_NO)+1" with no locking was a real race condition.
     */
    private String nextRfqNo() {
        return rfqHeaderRepository.lockMaxRfqNo()
                .map(max -> String.valueOf(max + 1))
                .orElse(String.valueOf(RFQ_NO_SEED));
    }

    /**
     * Reuses an existing QCF number when re-adding vendors to an already-created RFQ
     * (qcfPrev in the legacy JSP); otherwise atomically reads-and-advances the per-purchase-group
     * suffix counter (locked via RfqHeaderRepository.lockMaxCollectiveRfqSuffix) and prefixes it
     * with the purchase group, matching ezCreateRFQ.jsp's "purGrp + 7-digit zero-padded suffix" scheme.
     */
    private String resolveQcfNo(String existingQcfNo, String purGrp) {
        if (existingQcfNo != null && !existingQcfNo.isBlank()) {
            return existingQcfNo;
        }
        long next = rfqHeaderRepository.lockMaxCollectiveRfqSuffix(purGrp)
                .map(suffix -> {
                    try {
                        return Long.parseLong(suffix) + 1;
                    } catch (NumberFormatException e) {
                        return 1L;
                    }
                })
                .orElse(1L);

        // ERH_COLLETIVE_RFQ_NO is varchar(10); a real SAP purchase group is ~3 chars, but
        // clamp defensively so an unexpectedly long purGrp can't blow the column width.
        String safePurGrp = purGrp.length() > 3 ? purGrp.substring(0, 3) : purGrp;
        int suffixWidth = 10 - safePurGrp.length();
        String padded = String.format("%0" + suffixWidth + "d", next);
        if (padded.length() > suffixWidth) {
            padded = padded.substring(padded.length() - suffixWidth);
        }
        return safePurGrp + padded;
    }

    // --- List of RFQs (ezListRFQs.jsp) ---

    @Override
    public RfqListDataTablePage getRfqListPage(Users currentUser, String type, String rfqType, LocalDate fromDate,
            LocalDate toDate, String selVendorCode, int draw, int start, int length) {
        boolean isVendor = isVendorUser(currentUser);
        String safeType = (type == null || type.isBlank()) ? "ALL" : type;
        String safeRfqType = (rfqType == null || rfqType.isBlank()) ? "DOM" : rfqType;

        Specification<RfqHeader> spec = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(statusPredicate(root, cb, safeType, isVendor));

            if (isVendor) {
                predicates.add(cb.equal(root.get("soldTo"), vendorIdentity(currentUser)));
            } else {
                predicates.add(cb.equal(root.get("rfqType"), safeRfqType));
                predicates.add(cb.equal(root.get("createdBy"), currentUser.getUserId()));
                if (selVendorCode != null && !selVendorCode.isBlank()) {
                    predicates.add(cb.equal(root.get("soldTo"), selVendorCode));
                }
            }
            if (fromDate != null && toDate != null) {
                predicates.add(cb.between(root.get("createdOn"), fromDate.atTime(0, 1), toDate.atTime(23, 59)));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };

        int pageSize = length > 0 ? length : 10;
        int pageNumber = pageSize > 0 ? start / pageSize : 0;
        Pageable pageable = PageRequest.of(pageNumber, pageSize, Sort.by(Sort.Direction.DESC, "rfqNo"));
        Page<RfqHeader> page = rfqHeaderRepository.findAll(spec, pageable);
        List<RfqHeader> rows = page.getContent();

        Set<String> vendorIds = rows.stream().map(RfqHeader::getSoldTo).filter(Objects::nonNull).collect(Collectors.toSet());
        Map<String, Users> vendorsById = lookupVendorsById(vendorIds);

        Set<String> purGrps = rows.stream().map(RfqHeader::getPurGrp).filter(Objects::nonNull).collect(Collectors.toSet());
        Map<String, String> purGrpLabels = purGrps.isEmpty() ? Map.of()
                : legacyValueMappingRepository.findByMapTypeAndValue1InOrderByValue2Asc("PUR_GRP", new ArrayList<>(purGrps))
                        .stream().collect(Collectors.toMap(LegacyValueMapping::getValue1, LegacyValueMapping::getValue2, (a, b) -> a));

        List<RfqListRow> data = rows.stream().map(h -> toListRow(h, isVendor, vendorsById, purGrpLabels)).toList();
        return new RfqListDataTablePage(draw, page.getTotalElements(), page.getTotalElements(), data);
    }

    /**
     * Ports iListRFQs.jsp's qryStr construction. userType 2 (buyer) sees its own created
     * RFQs filtered by rfqType; userType 3/4 (vendor) sees RFQs sold to their vendor code.
     * "List"/"Exp" have different status sets for buyer vs. vendor, matching the legacy
     * per-userType override blocks.
     */
    private Predicate statusPredicate(jakarta.persistence.criteria.Root<RfqHeader> root,
            jakarta.persistence.criteria.CriteriaBuilder cb, String type, boolean isVendor) {
        LocalDateTime now = LocalDateTime.now();
        var status = root.<String>get("status");
        var validUpto = root.<LocalDateTime>get("validUpto");

        if (!isVendor && "List".equalsIgnoreCase(type)) {
            return cb.and(status.in("R", "N"), cb.greaterThan(validUpto, now));
        }
        if ("Exp".equalsIgnoreCase(type)) {
            return cb.and(status.in("P", "N"), cb.lessThan(validUpto, now));
        }
        return switch (type.toUpperCase()) {
            case "NEW" -> cb.and(status.in("N"), cb.greaterThan(validUpto, now));
            case "REQ" -> status.in("R");
            case "APR" -> status.in("Y", "S");
            case "REJ" -> status.in("X");
            case "LIST", "ACT" -> cb.and(status.in("P"), cb.greaterThan(validUpto, now));
            case "QRY" -> status.in("Q");
            default -> status.in("N", "R", "Y", "S", "X", "P", "Q");
        };
    }

    private RfqListRow toListRow(RfqHeader h, boolean isVendor, Map<String, Users> vendorsById, Map<String, String> purGrpLabels) {
        StatusInfo statusInfo = deriveStatus(h.getStatus(), h.getCreatedBy(), h.getModifiedBy(), h.getValidUpto());
        boolean expired = h.getValidUpto() != null && h.getValidUpto().isBefore(LocalDateTime.now());

        String quoteIndColor = "";
        if (!isVendor) {
            if ("2".equals(h.getSaveFlag())) {
                quoteIndColor = "orange";
            } else if ("3".equals(h.getSaveFlag()) || "4".equals(h.getSaveFlag())) {
                quoteIndColor = "#58fb30";
            }
        }

        Users vendor = h.getSoldTo() == null ? null : vendorsById.get(h.getSoldTo());
        String vendorLabel = vendor == null ? nullToEmpty(h.getSoldTo()) : (displayName(vendor) + " [" + h.getSoldTo() + "]");
        String purGrpLabel = h.getPurGrp() == null ? ""
                : (purGrpLabels.getOrDefault(h.getPurGrp(), h.getPurGrp()) + "[" + h.getPurGrp() + "]");

        String prNoDisplay = h.getPrNo();
        if (prNoDisplay != null && prNoDisplay.contains(",")) {
            prNoDisplay = prNoDisplay.split(",")[0] + "...";
        }
        if (prNoDisplay == null || prNoDisplay.isBlank() || "RFQ".equals(prNoDisplay)) {
            prNoDisplay = "NA";
        }

        String qcfTitle = h.getQcfTitle();
        if (qcfTitle == null || qcfTitle.isBlank() || "N".equals(qcfTitle)) {
            qcfTitle = h.getCollectiveRfqNo();
        }

        return new RfqListRow(
                h.getRfqNo(), h.getCollectiveRfqNo(), qcfTitle, prNoDisplay,
                h.getRfqDate() == null ? "" : h.getRfqDate().format(DMY),
                vendorLabel, purGrpLabel, h.getCreatedBy(),
                h.getValidUpto() == null ? "" : h.getValidUpto().format(DMY),
                statusInfo.label(), statusInfo.color(), quoteIndColor, statusInfo.listType(),
                h.getRfqType(), expired);
    }

    private record StatusInfo(String label, String color, String listType) {
    }

    /** Ports the sequential if-chain in ezListRFQs.jsp exactly - later checks (Expired) intentionally override earlier ones. */
    private StatusInfo deriveStatus(String status, String createdBy, String modifiedBy, LocalDateTime validUpto) {
        String label = "";
        String color = "";
        String listType = "";
        if ("P".equals(status)) {
            label = "To Approve";
            listType = "Act";
            color = "#f5b43d";
        }
        if ("Y".equals(status) || "S".equals(status)) {
            label = "Approved";
            color = "#2abb1894";
            listType = "Apr";
        }
        if ("X".equals(status)) {
            label = "Rejected";
            color = "#ef5a618f";
            listType = "Rej";
        }
        if ("R".equals(status)) {
            label = "Requote";
            color = "#bb981894";
            listType = "Req";
        }
        if ("N".equals(status) && Objects.equals(createdBy, modifiedBy)) {
            label = "At Vendor";
            color = "#f1df09ed";
            listType = "List";
        }
        if ("Q".equals(status)) {
            label = "Query";
            color = "#fb020275";
            listType = "Qry";
        }
        boolean expired = validUpto != null && validUpto.isBefore(LocalDateTime.now());
        if (("P".equals(status) || "N".equals(status)) && expired) {
            label = "Expired";
            color = "#bdb7b7ed";
            listType = "Exp";
        }
        return new StatusInfo(label, color, listType);
    }

    private boolean isVendorUser(Users u) {
        return u.getUserType() != null && (u.getUserType() == 3 || u.getUserType() == 4);
    }

    /**
     * The vendor identity to compare against RfqHeader.soldTo. This used to port
     * iListRFQs.jsp's soldTo1 zero-padded-SAP-vendor-code scheme (preferring EU_BUSINESS_PARTNER),
     * but createRfq (below) actually stores the vendor's raw login id (vendor.id(), sourced from
     * EU_ID via RfqVendorLookupRepository/toVendorOption) as soldTo - not a zero-padded SAP vendor
     * code. The old padding logic silently never matched, breaking a vendor's own "my RFQs" list
     * filter and (before this fix) every ownership check added for quote accept/reject/requote.
     */
    private String vendorIdentity(Users u) {
        return u.getUserId();
    }

    /**
     * ERH_SOLD_TO stores the vendor id zero-padded to 10 chars, but EZC_USERS.EU_ID is stored
     * unpadded (e.g. soldTo "0000101859" vs. EU_ID "101859") - look up by the stripped numeric
     * id and key the result by the original (possibly padded) soldTo value so callers can look
     * up with whatever they have on hand.
     */
    private Map<String, Users> lookupVendorsById(Set<String> soldToIds) {
        if (soldToIds.isEmpty()) {
            return Map.of();
        }
        Map<String, String> strippedToOriginal = new HashMap<>();
        for (String id : soldToIds) {
            strippedToOriginal.put(stripLeadingZeros(id), id);
        }
        Set<String> lookupIds = new HashSet<>(strippedToOriginal.keySet());
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

    private String displayName(Users u) {
        String n = ((u.getFirstName() == null ? "" : u.getFirstName()) + " " + (u.getLastName() == null ? "" : u.getLastName())).trim();
        return n.isEmpty() ? u.getUserId() : n.toUpperCase();
    }

    private String nullToEmpty(String s) {
        return s == null ? "" : s;
    }

    // --- RFQ view-details page (ezViewRFQDetails.jsp) ---

    @Override
    public RfqViewDetails getRfqViewDetails(String rfqNo, Users currentUser) {
        RfqHeader header = rfqHeaderRepository.findById(rfqNo)
                .orElseThrow(() -> new IllegalArgumentException("RFQ not found: " + rfqNo));
        List<RfqDetail> details = new ArrayList<>(rfqDetailRepository.findByRfqNo(rfqNo));
        details.sort(Comparator.comparing(RfqDetail::getLineNo));

        List<RfqLineItemView> lineItems = details.stream().map(d -> new RfqLineItemView(
                stripDecimal(d.getLineNo()),
                blankToNA(d.getPrNo()),
                blankToNA(normalizeMaterial(d.getMaterial())),
                d.getMaterialDesc(),
                "LE".equals(d.getUom()) ? "AU" : d.getUom(),
                d.getQuantity() == null ? "" : d.getQuantity().setScale(3, RoundingMode.HALF_UP).toPlainString(),
                d.getPlant(),
                d.getRemarks())).toList();

        boolean alreadyQuoted = !details.isEmpty() && details.get(0).getPrice() != null
                && details.get(0).getPrice().compareTo(BigDecimal.ZERO) != 0;
        boolean expired = header.getValidUpto() != null && header.getValidUpto().isBefore(LocalDateTime.now());

        Users vendor = header.getSoldTo() == null ? null : userRepository.findByUserId(stripLeadingZeros(header.getSoldTo()));
        String vendorLabel = vendor == null ? nullToEmpty(header.getSoldTo()) : displayName(vendor);

        return new RfqViewDetails(
                header.getRfqNo(), header.getCollectiveRfqNo(),
                header.getRfqDate() == null ? "" : header.getRfqDate().format(DMY),
                header.getValidUpto() == null ? "" : header.getValidUpto().format(DMY),
                header.getRfqType(), header.getSoldTo(), vendorLabel, header.getCreatedBy(),
                header.getStatus(), alreadyQuoted, expired, lineItems);
    }

    private String stripDecimal(BigDecimal v) {
        return v == null ? "" : v.stripTrailingZeros().toBigInteger().toString();
    }

    private String blankToNA(String s) {
        return (s == null || s.isBlank()) ? "NA" : s;
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

    // --- Vendor quotation entry page (ezPostQuote.jsp) ---

    @Override
    public RfqQuoteFormView getQuoteForm(String rfqNo, Users currentUser) {
        RfqHeader header = rfqHeaderRepository.findById(rfqNo)
                .orElseThrow(() -> new IllegalArgumentException("RFQ not found: " + rfqNo));
        List<RfqDetail> details = new ArrayList<>(rfqDetailRepository.findByRfqNo(rfqNo));
        details.sort(Comparator.comparing(RfqDetail::getLineNo));

        Map<String, Map<String, RfqItemCondition>> condByLine = groupConditionsByLine(rfqNo, header.getSoldTo());

        List<QuoteLineItemView> items = details.stream().map(d -> {
            Map<String, RfqItemCondition> lineConds = condByLine.getOrDefault(stripDecimal(d.getLineNo()), Map.of());
            RfqItemCondition disc = lineConds.get("DISC");
            RfqItemCondition pkfw = lineConds.get("PKFW");
            RfqItemCondition frt = lineConds.get("FRT");
            RfqItemCondition tax = lineConds.get("TAX");
            return new QuoteLineItemView(
                stripDecimal(d.getLineNo()),
                normalizeMaterial(d.getMaterial()),
                d.getMaterialDesc(),
                d.getMatGroup(),
                (d.getSapHsnCode() != null && !d.getSapHsnCode().isBlank()) ? d.getSapHsnCode() : d.getVendHsnCode(),
                d.getQuantity() == null ? "" : d.getQuantity().setScale(3, RoundingMode.HALF_UP).toPlainString(),
                (d.getOrderUnit() == null || d.getOrderUnit().isBlank()) ? "1" : d.getOrderUnit(),
                "LE".equals(d.getUom()) ? "AU" : d.getUom(),
                d.getMrpPrice() == null ? "" : d.getMrpPrice().stripTrailingZeros().toPlainString(),
                (d.getPrice() == null || d.getPrice().compareTo(BigDecimal.ZERO) == 0) ? "" : d.getPrice().stripTrailingZeros().toPlainString(),
                (d.getCurrency() == null || d.getCurrency().isBlank()) ? "INR" : d.getCurrency(),
                d.getRemarks(),
                d.getDeliveryDate() == null ? "" : d.getDeliveryDate().format(DMY),
                d.getWarranty(),
                condType(disc), condValue(disc),
                condType(pkfw), condValue(pkfw),
                condType(frt), condValue(frt),
                condValue(tax));
        }).toList();

        boolean isOwner = isVendorUser(currentUser) && header.getSoldTo() != null
                && header.getSoldTo().equals(vendorIdentity(currentUser));
        boolean canAct = !isOwner && "P".equals(header.getStatus());

        return new RfqQuoteFormView(
                header.getRfqNo(),
                header.getRfqDate() == null ? "" : header.getRfqDate().format(DMY),
                header.getValidUpto() == null ? "" : header.getValidUpto().format(DMY),
                LocalDate.now().format(DMY),
                header.getRfqType(),
                header.getPaymentTerms(), header.getIncoTerms1(),
                header.getLdStatus(), header.getLdClause(),
                header.getPgStatus(), header.getPgClause(),
                masterKeyValueOptions("PMNT_TERM"), masterKeyValueOptions("INCO_TERM"),
                items, isOwner, header.getStatus(), canAct);
    }

    private String condType(RfqItemCondition c) {
        return (c == null || c.getTaxType() == null) ? "" : c.getTaxType();
    }

    private String condValue(RfqItemCondition c) {
        if (c == null || c.getTaxValue() == null || c.getTaxValue().isBlank()) {
            return "0";
        }
        return c.getTaxValue();
    }

    private Map<String, Map<String, RfqItemCondition>> groupConditionsByLine(String rfqNo, String vendor) {
        Map<String, Map<String, RfqItemCondition>> byLine = new HashMap<>();
        for (RfqItemCondition c : rfqItemConditionRepository.findByRfqNoAndVendor(rfqNo, vendor)) {
            byLine.computeIfAbsent(stripDecimal(c.getLineNo()), k -> new HashMap<>()).put(c.getTaxCode(), c);
        }
        return byLine;
    }

    // --- Submit quote (ezQuotationSave.jsp) ---

    @Override
    @Transactional
    public void submitQuote(String rfqNo, SubmitQuoteRequest request, Users currentUser) {
        RfqHeader header = rfqHeaderRepository.findById(rfqNo)
                .orElseThrow(() -> new IllegalArgumentException("RFQ not found: " + rfqNo));
        List<RfqDetail> details = rfqDetailRepository.findByRfqNo(rfqNo);
        Map<String, RfqDetail> detailsByLine = details.stream()
                .collect(Collectors.toMap(d -> stripDecimal(d.getLineNo()), d -> d));

        LocalDateTime now = LocalDateTime.now();
        String vendorId = header.getSoldTo();
        String userType = currentUser.getUserType() == null ? "" : String.valueOf(currentUser.getUserType());
        boolean isImport = "IMP".equalsIgnoreCase(header.getRfqType());

        if (!isVendorUser(currentUser) || vendorId == null || !vendorId.equals(vendorIdentity(currentUser))) {
            throw new IllegalStateException("Only the vendor this RFQ was sent to can submit a quote.");
        }

        header.setStatus("P");
        header.setPaymentTerms(request.paymentTerms());
        header.setIncoTerms1(request.incoTerms1());
        header.setLdStatus(request.ldApplicable() ? "Y" : "N");
        header.setLdClause(request.ldClause());
        header.setPgStatus(request.pgApplicable() ? "Y" : "N");
        header.setPgClause(request.pgClause());
        header.setModifiedBy(currentUser.getUserId());
        header.setModifiedOn(now);
        header.setSaveFlag(userType);
        rfqHeaderRepository.save(header);

        List<RfqItemCondition> conditionRows = new ArrayList<>();
        List<RfqQuoteHistory> historyRows = new ArrayList<>();

        for (QuoteItemInput item : request.items() == null ? List.<QuoteItemInput>of() : request.items()) {
            RfqDetail detail = detailsByLine.get(item.lineNo());
            if (detail == null) {
                continue;
            }

            RfqConditionCalculator.LineCalc calc = RfqConditionCalculator.calculateDomestic(item.qty(), item.perQty(), item.price(),
                    item.discount(), item.pkgFwd(), item.freight(), item.gstPercent());

            detail.setPrice(item.price() == null ? BigDecimal.ZERO : item.price());
            detail.setMrpPrice(item.mrpPrice());
            detail.setCurrency(item.currency());
            detail.setRemarks(request.comments());
            detail.setVendHsnCode(item.hsnCode());
            // Warranty isn't collected on this quote entry page's item table - preserve whatever
            // was already stored rather than blanking it out on every submit.
            if (item.warranty() != null) {
                detail.setWarranty(item.warranty());
            }
            detail.setExchRate(BigDecimal.ONE);
            rfqDetailRepository.save(detail);

            BigDecimal lineNoDec = detail.getLineNo();
            String currency = nullToEmpty(item.currency());

            conditionRows.add(buildCondition(vendorId, rfqNo, lineNoDec, "DISC", "1", item, calc.discVal(), item.discount(), currency));
            conditionRows.add(buildCondition(vendorId, rfqNo, lineNoDec, "PKFW", "2", item, calc.pkfwVal(), item.pkgFwd(), currency));
            conditionRows.add(buildCondition(vendorId, rfqNo, lineNoDec, "FRT", "3", item, calc.frtVal(), item.freight(), currency));
            if (!isImport) {
                conditionRows.add(buildTaxCondition(vendorId, rfqNo, lineNoDec, "4", item, calc.taxVal(), currency));
            }

            historyRows.add(buildHistory(vendorId, rfqNo, lineNoDec, "DISC", "1", item, calc.discVal(), item.discount(), currency, currentUser, now));
            historyRows.add(buildHistory(vendorId, rfqNo, lineNoDec, "PKFW", "2", item, calc.pkfwVal(), item.pkgFwd(), currency, currentUser, now));
            historyRows.add(buildHistory(vendorId, rfqNo, lineNoDec, "FRT", "3", item, calc.frtVal(), item.freight(), currency, currentUser, now));
            if (!isImport) {
                historyRows.add(buildTaxHistory(vendorId, rfqNo, lineNoDec, "4", item, calc.taxVal(), currency, currentUser, now));
            }
        }

        rfqItemConditionRepository.saveAll(conditionRows);
        rfqQuoteHistoryRepository.saveAll(historyRows);

        if (request.comments() != null && !request.comments().isBlank()) {
            DocumentComment comment = new DocumentComment();
            comment.setDocId(rfqNo);
            comment.setDocType("RFQ");
            comment.setComments(request.comments());
            comment.setUserId(currentUser.getUserId());
            comment.setDate(now);
            documentCommentRepository.save(comment);
        }
    }

    // --- Buyer decision on a vendor's quote - see ezViewQuoteDetails.jsp ---

    @Override
    @Transactional
    public void approveQuote(String rfqNo, Users buyer, String comments) {
        transitionQuoteStatus(rfqNo, buyer, comments, "Y", false);
    }

    @Override
    @Transactional
    public void rejectQuote(String rfqNo, Users buyer, String comments) {
        transitionQuoteStatus(rfqNo, buyer, comments, "X", true);
    }

    @Override
    @Transactional
    public void requoteQuote(String rfqNo, Users buyer, String comments) {
        transitionQuoteStatus(rfqNo, buyer, comments, "R", true);
    }

    private void transitionQuoteStatus(String rfqNo, Users buyer, String comments, String newStatus, boolean commentsRequired) {
        RfqHeader header = rfqHeaderRepository.findById(rfqNo)
                .orElseThrow(() -> new IllegalArgumentException("RFQ not found: " + rfqNo));
        if (isVendorUser(buyer)) {
            throw new IllegalStateException("Only a buyer can act on a vendor's quote.");
        }
        if (!"P".equals(header.getStatus())) {
            throw new IllegalStateException("This quote is not awaiting a decision.");
        }
        if (commentsRequired && (comments == null || comments.isBlank())) {
            throw new IllegalStateException("Please enter comments.");
        }

        header.setStatus(newStatus);
        header.setModifiedBy(buyer.getUserId());
        header.setModifiedOn(LocalDateTime.now());
        rfqHeaderRepository.save(header);

        if (comments != null && !comments.isBlank()) {
            DocumentComment comment = new DocumentComment();
            comment.setDocId(rfqNo);
            comment.setDocType("RFQ");
            comment.setComments(comments);
            comment.setUserId(buyer.getUserId());
            comment.setDate(LocalDateTime.now());
            documentCommentRepository.save(comment);
        }
    }

    private RfqItemCondition buildCondition(String vendorId, String rfqNo, BigDecimal lineNo, String taxCode, String seqNo,
            QuoteItemInput item, BigDecimal computedVal, QuoteConditionInput cond, String currency) {
        RfqItemCondition c = new RfqItemCondition();
        c.setVendor(vendorId);
        c.setRfqNo(rfqNo);
        c.setLineNo(lineNo);
        c.setTaxCode(taxCode);
        c.setSeqNo(seqNo);
        c.setTaxValue(cond == null || cond.value() == null ? "0" : cond.value().toPlainString());
        c.setTaxType(cond == null ? "" : nullToEmpty(cond.type()));
        c.setCForm("");
        c.setExt1(item.qty() == null ? "0" : item.qty().toPlainString());
        c.setExt2(item.price() == null ? "0" : item.price().toPlainString());
        c.setExt3(computedVal.toPlainString());
        c.setNegTaxValue(computedVal.toPlainString());
        c.setCurrency(currency);
        c.setExchRate(BigDecimal.ONE);
        c.setCondVendor(vendorId);
        c.setExt4("");
        c.setExt5("");
        return c;
    }

    private RfqItemCondition buildTaxCondition(String vendorId, String rfqNo, BigDecimal lineNo, String seqNo,
            QuoteItemInput item, BigDecimal computedVal, String currency) {
        RfqItemCondition c = buildCondition(vendorId, rfqNo, lineNo, "TAX", seqNo, item, computedVal, null, currency);
        c.setTaxValue(item.gstPercent() == null ? "0" : item.gstPercent().toPlainString());
        c.setTaxType("W");
        return c;
    }

    private RfqQuoteHistory buildHistory(String vendorId, String rfqNo, BigDecimal lineNo, String condCode, String seqNo,
            QuoteItemInput item, BigDecimal computedVal, QuoteConditionInput cond, String currency, Users currentUser, LocalDateTime now) {
        RfqQuoteHistory h = new RfqQuoteHistory();
        h.setVendor(vendorId);
        h.setRfqNo(rfqNo);
        h.setLineNo(lineNo);
        h.setCounter(BigDecimal.ONE);
        h.setCondCode(condCode);
        h.setSeqNo(seqNo);
        h.setCondValue(cond == null || cond.value() == null ? "0" : cond.value().toPlainString());
        h.setCondType(cond == null ? "" : nullToEmpty(cond.type()));
        h.setCondTotValue(computedVal.toPlainString());
        h.setEnteredBy(currentUser.getUserId());
        h.setEnteredOn(now);
        h.setCForm("");
        h.setQuoteFlag("LATEST");
        h.setExt1(item.qty() == null ? "0" : item.qty().toPlainString());
        h.setExt2(item.price() == null ? "0" : item.price().toPlainString());
        h.setExt3("");
        h.setCurrency(currency);
        h.setExchRate(BigDecimal.ONE);
        h.setCondVendor(vendorId);
        h.setExt4("");
        h.setExt5("");
        return h;
    }

    private RfqQuoteHistory buildTaxHistory(String vendorId, String rfqNo, BigDecimal lineNo, String seqNo,
            QuoteItemInput item, BigDecimal computedVal, String currency, Users currentUser, LocalDateTime now) {
        RfqQuoteHistory h = buildHistory(vendorId, rfqNo, lineNo, "TAX", seqNo, item, computedVal, null, currency, currentUser, now);
        h.setCondValue(item.gstPercent() == null ? "0" : item.gstPercent().toPlainString());
        h.setCondType("W");
        return h;
    }
}
