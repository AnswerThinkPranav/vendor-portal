package com.ezc.aragenPR.webapp.repository.vendorreg;

import java.util.List;

import com.ezc.aragenPR.webapp.model.vendorreg.Plant;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PlantRepository extends JpaRepository<Plant, String> {

    List<Plant> findByPlantInOrderByPlantAsc(List<String> plants);

    List<Plant> findAllByOrderByPlantAsc();
}
