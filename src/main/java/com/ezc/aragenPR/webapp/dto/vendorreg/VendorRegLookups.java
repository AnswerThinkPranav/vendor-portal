package com.ezc.aragenPR.webapp.dto.vendorreg;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Static dropdown/checkbox option lists for the vendor registration form (Contact,
 * Constitution, MSME, Bank tabs). These are all hardcoded in the legacy
 * "Vendor Portal/JSP/Misc/ezCountryHT.jsp" (not database-driven, despite living
 * alongside DB-driven lookups elsewhere in that app) - reproduced verbatim here per the
 * instruction not to change dropdown structures. Country/currency name padding
 * (trailing spaces baked into the legacy strings) is trimmed since it served no visible
 * purpose in a modern UI; option values/keys are unchanged.
 */
public final class VendorRegLookups {

    private VendorRegLookups() {
    }

    public static List<OptionItem> countries() {
        Map<String, String> m = new LinkedHashMap<>();
        m.put("AD", "Andorran"); m.put("AE", "Utd.Arab Emir."); m.put("AF", "Afghanistan");
        m.put("AG", "Antigua/Barbuda"); m.put("AI", "Anguilla"); m.put("AL", "Albania");
        m.put("AM", "Armenia"); m.put("AN", "Dutch Antilles"); m.put("AO", "Angola");
        m.put("AQ", "Antarctica"); m.put("AR", "Argentina"); m.put("AS", "Samoa, America");
        m.put("AT", "Austria"); m.put("AU", "Australia"); m.put("AW", "Aruba");
        m.put("AZ", "Azerbaijan"); m.put("BA", "Bosnia-Herz."); m.put("BB", "Barbados");
        m.put("BD", "Bangladesh"); m.put("BE", "Belgium"); m.put("BF", "Burkina Faso");
        m.put("BG", "Bulgaria"); m.put("BH", "Bahrain"); m.put("BI", "Burundi");
        m.put("BJ", "Benin"); m.put("BL", "Blue"); m.put("BM", "Bermuda");
        m.put("BN", "Brunei Daruss."); m.put("BO", "Bolivia"); m.put("BR", "Brazil");
        m.put("BS", "Bahamas"); m.put("BT", "Bhutan"); m.put("BV", "Bouvet Islands");
        m.put("BW", "Botswana"); m.put("BY", "Belarus"); m.put("BZ", "Belize");
        m.put("CA", "Canada"); m.put("CC", "Coconut Islands"); m.put("CD", "Dem. Rep. Congo");
        m.put("CF", "CAR"); m.put("CG", "Rep.of Congo"); m.put("CH", "Switzerland");
        m.put("CI", "Cote d'Ivoire"); m.put("CK", "Cook Islands"); m.put("CL", "Chile");
        m.put("CM", "Cameroon"); m.put("CN", "China"); m.put("CO", "Colombia");
        m.put("CR", "Costa Rica"); m.put("CS", "Serbia/Monten."); m.put("CU", "Cuba");
        m.put("CV", "Cape Verde"); m.put("CX", "Christmas Islnd"); m.put("CY", "Cyprus");
        m.put("CZ", "Czech Republic"); m.put("DE", "Germany"); m.put("DJ", "Djibouti");
        m.put("DK", "Denmark"); m.put("DM", "Dominica"); m.put("DO", "Dominican Rep.");
        m.put("DZ", "Algeria"); m.put("EC", "Ecuador"); m.put("EE", "Estonia");
        m.put("EG", "Egypt"); m.put("EH", "West Sahara"); m.put("ER", "Eritrea");
        m.put("ES", "Spain"); m.put("ET", "Ethiopia"); m.put("EU", "European Union");
        m.put("FI", "Finland"); m.put("FJ", "Fiji"); m.put("FK", "Falkland Islnds");
        m.put("FM", "Micronesia"); m.put("FO", "Faroe Islands"); m.put("FR", "France");
        m.put("GA", "Gabon"); m.put("GB", "United Kingdom"); m.put("GC", "Guernsey");
        m.put("GD", "Grenada"); m.put("GE", "Georgia"); m.put("GF", "French Guayana");
        m.put("GH", "Ghana"); m.put("GI", "Gibraltar"); m.put("GL", "Greenland");
        m.put("GM", "Gambia"); m.put("GN", "Guinea"); m.put("GP", "Guadeloupe");
        m.put("GQ", "Equatorial Guin"); m.put("GR", "Greece"); m.put("GS", "S. Sandwich Ins");
        m.put("GT", "Guatemala"); m.put("GU", "Guam"); m.put("GW", "Guinea-Bissau");
        m.put("GY", "Guyana"); m.put("HK", "Hong Kong"); m.put("HM", "Heard/McDon.Isl");
        m.put("HN", "Honduras"); m.put("HR", "Croatia"); m.put("HT", "Haiti");
        m.put("HU", "Hungary"); m.put("ID", "Indonesia"); m.put("IE", "Ireland");
        m.put("IL", "Israel"); m.put("IN", "India"); m.put("IO", "Brit.Ind.Oc.Ter");
        m.put("IQ", "Iraq"); m.put("IR", "Iran"); m.put("IS", "Iceland");
        m.put("IT", "Italy"); m.put("JM", "Jamaica"); m.put("JO", "Jordan");
        m.put("JP", "Japan"); m.put("KE", "Kenya"); m.put("KG", "Kyrgyzstan");
        m.put("KH", "Cambodia"); m.put("KI", "Kiribati"); m.put("KM", "Comoros");
        m.put("KN", "St Kitts&Nevis"); m.put("KP", "North Korea"); m.put("KR", "South Korea");
        m.put("KW", "Kuwait"); m.put("KY", "Cayman Islands"); m.put("KZ", "Kazakhstan");
        m.put("LA", "Laos"); m.put("LB", "Lebanon"); m.put("LC", "St. Lucia");
        m.put("LI", "Liechtenstein"); m.put("LK", "Sri Lanka"); m.put("LR", "Liberia");
        m.put("LS", "Lesotho"); m.put("LT", "Lithuania"); m.put("LU", "Luxembourg");
        m.put("LV", "Latvia"); m.put("LY", "Libya"); m.put("MA", "Morocco");
        m.put("MC", "Monaco"); m.put("MD", "Moldova"); m.put("MG", "Madagascar");
        m.put("MH", "Marshall Islnds"); m.put("MK", "Macedonia"); m.put("ML", "Mali");
        m.put("MM", "Burma"); m.put("MN", "Mongolia"); m.put("MO", "Macau");
        m.put("MP", "N.Mariana Islnd"); m.put("MQ", "Martinique"); m.put("MR", "Mauretania");
        m.put("MS", "Montserrat"); m.put("MT", "Malta"); m.put("MU", "Mauritius");
        m.put("MV", "Maldives"); m.put("MW", "Malawi"); m.put("MX", "Mexico");
        m.put("MY", "Malaysia"); m.put("MZ", "Mozambique"); m.put("NA", "Namibia");
        m.put("NC", "New Caledonia"); m.put("NE", "Niger"); m.put("NF", "Norfolk Islands");
        m.put("NG", "Nigeria"); m.put("NI", "Nicaragua"); m.put("NL", "Netherlands");
        m.put("NO", "Norway"); m.put("NP", "Nepal"); m.put("NR", "Nauru");
        m.put("NT", "NATO"); m.put("NU", "Niue"); m.put("NZ", "New Zealand");
        m.put("OM", "Oman"); m.put("OR", "Orange"); m.put("PA", "Panama");
        m.put("PE", "Peru"); m.put("PF", "Frenc.Polynesia"); m.put("PG", "Pap. New Guinea");
        m.put("PH", "Philippines"); m.put("PK", "Pakistan"); m.put("PL", "Poland");
        m.put("PM", "St.Pier,Miquel."); m.put("PN", "Pitcairn Islnds"); m.put("PR", "Puerto Rico");
        m.put("PS", "Palestine"); m.put("PT", "Portugal"); m.put("PW", "Palau");
        m.put("PY", "Paraguay"); m.put("QA", "Qatar"); m.put("RE", "Reunion");
        m.put("RO", "Romania"); m.put("RU", "Russian Fed."); m.put("RW", "Rwanda");
        m.put("SA", "Saudi Arabia"); m.put("SB", "Solomon Islands"); m.put("SC", "Seychelles");
        m.put("SD", "Sudan"); m.put("SE", "Sweden"); m.put("SG", "Singapore");
        m.put("SH", "Saint Helena"); m.put("SI", "Slovenia"); m.put("SJ", "Svalbard");
        m.put("SK", "Slovakia"); m.put("SL", "Sierra Leone"); m.put("SM", "San Marino");
        m.put("SN", "Senegal"); m.put("SO", "Somalia"); m.put("SR", "Suriname");
        m.put("ST", "S.Tome,Principe"); m.put("SV", "El Salvador"); m.put("SY", "Syria");
        m.put("SZ", "Swaziland"); m.put("TC", "Turksh Caicosin"); m.put("TD", "Chad");
        m.put("TF", "French S.Territ"); m.put("TG", "Togo"); m.put("TH", "Thailand");
        m.put("TJ", "Tajikistan"); m.put("TK", "Tokelau Islands"); m.put("TL", "East Timor");
        m.put("TM", "Turkmenistan"); m.put("TN", "Tunisia"); m.put("TO", "Tonga");
        m.put("TP", "East Timor"); m.put("TR", "Turkey"); m.put("TT", "Trinidad,Tobago");
        m.put("TV", "Tuvalu"); m.put("TW", "Taiwan"); m.put("TZ", "Tanzania");
        m.put("UA", "Ukraine"); m.put("UG", "Uganda"); m.put("UM", "Minor Outl.Isl.");
        m.put("UN", "United Nations"); m.put("US", "United States"); m.put("UY", "Uruguay");
        m.put("UZ", "Uzbekistan"); m.put("VA", "Vatican City"); m.put("VC", "St. Vincent");
        m.put("VE", "Venezuela"); m.put("VG", "Brit.Virgin Is."); m.put("VI", "Amer.Virgin Is.");
        m.put("VN", "Vietnam"); m.put("VU", "Vanuatu"); m.put("WF", "Wallis,Futuna");
        m.put("WS", "Samoa"); m.put("XK", "Kosovo"); m.put("XM", "Montenegro");
        m.put("XS", "Serbia"); m.put("YE", "Yemen"); m.put("YT", "Mayotte");
        m.put("YU", "Yugoslavia"); m.put("ZA", "South Africa"); m.put("ZM", "Zambia");
        m.put("ZW", "Zimbabwe");
        return toOptions(m);
    }

