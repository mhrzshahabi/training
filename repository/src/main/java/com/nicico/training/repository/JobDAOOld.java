package com.nicico.training.repository;

/*
AUTHOR: ghazanfari_f
DATE: 6/8/2019
TIME: 7:43 AM
*/

import com.nicico.training.model.JobOld;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface JobDAOOld extends JpaRepository<JobOld, Long>, JpaSpecificationExecutor<JobOld> {

    @Query(value = "select j.* from training.tbl_job j " +
            " where j.id not in (select jc.f_job_id from training.tbl_job_competence jc where jc.f_competence_id = ?)", nativeQuery = true)
    List<JobOld> findOtherJobsForCompetence(Long competenceId);

    @Query(value = "SELECT tj.* FROM tbl_job tj where Exists(select * from tbl_job_competence tjc where tj.id = tjc.f_job_id and exists(select * from tbl_competence_skill tcs where tjc.f_competence_id= tcs.f_competence_id and tcs.f_skill_id = ?) )", nativeQuery = true)
    List<JobOld> getJobsBySkillId(Long skillId);

}
