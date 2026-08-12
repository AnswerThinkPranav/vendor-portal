package com.ezc.aragenPR.webapp.service.vendorreg;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import com.ezc.aragenPR.webapp.dto.vendorreg.BankDetailsRequest;
import com.ezc.aragenPR.webapp.dto.vendorreg.ConstitutionDetailsRequest;
import com.ezc.aragenPR.webapp.dto.vendorreg.ContactDetailsRequest;
import com.ezc.aragenPR.webapp.dto.vendorreg.DocumentDetailsRequest;
import com.ezc.aragenPR.webapp.dto.vendorreg.FinanceReviewFields;
import com.ezc.aragenPR.webapp.dto.vendorreg.InviteVendorRequest;
import com.ezc.aragenPR.webapp.dto.vendorreg.MsmeDetailsRequest;
import com.ezc.aragenPR.webapp.dto.vendorreg.OptionItem;
import com.ezc.aragenPR.webapp.dto.vendorreg.VendorListDataTablePage;
import com.ezc.aragenPR.webapp.dto.vendorreg.VendorListRow;
import com.ezc.aragenPR.webapp.dto.vendorreg.VendorRegistrationDetails;
import com.ezc.aragenPR.webapp.dto.vendorreg.VendorWorkflowStatus;
import com.ezc.aragenPR.webapp.dto.vendorreg.WorkflowActionRequest;
import com.ezc.aragenPR.webapp.dto.vendorreg.ApprovalHierarchyLevel;
import com.ezc.aragenPR.webapp.dto.vendorreg.AuditTrailEntry;
import com.ezc.aragenPR.webapp.dto.vendorreg.VendorQueryEntry;
import com.ezc.aragenPR.webapp.dto.vendorreg.VendorRegComment;
import com.ezc.aragenPR.webapp.model.pr.EzUploadDocument;
import com.ezc.aragenPR.webapp.model.rfq.DocumentComment;
import com.ezc.aragenPR.webapp.model.user.UserDefaults;
import com.ezc.aragenPR.webapp.model.user.UserType;
import com.ezc.aragenPR.webapp.model.user.Users;
import com.ezc.aragenPR.webapp.model.vendorreg.CustomerFormDetail;
import com.ezc.aragenPR.webapp.model.vendorreg.CustomerFormHeader;
import com.ezc.aragenPR.webapp.model.vendorreg.Plant;
import com.ezc.aragenPR.webapp.model.vendorreg.UserDefKeyValue;
import com.ezc.aragenPR.webapp.model.vendorreg.VendorQuery;
import com.ezc.aragenPR.webapp.model.workflow.WfDocHistoryHeader;
import com.ezc.aragenPR.webapp.model.workflow.WfPricingCondition;
import com.ezc.aragenPR.webapp.repository.user.UserDefRepository;
import com.ezc.aragenPR.webapp.repository.user.UserRepository;
import com.ezc.aragenPR.webapp.repository.vendorreg.CustomerFormDetailRepository;
import com.ezc.aragenPR.webapp.repository.vendorreg.CustomerFormHeaderRepository;
import com.ezc.aragenPR.webapp.repository.vendorreg.LegacyValueMappingRepository;
import com.ezc.aragenPR.webapp.repository.vendorreg.MasterKeyValueRepository;
import com.ezc.aragenPR.webapp.repository.vendorreg.PlantRepository;
import com.ezc.aragenPR.webapp.repository.vendorreg.UserDefKeyValueRepository;
import com.ezc.aragenPR.webapp.repository.pr.EzUploadDocumentRepo;
import com.ezc.aragenPR.webapp.repository.rfq.DocumentCommentRepository;
import com.ezc.aragenPR.webapp.repository.vendorreg.VendorQueryRepository;
import com.ezc.aragenPR.webapp.repository.workflow.WfAuditTrailRepository;
import com.ezc.aragenPR.webapp.repository.workflow.WfPricingConditionRepository;
import com.ezc.aragenPR.webapp.service.shared.MailService;
import com.ezc.aragenPR.webapp.service.workflow.IWorkflowEngineService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Slf4j
@Service
public class VendorRegistrationServiceImpl implements IVendorRegistrationService {

    /**
     * Starting point for a fresh TEMP_USER_NR_RANGE counter - 6 digits, mirroring a real
     * SAP vendor code's shape. The 900000+ range mirrors the common SAP convention of
     * reserving the top of a number range for temporary/one-time vendors, distinguishing
     * a not-yet-onboarded temp vendor id from a real assigned SAP vendor code at a glance.
     */
    private static final String TEMP_USER_NR_SEED = "900000";

    @Autowired
    private MasterKeyValueRepository masterKeyValueRepository;

    @Autowired
    private PlantRepository plantRepository;

    @Autowired
    private LegacyValueMappingRepository legacyValueMappingRepository;

    @Autowired
    private UserDefKeyValueRepository userDefKeyValueRepository;

    @Autowired
    private CustomerFormHeaderRepository customerFormHeaderRepository;

    @Autowired
    private CustomerFormDetailRepository customerFormDetailRepository;

    @Autowired
    private IWorkflowEngineService workflowEngineService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserDefRepository userDefRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private MailService mailService;

    @Autowired
    private VendorQueryRepository vendorQueryRepository;

    @Autowired
    private WfPricingConditionRepository wfPricingConditionRepository;

    @Autowired
    private WfAuditTrailRepository wfAuditTrailRepository;

    @Autowired
    private DocumentCommentRepository documentCommentRepository;

    @Autowired
    private EzUploadDocumentRepo ezUploadDocumentRepo;

    /** Item type used for general (not field-specific) attachments a buyer can add to a registration - see iGetUploadList.jsp's itemId="H" / docType "VNRH". */
    private static final String HEADER_ATTACHMENT_ITEM = "VNRH";

    /** Buyer-entered (not vendor-entered) finance field names, stored on the same BANK_DET tab - see FinanceReviewFields. */
    private static final List<String> FINANCE_FIELDS = List.of("whTaxType", "whTaxCode", "recType", "reconAccount", "docAck");

