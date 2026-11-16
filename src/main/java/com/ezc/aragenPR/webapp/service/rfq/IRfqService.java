package com.ezc.aragenPR.webapp.service.rfq;

import java.time.LocalDate;
import java.util.List;

import com.ezc.aragenPR.webapp.dto.rfq.CreateRfqRequest;
import com.ezc.aragenPR.webapp.dto.rfq.PrLineItem;
import com.ezc.aragenPR.webapp.dto.rfq.PrSearchCriteria;
import com.ezc.aragenPR.webapp.dto.rfq.RfqListDataTablePage;
import com.ezc.aragenPR.webapp.dto.rfq.RfqQuoteFormView;
import com.ezc.aragenPR.webapp.dto.rfq.RfqViewDetails;
import com.ezc.aragenPR.webapp.dto.rfq.SubmitQuoteRequest;
import com.ezc.aragenPR.webapp.dto.rfq.VendorDataTablePage;
import com.ezc.aragenPR.webapp.dto.rfq.VendorOption;
import com.ezc.aragenPR.webapp.dto.vendorreg.OptionItem;
import com.ezc.aragenPR.webapp.model.user.Users;

/** RFQ-from-PRs flow - see Vendor Portal/JSP/RFQ (ezPrePRList/ezListPR/ezVendorViewList/ezEnterEndDate/ezCreateRFQ). */
public interface IRfqService {

    List<OptionItem> getPurGrpOptions();

    List<OptionItem> getPlantOptions();

    List<OptionItem> getDocTypeOptions();

    List<OptionItem> getMatGrpOptions();

    List<OptionItem> getAccCatOptions();

    List<OptionItem> getItemCatOptions();

    List<PrLineItem> searchPurchaseRequisitions(PrSearchCriteria criteria, String buyerUserId);

    List<VendorOption> getSapVendors(String q);

    List<VendorOption> getNonSapVendors(String q);

    /** Server-side paginated/searchable vendor grid for the "Select Vendor" DataTable. */
    VendorDataTablePage getVendorsPage(String type, String q, int draw, int start, int length);

    /** Creates one EZC_RFQ_HEADER row per selected vendor, RFQ details per item, and RFQ_PRS linkage rows. Returns the collective RFQ / QCF number. */
    String createRfq(CreateRfqRequest request, String buyerUserId);

    /** Server-side paginated/searchable "List of RFQs" grid - see ezListRFQs.jsp. */
    RfqListDataTablePage getRfqListPage(Users currentUser, String type, String rfqType, LocalDate fromDate,
            LocalDate toDate, String selVendorCode, int draw, int start, int length);

    /** RFQ view-details page - see ezViewRFQDetails.jsp. */
    RfqViewDetails getRfqViewDetails(String rfqNo, Users currentUser);

    /** The vendor quotation entry page - see ezPostQuote.jsp. */
    RfqQuoteFormView getQuoteForm(String rfqNo, Users currentUser);

    /** Persists a submitted quote: header/detail updates, EZC_RFQ_ITEM_CONDITIONS and EZC_RFQ_QUOTE_HISTORY rows - see ezQuotationSave.jsp. */
    void submitQuote(String rfqNo, SubmitQuoteRequest request, Users currentUser);

    // --- Buyer decision on a vendor's quote - see ezViewQuoteDetails.jsp (approveQuote/reQuote/rejectQuote) ---

    /** Buyer accepts this vendor's quote (status -> "Y") - makes it eligible for QCF selection. */
    void approveQuote(String rfqNo, Users buyer, String comments);

    /** Buyer rejects this vendor's quote (status -> "X") - terminal, comments required. */
    void rejectQuote(String rfqNo, Users buyer, String comments);

    /** Buyer sends this vendor's quote back for requoting (status -> "R") - vendor can resubmit via submitQuote. */
    void requoteQuote(String rfqNo, Users buyer, String comments);
}
