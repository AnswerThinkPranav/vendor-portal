package com.ezc.aragenPR.webapp.service.shared;



import com.ezc.aragenPR.webapp.model.shared.EzLinkController;

public interface IEmailService {
	public void sendSimpleMessage(String to, String subject, String text);
	public EzLinkController saveLink(EzLinkController linkController);
	public EzLinkController getDetailsById(Integer id);
}
