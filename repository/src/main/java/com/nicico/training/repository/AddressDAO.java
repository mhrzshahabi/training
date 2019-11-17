package com.nicico.training.repository;

import com.nicico.training.model.Address;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;
import java.util.List;

@Repository
public interface AddressDAO extends JpaRepository<Address, Long>, JpaSpecificationExecutor<Address> {

    @Modifying
    @Query(value = "select * from TBL_ADDRESS where C_POSTAL_CODE = :postalCode", nativeQuery = true)
    @Transactional
    List<Address> findByPostalCode(@Param("postalCode") String postalCode);
}
