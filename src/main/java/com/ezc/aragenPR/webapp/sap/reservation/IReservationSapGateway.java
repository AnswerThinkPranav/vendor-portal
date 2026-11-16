package com.ezc.aragenPR.webapp.sap.reservation;

/**
 * SAP I/O for stock Reservations - reserved package shape, mirroring {@code sap.vendor}.
 * <b>Not migrated yet</b> - these calls still live inline in
 * {@code service.reservation.ReservationService} and {@code controller.reservation.
 * ReservationController}.
 *
 * <pre>
 * Operation code              | FM today                        | OData status
 * ------------------------------|----------------------------------|---------------------------
 * RESERVATION_CREATE            | ZEZ_BAPI_RESERVATION_CREATE1     | name suggests a thin wrapper
 *                                |                                   | around standard
 *                                |                                   | BAPI_RESERVATION_CREATE1 -
 *                                |                                   | NOT parameter-verified
 * RESERVATION_CHANGE            | ZEZ_BAPI_RESERVATION_CHANGE      | same family, not verified
 * RESERVATION_GETDETAIL         | ZEZ_BAPI_RESERVATION_GETDETAIL   | same family, not verified
 * RESERVATION_ACTIVE_WBS        | ZEZ_ACTIVE_WBS                   | genuinely custom (lookup) -
 *                                |                                   | same FM also called from
 *                                |                                   | PRController under
 *                                |                                   | SapOperationCode.PR_ACTIVE_WBS
 * </pre>
 *
 * Migration plan once undertaken: same shape as {@code sap.vendor.VendorSapGateway} - move each
 * `getFunction("...")` block verbatim into an {@code fmXxx} method here, dispatch via
 * {@link com.ezc.aragenPR.webapp.sap.SapIntegrationModeConfig}.
 */
public interface IReservationSapGateway {
    // Signatures intentionally not declared yet - see IPrSapGateway's javadoc for why.
}
