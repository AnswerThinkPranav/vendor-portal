package com.ezc.aragenPR.webapp.repository.rfq;

import java.util.Optional;

import com.ezc.aragenPR.webapp.model.rfq.MatBudgetPrice;
import com.ezc.aragenPR.webapp.model.rfq.MatBudgetPriceId;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MatBudgetPriceRepository extends JpaRepository<MatBudgetPrice, MatBudgetPriceId> {

    Optional<MatBudgetPrice> findByFinYearAndMonthAndPlantAndMaterial(String finYear, String month, String plant, String material);
}
