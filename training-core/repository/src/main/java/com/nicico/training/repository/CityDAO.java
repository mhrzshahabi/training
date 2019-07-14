package com.nicico.training.repository;

import com.nicico.training.model.City;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface CityDAO extends JpaRepository<City, Long>, JpaSpecificationExecutor<City> {
}
