package com.ezc.aragenPR.webapp.controller.pr;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.method.annotation.MvcUriComponentsBuilder;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ezc.aragenPR.webapp.error.StorageFileNotFoundException;
import com.ezc.aragenPR.webapp.model.pr.EzUploadDocument;
//import com.ezc.aragenPR.webapp.service.IPPAPService;
import com.ezc.aragenPR.webapp.service.pr.IStorageService;

import lombok.extern.slf4j.Slf4j;


@Slf4j
@RestController
public class FileUploadController {

	private final IStorageService storageService;
	
	//@Autowired
	//IPPAPService ppapService;

	@Autowired
	public FileUploadController(IStorageService storageService) {
		this.storageService = storageService;
	}

	@GetMapping("fileUpload/list")
	public String listUploadedFiles(Model model) throws IOException {

		model.addAttribute("files", storageService.loadAll().map(
				path -> MvcUriComponentsBuilder.fromMethodName(FileUploadController.class,
						"serveFile", path.getFileName().toString()).build().toUri().toString())
				.collect(Collectors.toList()));

		return "redirect:/dashboard";
	}
	
	@GetMapping("fileUpload/show") 
	public String show() throws IOException {

		
		return "/ppap/uploadForm";
	}

	@GetMapping("/files/{filename:.+}")
	@ResponseBody
	public ResponseEntity<Resource> serveFile(@PathVariable String filename) {

		Resource file = storageService.loadAsResource(filename);

		if (file == null)
			return ResponseEntity.notFound().build();

		return ResponseEntity.ok().header(HttpHeaders.CONTENT_DISPOSITION,
				"attachment; filename=\"" + file.getFilename() + "\"").body(file);
	}

	@PostMapping("/fileUpload/handle/{docNo}/{docType}/{docItemType}")
	public ResponseEntity<?> handleFileUpload(@PathVariable("docNo") Integer docNo,@PathVariable String docType,@PathVariable String docItemType,@RequestParam("file") MultipartFile file) {
		log.debug("entered into file upload::"+docNo);
		  Map<String, String> response = new HashMap<>(); 
		 
		  
		storageService.saveFilePermanently(docNo,file,docType,docItemType);
	    response.put("message", "File uploaded successfully");  
	    response.put("fileName", file.getOriginalFilename());
		
		return ResponseEntity.ok(response);  
	}
	

	@ExceptionHandler(StorageFileNotFoundException.class)
	public ResponseEntity<?> handleStorageFileNotFound(StorageFileNotFoundException exc) {
		return ResponseEntity.notFound().build();
	}
	
	// apis to store the file temporarily based on UUID approach
	  @PostMapping("/files/upload-temp")
	    public ResponseEntity<?> uploadTempFile(@RequestParam("file") MultipartFile file) throws IOException {
		  Map<String, String> response = new HashMap<>();
		  log.debug("Entered into uploadTempFile::");
		  try {
	        String uniqueFilename = storageService.saveFileTemporarily(file);
			 response.put("message", "File uploaded successfully");
			 response.put("filename", uniqueFilename);
			 response.put("fileName", file.getOriginalFilename());
			  log.debug("uniqueFilename::"+uniqueFilename); 
			  
		  }
		  catch(Exception e) {
			  log.debug("Error::"+e.getMessage());		  }

	        return ResponseEntity.ok(response);
	    }
	  
	  
	    @DeleteMapping("/delete/{filename}/{docNo}/{docType}/{docItemType}")
	    public ResponseEntity<?> deleteFile(@PathVariable String filename,@PathVariable Integer docNo,@PathVariable String docType,@PathVariable String docItemType) throws IOException {
	        storageService.deleteFile(filename,docNo,docType,docItemType);
			 return ResponseEntity.ok("File deleted successfully");
	        
	    }
	    
	    @DeleteMapping("/delete/{filename}")
	    public ResponseEntity<?> deleteFile(@PathVariable String filename) throws IOException {
	        storageService.deleteTemporaryFile(filename);
			 return ResponseEntity.ok("File deleted successfully");
	        
	    }
	    
	    
	    @GetMapping("/download/{fileName}/{docNo}/{docType}/{docItemType}")
	    public ResponseEntity<Resource> downloadFile(@PathVariable String fileName,@PathVariable Integer docNo,@PathVariable String docType,@PathVariable String docItemType) {
	    	String action="download";
	    	return storageService.downloadFile(fileName,docNo,docType,docItemType,action);
	      
	    }
	    
	    @GetMapping("/view/{fileName}/{docNo}/{docType}/{docItemType}")
	    public ResponseEntity<Resource> viewFile(@PathVariable String fileName,@PathVariable Integer docNo,@PathVariable String docType,@PathVariable String docItemType) {
	    	String action="view";
	    	
	    	return storageService.downloadFile(fileName,docNo,docType,docItemType,action);
	      
	    }
	    
	

}