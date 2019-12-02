/*
ghazanfari_f, 9/12/2019, 3:00 PM
*/
package com.nicico.training.repository;

import com.nicico.training.model.NeedAssessment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NeedAssessmentDAO extends JpaRepository<NeedAssessment, Long>, JpaSpecificationExecutor<NeedAssessment> {
    @Query(value = "SELECT na.* FROM tbl_need_assessment na where na.f_skill_id=?", nativeQuery = true)
    List<NeedAssessment> getNeedAssessmentsBySkillId(Long skillId);

}