    /** USERROLE codes allowed to enter/edit the finance fields at any workflow step - see ezSubmitVendRegOthMat.jsp. */
    private static final Set<String> FINANCE_ROLES = Set.of("VAR", "LB", "SCA");

    @Override
    public List<OptionItem> getPurOrgOptions() {
        return masterKeyValueOptions("PUR_ORG");
    }

    @Override
    public List<OptionItem> getCompCodeOptions() {
        return masterKeyValueOptions("COMP_CODE");
    }

    @Override
    public List<OptionItem> getVenGrpOptions() {
        return masterKeyValueOptions("VEN_GRP");
    }

    private List<OptionItem> masterKeyValueOptions(String masterType) {
        return masterKeyValueRepository.findByMasterTypeOrderByKeyAsc(masterType).stream()
                .map(m -> new OptionItem(m.getKey(), m.getKey() + "-" + m.getValue()))
                .toList();
    }

    @Override
    public List<OptionItem> getAllowedPlants(String buyerUserId) {
        List<String> plantCodes = userDefKeyValueRepository.findByUserIdAndKey(buyerUserId, "PLANT").stream()
                .map(UserDefKeyValue::getValue)
                .distinct()
                .toList();
        if (plantCodes.isEmpty()) {
            return List.of();
        }
        return plantRepository.findByPlantInOrderByPlantAsc(plantCodes).stream()
                .map(p -> new OptionItem(p.getPlant(), p.getPlant() + "->" + p.getName1()))
                .toList();
    }

    @Override
    public List<OptionItem> getAllowedCategories(String buyerUserId) {
        // EZC_USER_DEF_KEY_VALUES stores category authorizations as "PLANT#CATEGORY_CODE"
        // (see ezGetUserAuthDefaults.jsp's gv_CategoryVectAll) - only the code after '#' matters here.
        Set<String> categoryCodes = new LinkedHashSet<>();
        for (UserDefKeyValue def : userDefKeyValueRepository.findByUserIdAndKey(buyerUserId, "CATEGORY")) {
            String raw = def.getValue();
            if (raw != null && raw.contains("#")) {
                categoryCodes.add(raw.substring(raw.indexOf('#') + 1));
            }
        }
        if (categoryCodes.isEmpty()) {
            return List.of();
        }
        // ezc_value_mapping (MAP_TYPE='CATEGORY') only supplies a friendlier display label where
        // it happens to have a row - the user's own authorized codes are shown regardless of
        // whether a label mapping exists, falling back to the raw code as its own label.
        Map<String, String> labels = legacyValueMappingRepository
                .findByMapTypeAndValue1InOrderByValue2Asc("CATEGORY", List.copyOf(categoryCodes)).stream()
                .collect(Collectors.toMap(v -> v.getValue1(), v -> v.getValue2(), (a, b) -> a));
        return categoryCodes.stream()
                .sorted()
                .map(code -> new OptionItem(code, labels.getOrDefault(code, code)))
                .toList();
    }

    @Override
    public String peekNextTempVendorId() {
        return legacyValueMappingRepository.peekTempUserNrRangeValue1().orElse(TEMP_USER_NR_SEED);
    }

    @Override
    @Transactional
    public String inviteVendor(InviteVendorRequest request, String createdByUserId) {
        String docId = generateNextTempVendorId();

        CustomerFormHeader header = new CustomerFormHeader();
        header.setDocId(docId);
        header.setSalesOrg(request.getPurOrg());
        header.setCustName(request.getUserName());
        header.setCreatedBy(createdByUserId);
        header.setCreatedOn(LocalDate.now());
        header.setModifiedBy(createdByUserId);
        header.setModifiedOn(LocalDate.now());
        header.setStatus("INITIATED");
        header.setExt1(request.getCompCode());
        header.setMasterType("V");
        header.setVenGrp(request.getVenGrp());
        header.setVenType(request.getVenType());
        header.setPlant(request.getSelPlant());
        header.setCategory(request.getSelCategory());
        customerFormHeaderRepository.save(header);

        customerFormDetailRepository.saveAll(List.of(
                new CustomerFormDetail(docId, "EMAIL", request.getEmail(), "INVITE"),
                new CustomerFormDetail(docId, "CONTACT_NO", request.getContactNo(), "INVITE"),
                new CustomerFormDetail(docId, "ALLOW_RFQ", request.isRfqAuth() ? "Y" : "N", "INVITE"),
                new CustomerFormDetail(docId, "ALLOW_REG", request.isVendRegAuth() ? "Y" : "N", "INVITE")
        ));

        String tempPassword = generateTempPassword();
        Users vendor = createTempVendorLogin(docId, request, tempPassword);

        try {
            mailService.sendTempVendorInviteMail(vendor, tempPassword);
        } catch (Exception e) {
            // The vendor account and registration doc are already committed - a mail outage
            // (e.g. unconfigured SMTP creds in a dev environment) shouldn't fail the invite
            // itself, unlike the SAP vendor posting flow where a failure must surface loudly.
            log.warn("Could not send temp vendor invite mail to {} for docId {}: {}", request.getEmail(), docId, e.getMessage());
        }

        return docId;
    }

