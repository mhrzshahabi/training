package com.nicico.training.repository;
/* com.nicico.training.repository
@Author:Lotfy
*/

import com.nicico.training.model.PersonnelRegistered;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PersonnelRegisteredDAO extends JpaRepository<PersonnelRegistered, Long>, JpaSpecificationExecutor<PersonnelRegistered> {


    Optional<PersonnelRegistered> findOneByPersonnelNo(String personnelNo);

    //    Optional<PersonnelRegistered[]> findOneByNationalCode(String nationalCode);
    Optional<PersonnelRegistered> findOneByNationalCode(String nationalCode);

    PersonnelRegistered[] findAllByNationalCode(String nationalCode);

    List<PersonnelRegistered> findByPersonnelNoInOrPersonnelNo2In(List<String> personnelNos, List<String> personnelNos2);

    PersonnelRegistered findPersonnelRegisteredByPersonnelNo(String personnelNo);

    List<PersonnelRegistered> findAllByNationalCodeOrderByIdDesc(String nationalCode);

    List<PersonnelRegistered> findAllByPersonnelNoOrderByIdDesc(String personnelNo);

    @Query(value = "select * from tbl_personnel_registered where f_contact_info = :id and active = 1 and deleted = 0" , nativeQuery = true)
    Optional<PersonnelRegistered> findByContactInfoId(Long id);

    @Query(value = "select * from tbl_personnel_registered where f_contact_info IN(:ids)" , nativeQuery = true)
    List<PersonnelRegistered> findAllByContactInfoIds(List<Long> ids);

    @Query(value = "update  tbl_personnel_registered set f_contact_info=null where f_contact_info IN(:ids)" , nativeQuery = true)
    List<PersonnelRegistered> setNullToContactInfo(List<Long> ids);
}


