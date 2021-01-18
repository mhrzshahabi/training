package com.nicico.training.repository;
/* com.nicico.training.repository
@Author:Lotfy
*/

import com.nicico.training.model.PersonnelRegistered;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PersonnelRegisteredDAO extends JpaRepository<PersonnelRegistered, Long>, JpaSpecificationExecutor<PersonnelRegistered> {


    Optional<PersonnelRegistered> findOneByPersonnelNo(String personnelNo);

    Optional<PersonnelRegistered[]> findOneByNationalCode(String nationalCode);

    PersonnelRegistered[] findAllByNationalCode(String nationalCode);

    List<PersonnelRegistered> findByPersonnelNoInOrPersonnelNo2In(List<String> personnelNos,List<String> personnelNos2);

    PersonnelRegistered findPersonnelRegisteredByPersonnelNo(String personnelNo);

    List<PersonnelRegistered> findAllByNationalCodeOrderByIdDesc(String nationalCode);

    List<PersonnelRegistered> findAllByPersonnelNoOrderByIdDesc(String personnelNo);
}


