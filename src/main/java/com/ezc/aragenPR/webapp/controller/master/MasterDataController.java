/*
package com.ezc.aragenPR.webapp.controller.master;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.method.annotation.StreamingResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ezc.aragenPR.webapp.dto.master.PlaceMasterDto;
import com.ezc.aragenPR.webapp.dto.master.SeqCondMapInput;
import com.ezc.aragenPR.webapp.dto.master.SeqCondMapObj;
import com.ezc.aragenPR.webapp.dto.master.SequenceDto;
import com.ezc.aragenPR.webapp.dto.shared.WFInput;
import com.ezc.aragenPR.webapp.dto.shared.WFRow;
import com.ezc.aragenPR.webapp.model.master.EzConditionSeqMap;
import com.ezc.aragenPR.webapp.model.master.EzConditionValueMap;
import com.ezc.aragenPR.webapp.model.EzMaterialLimitKey;
import com.ezc.aragenPR.webapp.model.EzMaterialLimits;
import com.ezc.aragenPR.webapp.model.EzPriceSeqMaster;
import com.ezc.aragenPR.webapp.model.master.EzValueMapping;
import com.ezc.aragenPR.webapp.model.shared.EzWorkFlowKey;
import com.ezc.aragenPR.webapp.model.shared.EzWorkFlowMapping;
import com.ezc.aragenPR.webapp.model.user.Users;
import com.ezc.aragenPR.webapp.repository.shared.WorkflowKeyCustomDto;
import com.ezc.aragenPR.webapp.service.master.IMasterService;
import com.ezc.aragenPR.webapp.service.IPriceReqService;
import com.ezc.aragenPR.webapp.service.user.IUserService;
import com.ezc.aragenPR.webapp.util.EzExcelUtil;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/master")
public class MasterDataController {

    @Autowired
    IPriceReqService priceReqService;
	
    @Autowired
    IUserService userService;
	
	@Autowired
	IMasterService masterService;
	
	@Autowired
	WorkflowKeyCustomDto wfCustomDto;
	
	@Autowired
    private EzExcelUtil ezExcelUtil;

//
//	@Autowired
//	 private com.ezc.outsrc.webapp.sap.IMasterService iSAPMasterService;

	@Value("#{'${city}'.split(',')}")
	private List<String> city;
	
	
	@GetMapping("/addCity") 
	public String showAddCity(Model model) {
		
		model.addAttribute("placeMasterDto",new PlaceMasterDto());

		return "master/addCity";
	}
	@PostMapping("/addCity")
	public String saveCity(@Valid @ModelAttribute("placeMasterDto") PlaceMasterDto pDto, 
			BindingResult bindingResult, RedirectAttributes ra, Model model)  {
		log.debug("saving city");
		if(bindingResult.hasErrors()) {
			
			log.info("bindingResult:::::of City {}",bindingResult);
			return "master/addCity";
		}else {
			ra.addFlashAttribute("success", "City added successfully.");
			masterService.addNewCity(pDto);
		
		}
		
		return "redirect:/master/addCity"; 
	}
	@PostMapping("/delete-city/{id}")
	public String deleteCity(@PathVariable int id) {
		log.debug("code"+id);
			masterService.deleteCity(id);
			return "redirect:/master/listCity";
	}
	@GetMapping("/listCity") 
	public String listCity(Model model) {
		
		model.addAttribute("cityList", masterService.findAllCities());

		return "master/cityList";
	}

	@RequestMapping(value="/getExistingCity/{city}",method=RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody int getExistingCity(@PathVariable String city)
	{
		PlaceMasterDto pdto=masterService.getCityDetails(city);
		int id;
		try {
			id=pdto.getId();
		}catch(Exception e)
		{
			id=0;
		}
		log.debug("response"+id);
		return id;
	}

    @RequestMapping("/mapseq/add")
    public String addMapSeq(Model model) {
    	List<Users> creatorList=userService.findUsersByRole("ROLE_INT");
    	List<Users> gcCreatorList=userService.findUsersByRole("ROLE_ST_HEAD");
    	if(gcCreatorList != null)
    		creatorList.addAll(gcCreatorList); 
    	SeqCondMapInput seqCondMapInput = new SeqCondMapInput();
    	seqCondMapInput.setCreatorList(creatorList);
        model.addAttribute("seqCondMapInput", seqCondMapInput);
        return "master/addSeqCondMap";

    }
    
    @RequestMapping(value = "/mapseq/conddetails", method = RequestMethod.POST)
    public String getCondDetails(@ModelAttribute SeqCondMapInput seqCondMapInput,Model model, final RedirectAttributes ra) {
    	
    	List<Users> creatorList=userService.findUsersByRole("ROLE_INT");
    	List<Users> gcCreatorList=userService.findUsersByRole("ROLE_ST_HEAD");
    	if(gcCreatorList != null)
    		creatorList.addAll(gcCreatorList); 
    	seqCondMapInput.setCreatorList(creatorList);
    	List<SeqCondMapObj> condMapObjList = new ArrayList<SeqCondMapObj>(); 
    	List<EzValueMapping> condTypeList = masterService.findAllByMapKey("COND_TYPE");
    	
    	 
    	
    	
    //	HashMap<String,List<SequenceDto>> seqDtoHT=new HashMap<String,List<SequenceDto>>(); 
    	if(seqCondMapInput.getSelUser() != null)
    	{
    		List<EzConditionSeqMap> seqList =masterService.findCondSeqMapByUserId(seqCondMapInput.getSelUser());
    		HashMap<String,List<Integer>> chkdSeqMap=new HashMap<String,List<Integer>>(); 
    		if(seqList != null)
    		{
    			for(EzConditionSeqMap seqMap:seqList)
    			{
    				String condType=seqMap.getConditionType();
    				if(chkdSeqMap.containsKey(condType))
    				{
    					List<Integer> condTypeListTmp=chkdSeqMap.get(condType);
    					condTypeListTmp.add(seqMap.getSeqId());
    					chkdSeqMap.put(condType, condTypeListTmp);
    				}
    				else
    				{
    					List<Integer> condTypeListTmp=new ArrayList<Integer>();
    					condTypeListTmp.add(seqMap.getSeqId());
    					chkdSeqMap.put(condType, condTypeListTmp);
    				}
    			}
    		}
    
    		List<EzPriceSeqMaster> seqMasterList=priceReqService.getPriceSeqMaster();
    		for(EzValueMapping condTypeObj:condTypeList)
        	{
    			boolean isSelected=false;
        		SeqCondMapObj seqMapObj=new SeqCondMapObj();
        		List<SequenceDto> seqDtoList = new ArrayList<SequenceDto>();
        		List<Integer> chkdSeqArr=chkdSeqMap.get(condTypeObj.getValue1());
        		
	    		for(EzPriceSeqMaster seqMap:seqMasterList)
				{
	    			SequenceDto seqDto=new SequenceDto();
	    			if(chkdSeqArr != null && chkdSeqArr.contains(seqMap.getId()))
	    			{
	    				isSelected=true;
	    				seqDto.setSelected("true");
	    			}
	    			else
	    			{
	    				seqDto.setSelected("false");
	    			}
	    			seqDto.setSeqId(seqMap.getId());
	    			seqDto.setSeqDesc(seqMap.getDescription());
	    			seqDtoList.add(seqDto);
				}
	    		
	    		seqMapObj.setSeqList(seqDtoList);
	    		seqMapObj.setCondType(condTypeObj.getValue1());
	    		seqMapObj.setCondDesc(condTypeObj.getValue2());
	    		seqMapObj.setSelected(isSelected);
	    		condMapObjList.add(seqMapObj);
        	}
    	}
    	seqCondMapInput.setCondMapObjList(condMapObjList);
    	model.addAttribute("seqCondMapInput", seqCondMapInput);
    	return "master/addSeqCondMap";

    }
    @RequestMapping(value = "/mapseq/submit", method = RequestMethod.POST)
    public String submitCondDetails(@ModelAttribute SeqCondMapInput seqCondMapInput,Model model, final RedirectAttributes ra) {
    	String user=seqCondMapInput.getSelUser();
  
    	
    	List<String> checkedItems=seqCondMapInput.getCheckedItems();
    	List<EzConditionSeqMap> condSeqList=new ArrayList<EzConditionSeqMap>(); 
    	for(String temp:checkedItems)
    	{
    		String [] tempArr=temp.split("##");
    		EzConditionSeqMap seqMap=new EzConditionSeqMap(user, tempArr[1], Integer.parseInt(tempArr[0]));
    		condSeqList.add(seqMap);
    	}
    	masterService.addCondSeqMapping(condSeqList,user);
    	ra.addFlashAttribute("success","Details Saved Successfully");
        return "redirect:/master/mapseq/add";
        
    	
    }
    
    @RequestMapping("/wf/manage")
    public String wfManage(Model model) {
    	ArrayList<String> arrTypes=new ArrayList<String>();
    	arrTypes.add("SALESORG");
    	arrTypes.add("DIVISION");
    	arrTypes.add("DISTCHNL");
    	arrTypes.add("SUBCHNL");
    	arrTypes.add("MAINCHNL");
    	arrTypes.add("COND_TYPE");
    	arrTypes.add("BRAND");
    	WFInput wfInput=new WFInput(); 
    	Map<String, List<EzValueMapping>> masterMap = masterService.getValueMapList(arrTypes);
    	wfInput.setSalesOrg(masterMap.get("SALESORG"));
    	wfInput.setDivision(masterMap.get("DIVISION"));
    	wfInput.setDistChnl(masterMap.get("DISTCHNL"));
    	wfInput.setSubChnl(masterMap.get("SUBCHNL"));
    	wfInput.setMainChnl(masterMap.get("MAINCHNL"));
    	wfInput.setCondTypes(masterMap.get("COND_TYPE"));
    	wfInput.setBrands(masterMap.get("BRAND"));
        model.addAttribute("wfInput", wfInput);
        return "master/manageWF";

    }
    
    @RequestMapping(value = "/wf/getdetails", method = RequestMethod.POST)
    public String wfGetDetails(@ModelAttribute WFInput wfInput,BindingResult bindingResult,Model model, final RedirectAttributes ra) {
    	
    	Integer selWfKey=null;
    	Map<Integer,List<String>> htLevelUser=null;
    	List<EzWorkFlowKey> wfKeyList = wfCustomDto.searchWFKey(wfInput);
    	if(wfKeyList != null && wfKeyList.size() > 0)
    	{
    		EzWorkFlowKey wfKey = wfKeyList.get(0); 
    		selWfKey=wfKey.getWfKey();
    		List<EzWorkFlowMapping> wfMappingList=wfKey.getEzWorkFlowMapping();
    		if(wfMappingList != null)
    		{
    			htLevelUser = wfMappingList.stream().collect(Collectors.groupingBy(EzWorkFlowMapping::getLevel,Collectors.mapping(EzWorkFlowMapping::getUserId, Collectors.toList())));
    		}
    	}
    	
    	ArrayList<String> arrTypes=new ArrayList<String>();
    	arrTypes.add("SALESORG");
    	arrTypes.add("DIVISION");
    	arrTypes.add("DISTCHNL");
    	arrTypes.add("SUBCHNL");
    	arrTypes.add("MAINCHNL"); 
    	arrTypes.add("COND_TYPE");
    	arrTypes.add("BRAND");
    	
    	Map<String, List<EzValueMapping>> masterMap = masterService.getValueMapList(arrTypes);
    	wfInput.setSalesOrg(masterMap.get("SALESORG"));
    	wfInput.setDivision(masterMap.get("DIVISION"));
    	wfInput.setDistChnl(masterMap.get("DISTCHNL"));
    	wfInput.setSubChnl(masterMap.get("SUBCHNL"));
    	wfInput.setMainChnl(masterMap.get("MAINCHNL"));
    	wfInput.setCondTypes(masterMap.get("COND_TYPE"));
    	wfInput.setBrands(masterMap.get("BRAND"));
    	wfInput.setWfKey(selWfKey); 
    	List<Users> creatorList=userService.findUsersByRole("ROLE_INT");
    	List<Users> gcCreatorList=userService.findUsersByRole("ROLE_ST_HEAD");
    	if(gcCreatorList != null)
    		creatorList.addAll(gcCreatorList); 
    	List<Users> approverList=userService.findUsersByRole("ROLE_APR");
//    	List<String> selCreatorList = new ArrayList<String>();
//    	selCreatorList.add("PRCREATE");
//    	
    	List<WFRow> wfRowList = new ArrayList<WFRow>(); 
    	WFRow wfRow=new WFRow();
    	wfRow.setUserList(creatorList);
    	if(htLevelUser != null && htLevelUser.containsKey(1))
    		wfRow.setSelUserList(htLevelUser.get(1));
    	wfRow.setLevel(1);
    	wfRowList.add(wfRow);
    	
    	wfRow=new WFRow();
    	wfRow.setUserList(approverList);
    	if(htLevelUser != null && htLevelUser.containsKey(2))
    		wfRow.setSelUserList(htLevelUser.get(2));
    	wfRow.setLevel(2);
    	wfRowList.add(wfRow);
    	
    	wfRow=new WFRow();
    	wfRow.setUserList(approverList);
    	if(htLevelUser != null && htLevelUser.containsKey(3))
    		wfRow.setSelUserList(htLevelUser.get(3));
    	wfRow.setLevel(3);
    	wfRowList.add(wfRow);
    	
    	wfInput.setWfRowList(wfRowList);
    	
    	model.addAttribute("wfInput", wfInput);
    	return "master/manageWF";
    }
    @RequestMapping(value = "/wf/save", method = RequestMethod.POST)
    public String wfSave(@ModelAttribute WFInput wfInput,BindingResult bindingResult,Model model, final RedirectAttributes ra) {
    	List<WFRow> wfRowList=wfInput.getWfRowList();
    	Integer wfKey=wfInput.getWfKey();
    	if(wfKey == null)
    	{
    		EzWorkFlowKey wfKeyObj = new EzWorkFlowKey();
    		wfKeyObj.setCondType(wfInput.getSelCondTypes());
    		wfKeyObj.setSalesOrg(wfInput.getSelSalesOrg());
    		wfKeyObj.setDistChnl(wfInput.getSelDistChnl());
    		wfKeyObj.setDivision(wfInput.getSelDivision());
    		wfKeyObj.setMainChnl(wfInput.getSelMainChnl());
    		wfKeyObj.setSubChnl(wfInput.getSelSubChnl());
    		wfKeyObj.setBrand(wfInput.getSelBrand());
    		List<EzWorkFlowMapping> ezWorkFlowMapping=new ArrayList<EzWorkFlowMapping>();
    		for(WFRow wfRow:wfRowList)
    		{
    			List<String> userList=wfRow.getSelUserList();
    			for(String user:userList)
        		{
    				if(user == null || "null".equals(user) || "".equals(user))
    					continue;
					EzWorkFlowMapping wfMapObj=new EzWorkFlowMapping();
					wfMapObj.setEzWorkFlowKey(wfKeyObj);
					wfMapObj.setLevel(wfRow.getLevel());
					wfMapObj.setUserId(user);
					log.debug("user::"+user);
					log.debug("level::"+wfRow.getLevel());
					ezWorkFlowMapping.add(wfMapObj);
        		}		
    			
    		}
    		wfKeyObj.setEzWorkFlowMapping(ezWorkFlowMapping);
    		EzWorkFlowKey wfkey= masterService.addWorkflow(wfKeyObj);
    		log.debug(":::::workflowkey:::"+wfkey.getWfKey());
    	}
    	else
    	{
    		masterService.updateWorkflow(wfRowList, wfKey);
    	}
    	ra.addFlashAttribute("success","Workflow Details Saved Successfully");
        return "redirect:/master/wf/manage";
    }
    
	@RequestMapping(value = "/wf/downloadall", method = RequestMethod.GET)
    public StreamingResponseBody getDistDownload(HttpServletResponse response) throws IOException {

        response.setContentType("application/vnd.ms-excel"); 
        response.setHeader("Content-Disposition", "attachment; filename=\"workflow.xls\"");
        String [] distCodeArr={"Workflow Key","Sales Org","Dist Chnl","Main Chnl","Sub Chnl","Division","Condition Type","Brand","Level","User Id","Name"};

        List<Object[]> distMastList= masterService.getWorkflowDetails();
        
        return ezExcelUtil.writeExcel(distCodeArr,distMastList,"workflow"); 
    }
    
	@GetMapping("/listMaterials") 
	public String listMaterials(Model model) {
		
		model.addAttribute("matList", masterService.getAllMaterialList());

		return "master/materialList";
	}
	
//	@GetMapping("/synchMaterials")
//	public String synchMaterials(Model model) {
//
//		Thread newThread = new Thread(() -> {
//			iSAPMasterService.synchMaterials();
//			log.debug("Job Completed");
//			});
//		newThread.start();
//		return "master/synchMaterialsConf";
//	}
//
	@GetMapping("/listMaterialLimits") 
	public String listMaterialLimits(Model model) {
		
		model.addAttribute("matList", masterService.getAllMaterialLimits());

		return "master/materialLimits";
	}
	
	@RequestMapping(value = "/matSamp", method = RequestMethod.GET)
    public StreamingResponseBody getDistSample(HttpServletResponse response) throws IOException {

        //response.setContentType("application/vnd.ms-excel"); 
        //response.setHeader("Content-Disposition", "attachment; filename=\"distributors.xls\"");
		response.setContentType("application/application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"); 
        response.setHeader("Content-Disposition", "attachment; filename=\"materials.xlsx\"");
        //String [] matArr={"Material","Lower","Upper","Level","Distribution Channel","Main Channel","Sub Channel"};
        String [] matArr={"Distribution Channel","Brand","Level","Lower","Upper"};
        return ezExcelUtil.writeExcel(matArr,null,"materials"); 
    }
	
	
	@GetMapping("/materialLimitsUpload") 
	public String materialLimitsUp() {
		
		return "master/materialLimitsUp";
	}
	
	@PostMapping("/matLimitUpload")
	public String uploadMaterial(@RequestParam("file") MultipartFile reapExcelDataFile,RedirectAttributes model) throws IOException {
		*/
