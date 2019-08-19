package com.nicico.training.repository;

import com.nicico.training.model.ContactInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface ContactInfoDAO extends JpaRepository<ContactInfo, Long>, JpaSpecificationExecutor<ContactInfo> {
}
