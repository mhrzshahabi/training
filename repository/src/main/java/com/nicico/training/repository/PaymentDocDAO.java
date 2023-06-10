package com.nicico.training.repository;

import com.nicico.training.model.PaymentDoc;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface PaymentDocDAO extends JpaRepository<PaymentDoc, Long>, JpaSpecificationExecutor<PaymentDoc> {
}
