package com.nicico.training.repository;

import com.nicico.training.model.RequestItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface RequestItemDAO extends JpaRepository<RequestItem, Long>, JpaSpecificationExecutor<RequestItem> {

    List<RequestItem> findAllByCompetenceReqId(Long id);

    @Query(value = "select ri.id from tbl_request_item ri where ri.f_competence_id=:competenceId", nativeQuery = true)
    List<Long> findAllRequestItemIdsWithCompetenceId(Long competenceId);

}
