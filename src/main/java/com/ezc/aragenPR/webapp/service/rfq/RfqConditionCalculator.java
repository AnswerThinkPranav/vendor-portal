package com.ezc.aragenPR.webapp.service.rfq;

import java.math.BigDecimal;
import java.math.RoundingMode;

import com.ezc.aragenPR.webapp.dto.rfq.QuoteConditionInput;

/**
 * Ports the exact client-side calculation formula from Vendor Portal/JSP/RFQ/ezSaveConditions.jsp
 * and ezPostQuote.jsp's checkNum() (domestic only): basicValue = (qty/perQty)*price; each of
 * Discount/Pkg&Fwd/Freight is P=percent-of-base, Q=per-qty, or V=flat value, where Discount's
 * base is basicValue and Pkg&Fwd/Freight's base is (basicValue-discount); netValue = basicValue
 * - discount + pkg&fwd + freight; GST is a flat percent of netValue; grossValue = netValue + GST.
 * Shared between the RFQ quote-submit flow and the QCF Quotation Comparison Form (which
 * re-derives a vendor's quoted total from their already-persisted conditions).
 */
public final class RfqConditionCalculator {

    private RfqConditionCalculator() {
    }

    public record LineCalc(BigDecimal basicValue, BigDecimal discVal, BigDecimal pkfwVal, BigDecimal frtVal,
                            BigDecimal netValue, BigDecimal taxVal, BigDecimal grossValue) {
    }

    public static LineCalc calculateDomestic(BigDecimal qty, BigDecimal perQty, BigDecimal price,
            QuoteConditionInput disc, QuoteConditionInput pkfw, QuoteConditionInput frt, BigDecimal gstPercent) {
        BigDecimal safeQty = qty == null ? BigDecimal.ZERO : qty;
        BigDecimal safePerQty = (perQty == null || perQty.compareTo(BigDecimal.ZERO) == 0) ? BigDecimal.ONE : perQty;
        BigDecimal safePrice = price == null ? BigDecimal.ZERO : price;

        BigDecimal basicValue = safeQty.divide(safePerQty, 6, RoundingMode.HALF_UP)
                .multiply(safePrice).setScale(2, RoundingMode.HALF_UP);

        BigDecimal discVal = conditionAmount(disc, basicValue, safeQty, safePerQty);
        BigDecimal netAfterDisc = basicValue.subtract(discVal);

        BigDecimal pkfwVal = conditionAmount(pkfw, netAfterDisc, safeQty, safePerQty);
        BigDecimal frtVal = conditionAmount(frt, netAfterDisc, safeQty, safePerQty);

        BigDecimal netValue = basicValue.subtract(discVal).add(pkfwVal).add(frtVal).setScale(2, RoundingMode.HALF_UP);

        BigDecimal safeGst = gstPercent == null ? BigDecimal.ZERO : gstPercent;
        BigDecimal taxVal = netValue.multiply(safeGst).divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);

        BigDecimal grossValue = netValue.add(taxVal).setScale(2, RoundingMode.HALF_UP);

        return new LineCalc(basicValue, discVal, pkfwVal, frtVal, netValue, taxVal, grossValue);
    }

    public static BigDecimal conditionAmount(QuoteConditionInput cond, BigDecimal base, BigDecimal qty, BigDecimal perQty) {
        if (cond == null || cond.type() == null || cond.type().isBlank() || cond.value() == null) {
            return BigDecimal.ZERO;
        }
        BigDecimal val = cond.value();
        return switch (cond.type()) {
            case "P" -> base.multiply(val).divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
            case "V" -> val.setScale(2, RoundingMode.HALF_UP);
            case "Q" -> val.multiply(qty).divide(perQty, 2, RoundingMode.HALF_UP);
            default -> BigDecimal.ZERO;
        };
    }
}
