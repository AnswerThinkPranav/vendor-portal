package com.ezc.aragenPR.webapp.sap.po;

/**
 * Reserved for posting a Purchase Order to SAP, mirroring the {@code sap.vendor} package's shape
 * (business flow stays in {@code service.rfq.PoServiceImpl}; the actual SAP call would live
 * entirely here, behind an interface like {@link IVendorSapGateway}-but-for-PO once built).
 *
 * <b>Not implemented yet.</b> Today's "Create PO" (see {@code service.rfq.PoServiceImpl},
 * {@code model.rfq.PurchaseOrder}) is a real local record only - no SAP posting exists, by
 * design (mirrors how Vendor Registration's SAP posting was simplified when this app had no SAP
 * connection). When PO-to-SAP posting is needed, the standard target is {@code BAPI_PO_CREATE1}
 * (FM mode - genuinely standard, present on essentially any SAP system) or the client's own
 * Gateway purchase-order OData service (ODATA mode, name TBD - do not guess it, confirm it the
 * same way as every other operation in {@code SapOperationCode}/{@code sap.odata.service.*}).
 */
public interface IPoSapGateway {
    // No methods yet - this file exists to reserve the package/contract shape, per the user's
    // explicit request to lay out the architecture (subpackages per SAP-posting operation)
    // before any PO-to-SAP code is actually written.
}
