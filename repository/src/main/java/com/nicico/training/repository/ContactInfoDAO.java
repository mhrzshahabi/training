package com.nicico.training.repository;

import com.nicico.training.model.Address;
import com.nicico.training.model.ContactInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;
import java.util.List;
import java.util.Optional;

@Repository
public interface ContactInfoDAO extends JpaRepository<ContactInfo, Long>, JpaSpecificationExecutor<ContactInfo> {
    @Transactional
    Optional<ContactInfo> findByWorkAddressPostalCode(String postalCode);

    @Query(value = "SELECT ci.* FROM tbl_contact_info ci WHERE ci.c_mobile =:mobile OR ci.c_mdms_mobile =:mobile OR ci.c_hr_mobile =:mobile OR ci.c_mobile2 =:mobile", nativeQuery = true)
    List<ContactInfo> findAllByMobiles(String mobile);

}