    /**
     * Creates the EU_TYPE=4 (temp vendor) login for a freshly invited vendor - see
     * ezAddTempUser.jsp. The temp vendor doc id doubles as both EU_ID (login username) and
     * EU_BUSINESS_PARTNER (no real SAP vendor code exists yet), matching the legacy behavior
     * where the hidden "userId" field posted to ezAddTempUser.jsp is always the same value as
     * the freshly minted tempUserId.
     */
    private Users createTempVendorLogin(String docId, InviteVendorRequest request, String tempPassword) {
        Users vendor = new Users();
        vendor.setUserId(docId);
        vendor.setDeletionFlag("N");
        vendor.setFirstName(request.getUserName());
        vendor.setLastName("");
        vendor.setEmail(request.getEmail());
        vendor.setContactNo(request.getContactNo());
        vendor.setPassword(passwordEncoder.encode(tempPassword));
        vendor.setEnabled(true);
        vendor.setMustChangePassword(true);
        vendor.setUserType(UserType.VENDOR_TEMP.getCode());
        vendor.setUserGroupId(0);
        vendor.setVendorCode(docId);
        userRepository.save(vendor);

        String soldTo = ("0000000000" + docId).substring(docId.length());

        UserDefaults allowRfq = new UserDefaults();
        allowRfq.setUserId(docId);
        allowRfq.setKey("ALLOW_RFQ");
        allowRfq.setValue(request.isRfqAuth() ? "Y" : "N");
        allowRfq.setDefaultFlag("D");
        allowRfq.setIsUserAKey("Y");

        UserDefaults allowReg = new UserDefaults();
        allowReg.setUserId(docId);
        allowReg.setKey("ALLOW_REG");
        allowReg.setValue(request.isVendRegAuth() ? "Y" : "N");
        allowReg.setDefaultFlag("D");
        allowReg.setIsUserAKey("Y");

        UserDefaults soldToParty = new UserDefaults();
        soldToParty.setUserId(docId);
        soldToParty.setKey("SOLDTOPARTY");
        soldToParty.setValue(soldTo);

        userDefRepository.saveAll(List.of(allowRfq, allowReg, soldToParty));
        return vendor;
    }

    /**
     * TODO: revert to a random per-invite password once outbound mail is reachable from this
     * environment - local SMTP creds are placeholders (see application.properties), so a
     * random password would be emailed nowhere and be unrecoverable for local testing. A
     * fixed known password lets the invite flow be exercised end-to-end without mail.
     */
    private String generateTempPassword() {
        return "Aragen@123";
    }

    @Override
    public List<VendorListRow> getMyInvitedVendors(String buyerUserId, String venType, String statusFilter,
                                                     LocalDate fromDate, LocalDate toDate) {
        List<String> statuses = switch (statusFilter == null ? "ALL" : statusFilter) {
            case "Reg" -> List.of("INITIATED");
            case "Res" -> List.of("RESUBMITTED");
            default -> List.of("INITIATED", "RESUBMITTED");
        };
        return customerFormHeaderRepository.findMyInvites(buyerUserId, venType, statuses, fromDate, toDate)
                .stream().map(this::toRow).toList();
    }

    @Override
    public List<VendorListRow> getVendorRegistrationList(String buyerUserId, String venType, String statusFilter,
                                                           LocalDate fromDate, LocalDate toDate) {
        List<String> statuses = switch (statusFilter == null ? "ALL" : statusFilter) {
            case "Act" -> List.of("INITIATED");
            case "Sub" -> List.of("SUBMITTED");
            case "Apr" -> List.of("APPROVED");
            case "Rej" -> List.of("REJECTED");
            case "Ven" -> List.of("RESUBMITTED");
            default -> null; // ALL - no status filter
        };

        // Legacy scopes ezVNRList.jsp by CONCAT(PLANT,'#',CATEGORY) IN (buyer's authorized
        // combos) via a SQL join; EZC_USER_DEF_KEY_VALUES CATEGORY rows are already in
        // that exact "PLANT#CODE" shape, so this reuses the same read as the dropdown scoping.
        Set<String> allowedPlantCategoryCombos = userDefKeyValueRepository
                .findByUserIdAndKey(buyerUserId, "CATEGORY").stream()
                .map(UserDefKeyValue::getValue)
                .collect(Collectors.toSet());

        return customerFormHeaderRepository.findForVnrList(venType, statuses, fromDate, toDate).stream()
                .filter(h -> allowedPlantCategoryCombos.contains(h.getPlant() + "#" + h.getCategory()))
                .map(this::toRow)
                .toList();
    }

    @Override
    public VendorListDataTablePage getVendorRegistrationListPage(String buyerUserId, String venType, String statusFilter,
                                                                   LocalDate fromDate, LocalDate toDate, String searchTerm,
                                                                   int draw, int start, int length) {
        // Authorization scoping (plant/category) only exists as an in-memory filter today
        // (see getVendorRegistrationList) - the candidate set is a few thousand rows at
        // most, so it's fetched once and paginated/searched here in Java rather than
        // pushing the scoping condition down into SQL.
        List<VendorListRow> all = getVendorRegistrationList(buyerUserId, venType, statusFilter, fromDate, toDate);

        List<VendorListRow> filtered = all;
        if (searchTerm != null && !searchTerm.isBlank()) {
            String needle = searchTerm.trim().toLowerCase();
            filtered = all.stream()
                    .filter(r -> containsIgnoreCase(r.docId(), needle)
                            || containsIgnoreCase(r.custName(), needle)
                            || containsIgnoreCase(r.purOrg(), needle)
                            || containsIgnoreCase(r.createdBy(), needle)
                            || containsIgnoreCase(r.status(), needle)
                            || containsIgnoreCase(r.sapCode(), needle))
                    .toList();
        }

        int pageSize = length > 0 ? length : 10;
        int fromIndex = Math.min(start, filtered.size());
        int toIndex = Math.min(fromIndex + pageSize, filtered.size());
        List<VendorListRow> page = filtered.subList(fromIndex, toIndex);

        return new VendorListDataTablePage(draw, all.size(), filtered.size(), page);
    }

    private boolean containsIgnoreCase(String value, String needle) {
        return value != null && value.toLowerCase().contains(needle);
    }

    private VendorListRow toRow(CustomerFormHeader h) {
        return new VendorListRow(h.getDocId(), h.getCustName(), h.getSalesOrg(), h.getCreatedBy(),
                h.getCreatedOn(), h.getModifiedOn(), h.getStatus(), h.getSapCode());
    }

    // --- Full registration form (ezVendReg.jsp) ---

    @Override
    public List<OptionItem> getIncoTermsOptions() {
        return masterKeyValueArrowOptions("INCO_TERM");
    }

    @Override
    public List<OptionItem> getPaymentTermsOptions() {
        return masterKeyValueArrowOptions("PMNT_TERM");
    }

