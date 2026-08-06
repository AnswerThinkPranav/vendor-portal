from datetime import date
from decimal import Decimal
from typing import Literal, Optional

from pydantic import BaseModel, field_serializer, model_validator

# Mirrors PRController's SAP PRACCOUNT branch: F->internalOrder, P/Q->wbsElement,
# N->network, K->costCenter. See src/main/java/.../controller/pr/PRController.java.
_ACC_ASMT_REQUIRED_FIELD = {
    "F": "internalOrder",
    "P": "wbsElement",
    "Q": "wbsElement",
    "N": "network",
    "K": "costCenter",
}


class PRService(BaseModel):
    """Mirrors com.ezc.aragenPR.webapp.dto.pr.PRService - one service line of a Service PR item."""

    servLine: Optional[str] = None
    servNo: Optional[str] = None
    servDesc: Optional[str] = None
    servQty: Optional[Decimal] = None
    servUnit: Optional[str] = None
    servPrice: Optional[Decimal] = None
    servNetPrice: Optional[Decimal] = None


class PRItem(BaseModel):
    """Mirrors com.ezc.aragenPR.webapp.dto.pr.PRItem."""

    itemNumber: Optional[str] = None
    division: Optional[str] = None
    department: Optional[str] = None
    matNumber: Optional[str] = None
    shortText: Optional[str] = None
    cas: Optional[str] = None
    quantity: Decimal
    uom: str
    plant: str
    valPrice: Decimal
    total: Optional[Decimal] = None
    materialGroup: Optional[str] = None
    deliveryDate: date
    periodInd: Optional[str] = None
    purGrp: Optional[str] = None
    accAsmt: Optional[Literal["F", "P", "Q", "N", "K"]] = None
    reqName: Optional[str] = None
    glAcc: Optional[str] = None
    glAccDesc: Optional[str] = None
    projCode: Optional[str] = None
    projCodeDesc: Optional[str] = None
    wbsElement: Optional[str] = None
    internalOrder: Optional[str] = None
    network: Optional[str] = None
    costCenter: Optional[str] = None
    storageLoc: Optional[str] = None
    trackNo: Optional[str] = None
    packSize: Optional[str] = None
    coa: Optional[str] = None
    passThrough: Optional[str] = None
    msds: Optional[str] = None
    status: Optional[str] = None
    reason: Optional[str] = None
    agreement: Optional[str] = None
    catalog: Optional[str] = None
    fixVendor: Optional[str] = None
    aggrItem: Optional[str] = None
    currency: Optional[str] = None
    services: list[PRService] = []

    @field_serializer("deliveryDate")
    def _serialize_delivery_date(self, value: date) -> str:
        return value.isoformat()

    @model_validator(mode="after")
    def _check_account_assignment_field(self):
        required_field = _ACC_ASMT_REQUIRED_FIELD.get(self.accAsmt) if self.accAsmt else None
        if required_field and not getattr(self, required_field):
            raise ValueError(f"accAsmt={self.accAsmt!r} requires {required_field!r} to be set")
        return self


class PRRequest(BaseModel):
    """Mirrors com.ezc.aragenPR.webapp.dto.pr.PRRequest - body for postPR/postServicePR/update/updateServicePR."""

    logonSite: Optional[str] = None
    docType: str
    division: Optional[str] = None
    accAsmt: Optional[str] = None
    itemCateg: Optional[str] = None
    plant: str
    purGrp: Optional[str] = None
    department: Optional[str] = None
    catalog: Optional[str] = None
    sapReqName: Optional[str] = None
    portalRefNO: Optional[str] = None
    aonNo: Optional[str] = None
    sapPrRel: Optional[str] = None
    reqNumber: Optional[str] = None
    items: list[PRItem]