/*
		 * List<EzMaterialLimits> matList = new ArrayList<EzMaterialLimits>();
		 * List<Object[]> materialMast= masterService.getAllMaterialList();
		 * Hashtable<String,String> htMatBranch = new Hashtable<String,String>();
		 * for(Object[] objArr:materialMast) {
		 * htMatBranch.put(((String)objArr[0]).trim(),(String)objArr[2]); }
		 * log.debug("htMatBranch::"+htMatBranch); List<Object[]> lisObjArr=
		 * ezExcelUtil.readExcel(reapExcelDataFile.getInputStream(),reapExcelDataFile.
		 * getOriginalFilename()); for(Object[] objArr:lisObjArr) { try { String
		 * material=(String)objArr[0]; material=material.trim();
		 * log.debug("material::"+material); if(htMatBranch.containsKey(material)) {
		 * EzMaterialLimits matMaster = new EzMaterialLimits();
		 * matMaster.setMaterialNo(material);
		 * matMaster.setBrand(htMatBranch.get(material));
		 * matMaster.setLower(Float.parseFloat((String)objArr[1]));
		 * matMaster.setUpper(Float.parseFloat((String)objArr[2]));
		 * matMaster.setLevel(Integer.parseInt((String)objArr[3]));
		 * matMaster.setDistChnl(fillDefault((String)objArr[4]));
		 * matMaster.setMainChnl(fillDefault((String)objArr[5]));
		 * matMaster.setSubChnl(fillDefault((String)objArr[6])); matList.add(matMaster);
		 * } } catch (Exception e) { log.debug("exception::"+e); } }
		 * masterService.updateMaterialLimit(matList);
		 *//*

		List<Object[]> lisObjArr= ezExcelUtil.readExcel(reapExcelDataFile.getInputStream(),reapExcelDataFile.getOriginalFilename());
		List<EzMaterialLimits> matList = new ArrayList<EzMaterialLimits>();
		 for(Object[] objArr:lisObjArr)
		 {
			 	try {
					String material=(String)objArr[0];
					material=material.trim();
					log.debug("material::"+material);
					 	EzMaterialLimits matMaster = new EzMaterialLimits();
					 	matMaster.setDistChnl(fillDefault((String)objArr[0]));
					 	matMaster.setBrand(fillDefault((String)objArr[1]));
					 	matMaster.setLevel(Integer.parseInt((String)objArr[2]));
					 	matMaster.setLower(Float.parseFloat((String)objArr[3]));
					 	matMaster.setUpper(Float.parseFloat((String)objArr[4]));
					 	matList.add(matMaster);
					 	
				} catch (Exception e) {
				log.debug("exception uploading limits::"+e);
				}	
			}
		 masterService.updateMaterialLimit(matList);

		//return "redirect:/master/listMaterialLimits";
			 model.addFlashAttribute("success", "Material Limits Updated Successfully");
			return "redirect:/master/materialLimitsUpload";
	    }

	@RequestMapping(value = "/chainMapSamp", method = RequestMethod.GET)
    public StreamingResponseBody getChainMapSample(HttpServletResponse response) throws IOException {

        //response.setContentType("application/vnd.ms-excel"); 
        //response.setHeader("Content-Disposition", "attachment; filename=\"distributors.xls\"");
		response.setContentType("application/application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"); 
        response.setHeader("Content-Disposition", "attachment; filename=\"Mapping.xlsx\"");
        String [] matArr={"Chain Code","Dist Chnl"};
        return ezExcelUtil.writeExcel(matArr,null,"mapping"); 
    }
	
	@GetMapping("/listChainMapping") 
	public String listChainMapping(Model model) {
		
		model.addAttribute("chainList", masterService.getChainMapList());

		return "master/chainMap";
	}
	
	@PostMapping("/chainMapUpload")
	public String uploadChainMapping(@RequestParam("file") MultipartFile reapExcelDataFile) throws IOException {
		
		List<Object[]> lisObjArr= ezExcelUtil.readExcel(reapExcelDataFile.getInputStream(),reapExcelDataFile.getOriginalFilename());
	
		 masterService.updateChainCodeMap(lisObjArr);
		 return "redirect:/master/listChainMapping";
	    }
	
		private String fillDefault(String str)
		{
			if(str == null || "null".equals(str) || "".equals(str.trim()))
				return "NA";
			else
				return str;
		}
		
		@RequestMapping(value = "/matDiscountsSamp", method = RequestMethod.GET)
	    public StreamingResponseBody getMatDiscountsSample(HttpServletResponse response) throws IOException {

			response.setContentType("application/application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"); 
	        response.setHeader("Content-Disposition", "attachment; filename=\"conditions.xlsx\"");
	        //String [] matArr={"Material","Lower","Upper","Level","Distribution Channel","Main Channel","Sub Channel"};
	        String [] matArr= {"CONDITION_TYPE","BRAND","DIST_CATEGORY","VALUE"};
	        return ezExcelUtil.writeExcel(matArr,null,"conditions"); 
	    }

		@GetMapping("/materialDiscountsUpload") 
		public String materialDiscountsUp() {
			
			return "master/materialDiscountsUp";
		}
		
		@PostMapping("/matDiscountsUpload")
		public String uploadMaterialDiscounts(@RequestParam("file") MultipartFile reapExcelDataFile,RedirectAttributes model) throws IOException {
			
			List<Object[]> lisObjArr= ezExcelUtil.readExcel(reapExcelDataFile.getInputStream(),reapExcelDataFile.getOriginalFilename());
			List<EzConditionValueMap> matList = new ArrayList<EzConditionValueMap>();
			 for(Object[] objArr:lisObjArr)
			 {
				 	try {
						String material=(String)objArr[0];
						material=material.trim();
						log.debug("material::"+material);
						EzConditionValueMap matMaster = new EzConditionValueMap();
						 	matMaster.setConditionType((String)objArr[0]);
						 	matMaster.setBrand((String)objArr[1]);
						 	matMaster.setDistCat((String)objArr[2]);
						 	matMaster.setValue(Double.parseDouble((String)objArr[3]));
						 	matList.add(matMaster);
						 	
					} catch (Exception e) {
					log.debug("exception uploading limits::"+e);
					}	
				}
			 masterService.updateMaterialDiscounts(matList);

			//return "redirect:/master/listMaterialLimits";
				 model.addFlashAttribute("success", "Material Limits Updated Successfully");
				return "redirect:/master/materialDiscountsUpload";
		    }

		@GetMapping("/listMaterialDiscounts") 
		public String listMaterialDiscounts(Model model) {
			
			model.addAttribute("matList", masterService.getAllMaterialDiscounts());

			return "master/materialDiscounts";
		}
		
		
		
		
} 

*/