    public static List<OptionItem> currencies() {
        Map<String, String> m = new LinkedHashMap<>();
        m.put("ADP", "Andoran peseta"); m.put("AED", "United Arab Emirates Dirham");
        m.put("AFA", "Afghani (Old)"); m.put("AFN", "Afghani"); m.put("ALL", "Albanian Lek");
        m.put("AMD", "Armenian Dram"); m.put("ANG", "West Indian Guilder");
        m.put("AOA", "Angolanische Kwanza"); m.put("AON", "Angolan New Kwanza (Old)");
        m.put("AOR", "Angolan Kwanza Reajustado (Old)"); m.put("ARS", "Argentine Peso");
        m.put("ATS", "Austrian Schilling"); m.put("AUD", "Australian Dollar");
        m.put("AWG", "Aruban Guilder"); m.put("AZM", "Azerbaijan Manat");
        m.put("BAM", "Bosnia and Herzegovina Convertible Mark"); m.put("BBD", "Barbados Dollar");
        m.put("BDT", "Bangladesh Taka"); m.put("BEF", "Belgian Franc");
        m.put("BGN", "Bulgarian Lev"); m.put("BHD", "Bahrain Dinar"); m.put("BIF", "Burundi Franc");
        m.put("BMD", "Bermudan Dollar"); m.put("BND", "Brunei Dollar"); m.put("BOB", "Boliviano");
        m.put("BRL", "Brazilian Real"); m.put("BSD", "Bahaman Dollar"); m.put("BTN", "Bhutan Ngultrum");
        m.put("BWP", "Botswana Pula"); m.put("BYB", "Belorussian Ruble (Old)");
        m.put("BYR", "Belorussian Ruble"); m.put("BZD", "Belize Dollar"); m.put("CAD", "Canadian Dollar");
        m.put("CDF", "Congolese Franc"); m.put("CFP", "French Franc (Pacific Islands)");
        m.put("CHF", "Swiss Franc"); m.put("CLP", "Chilean Peso");
        m.put("CNY", "Chinesische Yuan (international)"); m.put("COP", "Colombian Peso");
        m.put("CRC", "Costa Rica Colon"); m.put("CUP", "Cuban Peso"); m.put("CVE", "Cape Verde Escudo");
        m.put("CYP", "Cyprus Pound"); m.put("CZK", "Czech Krona"); m.put("DEM", "German Mark");
        m.put("DEM3", "(Internal) German Mark (3 dec.places)"); m.put("DJF", "Djibouti Franc");
        m.put("DKK", "Danish Krone"); m.put("DOP", "Dominican Peso"); m.put("DZD", "Algerian Dinar");
        m.put("ECS", "Ecuadorian Sucre (  > USD)"); m.put("EEK", "Estonian Krone");
        m.put("EGP", "Egyptian Pound"); m.put("ERN", "Eritrean Nafka"); m.put("ESP", "Spanish Peseta");
        m.put("ETB", "Ethiopian Birr"); m.put("EUR", "European Euro"); m.put("FIM", "Finnish markka");
        m.put("FJD", "Fiji Dollar"); m.put("FKP", "Falkland Pound"); m.put("FRF", "French Franc");
        m.put("GBP", "British Pound"); m.put("GEL", "Georgian Lari"); m.put("GHC", "Ghanian Cedi");
        m.put("GIP", "Gibraltar Pound"); m.put("GMD", "Gambian Dalasi"); m.put("GNF", "Guinean Franc");
        m.put("GRD", "Greek Drachma"); m.put("GTQ", "Guatemalan Quetzal"); m.put("GWP", "Guinea Peso");
        m.put("GYD", "Guyana Dollar"); m.put("HKD", "Hong Kong Dollar"); m.put("HNL", "Honduran Lempira");
        m.put("HRK", "Croatian Kuna"); m.put("HTG", "Haitian Gourde"); m.put("HUF", "Hungarian Forint");
        m.put("IDR", "Indonesian Rupiah"); m.put("IEP", "Irish Punt"); m.put("ILS", "Israeli Scheckel");
        m.put("INR", "Indian Rupee"); m.put("IQD", "Iraqui Dinar"); m.put("IRR", "Iranian Rial");
        m.put("ISK", "Iceland Krona"); m.put("ITL", "Italian Lira"); m.put("JMD", "Jamaican Dollar");
        m.put("JOD", "Jordanian Dinar"); m.put("JPY", "Japanese Yen"); m.put("KES", "Kenyan Shilling");
        m.put("KGS", "Kyrgyzstan Som"); m.put("KHR", "Cambodian Riel"); m.put("KMF", "Comoros Franc");
        m.put("KPW", "North Korean Won"); m.put("KRW", "South Korean Won"); m.put("KWD", "Kuwaiti Dinar");
        m.put("KYD", "Cayman Dollar"); m.put("KZT", "Kazakstanian Tenge"); m.put("LAK", "Laotian Kip");
        m.put("LBP", "Lebanese Pound"); m.put("LKR", "Sri Lankan Rupee"); m.put("LRD", "Liberian Dollar");
        m.put("LSL", "Lesotho Loti"); m.put("LTL", "Lithuanian Lita"); m.put("LUF", "Luxembourg Franc");
        m.put("LVL", "Latvian Lat"); m.put("LYD", "Libyan Dinar"); m.put("MAD", "Moroccan Dirham");
        m.put("MDL", "Moldavian Leu"); m.put("MGF", "Madagascan Franc"); m.put("MKD", "Macedonian Denar");
        m.put("MMK", "Myanmar Kyat"); m.put("MNT", "Mongolian Tugrik"); m.put("MOP", "Macao Pataca");
        m.put("MRO", "Mauritanian Ouguiya"); m.put("MTL", "Maltese Lira"); m.put("MUR", "Mauritian Rupee");
        m.put("MVR", "Maldive Rufiyaa"); m.put("MWK", "Malawi Kwacha"); m.put("MXN", "Mexican Pesos");
        m.put("MYR", "Malaysian Ringgit"); m.put("MZM", "Mozambique Metical"); m.put("NAD", "Namibian Dollar");
        m.put("NGN", "Nigerian Naira"); m.put("NIO", "Nicaraguan Cordoba Oro"); m.put("NLG", "Dutch Guilder");
        m.put("NOK", "Norwegian Krone"); m.put("NPR", "Nepalese Rupee"); m.put("NZD", "New Zealand Dollars");
        m.put("OMR", "Omani Rial"); m.put("PAB", "Panamanian Balboa"); m.put("PEN", "Peruvian New Sol");
        m.put("PGK", "Papua New Guinea Kina"); m.put("PHP", "Philippine Peso"); m.put("PKR", "Pakistani Rupee");
        m.put("PLN", "Polish Zloty (new)"); m.put("PTE", "Portuguese Escudo"); m.put("PYG", "Paraguayan Guarani");
        m.put("QAR", "Qatar Rial"); m.put("RMB", "Chinesische Renminbi (national)"); m.put("ROL", "Romanian Leu");
        m.put("RUB", "Russian Ruble"); m.put("RWF", "Rwandan Franc"); m.put("SAR", "Saudi Riyal");
        m.put("SBD", "Solomon Islands Dollar"); m.put("SCR", "Seychelles Rupee"); m.put("SDD", "Sudanese Dinar");
        m.put("SDP", "Sudanese Pound"); m.put("SEK", "Swedish Krona"); m.put("SGD", "Singapore Dollar");
        m.put("SHP", "St.Helena Pound"); m.put("SIT", "Slovenian Tolar"); m.put("SKK", "Slovakian Krona");
        m.put("SLL", "Sierra Leone Leone"); m.put("SOS", "Somalian Shilling"); m.put("SRG", "Surinam Guilder");
        m.put("STD", "Sao Tome / Principe Dobra"); m.put("SVC", "El Salvador Colon"); m.put("SYP", "Syrian Pound");
        m.put("SZL", "Swaziland Lilangeni"); m.put("THB", "Thailand Baht"); m.put("TJR", "Tajikistani Ruble (Old)");
        m.put("TJS", "Tajikistani Somoni"); m.put("TMM", "Turkmenistani Manat"); m.put("TND", "Tunisian Dinar");
        m.put("TOP", "Tongan Pa'anga"); m.put("TPE", "Timor Escudo"); m.put("TRL", "Turkish Lira");
        m.put("TTD", "Trinidad and Tobago Dollar"); m.put("TWD", "New Taiwan Dollar"); m.put("TZS", "Tanzanian Shilling");
        m.put("UAH", "Ukraine Hryvnia"); m.put("UGX", "Ugandan Shilling"); m.put("USD", "United States Dollar");
        m.put("USDN", "(Internal) United States Dollar (5 Dec.)"); m.put("UYU", "Uruguayan Peso (new)");
        m.put("UZS", "Uzbekistan Som"); m.put("VEB", "Venezuelan Bolivar"); m.put("VND", "Vietnamese Dong");
        m.put("VUV", "Vanuatu Vatu"); m.put("WST", "Samoan Tala"); m.put("XAF", "Gabon CFA Franc BEAC");
        m.put("XCD", "East Carribean Dollar"); m.put("XDS", "St. Christopher Dollar");
        m.put("XEU", "European Currency Unit (E.C.U.)"); m.put("XOF", "Benin CFA Franc BCEAO");
        m.put("XPF", "CFP Franc"); m.put("YER", "Yemeni Ryal"); m.put("YUM", "New Yugoslavian Dinar");
        m.put("ZAR", "South African Rand"); m.put("ZMK", "Zambian Kwacha"); m.put("ZRN", "Zaire (Old)");
        m.put("ZWD", "Zimbabwean Dollar");
        return toOptions(m);
    }

