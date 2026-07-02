package com.ezc.aragenPR.webapp.controller.chatbot;




	import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import lombok.extern.slf4j.Slf4j;
	
	@Slf4j
	@Controller 
	@RequestMapping("/faq")
	public class FAQController {

	   	    @RequestMapping(value = "/faqAll", method = RequestMethod.GET)
	    public String faqAll(Model model) {
	    	 
	        return "/FAQ/FAQ1"; 

	    }
	    
	   
	 
}
