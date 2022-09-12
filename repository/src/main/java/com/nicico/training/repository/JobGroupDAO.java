package com.nicico.training.repository;

import com.nicico.training.model.JobGroup;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;

@Repository
public interface JobGroupDAO extends JpaRepository<JobGroup, Long>, JpaSpecificationExecutor<JobGroup> {

    @Modifying
    @Query(value = "update TBL_JOB_GROUP set D_LAST_MODIFIED_DATE_NA = :modificationDate, C_MODIFIED_BY_NA = :userName,N_VERSION = N_VERSION + 1 where ID = :objectId", nativeQuery = true)
    public int updateModifications(Long objectId, Date modificationDate, String userName);


    @Modifying
    @Query(value = "SELECT\n" +
            "    F_JOBGROUP_ID FROM tbl_job_jobgroup\n" +
            "    WHERE\n" +
            "    F_JOB_ID = :id", nativeQuery = true)
    List<Long> getPostGradeGroupsByJobId(Long id);
}