    /** GST-registration state codes for Address "state" dropdown - includes the duplicate/typo entries verbatim from legacy. */
    public static List<OptionItem> states() {
        Map<String, String> m = new LinkedHashMap<>();
        m.put("01", "Andra Pradesh"); m.put("02", "Arunachal Pradesh"); m.put("03", "Assam");
        m.put("04", "Bihar"); m.put("05", "Goa"); m.put("06", "Gujarat"); m.put("07", "Haryana");
        m.put("08", "Himachal Pradesh"); m.put("09", "Jammu and Kashmir"); m.put("10", "Karnataka");
        m.put("11", "Kerala"); m.put("12", "Madhya Pradesh"); m.put("13", "Maharashtra");
        m.put("14", "Manipur"); m.put("15", "Megalaya"); m.put("16", "Mizoram"); m.put("17", "Nagaland");
        m.put("18", "Orissa"); m.put("19", "Punjab"); m.put("20", "Rajasthan"); m.put("21", "Sikkim");
        m.put("22", "Tamil Nadu"); m.put("23", "Tripura"); m.put("24", "Uttar Pradesh");
        m.put("25", "West Bengal"); m.put("26", "Andaman and Nico"); m.put("27", "Chandigarh");
        m.put("28", "Dadra und Nagar Hav."); m.put("29", "Daman und Diu"); m.put("30", "Delhi");
        m.put("31", "Lakshadweep"); m.put("32", "Pondicherry"); m.put("33", "Chhaattisgarh");
        m.put("34", "Jharkhand"); m.put("35", "Uttarakhand"); m.put("36", "Telangana");
        m.put("AN", "Andhra Pradesh"); m.put("ND", "New Delhi"); m.put("HS", "Hertfordshire");
        m.put("DU", "DUBAI");
        return toOptions(m);
    }

