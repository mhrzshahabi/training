package com.nicico.training.repository;

import com.nicico.training.model.NeedAssessmentSkillBased;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;


@Repository
public interface NeedAssessmentSkillBasedDAO extends JpaRepository<NeedAssessmentSkillBased, Long>, JpaSpecificationExecutor<NeedAssessmentSkillBased> {

}