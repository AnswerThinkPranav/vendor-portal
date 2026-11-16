package com.ezc.aragenPR.webapp.sap.pr;

import com.ezc.aragenPR.webapp.model.pr.EzPurchaseRequisitionHeader;

/**
 * SAP I/O for Purchase Requisitions. Migration in progress - see each method's javadoc for
 * status. Mirrors {@code sap.vendor}/{@code sap.material}/{@code sap.ses}'s shape.
 *
 * <pre>
 * Operation code (SapOperationCode) | FM today                | OData status
 * -----------------------------------|--------------------------|----------------------------
 * PR_GETDETAIL                       | ZEZ_BAPI_PR_GETDETAIL    | MIGRATED (this gateway) - shape
 *                                     |                          | not yet verified against
 *                                     |                          | standard BAPI_REQUISITION_GETDETAIL
 * PR_CREATE                          | ZBAPI_PR_CREATE          | not migrated yet - shape confirmed
 *                                     |                          | to match standard BAPI_REQUISITION_CREATE
 * PR_CHANGE                          | ZBAPI_PR_CHANGE          | not migrated yet, same family
 * PR_SEARCH                          | Z_EZ_GET_PRS             | not migrated yet - genuinely
 *                                     |                          | custom (service.rfq.SapPrFetchServiceImpl)
 * PR_USER_DATA                       | ZEZ_PR_USER_DATA         | not migrated yet (genuinely custom)
 * PR_REL_DTLS                        | ZEZ_PR_REL_DTLS          | not migrated yet (genuinely custom)
 * PR_ACTIVE_WBS                      | ZEZ_ACTIVE_WBS           | not migrated yet (genuinely custom)
 * PR_PROJ_WBS                        | Z_EZ_GET_PROJ_WBS        | not migrated yet (genuinely custom)
 * PR_AGREEMENT_LIST                  | ZEZ_AGREEMENT_LIST       | not migrated yet (genuinely custom)
 * PR_GL_ACCOUNT                      | Z_EZ_GET_GL_ACCOUNT      | not migrated yet (genuinely custom)
 * </pre>
 *
 * <b>Important note on PR_GETDETAIL</b>: the same FM name is called from TWO places in
 * {@code PRController} with genuinely different parameters/output shape, not just different
 * surrounding code - {@code editPR} (regular PR, no SERVICES flag, no service lines) and
 * {@code editServicePR} (Service PR, sets {@code SERVICES="X"}, reads an extra SERVICELINES
 * table into {@code EzPurchaseRequisitionServices}). Both are migrated below as separate methods
 * rather than one, since forcing them into a single method would risk losing that distinction.
 */
public interface IPrSapGateway {

    /**
     * ZEZ_BAPI_PR_GETDETAIL (FM mode, regular PR - no SERVICES flag). Mutates {@code header} in
     * place exactly as the original inline code did (sets reqNumber/docType/items, and backfills
     * dept/division/purGrp/plant/accAsmt/itemCat from the first SAP line item if those are still
     * blank on the header) - kept as a mutation rather than a return value to avoid any
     * behavioral drift from the original controller code during this move. Throws on any SAP
     * error, matching the original try/catch that returned "errorPage" from the controller - the
     * controller catches this and does the same thing.
     */
    void getPrDetail(String reqNumber, EzPurchaseRequisitionHeader header);

    /**
     * ZEZ_BAPI_PR_GETDETAIL (FM mode, Service PR - sets SERVICES="X", reads SERVICELINES into
     * each item's {@code EzPurchaseRequisitionServices} list). Same mutation/error-handling
     * contract as {@link #getPrDetail}.
     */
    void getServicePrDetail(String reqNumber, EzPurchaseRequisitionHeader header);
}
