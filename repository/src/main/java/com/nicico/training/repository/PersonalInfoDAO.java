package com.nicico.training.repository;

import com.nicico.training.model.PersonalInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface PersonalInfoDAO extends JpaRepository<PersonalInfo, Long>, JpaSpecificationExecutor<PersonalInfo> {
}
