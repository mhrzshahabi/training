package com.nicico.training.repository;

import com.nicico.training.model.RequestItemProcessDetail;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface RequestItemProcessDetailDAO extends JpaRepository<RequestItemProcessDetail, Long>, JpaSpecificationExecutor<RequestItemProcessDetail> {

    List<RequestItemProcessDetail> findAllByRequestItemId(Long requestItemId);

    Optional<RequestItemProcessDetail> findFirstByRequestItemIdAndExpertNationalCode(Long requestItemId, String expertNationalCode);
}