    /** Matches legacy's "KEY-->VALUE" option-text format for INCO_Terms/Payment Terms specifically. */
    private List<OptionItem> masterKeyValueArrowOptions(String masterType) {
        return masterKeyValueRepository.findByMasterTypeOrderByKeyAsc(masterType).stream()
                .map(m -> new OptionItem(m.getKey(), m.getKey() + "-->" + m.getValue()))
                .toList();
    }

    private static final String TAB_CONTACT = "CONTCT_DET";
    private static final String TAB_CONTACT_ROWS = "CONTCT_DET1";
    private static final String TAB_CONSTITUTION = "CONSTN_DET";
    private static final String TAB_MSME = "MSME_DET";
    private static final String TAB_DOCUMENTS = "DOC_DET";
    private static final String TAB_BANK = "BANK_DET";

    @Override
    public VendorRegistrationDetails getVendorRegistrationDetails(String docId) {
        VendorRegistrationDetails result = new VendorRegistrationDetails();
        result.setDocId(docId);

        customerFormHeaderRepository.findById(docId).ifPresent(h -> {
            result.setCustName(h.getCustName());
            result.setStatus(h.getStatus());
        });

        List<CustomerFormDetail> all = customerFormDetailRepository.findByDocId(docId);
        Map<String, Map<String, String>> byTab = new LinkedHashMap<>();
        for (CustomerFormDetail d : all) {
            byTab.computeIfAbsent(d.getTabName(), k -> new LinkedHashMap<>()).put(d.getField(), d.getValue());
        }

        Map<String, String> contact = byTab.getOrDefault(TAB_CONTACT, Map.of());
        ContactDetailsRequest contactDto = result.getContact();
        contactDto.setTitle(contact.get("title"));
        contactDto.setVendName(contact.get("vendName"));
        contactDto.setSearchTerm(contact.get("searchTerm"));
        contactDto.setAddrsLine1(contact.get("addrsLine1"));
        contactDto.setAddrsLine2(contact.get("addrsLine2"));
        contactDto.setAddrsLine3(contact.get("addrsLine3"));
        contactDto.setAddrsLine4(contact.get("addrsLine4"));
        contactDto.setAddrsLine5(contact.get("addrsLine5"));
        contactDto.setPostalCode(contact.get("postalCode"));
        contactDto.setDistrictName(contact.get("districtName"));
        contactDto.setCity(contact.get("city"));
        contactDto.setState(contact.get("state"));
        contactDto.setCountry(contact.get("country"));
        contactDto.setPhoneNum(contact.get("phoneNum"));
        contactDto.setAltPhoneNum(contact.get("altPhoneNum"));
        contactDto.setMobNum(contact.get("mobNum"));
        contactDto.setAltMobNum(contact.get("altMobNum"));
        contactDto.setFax(contact.get("fax"));
        contactDto.setEmail1(contact.get("email_1"));
        contactDto.setEmail2(contact.get("email_2"));
        contactDto.setWebsite(contact.get("website"));
        contactDto.setConMethod(splitMulti(contact.get("conMethod")));
        contactDto.setOthConMethod(contact.get("othConMethod"));
        contactDto.setContacts(loadContactRows(byTab.getOrDefault(TAB_CONTACT_ROWS, Map.of())));

        Map<String, String> constn = byTab.getOrDefault(TAB_CONSTITUTION, Map.of());
        ConstitutionDetailsRequest constDto = result.getConstitution();
        constDto.setTypeOfOrg(constn.get("typeOfOrg"));
        constDto.setOthCompType(constn.get("othCompType"));
        constDto.setSupType(splitMulti(constn.get("supType")));
        constDto.setOthSupType(constn.get("othSupType"));
        constDto.setVendorType(splitMulti(constn.get("vendorType")));
        constDto.setPurOrdCurr(constn.get("purOrdCurr"));
        constDto.setIncoTerms2(constn.get("INCO_Terms2"));
        constDto.setIncoTerms(constn.get("INCO_Terms"));
        constDto.setPanAttach(constn.get("PAN_Attach"));
        constDto.setPanName(constn.get("PAN_Name"));
        constDto.setPanNumber(constn.get("PAN_Number"));
        constDto.setGstVendorClas(constn.get("gstVendorClas"));
        constDto.setGstType(constn.get("gstType"));
        constDto.setGstNumber(constn.get("gst_Number"));

        Map<String, String> msme = byTab.getOrDefault(TAB_MSME, Map.of());
        MsmeDetailsRequest msmeDto = result.getMsme();
        msmeDto.setMsmeType(msme.get("msme_Type"));
        msmeDto.setMsmeUdyogAdhrNo(msme.get("msme_Udyog_AdhrNo"));
        msmeDto.setPaymntTerms(msme.get("paymntTerms"));
        msmeDto.setBusStatus(msme.get("bus_Status"));
        msmeDto.setEInvoice(msme.get("e_Invoice"));
        msmeDto.setVendJgl(msme.get("vend_Jgl"));
        msmeDto.setVendUnit(msme.get("vend_Unit"));
        msmeDto.setVendTrans(msme.get("vend_Trans"));
        msmeDto.setVendDtls(msme.get("vend_Dtls"));
        msmeDto.setVendSite(msme.get("vend_Site"));
        msmeDto.setSitePerson(msme.get("sitePerson"));
        msmeDto.setSiteViDt(msme.get("siteViDt"));

        Map<String, String> docs = byTab.getOrDefault(TAB_DOCUMENTS, Map.of());
        DocumentDetailsRequest docDto = result.getDocuments();
        docDto.setItrAttach(docs.get("itrAttach"));
        docDto.setMoaAttach(docs.get("moaAttach"));
        docDto.setFsAttach(docs.get("fsAttach"));
        docDto.setSaAttach(docs.get("saAttach"));
        docDto.setKcAttach(docs.get("kcAttach"));
        docDto.setOthAttach(docs.get("othAttach"));

        Map<String, String> bank = byTab.getOrDefault(TAB_BANK, Map.of());
        BankDetailsRequest bankDto = result.getBank();
        bankDto.setAccntPer(bank.get("accnt_Per"));
        bankDto.setAccntEmail(bank.get("accnt_Email"));
        bankDto.setAccntMobile(bank.get("accnt_Mobile"));
        bankDto.setRtgsCode(bank.get("rtgs_Code"));
        bankDto.setBankName(bank.get("bankName"));
        bankDto.setBankBranch(bank.get("bank_Branch"));
        bankDto.setAccntNumber(bank.get("accnt_Number"));
        bankDto.setBankSwift(bank.get("bank_Swift"));
        bankDto.setChequeNo(bank.get("chequeNo"));

        return result;
    }

