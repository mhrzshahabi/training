package com.nicico.training.repository;

import com.nicico.training.model.Address;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface AddressDAO extends JpaRepository<Address, Long>, JpaSpecificationExecutor<Address> {
}
