package com.ezc.aragenPR.webapp.service.pr;

import com.ezc.aragenPR.webapp.model.pr.EzPurchaseRequisitionHeader;
import com.ezc.aragenPR.webapp.model.pr.EzPurchaseRequisitionItems;
import com.ezc.aragenPR.webapp.repository.pr.EzcPRHeaderRepository;
import com.ezc.aragenPR.webapp.service.pr.EzcPRHeaderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

@Service
public class EzcPRHeaderServiceImpl implements EzcPRHeaderService {

    @Autowired
    private EzcPRHeaderRepository headerRepository;

    @Override
    public List<EzPurchaseRequisitionHeader> getAllHeaders() {
        return headerRepository.findAll();
    }

    @Override
    public List<EzPurchaseRequisitionHeader> findByReqNumber(String reqNumber) {
        return headerRepository.findByReqNumber(reqNumber);
    }

    @Override
    @Transactional
    public EzPurchaseRequisitionHeader save(EzPurchaseRequisitionHeader header) {
        // Ensure each item knows its parent header
        if (header.getItems() != null) {
            for (EzPurchaseRequisitionItems item : header.getItems()) {
                item.setHeader(header);
            }
        }

        // Save header (items will be persisted automatically because of cascade)
        return headerRepository.save(header);
    }

    @Override
    public List<EzPurchaseRequisitionHeader> getFilteredHeaders(LocalDateTime fromDate, LocalDateTime toDate, String status, String userId) {
        return headerRepository.findByVendorFilters(fromDate, toDate, status, userId);
    }

    @Override
    public List<EzPurchaseRequisitionHeader> getFilteredHeaders(LocalDateTime fromDate, LocalDateTime toDate, String status) {
        return headerRepository.findByVendorFilters(fromDate, toDate, status);
    }

    @Override
    public List<EzPurchaseRequisitionHeader> getFilteredHeadersByDocType(LocalDateTime fromDate, LocalDateTime toDate, String docType, String userId) {
        return headerRepository.findByDocTypeFilters(fromDate, toDate, docType, userId);
    }

    @Override
    public int updateStatusAndApprover(String reqNumber,String status,String nxtApprover)
    {
        return headerRepository.updateStatusAndApprover(reqNumber, status, nxtApprover);
    }
    @Override
    public List<EzPurchaseRequisitionHeader> getCreatedByList(LocalDateTime fromDate, LocalDateTime toDate,String createdBy)
    {
        return headerRepository.getCreatedByList(fromDate, toDate, createdBy);
    }
    @Override
    public List<EzPurchaseRequisitionHeader> findByReqNumberWithItems(String reqNumber)
    {
        return headerRepository.findByReqNumberWithItems(reqNumber);

    }
}
