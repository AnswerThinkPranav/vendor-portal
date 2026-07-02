
package com.ezc.aragenPR.webapp.service.master;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ezc.aragenPR.webapp.dto.master.PlaceMasterDto;
import com.ezc.aragenPR.webapp.model.master.EzConditionSeqMap;
import com.ezc.aragenPR.webapp.model.master.EzConditionValueMap;
import com.ezc.aragenPR.webapp.model.master.EzPlaceMaster;
import com.ezc.aragenPR.webapp.model.master.EzValueMapping;

public interface IMasterService {

	List<EzPlaceMaster> findAllCities();
	PlaceMasterDto addNewCity(PlaceMasterDto pDto);
	String deleteCity(int id);
	PlaceMasterDto getCityDetails(String city);
	List<EzValueMapping> findAllByMapKey(String mapKey);
	List<EzConditionSeqMap> findCondSeqMapByCondition(String condType);
	List<EzConditionSeqMap> findCondSeqMapByUserId(String userId);
	void addCondSeqMapping(List<EzConditionSeqMap> seqMap,String userId);
	Map<String, List<EzValueMapping>> getValueMapList(List<String> listInput);
	List<EzValueMapping> getChainMapList();
	void updateChainCodeMap(List<Object[]> lisObjArr);
	List<EzValueMapping> getChainMapByCode(String chainCode);
	List<EzConditionValueMap> getAllConditionValueMap();
	void updateMaterialDiscounts(List<EzConditionValueMap> matList);
	List<Object[]> getAllMaterialDiscounts();

}

