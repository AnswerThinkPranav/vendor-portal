package com.ezc.aragenPR.webapp.repository.rfq;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ezc.aragenPR.webapp.model.rfq.PurchaseOrder;

public interface PurchaseOrderRepository extends JpaRepository<PurchaseOrder, String> {

    List<PurchaseOrder> findByQcfNo(String qcfNo);
}
