package com.nicico.training.repository;

import com.nicico.training.model.WorkGroup;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface WorkGroupDAO extends JpaRepository<WorkGroup, Long>, JpaSpecificationExecutor<WorkGroup> {
    @Query("SELECT p FROM WorkGroup p JOIN FETCH p.userIds WHERE p.id = (:id)")
    public WorkGroup findByIdAndFetchUserIdsEagerly(@Param("id") Long id);
}
