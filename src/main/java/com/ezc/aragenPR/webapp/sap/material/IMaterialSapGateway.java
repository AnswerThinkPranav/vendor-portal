package com.ezc.aragenPR.webapp.sap.material;

import java.util.List;

import com.ezc.aragenPR.webapp.dto.pr.MaterialDto;

/**
 * SAP I/O for Material master data. Migrated from {@code controller.pr.PRController}'s
 * {@code getMaterials}/{@code getMaterialDetails} endpoints - those now call this gateway instead
 * of touching JCo directly. See {@link MaterialSapGateway} for the FM/OData dispatch.
 *
 * Both FMs here are already genuinely standard (confirmed, not just name-pattern-suggested):
 * {@code BAPI_MATERIAL_GETLIST} / {@code BAPI_MATERIAL_GET_DETAIL} - no Z-wrapper at all, called
 * directly. That makes {@code MATERIAL_SEARCH}/{@code MATERIAL_GETDETAIL} the best near-term
 * OData-migration candidates in the app once a real S/4 Product/Material OData service name is
 * confirmed from the Business Accelerator Hub.
 */
public interface IMaterialSapGateway {

    /** BAPI_MATERIAL_GETLIST (FM mode). searchType is "shortText" or "matNumber". */
    List<MaterialDto> searchMaterials(String plant, String query, String searchType);

    /** BAPI_MATERIAL_GET_DETAIL (FM mode), plus a supplementary RFC_READ_TABLE on MARA for CAS/catalog fields. */
    List<MaterialDto> getMaterialDetails(String plant, String materialCode);
}
