package com.ezc.aragenPR.webapp.model.chatbot;




import java.util.*;

public class StaticFAQData {

    public static class FAQ {
        public String question;
        public String answer;
        public String category;

        public FAQ(String question, String answer, String category) {
            this.question = question;
            this.answer = answer;
            this.category = category;
        }
    }

    private static final List<FAQ> PR_FAQS = Arrays.asList(
            new FAQ(
                    "How do I create a new Purchase Requisition?",
                    "To create a PR:\n1. Go to 'PR Creation' from the sidebar menu\n2. Click 'Create PR' button\n3. Fill in required fields:\n   • Document Type (ZNBR/ZOSO/ZRSR)\n   • Plant, Division, Department\n   • Purchase Group\n4. Add line items with material details\n5. Click 'Submit' to create\n\nThe system will generate a PR number (e.g., 4500012345).",
                    "PR"
            ),
            new FAQ(
                    "How can I edit my Purchase Requisition?",
                    "You can only edit PRs with 'UNRELEASED' status:\n1. Go to 'PR List' from the menu\n2. Find your PR (it will have 🟡 UNRELEASED status)\n3. Click the 'Edit' icon (pencil)\n4. Make your changes\n5. Click 'Update'\n\nNote: Once a PR is submitted for approval (PENDING status), you cannot edit it directly.",
                    "PR"
            ),
            new FAQ(
                    "What are the different PR statuses?",
                    "PR Status meanings:\n\n🟡 UNRELEASED - Created but not submitted. You can edit/delete.\n\n🟠 PENDING - In approval workflow. Waiting for approver(s).\n\n✅ RELEASED - Fully approved! Ready for Purchase Order creation.\n\n❌ REJECTED - Rejected during approval. Check comments and create new PR.",
                    "PR"
            ),
            new FAQ(
                    "How do I view my Purchase Requisitions?",
                    "To view your PRs:\n1. Click 'PR List' from the sidebar\n2. Use filters:\n   • Date Range (From/To dates)\n   • Status (Unreleased/Pending/Released)\n   • Document Type\n3. Click on any PR number to view full details\n4. You can also check status using the chatbot!",
                    "PR"
            )
    );

    private static final List<FAQ> SES_FAQS = Arrays.asList(
            new FAQ(
                    "What is a Service Entry Sheet (SES)?",
                    "A Service Entry Sheet (SES) is used to confirm that services have been completed for Service Purchase Orders.\n\nIt includes:\n• Service lines performed\n• Quantities completed\n• Final approval before payment\n\nSES must be approved before vendor payment is processed.",
                    "SES"
            ),
            new FAQ(
                    "How do I view my Service Entry Sheets?",
                    "To view SES:\n1. Go to 'Service Entry' → 'List' from sidebar\n2. The system shows SES from last 3 months by default\n3. Click 'Sync from SAP' to fetch latest data\n4. Click on any SES number to view details\n\nYou can also check SES status using the chatbot!",
                    "SES"
            ),
            new FAQ(
                    "How do I approve a Service Entry Sheet?",
                    "To approve an SES:\n1. Open the SES from the list\n2. Review service lines and quantities carefully\n3. If everything is correct:\n   • Click 'Release Entry Sheet' button\n   • Enter your release code\n   • Click 'Submit'\n4. System will post approval to SAP\n5. You'll get confirmation message",
                    "SES"
            ),
            new FAQ(
                    "What are the SES statuses?",
                    "SES Status meanings:\n\n🟡 CREATED - SES created but not yet approved.\n\n✅ APPROVED - SES approved and ready for payment processing.\n\n❌ REJECTED - SES was rejected. Service provider needs to correct and resubmit.",
                    "SES"
            )
    );