    public static List<OptionItem> preferredContactMethods() {
        Map<String, String> m = new LinkedHashMap<>();
        m.put("PHE", "Phone"); m.put("EMA", "Email"); m.put("TXT", "Text");
        m.put("MSG", "Instant Message"); m.put("OTH", "Other");
        return toOptions(m);
    }

    /** Radio group; "OTH" is rendered separately in legacy (paired with a free-text box) but included here for completeness. */
    public static List<OptionItem> organizationTypes() {
        Map<String, String> m = new LinkedHashMap<>();
        m.put("PRP", "Proprietorship"); m.put("PAR", "Partnership"); m.put("PVT", "Private Limited");
        m.put("PUB", "Public Limited"); m.put("GOV", "Government organization");
        m.put("SEM", "Semi-Government organization"); m.put("OTH", "Other");
        return toOptions(m);
    }

    public static List<OptionItem> supplierTypes() {
        Map<String, String> m = new LinkedHashMap<>();
        m.put("MNF", "Manufacturer"); m.put("DTR", "Distributor"); m.put("SPR", "Service Providers");
        m.put("TDR", "Trader"); m.put("OTH", "Other");
        return toOptions(m);
    }

    public static List<OptionItem> vendorTypes() {
        Map<String, String> m = new LinkedHashMap<>();
        m.put("RAW", "Raw Materials"); m.put("PAK", "Packing Materials"); m.put("GEN", "General");
        m.put("CAP", "Capital"); m.put("SSP", "Stores & Spares"); m.put("EMP", "Employees Payable");
        m.put("SRV", "Services");
        return toOptions(m);
    }

