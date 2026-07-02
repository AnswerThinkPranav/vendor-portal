package com.ezc.aragenPR.webapp.service.shared;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.ezc.aragenPR.webapp.dto.shared.EmailFormat;
import com.ezc.aragenPR.webapp.model.shared.EzLinkController;
import com.ezc.aragenPR.webapp.model.user.Users;
import com.ezc.aragenPR.webapp.repository.shared.LinkControllerRepo;
import com.ezc.aragenPR.webapp.repository.user.UserRepository;
import com.ezc.aragenPR.webapp.util.EzCipher;
import com.google.protobuf.Message;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.AddressException;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;
import com.ezc.aragenPR.webapp.service.shared.IEmailService;
import com.ezc.aragenPR.webapp.service.user.IUserService;


@Service
@Transactional
@Slf4j
public class EmailServiceImpl implements IEmailService {

	@Autowired 
    private JavaMailSender emailSender;
	
	@Autowired 
    private LinkControllerRepo linkRepo;
	
	
	@Autowired 
    private UserRepository userRepository ;
	
	@Autowired 
    private IUserService iUserService;
	
	
	@Value("${site.url}")
	private String siteUrl="";
	
	@Value("${mail.fromaddress}")
	private String fromEmail="";
	
	@Value("${mail.ccmail}")
	private String ccmail="";
	
	@Override
	public void sendSimpleMessage(String to, String subject, String text) {
		SimpleMailMessage message = new SimpleMailMessage(); 
        message.setFrom(fromEmail);
        message.setTo(to); 
        message.setSubject(subject); 
        message.setText(text);
        try {
			emailSender.send(message);
		} catch (Exception e) {
			log.debug("Error in sending mails:::"+e);
		}
	}
	@Override
	public EzLinkController saveLink(EzLinkController linkController) {
		return linkRepo.save(linkController);
		
	}
	@Override
	public EzLinkController getDetailsById(Integer id) {
		Optional<EzLinkController> linkContOpt=linkRepo.findById(id);
		if(linkContOpt.isPresent())
			return linkContOpt.get();
		else
			return null;
	}

	
}