    private List<ContactDetailsRequest.ContactPerson> loadContactRows(Map<String, String> rowFields) {
        Set<Integer> indexes = new java.util.TreeSet<>();
        for (String field : rowFields.keySet()) {
            int underscore = field.lastIndexOf('_');
            if (underscore > 0) {
                try {
                    indexes.add(Integer.parseInt(field.substring(underscore + 1)));
                } catch (NumberFormatException ignored) {
                    // not an indexed field
                }
            }
        }
        List<ContactDetailsRequest.ContactPerson> contacts = new ArrayList<>();
        for (Integer i : indexes) {
            ContactDetailsRequest.ContactPerson person = new ContactDetailsRequest.ContactPerson();
            person.setTitle(rowFields.get("contactTitle_" + i));
            person.setName(rowFields.get("contactName_" + i));
            person.setDesignation(rowFields.get("contactDesgtn_" + i));
            person.setPhone(rowFields.get("contactPhone_" + i));
            person.setEmail(rowFields.get("contactEmail_" + i));
            contacts.add(person);
        }
        return contacts;
    }

    private List<String> splitMulti(String value) {
        return (value == null || value.isBlank()) ? List.of() : List.of(value.split("#"));
    }

    private String joinMulti(List<String> values) {
        return (values == null || values.isEmpty()) ? null : String.join("#", values);
    }

    private void addRow(List<CustomerFormDetail> rows, String docId, String tab, String field, String value) {
        if (value != null && !value.isBlank()) {
            rows.add(new CustomerFormDetail(docId, field, value, tab));
        }
    }

    @Override
    @Transactional
    public void saveContactDetails(String docId, ContactDetailsRequest r) {
        customerFormDetailRepository.deleteByDocIdAndTabName(docId, TAB_CONTACT);
        customerFormDetailRepository.deleteByDocIdAndTabName(docId, TAB_CONTACT_ROWS);

        List<CustomerFormDetail> rows = new ArrayList<>();
        addRow(rows, docId, TAB_CONTACT, "title", r.getTitle());
        addRow(rows, docId, TAB_CONTACT, "vendName", r.getVendName());
        addRow(rows, docId, TAB_CONTACT, "searchTerm", r.getSearchTerm());
        addRow(rows, docId, TAB_CONTACT, "addrsLine1", r.getAddrsLine1());
        addRow(rows, docId, TAB_CONTACT, "addrsLine2", r.getAddrsLine2());
        addRow(rows, docId, TAB_CONTACT, "addrsLine3", r.getAddrsLine3());
        addRow(rows, docId, TAB_CONTACT, "addrsLine4", r.getAddrsLine4());
        addRow(rows, docId, TAB_CONTACT, "addrsLine5", r.getAddrsLine5());
        addRow(rows, docId, TAB_CONTACT, "postalCode", r.getPostalCode());
        addRow(rows, docId, TAB_CONTACT, "districtName", r.getDistrictName());
        addRow(rows, docId, TAB_CONTACT, "city", r.getCity());
        addRow(rows, docId, TAB_CONTACT, "state", r.getState());
        addRow(rows, docId, TAB_CONTACT, "country", r.getCountry());
        addRow(rows, docId, TAB_CONTACT, "phoneNum", r.getPhoneNum());
        addRow(rows, docId, TAB_CONTACT, "altPhoneNum", r.getAltPhoneNum());
        addRow(rows, docId, TAB_CONTACT, "mobNum", r.getMobNum());
        addRow(rows, docId, TAB_CONTACT, "altMobNum", r.getAltMobNum());
        addRow(rows, docId, TAB_CONTACT, "fax", r.getFax());
        addRow(rows, docId, TAB_CONTACT, "email_1", r.getEmail1());
        addRow(rows, docId, TAB_CONTACT, "email_2", r.getEmail2());
        addRow(rows, docId, TAB_CONTACT, "website", r.getWebsite());
        addRow(rows, docId, TAB_CONTACT, "conMethod", joinMulti(r.getConMethod()));
        addRow(rows, docId, TAB_CONTACT, "othConMethod", r.getOthConMethod());

        if (r.getContacts() != null) {
            int i = 1;
            for (ContactDetailsRequest.ContactPerson person : r.getContacts()) {
                addRow(rows, docId, TAB_CONTACT_ROWS, "contactTitle_" + i, person.getTitle());
                addRow(rows, docId, TAB_CONTACT_ROWS, "contactName_" + i, person.getName());
                addRow(rows, docId, TAB_CONTACT_ROWS, "contactDesgtn_" + i, person.getDesignation());
                addRow(rows, docId, TAB_CONTACT_ROWS, "contactPhone_" + i, person.getPhone());
                addRow(rows, docId, TAB_CONTACT_ROWS, "contactEmail_" + i, person.getEmail());
                i++;
            }
        }

        customerFormDetailRepository.saveAll(rows);
    }