    public static List<OptionItem> gstVendorClassifications() {
        // Legacy quirk: "" (empty string) = Registered, not a placeholder - preserved as-is.
        Map<String, String> m = new LinkedHashMap<>();
        m.put("", "Registered"); m.put("0", "Unregistered");
        return toOptions(m);
    }

    public static List<OptionItem> gstRegistrationTypes() {
        Map<String, String> m = new LinkedHashMap<>();
        m.put("0", "Regular"); m.put("1", "Composition Scheme");
        return toOptions(m);
    }

    public static List<OptionItem> msmeStatusTypes() {
        Map<String, String> m = new LinkedHashMap<>();
        m.put("0", "Non-MSME"); m.put("1", "Micro"); m.put("5", "Small"); m.put("9", "Medium");
        return toOptions(m);
    }

    public static List<OptionItem> businessStatusTypes() {
        Map<String, String> m = new LinkedHashMap<>();
        m.put("DTA", "DTA"); m.put("SEZ", "SEZ Unit/SEZ Developer"); m.put("EOU", "EOU/EHTP/STP/BTP");
        m.put("OTH", "OTHER");
        return toOptions(m);
    }

    private static List<OptionItem> toOptions(Map<String, String> m) {
        return m.entrySet().stream().map(e -> new OptionItem(e.getKey(), e.getValue())).toList();
    }
}
