package com.ezc.aragenPR.webapp.dto.master;

import java.util.List;

import com.ezc.aragenPR.webapp.model.user.Users;

import lombok.Data;
import lombok.NoArgsConstructor;
import com.ezc.aragenPR.webapp.dto.master.SeqCondMapObj;

@Data
@NoArgsConstructor
public class SeqCondMapInput {

	
	private List<SeqCondMapObj> condMapObjList;
	
	private List<Users> creatorList;
	
	private String selUser;	
	
	private List<String> checkedItems;	
	
}
