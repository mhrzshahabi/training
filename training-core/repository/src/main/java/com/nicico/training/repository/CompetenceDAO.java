package com.nicico.training.repository;

import com.nicico.training.model.Competence;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

/*
AUTHOR: ghazanfari_f
DATE: 6/3/2019
TIME: 12:03 PM
*/
@Repository
public interface CompetenceDAO extends JpaRepository<Competence, Long>, JpaSpecificationExecutor<Competence> {

    @Query(value = "select c.* from training.tbl_competence c " +
            " where c.id not in (select jc.f_competence_id from training.tbl_job_competence jc where jc.f_job_id = ?)", nativeQuery = true)
    List<Competence> findOtherCompetencesForJob(Long jobId);


    @Query(value = "select c.* from training.TBL_COMPETENCE c  where Not EXISTS(select F_COMPETENCE_ID from training.TBL_COMPETENCE_SKILL cs where  cs.F_COMPETENCE_ID=c.ID and cs.F_SKILL_ID = ?)", nativeQuery = true)
    List<Competence> findCompetencesBySkillId(Long skillId);

}
