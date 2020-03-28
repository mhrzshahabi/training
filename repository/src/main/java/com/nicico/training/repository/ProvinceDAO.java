package com.nicico.training.repository;

import com.nicico.training.model.Province;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface ProvinceDAO extends JpaRepository<Province,Long>, JpaSpecificationExecutor<Province> {

    boolean existsByNameFa(String nameFa);

    boolean existsByNameFaAndIdIsNot(String nameFa, Long id);
}
