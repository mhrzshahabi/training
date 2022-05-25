package com.nicico.training.repository;


import com.nicico.training.model.AgreementClassCost;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AgreementClassCostDAO extends JpaRepository<AgreementClassCost, Long>, JpaSpecificationExecutor<AgreementClassCost> {

    List<AgreementClassCost> findAllByAgreement_Id(Long agreementId);
    Optional<AgreementClassCost> findByAgreement_IdAndClassId(Long agreementId, Long classId);
}