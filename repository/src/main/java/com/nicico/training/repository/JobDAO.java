/*
ghazanfari_f, 8/29/2019, 10:43 AM
*/
package com.nicico.training.repository;

import com.nicico.training.model.Job;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Date;

@Repository
public interface JobDAO extends JpaRepository<Job, Long>, JpaSpecificationExecutor<Job> {

    @Modifying
    @Query(value = "update TBL_JOB set D_LAST_MODIFIED_DATE_NA = :modificationDate, C_MODIFIED_BY_NA = :userName,N_VERSION = N_VERSION + 1 where ID = :objectId", nativeQuery = true)
    public int updateModifications(Long objectId, Date modificationDate, String userName);
}
