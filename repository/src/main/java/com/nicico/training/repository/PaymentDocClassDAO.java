package com.nicico.training.repository;

import com.nicico.training.model.PaymentDocClass;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface PaymentDocClassDAO extends JpaRepository<PaymentDocClass, Long>, JpaSpecificationExecutor<PaymentDocClass> {
}
