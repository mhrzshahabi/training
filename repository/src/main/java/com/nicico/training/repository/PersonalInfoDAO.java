package com.nicico.training.repository;

import com.nicico.training.model.PersonalInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;
import java.util.Optional;

@Repository
public interface PersonalInfoDAO extends JpaRepository<PersonalInfo, Long>, JpaSpecificationExecutor<PersonalInfo> {

    @Transactional
    Optional<PersonalInfo> findByNationalCode(@Param("nationalCode") String nationalCode);
}
