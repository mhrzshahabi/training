package com.nicico.training.repository;

import com.nicico.training.model.Company;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;
import java.util.List;

@Repository
public interface CompanyDAO extends JpaRepository<Company, Long>, JpaSpecificationExecutor<Company> {
    List<Company> findByManagerId(Long managerId);


    @Modifying
    @Transactional
    @Query(value = "UPDATE tbl_company c SET c.f_personal_info_id = :personalId  WHERE c.id = :companyId",nativeQuery = true)
    int updatepersonalId(@Param("companyId") Long companyId, @Param("personalId") Long  personalId);
}
