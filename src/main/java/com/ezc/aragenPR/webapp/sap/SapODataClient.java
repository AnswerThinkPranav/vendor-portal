package com.ezc.aragenPR.webapp.sap;

import com.fasterxml.jackson.databind.JsonNode;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.nio.charset.StandardCharsets;
import java.util.Base64;

/**
 * Generic SAP OData V2/V4 client, built on {@code spring-boot-starter-webflux}'s WebClient
 * (already a dependency, previously unused anywhere in the app - deliberately not adding Apache
 * Olingo, which is a stale/largely-unmaintained line for OData V2 and would likely conflict with
 * this project's pinned httpclient 4.5.4).
 *
 * Handles the one piece that's easy to get wrong: SAP NetWeaver Gateway requires an
 * "X-CSRF-Token: Fetch" handshake on a GET before it will accept any write (POST/PUT/DELETE) -
 * the fetched token plus the session cookie from that same response must be replayed on the
 * write call, or SAP returns 403.
 *
 * Base URL / credentials come from sap.odata.* in sap.properties (same override convention as
 * every other sap.* property - safe local-dev placeholders checked in, real values only via the
 * uncommitted application-prod.properties). Per-tenant base URLs are a follow-on once the
 * multi-tenant SAP connection registry lands - this client takes the base URL as a constructor/
 * call argument precisely so that swap is additive later, not a rewrite.
 */
@Slf4j
@Service
public class SapODataClient {

    @Autowired
    private Environment env;

    private WebClient webClient(String baseUrl) {
        String user = env.getProperty("sap.odata.user", "");
        String password = env.getProperty("sap.odata.password", "");
        String basicAuth = Base64.getEncoder().encodeToString((user + ":" + password)
                .getBytes(StandardCharsets.UTF_8));
        return WebClient.builder()
                .baseUrl(baseUrl)
                .defaultHeader(HttpHeaders.AUTHORIZATION, "Basic " + basicAuth)
                .defaultHeader(HttpHeaders.ACCEPT, MediaType.APPLICATION_JSON_VALUE)
                .build();
    }

    public String getBaseUrl() {
        return env.getProperty("sap.odata.base-url", "");
    }

    /** Plain GET against an OData entity set/path, e.g. "/API_SUPPLIER/A_Supplier('1000')". */
    public JsonNode get(String baseUrl, String path) {
        return webClient(baseUrl).get()
                .uri(path.contains("?") ? path + "&$format=json" : path + "?$format=json")
                .retrieve()
                .bodyToMono(JsonNode.class)
                .block();
    }

    /**
     * CSRF-protected write (POST create / PUT update). Does the Fetch handshake against
     * {@code csrfFetchPath} (normally the service root or $metadata), then replays the token +
     * session cookie on the actual write.
     */
    public JsonNode post(String baseUrl, String csrfFetchPath, String writePath, Object body) {
        WebClient client = webClient(baseUrl);

        CsrfToken token = client.get()
                .uri(csrfFetchPath)
                .header("X-CSRF-Token", "Fetch")
                .exchangeToMono(response -> {
                    String csrf = response.headers().asHttpHeaders().getFirst("X-CSRF-Token");
                    String cookie = String.join("; ", response.headers().asHttpHeaders().get(HttpHeaders.SET_COOKIE) == null
                            ? java.util.List.<String>of()
                            : response.headers().asHttpHeaders().get(HttpHeaders.SET_COOKIE));
                    return response.releaseBody().thenReturn(new CsrfToken(csrf, cookie));
                })
                .block();

        if (token == null || token.csrf == null) {
            throw new IllegalStateException("SAP OData CSRF handshake failed against " + baseUrl + csrfFetchPath
                    + " - the service may not require/support CSRF, or the base URL/credentials are wrong");
        }

        return client.post()
                .uri(writePath)
                .header("X-CSRF-Token", token.csrf)
                .header(HttpHeaders.COOKIE, token.cookie)
                .contentType(MediaType.APPLICATION_JSON)
                .bodyValue(body)
                .retrieve()
                .bodyToMono(JsonNode.class)
                .block();
    }

    private record CsrfToken(String csrf, String cookie) {
    }
}
