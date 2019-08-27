package com.nicico.training.repository;

import com.nicico.training.model.PersonalInfo;
import com.nicico.training.model.Teacher;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;
import java.util.List;

@Repository
public interface PersonalInfoDAO extends JpaRepository<PersonalInfo, Long>, JpaSpecificationExecutor<PersonalInfo> {
    @Modifying
    @Query(value = "select * from TBL_PERSONAL_INFO where C_NATIONAL_CODE = :nationalCode",nativeQuery = true)
    @Transactional
    public List<PersonalInfo> findByNationalCode(@Param("nationalCode") String nationalCode);

    @Modifying
    @Query(value = "update TBL_PERSONAL_INFO set" +
            " C_ATTACH_PHOTO = :attachFileName " +
            " WHERE ID= :id" ,nativeQuery = true)
    @Transactional
    public void addAttach(@Param("id") Long id, @Param("attachFileName") String attachFileName);

    @Modifying
    @Query(value = "select * from TBL_PERSONAL_INFO where C_NATIONAL_CODE = :nationalCode and ID != :id",nativeQuery = true)
    @Transactional
    public List<PersonalInfo> findByNationalCode(@Param("id") Long id, @Param("nationalCode") String nationalCode);
}
