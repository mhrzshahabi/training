package com.nicico.training.repository;

import com.nicico.training.model.SelfDeclaration;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface SelfDeclarationDAO extends JpaRepository<SelfDeclaration,Long> {

    Optional<SelfDeclaration> findByNationalCodeAndMobileNumber(String nationalCode,String mobileNumber);

    Optional<SelfDeclaration> findByMobileNumber(String number);

    List<SelfDeclaration> findAllByNationalCode(String nationalCode);
}
