package com.ezc.aragenPR.webapp.service.rfq;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ezc.aragenPR.webapp.dto.rfq.PoSummary;
import com.ezc.aragenPR.webapp.dto.rfq.QcfWorkflowStatus;
import com.ezc.aragenPR.webapp.dto.rfq.QuoteConditionInput;
import com.ezc.aragenPR.webapp.model.rfq.PurchaseOrder;
import com.ezc.aragenPR.webapp.model.rfq.PurchaseOrderItem;
import com.ezc.aragenPR.webapp.model.rfq.RfqDetail;
import com.ezc.aragenPR.webapp.model.rfq.RfqHeader;
import com.ezc.aragenPR.webapp.model.rfq.RfqItemCondition;
import com.ezc.aragenPR.webapp.model.user.Users;
import com.ezc.aragenPR.webapp.repository.rfq.PurchaseOrderRepository;
import com.ezc.aragenPR.webapp.repository.rfq.RfqDetailRepository;
import com.ezc.aragenPR.webapp.repository.rfq.RfqHeaderRepository;
import com.ezc.aragenPR.webapp.repository.rfq.RfqItemConditionRepository;
import com.ezc.aragenPR.webapp.repository.user.UserRepository;

@Service
public class PoServiceImpl implements IPoService {

    @Autowired
    private RfqHeaderRepository rfqHeaderRepository;

    @Autowired
    private RfqDetailRepository rfqDetailRepository;

    @Autowired
    private RfqItemConditionRepository rfqItemConditionRepository;

    @Autowired
    private PurchaseOrderRepository purchaseOrderRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private IQcfService qcfService;

    @Override
    @Transactional
    public List<PoSummary> createPurchaseOrders(String qcfNo, Users buyer) {
        List<PurchaseOrder> existing = purchaseOrderRepository.findByQcfNo(qcfNo);
        if (!existing.isEmpty()) {
            return toSummaries(existing);
        }

        QcfWorkflowStatus status = qcfService.getWorkflowStatus(qcfNo, buyer.getUserId());
        if (!status.approved()) {
            throw new IllegalStateException("This QCF has not been fully approved yet.");
        }

        List<RfqHeader> headers = rfqHeaderRepository.findByCollectiveRfqNo(qcfNo);
        if (headers.isEmpty()) {
            throw new IllegalArgumentException("QCF not found: " + qcfNo);
        }

        List<PurchaseOrder> created = new ArrayList<>();
        long seq = purchaseOrderRepository.count();
        for (RfqHeader header : headers) {
            List<RfqDetail> details = rfqDetailRepository.findByRfqNo(header.getRfqNo());
            List<RfqDetail> recommended = details.stream()
                    .filter(d -> d.getPoQty() != null && d.getPoQty().compareTo(BigDecimal.ZERO) > 0)
                    .toList();
            if (recommended.isEmpty()) {
                continue;
            }

            seq++;
            PurchaseOrder po = new PurchaseOrder();
            po.setPoNo("PO" + String.format("%08d", seq));
            po.setQcfNo(qcfNo);
            po.setRfqNo(header.getRfqNo());
            po.setVendorId(header.getSoldTo());
            po.setVendorLabel(vendorLabel(header.getSoldTo()));
            po.setCompCode(header.getCompCode());
            po.setPlant(header.getPlant());
            po.setStatus("CREATED");
            po.setCreatedBy(buyer.getUserId());
            po.setCreatedOn(LocalDateTime.now());

            Map<String, Map<String, RfqItemCondition>> condByLine = groupConditionsByLine(header.getRfqNo(), header.getSoldTo());
            BigDecimal poTotal = BigDecimal.ZERO;
            for (RfqDetail d : recommended) {
                String lineNo = stripDecimal(d.getLineNo());
                Map<String, RfqItemCondition> lineConds = condByLine.getOrDefault(lineNo, Map.of());
                QuoteConditionInput disc = toConditionInput(lineConds.get("DISC"));
                QuoteConditionInput pkfw = toConditionInput(lineConds.get("PKFW"));
                QuoteConditionInput frt = toConditionInput(lineConds.get("FRT"));
                BigDecimal gst = lineConds.containsKey("TAX") ? parseBD(lineConds.get("TAX").getTaxValue()) : BigDecimal.ZERO;

                RfqConditionCalculator.LineCalc calc = RfqConditionCalculator.calculateDomestic(
                        d.getPoQty(), parseBD(d.getOrderUnit()), d.getPrice(), disc, pkfw, frt, gst);
                poTotal = poTotal.add(calc.grossValue());

                PurchaseOrderItem item = new PurchaseOrderItem();
                item.setPurchaseOrder(po);
                item.setLineNo(lineNo);
                item.setMaterial(d.getMaterial());
                item.setMaterialDesc(d.getMaterialDesc());
                item.setQty(d.getPoQty());
                item.setUom(d.getUom());
                item.setRate(d.getPrice());
                item.setLineValue(calc.grossValue());
                po.getItems().add(item);
            }
            po.setTotalValue(poTotal.setScale(2, RoundingMode.HALF_UP));
            po.setCurrency("INR");
            purchaseOrderRepository.save(po);
            created.add(po);
        }

        if (created.isEmpty()) {
            throw new IllegalStateException("No vendor was recommended a quantity on this QCF - nothing to order.");
        }
        return toSummaries(created);
    }

    @Override
    public List<PoSummary> getPurchaseOrders(String qcfNo) {
        return toSummaries(purchaseOrderRepository.findByQcfNo(qcfNo));
    }

    private List<PoSummary> toSummaries(List<PurchaseOrder> pos) {
        return pos.stream().map(po -> new PoSummary(
                po.getPoNo(), po.getVendorLabel(), po.getPlant(),
                po.getTotalValue() == null ? "0.00" : po.getTotalValue().toPlainString(),
                po.getCurrency(),
                po.getItems().stream()
                        .sorted(Comparator.comparing(PurchaseOrderItem::getLineNo))
                        .map(i -> new PoSummary.PoItemSummary(
                                i.getLineNo(), i.getMaterial(), i.getMaterialDesc(),
                                i.getQty() == null ? "0" : i.getQty().stripTrailingZeros().toPlainString(),
                                i.getUom(),
                                i.getRate() == null ? "0.00" : i.getRate().stripTrailingZeros().toPlainString(),
                                i.getLineValue() == null ? "0.00" : i.getLineValue().toPlainString()))
                        .toList()))
                .toList();
    }

    private String vendorLabel(String soldTo) {
        if (soldTo == null) {
            return "";
        }
        Users vendor = userRepository.findByUserId(stripLeadingZeros(soldTo));
        if (vendor == null) {
            return soldTo;
        }
        String name = ((vendor.getFirstName() == null ? "" : vendor.getFirstName()) + " "
                + (vendor.getLastName() == null ? "" : vendor.getLastName())).trim();
        return name.isEmpty() ? soldTo : name;
    }

    private String stripLeadingZeros(String s) {
        String stripped = s.replaceFirst("^0+(?!$)", "");
        return stripped.isEmpty() ? s : stripped;
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

    private String stripDecimal(BigDecimal v) {
        return v == null ? "" : v.stripTrailingZeros().toBigInteger().toString();
    }
}