    @Override
    @Transactional
    public void saveConstitutionDetails(String docId, ConstitutionDetailsRequest r) {
        customerFormDetailRepository.deleteByDocIdAndTabName(docId, TAB_CONSTITUTION);

        List<CustomerFormDetail> rows = new ArrayList<>();
        addRow(rows, docId, TAB_CONSTITUTION, "typeOfOrg", r.getTypeOfOrg());
        addRow(rows, docId, TAB_CONSTITUTION, "othCompType", r.getOthCompType());
        addRow(rows, docId, TAB_CONSTITUTION, "supType", joinMulti(r.getSupType()));
        addRow(rows, docId, TAB_CONSTITUTION, "othSupType", r.getOthSupType());
        addRow(rows, docId, TAB_CONSTITUTION, "vendorType", joinMulti(r.getVendorType()));
        addRow(rows, docId, TAB_CONSTITUTION, "purOrdCurr", r.getPurOrdCurr());
        addRow(rows, docId, TAB_CONSTITUTION, "INCO_Terms2", r.getIncoTerms2());
        addRow(rows, docId, TAB_CONSTITUTION, "INCO_Terms", r.getIncoTerms());
        addRow(rows, docId, TAB_CONSTITUTION, "PAN_Attach", r.getPanAttach());
        addRow(rows, docId, TAB_CONSTITUTION, "PAN_Name", r.getPanName());
        addRow(rows, docId, TAB_CONSTITUTION, "PAN_Number", r.getPanNumber());
        addRow(rows, docId, TAB_CONSTITUTION, "gstVendorClas", r.getGstVendorClas());
        addRow(rows, docId, TAB_CONSTITUTION, "gstType", r.getGstType());
        addRow(rows, docId, TAB_CONSTITUTION, "gst_Number", r.getGstNumber());

        customerFormDetailRepository.saveAll(rows);
    }

    @Override
    @Transactional
    public void saveMsmeDetails(String docId, MsmeDetailsRequest r) {
        customerFormDetailRepository.deleteByDocIdAndTabName(docId, TAB_MSME);

        List<CustomerFormDetail> rows = new ArrayList<>();
        addRow(rows, docId, TAB_MSME, "msme_Type", r.getMsmeType());
        addRow(rows, docId, TAB_MSME, "msme_Udyog_AdhrNo", r.getMsmeUdyogAdhrNo());
        addRow(rows, docId, TAB_MSME, "paymntTerms", r.getPaymntTerms());
        addRow(rows, docId, TAB_MSME, "bus_Status", r.getBusStatus());
        addRow(rows, docId, TAB_MSME, "e_Invoice", r.getEInvoice());
        addRow(rows, docId, TAB_MSME, "vend_Jgl", r.getVendJgl());
        addRow(rows, docId, TAB_MSME, "vend_Unit", r.getVendUnit());
        addRow(rows, docId, TAB_MSME, "vend_Trans", r.getVendTrans());
        addRow(rows, docId, TAB_MSME, "vend_Dtls", r.getVendDtls());
        addRow(rows, docId, TAB_MSME, "vend_Site", r.getVendSite());
        addRow(rows, docId, TAB_MSME, "sitePerson", r.getSitePerson());
        addRow(rows, docId, TAB_MSME, "siteViDt", r.getSiteViDt());

        customerFormDetailRepository.saveAll(rows);
    }

    @Override
    @Transactional
    public void saveDocumentDetails(String docId, DocumentDetailsRequest r) {
        customerFormDetailRepository.deleteByDocIdAndTabName(docId, TAB_DOCUMENTS);

        List<CustomerFormDetail> rows = new ArrayList<>();
        addRow(rows, docId, TAB_DOCUMENTS, "itrAttach", r.getItrAttach());
        addRow(rows, docId, TAB_DOCUMENTS, "moaAttach", r.getMoaAttach());
        addRow(rows, docId, TAB_DOCUMENTS, "fsAttach", r.getFsAttach());
        addRow(rows, docId, TAB_DOCUMENTS, "saAttach", r.getSaAttach());
        addRow(rows, docId, TAB_DOCUMENTS, "kcAttach", r.getKcAttach());
        addRow(rows, docId, TAB_DOCUMENTS, "othAttach", r.getOthAttach());

        customerFormDetailRepository.saveAll(rows);
    }

    @Override
    @Transactional
    public void saveBankDetails(String docId, BankDetailsRequest r) {
        customerFormDetailRepository.deleteByDocIdAndTabName(docId, TAB_BANK);

        List<CustomerFormDetail> rows = new ArrayList<>();
        addRow(rows, docId, TAB_BANK, "accnt_Per", r.getAccntPer());
        addRow(rows, docId, TAB_BANK, "accnt_Email", r.getAccntEmail());
        addRow(rows, docId, TAB_BANK, "accnt_Mobile", r.getAccntMobile());
        addRow(rows, docId, TAB_BANK, "rtgs_Code", r.getRtgsCode());
        addRow(rows, docId, TAB_BANK, "bankName", r.getBankName());
        addRow(rows, docId, TAB_BANK, "bank_Branch", r.getBankBranch());
        addRow(rows, docId, TAB_BANK, "accnt_Number", r.getAccntNumber());
        addRow(rows, docId, TAB_BANK, "bank_Swift", r.getBankSwift());
        addRow(rows, docId, TAB_BANK, "chequeNo", r.getChequeNo());

        customerFormDetailRepository.saveAll(rows);
    }

    private static final String WF_DOC_TYPE = "VNR";

    @Override
    @Transactional
    public void submitVendorRegistration(String docId, String submittedByUserId) {
        CustomerFormHeader header = customerFormHeaderRepository.findById(docId)
                .orElseThrow(() -> new IllegalArgumentException("Vendor registration not found: " + docId));

        header.setStatus("SUBMITTED");
        header.setModifiedBy(submittedByUserId);
        header.setModifiedOn(LocalDate.now());
        header.setNextParticipant("");
        customerFormHeaderRepository.save(header);
    }

