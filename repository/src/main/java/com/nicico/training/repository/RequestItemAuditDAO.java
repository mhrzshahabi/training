package com.nicico.training.repository;

import com.nicico.training.model.RequestItemAudit;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RequestItemAuditDAO extends JpaRepository<RequestItemAudit, Long>, JpaSpecificationExecutor<RequestItemAudit> {

    @Query(value = "select * from tbl_request_item_aud where ID IN (:ids)", nativeQuery = true)
    List<RequestItemAudit> findAllByIds(Iterable<Long> ids);
}
