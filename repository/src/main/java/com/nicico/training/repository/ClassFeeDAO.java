package com.nicico.training.repository;

import com.nicico.training.model.ClassFee;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface ClassFeeDAO extends JpaRepository<ClassFee, Long>, JpaSpecificationExecutor<ClassFee> {

}
