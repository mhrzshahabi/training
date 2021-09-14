package com.nicico.training.repository;


import com.nicico.training.model.MobileVerify;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MobileVerifyDAO extends JpaRepository<MobileVerify, Long> {
}