    private static final List<FAQ> RESERVATION_FAQS = Arrays.asList(
            new FAQ(
                    "What is a Reservation?",
                    "A Reservation is a request to reserve materials from warehouse for future use.\n\nKey points:\n• Reserves materials so others can't use them\n• Used for projects, maintenance, or production\n• Different from PR (PR is for buying new materials)\n• Materials are picked up from your own warehouse",
                    "RESERVATION"
            ),
            new FAQ(
                    "How do I create a Reservation?",
                    "To create a Reservation:\n1. Go to 'Reservation' → 'Create Reservation'\n2. Fill in details:\n   • Plant\n   • Movement Type (201/261/221)\n   • Material Code\n   • Quantity\n   • Cost Center or WBS Element\n   • Requirement Date\n3. Click 'Submit'\n4. System generates a reservation number",
                    "RESERVATION"
            ),
            new FAQ(
                    "What are Movement Types in Reservations?",
                    "Movement Types define how materials are consumed:\n\n• 201 - Goods Issue for Cost Center\n• 261 - Goods Issue for Order\n• 221 - Goods Issue for Project/WBS\n\nSelect based on where you're charging the material cost.",
                    "RESERVATION"
            ),
            new FAQ(
                    "How do I check my Reservations?",
                    "To view reservations:\n1. Go to 'Reservation' → 'List'\n2. Filter by:\n   • Date Range\n   • Status (Unreleased/Pending/Released)\n3. Click on reservation number for details\n4. You can also check status using the chatbot!",
                    "RESERVATION"
            )
    );

    public static List<FAQ> getAllFAQs() {
        List<FAQ> all = new ArrayList<>();
        all.addAll(PR_FAQS);
        all.addAll(SES_FAQS);
        all.addAll(RESERVATION_FAQS);
        return all;
    }

    public static List<FAQ> getFAQsByCategory(String category) {
        switch (category.toUpperCase()) {
            case "PR":
                return new ArrayList<>(PR_FAQS);
            case "SES":
                return new ArrayList<>(SES_FAQS);
            case "RESERVATION":
                return new ArrayList<>(RESERVATION_FAQS);
            default:
                return new ArrayList<>();
        }
    }

    public static Map<String, List<Map<String, String>>> getCategorizedFAQs() {
        Map<String, List<Map<String, String>>> categorized = new LinkedHashMap<>();

        // PR FAQs
        List<Map<String, String>> prList = new ArrayList<>();
        for (FAQ faq : PR_FAQS) {
            Map<String, String> item = new HashMap<>();
            item.put("question", faq.question);
            item.put("answer", faq.answer);
            prList.add(item);
        }
        categorized.put("PR", prList);

        // SES FAQs
        List<Map<String, String>> sesList = new ArrayList<>();
        for (FAQ faq : SES_FAQS) {
            Map<String, String> item = new HashMap<>();
            item.put("question", faq.question);
            item.put("answer", faq.answer);
            sesList.add(item);
        }
        categorized.put("SES", sesList);

        // Reservation FAQs
        List<Map<String, String>> resList = new ArrayList<>();
        for (FAQ faq : RESERVATION_FAQS) {
            Map<String, String> item = new HashMap<>();
            item.put("question", faq.question);
            item.put("answer", faq.answer);
            resList.add(item);
        }
        categorized.put("RESERVATION", resList);

        return categorized;
    }

    public static FAQ findAnswer(String question) {
        String queryLower = question.toLowerCase().trim();

        // Try exact matching first
        for (FAQ faq : getAllFAQs()) {
            if (faq.question.toLowerCase().contains(queryLower) ||
                    queryLower.contains(faq.question.toLowerCase())) {
                return faq;
            }
        }

        // Try keyword matching
        for (FAQ faq : getAllFAQs()) {
            String[] keywords = faq.question.toLowerCase().split("\\s+");
            int matches = 0;
            for (String keyword : keywords) {
                if (queryLower.contains(keyword) && keyword.length() > 3) {
                    matches++;
                }
            }
            if (matches >= 2) {
                return faq;
            }
        }

        return null;
    }
}