    @Override
    @Transactional
    public void submitToWorkflow(String docId, String buyerUserId) {
        CustomerFormHeader header = customerFormHeaderRepository.findById(docId)
                .orElseThrow(() -> new IllegalArgumentException("Vendor registration not found: " + docId));
        if (!"SUBMITTED".equals(header.getStatus())) {
            throw new IllegalStateException("Only a submitted registration can be pushed into the approval workflow.");
        }

        var level1 = workflowEngineService.startWorkflow(WF_DOC_TYPE, docId, header.getExt1(), header.getPlant(),
                header.getCategory(), buyerUserId, null);
        if (level1.isEmpty()) {
            throw new IllegalStateException("No approval workflow is configured for company code " + header.getExt1()
                    + ", plant " + header.getPlant() + ", category " + header.getCategory() + ".");
        }

        header.setNextParticipant(level1.get().getGroup());
        header.setModifiedBy(buyerUserId);
        header.setModifiedOn(LocalDate.now());
        customerFormHeaderRepository.save(header);
    }

    @Override
    public VendorWorkflowStatus getVendorWorkflowStatus(String docId, String currentUserId) {
        CustomerFormHeader header = customerFormHeaderRepository.findById(docId)
                .orElseThrow(() -> new IllegalArgumentException("Vendor registration not found: " + docId));

        String role = workflowEngineService.getUserRole(currentUserId);

        WfDocHistoryHeader wf = workflowEngineService.getDocHistory(WF_DOC_TYPE, docId);
        boolean routed = wf != null && wf.getNextParticipant() != null && !wf.getNextParticipant().isBlank();

        if (!routed) {
            // Mirrors the JSP's showSubmit block, which renders Send Back alongside Submit/Upload
            // Attachments for a PP-role buyer reviewing a just-submitted registration - Send Back
            // isn't limited to once the doc has actually entered the approval workflow.
            boolean canSubmitToWorkflow = "SUBMITTED".equals(header.getStatus());
            boolean canSendBack = "SUBMITTED".equals(header.getStatus());
            return new VendorWorkflowStatus(header.getStatus(), null, null, true, false, canSendBack, canSubmitToWorkflow,
                    false, false, financeFieldsOf(docId));
        }

        int currentLevel = wf.getCurrentStep() == null ? 0 : wf.getCurrentStep().intValue();
        boolean isFinal = wf.getTemplateCode() != null
                && workflowEngineService.isFinalLevel(wf.getTemplateCode().intValue(), currentLevel);

        boolean canAct = workflowEngineService.resolveGroupUsers(wf.getNextParticipant(), header.getPlant(), header.getCategory())
                .stream().anyMatch(u -> currentUserId.equals(u.getUserId()));
        // Any buyer can send a submitted registration back to the vendor while it's active -
        // unlike Forward/Approve (canAct), this isn't limited to the exact current-level actor.
        boolean canSendBack = !"REJECTED".equals(wf.getWfStatus()) && !"APPROVED".equals(wf.getWfStatus());

        // Finance Review fields are only ever shown once the workflow has reached (or passed) the
        // template's finance level - hidden from the buyer and every approver before that, and from
        // the vendor always. Editable only by a finance-role user acting at that exact level.
        boolean financeVisible = false;
        if (wf.getTemplateCode() != null) {
            Integer financeLevel = wfPricingConditionRepository.findByTemplateOrderByLevelAsc(wf.getTemplateCode().intValue())
                    .stream().filter(l -> FINANCE_ROLES.contains(l.getRole())).map(l -> l.getLevel()).findFirst().orElse(null);
            financeVisible = financeLevel != null && currentLevel >= financeLevel;
        }
        boolean financeEditable = financeVisible && canAct && FINANCE_ROLES.contains(role);

        return new VendorWorkflowStatus(wf.getWfStatus(), currentLevel, wf.getNextParticipant(), isFinal, canAct, canSendBack,
                false, financeVisible, financeEditable, financeFieldsOf(docId));
    }

    @Override
    @Transactional
    public void actOnVendorRegistration(String docId, String actorUserId, WorkflowActionRequest request) {
        CustomerFormHeader header = customerFormHeaderRepository.findById(docId)
                .orElseThrow(() -> new IllegalArgumentException("Vendor registration not found: " + docId));

        // See the "* Query has not been replied..." banner in ezVendReg.jsp - an open query
        // blocks every buyer action (Forward/Reject/SendBack) until the vendor replies.
        if (hasUnansweredQuery(docId)) {
            throw new IllegalStateException("Query has not been replied to this Vendor Registration. You cannot submit/approve Vendor Registration now.");
        }

        String role = workflowEngineService.getUserRole(actorUserId);
        if (request.finance() != null && FINANCE_ROLES.contains(role)) {
            saveFinanceFields(docId, request.finance());
        }

        String newStatus;
        String newNextParticipant;
        switch (request.action()) {
            case WorkflowActionRequest.REJECT -> {
                workflowEngineService.reject(WF_DOC_TYPE, docId, actorUserId, request.comments());
                newStatus = "REJECTED";
                newNextParticipant = "";
            }
            case WorkflowActionRequest.SEND_BACK -> {
                workflowEngineService.sendBack(WF_DOC_TYPE, docId, actorUserId, request.comments());
                newStatus = "RESUBMITTED";
                newNextParticipant = "";
            }
            case WorkflowActionRequest.FORWARD -> {
                var next = workflowEngineService.forward(WF_DOC_TYPE, docId, header.getPlant(), header.getCategory(),
                        actorUserId, request.comments());
                newStatus = "SUBMITTED";
                newNextParticipant = next.map(WfPricingCondition::getGroup).orElse("");
            }
            default -> throw new IllegalArgumentException("Unknown workflow action: " + request.action());
        }

        header.setStatus(newStatus);
        header.setNextParticipant(newNextParticipant);
        header.setModifiedBy(actorUserId);
        header.setModifiedOn(LocalDate.now());
        customerFormHeaderRepository.save(header);
    }

    private void saveFinanceFields(String docId, FinanceReviewFields f) {
        customerFormDetailRepository.deleteByDocIdAndTabNameAndFieldIn(docId, TAB_BANK, FINANCE_FIELDS);
        List<CustomerFormDetail> rows = new ArrayList<>();
        addRow(rows, docId, TAB_BANK, "whTaxType", f.whTaxType());
        addRow(rows, docId, TAB_BANK, "whTaxCode", f.whTaxCode());
        addRow(rows, docId, TAB_BANK, "recType", f.recType());
        addRow(rows, docId, TAB_BANK, "reconAccount", f.reconAccount());
        addRow(rows, docId, TAB_BANK, "docAck", f.docAck());
        customerFormDetailRepository.saveAll(rows);
    }

