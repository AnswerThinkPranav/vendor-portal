from typing import Any, Optional

from pydantic import BaseModel


class SapPostResult(BaseModel):
    """Shape returned by prCreate/postPR, postServicePR, update, updateServicePR.

    The exact vocabulary of `status` and whether SAP's RETURN-table rows come through
    as a flat string or a structured list is unconfirmed against a live response -
    treat the parsing in tools/pr_write.py as provisional until verified (see plan's
    verification section).
    """

    status: Optional[str] = None
    sapPrNumber: Optional[str] = None
    message: Optional[Any] = None
