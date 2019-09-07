package com.nicico.training.repository;

import com.nicico.training.model.CompetenceOld;
import com.nicico.training.model.CompetenceOld;
import org.springframework.data.domain.Pageable;
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
public interface CompetenceDAOOld extends JpaRepository<CompetenceOld, Long>, JpaSpecificationExecutor<CompetenceOld> {

    @Query(value = "select c.* from training.tbl_competence c " +
            " where c.id not in (select jc.f_competence_id from training.tbl_job_competence jc where jc.f_job_id = ?)", nativeQuery = true)
    List<CompetenceOld> findOtherCompetencesForJob(Long jobId);


    @Query(value = "select c.* from training.TBL_COMPETENCE c  where Not EXISTS(select F_COMPETENCE_ID from training.TBL_COMPETENCE_SKILL cs where  cs.F_COMPETENCE_ID=c.ID and cs.F_SKILL_ID = ?)", nativeQuery = true)
    List<CompetenceOld> getUnAttachedCompetencesBySkillId(Long skillId, Pageable pageable);

    @Query(value = "select count(*) from training.TBL_COMPETENCE c  where Not EXISTS(select F_COMPETENCE_ID from training.TBL_COMPETENCE_SKILL cs where  cs.F_COMPETENCE_ID=c.ID and cs.F_SKILL_ID = ?)", nativeQuery = true)
    Integer getUnAttachedCompetencesCountBySkillId(Long skillId);


    @Query(value = "select * from training.TBL_COMPETENCE  where  exists(select cs.F_SKILL_ID from training.TBL_COMPETENCE_SKILL cs where  EXISTS (select F_SKILL_ID from training.TBL_SKILL_COURSE sc where sc.F_COURSE_ID = ?))",nativeQuery = true)
    List<CompetenceOld> findCompetenceByCourseId(Long id);

}
