/*
ghazanfari_f, 8/29/2019, 10:43 AM
*/
package com.nicico.training.repository;

import com.nicico.training.model.Job;
import com.nicico.training.model.enums.EDeleted;
import com.nicico.training.model.enums.EEnabled;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface JobDAO extends JpaRepository<Job, Long>, JpaSpecificationExecutor<Job> {


    @Query(value = "select j.* from training.tbl_job_new j where j.e_enabled =1 and j.e_deleted = 0")
    List<Job> findAllEnabledNotDeleted();
}
