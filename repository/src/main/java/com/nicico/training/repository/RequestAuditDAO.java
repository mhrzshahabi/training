package com.nicico.training.repository;

import com.nicico.training.model.RequestAudit;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RequestAuditDAO extends JpaRepository<RequestAudit, Long>,JpaSpecificationExecutor<RequestAudit> {
    @Query(value = "select * from tbl_request_aud  where ID = :requestId ORDER BY rev DESC ", nativeQuery = true)
     List<RequestAudit> getAuditData(long requestId);
}
