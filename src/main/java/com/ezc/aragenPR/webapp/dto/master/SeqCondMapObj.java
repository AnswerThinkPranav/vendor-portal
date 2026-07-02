package com.ezc.aragenPR.webapp.dto.master;

import java.util.List;

import com.ezc.aragenPR.webapp.model.master.EzValueMapping;

import lombok.Data;
import lombok.NoArgsConstructor;
import com.ezc.aragenPR.webapp.dto.master.SequenceDto;

@Data
@NoArgsConstructor
public class SeqCondMapObj {

	//private List<EzPriceSeqMaster> priceSeqList = new ArrayList<EzPriceSeqMaster>();
	private boolean isSelected;
	private String condType;
	private String condDesc;
	private List<SequenceDto> seqList;
	private List<String> checkedItems;
	
		
	
	
}
