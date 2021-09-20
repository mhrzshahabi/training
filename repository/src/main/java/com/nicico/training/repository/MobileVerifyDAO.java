package com.nicico.training.repository;


import com.nicico.training.model.MobileVerify;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface MobileVerifyDAO extends JpaRepository<MobileVerify, Long> {
    Optional<MobileVerify> findByNationalCodeAndMobileNumber(String nationalCode, String mobileNumber);
}
