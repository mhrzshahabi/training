package com.nicico.training.repository;

import com.nicico.training.model.Address;
import com.nicico.training.model.ContactInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;
import java.util.Optional;

@Repository
public interface ContactInfoDAO extends JpaRepository<ContactInfo, Long>, JpaSpecificationExecutor<ContactInfo> {
    @Transactional
    Optional<ContactInfo> findByWorkAddressPostalCode(String postalCode);
}
