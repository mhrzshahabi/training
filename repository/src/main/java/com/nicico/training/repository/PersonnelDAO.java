package com.nicico.training.repository;

import com.nicico.training.model.Personnel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PersonnelDAO extends JpaRepository<Personnel, Long>, JpaSpecificationExecutor<Personnel> {

    Optional<Personnel> findOneByPersonnelNo(String personnelNo);
    Optional<Personnel[]> findOneByNationalCode(String nationalCode);

    Optional<Personnel> findOneByPostCode(String postCode);


//    @Query(value = "select * from tbl_personnel   where (tbl_personnel.post_code=:postCode )", nativeQuery = true)
//    List<Personnel> findPersonnelByPostCode(@Param("postCode")  String postCode);


}