    @Override
    public FinanceReviewFields getFinanceFields(String docId) {
        return financeFieldsOf(docId);
    }

    private FinanceReviewFields financeFieldsOf(String docId) {
        Map<String, String> bank = customerFormDetailRepository.findByDocIdAndTabName(docId, TAB_BANK).stream()
                .collect(Collectors.toMap(CustomerFormDetail::getField, d -> d.getValue() == null ? "" : d.getValue(), (a, b) -> a));
        return new FinanceReviewFields(bank.getOrDefault("whTaxType", ""), bank.getOrDefault("whTaxCode", ""),
                bank.getOrDefault("recType", ""), bank.getOrDefault("reconAccount", ""), bank.getOrDefault("docAck", ""));
    }

    @Override
    @Transactional
    public void raiseQuery(String docId, String raisedByUserId, String queryText) {
        VendorQuery query = new VendorQuery();
        query.setDocId(docId);
        query.setRaisedBy(raisedByUserId);
        query.setRaisedOn(LocalDateTime.now());
        query.setQueryText(queryText);
        vendorQueryRepository.save(query);
    }

    @Override
    @Transactional
    public void replyToQuery(String docId, String repliedByUserId, String replyText) {
        VendorQuery query = vendorQueryRepository.findFirstByDocIdAndRepliedOnIsNullOrderByRaisedOnDesc(docId)
                .orElseThrow(() -> new IllegalStateException("There is no open query on this registration to reply to."));
        query.setRepliedBy(repliedByUserId);
        query.setRepliedOn(LocalDateTime.now());
        query.setReplyText(replyText);
        vendorQueryRepository.save(query);
    }

    @Override
    public boolean hasUnansweredQuery(String docId) {
        return vendorQueryRepository.existsByDocIdAndRepliedOnIsNull(docId);
    }

    @Override
    public List<VendorQueryEntry> getQueries(String docId) {
        return vendorQueryRepository.findByDocIdOrderByRaisedOnDesc(docId).stream()
                .map(q -> new VendorQueryEntry(q.getId(), q.getRaisedBy(), q.getRaisedOn(), q.getQueryText(),
                        q.getRepliedBy(), q.getRepliedOn(), q.getReplyText()))
                .toList();
    }

    @Override
    public List<ApprovalHierarchyLevel> getApprovalHierarchy(String docId) {
        CustomerFormHeader header = customerFormHeaderRepository.findById(docId)
                .orElseThrow(() -> new IllegalArgumentException("Vendor registration not found: " + docId));

        Integer template = workflowEngineService.resolveTemplate(WF_DOC_TYPE, header.getExt1(), header.getPlant(), header.getCategory())
                .orElse(null);
        if (template == null) {
            return List.of();
        }

        // Mirrors ezShowVNRApprovalHirearchy.jsp: condition flag LE -> "Submit", GE -> "Approve",
        // and the level list stops at (and includes) the first Approve level rather than listing
        // every level configured in the template.
        List<ApprovalHierarchyLevel> result = new ArrayList<>();
        for (WfPricingCondition level : wfPricingConditionRepository.findByTemplateOrderByLevelAsc(template)) {
            String userStr = workflowEngineService.resolveGroupUsers(level.getGroup(), header.getPlant(), header.getCategory()).stream()
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
    public List<AuditTrailEntry> getAuditTrail(String docId) {
        return wfAuditTrailRepository.findByDocIdOrderByDateAsc(docId).stream()
                .map(a -> new AuditTrailEntry(a.getAuditNo(), a.getComments(), a.getDate()))
                .toList();
    }

    @Override
    public List<VendorRegComment> getComments(String docId) {
        return documentCommentRepository.findByDocIdAndDocTypeOrderByDateAsc(docId, WF_DOC_TYPE).stream()
                .map(c -> new VendorRegComment(c.getUserId(), commentUserName(c), c.getDate(), c.getComments()))
                .toList();
    }

    private String commentUserName(DocumentComment c) {
        return userRepository.findById(c.getUserId())
                .map(u -> ((u.getFirstName() == null ? "" : u.getFirstName()) + " " + (u.getLastName() == null ? "" : u.getLastName())).trim())
                .filter(name -> !name.isEmpty())
                .orElse(c.getUserId());
    }

    @Override
    public List<String> getHeaderAttachments(String docId) {
        int docNo;
        try {
            docNo = Integer.parseInt(docId);
        } catch (NumberFormatException e) {
            return List.of();
        }
        return ezUploadDocumentRepo.findFileByDocTypeDocItemType(docNo, WF_DOC_TYPE, HEADER_ATTACHMENT_ITEM).stream()
                .map(EzUploadDocument::getFileName)
                .toList();
    }

    /**
     * Atomically reads-and-advances the EZC_VALUE_MAPPING TEMP_USER_NR_RANGE counter
     * (locked for the caller's transaction via SELECT ... FOR UPDATE) and returns the id
     * to assign to this invite. The legacy JSP did this same read-then-update at page
     * *load* time (burning a number on every visit, even without saving, and without a
     * lock against concurrent invites) - both are fixed here: generation only happens on
     * save, and the row lock prevents two concurrent invites from getting the same id.
     */
    private String generateNextTempVendorId() {
        String current = legacyValueMappingRepository.lockTempUserNrRangeValue1()
                .orElse(null);
        if (current == null) {
            legacyValueMappingRepository.seedTempUserNrRange(String.valueOf(Long.parseLong(TEMP_USER_NR_SEED) + 1));
            return TEMP_USER_NR_SEED;
        }
        String next = String.valueOf(Long.parseLong(current) + 1);
        legacyValueMappingRepository.updateTempUserNrRangeValue1(next);
        return current;
    }
}
