/*
ghazanfari_f, 9/12/2019, 3:00 PM
*/
package com.nicico.training.repository;

import com.nicico.training.model.NeedAssessment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface NeedAssessmentDAO extends JpaRepository<NeedAssessment, Long>, JpaSpecificationExecutor<NeedAssessment> {
}