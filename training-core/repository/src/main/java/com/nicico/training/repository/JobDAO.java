package com.nicico.training.repository;

/*
AUTHOR: ghazanfari_f
DATE: 6/8/2019
TIME: 7:43 AM
*/

import com.nicico.training.model.Job;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface JobDAO extends JpaRepository<Job, Long>, JpaSpecificationExecutor<Job> {

    @Query(value = "select j.* from training.tbl_job j " +
            " where j.id not in (select jc.f_job_id from training.tbl_job_competence jc where jc.f_competence_id = ?)", nativeQuery = true)
    List<Job> findOtherJobsForCompetence(Long competenceId);
}
