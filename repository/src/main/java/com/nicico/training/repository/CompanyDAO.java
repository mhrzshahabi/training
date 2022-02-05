package com.nicico.training.repository;

import com.nicico.training.model.Company;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CompanyDAO extends JpaRepository<Company, Long>, JpaSpecificationExecutor<Company> {

    List<Company> findByAddressId(long addressId);
}
