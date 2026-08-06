class AragenApiError(Exception):
    """Raised when the Aragen PR Portal returns a non-2xx response."""

    def __init__(self, status_code: int, raw_body):
        self.status_code = status_code
        self.raw_body = raw_body
        super().__init__(f"Aragen API error {status_code}: {raw_body!r}")
